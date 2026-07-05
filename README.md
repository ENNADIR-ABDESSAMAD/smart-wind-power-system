# PFE Smart Wind Power System

IoT-based smart wind power monitoring and control platform for a final year project (PFE).

## Architecture

| Layer | Technology | Path |
|-------|------------|------|
| Edge firmware | Arduino UNO R3 | `firmware/SmartWindPowerSystem/` |
| WiFi bridge | ESP8266 / ESP32 | `firmware/BlynkBridge/` |
| Front Office API | Express.js (Node.js) | `backend-express/` |
| Front Office Web | Angular | `frontend-office/web-angular/` |
| Front Office Mobile | Flutter | `frontend-office/mobile-flutter/` |
| Back Office | Spring Boot + Thymeleaf | `backend-admin-spring/` |
| Shared database | PostgreSQL | Both backends connect to the same instance |

## Hardware overview

```
Wind / Manual Spin → Turbine → RO24-75G Generator
  → Bridge Rectifier & Capacitor → 12V Battery/Supercap
  → Relay → LED Load
  → Voltage Divider → Arduino A0
```

See [docs/WIRING_DIAGRAM.md](docs/WIRING_DIAGRAM.md) for pin mappings.

## Quick start

### Database (PostgreSQL)

PostgreSQL 17 must be running. Use the setup script (prompts for your `postgres` password):

```powershell
.\scripts\setup-db.ps1
```

Or set `POSTGRES_PASSWORD` and run non-interactively:

```powershell
$env:POSTGRES_PASSWORD = "your-password"
.\scripts\setup-db.ps1
```

Default connection (both backends):

- Host: `localhost`
- Port: `5432`
- Database: `smart_wind_power`
- User: `postgres`

### Express API (Front Office)

```powershell
cd backend-express
npm install
npm run dev
```

Or start API + Angular together:

```powershell
.\scripts\start-dev.ps1
```

Runs on `http://localhost:3000`

### Spring Boot Admin (Back Office)

```powershell
.\scripts\start-spring.ps1
```

Uses portable Maven in `.tools/apache-maven-3.9.6/`.

Runs on `http://localhost:8080` — default admin: `admin` / `admin123`

### Angular dashboard

```bash
cd frontend-office/web-angular
npm install
npm start
```

Runs on `http://localhost:4200`

### Flutter mobile

```bash
cd frontend-office/mobile-flutter
flutter pub get
flutter run
```

### Firmware

1. Flash `firmware/SmartWindPowerSystem/SmartWindPowerSystem.ino` to Arduino UNO.
2. Flash `firmware/BlynkBridge/BlynkBridge.ino` to ESP8266/ESP32.
3. Configure WiFi and API URL in the bridge sketch.
4. See [docs/BLYNK_APP_SETUP.md](docs/BLYNK_APP_SETUP.md) for Blynk widgets.

## API endpoints (Express)

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/health` | Health check |
| `POST` | `/api/iot/ingest` | Device sensor payload ingestion |
| `GET` | `/api/sensors/latest` | Latest readings |
| `GET` | `/api/sensors/history` | Historical readings |

## Project structure

```
├── firmware/
├── docs/
├── frontend-office/
│   ├── mobile-flutter/
│   └── web-angular/
├── backend-express/
├── backend-admin-spring/
└── README.md
```

## Documentation

- [Wiring diagram & pin map](docs/WIRING_DIAGRAM.md)
- [Blynk app setup](docs/BLYNK_APP_SETUP.md)
- [PFE report outline (FR)](docs/PFE_REPORT_OUTLINE.md)
