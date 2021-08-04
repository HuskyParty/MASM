TITLE Project 5 - Genorating, Sorting, Counting Random Ints     (Proj5_baxs.asm)

; Author: Scott Bax
; Last Modified: 4 Aug 2021
; OSU email address: baxs@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project 5    Due Date: 8 Aug 2021
; Description: Program that generates an array with 200 random integers between 10-29
;		The program displays the list first unsorted. It then /calculates/displays the median value
;		of the array. It then sorts/displays array in ascending order. It then generates/
;		displays another array holding the number of times each random number was displayed.

INCLUDE Irvine32.inc

; Integer Constants
ARRAYSIZE = 200
LO = 10
HI = 29

.data

; Intro variables
nameAndTitle	BYTE	"Scott Bax - Project 5 - Random Integer Array Generator/Manipulator", 0
description		BYTE	"This program generates an array with 200 random integers between 10-29", 10, 13
				BYTE	"and displays the list first unsorted. It then /calculates/displays the median value", 10, 13
				BYTE	"of the array. It then sorts/displays array in ascending order. It then generates/", 10, 13
				BYTE	"displays another array holding the number of times each random number was displayed.", 10, 13, 0


; Array variables	
randArray		DWORD   ARRAYSIZE DUP(?)


.code
main PROC

	; Intro
	PUSH		OFFSET nameAndTitle 
	PUSH		OFFSET description
	CALL		introduction

	; Fill array
	PUSH		OFFSET randArray
	PUSH		LO
	PUSH		HI
	PUSH		ARRAYSIZE
	CALL		fillArray

	; Display array
	PUSH		OFFSET randArray
	PUSH		ARRAYSIZE
	CALL		displayList



	Invoke ExitProcess,0	; exit to operating system

main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
; 
; The procedure displays programmer name and program description to user. 
;
; Preconditions: intro1 and intro2 exist as strings.
;
; Postconditions: EDX changed.
;
; Receives:	intro1 and intro2 by reference via the stack (in that order). 
;
; Returns: None.
; ---------------------------------------------------------------------------------
introduction PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP
	
	; title, name and description of program
	MOV			EDX, [EBP + 12]
	CALL		WriteString
	CALL		Crlf
	CALL		Crlf

	MOV			EDX, [EBP + 8]
	CALL		WriteString
	CALL		Crlf
	CALL		Crlf

	; restore EBP register
	POP			EBP

	RET 8
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values
;
; Receives:	someArray passed by referenece as input/output. LO, HI, ARRAYSIZE passed by value
;
; Returns: someArray updated with random integers within specified range
; ---------------------------------------------------------------------------------
fillArray PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserver registers
	PUSH		EAX
	PUSH		ECX
	PUSH		EDI

	; set loop & EDI for loop reference
	MOV			ECX, [EBP + 8]
	MOV			EDI, [EBP + 20]
	; loop to fill array
	fillLoop:
		
		; Generate random number by using HI & LO
		; Since RandomRange Initializes at zero mus subtract LO from HI
		; then generate number and add LO back to HI
		MOV		EAX, [EBP + 12]
		SUB		EAX, [EBP + 16]
		ADD		EAX, 1				; RandomRange upper limit exclusive

		CALL	RandomRange
		ADD		EAX, [EBP + 16]		; add back Lo


		MOV		[EDI], EAX
		ADD		EDI, 4				; put random val in array and increment to next index

		LOOP	fillLoop


	; restore registers
	POP			EDI
	POP			ECX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 20
fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values
;
; Receives:	someArray passed by referenece as input/output. LO, HI, ARRAYSIZE passed by value
;
; Returns: someArray updated with random integers within specified range
; ---------------------------------------------------------------------------------
displayList PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserver registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDI

	; set loop & EDI for loop reference
	MOV			ECX, [EBP + 8]
	MOV			EDI, [EBP + 12]
	
	; loop to display array
	displayLoop:
		
		; pass array item into WriteDec
		MOV		EAX, [EDI]
		CALL	WriteDec

		ADD		EDI, 4				;increment to next index

		LOOP	displayLoop


	; restore registers
	POP			EDI
	POP			ECX
	POP			EBX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 12
displayList ENDP

END main
