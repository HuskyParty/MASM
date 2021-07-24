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
UPPERBOUND = 4000
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
numSpace			BYTE	" ", 0


.code
main PROC

	CALL introduction
	CALL getUserData
	CALL showPrimes
	CALL farewell

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
	MOV		EDX, OFFSET programTitle
	CALL	WriteString
	CALL	Crlf

	MOV		EDX, OFFSET extraCredit
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

	; input instructions
	MOV		EDX, OFFSET numberReqPrompt1 
	CALL	WriteString
	CALL	Crlf

	MOV		EDX, OFFSET numberReqPrompt2	; lines 1 - 2 of instructions
	CALL	WriteString
	CALL	Crlf
	CALL	Crlf

	RET
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: getUserData
; 
; The procedure prompts the user to enter the number of primes to be displayed,
;		stores that data in global variables, and CALLs validation procedure
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
	MOV		EDX, OFFSET enterNumberPrompt
	CALL	WriteString

	; get number from user and store in global variable
	CALL	ReadInt				
	MOV		numberInput, EAX

	; check if the number is within bounds by CALLing validate
	CALL validate

	RET
getUserData ENDP

; ---------------------------------------------------------------------------------
; Name: validate
; 
; The procedure determines if the user input is within the range [1,200], if not
;		will display error message and send back to getUserData. If so, will
;		will continue to RETurn address.  
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
	CMP		numberInput, UPPERBOUND
	JA		errorMessage					;above 200

	CMP		numberInput, LOWERBOUND
	JB		errorMessage					;below 1

	RET

	; error message if out of bounds
	errorMessage:

		; prompt for number
		MOV		EDX, OFFSET wrongNumberPrompt
		CALL	WriteString
		CALL	Crlf

		CALL	getUserData		; jump back to getUserData

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

	; establish how many times to iterate
	MOV		ECX, numberInput	; number of loops
	MOV		EAX, 0				; represents number of primes
	MOV		EDX, 1				; represents index


	;loop and display primes
	displayLoop:
		
		INC EDX

		CMP		ECX, 1
		JE		exitLoop

		
		; if prime, EBX will be (1) if not (0), jump if returned (1)
		CALL	isPrime

		CMP		EBX, 1
		JNE		displayLoop

		; push EAX on stack to preserve number so EAX can be used for DIV
		INC		EAX
		PUSH	EAX

		; div operation
		MOV		EDX, 0
		MOV		EBX, 10	
		DIV		EBX

			
		MOV		EAX, ECX
		; if prime counter is divisible by 10 with no quotient, print new line
		MOV		divByTen, EDX
		CALL	WriteDec

 		MOV		EDX, OFFSET	numSpace
 		CALL	WriteString
 
 		CMP		divByTen, 0
 		JNE		noNewLine
		CALL	Crlf			; new line

		; jump here if not printing new line
		noNewLine:
		; get EAX back from stack
		POP		EAX	
		POP		EBX
		

		LOOP	displayLoop

	exitLoop:

	RET

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
; Receives: index number of loop 
;
; Returns: global variable, isPrime, holding whether number is prime via stack
; ---------------------------------------------------------------------------------
isPrime PROC

	; save registers
	PUSH	EAX
	PUSH	ECX
	PUSH	EDX

	; Using EAX for current index as dividend
	MOV		EAX, EDX

	; start divisor at 2 and increase upward, this will find out if not prime more efficiently
	MOV		EBX, 2

	isPrimeLoop:
		
		; if loop counter is same as index, exit becuase prime
		CMP		EBX, EAX
		JE		exitLoop

		PUSH	EAX		; preserve EAX as dividend

		; div operation EAX(current index)/ EBX(current loop counter)
		MOV		EDX, 0
		DIV		EBX

		; restore dividend
		POP		EAX
		INC		EBX

		; if quotient is zero it was divisible and jump
		CMP		EDX, 0
		JE		primeNum
		
		
	LOOP	isPrimeLoop

	; exited here because is prime update EBX accordingly
	exitLoop:

		MOV		EBX, 1

	

	leaveProc:
		; restore registers
		POP	EDX
		POP ECX
		POP EAX

	RET


	primeNum:
		
		; restore registers
		POP	EDX
		POP ECX	
		POP EAX

		MOV		EBX, 0
		
	RET
		

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

	RET
farewell ENDP




END main
