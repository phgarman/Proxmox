#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y unzip
msg_ok "Installed Dependencies"

msg_info "Updating Python3"
$STD apt-get install -y \
  python3 \
  python3-dev \
  python3-pip
$STD apt-get install -y python3-setuptools
msg_ok "Updated Python3"

msg_info "Installing NZBHydra"
$STD unzip <(curl -fsSL https://github.com/theotherp/nzbhydra2/releases/download/v6.0.0/nzbhydra2-6.0.0-amd64-linux.zip) -d /opt/nzbhydra2
msg_ok "Installed NZBHydra2"

msg_info "Creating Service"
service_path="/etc/systemd/system/nzbhydra.service"
echo "[Unit]
Description=NZBHydra2 Daemon
Documentation=https://github.com/theotherp/nzbhydra2
After=network.target
[Service]
User=root
Type=simple
# Set to the folder where you extracted the ZIP
WorkingDirectory=/opt/nzbhydra2
# NZBHydra stores its data in a "data" subfolder of its installation path
# To change that set the --datafolder parameter:
--datafolder /var/local/lib/nzbhydra
ExecStart=/opt/nzbhydra2/nzbhydra2 --nobrowser
Restart=always
[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable --now -q nzbhydra.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
