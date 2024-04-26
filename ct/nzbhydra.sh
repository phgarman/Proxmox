#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   _____ ___    ____              __        __
  / ___//   |  / __ )____  ____  / /_  ____/ /
  \__ \/ /| | / __  / __ \/_  / / __ \/ __  / 
 ___/ / ___ |/ /_/ / / / / / /_/ /_/ / /_/ /  
/____/_/  |_/_____/_/ /_/ /___/_.___/\__,_/   
                                              
EOF
}
header_info
echo -e "Loading..."
APP="nzbhydra"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/nzbhydra ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop nzbhydra.service
RELEASE=$(curl -s https://api.github.com/repos/theotherp/nzbhydra2/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
unzip <(curl -fsSL https://github.com/theotherp/nzbhydra2/releases/download/v6.0.0/nzbhydra2-6.0.0-amd64-linux.zip) -d /opt/nzbhydra2 &>/dev/null
\cp -r nzbhydra2-6.0.0-amd64-linux/* /opt/nzbhydra &>/dev/null
rm -rf nzbhydra2-6.0.0-amd64-linux
cd /opt/sabnzbd
systemctl start nzbhydra.service
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:5075${CL} \n"
