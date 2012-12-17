#define __AVR_ATmega328P__
#define __cplusplus
#define __builtin_va_list int
#define __attribute__(x)
#define __inline__
#define __asm__(x)
#define ARDUINO 100
extern "C" void __cxa_pure_virtual() {}
#include "C:\arduino-1.0\libraries\WiFly\Client.h"
#include "C:\arduino-1.0\libraries\WiFly\Configuration.h"
#include "C:\arduino-1.0\libraries\WiFly\Debug.h"
#include "C:\arduino-1.0\libraries\WiFly\ParsedStream.h"
#include "C:\arduino-1.0\libraries\WiFly\Server.h"
#include "C:\arduino-1.0\libraries\WiFly\SpiUart.h"
#include "C:\arduino-1.0\libraries\WiFly\WiFly.h"
#include "C:\arduino-1.0\libraries\WiFly\WiFlyDevice.h"
#include "C:\arduino-1.0\libraries\WiFly\_Spi.h"
#include "C:\arduino-1.0\libraries\Wire\Wire.h"
#include "C:\arduino-1.0\libraries\Wire\utility\twi.h"
#include "C:\arduino-1.0\libraries\WiFly\Client.cpp"
#include "C:\arduino-1.0\libraries\WiFly\ParsedStream.cpp"
#include "C:\arduino-1.0\libraries\WiFly\Server.cpp"
#include "C:\arduino-1.0\libraries\WiFly\SpiUart.cpp"
#include "C:\arduino-1.0\libraries\WiFly\WiFlyDevice.cpp"
#include "C:\arduino-1.0\libraries\WiFly\_Spi.cpp"
#include "C:\arduino-1.0\libraries\Wire\Wire.cpp"
#include "C:\arduino-1.0\libraries\Wire\utility\twi.c"
void setup();
void loop();
void updateThingSpeak(String tsData);
void startEthernet();
float getTemperature();

#include "C:\arduino-1.0\hardware\arduino\variants\standard\pins_arduino.h" 
#include "C:\arduino-1.0\hardware\arduino\cores\arduino\Arduino.h"
#include "C:\Users\Kolan\Documents\Arduino\ArduinoWiFly\ArduinoWiFly.pde" 
