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
	POP			EDX
ENDM

mDisplayString MACRO passedString
	PUSH		EDX
  ; title, name and description of program
	MOV			EDX, passedString
	CALL		WriteString
	CALL		Crlf

	POP			EDX
ENDM

; (insert constant definitions here)

.data

; Intro variables
nameAndTitle	BYTE	"Scott Bax - Project 6 - String Primitives and Macros", 0
description		BYTE	"This program will ", 10, 13
				BYTE	"x", 10, 13
				BYTE	"y", 10, 13
				BYTE	"z", 10, 13, 0
userNumber		SDWORD	?
userNumberSize  DWORD	?
userInteger		SDWORD	?
intToString		SDWORD	?

; Array variables	
intArray		DWORD	10 DUP(?)


; Data variables



; Display variables	
space			BYTE	" ", 0
enterNumber		BYTE	"Please enter a number that is signed: ", 0
displayNumbers	BYTE	"Check out the following numbers you entered: ", 0
median			BYTE	"Median value of the array is: ", 0
counted			BYTE	"The amount each random occurs starting at 10 is: ", 0
byeMessage		BYTE	"Thanks for using this program. See ya!", 0

.code
main PROC

; inroduction MACRO
introduction OFFSET nameAndTitle, OFFSET description


MOV		EDI, OFFSET intArray
MOV		ECX, 10
; Integer Loop
_integerLoop:
		
		; Readval procedure
		PUSH		OFFSET userInteger
		PUSH		OFFSET userNumberSize
		PUSH		OFFSET userNumber
		PUSH		OFFSET enterNumber
		CALL		Readval
		MOV			EBX, [EAX]
		MOV			[EDI], EBX
		
		PUSH		OFFSET intToString
		PUSH		EBX
		CALL		Writeval
		
		ADD		EDI, 4
		
		LOOP	_integerLoop

; Display 
	

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
	LOCAL		userNumberProc: SDWORD, userNumberSizeProc: SDWORD, enterNumberProc: SDWORD, userIntegerProc: SDWORD


	; preserver registers
	PUSH		EBX
	PUSH		ECX
	PUSH		EDX
	PUSH		ESI
	PUSH		EDI

	MOV EDX, [EBP + 8]
	MOV enterNumberProc, EDX

	MOV EDX, [EBP + 12]
	MOV userNumberProc, EDX

	MOV EDX, [EBP + 16]
	MOV userNumberSizeProc, EDX

	MOV EDX, [EBP + 20]
	MOV	userIntegerProc, EDX

	; get user input
	mGetString enterNumberProc, userNumberProc, userNumberSizeProc, 33

	MOV ESI, userNumberProc
	MOV	EDI, userIntegerProc
	MOV ECX, userNumberSizeProc
	
	_checkChar:
		LODSB
		SUB	AL, 48
		STOSB
		LOOP _checkChar

	MOV EAX, userIntegerProc

	; restore registers
	POP			EDI
	POP			ESI
	POP			EDX
	POP			ECX
	POP			EBX


	RET 4
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
	LOCAL		intToStringProc: SDWORD, outToStringProc: SDWORD


	; preserver registers
	PUSH		EBX
	PUSH		ECX
	PUSH		EDX

	MOV			EDX, [EBP + 8]
	MOV			intToStringProc, EDX

	MOV			EDX, [EBP + 12]
	MOV			outToStringProc, EDX
	
	MOV			EAX, intToStringProc
	CALL		WriteDec

	MOV			EDI, outToStringProc
	
	MOV ECX, 0
	_intToStringLoop:
		mov		EAX, intToStringProc
		MOV		EBX, 10
		CDQ
		idiv	EBX
		
		MOV		EBX, 0
		
		CMP		EBX, EDX
		JE  skip:

		MOV		ECX, 1

		skip:
		CALL WriteString
		;MOV	AL, EDX
		;STOSB
		
		LOOP _intToStringLoop
	;MOV EDX, outToString
	;call WriteString

	POP			EDX
	POP			ECX
	POP			EBX


	RET 4
Writeval ENDP

END main
