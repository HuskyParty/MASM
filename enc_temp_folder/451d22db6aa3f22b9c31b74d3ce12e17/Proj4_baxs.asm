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
numPerLine = 10
rowPerPage = 20

.data

; Intro variables
programTitle		BYTE	"Scott Bax - Project 4 - Prime Number Calculator", 0
extraCredit			BYTE	"**EC: ", 0

; Prompt variables
numberReqPrompt1	BYTE	"Please enter the amount of prime numbers you would like to see.", 0
numberReqPrompt2	BYTE	"The number must be within the range of [1, 200].", 0
enterNumberPrompt	BYTE	"Enter the number of primes to display: ", 0
wrongNumberPrompt	BYTE	"Wrong number, try again.", 0
numSpace			BYTE	"   ",0
goodBye				BYTE	"Use these prime numbers wisely, See ya!",0

			

; Data calculation variables
numberInput			SDWORD	?		  ; user number input
divByTen			SDWORD	?
primeHolder			SDWORD	?
rowNum				SDWORD	0


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
	MOV		ECX, numberInput			; number of loops
	MOV		EAX, 0						; represents number of primes
	MOV		EBX, 1						; represents index


	;loop and display primes
	displayLoop:
		
		PUSH	ECX

		
		reLoop:
			
			INC		EBX
			PUSH	EBX

		
			CALL	isPrime					; if prime, EBX will be (1), else (0)
			MOV		primeHolder, EBX		
		
			POP		EBX
			CMP		primeHolder, 1
			JNE		reLoop				; if number not prime jump back 

		INC		EAX
		PUSH	EAX

		MOV		ECX, rowNum

		
		CMP		ECX, rowPerPage
		JE		continueAt20


		; -------------------------
		; Display prime numbers - new line pushed every ten prime numbers

		; -------------------------
		displayOut:
			MOV		EAX, EBX
			CALL	WriteDec			; write prime number

 			MOV		EDX, OFFSET	numSpace
 			CALL	WriteString			; write " "
 
			POP		EAX
 			CMP		EAX, numPerLine
 			JNE		noNewLine
			MOV		EAX, 0
			CALL	Crlf				; write new line
			INC		ECX					; increase row count

		; jump here if not printing new line
		noNewLine:
		
		
		
		MOV		rowNum, ECX				; preserve row total
		POP		ECX
		LOOP	displayLoop


	RET

	; -------------------------
	; Displays 20 rows of primes per "page", by clearing the screen every 20 lines

	; -------------------------
	continueAt20:
			CALL	WaitMsg				; press any key to continue...
			CALL	Clrscr				; clear page
			MOV		ECX, 0
			JMP		displayOut		

showPrimes ENDP

; ---------------------------------------------------------------------------------
; Name: isPrime
; 
; The procedure will take an index to check for 
;
; Preconditions: 
;
; Postconditions: 
;
; Receives: index number of loop in EBX
;
; Returns: value of whether number is prime is returned in EBX. (1) yes (0) no.
; ---------------------------------------------------------------------------------
isPrime PROC

	; save registers
	PUSH	EAX
	PUSH	ECX
	

	; Using EAX for current index as dividend
	MOV		EAX, EBX

	; start divisor at 2 and increase upward, 
	; this will find out if not prime more efficiently
	MOV		EBX, 2


	; -------------------------
	; Loops from 2 to index to see if any division occurs to make number not prime

	; -------------------------
	isPrimeLoop:
		
		; if loop counter is same as index, exit becuase prime
		CMP		EBX, EAX
		JE		exitLoop

		PUSH EAX		; save

		; div operation EAX(current index)/ EBX(current loop counter)
		MOV		EDX, 0
		DIV		EBX

		INC		EBX

		POP EAX			; restore


		; if quotient is zero it was divisible and jump
		CMP		EDX, 0
		JE		notPrimeNum
		INC		ECX

	LOOP	isPrimeLoop


	; exited here because is prime update EBX accordingly
	exitLoop:

		MOV		EBX, 1		; return value

	; restore registers
	POP ECX
	POP EAX

	RET

	; exit early if not prime number
	notPrimeNum:
		
		; restore registers
		POP ECX
		POP EAX

		MOV		EBX, 0		; return value
		
	RET
		

isPrime ENDP

; ---------------------------------------------------------------------------------
; Name: farewell
; 
; The procedure displays a goodbye message.

; Preconditions: goodBye is a string
;
; Postconditions: EDX changed
;
; Receives: None. 
;
; Returns: None. 
; ---------------------------------------------------------------------------------
farewell PROC

	; farewell message 
	call	Crlf
	call	Crlf

	mov		EDX, OFFSET goodBye			; message
	call	WriteString

	RET
farewell ENDP




END main
