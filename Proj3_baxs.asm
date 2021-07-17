TITLE Project 3 - Data Validation, Looping, and Constants     (Proj3_baxs.asm)

; Author: Scott Bax
; Last Modified: 17 JuLy 2021
; OSU email address: baxs@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project 1    Due Date: 18 July 2021
; Description: Program that asks user for negative integers within a specific range, and to enter a non-negative
;		number when they want to stop entering negative numbers. Once that occurs, Program will display how many 
;		valid numbers were entered, the max/min/sum/round average of the valid numbers. If user inputs incorrect
;		program will display error until correct number is input. 

INCLUDE Irvine32.inc


; (insert constant definitions here)

.data

; Intro variables
program_title		BYTE	"Scott Bax - Project Project 3 -  Data Validation, Looping, and Constants", 0
user_name_prompt	BYTE	"What is your name? ", 0
user_name			BYTE	33 DUP(0) ; User name to be entered
user_greeting		BYTE	"Hey what's up, ", 0

; Data calculation prompt variables
number_req_prompt	BYTE	"Please enter numbers between [-200, -100] or between [-50, -1].", 0
how_finish_prompt	BYTE	"To see the results when you are finished, enter a non-negative number.", 0
enter_num_prompt 	BYTE	"Enter a number: ", 0
invalid_num_prompt 	BYTE	"Wrong Number!", 0

; Data calculation variables
number_input		SDWORD	?		  ; user number input
min_value			SDWORD	?		  	  
max_value			SDWORD	?		  
sum_value			SDWORD	?		  
valid_numbers		DWORD	0

;Display result prompts
valid_number_res1_p	BYTE	"You entered ", 0
valid_number_res2_p	BYTE	" valid numbers!", 0
min_value_res_p		BYTE	"The minimum valid number is ", 0
max_value_res_p		BYTE	"The maximum valid number is ", 0
sum_value_res_p		BYTE	"The valid numbers sum is ", 0


; Done
finished_prompt		BYTE	"DONE DONE DONE", 0

.code
main PROC

; -------------------------
; INTRODUCTION - Display program title and programmer's name. Get user name and greet them.
; -------------------------
	;title
	mov		EDX, OFFSET program_title
	call	WriteString
	call	Crlf
	call	Crlf

	;get user name
	mov		EDX, OFFSET user_name_prompt
	call WriteString
	mov		EDX, OFFSET user_name
	mov		ECX, 33
	call ReadString

	;greet user
	mov		EDX, OFFSET user_greeting
	call WriteString
	mov		EDX, OFFSET user_name
	call WriteString
	call	Crlf
	call	Crlf
	call	Crlf

; -------------------------
; INSTRUCTIONS/GET DATA - Displays instructions to user. Get data from user
; -------------------------

	;ask for numbers with parameters
	mov		EDX, OFFSET number_req_prompt
	call	WriteString
	call	Crlf

	;tell how to finish
	mov		EDX, OFFSET how_finish_prompt
	call	WriteString
	call	Crlf

	;ask for a number between [-200, -100] or between [-50, -1] while looping
	ask_number:
		
		;prompt
		mov		EDX, OFFSET enter_num_prompt
		call	WriteString

		;get number
		call	ReadInt				; number now in variable
		mov		number_input, EAX


		;if number is not within range and not non-negative 

		cmp		number_input, -51
		jg		above_neg_fifty		;above -50

		cmp		number_input, -200
		jl		wrong_number		;below -200

		cmp		number_input, -99
		jnl		wrong_number		;above -100

		;loop again
		jmp		right_number


	;To execute if number is above neg fifty
	above_neg_fifty:

		cmp		number_input, -1
		jg		data_calc		;below -200
		jmp		right_number


	
	

	;To execute if wrong number is entered
	wrong_number:

		;Error mesage
		mov		EDX, OFFSET invalid_num_prompt
		call	WriteString
		call	Crlf

		;go back to ask number loop
		jmp		ask_number
	

	;To execute if right number is entered. will track number of valid numbers/min and max value
	right_number:


		;count valid numbers
		mov		EAX, 1
		mov		EBX, valid_numbers
		add		EAX, EBX
		mov		valid_numbers, EAX

		;update sum of valid numbers
		mov		EBX, number_input
		add		sum_value, EBX


		;initialize both min/max variables to first input
		cmp		valid_numbers, 1
		je		initialize_min_max


		;track min value
		mov		EAX, number_input
		cmp		min_value, EAX
		jg		update_min

		;track max value
		mov		EAX, number_input
		cmp		max_value, EAX
		jl		update_max

		;go back to ask number loop
		jmp		ask_number

	;initialize both min/max variables to first input
	initialize_min_max:
		;update value
		mov		EAX, number_input
		mov		min_value, EAX

		;update value
		mov		EAX, number_input
		mov		max_value, EAX


		;go back to ask number loop
		jmp		ask_number


	;Updates min value
	update_min:
		
		;update value
		mov		EAX, number_input
		mov		min_value, EAX

		;go back to ask number loop
		jmp		ask_number

	;Updates max value
	update_max:

		;update value
		mov		EAX, number_input
		mov		max_value, EAX


		;go back to ask number loop
		jmp		ask_number



; -------------------------
; CALCULATE DATA - Calculate Data for final results
; -------------------------
	;To execute if number is above neg fifty
	data_calc:
		
		


; -------------------------
; DISPLAY DATA - Calculate Data for final results
; -------------------------

	;display number of valid numbers entered 
	mov		EDX, OFFSET valid_number_res1_p
	call	WriteString			; display prompt part 1

	mov		EAX, valid_numbers
	call	WriteDec			; dislpay number

	mov		EDX, OFFSET valid_number_res2_p
	call	WriteString			; display prompt part 1
	call	Crlf

	;display max value
	mov		EDX, OFFSET max_value_res_p
	call	WriteString			; display prompt

	mov		EAX, max_value
	call	WriteInt			; dislpay number
	call	Crlf

	;display min value
	mov		EDX, OFFSET min_value_res_p
	call	WriteString			; display prompt

	mov		EAX, min_value
	call	WriteInt			; dislpay number
	call	Crlf

	;display sum value
	mov		EDX, OFFSET sum_value_res_p
	call	WriteString			; display prompt

	mov		EAX, sum_value
	call	WriteInt			; dislpay number
	call	Crlf



; -------------------------
;  PARTING MESSAGE - Display farewell to user
; -------------------------

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
