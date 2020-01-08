#!/bin/sh

toggle_flag() {
    id=$(bspc query -N -n "focused")
    if [ -n "$id" ]; then
        if [ $(xprop -id "$id" | grep "_SCRATCH_ORDER" | wc -l) -gt 0 ]; then
            xprop -id $id -remove _SCRATCH_ORDER
            xprop -id $id -remove _SCRATCH_VISIBILITY
        else
            xprop -id $id -f _SCRATCH_ORDER 32ii -set _SCRATCH_ORDER $(date +%s,%N)
            xprop -id $id -f _SCRATCH_VISIBILITY 8i -set _SCRATCH_VISIBILITY 0
            xdotool windowunmap $id
        fi
    fi
}

switch_app() {
    id=$(bspc query -N -n "focused")
    if [ $(xprop -id "$id" | grep "_SCRATCH_VISIBILITY(INTEGER) = 1" | wc -l) -gt 0 ]; then
        xprop -id $id -f _SCRATCH_VISIBILITY 8i -set _SCRATCH_VISIBILITY 0
        xdotool windowunmap $id
    fi

    sid=$(
        id=$(bspc query -N -n "focused");
        for w in $(xwininfo -root -children | grep -e "^\s*0x[0-9a-f]\+" -o); do
            if [ "$w" != "$id" ]; then
                t=$(xprop -id $w _SCRATCH_ORDER | grep ' = \(.*\)')
                if [ -n "$t" ]; then
                    echo $t $w
                fi
            fi
        done | sort -n | head -n1 | cut -d" " -f 5
    );

    if [ -n "$sid" ] && [ "$(printf "%04d" $sid)" != "$(printf "%04d" $id)" ]; then
    echo "$sid" != "$id"
        xprop -id $sid -f _SCRATCH_ORDER 32ii -set _SCRATCH_ORDER $(date +%s,%N)
        xprop -id $sid -f _SCRATCH_VISIBILITY 8i -set _SCRATCH_VISIBILITY 1
        xdotool windowmap $sid
        bspc node -f $sid
    fi
}


op="$1"
if [ "$op" = "toggle-flag" ]; then
    toggle_flag
elif [ "$op" = "switch-app" ]; then
    switch_app
fi
