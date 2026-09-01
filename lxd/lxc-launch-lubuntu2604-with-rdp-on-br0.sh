#!/bin/bash

# Explanation
# This script creates a rdpsvr for kde as a lxc instance, follows guide: https://wiki.scanframe.com/en/Configuration/Linux/lxc-kde-xrdp

# !!!!!!!!! WAIT:
# TODO: STILL REQUIRES RUNNING VIA CLI TO BYPASS THE GUI PROMPTS FOR SDDM and KDUMP!!!!!!!!!!!!

CONTAINERNAME='ubuntu2604rdp01'
read -p "Press enter to continue to create $CONTAINERNAME which is connected to a [br0] WHICH YOU ALREADY HAVE UP RIGHT? (Ctrl+C to Cancel)"

echo "Rebuilding a fresh Ubuntu2604 container..."
lxc rm -f $CONTAINERNAME
lxc init ubuntu:26.04 $CONTAINERNAME -n br0
lxc start $CONTAINERNAME

echo "Launching bld commands to apt install kde..."
lxc exec $CONTAINERNAME -- bash <<'EOF'
export DEBIAN_FRONTEND=noninteractive
export ACCEPT_EULA=Y
yes | NEEDRESTART_MODE=a apt remove -y needrestart

apt update
# No longer doing: kde-plasma-desktop xrdp ubuntu-desktop kubuntu-desktop xubuntu-desktop joe mc git bash-completion sshfs xterm fuse sshfs cups  ark language-selector-common plasma-workspace-data rdiff-backup telnet cifs-utils hplip nmap snmp kdeconnect ttf-mscorefonts-installer fonts-noto-color-emoji xdg-desktop-portal-kde
DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y NEEDRESTART_MODE=a apt-get --yes install xrdp ssl-cert net-tools fish byobu curl git wget lubuntu-desktop
usermod -aG ssl-cert xrdp         
echo "
# MY WORKAROUND FOR IMPROVING PERFORMANCE OF XRDP (See Scanframe Wiki Online).
tcp_send_buffer_bytes=4194304
tcp_recv_buffer_bytes=4194304
crypt_level=low
" >> /etc/xrdp/xrdp.ini
mkdir --parents /usr/share/accountsservice/interfaces
systemctl enable --now accounts-daemon
sed 's/@include common-auth/\n#MY KEYRING FOR KDE STUFF\nauth optional pam_kwallet5.so\nsession optional pam_kwallet5.so auto_start\n\n@include common-auth/' /etc/pam.d/xrdp-sesman
systemctl restart xrdp

# Manual way to run a cronjob @reboot b/c it might not working in container guest os
## DISABLED: echo '
## DISABLED: # EXAMPLE - This cronjob WILL execute script /root/bin/boot-script.sh when the container Guest OS starts.
## DISABLED: [Unit]
## DISABLED: Description=LXC Boot Script Execution
## DISABLED: After=network.target
## DISABLED: 
## DISABLED: [Service]
## DISABLED: Type=oneshot
## DISABLED: ExecStart=/root/bin/boot-script.sh
## DISABLED: RemainAfterExit=yes
## DISABLED: 
## DISABLED: [User]
## DISABLED: User=root
## DISABLED: 
## DISABLED: [Install]
## DISABLED: WantedBy=multi-user.target
## DISABLED: ' >> /etc/systemd/system/lxc-boot-script.service

fc-cache -f -v
echo 'Package: snapd
Pin: release a=*
Pin-Priority: -10' >> /etc/apt/preferences.d/no-snap

systemctl restart NetworkManager.service
systemctl restart networkd-dispatcher.service
systemctl restart sddm.service
systemctl restart unattended-upgrades.service
systemctl restart xrdp.service

# Need to set password / ensure gui user works
echo "Remote script complete."
EOF

echo "Please set the root passwd of the container now.."
lxc exec $CONTAINERNAME passwd

echo "Listing containers now.."
lxc list

echo "Main script complete. 

1. lxc list to identify the IP to RDP into.
2. Set the password of the login account to RDP in as.
"
