# CentOS 10 BootC with Windows-style OOBE

This project documents how to create a bootable CentOS 10 Stream ISO using `bootc` (bootable containers). The resulting image features a graphical Out-of-Box Experience (OOBE) setup similar to Windows, built entirely on a Windows 11 machine.

---

## 🌟 Key Features
* Windows-style OOBE: Boots directly into a graphical setup wizard for user creation and timezone settings.
* Active Directory Ready: Pre-installed with realmd, sssd, and samba-common-tools for AD integration.
* Immutable Core: Built on the bootc model for high reliability and easy rollbacks.
    - ✅ What stays (Persistent)
        - User Accounts: The username and password you created.
        - Root Password: The password you set during the first boot.
        - Network Settings: Wi-Fi or Ethernet configurations.
        - Home Folders: Anything in /home/user/ (your documents, downloads, etc.).
    - ❌ What goes (Ephemeral)
        - These are "installed" into the system's "read-only brain." When you install package temporarily using [--transient] flag,New Software: httpd, iperf3, etc.
        - System Binaries: Anything added to /usr/bin or /usr/lib.
    - ❓ Changes Made to    
* Automated Builds: GitHub Action workflow included to build the ISO on every push.

## 🛠 Phase 1: Windows 11 Environment Setup

### 1. Install Podman Desktop
Download and install [Podman Desktop](https://podman-desktop.io).

### 2. Configure WSL2 Resources
Open PowerShell and create/edit the global WSL config to ensure enough RAM for the build:
```powershell
notepad.exe $HOME/.wslconfig
```
Add these lines:
```text
[wsl2]
memory=6GB
```
Restart WSL to apply:
```powershell
wsl --shutdown
```

### 3. Initialize Podman in Rootful Mode
Open PowerShell and run:
```powershell
podman machine rm --force
podman machine init --rootful
podman machine start
```

---

## 🏗 Phase 2: Build & Push the Image

### 1. Build the OS Container
Navigate to your project folder and build the local image:
```powershell
podman build -t localhost/centos10-oobe:latest .
```

### 2. Push to Docker Hub
Upload the image to your registry (replace `yourusername` with your Docker ID):
```powershell
podman login docker.io
podman tag localhost/centos10-oobe:latest docker.io/yourusername/centos10-oobe:latest
podman push docker.io/yourusername/centos10-oobe:latest
```

---

## 💿 Phase 3: Generate the Installation ISO

Run the `bootc-image-builder`. Note the specific volume mount required for Windows/WSL2:

```powershell
podman run --rm --privileged `
  -v C:/Users/pcuser/centos10-build:/output:z `
  -v /var/lib/containers/storage:/var/lib/containers/storage `
  quay.io/centos-bootc/bootc-image-builder:latest `
  --type anaconda-iso `
  --config /output/config.toml `
  localhost/centos10-oobe:latest
```
*Your `install.iso` will appear in the `anaconda-iso` or `bootiso` subfolder.*

---

## 🖥 Phase 4: Hyper-V Deployment Settings

To boot correctly, configure your Hyper-V VM with these settings:

1. **Generation:** Select **Generation 2**.
2. **Security:** Go to Settings > Security and **Uncheck "Enable Secure Boot"**.
3. **Memory:** Minimum **4096 MB** (4GB).
4. **Processor:** Minimum **2 Virtual Processors**.
5. **Boot:** Connect the `install.iso` and start the VM. Follow the graphical OOBE wizard.

---

## 🔄 Phase 5: Updating the System

Because BootC is immutable, do not use `dnf install` inside the VM. Instead:

1. Update the **Containerfile** on Windows.
2. Re-run Phase 2 (Build & Push) with a new tag (e.g., `:v2`).
3. Inside the Hyper-V VM, apply the update:
```bash
sudo bootc switch docker.io/yourusername/centos10-oobe:v2
```
4. Reboot to apply changes permanently.

## 🤖 GitHub Action Workflow
Create a file at .github/workflows/build.yml to automate the build. Ensure you add **DOCKER_USERNAME** and **DOCKER_PASSWORD** to your GitHub Repo Secrets.
```yaml
name: Build CentOS 10 BootC ISO
on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and Push Container
        run: |
          podman build -t docker.io/${{ secrets.DOCKER_USERNAME }}/centos10-oobe:latest .
          podman push docker.io/${{ secrets.DOCKER_USERNAME }}/centos10-oobe:latest

      - name: Build ISO
        id: build-iso
        uses: osbuild/bootc-image-builder-action@v1
        with:
          image: docker.io/${{ secrets.DOCKER_USERNAME }}/centos10-oobe:latest
          config-file: ./config.toml
          types: anaconda-iso

      - name: Upload ISO Artifact
        uses: actions/upload-artifact@v4
        with:
          name: centos10-bootiso
          path: ${{ steps.build-iso.outputs.output-directory }}/bootiso/install.iso
```