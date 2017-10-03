/*
 * 25/9/16
 * GPIO only auto/manual 3CH gpio controller
 * Attention when works with BT HC-05/06 device necessary to uncomment:
 * #define PRINTF_EN 0 
 * 
 * 
 * Inputs:
 * 19/PC3 - manual mode (pull-up), when <0> is manual, when <1> is automatic (not used here)
 * 16/PC0 - led_01_manual channel in (pull-up)
 * 17/PC1 - led_02_manual channel in (pull-up)
 * 18/PC2 - led_03_manual channel in (pull-up)
 * Outputs:
 * 15/PD7 - const int led01 = 15; //PD7 (also can use 14-PD6, 13-PD5, 12-PD4)
 * 14/PD6 - const int led02 = 14; //PD6
 * 13/PD5 - const int led03 = 13; //PD5
 * 20/PC4 - manual mode ON <1> - LIGHT, OFF <0> - BLANK
 * 
 * Serial command:
 * RX(IN)
 * A/a - ON/OFF CH#1
 * B/b - ON/OFF CH#2
 * C/v - ON/OFF CH#3
 * S/s - Sta(tus) send back
 * 
 * TX(out)
 * send only on received (S/s) - Sta command
 * A/a - state CH#1
 * B/b - state CH#2
 * C/c - state CH#3
 * M/m - Auto/manual mode
 */
/*
 * 4/09/2017
 * Manual mode for RGB LED handle
 * Inputs:
 * 31/PA0 - POT for brightness
 * 16/PC0 - R channel in (pull-up)
 * 17/PC1 - G channel in (pull-up)
 * 18/PC2 - B channel in (pull-up)
 * 19/PC3 - manual mode (pull-up), when <0> is manual, when <1> is automatic (not used here)
 * Outputs:
 * 15/PD7 - const int led_pwm_1 = 15; //PD7 (also can use 14-PD6, 13-PD5, 12-PD4)
 * 14/PD6 - const int led_pwm_2 = 14; //PD6
 * 13/PD5 - const int led_pwm_3 = 13; //PD5
 * 20/PC4 - manual mode ON <1> - LIGHT, OFF <0> - BLANK
 */
/*
Bare Bone minimum for M644P
*/
/*
  Blink  Sanguino - M644P
  Pinmapping look here: http://www.instructables.com/id/Arduino-atmega6441284-clone/?ALLSTEPS
  Addon for Sanguino (1.0.5 checked) https://github.com/Lauszus/Sanguino/tree/master/avr
  Fuses wo bootloader (ISP MKII programming):
  LOW = 0xFF
  HIGH = 0xDF
  EXTD = 0xFD

  With bootloader (OptiBoot):
  LOW = 0xFF
  HIGH = 0xDE
  EXTD = 0xFD
  */

#include "avr/wdt.h" // WatchDog

const char PROGMEM compile_date[] = __DATE__;     // Mmm dd yyyy - Дата компиляции
const char PROGMEM compile_time[]  = __TIME__;     // hh:mm:ss - Время компиляции
const char PROGMEM str_prog_name[] = "\r\nM644P/M1284P[Arduino] v1.0 GPIO LEDs manual 25/09/2017\r\n";
#if defined(__AVR_ATmega128__)
const char PROGMEM str_mcu[] = "ATmega128"; //CPU is m128
#elif defined (__AVR_ATmega2560__)
const char PROGMEM str_mcu[] = "ATmega2560"; //CPU is m2560
#elif defined (__AVR_ATmega2561__)
const char PROGMEM str_mcu[] = "ATmega2561"; //CPU is m2561
#elif defined (__AVR_ATmega328P__)
const char PROGMEM str_mcu[] = "ATmega328P"; //CPU is m328p
#elif defined (__AVR_ATmega32U4__)
const char PROGMEM str_mcu[] = "ATmega32u4"; //CPU is m32u4
#elif defined (__AVR_ATmega644P__)
const char PROGMEM str_mcu[] = "ATmega644P"; //CPU is m644p
#elif defined (__AVR_ATmega1284P__)
const char PROGMEM str_mcu[] = "ATmega1284P"; //CPU is m1284p
#else
const char PROGMEM str_mcu[] = "Unknown CPU"; //CPU is unknown
#endif

//#define PRINTF_EN 1
#define PRINTF_EN 0

#if PRINTF_EN
#define PRINTF(...) Serial.print(__VA_ARGS__)
#define PRINTF_F(...) Serial.print(F(__VA_ARGS__))
#else
#define PRINTF(...) do { } while(0)
#define PRINTF_F(...) do { } while(0)
#endif

// Pin 20 has an LED connected on M644P/M1284P
// give it a name:
const int led_manual = 20; // PC4
/*
 * Inputs:
 * 31/PA0 - POT for brightness
 * 16/PC0 - R channel in (pull-up)
 * 17/PC1 - G channel in (pull-up)
 * 18/PC2 - B channel in (pull-up)
 * 19/PC3 - manual mode (pull-up), when <0> is manual, when <1> is automatic (not used here)
 * Outputs:
 * 15/PD7 - const int led_pwm_1 = 15; //PD7 (also can use 14-PD6, 13-PD5, 12-PD4)
 * 14/PD6 - const int led_pwm_2 = 14; //PD6
 * 13/PD5 - const int led_pwm_3 = 13; //PD5
 * 20/PC4 - manual mode ON <1> - LIGHT, OFF <0> - BLANK
*/

const int led_01_manual = 16;
const int led_02_manual = 17;
const int led_03_manual = 18;

const int manual_in = 19; //PC3
const int led_01 = 15; //PD7 (also can use 14-PD6, 13-PD5, 12-PD4)
const int led_02 = 14; //PD6
const int led_03 = 13; //PD5
/*
const int max_brightness = 100; // Максимальная яркость 100 единиц ~ 2.5 скважность (40% заполнение, ie. 100/255)
*/


//***********Пролог для быстрого отключения WDT & сохранения причины вкл.(Atmega128/328) при старте программы: BEGIN
// Пояснения см. <wdt_reset_m328p_Arduino_trouble.txt>
//!! В <mcusr_mirror> см. флаги MCUSR по причине запуска-перезагрузки платы

uint8_t mcucsr_mirror __attribute__ ((section (".noinit")));

// Это для как можно более раннего запрета WDT & сохранения причины вкл.(Atmega128/328)
void get_mcusr(void) \
__attribute__((naked)) \
__attribute__((section(".init3")));
void get_mcusr(void)
{
	mcucsr_mirror = MCUSR;
	MCUSR = 0;
	wdt_disable();
}
//***********Пролог для быстрого отключения WDT & сохранения причины вкл.(Atmega128/328) при старте программы: END

// function to return the amount of free RAM
// RAM Memory usage test
static int freeRam (void)
{
	extern int __heap_start, *__brkval;
	int v;
	int _res = (int) &v - (__brkval == 0 ? (int) &__heap_start : (int) __brkval);
	return _res;
}


void gpio_inputs_setup()
{
	pinMode(led_01_manual, INPUT_PULLUP);
	pinMode(led_02_manual, INPUT_PULLUP);
	pinMode(led_03_manual, INPUT_PULLUP);
	pinMode(manual_in, INPUT_PULLUP);

}

void gpio_outputs_setup()
{
	pinMode(led_01, OUTPUT);
	digitalWrite(led_01, LOW);

	pinMode(led_02, OUTPUT);
	digitalWrite(led_02, LOW);

	pinMode(led_03, OUTPUT);
	digitalWrite(led_03, LOW);

	pinMode(led_manual, OUTPUT);
	digitalWrite(led_manual, LOW);

}
char msg[128] = "\0";

int prev_manual; // For track switch mode between auto and manual

// the setup routine runs once when you press reset:
void setup()
{

	// WatchDog INIT
	wdt_enable(WDTO_2S);  // set up wdt reset interval 2 second
	wdt_reset(); // wdt reset ~ every <2000ms

	// initialize the digital pin as an output.
	gpio_inputs_setup();
	gpio_outputs_setup();
	Serial.begin(9600);

	delay(1000);
	sprintf_P(msg, PSTR("%S"), str_prog_name); // Prog Name
	PRINTF(msg);
	sprintf_P(msg, PSTR("Compiled at: %S %S\r\n"), compile_date, compile_time); // Date && Time compile
	PRINTF(msg);
	sprintf_P(msg, PSTR(">> MCU: %S; CLK: %luHz\r\n"), str_mcu, F_CPU); // MCU Name && FREQ
	PRINTF(msg);
	sprintf_P(msg, PSTR("Free Ram: %u bytes\r\n"), freeRam()); // Free RAM
	PRINTF(msg);

	prev_manual = !digitalRead(manual_in); // Check initial value for auto_manual switch
	if(prev_manual)
	{
		//prev_manual=HIGH
		PRINTF_F("Initial MANUAL MODE\r\n");
	}
	else
	{
		//prev_manual=LOW
		PRINTF_F("Initial AUTO MODE\r\n");
	}


}

void send_STA(void)
{
	//Ch#1 status
	if (digitalRead(led_01))
		Serial.write('A');
	else
		Serial.write('a');

	//Ch#2 status
	if (digitalRead(led_02))
		Serial.write('B');
	else
		Serial.write('b');

	//Ch#3 status
	if (digitalRead(led_03))
		Serial.write('C');
	else
		Serial.write('c');

	//Switch aAUTO/Manual status
	if (digitalRead(manual_in))
		Serial.write('M'); //mode Auto
	else
		Serial.write('m'); //mode Manual
	Serial.write('\r');
	Serial.write('\n');
}

//Command processor mode (parse serial stream)
void PS_SERIAL(int mode)
{
	//mode == LOW auto mode
	//mode == HIGH manual mode
	int uart_RX;
	//Check UAT RX
	while(Serial.available() > 0)
	{
		wdt_reset();
		// read the incoming byte:
		uart_RX = Serial.read();

		//!! Debug out uart rx
		PRINTF_F("RX: <");
		if(uart_RX > 0x20)
		{
#if PRINTF_EN
			Serial.write((uint8_t)uart_RX);
#endif
		}
		else
		{
			PRINTF_F(" ");
		}
		PRINTF_F(">-0x");
		PRINTF(uart_RX, HEX);
		PRINTF_F("\r\n");

		//!! Add here your own command processor (uart_RX - stream received commands)
		if (mode) // Check for manual mode
		{
			//MODE MANUAL
			//Avoid exec GPIO commands wo status in manual mode
			switch ((char)uart_RX)
			{
			case 's':
			case 'S':
				send_STA();
				break;
			default:;
			}
		}
		else
		{
			//MODE AUTO
			switch ((char)uart_RX)
			{
			case 'A':
				digitalWrite(led_01, HIGH);
				break;
			case 'a':
				digitalWrite(led_01, LOW);
				break;
			case 'B':
				digitalWrite(led_02, HIGH);
				break;
			case 'b':
				digitalWrite(led_02, LOW);
				break;
			case 'C':
				digitalWrite(led_03, HIGH);
				break;
			case 'c':
				digitalWrite(led_03, LOW);
				break;
			case 's': //Status
			case 'S':
				send_STA();
				break;
			default:
				;
			}
		}
	}
}

void loop()
{
	unsigned long timer_tick = millis();
	while (1)
	{
		//Wait for 50 ms
		//if ((millis() - timer_tick) > 50)
		//Wait for 1 sec
		if ((millis() - timer_tick) > 50)
		{
			wdt_reset();  //Reset watchdog
			timer_tick = millis(); //Store timer tag for next 50ms iteration
			//Check manual mode switch ON
			if (!digitalRead(manual_in)) // LOW on manual
			{
				//Manual mode
				digitalWrite(led_manual, LOW);
				//delay(50);               // wait for a second
				//digitalWrite(led_manual, LOW);    // turn the LED off by making the voltage LOW
				//delay(50);               // wait for a second
				//PRINTF_F("Uptime: "); PRINTF(((float)millis())/1000.0,3); PRINTF_F(" sec\r\n");
				//PRINTF_F("PA0: "); PRINTF(analogRead(A0)); PRINTF_F("\r\n");
				//PRINTF_F("INs: 0B"); PRINTF(PINC & 0xF, BIN); PRINTF_F("\r\n");

				//Read brightness value
				//int pwm_value_a0 = map(analogRead(A0), 0, 1023, 0, max_brightness);

				//1CH RED
				if (digitalRead(led_01_manual))
					digitalWrite(led_01, 0);
				else
					digitalWrite(led_01, 1);

				//2CH GREEN
				if (digitalRead(led_02_manual))
					digitalWrite(led_02, 0);
				else
					digitalWrite(led_02, 1);

				//3CH BLUE
				if (digitalRead(led_03_manual))
					digitalWrite(led_03, 0);
				else
					digitalWrite(led_03, 1);

				//Check prev step mode
				if (!prev_manual) //Prev was low i.e. AUTO
				{
					//!!Here when change from AUTO to MANUAL
					//PRINTF_F("Going to MANUAL mode\r\n");
				}
				prev_manual = HIGH; // Set prev mode as high i.e. MANUAL
			}//MANUAL MODE
			else
			{
				//Auto mode ON
				digitalWrite(led_manual, HIGH);
				//Add here your own algorithm for auto mode

				//Check prev step mode
				if (prev_manual) //Prev was high i.e. MANUAL
				{
					//!!Here when change from MANUAL to AUTO
					//PRINTF_F("Going to AUTO mode\r\n");
				}
				prev_manual = LOW; // Set prev mode as low i.e. AUTO
			}//AUTO MODE
		}//if ((millis() - timer_tick) > 50)..
		//Process Serial command processor
		PS_SERIAL(prev_manual);
	}//while (1)

}

