#!/bin/sh

# START XTEVE
xteve -port=34400 -config=/config &

# START CRON
crond -f
