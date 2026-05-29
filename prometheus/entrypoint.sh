#!/bin/sh
set -e

CONFIG="/etc/prometheus/config.yml"

# Extraire server_name depuis config.yml
SERVER_NAME=$(awk '/^server_name:/{gsub(/["\x27]/, "", $2); print $2; exit}' "$CONFIG")
: "${SERVER_NAME:=unknown-server}"

# Substituer ${SERVER_NAME} dans prometheus.yml
sed "s|\${SERVER_NAME}|${SERVER_NAME}|g" /etc/prometheus/prometheus.yml > /tmp/prometheus.yml

# Générer le fichier de cibles Blackbox au format file_sd_configs
TARGETS=$(awk '
  /^blackbox_targets:/{in_t=1; next}
  in_t && /^  - /{sub(/^  - /, ""); sub(/ *#.*$/, ""); if($0 != "") print $0}
  in_t && /^[^ ]/{in_t=0}
' "$CONFIG")

if [ -z "$TARGETS" ]; then
  printf '- targets: []\n' > /tmp/blackbox_targets.yml
else
  printf '- targets:\n' > /tmp/blackbox_targets.yml
  echo "$TARGETS" | while IFS= read -r target; do
    printf '    - %s\n' "$target" >> /tmp/blackbox_targets.yml
  done
fi

exec /bin/prometheus \
  --config.file=/tmp/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles
