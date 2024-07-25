#include <Wire.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include <BlynkEdgent.h>
// API Integration of the Blynk IOT platform.
#define BLYNK_TEMPLATE_ID "TMPL6nLa-DCR-"
#define BLYNK_TEMPLATE_NAME "IOT Project"
#define BLYNK_AUTH_TOKEN "4QQBZ5IdyYHd7liE6RLL9mrG_4kSJ_BA"
#define sensorPin 34 //Connecting soil moisture sensor at GPIO 34 of the ESP32
#define relayPin 4 //The relay is connected to GPIO 4 of ESP32
BlynkTimer timer;
char auth[] = "4QQBZ5IdyYHd7liE6RLL9mrG_4kSJ_BA";
// Providing WiFI credentials.
char ssid[] = "[SSID]";
char pass[] = "[Password]";
#define SOIL_MOISTURE_PIN A0 // Connecting soil moisture sensor to analog
pin A0
// Motor control settings
#define MOTOR_PIN 4 // Connecting motor control pin to GPIO 4
WiFiClient client;
void setup() {
 Serial.begin(115200);
 BlynkEdgent.begin();
 pinMode(relayPin, OUTPUT);
 digitalWrite(relayPin, HIGH);
}
void loop() {
 BlynkEdgent.run();
 Blynk.run(); // Initializing the Blynk library
 timer.run(); // Initializing the timer

 // Read soil moisture value from analog sensor
 int soilMoistureValue = analogRead(SOIL_MOISTURE_PIN);
 int soilMoisturePercentage = map(soilMoistureValue, 0, 4095, 0, 100);
 // Log soil moisture level
 Blynk.logEvent("Soil Moisture", "Moisture: " + String(soilMoisturePercentage) + "%");
 // Checking if sensor readings are valid
 if (soilMoistureValue == 0) {
 Serial.println("Failed to read from sensors!");
 return;
 }
 // Motor control based on soil moisture
 if (soilMoisturePercentage < 50) { // Adjusting the threshold to be 50%.
 digitalWrite(MOTOR_PIN, HIGH); // Turns on the motor automatically
 Serial.println("Soil moisture is low. Turning on motor...");
 // Alerting the user about low soil moisture and motor activation
 Blynk.logEvent("Soil Moisture Alert", "Soil moisture is low. Motor turning on...");
 } else {
 digitalWrite(MOTOR_PIN, LOW); // Turns off the motor itself.
 Serial.println("Soil moisture is sufficient. Motor turned off.");
 // Alerting user about sufficient soil moisture and motor deactivation
 Blynk.logEvent("Soil Moisture Alert", "Soil moisture is sufficient. Motor turned off.");
 }
 Serial.println("Waiting...");
 delay(2000);
}
