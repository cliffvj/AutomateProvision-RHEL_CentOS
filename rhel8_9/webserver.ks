# Basic Configuration
lang en_US
keyboard us
timezone Asia/Manila --utc
rootpw $2b$10$bgxiZJnHJX4UrOhFvGzThukiF0Rb.BbXliqZ3ohPlo7ULsYBCtTiO --iscrypted
reboot --eject

cdrom
eula --agreed
# Partition
bootloader --append="rhgb quiet crashkernel=auto"
zerombr
clearpart --all --initlabel
autopart

# Network
network --bootproto=dhcp
firstboot --disable

# Security
selinux --enforcing
firewall --enabled --http --ftp --ssh

%addon org_fedora_oscap
content-type = scap-security-guide
profile = xccdf_org.ssgproject.content_profile_pci-dss
%end

%packages
@^minimal-environment
# Package Groups
@web-server
#@file-server
#@ftp-server
%end
