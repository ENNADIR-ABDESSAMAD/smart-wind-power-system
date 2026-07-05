/*
 * BlynkBridge — ESP8266 NodeMCU / ESP32
 * WiFi bridge: reads serial from Arduino, pushes to Blynk + Express API.
 *
 * Configure WIFI_SSID, WIFI_PASS, BLYNK_AUTH_TOKEN, API_URL below.
 */

#if defined(ESP32)
  #include <WiFi.h>
#else
  #include <ESP8266WiFi.h>
#endif

#include <SoftwareSerial.h>
#include <BlynkSimpleEsp8266.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// --- Configuration (update before flashing) ---
#define WIFI_SSID       "YOUR_WIFI_SSID"
#define WIFI_PASS       "YOUR_WIFI_PASSWORD"
#define BLYNK_AUTH_TOKEN "YOUR_BLYNK_TOKEN"
#define API_URL         "http://192.168.1.100:3000/api/iot/ingest"
#define DEVICE_ID       "wind-turbine-01"

#define ARDUINO_RX      4
#define ARDUINO_TX      5
#define SERIAL_BAUD     115200

SoftwareSerial arduinoSerial(ARDUINO_RX, ARDUINO_TX);

// Blynk virtual pins
#define VPIN_VOLTAGE    V0
#define VPIN_TEMP       V1
#define VPIN_HUMIDITY   V2
#define VPIN_RELAY      V3

float lastVoltage = 0;
float lastTemp = 0;
float lastHumidity = 0;
bool lastRelay = false;

BlynkTimer timer;

void setup() {
  Serial.begin(115200);
  arduinoSerial.begin(SERIAL_BAUD);

  Blynk.begin(BLYNK_AUTH_TOKEN, WIFI_SSID, WIFI_PASS);
  timer.setInterval(10000L, postToApi);
}

void loop() {
  Blynk.run();
  timer.run();
  readArduinoSerial();
}

void readArduinoSerial() {
  if (!arduinoSerial.available()) return;

  String line = arduinoSerial.readStringUntil('\n');
  line.trim();
  if (!line.startsWith("DATA,")) return;

  int c1 = line.indexOf(',', 5);
  int c2 = line.indexOf(',', c1 + 1);
  int c3 = line.indexOf(',', c2 + 1);

  if (c1 < 0 || c2 < 0 || c3 < 0) return;

  lastVoltage  = line.substring(5, c1).toFloat();
  lastTemp     = line.substring(c1 + 1, c2).toFloat();
  lastHumidity = line.substring(c2 + 1, c3).toFloat();
  lastRelay    = line.substring(c3 + 1).toInt() == 1;

  Blynk.virtualWrite(VPIN_VOLTAGE, lastVoltage);
  Blynk.virtualWrite(VPIN_TEMP, lastTemp);
  Blynk.virtualWrite(VPIN_HUMIDITY, lastHumidity);
  Blynk.virtualWrite(VPIN_RELAY, lastRelay ? 1 : 0);
}

void postToApi() {
  if (WiFi.status() != WL_CONNECTED) return;

  HTTPClient http;
  http.begin(API_URL);
  http.addHeader("Content-Type", "application/json");

  StaticJsonDocument<256> doc;
  doc["deviceId"] = DEVICE_ID;
  doc["voltage"] = lastVoltage;
  doc["temperature"] = lastTemp;
  doc["humidity"] = lastHumidity;
  doc["relayOn"] = lastRelay;

  String body;
  serializeJson(doc, body);

  int code = http.POST(body);
  if (code > 0) {
    Serial.printf("API POST: %d\n", code);
  } else {
    Serial.printf("API error: %s\n", http.errorToString(code).c_str());
  }
  http.end();
}

BLYNK_WRITE(VPIN_RELAY) {
  int value = param.asInt();
  arduinoSerial.print("CMD,RELAY,");
  arduinoSerial.println(value);
}
