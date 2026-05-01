# RHEL 8/9 Traditional Kickstart
# Designed for consistency with CentOS 10 setup
graphical
lang en_US.UTF-8
keyboard us
network --bootproto=dhcp --device=link --activate
rootpw --lock
services --enabled="chronyd"

# System Timezone (Uses legacy RHEL 8/9 flags)
timezone Asia/Manila --utc

# Partitioning
ignoredisk --only-use=sda,vda
clearpart --all --initlabel
autopart

# The OOBE Toggle (Windows-style)
# Note: In RHEL 8/9 this enables the 'initial-setup' utility
firstboot --enable

%packages
@^graphical-server-environment
initial-setup            # Legacy OOBE tool for RHEL 8/9
initial-setup-gui        # Required for graphical OOBE
# AD required packages
realmd
sssd
adcli
samba-common-tools
krb5-workstation
%end

%post
# Pre-configuring the OOBE to be graphical
systemctl set-default graphical.target
%end

reboot