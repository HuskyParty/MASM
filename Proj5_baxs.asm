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
COUNTSIZE		TEXTEQU %(HI - LO) + 1

.data

; Intro variables
nameAndTitle	BYTE	"Scott Bax - Project 5 - Random Integer Array Generator/Manipulator", 0
description		BYTE	"This program generates an array with 200 random integers between 10-29", 10, 13
				BYTE	"and displays the list first unsorted. It then /calculates/displays the median value", 10, 13
				BYTE	"of the array. It then sorts/displays array in ascending order. It then generates/", 10, 13
				BYTE	"displays another array holding the number of times each random number was displayed.", 10, 13, 0


; Array variables	
randArray		DWORD	ARRAYSIZE DUP(?)
countArray		DWORD	COUNTSIZE DUP(?)

; Display variables	
space			BYTE	" ", 0
unsorted		BYTE	"Unsorted random numbers are: ", 0
sorted			BYTE	"Sorted random numbers are: ", 0
median			BYTE	"Median value of the array is: ", 0
counted			BYTE	"The amount each random occurs starting at 10 is: ", 0



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

	; Display unsorted array
	PUSH		OFFSET unsorted
	PUSH		OFFSET space
	PUSH		OFFSET randArray
	PUSH		ARRAYSIZE
	CALL		displayList

	; Sort array
	PUSH		OFFSET randArray
	PUSH		ARRAYSIZE
	CALL		sortList

	; Display median
	PUSH		OFFSET median
	PUSH		OFFSET randArray
	PUSH		ARRAYSIZE
	CALL		displayMedian

	; Display array
	PUSH		OFFSET sorted
	PUSH		OFFSET space
	PUSH		OFFSET randArray
	PUSH		ARRAYSIZE
	CALL		displayList

	; Count list
	PUSH		OFFSET countArray
	PUSH		OFFSET randArray
	PUSH		LO
	PUSH		HI
	PUSH		ARRAYSIZE
	CALL		countList

	; Display array
	PUSH		OFFSET counted
	PUSH		OFFSET space
	PUSH		OFFSET countArray
	PUSH		COUNTSIZE
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

	; set seed value for randomizing number
	CALL	Randomize

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

	RET 16
fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: sortList
; 
; The procedure sorts an array of ARRAYSIZE in ascending order.

; Preconditions: 
;
; Postconditions:
;
; Receives:	
;
; Returns: 
; ---------------------------------------------------------------------------------
sortList PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserve registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDI

	backToSortLoop:
	; set loop & EDI for loop reference
	MOV			ECX, [EBP + 8]
	SUB			ECX, 1					; due to exchangeg call procedure, 
	MOV			EDI, [EBP + 12]
	MOV			EBX, 0					; tracks how many exchanges occur

	; loop to sort arrat by exchanges 
	sortLoop:   

		; Set up array elements for compare and possible pass to exchange procedure
		PUSH	EBX
		MOV		EAX, [EDI]
		
		ADD		EDI, 4
		MOV		EBX, [EDI]
		SUB		EDI, 4			; restore EDI back
		

		CMP		EAX, EBX
		POP		EBX
		JNA		noExchangeNeeded

		; restore and increment EBX since exchange will occur
		
		ADD		EBX, 1

		; exhange elements in array if left > right
		PUSH		EDI
		ADD			EDI, 4
		PUSH		EDI
		CALL		exchangeElements  

		noExchangeNeeded:

		ADD		EDI, 4				;increment to next index
		LOOP	sortLoop
	
	CMP			EBX, 0
	JNE			backToSortLoop


	; restore registers
	POP			EDI
	POP			ECX
	POP			EBX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 8
sortList ENDP

; ---------------------------------------------------------------------------------
; Name: exchangeElements  
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values, EDX changed
;
; Receives:	someArray passed by referenece as input/output. LO, HI, ARRAYSIZE passed by value. space passed by reference.
;
; Returns: someArray updated with random integers within specified range
; ---------------------------------------------------------------------------------
exchangeElements PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserver registers

	PUSH		EBX
	PUSH		ECX


	; set registers with first and second index
	MOV			EDI, [EBP + 8]		; second index
	MOV			ECX, [EDI]

	MOV			EDI, [EBP + 12]		; first index
	MOV			EBX, [EDI]

	MOV			EDI, [EBP + 8]	
	MOV			[EDI], EBX

	MOV			EDI, [EBP + 12]	
	MOV			[EDI], ECX


	; restore registers
	POP			ECX
	POP			EBX


	; restore EBP register
	POP			EBP

	RET 8
exchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values, EDX changed
;
; Receives:	someArray passed by referenece as input/output. LO, HI, ARRAYSIZE passed by value. space passed by reference.
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

	; set loop & EDI for loop reference/set EDX for writeString
	MOV			ECX, [EBP + 8]
	MOV			EDI, [EBP + 12]
	MOV			EDX, [EBP + 20]

	; display title message
	CALL		WriteString
	CALL		Crlf

	; used to track numbers per line
	MOV			EBX, 0 
	
	
	; loop to display array
	displayLoop:
		
		; pass array item into WriteDec
		MOV		EAX, [EDI]
		CMP		EBX, 20

		JNE		skipLineReset		; if there are 20 numbers make new line
		MOV		EBX, 0 
		CALL	Crlf	

		skipLineReset:
		CALL	WriteDec			; display number

		MOV		EDX, [EBP + 16]
		CALL	WriteString			; display space


		ADD		EDI, 4				;increment to next index
		ADD		EBX, 1
		LOOP	displayLoop


	; New line
	CALL	Crlf
	CALL	Crlf
	
	; restore registers
	POP			EDI
	POP			ECX
	POP			EBX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 16
displayList ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian 
; 
; The procedure fills an array of ARRAYSIZE between the range of LO and HI.
;
; Preconditions: someArray, LO, HI, ARRAYSIZE exist
;
; Postconditions: someArray is updated with new random values, EDX changed
;
; Receives:	someArray passed by referenece as input/output. LO, HI, ARRAYSIZE passed by value. space passed by reference.
;
; Returns: someArray updated with random integers within specified range
; ---------------------------------------------------------------------------------
displayMedian PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserver registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDI

	; set loop & EDI for loop reference/set EDX for writeString
	MOV			ECX, [EBP + 8]
	MOV			EDI, [EBP + 12]
	MOV			EDX, [EBP + 16]

	; display title message
	CALL		WriteString

	;calculate average by dividing sum by valid numbers
	MOV			EAX, ECX
	MOV			EBX, 2
	CDQ
	DIV			EBX

	;find difference between remainder and divsor
	MOV		EBX, 2
	SUB		EBX, EDX

	;calculate average by dividing by divisor
	cmp		EBX, EAX
	jl		skip_rounding_up
	mov		EBX, -1
	add		EAX, EBX

	;rounding up got skipped
	skip_rounding_up:

	;Median in EAX
	IMUL	EAX, 4
	

	ADD		EDI, EAX

	MOV     EAX, [EDI]

	CALL	WriteDec


	

	; New line
	CALL	Crlf
	CALL	Crlf
	
	; restore registers
	POP			EDI
	POP			ECX
	POP			EBX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 12
displayMedian  ENDP

; ---------------------------------------------------------------------------------
; Name: countList
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
countList PROC
	
	; preserve EBP register and set it up as stack pointer
	PUSH		EBP
	MOV			EBP, ESP

	; preserver registers
	PUSH		EAX
	PUSH		EBX
	PUSH		ECX
	PUSH		EDX
	PUSH		EDI

	; set loop & EDI for loop reference
	MOV			ECX, [EBP + 8]

	; set countList
	MOV			ESI, [EBP + 24]
	SUB			ESI, 4

	; initial values - prev randArray Index in EAX, current randArray Index in EDX
	MOV			EDI, [EBP + 20]	
	SUB			EDI, 4
	MOV			EAX, [EDI]
	MOV			EBX, 0
	MOV			EDX, [EBP + 16]		

	; loop to fill array
	countLoop:
		
		
		
		ADD		EDI, 4
		MOV		EAX, [EDI]			; current randArray Index stored in EAX
		CMP		EDX, EAX
		JNE		updateCountList
		ADD		EBX, 1
		continueLoop:
		


		LOOP	countLoop
	

	JMP			skip

	; Add index occurence count to new array (all but last index)
	updateCountList:
	ADD			EBX, 1
	ADD			ESI, 4
	MOV			[ESI], EBX
	MOV			EBX, 0
	add			EDX, 1
	JMP			continueLoop

	; Add last index occurence count to new array
	skip:
	ADD			EBX, 1
	ADD			ESI, 4
	MOV			[ESI], EBX
	MOV			EBX, 0
	add			EDX, 1

	; restore registers
	POP			EDI
	POP			EDX
	POP			ECX
	POP			EBX
	POP			EAX

	; restore EBP register
	POP			EBP

	RET 20
countList ENDP


END main
