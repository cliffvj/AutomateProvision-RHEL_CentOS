# Basic Configuration
lang en_US
keyboard --xlayouts='us'
timezone Asia/Manila --utc
rootpw $2b$10$HrK3WaS0Eqaja6AyytZ9Vum5sX.1twMSoRW1S4K.ZpcSn2ShABE5. --iscrypted
reboot --eject
# Installation mode
text

cdrom
eula --agreed
# Partition
bootloader --append="rhgb quiet crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
zerombr
clearpart --all --initlabel
autopart

# Network
network --bootproto=dhcp
firstboot --disable

# Security
selinux --enforcing
firewall --enabled --http --ftp --ssh

%addon com_redhat_oscap
content-type = scap-security-guide
profile = xccdf_org.ssgproject.content_profile_pci-dss
%end

%packages
@^minimal-environment
# Package Groups
#@web-server
#@ftp-server
#@file-server
%end
