TITLE Project 4 - Prime Number Calculator     (Proj4_baxs.asm)

; Author: Scott Bax
; Last Modified: 23 JuLy 2021
; OSU email address: baxs@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project 4    Due Date: 26 July 2021
; Description: Program that calculates and displays prime numbers given a range input by the user.
;		The user is prompted to input a number between 1-200. This input is validated, and if it
;		is done successfully, all prime numbers from 1 to that number are calcuated and displayed.


INCLUDE Irvine32.inc

; Integer Constants
UPPERBOUND = 200
LOWERBOUND = 1

.data

; Intro variables
programTitle		BYTE	"Scott Bax - Project 4 - Prime Number Calculator", 0
extraCredit			BYTE	"**EC: ", 0

; Data calculation prompt variables
numberReqPrompt1	BYTE	"Please enter the amount of prime numbers you would like to see.", 0
numberReqPrompt2	BYTE	"The number must be within the range of [1, 200].", 0
enterNumberPrompt	BYTE	"Enter the number of primes to display: ", 0
wrongNumberPrompt	BYTE	"Wrong number, try again.", 0
			

; Data calculation variables
numberInput			SDWORD	?		  ; user number input
divByTen			SDWORD	?


.code
main PROC

	call introduction
	call getUserData
	call showPrimes
	call farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
; 
; The procedure displays program title and programmer's name. Displays number input 
;		instructions and prompt.
;
; Preconditions: programTitle, extraCredit, numberReqPrompt1, and numberReqPrompt2
;		 are strings that describe the program and are instructions.
;
; Postconditions: EDX Changed
;
; Receives:  programTitle, extraCredit, numberReqPrompt1, and numberReqPrompt2
;		 are global variables
;
; Returns: None
; ---------------------------------------------------------------------------------
introduction PROC
	
	; title, name, extra credit
	mov		EDX, OFFSET programTitle
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET extraCredit
	call	WriteString
	call	Crlf
	call	Crlf

	; input instructions
	mov		EDX, OFFSET numberReqPrompt1 
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET numberReqPrompt2	; lines 1 - 2 of instructions
	call	WriteString
	call	Crlf
	call	Crlf

	ret
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: getUserData
; 
; The procedure prompts the user to enter the number of primes to be displayed,
;		stores that data in global variables, and calls validation procedure
;		to validate that the number entered is within the range [1, 200].
;
; Preconditions: enterNumberPrompt is a string and numberInput is created to store 
;		integer.
;
; Postconditions: EDX and EAX changed 
;
; Receives: enterNumberPrompt and numberInput as global variables. 
;
; Returns: user input number into numberInput as global variable. 
; ---------------------------------------------------------------------------------
getUserData PROC
	
	; prompt for number
	mov		EDX, OFFSET enterNumberPrompt
	call	WriteString

	; get number from user and store in global variable
	call	ReadInt				
	mov		numberInput, EAX

	; check if the number is within bounds by calling validate
	call validate

	ret
getUserData ENDP

; ---------------------------------------------------------------------------------
; Name: validate
; 
; The procedure determines if the user input is within the range [1,200], if not
;		will display error message and send back to getUserData. If so, will
;		will continue to return address.  
;
; Preconditions: wrongNumberPrompt is a string, UPPERBOUND/LOWERBOUND are integers
;		and user has input numberInput.
;
; Postconditions: EDX changed.
;
; Receives: UPPERBOUND/LOWERBOUND as integer constants, and numberInput/wrongNumberPrompt
;		as global variables.
;
; Returns: None.
; ---------------------------------------------------------------------------------
validate PROC

	; if number is not within range jump back to getUserData
	cmp		numberInput, UPPERBOUND
	ja		errorMessage					;above 200

	cmp		numberInput, LOWERBOUND
	jb		errorMessage					;below 1

	ret

	; error message if out of bounds
	errorMessage:

		; prompt for number
		mov		EDX, OFFSET wrongNumberPrompt
		call	WriteString
		call	Crlf

		call	getUserData		; jump back to getUserData

validate ENDP

; ---------------------------------------------------------------------------------
; Name: procedureName
; 
; The description...
;
; Preconditions: 
;
; Postconditions: 
;
; Receives: 
;
; Returns: 
; ---------------------------------------------------------------------------------
showPrimes PROC

	;establish how many times to iterate
	mov		ECX, numberInput	; number of loops
	mov		EAX, 0				; represents the index (N)


	;loop and display primes
	displayLoop:
		inc		EAX

		push	EAX

		mov		EDX, 0
		mov		EBX, 10	
		div		EBX

		mov		divByTen, EDX
		pop		EAX

		call	WriteDec

		cmp		divByTen, 0
		jne		noNewLine


		call	Crlf

		; jump here if not printing new line
		noNewLine:

		loop displayLoop

		



	ret
showPrimes ENDP

; ---------------------------------------------------------------------------------
; Name: procedureName
; 
; The description...
;
; Preconditions: 
;
; Postconditions: 
;
; Receives: 
;
; Returns: 
; ---------------------------------------------------------------------------------
isPrime PROC

	ret
isPrime ENDP

; ---------------------------------------------------------------------------------
; Name: procedureName
; 
; The description...
;
; Preconditions: 
;
; Postconditions: 
;
; Receives: 
;
; Returns: 
; ---------------------------------------------------------------------------------
farewell PROC

	ret
farewell ENDP




END main
