# OBD2-Diagnostic-UI
![GitHub forks](https://img.shields.io/github/forks/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub Repo stars](https://img.shields.io/github/stars/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub License](https://img.shields.io/github/license/muki01/OBD2-Diagnostic-UI?style=flat)
![GitHub last commit](https://img.shields.io/github/last-commit/muki01/OBD2-Diagnostic-UI)

OBD2-Diagnostic-UI is a lightweight, high-performance web interface designed for real-time vehicle diagnostics.
It serves as a protocol-agnostic frontend optimized for embedded systems like ESP32 and STM32.

## 📱 Interface Preview
<img width=90% src="https://github.com/user-attachments/assets/5a3e0540-b56d-4c3a-a0bf-8c1affcda00c" />
<img width=90% src="https://github.com/user-attachments/assets/8544df16-cf62-4a80-8f19-cbd0daadfb51" />

## ✨ Key Features
- Real-time PID monitoring
- Diagnostic Trouble Code (DTC) visualization
- Freeze frame data display
- WebSocket-based live data streaming
- Protocol-independent API integration
- Optimized for embedded HTTP servers (ESP32, STM32, etc.)
- Production-ready static asset build (minified + gzip)

## 🛠 Tech Stack
- Frontend: HTML5, CSS3, JavaScript (ES6+)
- Communication: WebSockets & REST API
- Optimization: Minified static assets for embedded storage (SPIFFS/LittleFS)

## Architecture

The UI is designed to operate independently of the underlying physical and transport layers.

| Layer            | Responsibility                       |
|------------------|--------------------------------------|
| Physical Layer   | K-Line / CAN                         |
| Protocol Layer   | ISO 9141-2 / ISO 14230 / ISO 15765-4 |
| Diagnostic Layer | OBD-II PIDs / DTC                    |
| API Layer        | REST / WebSocket (JSON)              |
| UI Layer         | OBD2-Diagnostic-UI                   |


The frontend communicates only with the API layer and remains protocol-agnostic.

## 📡 API Contract
#### WebSocket Sample Payload
The frontend expects JSON data in the following format:

```json
{
  "protocol": "ISO15765-4",
  "timestamp": 1700000000,
  "data": {
    "rpm": 820,
    "coolant_temp": 87,
    "vehicle_speed": 0
  }
}
```

---

## ☕ Support My Work

If you enjoy my projects and want to support me, you can do so through the links below:

[![Buy Me A Coffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/muki01)
[![PayPal](https://img.shields.io/badge/-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=SAAH5GHAH6T72)
[![GitHub Sponsors](https://img.shields.io/badge/-Sponsor%20Me%20on%20GitHub-181717?style=for-the-badge&logo=github)](https://github.com/sponsors/muki01)

---

## 📬 Contact

For information, job offers, collaboration, sponsorship, or purchasing my devices, you can contact me via email.

📧 Email: muksin.muksin04@gmail.com

---
