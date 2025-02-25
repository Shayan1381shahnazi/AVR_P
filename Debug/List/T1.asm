
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _h=R5
	.DEF _m=R4
	.DEF _s=R7
	.DEF _a=R8
	.DEF _a_msb=R9
	.DEF _wd=R6
	.DEF _day=R11
	.DEF _month=R10
	.DEF _year=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_p3:
	.DB  0x80,0x0,0x40,0x0,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x80,0xC0,0xC0,0xC0,0x20,0x20,0x20,0x20
	.DB  0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60
	.DB  0x60,0x60,0x60,0x60,0x60,0x60,0x60,0x60
	.DB  0x60,0x20,0x20,0x20,0x20,0x20,0x20,0xA0
	.DB  0x70,0xF0,0x10,0x10,0xF0,0x18,0x8,0x8
	.DB  0x8,0x8,0x6,0x6,0x5,0x41,0x22,0x32
	.DB  0xF1,0x21,0x0,0xF0,0x0,0x0,0x0,0x0
	.DB  0x0,0x40,0x0,0x0,0x20,0x20,0x0,0xF0
	.DB  0x10,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0x40,0x20
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xF8,0x4,0x2,0x1,0x1,0x1,0x1,0x0
	.DB  0x0,0x0,0x8,0x8,0x8,0x8,0x8,0xC
	.DB  0xC,0x0,0x0,0x0,0x0,0x0,0x0,0x40
	.DB  0x60,0x40,0x0,0x80,0x80,0xE0,0x90,0x88
	.DB  0x80,0xD4,0x50,0x50,0x48,0x48,0x47,0x64
	.DB  0x26,0x25,0xB4,0xB2,0xB9,0x98,0xC8,0x54
	.DB  0x54,0x42,0x2A,0x20,0x34,0x13,0x92,0x4B
	.DB  0x2A,0x2A,0x15,0x34,0x34,0x36,0x3E,0x28
	.DB  0x20,0x25,0x29,0x2C,0x22,0x24,0x26,0x21
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x30,0x30
	.DB  0x30,0x30,0x10,0x10,0x10,0x10,0x10,0x18
	.DB  0x18,0x8,0x8,0x8,0xC,0xC4,0xC4,0x44
	.DB  0x2,0x2,0x2,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x3,0x0,0x0,0x0,0x0,0x0,0x80,0x40
	.DB  0x20,0x20,0x10,0x10,0x18,0x8,0x8,0xC
	.DB  0x4,0x4,0x6,0x2,0x2,0x2,0x83,0x81
	.DB  0x81,0x1,0x41,0x41,0x40,0x0,0x0,0x21
	.DB  0x21,0x21,0x21,0x21,0x1,0x11,0x11,0x11
	.DB  0x11,0x11,0x10,0x0,0x8,0x8,0x8,0x8
	.DB  0x8,0x8,0x8,0x8,0x8,0xFF,0x9,0x8
	.DB  0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8
	.DB  0x8,0x8,0x8,0x8,0x10,0x10,0x90,0x60
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xF,0x18,0x10
	.DB  0x30,0x20,0x60,0x60,0x40,0x40,0xC0,0xC0
	.DB  0xC0,0x80,0x80,0x80,0x80,0x80,0x80,0x80
	.DB  0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
	.DB  0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
	.DB  0x80,0x80,0xC0,0xC0,0x40,0x40,0x40,0x40
	.DB  0x40,0x40,0x60,0x20,0x20,0x27,0x20,0x20
	.DB  0x10,0x10,0x10,0x10,0x8,0x8,0x8,0x4
	.DB  0x4,0x4,0x2,0x2,0x3,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x43,0x4C,0x4F,0x43,0x4B,0x3A,0x0,0x25
	.DB  0x30,0x32,0x64,0x3A,0x25,0x30,0x32,0x64
	.DB  0x3A,0x25,0x30,0x32,0x64,0x0,0x44,0x41
	.DB  0x54,0x45,0x3A,0x0,0x25,0x30,0x32,0x64
	.DB  0x2F,0x25,0x32,0x64,0x2F,0x25,0x30,0x32
	.DB  0x64,0x0,0x25,0x34,0x2E,0x31,0x66,0x0
	.DB  0x54,0x45,0x4D,0x50,0x3A,0x20,0x0,0x52
	.DB  0x45,0x4C,0x41,0x59,0x5F,0x31,0x3A,0x20
	.DB  0x4F,0x46,0x46,0x0,0x52,0x45,0x4C,0x41
	.DB  0x59,0x5F,0x32,0x3A,0x20,0x4F,0x46,0x46
	.DB  0x0,0x52,0x45,0x4C,0x41,0x59,0x5F,0x31
	.DB  0x3A,0x20,0x4F,0x4E,0x0,0x52,0x45,0x4C
	.DB  0x41,0x59,0x5F,0x32,0x3A,0x20,0x4F,0x4E
	.DB  0x0
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2160060:
	.DB  0x1
_0x2160000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _0xE
	.DW  _0x0*2

	.DW  0x06
	.DW  _0xE+7
	.DW  _0x0*2+22

	.DW  0x07
	.DW  _0xE+13
	.DW  _0x0*2+48

	.DW  0x0D
	.DW  _0xE+20
	.DW  _0x0*2+55

	.DW  0x0D
	.DW  _0xE+33
	.DW  _0x0*2+68

	.DW  0x0C
	.DW  _0xE+46
	.DW  _0x0*2+81

	.DW  0x0C
	.DW  _0xE+58
	.DW  _0x0*2+93

	.DW  0x01
	.DW  __seed_G10B
	.DW  _0x2160060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2/25/2025
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <i2c.h>
;#include <lm75.h>
;#include <ds1307.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
;#include <ir1.h>
;#include <delay.h>
;
;
;unsigned char  h = 0, m = 0, s = 0;
;unsigned char t1[16],t2[16],t3[16];
;int a;
;float b;
;unsigned char wd = 0, day = 0,month = 0,year = 0;
;
;void main(void)
; 0000 002A {

	.CSEG
_main:
; .FSTART _main
; 0000 002B // Declare your local variables here
; 0000 002C // Variable used to store graphic display
; 0000 002D // controller initialization data
; 0000 002E GLCDINIT_t glcd_init_data;
; 0000 002F 
; 0000 0030 DDRD.6 = 0x00;
	SBIW R28,6
;	glcd_init_data -> Y+0
	CBI  0x11,6
; 0000 0031 DDRD.7 = 0x00;
	CBI  0x11,7
; 0000 0032 
; 0000 0033 DDRB.6 = 1;
	SBI  0x17,6
; 0000 0034 DDRB.7 = 1;
	SBI  0x17,7
; 0000 0035 
; 0000 0036 // Timer/Counter 0 initialization
; 0000 0037 // Clock source: System Clock
; 0000 0038 // Clock value: Timer 0 Stopped
; 0000 0039 // Mode: Normal top=0xFF
; 0000 003A // OC0 output: Disconnected
; 0000 003B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 003C TCNT0=0x00;
	OUT  0x32,R30
; 0000 003D OCR0=0x00;
	OUT  0x3C,R30
; 0000 003E 
; 0000 003F // Timer/Counter 1 initialization
; 0000 0040 // Clock source: System Clock
; 0000 0041 // Clock value: Timer1 Stopped
; 0000 0042 // Mode: Normal top=0xFFFF
; 0000 0043 // OC1A output: Disconnected
; 0000 0044 // OC1B output: Disconnected
; 0000 0045 // Noise Canceler: Off
; 0000 0046 // Input Capture on Falling Edge
; 0000 0047 // Timer1 Overflow Interrupt: Off
; 0000 0048 // Input Capture Interrupt: Off
; 0000 0049 // Compare A Match Interrupt: Off
; 0000 004A // Compare B Match Interrupt: Off
; 0000 004B TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 004C TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 004D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 004E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 004F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0050 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0051 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0052 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0053 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0054 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0055 
; 0000 0056 // Timer/Counter 2 initialization
; 0000 0057 // Clock source: System Clock
; 0000 0058 // Clock value: Timer2 Stopped
; 0000 0059 // Mode: Normal top=0xFF
; 0000 005A // OC2 output: Disconnected
; 0000 005B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 005C TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 005D TCNT2=0x00;
	OUT  0x24,R30
; 0000 005E OCR2=0x00;
	OUT  0x23,R30
; 0000 005F 
; 0000 0060 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0061 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0062 
; 0000 0063 // External Interrupt(s) initialization
; 0000 0064 // INT0: Off
; 0000 0065 // INT1: Off
; 0000 0066 // INT2: Off
; 0000 0067 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0068 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0069 
; 0000 006A // USART initialization
; 0000 006B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 006C // USART Receiver: On
; 0000 006D // USART Transmitter: On
; 0000 006E // USART Mode: Asynchronous
; 0000 006F // USART Baud Rate: 9600
; 0000 0070 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0071 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0072 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0073 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0074 UBRRL=0x06;
	LDI  R30,LOW(6)
	OUT  0x9,R30
; 0000 0075 
; 0000 0076 // Analog Comparator initialization
; 0000 0077 // Analog Comparator: Off
; 0000 0078 // The Analog Comparator's positive input is
; 0000 0079 // connected to the AIN0 pin
; 0000 007A // The Analog Comparator's negative input is
; 0000 007B // connected to the AIN1 pin
; 0000 007C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 007D SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 007E 
; 0000 007F // ADC initialization
; 0000 0080 // ADC disabled
; 0000 0081 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0082 
; 0000 0083 // SPI initialization
; 0000 0084 // SPI disabled
; 0000 0085 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0086 
; 0000 0087 // TWI initialization
; 0000 0088 // TWI disabled
; 0000 0089 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 008A 
; 0000 008B // Bit-Banged I2C Bus initialization
; 0000 008C // I2C Port: PORTC
; 0000 008D // I2C SDA bit: 1
; 0000 008E // I2C SCL bit: 0
; 0000 008F // Bit Rate: 100 kHz
; 0000 0090 // Note: I2C settings are specified in the
; 0000 0091 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0092 i2c_init();
	CALL _i2c_init
; 0000 0093 
; 0000 0094 // LM75 Temperature Sensor initialization
; 0000 0095 // thyst: 25°C
; 0000 0096 // tos: 36°C
; 0000 0097 // O.S. polarity: 0
; 0000 0098 lm75_init(0,25,36,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDI  R30,LOW(36)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lm75_init
; 0000 0099 
; 0000 009A // DS1307 Real Time Clock initialization
; 0000 009B // Square wave output on pin SQW/OUT: On
; 0000 009C // Square wave frequency: 1Hz
; 0000 009D rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 009E 
; 0000 009F // Graphic Display Controller initialization
; 0000 00A0 // The KS0108 connections are specified in the
; 0000 00A1 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00A2 // DB0 - PORTA Bit 0
; 0000 00A3 // DB1 - PORTA Bit 1
; 0000 00A4 // DB2 - PORTA Bit 2
; 0000 00A5 // DB3 - PORTA Bit 3
; 0000 00A6 // DB4 - PORTA Bit 4
; 0000 00A7 // DB5 - PORTA Bit 5
; 0000 00A8 // DB6 - PORTA Bit 6
; 0000 00A9 // DB7 - PORTA Bit 7
; 0000 00AA // E - PORTB Bit 2
; 0000 00AB // RD /WR - PORTB Bit 1
; 0000 00AC // RS - PORTB Bit 0
; 0000 00AD // /RST - PORTB Bit 5
; 0000 00AE // CS1 - PORTB Bit 4
; 0000 00AF // CS2 - PORTB Bit 3
; 0000 00B0 
; 0000 00B1 // Specify the current font for displaying text
; 0000 00B2 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00B3 // No function is used for reading
; 0000 00B4 // image data from external memory
; 0000 00B5 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00B6 // No function is used for writing
; 0000 00B7 // image data to external memory
; 0000 00B8 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00B9 
; 0000 00BA glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 00BB 
; 0000 00BC h  = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 00BD m = 28;
	LDI  R30,LOW(28)
	MOV  R4,R30
; 0000 00BE 
; 0000 00BF rtc_set_time(h,m,s);
	CALL SUBOPT_0x0
; 0000 00C0  year = 03;
	LDI  R30,LOW(3)
	MOV  R13,R30
; 0000 00C1 month = 12;
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 00C2  day = 7;
	LDI  R30,LOW(7)
	MOV  R11,R30
; 0000 00C3 rtc_set_date(wd,day,month,year);
	ST   -Y,R6
	ST   -Y,R11
	ST   -Y,R10
	MOV  R26,R13
	RCALL _rtc_set_date
; 0000 00C4 glcd_putimagef(0,0,p3,GLCD_PUTCOPY);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(_p3*2)
	LDI  R31,HIGH(_p3*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _glcd_putimagef
; 0000 00C5 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00C6 glcd_clear();
	CALL _glcd_clear
; 0000 00C7 
; 0000 00C8 
; 0000 00C9 while (1)
_0xB:
; 0000 00CA       {
; 0000 00CB         rtc_get_time(&h,&m,&s);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL _rtc_get_time
; 0000 00CC         glcd_outtextxy(0,0,"CLOCK:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0xE,0
	CALL _glcd_outtextxy
; 0000 00CD         sprintf(t1,"%02d:%02d:%02d",h,m,s);
	LDI  R30,LOW(_t1)
	LDI  R31,HIGH(_t1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,7
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0x1
	MOV  R30,R4
	CALL SUBOPT_0x1
	MOV  R30,R7
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
; 0000 00CE         glcd_outtextxy(35,0,t1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(_t1)
	LDI  R27,HIGH(_t1)
	CALL _glcd_outtextxy
; 0000 00CF         if(PIND.6 == 0)
	SBIC 0x10,6
	RJMP _0xF
; 0000 00D0         {
; 0000 00D1             m++;
	INC  R4
; 0000 00D2             if(m == 60) m = 0;
	LDI  R30,LOW(60)
	CP   R30,R4
	BRNE _0x10
	CLR  R4
; 0000 00D3             rtc_set_time(h,m,s);
_0x10:
	CALL SUBOPT_0x0
; 0000 00D4         }
; 0000 00D5 
; 0000 00D6         if(PIND.7 == 0)
_0xF:
	SBIC 0x10,7
	RJMP _0x11
; 0000 00D7         {
; 0000 00D8             h++;
	INC  R5
; 0000 00D9             if(h == 24) h =0;
	LDI  R30,LOW(24)
	CP   R30,R5
	BRNE _0x12
	CLR  R5
; 0000 00DA             rtc_set_time(h,m,s);
_0x12:
	CALL SUBOPT_0x0
; 0000 00DB         }
; 0000 00DC 
; 0000 00DD         rtc_get_date(&wd,&day,&month,&year);
_0x11:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(13)
	LDI  R27,HIGH(13)
	RCALL _rtc_get_date
; 0000 00DE         glcd_outtextxy(0,10,"DATE:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	__POINTW2MN _0xE,7
	CALL _glcd_outtextxy
; 0000 00DF         sprintf(t3,"%02d/%2d/%02d",year,month,day);
	LDI  R30,LOW(_t3)
	LDI  R31,HIGH(_t3)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,28
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R13
	CALL SUBOPT_0x1
	MOV  R30,R10
	CALL SUBOPT_0x1
	MOV  R30,R11
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
; 0000 00E0         glcd_outtextxy(35,10,t3);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(_t3)
	LDI  R27,HIGH(_t3)
	CALL _glcd_outtextxy
; 0000 00E1 
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 
; 0000 00E5         a = lm75_temperature_10(0);
	LDI  R26,LOW(0)
	RCALL _lm75_temperature_10
	MOVW R8,R30
; 0000 00E6         b = (float)a/10;
	CALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x4
	CALL __DIVF21
	STS  _b,R30
	STS  _b+1,R31
	STS  _b+2,R22
	STS  _b+3,R23
; 0000 00E7         sprintf(t2,"%4.1f",b);
	LDI  R30,LOW(_t2)
	LDI  R31,HIGH(_t2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,42
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_b
	LDS  R31,_b+1
	LDS  R22,_b+2
	LDS  R23,_b+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00E8         glcd_outtextxy(0,20,"TEMP: ");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0xE,13
	CALL _glcd_outtextxy
; 0000 00E9         glcd_outtextxy(29,20,t2);
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(_t2)
	LDI  R27,HIGH(_t2)
	CALL _glcd_outtextxy
; 0000 00EA 
; 0000 00EB 
; 0000 00EC         glcd_outtextxy(0,30,"RELAY_1: OFF");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xE,20
	CALL _glcd_outtextxy
; 0000 00ED         glcd_outtextxy(0,40,"RELAY_2: OFF");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0xE,33
	CALL _glcd_outtextxy
; 0000 00EE 
; 0000 00EF         if(b >= 25)
	CALL SUBOPT_0x5
	__GETD1N 0x41C80000
	CALL __CMPF12
	BRLO _0x13
; 0000 00F0         {
; 0000 00F1             PORTB.6 = 1;
	SBI  0x18,6
; 0000 00F2             glcd_outtextxy(0,30,"RELAY_1: ON");
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	__POINTW2MN _0xE,46
	CALL _glcd_outtextxy
; 0000 00F3         }
; 0000 00F4 
; 0000 00F5         if(b >=30)
_0x13:
	CALL SUBOPT_0x5
	__GETD1N 0x41F00000
	CALL __CMPF12
	BRLO _0x16
; 0000 00F6         {
; 0000 00F7             PORTB.7 =1;
	SBI  0x18,7
; 0000 00F8             glcd_outtextxy(0,40,"RELAY_2: ON");
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	__POINTW2MN _0xE,58
	CALL _glcd_outtextxy
; 0000 00F9         }
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD 
; 0000 00FE 
; 0000 00FF       }
_0x16:
	RJMP _0xB
; 0000 0100 }
_0x19:
	RJMP _0x19
; .FEND

	.DSEG
_0xE:
	.BYTE 0x46
;/****************************************************************************
;Image data created by the LCD Vision V1.05 font & image editor/converter
;(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Graphic LCD controller: KS0108 128x64 CS1,CS2
;Image width: 128 pixels
;Image height: 64 pixels
;Color depth: 1 bits/pixel
;Imported image file name: p3.bmp
;
;Exported monochrome image data size:
;1028 bytes for displays organized as horizontal rows of bytes
;1028 bytes for displays organized as rows of vertical bytes.
;****************************************************************************/
;
;flash unsigned char p3[]=
;{
;/* Image width: 128 pixels */
;0x80, 0x00,
;/* Image height: 64 pixels */
;0x40, 0x00,
;#ifndef _GLCD_DATA_BYTEY_
;/* Image data for monochrome displays organized
;   as horizontal rows of bytes */
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x33, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,
;0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x03,
;0x98, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x3F, 0x01,
;0xBC, 0x00, 0x0B, 0x00, 0x00, 0x00, 0x08, 0x80,
;0x01, 0x00, 0xE0, 0xF0, 0xFF, 0x1F, 0x30, 0x01,
;0x92, 0x20, 0x08, 0x00, 0x00, 0x00, 0x04, 0x80,
;0x01, 0x00, 0xFC, 0x00, 0x00, 0x00, 0x28, 0x01,
;0x90, 0x00, 0x08, 0x00, 0x00, 0x00, 0x02, 0x80,
;0x01, 0x80, 0x07, 0x00, 0x00, 0x00, 0x24, 0x01,
;0x4A, 0x60, 0x08, 0x00, 0x00, 0x80, 0x01, 0x80,
;0x01, 0x40, 0x00, 0x00, 0x00, 0x00, 0x94, 0x60,
;0x3E, 0x06, 0x05, 0x00, 0x00, 0x70, 0x00, 0x80,
;0x01, 0x20, 0x00, 0x18, 0x00, 0x20, 0x7C, 0x18,
;0xC1, 0xA7, 0x06, 0x00, 0x00, 0x0F, 0x00, 0x80,
;0x01, 0x10, 0xC0, 0x1F, 0x00, 0x08, 0x03, 0x47,
;0x38, 0xCC, 0x00, 0x00, 0xF8, 0x01, 0x00, 0x80,
;0x01, 0x10, 0x00, 0x00, 0x00, 0xE4, 0xC0, 0x1B,
;0xC7, 0x07, 0x00, 0xFC, 0x1F, 0x00, 0x00, 0x80,
;0x01, 0x10, 0x00, 0x00, 0x10, 0x02, 0xF8, 0xC1,
;0xB1, 0xFF, 0xFF, 0x3F, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x10, 0x00, 0x00, 0x38, 0xE2, 0x0F, 0x3C,
;0x08, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x80,
;0x01, 0x10, 0x00, 0x00, 0x80, 0x3F, 0xC0, 0x07,
;0x04, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x80,
;0x01, 0x10, 0x00, 0x00, 0xFC, 0xF8, 0x3F, 0x00,
;0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x10, 0x00, 0xC0, 0x07, 0x00, 0x00, 0x00,
;0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x78, 0x00, 0x00, 0x00, 0x00,
;0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0xC0, 0x01, 0x00, 0x00, 0x7E, 0x00,
;0x02, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x30, 0x00, 0x00, 0xF8, 0x00, 0x00,
;0x02, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x08, 0x00, 0xC0, 0x01, 0x00, 0x00,
;0x02, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x04, 0x00, 0x1C, 0x00, 0x00, 0x00,
;0x02, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x02, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x02, 0xC0, 0x01, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x02, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x00, 0x00,
;0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x00, 0xC0,
;0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0xC0, 0x1F, 0x00, 0x00, 0xC0, 0x7F,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0xFC, 0xFF, 0xFF, 0xFF, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;#else
;/* Image data for monochrome displays organized
;   as rows of vertical bytes */
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x80, 0x80, 0x80, 0xC0, 0xC0, 0xC0,
;0x20, 0x20, 0x20, 0x20, 0x60, 0x60, 0x60, 0x60,
;0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60, 0x60,
;0x60, 0x60, 0x60, 0x60, 0x60, 0x20, 0x20, 0x20,
;0x20, 0x20, 0x20, 0xA0, 0x70, 0xF0, 0x10, 0x10,
;0xF0, 0x18, 0x08, 0x08, 0x08, 0x08, 0x06, 0x06,
;0x05, 0x41, 0x22, 0x32, 0xF1, 0x21, 0x00, 0xF0,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00,
;0x20, 0x20, 0x00, 0xF0, 0x10, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x80, 0x40, 0x20, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0xF8, 0x04, 0x02, 0x01,
;0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x08, 0x08,
;0x08, 0x08, 0x08, 0x0C, 0x0C, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x40, 0x60, 0x40, 0x00, 0x80,
;0x80, 0xE0, 0x90, 0x88, 0x80, 0xD4, 0x50, 0x50,
;0x48, 0x48, 0x47, 0x64, 0x26, 0x25, 0xB4, 0xB2,
;0xB9, 0x98, 0xC8, 0x54, 0x54, 0x42, 0x2A, 0x20,
;0x34, 0x13, 0x92, 0x4B, 0x2A, 0x2A, 0x15, 0x34,
;0x34, 0x36, 0x3E, 0x28, 0x20, 0x25, 0x29, 0x2C,
;0x22, 0x24, 0x26, 0x21, 0x20, 0x20, 0x20, 0x20,
;0x20, 0x20, 0x30, 0x30, 0x30, 0x30, 0x10, 0x10,
;0x10, 0x10, 0x10, 0x18, 0x18, 0x08, 0x08, 0x08,
;0x0C, 0xC4, 0xC4, 0x44, 0x02, 0x02, 0x02, 0x01,
;0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x80, 0x40, 0x20, 0x20, 0x10, 0x10,
;0x18, 0x08, 0x08, 0x0C, 0x04, 0x04, 0x06, 0x02,
;0x02, 0x02, 0x83, 0x81, 0x81, 0x01, 0x41, 0x41,
;0x40, 0x00, 0x00, 0x21, 0x21, 0x21, 0x21, 0x21,
;0x01, 0x11, 0x11, 0x11, 0x11, 0x11, 0x10, 0x00,
;0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
;0x08, 0xFF, 0x09, 0x08, 0x08, 0x08, 0x08, 0x08,
;0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
;0x10, 0x10, 0x90, 0x60, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x0F, 0x18, 0x10, 0x30, 0x20, 0x60, 0x60,
;0x40, 0x40, 0xC0, 0xC0, 0xC0, 0x80, 0x80, 0x80,
;0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
;0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80,
;0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xC0, 0xC0,
;0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x60, 0x20,
;0x20, 0x27, 0x20, 0x20, 0x10, 0x10, 0x10, 0x10,
;0x08, 0x08, 0x08, 0x04, 0x04, 0x04, 0x02, 0x02,
;0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
;#endif
;};
;

	.CSEG
_lm75_set_temp_G100:
; .FSTART _lm75_set_temp_G100
	ST   -Y,R26
	CALL _i2c_start
	LDD  R26,Y+2
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _i2c_write
	LD   R26,Y
	CALL SUBOPT_0x6
	CALL _i2c_stop
	RJMP _0x2180010
; .FEND
_lm75_init:
; .FSTART _lm75_init
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	CALL SUBOPT_0x7
	CALL _i2c_write
	LDI  R26,LOW(1)
	CALL _i2c_write
	LDD  R30,Y+1
	LSL  R30
	LSL  R30
	CALL SUBOPT_0x8
	ST   -Y,R17
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _lm75_set_temp_G100
	ST   -Y,R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _lm75_set_temp_G100
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
_lm75_temperature_10:
; .FSTART _lm75_temperature_10
	ST   -Y,R26
	SBIW R28,2
	ST   -Y,R17
	LDD  R30,Y+3
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
	CALL _i2c_start
	SUBI R17,-LOW(1)
	MOV  R26,R17
	CALL SUBOPT_0x9
	STD  Y+2,R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	STD  Y+1,R30
	CALL _i2c_stop
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(7)
	CALL __ASRW12
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12
	LDD  R17,Y+0
	RJMP _0x218000F
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	CALL SUBOPT_0xA
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
	RJMP _0x2180010
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL SUBOPT_0x6
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	RJMP _0x218000E
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL SUBOPT_0x6
	LD   R26,Y
	CALL SUBOPT_0xF
	LDD  R26,Y+1
	CALL SUBOPT_0xF
	LDD  R26,Y+2
	CALL _bin2bcd
	CALL SUBOPT_0x8
	RJMP _0x2180010
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0xA
	LDI  R26,LOW(3)
	CALL _i2c_write
	CALL SUBOPT_0xB
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0xD
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	CALL _i2c_stop
	JMP  _0x218000B
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0xA
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0xF
	LDD  R26,Y+1
	CALL SUBOPT_0xF
	LD   R26,Y
	CALL _bin2bcd
	CALL SUBOPT_0x8
	RJMP _0x218000F
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G102:
; .FSTART _ks0108_enable_G102
	nop
	SBI  0x18,2
	nop
	RET
; .FEND
_ks0108_disable_G102:
; .FSTART _ks0108_disable_G102
	CBI  0x18,2
	CBI  0x18,4
	CBI  0x18,3
	RET
; .FEND
_ks0108_rdbus_G102:
; .FSTART _ks0108_rdbus_G102
	ST   -Y,R17
	RCALL _ks0108_enable_G102
	IN   R17,25
	CBI  0x18,2
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G102:
; .FSTART _ks0108_busy_G102
	ST   -Y,R26
	ST   -Y,R17
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	CBI  0x18,0
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2040003
	SBI  0x18,4
	RJMP _0x2040004
_0x2040003:
	CBI  0x18,4
_0x2040004:
	SBRS R17,1
	RJMP _0x2040005
	SBI  0x18,3
	RJMP _0x2040006
_0x2040005:
	CBI  0x18,3
_0x2040006:
_0x2040007:
	RCALL _ks0108_rdbus_G102
	ANDI R30,LOW(0x80)
	BRNE _0x2040007
	LDD  R17,Y+0
	RJMP _0x2180011
; .FEND
_ks0108_wrcmd_G102:
; .FSTART _ks0108_wrcmd_G102
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G102
	CALL SUBOPT_0x10
	RJMP _0x2180011
; .FEND
_ks0108_setloc_G102:
; .FSTART _ks0108_setloc_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	__GETB1MN _ks0108_coord_G102,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G102,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G102
	RET
; .FEND
_ks0108_gotoxp_G102:
; .FSTART _ks0108_gotoxp_G102
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G102,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G102,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G102,2
	RCALL _ks0108_setloc_G102
	RJMP _0x2180011
; .FEND
_ks0108_nextx_G102:
; .FSTART _ks0108_nextx_G102
	LDS  R26,_ks0108_coord_G102
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G102,R26
	CPI  R26,LOW(0x80)
	BRLO _0x204000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G102,R30
_0x204000A:
	LDS  R30,_ks0108_coord_G102
	ANDI R30,LOW(0x3F)
	BRNE _0x204000B
	LDS  R30,_ks0108_coord_G102
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G102,2
	RCALL _ks0108_gotoxp_G102
_0x204000B:
	RET
; .FEND
_ks0108_wrdata_G102:
; .FSTART _ks0108_wrdata_G102
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	SBI  0x18,0
	CALL SUBOPT_0x10
	ADIW R28,1
	RET
; .FEND
_ks0108_rddata_G102:
; .FSTART _ks0108_rddata_G102
	__GETB2MN _ks0108_coord_G102,1
	RCALL _ks0108_busy_G102
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	SBI  0x18,1
	SBI  0x18,0
	RCALL _ks0108_rdbus_G102
	RET
; .FEND
_ks0108_rdbyte_G102:
; .FSTART _ks0108_rdbyte_G102
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x11
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	RCALL _ks0108_rddata_G102
_0x2180011:
	ADIW R28,2
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,2
	SBI  0x17,1
	SBI  0x17,0
	SBI  0x17,5
	SBI  0x18,5
	SBI  0x17,4
	SBI  0x17,3
	RCALL _ks0108_disable_G102
	CBI  0x18,5
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,5
	LDI  R17,LOW(0)
_0x204000C:
	CPI  R17,2
	BRSH _0x204000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G102
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G102
	RJMP _0x204000C
_0x204000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x204000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20400AC
_0x204000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20400AC:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
_0x2180010:
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2040015
	LDI  R16,LOW(255)
_0x2040015:
_0x2040016:
	CPI  R19,8
	BRSH _0x2040018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G102
	LDI  R17,LOW(0)
_0x2040019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x204001B
	MOV  R26,R16
	CALL SUBOPT_0x12
	RJMP _0x2040019
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G102
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
_0x218000F:
	ADIW R28,4
	RET
; .FEND
_ks0108_wrmasked_G102:
; .FSTART _ks0108_wrmasked_G102
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G102
	MOV  R17,R30
	RCALL _ks0108_setloc_G102
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x204002B
	CPI  R30,LOW(0x8)
	BRNE _0x204002C
_0x204002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x204002D
_0x204002C:
	CPI  R30,LOW(0x3)
	BRNE _0x204002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2040030
_0x204002F:
	CPI  R30,0
	BRNE _0x2040031
_0x2040030:
_0x204002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040032
_0x2040031:
	CPI  R30,LOW(0x2)
	BRNE _0x2040033
_0x2040032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2040029
_0x2040033:
	CPI  R30,LOW(0x1)
	BRNE _0x2040034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2040029
_0x2040034:
	CPI  R30,LOW(0x4)
	BRNE _0x2040029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2040029:
	MOV  R26,R17
	CALL SUBOPT_0x12
	LDD  R17,Y+0
_0x218000E:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2040037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2040037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2040037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2040036
_0x2040037:
	RJMP _0x218000D
_0x2040036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2040039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2040039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x204003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x204003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x204003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x204003F
	RJMP _0x218000D
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040041
	RJMP _0x218000D
_0x2040041:
_0x2040042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2040044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2040043
_0x2040044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x13
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2040046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2040048
	MOV  R17,R16
_0x2040049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204004B
	CALL SUBOPT_0x14
	RJMP _0x2040049
_0x204004B:
	RJMP _0x2040046
_0x2040048:
_0x2040043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x204004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x13
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x204004D
	SUBI R19,-LOW(1)
_0x204004D:
	LDI  R18,LOW(0)
_0x204004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2040050
	LDD  R17,Y+14
_0x2040051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2040053
	CALL SUBOPT_0x14
	RJMP _0x2040051
_0x2040053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x13
	RJMP _0x204004E
_0x2040050:
_0x204004C:
_0x204003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2040054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2040057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2040058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x204005D
	CPI  R30,LOW(0x3)
	BRNE _0x204005E
_0x204005D:
	RJMP _0x204005F
_0x204005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2040060
_0x204005F:
	RJMP _0x2040061
_0x2040060:
	CPI  R30,LOW(0x8)
	BRNE _0x2040062
_0x2040061:
	RJMP _0x2040063
_0x2040062:
	CPI  R30,LOW(0x6)
	BRNE _0x2040064
_0x2040063:
	RJMP _0x2040065
_0x2040064:
	CPI  R30,LOW(0x9)
	BRNE _0x2040066
_0x2040065:
	RJMP _0x2040067
_0x2040066:
	CPI  R30,LOW(0xA)
	BRNE _0x204005B
_0x2040067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x11
_0x204005B:
_0x2040069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x204006C
	RCALL _ks0108_rddata_G102
	RCALL _ks0108_setloc_G102
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G102
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G102
	RJMP _0x204006D
_0x204006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2040071
	LDI  R21,LOW(0)
	RJMP _0x2040072
_0x2040071:
	CPI  R30,LOW(0xA)
	BRNE _0x2040070
	LDI  R21,LOW(255)
	RJMP _0x2040072
_0x2040070:
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2040079
	CPI  R30,LOW(0x8)
	BRNE _0x204007A
_0x2040079:
_0x2040072:
	CALL SUBOPT_0x17
	MOV  R21,R30
	RJMP _0x204007B
_0x204007A:
	CPI  R30,LOW(0x3)
	BRNE _0x204007D
	COM  R21
	RJMP _0x204007E
_0x204007D:
	CPI  R30,0
	BRNE _0x2040080
_0x204007E:
_0x204007B:
	MOV  R26,R21
	CALL SUBOPT_0x12
	RJMP _0x2040077
_0x2040080:
	CALL SUBOPT_0x18
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
_0x2040077:
_0x204006D:
	RJMP _0x2040069
_0x204006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2040081
_0x2040058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040082
_0x2040057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2040083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040084
_0x2040083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2040084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040088
_0x2040089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x204008B
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x1A
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2040089
_0x204008B:
	RJMP _0x2040087
_0x2040088:
	CPI  R30,LOW(0x9)
	BRNE _0x204008C
	LDI  R21,LOW(0)
	RJMP _0x204008D
_0x204008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2040093
	LDI  R21,LOW(255)
_0x204008D:
	CALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2040090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040092
	CALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040090
_0x2040092:
	RJMP _0x2040087
_0x2040093:
_0x2040094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2040096
	CALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x2040094
_0x2040096:
_0x2040087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2040097
	RJMP _0x2040056
_0x2040097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2040098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20400AD
_0x2040098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20400AD:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204009D
_0x204009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A0
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x1A
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x204009E
_0x20400A0:
	RJMP _0x204009C
_0x204009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20400A1
	LDI  R21,LOW(0)
	RJMP _0x20400A2
_0x20400A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20400A8
	LDI  R21,LOW(255)
_0x20400A2:
	CALL SUBOPT_0x17
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20400A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400A7
	CALL SUBOPT_0x18
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A5
_0x20400A7:
	RJMP _0x204009C
_0x20400A8:
_0x20400A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20400AB
	CALL SUBOPT_0x1B
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G102
	RJMP _0x20400A9
_0x20400AB:
_0x204009C:
_0x2040081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040054
_0x2040056:
_0x218000D:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x1C
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2180005
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2180005
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2180005
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x1C
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2180005
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2060006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2180005
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2180005
; .FEND
_glcd_imagesize:
; .FSTART _glcd_imagesize
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x80)
	BRSH _0x2060008
	LDD  R26,Y+1
	CPI  R26,LOW(0x40)
	BRLO _0x2060007
_0x2060008:
	__GETD1N 0x0
	LDD  R17,Y+0
	JMP  _0x2180004
_0x2060007:
	LDD  R30,Y+1
	ANDI R30,LOW(0x7)
	MOV  R17,R30
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	STD  Y+1,R30
	CPI  R17,0
	BREQ _0x206000A
	SUBI R30,-LOW(1)
	STD  Y+1,R30
_0x206000A:
	LDD  R26,Y+2
	CLR  R27
	CLR  R24
	CLR  R25
	LDD  R30,Y+1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12U
	__ADDD1N 4
	LDD  R17,Y+0
	JMP  _0x2180004
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x1D
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x218000C
_0x206000B:
	CALL SUBOPT_0x1E
	STD  Y+7,R0
	CALL SUBOPT_0x1E
	STD  Y+6,R0
	CALL SUBOPT_0x1E
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x218000C
_0x206000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x206000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x218000C
_0x206000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x218000C
_0x206000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x218000C:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x1F
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x1D
	SBIW R30,0
	BRNE PC+2
	RJMP _0x206001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060020
	RJMP _0x2060021
_0x2060020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060022
	RJMP _0x218000A
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x1F
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x1F
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x20
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x218000A
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x218000A:
	CALL __LOADLOCR6
_0x218000B:
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2060025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2060025
_0x2060027:
	LDD  R17,Y+0
	JMP  _0x2180006
; .FEND
_glcd_putimagef:
; .FSTART _glcd_putimagef
	ST   -Y,R26
	CALL __SAVELOCR4
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRSH _0x2060038
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	LPM  R16,Z+
	CALL SUBOPT_0x21
	LPM  R17,Z+
	CALL SUBOPT_0x21
	LPM  R18,Z+
	CALL SUBOPT_0x21
	LPM  R19,Z+
	STD  Y+5,R30
	STD  Y+5+1,R31
	LDD  R30,Y+8
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+11
	RCALL _glcd_block
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_imagesize
	RJMP _0x2180009
_0x2060038:
	__GETD1N 0x0
_0x2180009:
	CALL __LOADLOCR4
	ADIW R28,9
	RET
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2180005
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G105:
; .FSTART _put_buff_G105
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20A0010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x20A0012
	__CPWRN 16,17,2
	BRLO _0x20A0013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x20A0012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x22
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x20A0013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x20A0014
	CALL SUBOPT_0x22
_0x20A0014:
	RJMP _0x20A0015
_0x20A0010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x20A0015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2180006
; .FEND
__ftoe_G105:
; .FSTART __ftoe_G105
	CALL SUBOPT_0x23
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A0019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20A0000,0
	CALL _strcpyf
	RJMP _0x2180008
_0x20A0019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A0018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x20A0000,1
	CALL _strcpyf
	RJMP _0x2180008
_0x20A0018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x20A001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x20A001B:
	LDD  R17,Y+11
_0x20A001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001E
	CALL SUBOPT_0x24
	RJMP _0x20A001C
_0x20A001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x20A001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x24
	RJMP _0x20A0020
_0x20A001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x25
	BREQ PC+2
	BRCC PC+2
	RJMP _0x20A0021
	CALL SUBOPT_0x24
_0x20A0022:
	CALL SUBOPT_0x25
	BRLO _0x20A0024
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
	RJMP _0x20A0022
_0x20A0024:
	RJMP _0x20A0025
_0x20A0021:
_0x20A0026:
	CALL SUBOPT_0x25
	BRSH _0x20A0028
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	SUBI R19,LOW(1)
	RJMP _0x20A0026
_0x20A0028:
	CALL SUBOPT_0x24
_0x20A0025:
	__GETD1S 12
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
	CALL SUBOPT_0x25
	BRLO _0x20A0029
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
_0x20A0029:
_0x20A0020:
	LDI  R17,LOW(0)
_0x20A002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x20A002C
	__GETD2S 4
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x26
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x26
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x29
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x20A002A
	CALL SUBOPT_0x2C
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x20A002A
_0x20A002C:
	CALL SUBOPT_0x2F
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x20A002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x20A0113
_0x20A002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x20A0113:
	ST   X,R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x2F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x2F
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2180008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G105:
; .FSTART __print_G105
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x20A0030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x22
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20A0032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x20A0036
	CPI  R18,37
	BRNE _0x20A0037
	LDI  R17,LOW(1)
	RJMP _0x20A0038
_0x20A0037:
	CALL SUBOPT_0x30
_0x20A0038:
	RJMP _0x20A0035
_0x20A0036:
	CPI  R30,LOW(0x1)
	BRNE _0x20A0039
	CPI  R18,37
	BRNE _0x20A003A
	CALL SUBOPT_0x30
	RJMP _0x20A0114
_0x20A003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x20A003B
	LDI  R16,LOW(1)
	RJMP _0x20A0035
_0x20A003B:
	CPI  R18,43
	BRNE _0x20A003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x20A0035
_0x20A003C:
	CPI  R18,32
	BRNE _0x20A003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x20A0035
_0x20A003D:
	RJMP _0x20A003E
_0x20A0039:
	CPI  R30,LOW(0x2)
	BRNE _0x20A003F
_0x20A003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x20A0040
	ORI  R16,LOW(128)
	RJMP _0x20A0035
_0x20A0040:
	RJMP _0x20A0041
_0x20A003F:
	CPI  R30,LOW(0x3)
	BRNE _0x20A0042
_0x20A0041:
	CPI  R18,48
	BRLO _0x20A0044
	CPI  R18,58
	BRLO _0x20A0045
_0x20A0044:
	RJMP _0x20A0043
_0x20A0045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x20A0035
_0x20A0043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x20A0046
	LDI  R17,LOW(4)
	RJMP _0x20A0035
_0x20A0046:
	RJMP _0x20A0047
_0x20A0042:
	CPI  R30,LOW(0x4)
	BRNE _0x20A0049
	CPI  R18,48
	BRLO _0x20A004B
	CPI  R18,58
	BRLO _0x20A004C
_0x20A004B:
	RJMP _0x20A004A
_0x20A004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x20A0035
_0x20A004A:
_0x20A0047:
	CPI  R18,108
	BRNE _0x20A004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x20A0035
_0x20A004D:
	RJMP _0x20A004E
_0x20A0049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x20A0035
_0x20A004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x20A0053
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	CALL SUBOPT_0x31
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x33
	RJMP _0x20A0054
_0x20A0053:
	CPI  R30,LOW(0x45)
	BREQ _0x20A0057
	CPI  R30,LOW(0x65)
	BRNE _0x20A0058
_0x20A0057:
	RJMP _0x20A0059
_0x20A0058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x20A005A
_0x20A0059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x34
	CALL __GETD1P
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	LDD  R26,Y+13
	TST  R26
	BRMI _0x20A005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x20A005D
	CPI  R26,LOW(0x20)
	BREQ _0x20A005F
	RJMP _0x20A0060
_0x20A005B:
	CALL SUBOPT_0x37
	CALL __ANEGF1
	CALL SUBOPT_0x35
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x20A005D:
	SBRS R16,7
	RJMP _0x20A0061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x33
	RJMP _0x20A0062
_0x20A0061:
_0x20A005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x20A0062:
_0x20A0060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x20A0064
	CALL SUBOPT_0x37
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x20A0065
_0x20A0064:
	CALL SUBOPT_0x37
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G105
_0x20A0065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x38
	RJMP _0x20A0066
_0x20A005A:
	CPI  R30,LOW(0x73)
	BRNE _0x20A0068
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	RJMP _0x20A0069
_0x20A0068:
	CPI  R30,LOW(0x70)
	BRNE _0x20A006B
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x20A0069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x20A006D
	CP   R20,R17
	BRLO _0x20A006E
_0x20A006D:
	RJMP _0x20A006C
_0x20A006E:
	MOV  R17,R20
_0x20A006C:
_0x20A0066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x20A006F
_0x20A006B:
	CPI  R30,LOW(0x64)
	BREQ _0x20A0072
	CPI  R30,LOW(0x69)
	BRNE _0x20A0073
_0x20A0072:
	ORI  R16,LOW(4)
	RJMP _0x20A0074
_0x20A0073:
	CPI  R30,LOW(0x75)
	BRNE _0x20A0075
_0x20A0074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x20A0076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x3A
	LDI  R17,LOW(10)
	RJMP _0x20A0077
_0x20A0076:
	__GETD1N 0x2710
	CALL SUBOPT_0x3A
	LDI  R17,LOW(5)
	RJMP _0x20A0077
_0x20A0075:
	CPI  R30,LOW(0x58)
	BRNE _0x20A0079
	ORI  R16,LOW(8)
	RJMP _0x20A007A
_0x20A0079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20A00B8
_0x20A007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x20A007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x3A
	LDI  R17,LOW(8)
	RJMP _0x20A0077
_0x20A007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x3A
	LDI  R17,LOW(4)
_0x20A0077:
	CPI  R20,0
	BREQ _0x20A007D
	ANDI R16,LOW(127)
	RJMP _0x20A007E
_0x20A007D:
	LDI  R20,LOW(1)
_0x20A007E:
	SBRS R16,1
	RJMP _0x20A007F
	CALL SUBOPT_0x36
	CALL SUBOPT_0x34
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20A0115
_0x20A007F:
	SBRS R16,2
	RJMP _0x20A0081
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
	CALL __CWD1
	RJMP _0x20A0115
_0x20A0081:
	CALL SUBOPT_0x36
	CALL SUBOPT_0x39
	CLR  R22
	CLR  R23
_0x20A0115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x20A0083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x20A0084
	CALL SUBOPT_0x37
	CALL __ANEGD1
	CALL SUBOPT_0x35
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x20A0084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x20A0085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x20A0086
_0x20A0085:
	ANDI R16,LOW(251)
_0x20A0086:
_0x20A0083:
	MOV  R19,R20
_0x20A006F:
	SBRC R16,0
	RJMP _0x20A0087
_0x20A0088:
	CP   R17,R21
	BRSH _0x20A008B
	CP   R19,R21
	BRLO _0x20A008C
_0x20A008B:
	RJMP _0x20A008A
_0x20A008C:
	SBRS R16,7
	RJMP _0x20A008D
	SBRS R16,2
	RJMP _0x20A008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x20A008F
_0x20A008E:
	LDI  R18,LOW(48)
_0x20A008F:
	RJMP _0x20A0090
_0x20A008D:
	LDI  R18,LOW(32)
_0x20A0090:
	CALL SUBOPT_0x30
	SUBI R21,LOW(1)
	RJMP _0x20A0088
_0x20A008A:
_0x20A0087:
_0x20A0091:
	CP   R17,R20
	BRSH _0x20A0093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20A0094
	CALL SUBOPT_0x3B
	BREQ _0x20A0095
	SUBI R21,LOW(1)
_0x20A0095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x20A0094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x20A0096
	SUBI R21,LOW(1)
_0x20A0096:
	SUBI R20,LOW(1)
	RJMP _0x20A0091
_0x20A0093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x20A0097
_0x20A0098:
	CPI  R19,0
	BREQ _0x20A009A
	SBRS R16,3
	RJMP _0x20A009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20A009C
_0x20A009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20A009C:
	CALL SUBOPT_0x30
	CPI  R21,0
	BREQ _0x20A009D
	SUBI R21,LOW(1)
_0x20A009D:
	SUBI R19,LOW(1)
	RJMP _0x20A0098
_0x20A009A:
	RJMP _0x20A009E
_0x20A0097:
_0x20A00A0:
	CALL SUBOPT_0x3C
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20A00A2
	SBRS R16,3
	RJMP _0x20A00A3
	SUBI R18,-LOW(55)
	RJMP _0x20A00A4
_0x20A00A3:
	SUBI R18,-LOW(87)
_0x20A00A4:
	RJMP _0x20A00A5
_0x20A00A2:
	SUBI R18,-LOW(48)
_0x20A00A5:
	SBRC R16,4
	RJMP _0x20A00A7
	CPI  R18,49
	BRSH _0x20A00A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20A00A8
_0x20A00A9:
	RJMP _0x20A00AB
_0x20A00A8:
	CP   R20,R19
	BRSH _0x20A0116
	CP   R21,R19
	BRLO _0x20A00AE
	SBRS R16,0
	RJMP _0x20A00AF
_0x20A00AE:
	RJMP _0x20A00AD
_0x20A00AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20A00B0
_0x20A0116:
	LDI  R18,LOW(48)
_0x20A00AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20A00B1
	CALL SUBOPT_0x3B
	BREQ _0x20A00B2
	SUBI R21,LOW(1)
_0x20A00B2:
_0x20A00B1:
_0x20A00B0:
_0x20A00A7:
	CALL SUBOPT_0x30
	CPI  R21,0
	BREQ _0x20A00B3
	SUBI R21,LOW(1)
_0x20A00B3:
_0x20A00AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x3C
	CALL __MODD21U
	CALL SUBOPT_0x35
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x3A
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20A00A1
	RJMP _0x20A00A0
_0x20A00A1:
_0x20A009E:
	SBRS R16,0
	RJMP _0x20A00B4
_0x20A00B5:
	CPI  R21,0
	BREQ _0x20A00B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x33
	RJMP _0x20A00B5
_0x20A00B7:
_0x20A00B4:
_0x20A00B8:
_0x20A0054:
_0x20A0114:
	LDI  R17,LOW(0)
_0x20A0035:
	RJMP _0x20A0030
_0x20A0032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x3D
	SBIW R30,0
	BRNE _0x20A00B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2180007
_0x20A00B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x3D
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G105)
	LDI  R31,HIGH(_put_buff_G105)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G105
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2180007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2180006:
	ADIW R28,5
	RET
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2180005:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2180004
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2180004
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2180004
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2180004
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2180004
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2180004
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2180004
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2180004:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
	JMP  _0x2180003
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2180003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2180003:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x23
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x216000D
	RCALL SUBOPT_0x3E
	__POINTW2FN _0x2160000,0
	CALL _strcpyf
	RJMP _0x2180002
_0x216000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x216000C
	RCALL SUBOPT_0x3E
	__POINTW2FN _0x2160000,1
	CALL _strcpyf
	RJMP _0x2180002
_0x216000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x216000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	LDI  R30,LOW(45)
	ST   X,R30
_0x216000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2160010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2160010:
	LDD  R17,Y+8
_0x2160011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2160013
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x42
	RJMP _0x2160011
_0x2160013:
	RCALL SUBOPT_0x43
	CALL __ADDF12
	RCALL SUBOPT_0x3F
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x42
_0x2160014:
	RCALL SUBOPT_0x43
	CALL __CMPF12
	BRLO _0x2160016
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x42
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2160017
	RCALL SUBOPT_0x3E
	__POINTW2FN _0x2160000,5
	CALL _strcpyf
	RJMP _0x2180002
_0x2160017:
	RJMP _0x2160014
_0x2160016:
	CPI  R17,0
	BRNE _0x2160018
	RCALL SUBOPT_0x40
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2160019
_0x2160018:
_0x216001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x216001C
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2A
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x2D
	LDI  R31,0
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x3
	CALL __MULF12
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x3F
	RJMP _0x216001A
_0x216001C:
_0x2160019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2180001
	RCALL SUBOPT_0x40
	LDI  R30,LOW(46)
	ST   X,R30
_0x216001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2160020
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3F
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x2D
	LDI  R31,0
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x3F
	RJMP _0x216001E
_0x2160020:
_0x2180001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2180002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_t1:
	.BYTE 0x10
_t2:
	.BYTE 0x10
_t3:
	.BYTE 0x10
_b:
	.BYTE 0x4
_ks0108_coord_G102:
	.BYTE 0x3
__seed_G10B:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R7
	JMP  _rtc_set_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	LDI  R30,LOW(35)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R26,_b
	LDS  R27,_b+1
	LDS  R24,_b+2
	LDS  R25,_b+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	CALL _i2c_write
	LDI  R26,LOW(0)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LSL  R30
	ORI  R30,LOW(0x90)
	MOV  R17,R30
	CALL _i2c_start
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOV  R26,R30
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	CALL _i2c_stop
	CALL _i2c_start
	LDI  R26,LOW(209)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	CALL _bin2bcd
	MOV  R26,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	CBI  0x18,1
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G102
	JMP  _ks0108_disable_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _ks0108_wrdata_G102
	JMP  _ks0108_nextx_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G102
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	STD  Y+5,R30
	STD  Y+5+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	__GETD2S 4
	RCALL SUBOPT_0x4
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x25:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x27:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x30:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x31:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x32:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x33:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x34:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x31
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x34
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3B:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x40:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,2
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,3
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
