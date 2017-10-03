#!/bin/bash
sleep 30 &
conky -c ~/.conky/time &
conky -c ~/.conky/weather_forecast &
exit 0
