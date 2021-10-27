TITLE String Primitives and Macros


; Description: Program that uses macros and procedurs to validate and get 10 signed integers from 
;		a user, store them in an array, display them, and provide the sum and average of all numbers
;		

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Introduced program to user with two messages
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
; intro1 = display programmer name and title of program
; intro2 = displays description of program
;
; returns: None
; ---------------------------------------------------------------------------------
introduction MACRO intro1, intro2
	PUSH		EDX
  ; title, name and description of program
	MOV			EDX, intro1
	CALL		WriteString
	CALL		Crlf
	CALL		Crlf

	; program description
	MOV			EDX, intro2
	CALL		WriteString
	CALL		Crlf
	POP			EDX
ENDM

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Gets string from user and converts it to a signed number
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
; prompt = display message asking for number, passed by reference
; userInput = variable to hold user message passed by reference
; bytesRead = holds size of number passed by reference
; count = size the number can be passed by value
;
; returns: 
; userInput = user number is at passed address
; bytesRead = size is at passed address
; ---------------------------------------------------------------------------------
mGetString MACRO prompt, userInput, bytesRead, count
	PUSH		EDX
	PUSH		ECX
	PUSH		EAX
	
	; prompt
	MOV			EDX, prompt
	CALL		WriteString
	CALL		Crlf

	; read string
	MOV			EDX, userInput
	MOV			ECX, count
	call		ReadString

	; store numbers
	MOV			userInput, EDX
	MOV			bytesRead, EAX

	POP			EAX
	POP			ECX
	POP			EDX
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Displays a passed string.
;
; Preconditions: do not use eax, ecx, esi as arguments
;
; Receives:
; passedString = the string needing to be displayed passed by reference. 
;
; returns: None. 
; ---------------------------------------------------------------------------------
mDisplayString MACRO passedString
	PUSH		EDX

  ; Displays string
	MOV			EDX, passedString
	CALL		WriteString

	POP			EDX
ENDM


; Integer Constants
ARRAYSIZE = 10

.data

; Intro variables
nameAndTitle	BYTE	"Scott Bax - Project 6 - String Primitives and Macros", 0
description		BYTE	"This program will take 10 signed numbers as strings and convert them to integers. ", 10, 13
				BYTE	"It will store all numbers in an array and calculate the sum and average of all the numbers. ", 10, 13
				BYTE	"Finally, the sum/average, including the array will be printed out.", 10, 13

; data variables
userNumber		SDWORD	?
userNumberSize  SDWORD	?
userInteger		SDWORD	?
intToString		SDWORD	?
sign			SDWORD	?

; Array variables	
intArray		SDWORD	ARRAYSIZE DUP(?)


; Display variables	
enterNumber		BYTE	"Please enter a number that is signed: ", 0
numbersEntered	BYTE	"Here are the numbers you entered: ", 0
wrongNumber		BYTE	"Not a signed number or number too big.", 0
space			BYTE	" ", 0
sumMessage		BYTE	"The sum off theses numbers is: ", 0
averageMessage	BYTE	"The rounded average off theses numbers is: ", 0
bye				BYTE	"See ya!", 0

.code
main PROC

; Call inroduction MACRO
introduction OFFSET nameAndTitle, OFFSET description


; -------------------------
; Get Integers and store in Array. 
; -------------------------
MOV		EDI, OFFSET intArray
MOV		ECX, ARRAYSIZE
_integerLoop:
		
		; Gets the user string and converts it to a number
		PUSH		OFFSET sign	
		PUSH		OFFSET wrongNumber				
		PUSH		OFFSET userInteger			; return number address
		PUSH		OFFSET userNumberSize
		PUSH		OFFSET userNumber
		PUSH		OFFSET enterNumber
		CALL		Readval						; Proc Call

		; store in array
		MOV			EBX, 0
		MOV			EBX, userInteger
		MOV			[EDI], EBX


		ADD		EDI, 4
		
		LOOP	_integerLoop


; -------------------------
; Display Array Integers 
; -------------------------

CALL	Crlf
MOV		EDX, OFFSET numbersEntered
CALL	WriteString					; display message
CALL	Crlf

; set up loop
MOV		EDI, OFFSET intArray
MOV		ECX, ARRAYSIZE				; loop variables
displayLoop:
		
		; pass array item into WriteDec
		MOV		EAX, [EDI]
		
		; set up and use Writeval PROC
		PUSH	OFFSET intToString			; address used in proc
		PUSH	EAX
		CALL	Writeval

		; add a space between numbers
		MOV		EDX, OFFSET space
		call	WriteString
		ADD		EDI, 4

		LOOP displayLoop
CALL	Crlf

; -------------------------
; Calc/Display Sum 
; -------------------------

; set up loop
MOV		EDI, OFFSET intArray
MOV		ECX, ARRAYSIZE				
addLoop:
		
		; grab array item
		MOV		EAX, [EDI]
		
		; add up continually
		ADD		EBX, EAX	
		
		; move along the index
		ADD		EDI, 4

		LOOP addLoop

; Display message
MOV		EDX, OFFSET sumMessage
call	WriteString
CALL	Crlf						

; use Writeval PROC to display sum
PUSH	OFFSET intToString			
PUSH	EBX
CALL	Writeval
CALL	Crlf

; -------------------------
; Calc/Display Average
; -------------------------
; 

; display message
MOV		EDX, OFFSET averageMessage
call	WriteString
CALL	Crlf

; divide for average
MOV		EAX, EBX
MOV		EBX, 10
CDQ
idiv	EBX

; display average
PUSH	OFFSET intToString			; address used in proc
PUSH	EAX
CALL	Writeval
CALL	Crlf
CALL	Crlf

; -------------------------
; Bye Message
; -------------------------
MOV		EDX, OFFSET bye
call	WriteString
CALL	Crlf
	
	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: Readval
; 
; The procedure will get a number from a user and validate it based on criteria. It will then update that address of the integer
;
; Preconditions: variable addresses exist
;
; Postconditions: varialbes are updated without being called on. 
;
; Receives:	userNumberProc (reference/input-output), userNumberSizeProc (reference/input-output) enterNumberProc (reference/input)
;           wrongNumProc (reference/input) signProc (reference/input-output).
;
; Returns: values are updated without changing registers or calling variables direactly
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

	
	; load arguments into local variables
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

	; conditionals to update sign/display error message
	_setPlus:
		PUSH	EDX
		PUSH	EAX

		MOV		EDX, signProc
		MOV		EAX, 43
		MOV		[EDX], EAX					; create sign

		POP		EAX
		POP		EDX
		JMP		_plusOrMinus

	_setMinus:
		PUSH	EDX
		PUSH	EAX

		MOV		EDX, signProc
		MOV		EAX, 45
		MOV		[EDX], EAX					; create sign

		POP		EAX
		POP		EDX
		JMP		_plusOrMinus
		
	
	_tryAgain:
		PUSH	EDX
		MOV		EDX, wrongNumProc
		CALL	WriteString					; error message
		CALL	Crlf
		POP		EDX

	_skippWrongMessage:

	; get user input by MACRO CALL
	mGetString enterNumberProc, userNumberProc, userNumberSizeProc, 33


	; transfer local variables that were altered to registers for use in transforming
	MOV		ESI, userNumberProc
	MOV		EDI, userIntegerProc
	MOV		ECX, userNumberSizeProc
	MOV		EBX, 0

	CMP		ECX, 10
	JA		_tryAgain
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
	

	; save integer and size
	MOV EAX, userNumberSizeProc
	MOV EDX, userIntegerProc
	
	CMP	EBX, 2147483647
	JA	_tryAgain
	JO	_tryAgain

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


	; move value to variable address
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
; Name: Writeval
; 
; Will take a signed number, convert it to string and display it. 
;
; Preconditions: variable addresses exist
;
; Postconditions: varialbes are updated without being called on. 
;
; Receives:	intToStringProc (value/input), outToStringProc (reference/input-output) stringSize (reference/input).
;
; Returns: values are updated without changing registers or calling variables direactly
; ---------------------------------------------------------------------------------
Writeval PROC
	LOCAL		intToStringProc: SDWORD, outToStringProc: SDWORD, stringSize: SDWORD


	; preserver registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDX
	PUSH		EDI
	
	; add arguments to local variables
	MOV			EAX, [EBP + 12]
	MOV			outToStringProc, EAX
	MOV			EDI, outToStringProc

	MOV			EDX, [EBP + 8]
	
	;check if negative
	CMP			EDX, 0
	JGE			_notNeg
		
		imul	EDX, -1			; makes positive for string transform
		MOV		EAX, 45
		
		STD
		STOSB					; store sign

	
	_notNeg:
		MOV			intToStringProc, EDX
	
	MOV			EAX, EDX
	
	; set up loop and direction flag
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
		_skippedBack1:
		
		MOV		EBX, 0
		PUSH EAX
		MOV		EAX, EDX
		ADD		EAX, 48
		
		STOSB
		
		POP EAX
		
		LOOP _intToStringLoop

	; special case if there is a digit with a zero, does not terminate wrongly
	JMP _skipOver


	; verifying if the loop should stop
	_skipped1:
		cmp EAX, 0
		JNE _skippedBack
		cmp intToStringProc, 0
		
		JE	_skippedBack1			; single zero case
	
	; display the value 
	_skipOver:
	CLD
	MOV outToStringProc, EDI
	ADD outToStringProc, 1
	mDisplayString outToStringProc
	; call WriteString
	

	; restore registers
	POP			EDI
	POP			EDX
	POP			ECX
	POP			EBX
	POP			EAX


	RET 8
Writeval ENDP

END main
