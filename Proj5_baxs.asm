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
intro1		 		BYTE	"Scott Bax - Project 5 - Random Integer Array Generator/Manipulator", 0
intro2				BYTE	"This program generates an array with 200 random integers between 10-29", 10, 13
					BYTE	"and displays the list first unsorted. It then /calculates/displays the median value", 10, 13
					BYTE	"of the array. It then sorts/displays array in ascending order. It then generates/", 10, 13
					BYTE	"displays another array holding the number of times each random number was displayed.", 10, 13, 0


; Array variables	
randArray		    DWORD   ARRAYSIZE DUP(?)


.code
main PROC

	; Intro
	PUSH			OFFSET intro1 
	PUSH			OFFSET intro2
	CALL			introduction

	; Fill array
	PUSH			OFFSET randArray
	PUSH			LO
	PUSH			HI
	PUSH			ARRAYSIZE
	CALL			fillArray



	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
; 
; The procedure displays programmer name and program description to user. 
;
; Preconditions: intro1 and intro2 exist as strings
;
; Postconditions: EDX changed
;
; Receives:	intro1 and intro2 by reference via the stack (in that order). 
;
; Returns: None
; ---------------------------------------------------------------------------------
introduction PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH			EBP
	MOV				EBP, ESP
	
	; title, name and description of program
	MOV				EDX, [EBP + 12]
	CALL			WriteString
	CALL			Crlf
	CALL			Crlf

	MOV				EDX, [EBP + 8]
	CALL			WriteString
	CALL			Crlf
	CALL			Crlf

	; restore EBP register
	POP			EBP

	RET 8
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
; 
; The procedure displays programmer name and program description to user. 
;
; Preconditions: intro1 and intro2 exist as strings
;
; Postconditions: EDX changed
;
; Receives:	intro1 and intro2 by reference via the stack (in that order). 
;
; Returns: None
; ---------------------------------------------------------------------------------
fillArray PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH			EBP
	MOV				EBP, ESP
	
	; title, name and description of program
	MOV				EDX, [EBP + 12]
	CALL			WriteString
	CALL			Crlf
	CALL			Crlf

	MOV				EDX, [EBP + 8]
	CALL			WriteString
	CALL			Crlf
	CALL			Crlf

	; restore EBP register
	POP			EBP

	RET 8
fillArray ENDP

END main
