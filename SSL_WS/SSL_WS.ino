#include "ESP8266WiFi.h"
#include "ESPAsyncWebServer.h"
//#include "index.h"

#include <FastLED.h>
#define LED_PIN     12
#define NUM_LEDS    20
CRGB leds[NUM_LEDS];

const char* ssid = "HanyeS";
const char* password =  "17171717";

#define NUM_LAMP 12

AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

// Set your Static IP address
IPAddress local_IP(192, 168, 100, 15);
// Set your Gateway IP address
IPAddress gateway(192, 168, 100, 1);

IPAddress subnet(255, 255, 0, 0);
IPAddress primaryDNS(8, 8, 8, 8);   //optional
IPAddress secondaryDNS(8, 8, 4, 4); //optional

void onWsEvent(AsyncWebSocket * server, AsyncWebSocketClient * client, AwsEventType type, void * arg, uint8_t *data, size_t len){

  if(type == WS_EVT_CONNECT){

    Serial.println("Websocket client connection received");
    client->text("Connected");
    Serial.println(client->id());
  } else if(type == WS_EVT_DISCONNECT){
    Serial.println("Client disconnected");
    Serial.println("-----------------------");

  } else if(type == WS_EVT_DATA){

    Serial.print("Data received: ");
    String c = "";
    for(int i = 0; i < len; i++){
      c += (char)data[i];
    }
    Serial.println(c);
    if (strcmp((char*)data, "on") == 1){
      digitalWrite(LED_BUILTIN, HIGH);
    }
    if (strcmp((char*)data, "off") == 1){
      digitalWrite(LED_BUILTIN, LOW);
    }
  }
}

void setup(){
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  
  // Configures static IP address
  if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
    Serial.println("STA Failed to configure");
  }

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  Serial.println(WiFi.localIP());

  ws.onEvent(onWsEvent);
  server.addHandler(&ws);

  server.on("/update", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(200);
    Serial.println("Client connected to server!");
  //  request->send_P(200, "text/html", MAIN_page);
  });

  server.begin();
}

void loop(){}

//void deepSleep(){
//  Serial.println("Going for deep sleep!");
//  esp_deep_sleep_start();
//}
