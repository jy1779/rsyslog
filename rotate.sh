#!/bin/sh
docker exec rsyslog logrotate -f /etc/logrotate.conf
