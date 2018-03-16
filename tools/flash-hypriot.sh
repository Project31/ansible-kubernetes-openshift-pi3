#!/bin/bash

set -o pipefail

set -eu

run() {
  # Params
  local ssid=$(readopt --ssid)
  local password=$(readopt --password)
  local hostname=$(readopt --hostname)
  local image=$(readopt --image)
  local device=$(readopt --device)

  if [ -z "$ssid" ] || [ -z "$password" ] || [ -z "$hostname" ] || [ -z "$image" ]; then
     echo "Usage: $0 --ssid <wifi ssid> --password <pass> --hostname <name> --image <path to hypriot image>"
     exit 1
  fi

  if [ ! -f "$image" ]; then
     echo "No image $image found"
     exit 1
  fi

  local device_opts=""
  if [ -n "$device" ]; then
     device_opts="--device $device "
  fi
  local userdata=$(mktemp)
  trap "rm -f $userdata" "EXIT"
  wifi_config "$hostname" "$ssid" "$password" "$userdata"

  local bootconfig=$(mktemp)
  trap "rm -f $bootconfig" "EXIT"
  boot_config "$bootconfig"

  cmd="flash ${device_opts}--userdata $userdata --bootconf $bootconfig $image"
  echo $cmd && exec $cmd
}

wifi_config() {
  local hostname=$1
  local ssid=$2
  local password=$3
  local target_file=$4
  cat <<EOT > $target_file
#cloud-config

# Set your hostname here, the manage_etc_hosts will update the hosts file entries as well
hostname: $hostname
manage_etc_hosts: true

# You could modify this for your own user information
users:
  - name: pirate
    gecos: "Hypriot Pirate"
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users,docker,video
    plain_text_passwd: hypriot
    lock_passwd: false
    ssh_pwauth: true
    chpasswd: { expire: false }

package_upgrade: false

# # WiFi connect to HotSpot
# # - use wpa_passphrase SSID PASSWORD to encrypt the psk
write_files:
  - content: |
      allow-hotplug wlan0
      iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
      iface default inet dhcp
    path: /etc/network/interfaces.d/wlan0
  - content: |
      ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
      update_config=1
      network={
      ssid="$ssid"
      psk="$password"
      proto=RSN
      key_mgmt=WPA-PSK
      pairwise=CCMP
      auth_alg=OPEN
      }
    path: /etc/wpa_supplicant/wpa_supplicant.conf

# These commands will be ran once on first boot only
runcmd:
  # Pickup the hostname changes
  - 'systemctl restart avahi-daemon'

  # Activate WiFi interface
  - 'ifup wlan0'

EOT
}

boot_config() {
  local target_file=$1
  cat <<EOT > ${target_file}
hdmi_force_hotplug=1
enable_uart=0
start_x=0
EOT
}

# Read the value of an option.
readopt() {
    filters="$@"
    next=false
    for var in "${ARGS[@]}"; do
        if $next; then
            echo $var
            break;
        fi
        for filter in $filters; do
            if [[ "$var" = ${filter}* ]]; then
                local value="${var//${filter}=/}"
                if [ "$value" != "$var" ]; then
                    echo $value
                    return
                fi
                next=true
            fi
        done
    done
}

ARGS=("$@")
run "$@"
