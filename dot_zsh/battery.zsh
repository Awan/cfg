function battery_charge {
    local power_supply_dir=${POWER_SUPPLY_DIR:-/sys/class/power_supply}
    local battery_dir= supply_dir supply_type

    if [[ ${_battery_charge_power_supply_dir:-} != "$power_supply_dir" ||
        ${_battery_charge_lookup_done:-0} != 1 ]]; then
        _battery_charge_power_supply_dir=$power_supply_dir
        _battery_charge_battery_dir=
        for supply_dir in "$power_supply_dir"/*; do
            [[ -r "$supply_dir/type" && -r "$supply_dir/energy_now" &&
                -r "$supply_dir/energy_full" ]] || continue
            supply_type=$(<"$supply_dir/type")
            if [[ "$supply_type" == Battery ]]; then
                _battery_charge_battery_dir=$supply_dir
                break
            fi
        done
        _battery_charge_lookup_done=1
    fi
    battery_dir=${_battery_charge_battery_dir:-}

    if [[ -z "$battery_dir" ]]; then
        psvar[5]=8
        psvar[6]=
        psvar[7]=
        return 1
    fi

    b_now=$(<"$battery_dir/energy_now")
    b_full=$(<"$battery_dir/energy_full")
    b_status=$(<"$battery_dir/status")
    [[ "$b_now" == <-> && "$b_full" == <-> && $b_full -gt 0 ]] || return 1
    charge=$(( (b_now * 10) / b_full ))

    if (( charge > 5 )) || [[ "Charging" == $b_status ]]; then
        psvar[5]=green
    elif (( charge > 2 )) then
        psvar[5]=yellow
    else
        psvar[5]=red
    fi

    psvar[6]=${(l:charge::▸:)}${(l:10-charge::▹:)}

    if [[ "Charging" == $b_status ]]; then
        psvar[7]=" +"
    else
        psvar[7]=
    fi
}
