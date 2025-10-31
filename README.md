# ubuntu-to-android-display

Extend your **Ubuntu (Wayland/Sway)** desktop to an **Android tablet** over USB — stable, wired, and simple.

After a long search for a reliable Wayland solution to use my Android tablet as a second screen, I built this minimal setup.  
It reuses a single virtual (“headless”) display in Sway and streams it to the tablet using **WayVNC**, toggled directly from **Waybar**.

---

## ✨ Features

- Works on **Ubuntu 24.04 / Sway (Wayland)** — no X11 or `xrandr`.
- Streams your desktop via **WayVNC**.
- Wired over **USB tethering** or **ADB reverse** (no Wi-Fi lag).
- **One-click toggle** in Waybar:
  - Click to start/stop.
  - Hover to see IP & port for tablet connection.
- Clean notifications and logs for troubleshooting.

---

## 🧩 Installation

### 1. Requirements
```bash
sudo apt install -y wayvnc libnotify-bin
