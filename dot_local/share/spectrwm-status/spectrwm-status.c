#define _POSIX_C_SOURCE 200809L

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <linux/nl80211.h>
#include <math.h>
#include <mpd/client.h>
#include <net/if.h>
#include <netlink/attr.h>
#include <netlink/genl/ctrl.h>
#include <netlink/genl/genl.h>
#include <netlink/msg.h>
#include <netlink/netlink.h>
#include <poll.h>
#include <pulse/pulseaudio.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/inotify.h>
#include <sys/time.h>
#include <unistd.h>

#define MPD_RECONNECT_SECONDS 2
#define STATUS_REFRESH_SECONDS 5
#define MUSIC_TITLE_WORD_LIMIT 4

struct music_snapshot {
    char title[1024];
    enum mpd_state state;
};

struct audio_snapshot {
    char sink_name[256];
    char active_port[128];
    char icon[32];
    int volume;
    bool muted;
};

static pthread_mutex_t music_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t wifi_mutex = PTHREAD_MUTEX_INITIALIZER;
static struct music_snapshot music;
static struct audio_snapshot audio = {
    .icon = "",
    .volume = -1,
};
static pa_mainloop *pulse_mainloop;
static pa_context *pulse_context;
static pa_time_event *tick_event;
static pa_io_event *status_io_event;
static char pulse_sink_name[256];
static uint32_t pulse_sink_index = PA_INVALID_INDEX;
static atomic_uint mail_count = ATOMIC_VAR_INIT(0);
static atomic_bool mail_watch_active = ATOMIC_VAR_INIT(false);
static int status_pipe[2] = {-1, -1};
static unsigned long long previous_cpu_total;
static unsigned long long previous_cpu_idle;
static unsigned cpu_usage;
static unsigned ram_usage;
static char brightness[32] = "?";
static char wifi_ssid[128];
static bool wifi_connected;
static volatile sig_atomic_t stop_requested;
static atomic_bool stopping = ATOMIC_VAR_INIT(false);
static char battery[32] = "?";
static char battery_icon[32] = "󰁹";
static unsigned battery_color = 8;
static char battery_state[32];
static bool external_power_connected;
static char temperature[32] = "?";
static unsigned temperature_color = 9;
static size_t utf8_prefix(const char *text, size_t max_characters);
static void copy_string(char *destination, size_t size, const char *source);
static void print_status(void);

static void
notify_status_change(void)
{
    const char notification = 'u';

    if (status_pipe[1] >= 0 &&
        write(status_pipe[1], &notification, sizeof(notification)) < 0 &&
        errno != EAGAIN && errno != EWOULDBLOCK && errno != EINTR)
        perror("spectrwm-status: status notification");
}

static void
copy_title_words(char *destination, size_t size, const char *title)
{
    const char *position = title;
    const char *truncate_at = NULL;
    unsigned words = 0;
    size_t length;

    if (size == 0)
        return;

    while (*position != '\0') {
        while (isspace((unsigned char)*position))
            ++position;
        if (*position == '\0')
            break;
        if (++words > MUSIC_TITLE_WORD_LIMIT) {
            truncate_at = position;
            break;
        }
        while (*position != '\0' && !isspace((unsigned char)*position))
            ++position;
    }

    if (truncate_at == NULL) {
        copy_string(destination, size, title);
        return;
    }

    length = (size_t)(truncate_at - title);
    while (length > 0 && isspace((unsigned char)title[length - 1]))
        --length;
    if (length >= size)
        length = size - 1;
    memcpy(destination, title, length);
    destination[length] = '\0';
    if (length + strlen("…") < size)
        memcpy(destination + length, "…", strlen("…") + 1);
}

static void
handle_signal(int signal_number)
{
    (void)signal_number;
    stop_requested = 1;
}

static void
copy_string(char *destination, size_t size, const char *source)
{
    if (size == 0)
        return;

    if (source == NULL)
        source = "";

    size_t length = strnlen(source, size - 1);
    memcpy(destination, source, length);
    destination[length] = '\0';
}

static void
copy_status_title(char *destination, size_t size, const char *source)
{
    size_t used = 0;

    if (size == 0)
        return;
    if (source == NULL)
        source = "";

    while (*source != '\0' && used + 1 < size) {
        unsigned char character = (unsigned char)*source++;
        destination[used++] =
            character < 0x20 || character == 0x7f ? ' ' : (char)character;
    }
    destination[used] = '\0';
}

static void
update_music(struct mpd_connection *connection)
{
    struct mpd_status *status;
    struct mpd_song *song;
    const char *title = "";
    struct music_snapshot next = {0};

    status = mpd_run_status(connection);
    if (status == NULL) {
        pthread_mutex_lock(&music_mutex);
        memset(&music, 0, sizeof(music));
        pthread_mutex_unlock(&music_mutex);
        notify_status_change();
        return;
    }

    next.state = mpd_status_get_state(status);
    mpd_status_free(status);

    if (next.state == MPD_STATE_PLAY || next.state == MPD_STATE_PAUSE) {
        song = mpd_run_current_song(connection);
        if (song != NULL) {
            title = mpd_song_get_tag(song, MPD_TAG_TITLE, 0);
            copy_status_title(next.title, sizeof(next.title), title);
            mpd_song_free(song);
        }
    }

    pthread_mutex_lock(&music_mutex);
    music = next;
    pthread_mutex_unlock(&music_mutex);
    notify_status_change();
}

static void *
mpd_worker(void *unused)
{
    const enum mpd_idle mask = MPD_IDLE_PLAYER;

    (void)unused;
    while (true) {
        struct mpd_connection *connection;

        connection = mpd_connection_new(NULL, 0, 3000);
        if (connection == NULL) {
            sleep(MPD_RECONNECT_SECONDS);
            continue;
        }

        if (mpd_connection_get_error(connection) != MPD_ERROR_SUCCESS) {
            mpd_connection_free(connection);
            sleep(MPD_RECONNECT_SECONDS);
            continue;
        }

        update_music(connection);
        while (mpd_run_idle_mask(connection, mask) != 0) {
            update_music(connection);
        }

        mpd_connection_free(connection);
        sleep(MPD_RECONNECT_SECONDS);
    }

    return NULL;
}

static void
sink_info_callback(pa_context *context, const pa_sink_info *info, int eol,
    void *userdata)
{
    (void)context;
    (void)userdata;
    if (eol != 0 || info == NULL)
        return;

    pulse_sink_index = info->index;
    copy_string(audio.sink_name, sizeof(audio.sink_name), info->name);
    copy_string(audio.active_port, sizeof(audio.active_port),
        info->active_port == NULL ? "" : info->active_port->name);
    audio.muted = info->mute != 0;
    audio.volume = (int)((pa_cvolume_avg(&info->volume) * 100U +
        PA_VOLUME_NORM / 2U) / PA_VOLUME_NORM);
    copy_string(audio.icon, sizeof(audio.icon), "");
    if (strstr(info->name, "bluez") != NULL ||
        strstr(info->name, "bluetooth") != NULL) {
        copy_string(audio.icon, sizeof(audio.icon), "");
    } else if (strstr(audio.active_port, "headphone") != NULL ||
        strstr(audio.active_port, "headset") != NULL) {
        copy_string(audio.icon, sizeof(audio.icon), "");
    }
    notify_status_change();
}

static void
query_sink_info(pa_context *context, const char *name)
{
    pa_operation *operation;

    if (name == NULL || *name == '\0')
        return;

    operation = pa_context_get_sink_info_by_name(context, name,
        sink_info_callback, NULL);
    if (operation != NULL)
        pa_operation_unref(operation);
}

static void
server_info_callback(pa_context *context, const pa_server_info *info,
    void *userdata)
{
    (void)userdata;
    if (info == NULL)
        return;

    copy_string(pulse_sink_name, sizeof(pulse_sink_name),
        info->default_sink_name);
    query_sink_info(context, pulse_sink_name);
    notify_status_change();
}

static void
query_server_info(pa_context *context)
{
    pa_operation *operation = pa_context_get_server_info(context,
        server_info_callback, NULL);
    if (operation != NULL)
        pa_operation_unref(operation);
}

static void
subscribe_callback(pa_context *context, pa_subscription_event_type_t event,
    uint32_t index, void *userdata)
{
    pa_subscription_event_type_t facility =
        event & PA_SUBSCRIPTION_EVENT_FACILITY_MASK;

    (void)userdata;
    if (facility == PA_SUBSCRIPTION_EVENT_SERVER) {
        query_server_info(context);
    } else if (facility == PA_SUBSCRIPTION_EVENT_SINK &&
        (pulse_sink_index == PA_INVALID_INDEX || index == pulse_sink_index)) {
        query_server_info(context);
    }
}

static void
subscribe_complete(pa_context *context, int success, void *userdata)
{
    (void)userdata;
    if (success)
        query_server_info(context);
}

static void
pulse_state_callback(pa_context *context, void *userdata)
{
    pa_operation *operation;

    (void)userdata;
    switch (pa_context_get_state(context)) {
    case PA_CONTEXT_READY:
        pa_context_set_subscribe_callback(context, subscribe_callback, NULL);
        operation = pa_context_subscribe(context,
            PA_SUBSCRIPTION_MASK_SERVER | PA_SUBSCRIPTION_MASK_SINK,
            subscribe_complete, NULL);
        if (operation != NULL)
            pa_operation_unref(operation);
        break;
    case PA_CONTEXT_FAILED:
    case PA_CONTEXT_TERMINATED:
        pulse_sink_name[0] = '\0';
        pulse_sink_index = PA_INVALID_INDEX;
        break;
    default:
        break;
    }
}

static bool
connect_pulse(void)
{
    if (pulse_context != NULL)
        return true;

    pulse_context = pa_context_new(pa_mainloop_get_api(pulse_mainloop),
        "spectrwm-status");
    if (pulse_context == NULL)
        return false;

    pa_context_set_state_callback(pulse_context, pulse_state_callback, NULL);
    if (pa_context_connect(pulse_context, NULL, PA_CONTEXT_NOFLAGS, NULL) < 0) {
        pa_context_unref(pulse_context);
        pulse_context = NULL;
        return false;
    }

    return true;
}

static unsigned long long
read_cpu_total(unsigned long long *idle)
{
    FILE *file = fopen("/proc/stat", "r");
    unsigned long long user, nice, system, iowait, irq, softirq, steal;
    unsigned long long total;
    char line[256];

    if (file == NULL)
        return 0;

    if (fgets(line, sizeof(line), file) == NULL ||
        sscanf(line, "cpu %llu %llu %llu %llu %llu %llu %llu %llu",
            &user, &nice, &system, idle, &iowait, &irq, &softirq, &steal) != 8) {
        fclose(file);
        return 0;
    }

    fclose(file);
    *idle += iowait;
    total = user + nice + system + *idle + irq + softirq + steal;
    return total;
}

static void
read_cpu_memory(void)
{
    unsigned long long idle = 0;
    unsigned long long total = read_cpu_total(&idle);
    FILE *file;
    unsigned long long memory_total = 0;
    unsigned long long memory_available = 0;
    char line[256];

    if (previous_cpu_total != 0 && total > previous_cpu_total &&
        idle >= previous_cpu_idle) {
        unsigned long long delta_total = total - previous_cpu_total;
        unsigned long long delta_idle = idle - previous_cpu_idle;
        if (delta_idle <= delta_total)
            cpu_usage = (unsigned)(((delta_total - delta_idle) * 100) /
                delta_total);
    }
    previous_cpu_total = total;
    previous_cpu_idle = idle;

    file = fopen("/proc/meminfo", "r");
    if (file == NULL)
        return;

    while (fgets(line, sizeof(line), file) != NULL) {
        unsigned long long value;
        if (sscanf(line, "MemTotal: %llu kB", &value) == 1)
            memory_total = value;
        else if (sscanf(line, "MemAvailable: %llu kB", &value) == 1)
            memory_available = value;
    }
    fclose(file);

    if (memory_total > 0 && memory_available <= memory_total)
        ram_usage = (unsigned)(((memory_total - memory_available) * 100) /
            memory_total);
}

static bool
read_text_file(const char *path, char *buffer, size_t size)
{
    FILE *file = fopen(path, "r");
    bool result;

    if (file == NULL || size == 0)
        return false;

    result = fgets(buffer, (int)size, file) != NULL;
    fclose(file);
    if (result)
        buffer[strcspn(buffer, "\r\n")] = '\0';
    return result;
}

static void
read_hardware(void)
{
    DIR *directory;
    struct dirent *entry;
    char path[PATH_MAX];
    char value[128];
    char selected_zone[PATH_MAX] = "";
    char fallback_zone[PATH_MAX] = "";
    bool battery_found = false;

    strcpy(battery, "?");
    strcpy(battery_icon, "󰁹");
    battery_color = 8;
    battery_state[0] = '\0';
    external_power_connected = false;

    directory = opendir("/sys/class/power_supply");
    if (directory != NULL) {
        while ((entry = readdir(directory)) != NULL) {
            char supply_type[32];

            snprintf(path, sizeof(path), "/sys/class/power_supply/%s/type",
                entry->d_name);
            if (read_text_file(path, supply_type, sizeof(supply_type)) &&
                (strcmp(supply_type, "Mains") == 0 ||
                 strcmp(supply_type, "USB") == 0 ||
                 strcmp(supply_type, "USB_C") == 0)) {
                snprintf(path, sizeof(path),
                    "/sys/class/power_supply/%s/online", entry->d_name);
                if (read_text_file(path, value, sizeof(value)) &&
                    strcmp(value, "1") == 0)
                    external_power_connected = true;
            }

            if (battery_found)
                continue;

            snprintf(path, sizeof(path), "/sys/class/power_supply/%s/type",
                entry->d_name);
            if (!read_text_file(path, value, sizeof(value)) ||
                strcmp(value, "Battery") != 0)
                continue;

            snprintf(path, sizeof(path),
                "/sys/class/power_supply/%s/capacity", entry->d_name);
            if (!read_text_file(path, value, sizeof(value)))
                continue;

            char *end;
            long level = strtol(value, &end, 10);
            if (*value == '\0' || *end != '\0' || level < 0 || level > 100)
                continue;

            snprintf(battery, sizeof(battery), "%ld%%", level);
            snprintf(path, sizeof(path),
                "/sys/class/power_supply/%s/status", entry->d_name);
            read_text_file(path, battery_state, sizeof(battery_state));

            if (level <= 15) {
                strcpy(battery_icon, "󰂃");
            } else if (level <= 35) {
                strcpy(battery_icon, "󰁼");
            } else if (level <= 60) {
                strcpy(battery_icon, "󰂀");
            } else if (level <= 85) {
                strcpy(battery_icon, "󰂂");
            }
            if (level < 30 && strcmp(battery_state, "Charging") != 0)
                battery_color = 1;
            battery_found = true;
        }
        closedir(directory);
    }

    if (strcmp(battery_state, "Charging") == 0)
        battery_color = 3;
    else if (external_power_connected &&
        strcmp(battery_state, "Discharging") != 0) {
        strcpy(battery_icon, "");
        if (strtol(battery, NULL, 10) >= 30)
            battery_color = 3;
    }

    strcpy(temperature, "?");
    temperature_color = 9;
    directory = opendir("/sys/class/thermal");
    if (directory != NULL) {
        while ((entry = readdir(directory)) != NULL) {
            char zone_type[128];
            if (strncmp(entry->d_name, "thermal_zone", 12) != 0)
                continue;
            snprintf(path, sizeof(path), "/sys/class/thermal/%s/type",
                entry->d_name);
            if (!read_text_file(path, zone_type, sizeof(zone_type)))
                continue;
            if (fallback_zone[0] == '\0')
                snprintf(fallback_zone, sizeof(fallback_zone),
                    "/sys/class/thermal/%s", entry->d_name);
            if (strstr(zone_type, "cpu") != NULL ||
                strstr(zone_type, "CPU") != NULL ||
                strstr(zone_type, "pkg") != NULL ||
                strstr(zone_type, "Package") != NULL) {
                snprintf(selected_zone, sizeof(selected_zone),
                    "/sys/class/thermal/%s", entry->d_name);
                break;
            }
        }
        closedir(directory);
    }
    if (selected_zone[0] == '\0')
        copy_string(selected_zone, sizeof(selected_zone), fallback_zone);
    if (selected_zone[0] != '\0') {
        snprintf(path, sizeof(path), "%s/temp", selected_zone);
        if (read_text_file(path, value, sizeof(value))) {
            char *end;
            long raw = strtol(value, &end, 10);
            if (*value != '\0' && *end == '\0' && raw >= 0) {
                snprintf(temperature, sizeof(temperature), "%ld", raw / 1000);
                if (raw / 1000 >= 85)
                    temperature_color = 1;
                else if (raw / 1000 >= 70)
                    temperature_color = 4;
            }
        }
    }
}

static void
read_brightness(void)
{
    const char *base = "/sys/class/backlight/intel_backlight";
    char path[PATH_MAX];
    char value[64];
    char maximum[64];
    char *end;
    long current_value, max_value;

    strcpy(brightness, "?");
    snprintf(path, sizeof(path), "%s/brightness", base);
    if (!read_text_file(path, value, sizeof(value)))
        return;
    snprintf(path, sizeof(path), "%s/max_brightness", base);
    if (!read_text_file(path, maximum, sizeof(maximum)))
        return;

    current_value = strtol(value, &end, 10);
    if (*value == '\0' || *end != '\0')
        return;
    max_value = strtol(maximum, &end, 10);
    if (*maximum == '\0' || *end != '\0' || max_value <= 0)
        return;
    snprintf(brightness, sizeof(brightness), "%ld",
        (current_value * 100 + max_value / 2) / max_value);
}

struct wifi_query {
    unsigned ifindex;
    bool needs_query;
    bool interface_removed;
};

static void
set_wifi_state(bool connected, const char *ssid, size_t ssid_length)
{
    char shortened[sizeof(wifi_ssid)];
    size_t length = 0;

    if (ssid != NULL) {
        if (ssid_length >= sizeof(shortened))
            ssid_length = sizeof(shortened) - 1;
        for (size_t i = 0; i < ssid_length; ++i) {
            unsigned char character = (unsigned char)ssid[i];
            if (character == '\0')
                break;
            shortened[length++] =
                character < 0x20 || character == 0x7f ? '?' : (char)character;
        }
    }
    shortened[length] = '\0';
    length = utf8_prefix(shortened, 16);
    shortened[length] = '\0';

    pthread_mutex_lock(&wifi_mutex);
    wifi_connected = connected && shortened[0] != '\0';
    copy_string(wifi_ssid, sizeof(wifi_ssid),
        wifi_connected ? shortened : "");
    pthread_mutex_unlock(&wifi_mutex);
    notify_status_change();
}

static int wifi_event_callback(struct nl_msg *message, void *userdata);

static int
wifi_query_callback(struct nl_msg *message, void *userdata)
{
    struct wifi_query *query = userdata;
    struct nlattr *attributes[NL80211_ATTR_MAX + 1] = {0};
    struct genlmsghdr *header = nlmsg_data(nlmsg_hdr(message));
    unsigned ifindex = 0;
    const char *ssid = NULL;

    if (genlmsg_parse(nlmsg_hdr(message), 0, attributes,
            NL80211_ATTR_MAX, NULL) < 0)
        return NL_SKIP;

    if (attributes[NL80211_ATTR_IFINDEX] != NULL)
        ifindex = nla_get_u32(attributes[NL80211_ATTR_IFINDEX]);
    if (ifindex != query->ifindex)
        return NL_SKIP;

    if (attributes[NL80211_ATTR_SSID] != NULL)
        ssid = nla_data(attributes[NL80211_ATTR_SSID]);

    if (header->cmd == NL80211_CMD_NEW_INTERFACE ||
        header->cmd == NL80211_CMD_CONNECT ||
        header->cmd == NL80211_CMD_ROAM ||
        header->cmd == NL80211_CMD_GET_INTERFACE) {
        set_wifi_state(ssid != NULL, ssid,
            ssid == NULL ? 0 :
            (size_t)nla_len(attributes[NL80211_ATTR_SSID]));
    }
    return NL_SKIP;
}

static bool
query_wifi_interface(struct nl_sock *socket, int family,
    struct wifi_query *query)
{
    struct nl_msg *message = nlmsg_alloc();
    int result;

    if (message == NULL)
        return false;
    if (genlmsg_put(message, NL_AUTO_PORT, NL_AUTO_SEQ, family, 0,
            0, NL80211_CMD_GET_INTERFACE, 0) == NULL ||
        nla_put_u32(message, NL80211_ATTR_IFINDEX, query->ifindex) < 0) {
        nlmsg_free(message);
        return false;
    }

    nl_socket_modify_cb(socket, NL_CB_VALID, NL_CB_CUSTOM,
        wifi_query_callback, query);
    result = nl_send_auto(socket, message);
    nlmsg_free(message);
    if (result < 0)
        return false;

    result = nl_recvmsgs_default(socket);
    nl_socket_modify_cb(socket, NL_CB_VALID, NL_CB_CUSTOM,
        wifi_event_callback, query);
    return result >= 0;
}

static int
wifi_event_callback(struct nl_msg *message, void *userdata)
{
    struct wifi_query *query = userdata;
    struct nlattr *attributes[NL80211_ATTR_MAX + 1] = {0};
    struct genlmsghdr *header = nlmsg_data(nlmsg_hdr(message));
    unsigned ifindex = 0;
    const char *ssid = NULL;

    if (genlmsg_parse(nlmsg_hdr(message), 0, attributes,
            NL80211_ATTR_MAX, NULL) < 0)
        return NL_SKIP;
    if (attributes[NL80211_ATTR_IFINDEX] != NULL)
        ifindex = nla_get_u32(attributes[NL80211_ATTR_IFINDEX]);
    if (ifindex != query->ifindex)
        return NL_SKIP;
    if (attributes[NL80211_ATTR_SSID] != NULL)
        ssid = nla_data(attributes[NL80211_ATTR_SSID]);

    switch (header->cmd) {
    case NL80211_CMD_CONNECT:
    case NL80211_CMD_ROAM:
        if (ssid != NULL)
            set_wifi_state(true, ssid,
                (size_t)nla_len(attributes[NL80211_ATTR_SSID]));
        else
            query->needs_query = true;
        break;
    case NL80211_CMD_DISCONNECT:
        set_wifi_state(false, NULL, 0);
        break;
    case NL80211_CMD_DEL_INTERFACE:
        set_wifi_state(false, NULL, 0);
        query->interface_removed = true;
        break;
    default:
        break;
    }
    return NL_SKIP;
}

static unsigned
find_wifi_ifindex(void)
{
    DIR *directory = opendir("/sys/class/net");
    struct dirent *entry;
    char path[PATH_MAX];
    unsigned ifindex = 0;

    if (directory == NULL)
        return 0;

    while ((entry = readdir(directory)) != NULL) {
        snprintf(path, sizeof(path), "/sys/class/net/%s/wireless",
            entry->d_name);
        if (access(path, F_OK) == 0) {
            ifindex = if_nametoindex(entry->d_name);
            if (ifindex != 0)
                break;
        }
    }
    closedir(directory);
    return ifindex;
}

static void *
wifi_worker(void *unused)
{
    (void)unused;

    while (!atomic_load_explicit(&stopping, memory_order_relaxed)) {
        struct nl_sock *socket = nl_socket_alloc();
        struct wifi_query query = {0};
        unsigned ifindex = find_wifi_ifindex();
        int family = -1;
        int group = -1;
        int result;

        if (socket == NULL || ifindex == 0) {
            if (socket != NULL)
                nl_socket_free(socket);
            set_wifi_state(false, NULL, 0);
            sleep(2);
            continue;
        }

        query.ifindex = ifindex;
        if (genl_connect(socket) < 0 ||
            (family = genl_ctrl_resolve(socket, "nl80211")) < 0 ||
            (group = genl_ctrl_resolve_grp(socket, "nl80211", "mlme")) < 0 ||
            nl_socket_add_membership(socket, group) < 0) {
            nl_socket_free(socket);
            set_wifi_state(false, NULL, 0);
            sleep(2);
            continue;
        }

        if (!query_wifi_interface(socket, family, &query)) {
            nl_socket_free(socket);
            set_wifi_state(false, NULL, 0);
            sleep(2);
            continue;
        }
        nl_socket_modify_cb(socket, NL_CB_VALID, NL_CB_CUSTOM,
            wifi_event_callback, &query);

        while (!atomic_load_explicit(&stopping, memory_order_relaxed) &&
            !query.interface_removed) {
            result = nl_recvmsgs_default(socket);
            if (result < 0) {
                if (result == -NLE_INTR)
                    continue;
                break;
            }
            if (query.needs_query) {
                query.needs_query = false;
                query_wifi_interface(socket, family, &query);
            }
        }
        nl_socket_free(socket);
        if (!atomic_load_explicit(&stopping, memory_order_relaxed))
            set_wifi_state(false, NULL, 0);
        if (!atomic_load_explicit(&stopping, memory_order_relaxed))
            sleep(2);
    }
    return NULL;
}

static unsigned
count_mail(void)
{
    const char *home = getenv("HOME");
    char path[PATH_MAX];
    char mailbox[PATH_MAX];
    DIR *directory;
    struct dirent *entry;
    unsigned count = 0;

    if (home == NULL)
        return 0;
    if (snprintf(mailbox, sizeof(mailbox),
            "%s/.local/share/email/x1c/INBOX/new", home) >=
        (int)sizeof(mailbox))
        return 0;
    copy_string(path, sizeof(path), mailbox);
    directory = opendir(path);
    if (directory == NULL)
        return 0;

    while ((entry = readdir(directory)) != NULL) {
        struct stat info;
        if (entry->d_name[0] == '.')
            continue;
        if (fstatat(dirfd(directory), entry->d_name, &info, 0) == 0 &&
            S_ISREG(info.st_mode))
            ++count;
    }
    closedir(directory);
    return count;
}

static void *
maildir_worker(void *unused)
{
    const char *home = getenv("HOME");
    char mailbox[PATH_MAX];
    char new_directory[PATH_MAX];
    int descriptor;
    int parent_watch = -1;
    int new_watch = -1;

    (void)unused;
    if (home == NULL ||
        snprintf(mailbox, sizeof(mailbox),
            "%s/.local/share/email/x1c/INBOX", home) >= (int)sizeof(mailbox) ||
        snprintf(new_directory, sizeof(new_directory), "%s/new", mailbox) >=
            (int)sizeof(new_directory)) {
        fprintf(stderr, "spectrwm-status: invalid Maildir path\n");
        return NULL;
    }

    descriptor = inotify_init1(IN_NONBLOCK | IN_CLOEXEC);
    if (descriptor < 0) {
        perror("spectrwm-status: inotify_init1");
        return NULL;
    }

    while (!atomic_load_explicit(&stopping, memory_order_relaxed)) {
        struct pollfd poll_descriptor = {
            .fd = descriptor,
            .events = POLLIN,
        };
        int timeout = parent_watch < 0 ? 30000 : -1;
        int result;

        if (parent_watch < 0) {
            parent_watch = inotify_add_watch(descriptor, mailbox,
                IN_CREATE | IN_MOVED_TO | IN_DELETE_SELF | IN_MOVE_SELF);
            if (parent_watch < 0) {
                if (errno != ENOENT && errno != EACCES)
                    perror("spectrwm-status: watch Maildir");
            } else {
                new_watch = inotify_add_watch(descriptor, new_directory,
                    IN_CREATE | IN_MOVED_TO | IN_DELETE | IN_MOVED_FROM |
                    IN_CLOSE_WRITE | IN_DELETE_SELF | IN_MOVE_SELF);
                if (new_watch < 0 && errno != ENOENT)
                    perror("spectrwm-status: watch Maildir new");
                atomic_store_explicit(&mail_watch_active, new_watch >= 0,
                    memory_order_relaxed);
                atomic_store_explicit(&mail_count, count_mail(),
                    memory_order_relaxed);
                notify_status_change();
            }
        }

        result = poll(&poll_descriptor, 1, timeout);
        if (result < 0) {
            if (errno == EINTR)
                continue;
            perror("spectrwm-status: poll Maildir");
            break;
        }
        if (result == 0)
            continue;
        if ((poll_descriptor.revents & (POLLERR | POLLHUP | POLLNVAL)) != 0) {
            fprintf(stderr, "spectrwm-status: Maildir notification fd failed\n");
            break;
        }

        if ((poll_descriptor.revents & POLLIN) != 0) {
            union {
                struct inotify_event alignment;
                char buffer[4096];
            } events;
            ssize_t length = read(descriptor, events.buffer,
                sizeof(events.buffer));
            bool refresh = false;

            if (length < 0) {
                if (errno == EINTR || errno == EAGAIN)
                    continue;
                perror("spectrwm-status: read Maildir events");
                break;
            }

            for (char *position = events.buffer;
                position < events.buffer + length;) {
                struct inotify_event *event =
                    (struct inotify_event *)position;

                if ((event->mask & IN_Q_OVERFLOW) != 0) {
                    refresh = true;
                } else if (event->wd == parent_watch) {
                    if ((event->mask & (IN_DELETE_SELF | IN_MOVE_SELF |
                            IN_IGNORED)) != 0) {
                        parent_watch = -1;
                        new_watch = -1;
                        atomic_store_explicit(&mail_watch_active, false,
                            memory_order_relaxed);
                        refresh = true;
                    } else if (event->len > 0 &&
                        strcmp(event->name, "new") == 0) {
                        new_watch = inotify_add_watch(descriptor,
                            new_directory,
                            IN_CREATE | IN_MOVED_TO | IN_DELETE |
                            IN_MOVED_FROM | IN_CLOSE_WRITE |
                            IN_DELETE_SELF | IN_MOVE_SELF);
                        if (new_watch < 0 && errno != ENOENT)
                            perror("spectrwm-status: watch Maildir new");
                        atomic_store_explicit(&mail_watch_active,
                            new_watch >= 0, memory_order_relaxed);
                        refresh = true;
                    }
                } else if (event->wd == new_watch) {
                    refresh = true;
                    if ((event->mask & (IN_DELETE_SELF | IN_MOVE_SELF |
                            IN_IGNORED)) != 0) {
                        new_watch = -1;
                        atomic_store_explicit(&mail_watch_active, false,
                            memory_order_relaxed);
                    }
                }
                position += sizeof(*event) + event->len;
            }

            if (refresh) {
                atomic_store_explicit(&mail_count, count_mail(),
                    memory_order_relaxed);
                notify_status_change();
            }
        }
    }

    close(descriptor);
    atomic_store_explicit(&mail_watch_active, false, memory_order_relaxed);
    return NULL;
}

static size_t
utf8_prefix(const char *text, size_t max_characters)
{
    const unsigned char *p = (const unsigned char *)text;
    size_t bytes = 0;
    size_t characters = 0;

    while (p[bytes] != '\0' && characters < max_characters) {
        unsigned char first = p[bytes];
        size_t width = first < 0x80 ? 1 :
            (first & 0xe0) == 0xc0 ? 2 :
            (first & 0xf0) == 0xe0 ? 3 :
            (first & 0xf8) == 0xf0 ? 4 : 1;
        size_t i;
        for (i = 1; i < width && p[bytes + i] != '\0'; ++i) {
        }
        bytes += i;
        ++characters;
    }
    return bytes;
}

static void
escape_markup(const char *source, char *destination, size_t size)
{
    size_t used = 0;

    if (size == 0)
        return;
    for (size_t i = 0; source[i] != '\0' && used + 1 < size; ++i) {
        if (source[i] == '+' && used + 2 < size)
            destination[used++] = '+';
        destination[used++] = source[i];
    }
    destination[used] = '\0';
}

static void
print_status(void)
{
    struct music_snapshot current_music;
    char display_title[sizeof(music.title)];
    char escaped_title[sizeof(music.title) * 2];
    char battery_status[128] = "";
    char temperature_status[128] = "";
    char mail_status[64] = "";
    char music_status[sizeof(music.title) * 2 + 64] = "";
    char wifi_status[512] = "";
    char current_wifi_ssid[sizeof(wifi_ssid)];
    char escaped_wifi_ssid[sizeof(wifi_ssid) * 2];
    char volume[32];
    const char *volume_icon = audio.icon;
    unsigned volume_color = 14;
    bool current_wifi_connected;

    pthread_mutex_lock(&music_mutex);
    current_music = music;
    pthread_mutex_unlock(&music_mutex);
    pthread_mutex_lock(&wifi_mutex);
    current_wifi_connected = wifi_connected;
    copy_string(current_wifi_ssid, sizeof(current_wifi_ssid), wifi_ssid);
    pthread_mutex_unlock(&wifi_mutex);

    copy_title_words(display_title, sizeof(display_title), current_music.title);
    escape_markup(display_title, escaped_title, sizeof(escaped_title));

    if (audio.muted) {
        volume[0] = '\0';
        volume_icon = "󰝟";
        volume_color = 13;
    } else if (audio.volume >= 0) {
        snprintf(volume, sizeof(volume), " %d%%", audio.volume);
    } else {
        strcpy(volume, " ?");
    }

    if (current_music.state == MPD_STATE_PLAY &&
        current_music.title[0] != '\0') {
        snprintf(music_status, sizeof(music_status),
            "  +@fg=6; +@fg=10;%s", escaped_title);
    }

    unsigned current_mail_count =
        atomic_load_explicit(&mail_count, memory_order_relaxed);
    if (current_mail_count > 0)
        snprintf(mail_status, sizeof(mail_status),
            "  +@fg=1; %u+@fg=0;", current_mail_count);

    if (current_wifi_connected)
        escape_markup(current_wifi_ssid, escaped_wifi_ssid,
            sizeof(escaped_wifi_ssid));
    if (current_wifi_connected)
        snprintf(wifi_status, sizeof(wifi_status),
            "  +@fg=2; %s+@fg=0;", escaped_wifi_ssid);

    if (strcmp(battery, "?") != 0) {
        if (strcmp(battery_state, "Charging") == 0) {
            snprintf(battery_status, sizeof(battery_status),
                "  +@fg=%u; %s+@fg=0;", battery_color, battery);
        } else {
            snprintf(battery_status, sizeof(battery_status),
                "  +@fg=%u;%s %s+@fg=0;",
                battery_color, battery_icon, battery);
        }
    }

    if (strcmp(temperature, "?") != 0)
        snprintf(temperature_status, sizeof(temperature_status),
            "  +@fg=%u; %s°C+@fg=0;", temperature_color, temperature);

    printf("%s%s%s  +@fg=%u;%s%s+@fg=0;  +@fg=4; %u%%+@fg=0;"
        "  +@fg=20; %s%%+@fg=0;  +@fg=5; %u%%+@fg=0;%s%s\n",
        mail_status, music_status, wifi_status, volume_color, volume_icon, volume,
        cpu_usage, brightness, ram_usage, battery_status, temperature_status);
    fflush(stdout);
}

static void
status_io_callback(pa_mainloop_api *api, pa_io_event *event, int fd,
    pa_io_event_flags_t flags, void *userdata)
{
    char buffer[256];
    ssize_t bytes;

    (void)api;
    (void)event;
    (void)flags;
    (void)userdata;

    do {
        bytes = read(fd, buffer, sizeof(buffer));
    } while (bytes > 0 || (bytes < 0 && errno == EINTR));

    if (bytes < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
        perror("spectrwm-status: read status notifications");
        return;
    }
    print_status();
}

static void
tick_callback(pa_mainloop_api *api, pa_time_event *event,
    const struct timeval *tv, void *userdata)
{
    struct timeval next;

    (void)event;
    (void)tv;
    (void)userdata;

    if (stop_requested) {
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        api->quit(api, 0);
        return;
    }

    read_cpu_memory();
    read_hardware();
    read_brightness();
    if (!atomic_load_explicit(&mail_watch_active, memory_order_relaxed))
        atomic_store_explicit(&mail_count, count_mail(), memory_order_relaxed);

    if (pulse_context == NULL ||
        pa_context_get_state(pulse_context) == PA_CONTEXT_FAILED ||
        pa_context_get_state(pulse_context) == PA_CONTEXT_TERMINATED) {
        if (pulse_context != NULL) {
            pa_context_set_state_callback(pulse_context, NULL, NULL);
            pa_context_disconnect(pulse_context);
            pa_context_unref(pulse_context);
            pulse_context = NULL;
        }
        connect_pulse();
    }

    print_status();
    gettimeofday(&next, NULL);
    next.tv_sec += STATUS_REFRESH_SECONDS;
    api->time_restart(tick_event, &next);
}

static bool
create_status_pipe(void)
{
    if (pipe(status_pipe) < 0) {
        perror("spectrwm-status: pipe");
        return false;
    }

    for (size_t i = 0; i < 2; ++i) {
        int flags = fcntl(status_pipe[i], F_GETFL);
        int descriptor_flags = fcntl(status_pipe[i], F_GETFD);

        if (flags < 0 || descriptor_flags < 0 ||
            fcntl(status_pipe[i], F_SETFL, flags | O_NONBLOCK) < 0 ||
            fcntl(status_pipe[i], F_SETFD, descriptor_flags | FD_CLOEXEC) < 0) {
            perror("spectrwm-status: configure notification pipe");
            close(status_pipe[0]);
            close(status_pipe[1]);
            status_pipe[0] = -1;
            status_pipe[1] = -1;
            return false;
        }
    }
    return true;
}

int
main(void)
{
    pthread_t mpd_thread, wifi_thread_id, maildir_thread_id;
    struct timeval first_tick;
    struct sigaction action = {0};
    int result;

    action.sa_handler = handle_signal;
    sigemptyset(&action.sa_mask);
    if (sigaction(SIGTERM, &action, NULL) < 0 ||
        sigaction(SIGINT, &action, NULL) < 0) {
        perror("spectrwm-status: sigaction");
        return EXIT_FAILURE;
    }

    if (!create_status_pipe())
        return EXIT_FAILURE;

    if (pthread_create(&mpd_thread, NULL, mpd_worker, NULL) != 0) {
        fprintf(stderr, "spectrwm-status: unable to start MPD listener\n");
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }
    if (pthread_create(&wifi_thread_id, NULL, wifi_worker, NULL) != 0) {
        fprintf(stderr, "spectrwm-status: unable to start Wi-Fi listener\n");
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        pthread_cancel(mpd_thread);
        pthread_join(mpd_thread, NULL);
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }
    if (pthread_create(&maildir_thread_id, NULL, maildir_worker, NULL) != 0) {
        fprintf(stderr, "spectrwm-status: unable to start Maildir listener\n");
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        pthread_cancel(mpd_thread);
        pthread_join(mpd_thread, NULL);
        pthread_cancel(wifi_thread_id);
        pthread_join(wifi_thread_id, NULL);
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }

    pulse_mainloop = pa_mainloop_new();
    if (pulse_mainloop == NULL) {
        fprintf(stderr, "spectrwm-status: unable to create PulseAudio event loop\n");
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        pthread_cancel(mpd_thread);
        pthread_join(mpd_thread, NULL);
        pthread_cancel(wifi_thread_id);
        pthread_join(wifi_thread_id, NULL);
        pthread_cancel(maildir_thread_id);
        pthread_join(maildir_thread_id, NULL);
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }

    gettimeofday(&first_tick, NULL);
    first_tick.tv_sec += STATUS_REFRESH_SECONDS;
    tick_event = pa_mainloop_get_api(pulse_mainloop)->time_new(
        pa_mainloop_get_api(pulse_mainloop), &first_tick, tick_callback, NULL);
    if (tick_event == NULL) {
        fprintf(stderr, "spectrwm-status: unable to create status timer\n");
        pa_mainloop_free(pulse_mainloop);
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        pthread_cancel(mpd_thread);
        pthread_join(mpd_thread, NULL);
        pthread_cancel(wifi_thread_id);
        pthread_join(wifi_thread_id, NULL);
        pthread_cancel(maildir_thread_id);
        pthread_join(maildir_thread_id, NULL);
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }

    status_io_event = pa_mainloop_get_api(pulse_mainloop)->io_new(
        pa_mainloop_get_api(pulse_mainloop), status_pipe[0],
        PA_IO_EVENT_INPUT, status_io_callback, NULL);
    if (status_io_event == NULL) {
        fprintf(stderr, "spectrwm-status: unable to watch status notifications\n");
        pa_mainloop_get_api(pulse_mainloop)->time_free(tick_event);
        pa_mainloop_free(pulse_mainloop);
        atomic_store_explicit(&stopping, true, memory_order_relaxed);
        pthread_cancel(mpd_thread);
        pthread_join(mpd_thread, NULL);
        pthread_cancel(wifi_thread_id);
        pthread_join(wifi_thread_id, NULL);
        pthread_cancel(maildir_thread_id);
        pthread_join(maildir_thread_id, NULL);
        close(status_pipe[0]);
        close(status_pipe[1]);
        return EXIT_FAILURE;
    }

    read_cpu_memory();
    read_hardware();
    read_brightness();
    print_status();
    connect_pulse();
    result = pa_mainloop_run(pulse_mainloop, NULL);

    atomic_store_explicit(&stopping, true, memory_order_relaxed);
    pa_mainloop_get_api(pulse_mainloop)->time_free(tick_event);
    pa_mainloop_get_api(pulse_mainloop)->io_free(status_io_event);
    if (pulse_context != NULL) {
        pa_context_disconnect(pulse_context);
        pa_context_unref(pulse_context);
    }
    pa_mainloop_free(pulse_mainloop);
    pthread_cancel(mpd_thread);
    pthread_join(mpd_thread, NULL);
    pthread_cancel(wifi_thread_id);
    pthread_join(wifi_thread_id, NULL);
    pthread_cancel(maildir_thread_id);
    pthread_join(maildir_thread_id, NULL);
    close(status_pipe[0]);
    close(status_pipe[1]);

    return result < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
}
