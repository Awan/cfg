function battery_charge {
    b_now=$(< /sys/class/power_supply/BAT0/energy_now)
    b_full=$(< /sys/class/power_supply/BAT0/energy_full)
    b_status=$(< /sys/class/power_supply/BAT0/status)
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
