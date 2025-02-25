/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/25/2025
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <i2c.h>
#include <lm75.h>
#include <ds1307.h>
#include <glcd.h>
#include <font5x7.h>
#include <stdio.h>
#include <ir1.h>
#include <delay.h>


unsigned char  h = 0, m = 0, s = 0;
unsigned char t1[16],t2[16],t3[16];
int a;
float b;
unsigned char wd = 0, day = 0,month = 0,year = 0;

void main(void)
{
// Declare your local variables here
// Variable used to store graphic display
// controller initialization data
GLCDINIT_t glcd_init_data;

DDRD.6 = 0x00;
DDRD.7 = 0x00;

DDRB.6 = 1; 
DDRB.7 = 1; 

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x06;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTC
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// LM75 Temperature Sensor initialization
// thyst: 25�C
// tos: 36�C
// O.S. polarity: 0
lm75_init(0,25,36,0);

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: On
// Square wave frequency: 1Hz
rtc_init(0,1,0);

// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTA Bit 0
// DB1 - PORTA Bit 1
// DB2 - PORTA Bit 2
// DB3 - PORTA Bit 3
// DB4 - PORTA Bit 4
// DB5 - PORTA Bit 5
// DB6 - PORTA Bit 6
// DB7 - PORTA Bit 7
// E - PORTB Bit 2
// RD /WR - PORTB Bit 1
// RS - PORTB Bit 0
// /RST - PORTB Bit 5
// CS1 - PORTB Bit 4
// CS2 - PORTB Bit 3

// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;

glcd_init(&glcd_init_data);

h  = 11;
m = 28;

rtc_set_time(h,m,s);
 year = 03;
month = 12;
 day = 7;
rtc_set_date(wd,day,month,year);
glcd_putimagef(0,0,p3,GLCD_PUTCOPY);
delay_ms(2000);
glcd_clear();


while (1)
      { 
        rtc_get_time(&h,&m,&s);
        glcd_outtextxy(0,0,"CLOCK:");
        sprintf(t1,"%02d:%02d:%02d",h,m,s);
        glcd_outtextxy(35,0,t1);
        if(PIND.6 == 0)
        {
            m++;
            if(m == 60) m = 0;
            rtc_set_time(h,m,s);
        }
        
        if(PIND.7 == 0)
        {
            h++;
            if(h == 24) h =0;
            rtc_set_time(h,m,s);
        }
        
        rtc_get_date(&wd,&day,&month,&year);
        glcd_outtextxy(0,10,"DATE:");
        sprintf(t3,"%02d/%2d/%02d",year,month,day);
        glcd_outtextxy(35,10,t3); 
        

        
        
        a = lm75_temperature_10(0);
        b = (float)a/10;
        sprintf(t2,"%4.1f",b);
        glcd_outtextxy(0,20,"TEMP: ");
        glcd_outtextxy(29,20,t2);
        
        
        glcd_outtextxy(0,30,"RELAY_1: OFF");
        glcd_outtextxy(0,40,"RELAY_2: OFF");
        
        if(b >= 25)
        {
            PORTB.6 = 1;
            glcd_outtextxy(0,30,"RELAY_1: ON");   
        }
        
        if(b >=30)
        {
            PORTB.7 =1;
            glcd_outtextxy(0,40,"RELAY_2: ON");
        }
         

        


      }
}
