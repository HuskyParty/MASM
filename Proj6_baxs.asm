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

; Integer Constants
sizeNumMax = 200

mGetString MACRO prompt, userInput, bytesRead, count
	PUSH		EDX
	PUSH		EAX
  ; title, name and description of program
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
userNumber		BYTE	33 DUP(0) ; User number to be entered
userNumberSize  DWORD	?

; Array variables	
;randArray		DWORD	ARRAYSIZE DUP(?)
;countArray		DWORD	COUNTSIZE DUP(?)

; Data variables



; Display variables	
space			BYTE	" ", 0
enterNumber		BYTE	"Please enter a number that is signed: ", 0
sorted			BYTE	"Sorted random numbers are: ", 0
median			BYTE	"Median value of the array is: ", 0
counted			BYTE	"The amount each random occurs starting at 10 is: ", 0
byeMessage		BYTE	"Thanks for using this program. See ya!", 0

.code
main PROC

; inroduction MACRO
introduction OFFSET nameAndTitle, OFFSET description

; Readval procedure
PUSH		OFFSET userNumberSize
PUSH		OFFSET userNumber
PUSH		OFFSET enterNumber
CALL		Readval

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
; Returns: someArray updated with random integers within specified range
; ---------------------------------------------------------------------------------
Readval PROC
	LOCAL		userNumberProc: DWORD, userNumberSizeProc: DWORD, enterNumberProc: DWORD


	; preserver registers
	PUSH		EAX
	PUSH		ECX
	PUSH		EBX

	MOV EDX, [EBP + 8]
	MOV enterNumberProc, EDX

	MOV EDX, [EBP + 12]
	MOV userNumberProc, EDX

	MOV EDX, [EBP + 16]
	MOV userNumberSizeProc, EDX

	; get user input
	mGetString enterNumberProc, userNumberProc, userNumberSizeProc, 33
	; display user input 
	mDisplayString userNumberProc






	; restore registers
	POP			EBX
	POP			ECX
	POP			EAX


	RET 4
Readval ENDP

END main
