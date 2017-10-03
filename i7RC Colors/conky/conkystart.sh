#!/bin/bash
sleep 30 &
conky -c ~/.conky/time &
conky -c ~/.conky/date &
conky -c ~/.conky/disk &
conky -c ~/.conky/weatherg &
exit 0
