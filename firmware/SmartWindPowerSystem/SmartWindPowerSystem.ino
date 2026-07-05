/*
 * Smart Wind Power System — Arduino UNO R3
 * Main edge controller: sensors, LCD, relay, buzzer, ESP bridge.
 *
 * Pin map:
 *   A0  — Voltage divider
 *   D2  — DHT11
 *   D3  — IR receiver
 *   D4-D9 — LCD 1602 (RS, E, D4-D7)
 *   D7  — Buzzer
 *   D8  — Relay
 *   D10/D11 — Software serial to ESP8266 (RX/TX)
 */

#include <SoftwareSerial.h>
#include <DHT.h>
#include <LiquidCrystal.h>
#include <IRremote.h>

// --- Pin definitions ---
#define PIN_VOLTAGE       A0
#define PIN_DHT           2
#define PIN_IR            3
#define PIN_BUZZER        7
#define PIN_RELAY         8
#define PIN_ESP_RX        10
#define PIN_ESP_TX        11

#define DHT_TYPE          DHT11
#define VOLTAGE_DIVIDER   5.0
#define ADC_MAX           1023.0
#define VOLTAGE_ALERT     11.5
#define VOLTAGE_LOW       10.5
#define READ_INTERVAL_MS  2000

// LCD: RS, E, D4, D5, D6, D7 — D9 used for D7 data; D7/D8 reserved for buzzer/relay
LiquidCrystal lcd(4, 5, 6, 9, 12, 13);
DHT dht(PIN_DHT, DHT_TYPE);
SoftwareSerial espSerial(PIN_ESP_RX, PIN_ESP_TX);

// --- State ---
bool relayOn = false;
unsigned long lastReadMs = 0;

void setup() {
  Serial.begin(9600);
  espSerial.begin(115200);

  pinMode(PIN_BUZZER, OUTPUT);
  pinMode(PIN_RELAY, OUTPUT);
  pinMode(PIN_VOLTAGE, INPUT);

  digitalWrite(PIN_BUZZER, LOW);
  digitalWrite(PIN_RELAY, LOW);

  dht.begin();
  IrReceiver.begin(PIN_IR, ENABLE_LED_FEEDBACK);

  lcd.begin(16, 2);
  lcd.print("Smart Wind Power");
  lcd.setCursor(0, 1);
  lcd.print("Initializing...");

  delay(1500);
  lcd.clear();
}

void loop() {
  if (IrReceiver.decode()) {
    handleIrCommand(IrReceiver.decodedIRData.command);
    IrReceiver.resume();
  }

  unsigned long now = millis();
  if (now - lastReadMs >= READ_INTERVAL_MS) {
    lastReadMs = now;
    readAndPublish();
  }
}

void readAndPublish() {
  float rawAdc = analogRead(PIN_VOLTAGE);
  float voltage = (rawAdc / ADC_MAX) * VOLTAGE_DIVIDER;

  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();

  if (isnan(temperature) || isnan(humidity)) {
    temperature = 0.0;
    humidity = 0.0;
  }

  checkAlerts(voltage);
  updateLcd(voltage, temperature, humidity);
  sendToEsp(voltage, temperature, humidity);
}

void checkAlerts(float voltage) {
  if (voltage >= VOLTAGE_ALERT) {
    tone(PIN_BUZZER, 1000, 200);
  } else if (voltage <= VOLTAGE_LOW && voltage > 0.5) {
    tone(PIN_BUZZER, 500, 500);
  }
}

void updateLcd(float voltage, float temp, float humidity) {
  lcd.setCursor(0, 0);
  lcd.print("V:");
  lcd.print(voltage, 1);
  lcd.print("V T:");
  lcd.print(temp, 0);
  lcd.print("C");

  lcd.setCursor(0, 1);
  lcd.print("H:");
  lcd.print(humidity, 0);
  lcd.print("% R:");
  lcd.print(relayOn ? "ON " : "OFF");
}

void sendToEsp(float voltage, float temp, float humidity) {
  espSerial.print("DATA,");
  espSerial.print(voltage, 2);
  espSerial.print(",");
  espSerial.print(temp, 1);
  espSerial.print(",");
  espSerial.print(humidity, 1);
  espSerial.print(",");
  espSerial.println(relayOn ? "1" : "0");
}

void handleIrCommand(uint16_t command) {
  switch (command) {
    case 0xFF02FD: // example: power button
      relayOn = !relayOn;
      digitalWrite(PIN_RELAY, relayOn ? HIGH : LOW);
      break;
    default:
      break;
  }
}
