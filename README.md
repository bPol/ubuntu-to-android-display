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
```

### 2. Setup
```bash
git clone https://github.com/<youruser>/ubuntu-to-android-display.git
cd ubuntu-to-android-display
chmod +x bin/tablet-toggle.sh bin/tablet-status.sh
sudo install -m 0755 bin/tablet-toggle.sh /usr/local/bin/
sudo install -m 0755 bin/tablet-status.sh /usr/local/bin/
```

---

## 🖥️ Waybar Integration

Add this module to your Waybar config (`~/.config/waybar/config`) and include `"custom/tablet"` in your `modules-right`:

```json
"custom/tablet": {
  "return-type": "json",
  "exec": "/usr/local/bin/tablet-status.sh",
  "interval": 2,
  "on-click": "/usr/local/bin/tablet-toggle.sh",
  "tooltip": true
}
```

Optional color styling in `~/.config/waybar/style.css`:
```css
#custom-tablet.off { color: #888; }
#custom-tablet.on  { color: #9f9; }
```

Reload Waybar:
```bash
pkill -SIGUSR2 waybar
```

---

## 📱 How to Use

1. **Connect the tablet via USB.**
2. Enable **USB tethering** on Android  
   *(Settings → Network & Internet → Hotspot & Tethering → USB tethering)*  
   Ubuntu will create an interface like `enx...` with an IP (e.g. `10.224.x.x`).

   or use **ADB reverse**:
   ```bash
   adb reverse tcp:5900 tcp:5900
   ```
3. Click the **🖥 icon** in Waybar:
   - `HEADLESS-1` output is enabled on the right side.
   - WayVNC starts streaming on port `5900`.
   - You’ll get a notification: `Started at 10.224.x.x:5900`.
4. On the tablet, open a **VNC client** (like **bVNC** or **RealVNC Viewer**) and connect to that address.
5. Click the icon again to stop.

---

## ⚙️ Configuration

- **Resolution:** edit `MODE="1920x1200@60"` inside `tablet-toggle.sh`.
- **Position:** change `position 2560 0` for left/right placement.
- **Port:** change `PORT=5900` if needed.
- **Logs:**  
  - `/tmp/tablet-toggle.log` — script activity  
  - `/tmp/wayvnc.out` — WayVNC output  

---

## 🪛 Troubleshooting

| Problem | Fix |
|----------|------|
| Nothing happens | Run `tail -n 100 /tmp/tablet-toggle.log` and check Waybar config syntax. |
| “No such output” | Ensure you’re running under Sway and not via SSH. |
| Lag | Use USB tethering (faster than Wi-Fi). |
| Security | By default, WayVNC listens on `0.0.0.0` (USB only). For ADB-only, bind to `127.0.0.1`. |

---

## 💡 Why this project

All existing “second monitor” tutorials relied on X11 dummy drivers or complex setups.  
This is a **Wayland-native**, **two-script**, and **practical** solution that works consistently on modern Ubuntu + Sway.

It combines:
- Sway’s `create_output` (headless displays)
- WayVNC for streaming
- Waybar for instant control

---

## 📄 License

MIT License © 2025 Bernhard Huber  
You’re free to use, modify, and share with attribution.
