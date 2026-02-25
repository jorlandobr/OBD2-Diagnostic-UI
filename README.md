# 🚗 OBD2 Diagnostic UI
![GitHub forks](https://img.shields.io/github/forks/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub Repo stars](https://img.shields.io/github/stars/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub License](https://img.shields.io/github/license/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub last commit](https://img.shields.io/github/last-commit/muki01/OBD2-Diagnostic-UI)

OBD2-Diagnostic-UI is a premium, high-performance web interface designed for real-time vehicle diagnostics. Optimized for embedded web servers (ESP32, ESP8266, STM32), it provides a sleek, responsive, and professional dashboard for monitoring vehicle health, reading/clearing fault codes, and performance testing.

## 📱 Interface Preview
<img width=90% src="https://github.com/user-attachments/assets/5a3e0540-b56d-4c3a-a0bf-8c1affcda00c" />
<img width=90% src="https://github.com/user-attachments/assets/8544df16-cf62-4a80-8f19-cbd0daadfb51" />

## ✨ Key Features

- **📊 Real-Time Monitoring**: Live visualization of PIDs (RPM, Speed, Load, etc.) with custom selection.
- **⚠️ DTC Management**: Read and clear Diagnostic Trouble Codes (DTCs) with descriptive meanings.
- **❄️ Freeze Frame**: View engine sensor snapshots taken at the exact moment a fault occurred.
- **⏱️ Performance Test**: Automated 0-100 KM/H timer with precision measurement.
- **🆔 Vehicle Information**: Retrieve VIN, Calibration IDs, and supported protocol details.
- **⚙️ Advanced Configuration**:
  - Wireless Network Settings (SSID/Password/Static IP).
  - OBD-II Protocol Selection (ISO9141, KWP2000, CAN 11/29bit).
  - Dark Mode support for night-time diagnostics.
- **🚀 Embedded Optimization**: Pre-minified and gzipped assets for extremely low memory footprint.

---

## 🛠 Tech Stack

- **Frontend**: HTML5, CSS3 (Modern UI with Glassmorphism), Vanilla JavaScript (ES6+).
- **Communication**: WebSockets for low-latency live streaming & REST API for configuration.
- **Backend Compatibility**: Designed for ESP32/STM32 running ELM327-compatible firmware.

---

## 📡 API Architecture & Contract

The UI operates as a standalone frontend communicating with the hardware via WebSockets.

### WebSocket Data Structure (Uplink)

The hardware (ESP32) should broadcast the following JSON periodically to update the UI:

```json
{
  "vehicleStatus": true,
  "Voltage": 14.1,
  "LiveData": {
    "Engine RPM": { "value": 850, "unit": "RPM" },
    "Coolant Temperature": { "value": 92, "unit": "°C" },
    "Manifold Pressure": { "value": 34, "unit": "kPa" }
  },
  "DTCs": "P0101, P0300",
  "FreezeFrame": {
    "RPM": { "value": 2450, "unit": "RPM" },
    "Vehicle Speed": { "value": 45, "unit": "km/h" }
  },
  "Speed": 0,
  "VIN": "1ABCDEFG12345678",
  "ID": "CALIB-ID-88220",
  "IDNum": "V2.1.0",
  "selectedProtocol": "Automatic",
  "connectedProtocol": "11b500",
  "SupportedLiveData": {
    "Coolant": { "pid": "0105" },
    "RPM": { "pid": "010C" }
  },
  "DesiredLiveData": ["0105", "010C"]
}
```

### Control Commands (Downlink)

Commands sent from the UI to the hardware:
- `page[0-6]`: Notify hardware of the current active menu.
- `clear_dtc`: Request DTC memory clearance.
- `beep`: Trigger audible feedback on the device.

---

## 🚀 Getting Started

### Deployment on ESP32
1. Clone the repository.
2. Ensure you have the `build_spiffs.bat` script to generate the SPIFFS image.
3. Upload the contents of the `data/` folder (minified and gzipped) to your ESP32's flash memory.
4. Implement a WebSocket server on the ESP32 that handles the JSON payload described above.

---

## ☕ Support My Work

If you enjoy my projects and want to support me, you can do so through the links below:

[![Buy Me A Coffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/muki01)
[![PayPal](https://img.shields.io/badge/-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=SAAH5GHAH6T72)
[![GitHub Sponsors](https://img.shields.io/badge/-Sponsor%20Me%20on%20GitHub-181717?style=for-the-badge&logo=github)](https://github.com/sponsors/muki01)

---

## 📬 Contact

For information, job offers, collaboration, sponsorship, or purchasing my devices, you can contact me via email.

📧 **Email**: [muksin.muksin04@gmail.com](mailto:muksin.muksin04@gmail.com)

---
