# Blynk App Setup

Mobile dashboard for real-time wind power monitoring alongside the custom Flutter/Angular apps.

## Prerequisites

- Blynk account (Blynk IoT or legacy Blynk)
- Auth token from your Blynk device template
- ESP8266/ESP32 flashed with `firmware/BlynkBridge/BlynkBridge.ino`

## Device template

Create a **Device** named `Smart Wind Turbine` with these datastreams / virtual pins:

| Virtual pin | Type | Name | Range |
|-------------|------|------|-------|
| `V0` | Gauge | Voltage (V) | 0 – 15 |
| `V1` | Gauge | Temperature (°C) | -10 – 50 |
| `V2` | Gauge | Humidity (%) | 0 – 100 |
| `V3` | Switch | Relay / Load | 0 / 1 |

## Mobile layout (suggested)

```
┌─────────────────────────────┐
│  Smart Wind Power           │
├─────────────────────────────┤
│  [Gauge] V0  Voltage        │
│  [Gauge] V1  Temperature    │
│  [Gauge] V2  Humidity       │
│  [Switch] V3  LED Load      │
├─────────────────────────────┤
│  [Label] Device status      │
│  [History graph] V0         │
└─────────────────────────────┘
```

## Configuration steps

1. Copy your **Auth Token** into `BLYNK_AUTH_TOKEN` in `BlynkBridge.ino`.
2. Set `WIFI_SSID` and `WIFI_PASS`.
3. Set `API_URL` to your Express server (e.g. `http://192.168.1.100:3000/api/iot/ingest`).
4. Flash the ESP module and power the full hardware stack.
5. Open Blynk app → add device → verify live updates on V0–V3.

## Dual path architecture

```
Arduino ──serial──► ESP8266/ESP32 ──┬──► Blynk Cloud (V0–V3)
                                    └──► Express API (/api/iot/ingest)
                                              │
                                              ▼
                                        PostgreSQL
                                              ▲
                                        Spring Boot Admin
```

Blynk provides quick mobile prototyping; Express + PostgreSQL is the canonical store for web/admin dashboards.

## Troubleshooting

| Issue | Check |
|-------|-------|
| No Blynk data | Token, WiFi credentials, ESP serial wiring |
| Stale values | Arduino `DATA,...` line format, baud 115200 |
| API not updating | `API_URL` reachable from ESP, Express running, firewall |
| Relay switch no effect | `BLYNK_WRITE(VPIN_RELAY)` and Arduino CMD handler |
