#!/bin/sh
sed "s|\${SERVER_NAME}|${SERVER_NAME}|g" /etc/prometheus/prometheus.yml > /tmp/prometheus.yml
exec /bin/prometheus \
  --config.file=/tmp/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles
