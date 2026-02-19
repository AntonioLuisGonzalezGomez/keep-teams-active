#!/bin/bash

INTERVAL=240
LOGFILE="$HOME/keep_teams_active.log"
MAX_LINES=1000

# Run caffeine in the background to avoid suspension
caffeine &

touch "$LOGFILE"
echo "$(date '+%F %T') | Script iniciado" >> "$LOGFILE"

while true; do
    WINDOW=$(xdotool search --name "Microsoft Teams" 2>/dev/null | head -n 1)

    if [ -n "$WINDOW" ]; then
        ACTIVE=$(xdotool getactivewindow 2>/dev/null)
        xdotool windowactivate --sync $WINDOW 2>/dev/null

        eval $(xdotool getwindowgeometry --shell $WINDOW 2>/dev/null)
        WIN_X=$X
        WIN_Y=$Y

        CURSOR_X=$((WIN_X + 250))
        CURSOR_Y=$((WIN_Y + 100))

        eval $(xdotool getmouselocation --shell 2>/dev/null)
        ORIG_X=$X
        ORIG_Y=$Y

        xdotool mousemove --sync $CURSOR_X $CURSOR_Y 2>/dev/null
        sleep 0.2
        xdotool click 1

        xdotool mousemove --sync $ORIG_X $ORIG_Y 2>/dev/null

        if [ -n "$ACTIVE" ]; then
            xdotool windowactivate --sync $ACTIVE 2>/dev/null
        fi

        echo "$(date '+%F %T') | Teams detected. Simulated hover over window $WINDOW" >> "$LOGFILE"
    else
        echo "$(date '+%F %T') | Teams window NOT detected" >> "$LOGFILE"
    fi

    LINE_COUNT=$(wc -l < "$LOGFILE")
    if [ "$LINE_COUNT" -gt "$MAX_LINES" ]; then
        tail -n $MAX_LINES "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
    fi

    sleep $INTERVAL
done
