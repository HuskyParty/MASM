TITLE Project 1 - Basic Logic and Arithmetic Programc

; Author: Scott Bax
; Last Modified: 3 JuLy 2021
; OSU email address: baxs@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project 1    Due Date: 11 July 2021
; Description: Basic logic and arithmetic program that will ask user to input three numbers in descending order (will exit if not comply). 
;	   The program will calculate return results of specific addition, subtraction and division of the numbers. The program 
;	   continues until the user decides to exit.

INCLUDE Irvine32.inc

.data

; variables holding intro messages
intro_title		BYTE	"Scott Bax - Project Project 1 -  Basic Logic and Arithmetic Program", 0
intro_EC1		BYTE	"**EC: Program repeats until the user chooses to quit.", 0
intro_EC2		BYTE	"**EC: Program verifies the numbers are in descending order - quits otherwise.", 0
intro_EC3		BYTE	"**EC: Program handles negative results, and computes/displays B-A, C-A, C-B, C-B-A", 0
intro_EC4		BYTE	"**EC: Program calculates and displays quotients/remainders for A/B, A/C, B/C", 0
prompt_Intro	BYTE	"Enter 3 numbers in descending order (A > B > C), and I'll show you the sums and differences.", 0

; variables holding prompts to retrieve user numbers
prompt_int_A	BYTE	"First number: ", 0
prompt_int_B	BYTE	"Second number: ", 0
prompt_int_C	BYTE	"Third number: ", 0

; variables to hold user input numbers
int_A			DWORD	?		  
int_B			DWORD	?		  
int_C			DWORD	?		 

; variables to store arithetic of input
result_AplusB	DWORD	?		  
result_AminusB	DWORD	?		  
result_AplusC	DWORD	?		  
result_AminusC	DWORD	?		
result_BplusC	DWORD	?		  
result_BminusC	DWORD	?
result_plusABC	DWORD	?		  


; variables to use for result calculation message
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
equals			BYTE	" = ", 0

; Extra Credit variables
quit_caption	BYTE	" "
				BYTE	0dh, 0ah
				BYTE	"Press 'Yes' to exit the program or 'No' to continue using it.", 0

order_err_prmpt	BYTE	"ERROR: You did not put the numbers in descending order - program will exit.", 0

result_BminusA	DWORD	?		  	  
result_CminusA	DWORD	?		  
result_CminusB	DWORD	?
result_minusCBA	DWORD	?	

divide_sym		BYTE	" / ", 0
quotient_msg	BYTE	" quotient: ", 0
remainder_msg	BYTE	" remainder: ", 0

quotient_AdivB	DWORD	?		  
quotient_AdivC	DWORD	?
quotient_BdivC	DWORD	?	
remainder_AdivB	DWORD	?		  
remainder_AdivC	DWORD	?
remainder_BdivC	DWORD	?	



; Goodbye mesage
goodbye			BYTE	"Thanks for using my Basic Logic and Arithmetic Program! Goodbye!", 0


.code
main PROC

; -------------------------
; INTRODUCTION - Displays program information to include extra credit info
; -------------------------
	mov		EDX, OFFSET intro_title
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET intro_EC1 ; first EC statement
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET intro_EC2 ; second EC statement
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET intro_EC3 ; third EC statement
	call	WriteString
	call	Crlf

	mov		EDX, OFFSET intro_EC4 ; fourth EC statement
	call	WriteString
	call	Crlf
	call	Crlf

; -------------------------
; GET THE DATA - Asks the user for three numbers in descending order and stores data into variables.  
;		If the numbers are not descending, program will close
; -------------------------
	mov		EDX, OFFSET prompt_Intro
	call	WriteString
	call	Crlf

	; Gather first number
	mov		EDX, OFFSET prompt_int_A
	call	WriteString
	call	ReadDEC
	mov		int_A, EAX

	; Gather second number
	mov		EDX, OFFSET prompt_int_B
	call	WriteString
	call	ReadDEC
	mov		int_B, EAX

	; **Extra Credit - verifies the numbers are in descending order
	mov		EAX, int_B
	cmp		int_A, EAX
	mov		int_B, EAX
	JC		get_out_descending ; jumps to exit section if there is a carry flag (greater than preceding number)
	JZ		get_out_descending ; jumps to exit section if there is a zero flag (equal to preceding number)


	; Gather third number
	mov		EDX, OFFSET prompt_int_C
	call	WriteString
	call	ReadDEC
	mov		int_C, EAX
	call	Crlf

	; **Extra Credit - verifies the numbers are in descending order
	mov		EAX, int_C
	cmp		int_B, EAX
	mov		int_C, EAX
	JC		get_out_descending ; jumps to exit section if there is a carry flag (greater than preceding number)
	JZ		get_out_descending ; jumps to exit section if there is a zero flag (equal to preceding number)

; -------------------------
; CALCULATE THE VALUES (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C)
;		Goes through and uses arithmetic operations to calculate and store the above equations.
; -------------------------
	mov		EBX, int_A
	add		EBX, int_B
	mov		result_AplusB, EBX	; A + B

	mov		EBX, int_A
	sub		EBX, int_B
	mov		result_AminusB, EBX	; A - B

	mov		EBX, int_A
	add		EBX, int_C
	mov		result_AplusC, EBX	; A + C

	mov		EBX, int_A
	sub		EBX, int_C
	mov		result_AminusC, EBX	; A - C

	mov		EBX, int_B
	add		EBX, int_C
	mov		result_BplusC, EBX	; B + C

	mov		EBX, int_B
	sub		EBX, int_C
	mov		result_BminusC, EBX	; B - C

	mov		EBX, result_AplusB
	add		EBX, int_C
	mov		result_plusABC, EBX	; A + B + C

; -------------------------	
; **Extra Credit: CALCULATE THE VALUES (B-A, C-A, C-B, C-B-A)
;		Goes through and uses arithmetic operations to calculate and store the above equations.
; -------------------------	
	mov		EBX, int_B
	sub		EBX, int_A
	mov		result_BminusA, EBX	; B - A

	mov		EBX, int_C
	sub		EBX, int_A
	mov		result_CminusA, EBX	; C - A

	mov		EBX, int_C
	sub		EBX, int_B
	mov		result_CminusB, EBX	; C - B

	mov		EBX, result_CminusB
	sub		EBX, int_A
	mov		result_minusCBA, EBX ; C - B - A

; -------------------------	
; **Extra Credit: CALCULATE THE VALUES (A/B, A/C, B/C)
;		Goes through and uses arithmetic operations to calculate and store the above equations.
; -------------------------	
	mov		EAX, int_A
	mov		EDX, 0
	mov		EBX, int_B
	DIV		EBX
	mov		quotient_AdivB, EAX
	mov		remainder_AdivB, EDX ; A / B

	mov		EAX, int_A
	mov		EDX, 0
	mov		EBX, int_C
	DIV		EBX
	mov		quotient_AdivC, EAX
	mov		remainder_AdivC, EDX ; A / C

	mov		EAX, int_B
	mov		EDX, 0
	mov		EBX, int_C
	DIV		EBX
	mov		quotient_BdivC, EAX
	mov		remainder_BdivC, EDX ; B / C

; -------------------------	
; DISPLAY THE RESULTS - Writes out to the console the required information for the specifications of the class.
;		This will return all addition, subtraction and division data.
; -------------------------	

	; A + B
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_AplusB
	call	WriteDec
	call	Crlf				; Equals and result

	; A - B
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_AminusB
	call	WriteDec
	call	Crlf				; Equals and result

	; A + C
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_AplusC
	call	WriteDec
	call	Crlf				; Equals and result

	; A - C
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_AminusC
	call	WriteDec
	call	Crlf				; Equals and result

	; B + C
	mov		EAX, int_B
	call	WriteDec
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_BplusC
	call	WriteDec
	call	Crlf				; Equals and result

	; B - C
	mov		EAX, int_B
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_BminusC
	call	WriteDec
	call	Crlf				; Equals and result

	; A + B + C
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Additional operator and num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_plusABC
	call	WriteDec
	call	Crlf
	call	Crlf				; Equals and result


	; **Extra Credit: Display the negative results  

	; B-A
	mov		EAX, int_B
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_A
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_BminusA	; Equals and result
	call	WriteInt
	call	Crlf

	; C-A
	mov		EAX, int_C
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_A
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_CminusA
	call	WriteInt
	call	Crlf				; Equals and result

	; C-B
	mov		EAX, int_C
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_CminusB
	call	WriteInt
	call	Crlf				; Equals and result

	; C-B-A
	mov		EAX, int_C
	call	WriteDec
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, int_A
	call	WriteDec			; Additional operator and Num

	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, result_minusCBA
	call	WriteInt
	call	Crlf
	call	Crlf				; Equals and result

	; **Extra Credit: Display the division results  

	; A / B
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET divide_sym
	call	WriteString
	mov		EAX, int_B
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString			; Equals

	mov		EDX, OFFSET quotient_msg 
	call	WriteString
	mov		EAX, quotient_AdivB
	call	WriteDec			; Quotient

	mov		EDX, OFFSET remainder_msg
	call	WriteString
	mov		EAX, remainder_AdivB
	call	WriteDec			
	call	Crlf				; Remainder

	; A / C
	mov		EAX, int_A
	call	WriteDec
	mov		EDX, OFFSET divide_sym
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString			; Equals

	mov		EDX, OFFSET quotient_msg 
	call	WriteString
	mov		EAX, quotient_AdivC
	call	WriteDec			; Quotient

	mov		EDX, OFFSET remainder_msg 
	call	WriteString
	mov		EAX, remainder_AdivC
	call	WriteDec
	call	Crlf				; Remainder

	; B / C
	mov		EAX, int_B
	call	WriteDec
	mov		EDX, OFFSET divide_sym
	call	WriteString
	mov		EAX, int_C
	call	WriteDec			; Num operator Num

	mov		EDX, OFFSET equals
	call	WriteString			; Equals

	mov		EDX, OFFSET quotient_msg
	call	WriteString
	mov		EAX, quotient_BdivC
	call	WriteDec			; Quotient

	mov		EDX, OFFSET remainder_msg
	call	WriteString
	mov		EAX, remainder_BdivC
	call	WriteDec
	call	Crlf
	call	Crlf				; Remainder


; -------------------------	
; **Extra Credit: Ask if Want to Continue - Uses the MsgBoxAsk procedure to determine if the user wants
;		to continue by asking them to answer yes or no. The no value will generate an unsigned carry flag, 
;		which will trigger the conditional jump. 
; -------------------------	
	mov		ebx, 0
	mov		edx, OFFSET quit_caption
	call	MsgBoxAsk			
	cmp		eax, IDNO

	JC		get_out				; jumps to get out section of code if there is an unsigned carry (which occurs if user asks to leave)

	
	Invoke	main				; if user doesn't jumpt to get out section, the program will be invoke and it will start from top

; -------------------------		
; SAY GOODBYE - Closing portion of the program. Has two ways to close 1) because user didn't enter in numbers 
;		in descending order or 2) because they chose to leave the program. Both are traveled to by conditional jumps.
; -------------------------	

; To execute if getting out with no errors
get_out:
	mov		EDX, OFFSET goodbye
	call	WriteString
	call	Crlf
	Invoke	ExitProcess,0		; exit to operating system

; To execute if getting out with issue (not descending input)
get_out_descending:
	mov		EDX, OFFSET order_err_prmpt
	call	WriteString
	call	Crlf
	call	Crlf
	mov		EDX, OFFSET goodbye
	call	WriteString
	call	Crlf
	Invoke	ExitProcess,0		; exit to operating system

main ENDP

END main
