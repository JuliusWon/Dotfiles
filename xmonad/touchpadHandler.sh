--~/.xmonad/touchpadHandler.sh
TOUCHPAD=$(echo `synclient -l | grep TouchpadOff` | grep -o "[0-1]")

if [[ "$TOUCHPAD" == "1" ]]; then
    synclient TouchpadOff=0
    # echo "on"
else
    synclient TouchpadOff=1
    # echo "off"
fi
