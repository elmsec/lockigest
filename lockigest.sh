#!/bin/bash

# Configuration
program_name="Lockigest"
wait_time=120  # It must be bigger than the $countdown
countdown=5

# MOUSE LOCATION VARS
X=0
Y=0

# PREV MOUSE LOCATION VARS
PML_X=0
PML_Y=0

# STATUS
counter=0
protection=0


# FUNTIONS
installed() {
    command -v xdotool >/dev/null 2>&1 || {
        echo >&2 "$1 required. Please install it first.";
        exit 1;
    }
}
installed "xdotool"

get_cursor_location() {
    eval $(xdotool getmouselocation -s);
}

toggle_protection() {
    protection=$1
    if [ $1 -eq 1 ]; then
        notify "Protection mode was activated." 20000 "security-high"
        printf "\t Protection mode was activated.\n"
    else
        notify "Protection mode was deactivated." 20000 "security-low"
        printf "\t Protection mode was deactivated.\n"
    fi
}
notify() {
    notify-send "$program_name" "$1" -t ${2:-2000} --icon="${3:-security-high}"
}

# START
while :; do
    sleep 1
    get_cursor_location

    if (( $X != $PML_X || $Y != $PML_Y )); then
        # update "previous mouse locations"
        PML_X=$X
        PML_Y=$Y

        counter=0 # initialize counter again
        if [ $protection -eq 1 ]; then
            while [ $counter -ne $countdown ]; do
                ((counter++))
                get_cursor_location
                printf  "(%s/%s)\t Move your cursor to the specified area. \n" \
                        "$counter" "$countdown"

                remaining=$(expr $countdown + 1 - $counter)

                # if "remaining" is an odd number
                if [ `expr $remaining % 2` -ne 0 ]; then
                    # inform about upcoming screen lock
                    notify "Your screen is getting locked in $remaining second(s)."
                fi

                # the trigget to deactivate the protection mode
                # if mouse's y point is equal to zero (so it's on upper top)
                if [ $Y -eq 0 ]; then
                    toggle_protection 0
                    break
                fi
                sleep 1
            done

            # if the protection is active,
            if [ $protection -eq 1 ]; then
                printf "\t\t The device was locked.\n"
                toggle_protection 0 # disable the protection
                xdg-screensaver lock # lock the screen. alternative: "xdotool key Ctrl+alt+l"
            fi
        fi
        # echo $X - $Y # debug
        printf "\t The location of the cursor was changed.\n"
    else
        ((counter++)) # increase counter
        printf "(%s/%s)\t The cursor is inactive. X: $X Y: $Y\n" \
             "$counter" "$wait_time"

        if [ $counter -ge $wait_time ] && [ $protection -eq 0 ]; then
            toggle_protection 1
        fi
    fi
done
