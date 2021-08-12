TITLE Project 6 - String Primitives and Macros     (Proj6_baxs.asm)

; Author: Scott Bax
; Last Modified: 10 Aug 2021
; OSU email address: baxs@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project 6    Due Date: 13 Aug 2021
; Description: 
;		
;		
;		

INCLUDE Irvine32.inc

;intro macro
introduction MACRO intro1, intro2
	PUSH		EDX
  ; title, name and description of program
	MOV			EDX, intro1
	CALL		WriteString
	CALL		Crlf
	CALL		Crlf

	MOV			EDX, intro2
	CALL		WriteString
	CALL		Crlf
	POP			EDX
ENDM


mGetString MACRO prompt, userInput, bytesRead, count
	PUSH		EDX
	PUSH		ECX
	PUSH		EAX
  ; prompt
	MOV			EDX, prompt
	CALL		WriteString
	CALL		Crlf

	MOV			EDX, userInput
	MOV			ECX, count
	call		ReadString
	MOV			userInput, EDX
	MOV			bytesRead, EAX
	POP			EAX
	POP			ECX
	POP			EDX
ENDM

mDisplayString MACRO passedString
	PUSH		EDX
  ; title, name and description of program
	MOV			EDX, passedString
	CALL		WriteString

	POP			EDX
ENDM


; Integer Constants
ARRAYSIZE = 2

.data

; Intro variables
nameAndTitle	BYTE	"Scott Bax - Project 6 - String Primitives and Macros", 0
description		BYTE	"This program will ", 10, 13
				BYTE	"x", 10, 13
				BYTE	"y", 10, 13
				BYTE	"z", 10, 13, 0
userNumber		SDWORD	?
userNumberSize  SDWORD	?
userInteger		SDWORD	?
intToString		SDWORD	?
sign			SDWORD	?

; Array variables	
intArray		SDWORD	ARRAYSIZE DUP(?)


; Data variables
; 2147483647


; Display variables	
enterNumber		BYTE	"Please enter a number that is signed: ", 0
numbersEntered	BYTE	"Here are the numbers you entered: ", 0
wrongNumber		BYTE	"Not a signed number or number too big.", 0
space			BYTE	" ", 0

.code
main PROC

; inroduction MACRO
introduction OFFSET nameAndTitle, OFFSET description


MOV		EDI, OFFSET intArray
MOV		ECX, ARRAYSIZE
; Integer Loop
_integerLoop:
		
		; Gets the user string and converts it to a number
		PUSH		OFFSET sign	
		PUSH		OFFSET wrongNumber				
		PUSH		OFFSET userInteger			; return number address
		PUSH		OFFSET userNumberSize
		PUSH		OFFSET userNumber
		PUSH		OFFSET enterNumber
		CALL		Readval
		MOV			EBX, 0
		MOV			EBX, userInteger
		MOV			[EDI], EBX



		
		ADD		EDI, 4
		
		LOOP	_integerLoop


; -------------------------
; Display ARRAY Integers 
; -------------------------

CALL	Crlf
MOV		EDX, OFFSET numbersEntered
CALL	WriteString					; display variables
CALL	Crlf

;
MOV		EDI, OFFSET intArray
MOV		ECX, ARRAYSIZE				; loop variables
displayLoop:
		
		; pass array item into WriteDec
		MOV		EAX, [EDI]
				; converts number to string
		PUSH	OFFSET intToString			; address used in proc
		PUSH	EAX
		CALL	Writeval
		MOV		EDX, OFFSET space
		call	WriteString
		ADD		EDI, 4

		LOOP displayLoop
CALL	Crlf

; -------------------------
; Calc/Display Sum 
; -------------------------


; -------------------------
; Calc/Display Average
; -------------------------
	

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values. EDI changed.
;
; Receives:	randArray (reference/input-output), ARRAYSIZE/HI/LO (value/input).
;
; Returns: memory variable returned in EAX
; ---------------------------------------------------------------------------------
Readval PROC
	LOCAL		userNumberProc: SDWORD, userNumberSizeProc: SDWORD, enterNumberProc: SDWORD, userIntegerProc: SDWORD, wrongNumProc: SDWORD, signProc: SDWORD


	; preserver registers
	PUSH		EAX
	PUSH		ECX
	PUSH		EBX
	PUSH		EDX
	PUSH		EDI
	PUSH		ESI

	

	MOV		EDX, [EBP + 8]
	MOV		enterNumberProc, EDX

	MOV		EDX, [EBP + 12]
	MOV		userNumberProc, EDX

	MOV		EDX, [EBP + 16]
	MOV		userNumberSizeProc, EDX

	MOV		EDX, [EBP + 20]
	MOV		userIntegerProc, EDX

	MOV		EDX, [EBP + 24]
	MOV		wrongNumProc, EDX

	MOV		EDX, [EBP + 28]
	MOV		signProc, EDX
	
	JMP		_skippWrongMessage

	
	_setPlus:
		PUSH	EDX
		PUSH	EAX
		MOV		EDX, signProc
		MOV		EAX, 43
		MOV		[EDX], EAX
		POP		EAX
		POP		EDX
		JMP		_plusOrMinus

	_setMinus:
		PUSH	EDX
		PUSH	EAX
		MOV		EDX, signProc
		MOV		EAX, 45
		MOV		[EDX], EAX
		POP		EAX
		POP		EDX
		JMP		_plusOrMinus
		
	
	_tryAgain:
		PUSH	EDX
		MOV		EDX, wrongNumProc
		CALL	WriteString
		CALL	Crlf
		POP		EDX

	_skippWrongMessage:
	; get user input
	mGetString enterNumberProc, userNumberProc, userNumberSizeProc, 33

	MOV		ESI, userNumberProc
	MOV		EDI, userIntegerProc
	MOV		ECX, userNumberSizeProc
	MOV		EBX, 0

	
	; transform correct values into integer
	_checkChar:
		MOV		EAX, 0
		LODSB
		SUB		AL, 48


		;look for positive or negative
		CMP		EAX, 253				;minus
		JE		_setMinus
		
		CMP		EAX, 251				;plus
		JE		_setPlus

		; check for wrong characters
		CMP		EAX, 9
		JA		_tryAgain
		
		; continue on
		PUSH	ECX
		SUB		ECX, 1
		PUSH	EBX
		cmp		ECX, 0
		JE		skipped
		_int:
			MOV EBX, 10
			IMUL EBX
			
			LOOP _int
		skipped:
		POP EBX
		POP ECX
		
		ADD EBX, EAX

		; plus or minus found
		_plusOrMinus:

		LOOP _checkChar

	MOV EAX, userNumberSizeProc
	MOV EDX, userIntegerProc
	
	CMP	EBX, 2147483647
	JA	_tryAgain

	; Add sign if there is one
		PUSH	EDX
		PUSH	EAX
		MOV		EDX, signProc
		MOV		EAX, [EDX]
		
		CMP     EAX, 45
		JNE		_noSIgn

		;make negative 
		imul	EBX, -1	

		MOV		EAX, 0
		MOV		[EDX], EAX			; reset sign

		_noSIgn:
		POP		EAX
		POP		EDX



	MOV [EDX], EBX
	MOV ECX, userNumberSizeProc
	MOV EDX, [EBP + 16]
	MOV [EDX], ECX
	; restore registers
	POP			ESI
	POP			EDI
	POP			EDX
	POP			EBX
	POP			ECX
	POP			EAX
	
	RET 24
Readval ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values. EDI changed.
;
; Receives:	randArray (reference/input-output), ARRAYSIZE/HI/LO (value/input).
;
; Returns: memory variable returned in EAX
; ---------------------------------------------------------------------------------
Writeval PROC
	LOCAL		intToStringProc: SDWORD, outToStringProc: SDWORD, stringSize: SDWORD


	; preserver registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDX
	PUSH		EDI
	
	MOV			EAX, [EBP + 12]
	MOV			outToStringProc, EAX

	MOV			EDX, [EBP + 8]
	
	;check if negative
	CMP			EDX, 0
	JGE			_notNeg
		imul	EDX, -1	
	
	_notNeg:
		MOV			intToStringProc, EDX
	


	MOV			EDI, outToStringProc

	MOV			EAX, EDX
	
	
	MOV			ECX, 1
	STD
	_intToStringLoop:

		MOV		EBX, 10
		CDQ
		idiv	EBX

		cmp EDX, 0
		
		; if remainder is zero, go to second check to see if int is done
		JE _skipped1
		_skippedBack:
		ADD ECX, 1
		
		
		MOV		EBX, 0
		PUSH EAX
		MOV		EAX, EDX
		ADD		EAX, 48
		
		STOSB
		
		POP EAX
		
		LOOP _intToStringLoop

	; special case if there is a digit with a zero, does not terminate wrongly
	JMP _skipOver
	_skipped1:
		cmp EAX, 0
		JNE _skippedBack
		cmp intToStringProc, 0
		
		JE	_skippedBack			; single zero case

	_skipOver:
	CLD
	MOV outToStringProc, EDI
	ADD outToStringProc, 1
	mDisplayString outToStringProc
	;call WriteString
	
	POP			EDI
	POP			EDX
	POP			ECX
	POP			EBX
	POP			EAX


	RET 8
Writeval ENDP

END main
