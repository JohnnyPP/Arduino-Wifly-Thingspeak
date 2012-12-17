#include <WiFly.h>
#include <Wire.h>



int tmp102Address = 0x48;
int iAverageCount = 1;
float fCelsiusSum=0;
float fCelsiusAverage=0;
bool bAverageCountFlag=false;

// ThingSpeak Settings
char thingSpeakAddress[] = "api.thingspeak.com";
String writeAPIKey = "H2R32AXOACXWEKDI";		
const int updateThingSpeakInterval = 16 * 1000; // Time interval in milliseconds to update ThingSpeak (number of seconds * 1000 = interval)

// Variable Setup
long lastConnectionTime = 0;
boolean lastConnected = false;
int failedCounter = 0;

Client client("api.thingspeak.com", 80);


void setup() 
{
 
  Serial.begin(9600);
  Wire.begin();
  WiFly.begin();
  //delay(1000);
 
  if (!WiFly.join("KKSOSTR", "11111111112"))
  {
    Serial.println("Association failed.");
    while (1)
    {
      // Hang on failure.
    }
  } 

  Serial.println("connecting...");

  if (client.connect())
  {
    Serial.println("connected");
  }
  else
  {
    Serial.println("connection failed");
  }
 
}



void loop()
{

  float celsius = getTemperature();
  //Serial.print("Celsius: ");
  //Serial.println(celsius);

  fCelsiusSum+=celsius;                                //equivalent to fCelsiusSum=fCelsiusSum+celsius; used for averaging
  //Serial.print("fCelsiusSum: ");
  //Serial.println(fCelsiusSum);

  fCelsiusAverage=fCelsiusSum/iAverageCount;
  //Serial.print("fCelsiusAverage: ");
  //Serial.println(fCelsiusAverage);

  char strCelsiusAverage[7];
  dtostrf(fCelsiusAverage,3,3,strCelsiusAverage);
  String strSendTemperatureAverage = String(strCelsiusAverage);

  /*send RAW data
  char strCelsius[7];
  dtostrf(celsius,3,3,strCelsius);
  String sendTemperature = String(strCelsius);
  */


  iAverageCount++;
  //Serial.print("iAverageCount: ");
  //Serial.println(iAverageCount);

  if (iAverageCount==500)
  {
        bAverageCountFlag=true;
        iAverageCount=1;
        fCelsiusSum=0;
  }
  else
  {
        bAverageCountFlag=false;
  }
 
      if (client.available())
      {
        char c = client.read();
        Serial.print(c);
      }

      if (!client.connected() && lastConnected)
      {
        Serial.println("...disconnected");
        Serial.println();
   
        client.stop();
      }
 
      // Update ThingSpeak
      if(!client.connected() && bAverageCountFlag && (millis() - lastConnectionTime > updateThingSpeakInterval))
      {
        updateThingSpeak("field1="+strSendTemperatureAverage);
      }
 
      // Check if Arduino Ethernet needs to be restarted
      if (failedCounter > 3 ) {startEthernet();}
 
      lastConnected = client.connected();

   
 
}

void updateThingSpeak(String tsData)
{
  if (client.connect())
  {
    client.print("POST /update HTTP/1.1\n");
    client.print("Host: api.thingspeak.com\n");
    client.print("Connection: close\n");
    client.print("X-THINGSPEAKAPIKEY: "+writeAPIKey+"\n");
    client.print("Content-Type: application/x-www-form-urlencoded\n");
    client.print("Content-Length: ");
    client.print(tsData.length());
    client.print("\n\n");

    client.print(tsData);
   
    lastConnectionTime = millis();
   
    if (client.connected())
    {
      Serial.println("Connecting to ThingSpeak...");
      Serial.println();
     
      failedCounter = 0;
    }
    else
    {
      failedCounter++;
 
      Serial.println("Connection to ThingSpeak failed ("+String(failedCounter, DEC)+")");
      Serial.println();
    }
   
  }
  else
  {
    failedCounter++;
   
    Serial.println("Connection to ThingSpeak Failed ("+String(failedCounter, DEC)+")");
    Serial.println();
   
    lastConnectionTime = millis();
  }
}


void startEthernet()
{
 
  client.stop();

  Serial.println("Connecting Arduino to network StartEthernet...");
  Serial.println();

  delay(1000);
 
  // Connect to network amd obtain an IP address using DHCP
  /*if (Ethernet.begin(mac) == 0)
  {
    Serial.println("DHCP Failed, reset Arduino to try again");
    Serial.println();
  }
  else
  {
    Serial.println("Arduino connected to network using DHCP");
    Serial.println();
  }
 
  delay(1000);*/
}

float getTemperature()
{
  Wire.requestFrom(tmp102Address,2);

  byte MSB = Wire.read();
  byte LSB = Wire.read();

  //it's a 12bit int, using two's compliment for negative
  int TemperatureSum = ((MSB << 8) | LSB) >> 4;

  float celsius = TemperatureSum*0.0625;
  return celsius;
}


