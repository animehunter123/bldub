#!/bin/bash

# Explanation
# This script creates a rdpsvr for kde as a lxc instance, follows guide: [https://wiki.scanframe.com/en/Configuration/Linux/lxc-kde-xrdp](https://wiki.scanframe.com/en/Configuration/Linux/lxc-kde-xrdp)

# !!!!!!!!! WAIT:
# TODO: STILL REQUIRES RUNNING VIA CLI TO BYPASS THE GUI PROMPTS FOR SDDM and KDUMP!!!!!!!!!!!!

CONTAINERNAME='rdp01'
echo "BUILDING A LXC+RDP CONTAINER. Note: Arch might not work, so just paste the code INSIDE AFTER A REBOOT. 
Ok... 
"
read -p "Press enter to continue to create $CONTAINERNAME which is connected to a [br0] WHICH YOU ALREADY HAVE UP RIGHT? (Ctrl+C to Cancel)"

echo "Rebuilding a fresh Ubuntu2604 container named: [rdp01] and dns HARDCODED to: [1.1.1.1]..."
lxc rm -f "$CONTAINERNAME"
lxc init ubuntu:26.04 "$CONTAINERNAME"
lxc start "$CONTAINERNAME"

# Wait for DHCP to give the container an IPv4 address.
echo "Waiting for $CONTAINERNAME to receive an IPv4 address..."
IP=""
for i in $(seq 1 30); do
    IP="$(lxc list "$CONTAINERNAME" -c4 --format csv | cut -d' ' -f1)"
    if [ -n "$IP" ]; then
        echo "Got IPv4 address: $IP"
        break
    fi
    sleep 2
done

if [ -z "$IP" ]; then
    echo "ERROR: $CONTAINERNAME did not receive an IPv4 address."
    lxc exec "$CONTAINERNAME" -- bash -c '
        ip -br addr
        ip route
        networkctl status
        cat /run/systemd/network/10-netplan-eth0.network 2>/dev/null || true
        journalctl -u systemd-networkd -u systemd-resolved --no-pager -n 100
    '
    exit 1
fi

# Force DHCP on eth0 and set public DNS.
lxc exec "$CONTAINERNAME" -- bash -c '
cat >/etc/netplan/99-lxc-dhcp.yaml <<NETPLAN
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      optional: false
NETPLAN

netplan apply

mkdir -p /etc/systemd/resolved.conf.d
cat >/etc/systemd/resolved.conf.d/dns.conf <<RESOLVED
[Resolve]
DNS=1.1.1.1
Domains=~.
RESOLVED

systemctl restart systemd-resolved
resolvectl flush-caches
'

# Wait specifically for DNS.
echo "Waiting for DNS..."
DNS_OK=0
for i in $(seq 1 30); do
    if lxc exec "$CONTAINERNAME" -- getent hosts archive.ubuntu.com >/dev/null 2>&1; then
        DNS_OK=1
        echo "DNS is working."
        break
    fi
    sleep 2
done

if [ "$DNS_OK" -ne 1 ]; then
    echo "ERROR: DNS is still not working."
    lxc exec "$CONTAINERNAME" -- bash -c '
        ip -br addr
        ip route
        resolvectl status
        cat /etc/resolv.conf
        journalctl -u systemd-networkd -u systemd-resolved --no-pager -n 100
    '
    exit 1
fi

echo "Launching bld commands to apt install kde..."
lxc exec "$CONTAINERNAME" -- bash <<'EOF'
set -euo pipefail

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

echo "Remote script complete."
EOF

echo "Please set the root passwd of the container now.."
lxc exec "$CONTAINERNAME" -- bash -c 'passwd'

echo "Listing containers now.."
lxc list

echo "Main script complete. 

1. lxc list to identify the IP to RDP into.
2. Set the password of the login account to RDP in as.
"