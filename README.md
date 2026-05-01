# 🚀 RHEL & CentOS Automated Provisioning

![Build Status](https://img.shields.io/badge/Build-Status-success)
![OS Support](https://shields.io/badge/OS-Support-blue)
![Method](https://shields.io/badge/Method_-orange)
![MIT](https://img.shields.io/badge/license-MIT-black)



A professional suite for automated deployment of Red Hat-based systems. This repository demonstrates how to bridge the gap between legacy infrastructure and modern DevSecOps practices.

## 📂 Project Architecture

*   **/rhel8_9**: Production-ready Kickstart files for stable enterprise workloads.
*   **/centos10**: The cutting edge. Includes a Windows-style graphical OOBE setup and the new **BootC** immutable workflow.
*   **/.github**: Automated CI/CD pipelines that build your OS installers as you code.

## 🏁 Getting Started

### 1. Traditional Deployment
Use the `*.ks` files located in the `rhel8-9` and `centos10\Kickstart` folders to automate your PXE or ISO-based installations. These are pre-configured with:
*   **Active Directory Integration** (`realmd`, `sssd`)
*   **Standard LVM Partitioning**
*   **Locked Root** for enhanced security.

### 2. Modern BootC Deployment (CentOS 10)
Build your OS as a container, push to Docker Hub, and generate a bootable ISO:
```powershell
# Build the blueprint
podman build -t yourdockerhub/centos10-oobe:latest ./centos10

# Push for cloud-native updates
podman push yourdockerhub/centos10-oobe:latest

# Generate the ISO via the automated builder
# (See centos10/README.md for specific volume mount commands)
```

## 📈 Strategic Insights
Not sure which version to use? Check our **[Strategy & Comparison Guide](./STRATEGY_GUIDE.md)** for a deep dive into Immutable vs. Persistent infrastructure.

---
**Author:** [Clifford Juan/cliffvj]  
**Objective:** To provide a robust, "set-and-forget" installation framework for enterprise Linux environments.
