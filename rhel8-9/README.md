# rhel-kickstart

Created this repo for my RHEL Labs. Modified RHEL Installers causes UEFI boot issues.

Instead of placing my kickstart files in the installer or locally, I will just reference this during boot time.

### Instruction on using the online kickstart file
1. Boot from the Original RHEL ISO

* Start the VM and go to the boot menu.

* Highlight "Install Red Hat Enterprise Linux 8.x or 9.x" but don’t press Enter yet.

2. Edit Boot Parameters

* Press e to edit the boot entry.

* Find the append line (where initrd and inst.stage2 are set).

* Add the inst.ks= parameter pointing to your hosted Kickstart file. Copy the raw link of the ks file.

```ini
inst.ks=https://raw.githubusercontent.com/cliffvj/AutomateProvision-RHEL_CentOS/refs/heads/main/rhel8-9/webserver.ks
```
* Press Ctrl + X (or F10) to boot.

3. Installation Proceeds Automatically

* If the Kickstart file is correct and accessible, the installation will proceed without manual input.
