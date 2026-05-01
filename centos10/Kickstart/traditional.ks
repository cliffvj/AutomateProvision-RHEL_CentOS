# CentOS 10 Stream Traditional Kickstart
graphical
lang en_US.UTF-8
keyboard us
network --bootproto=dhcp --device=link --activate
rootpw --lock
services --enabled="chronyd"

# System Timezone
timezone Asia/Manila --utc
timesource --ntp-server=pool.ntp.org

# Partitioning
ignoredisk --only-use=sda,vda
clearpart --all --initlabel
autopart

# The OOBE Toggle (Windows-style)
firstboot --enable

%packages
@^graphical-server-environment
gnome-initial-setup
# AD required packages
realmd
sssd
adcli
samba-common-tools
krb5-workstation
%end

reboot