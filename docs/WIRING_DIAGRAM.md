# Smart Wind Power System — Wiring Diagram

## Power path

```
Wind / Manual Spin
    │
    ▼
Yellow Turbine Blades
    │
    ▼
RO24-75G DC Generator
    │
    ▼
Bridge Rectifier + Capacitor
    │
    ▼
12V Battery / Supercap
    │
    ├──► 1-Channel Relay ──► LED Load
    │
    └──► Voltage Divider ──► Arduino A0
```

## Arduino UNO R3 pin map

| Pin | Direction | Component | Notes |
|-----|-----------|-----------|-------|
| `A0` | Input | Voltage divider output | Scale to 0–5 V max at ADC |
| `D2` | Input | DHT11 data | 10 kΩ pull-up recommended |
| `D3` | Input | IR receiver OUT | Active LOW modules common |
| `D4` | Output | LCD RS | |
| `D5` | Output | LCD E | |
| `D6` | Output | LCD D4 | |
| `D9` | Output | LCD D5 | |
| `D12` | Output | LCD D6 | |
| `D13` | Output | LCD D7 | |
| `D8` | Output | Relay IN | Active HIGH typical |
| `D7` | Output | Buzzer (+) | Use transistor if > 20 mA |
| `D10` | Input | ESP8266 TX → Arduino RX | Software serial |
| `D11` | Output | Arduino TX → ESP8266 RX | Software serial |

> **LCD pin note:** If D8 conflicts with relay on your breadboard layout, move LCD data pins to unused digital pins and update `LiquidCrystal` constructor in firmware.

## Voltage divider

Example for monitoring up to ~15 V battery:

```
Battery+ ── R1 (10 kΩ) ──┬── A0
                         │
                        R2 (3.3 kΩ)
                         │
                       GND
```

Divider ratio: `V_adc = V_battery × R2 / (R1 + R2)`

Calibrate `VOLTAGE_DIVIDER` constant in Arduino sketch after multimeter check.

## ESP8266 / ESP32 bridge

| MCU pin | Connects to |
|---------|-------------|
| GPIO4 (RX) | Arduino D11 (TX) |
| GPIO5 (TX) | Arduino D10 (RX) |
| GND | Arduino GND (common ground required) |
| 3.3 V | Stable 3.3 V supply — do not feed 5 V logic to ESP |

## Relay module

- `VCC` → 5 V (or module rating)
- `GND` → Common GND
- `IN` → Arduino D8
- `COM` / `NO` → LED load circuit on battery side

## Safety

- Always common-ground Arduino, ESP, and power monitoring circuit.
- Fuse the battery line appropriately for your load.
- Never connect generator directly to MCU pins.
