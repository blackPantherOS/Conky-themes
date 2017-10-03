#!/bin/bash
sleep 30 &
conky -c ~/.conky/conkyrc_time &
conky -c ~/.conky/conkyrc_weather &
conky -c ~/.conky/conkyrc_disk &
exit 0
