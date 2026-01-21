# Fedora 43 Ultimate Post-Install Suite 🚀

A modular, idempotent automation toolkit designed to transform a fresh Fedora 43 Workstation installation into a high-performance development powerhouse. Optimized for **NVIDIA/CUDA development**, **Zsh performance**, and **modern UI aesthetics**.

---

## 🌟 Key Features

- **Zsh Mastery:** Standalone setup with syntax highlighting, autosuggestions, and `fzf` history search.
- **Starship Prompt:** Fast, beautiful prompt with the **Catppuccin Powerline** preset.
- **NVIDIA & CUDA:** Automated driver installation (akmod), VA-API acceleration, and **CUDA Toolkit** (with Fedora 42 fallback logic).
- **Multimedia:** Full FFmpeg swap and essential codecs for creators.
- **Modern IDEs:** Automated installation for **Zed IDE** and **Google Antigravity**.
- **Ptyxis Integration:** Automated terminal transparency (0.8) and **FiraCode Nerd Font** configuration.

---

## 📋 Prerequisites

- **OS:** Fedora 43 Workstation (x86_64).
- **Hardware:** NVIDIA GPU (required for the CUDA script).
- **Permissions:** Sudo access is required for system-level changes.
- **Internet:** Stable connection for package downloads.

---

## 🚀 Quick Start

To set up your entire environment in one command, follow these steps:

### 1. Clone the Repository
```bash
git clone https://github.com/bdtoconnect-creator/fedora43_workstation_setup.git
