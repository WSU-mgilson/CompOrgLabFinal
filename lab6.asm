; Sample Code for Lab 6
; This sample code implements the int main() function

.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; int main()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Main's return value
LD R6, STACK_BASE		; R6 = x6000
LD R4 WORDZ

; Main's return address
ADD R6, R6, #-1			; R6 = x5FFF
STR R7, R6, #0

; Previous frame pointer
ADD R6, R6, #-1			; R6 = x5FFE
STR R5, R6, #0          ;Storing loot(Previous Frame ptr R5) stored at x5FFE

; Set frame pointer
ADD R5, R6, #0			; R5 = R6 = x5FFE Current frame ptr = R5 = x5FFE

; node_t *head
ADD R6, R6, #-1			; R6 = x5FFD
AND R0, R0, #0			; R0 = 0
STR R0, R6, #0

; char selection
ADD R6, R6, #-1			; R6 = x5FFC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while(selection != 'q')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Perform the check for the while loop
; We check to see if char selection is equal to 'q'
; If equal, quit
; It not equal, continue running the loop
CHECK_WHILE
LDR R0, R5, #-2			; R0 = char selection
LD R1, LOWERCASE_Q
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRz BREAK_WHILE_LOOP

; Print the options menu
LEA R0, PROMPT_MENU
PUTS

; Get a character from the keyboard and put it in selection
; (We don't have to write our own scanf() function)
GETC
STR R0, R5, #-2			; Store the character on the runtime stack in char selection (R0 = char selection)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if(selection == 'p')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'p'
LD R1, LOWERCASE_P
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_A			; If not equal to 'p' check 'a'

; Display prompt
LEA R0, PROMPT_PRINT
PUTS

; node_t **head (&head) (input to printList())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

JSR PRINT_LIST

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'a')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'a'
ELSE_IF_A
LD R1, LOWERCASE_A
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp ELSE_IF_R

;Note, R5 starts at x5FFE

; int a
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0          ;Storing loot(R0 = 0) at &R6(x5FFB)

; Display prompt
LEA R0, PROMPT_ADD
PUTS

; Call TRAP service routine for getting number here
; For testing purposes, let's use 12
;AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
;ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine
TRAP x40

; Store number entered into int a
STR R0, R5, #-3         ;Store loot(R0 = a) at &R5(x5FFB)

; node_t **head (&head) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FFA Make space
ADD R0, R5, #-1			; R0 = &head(Address of head) = x5FFD
STR R0, R6, #0          ; Store the value of R0 at the &R6 currently(Put my loot in a chest)

; int added (a) (input to addValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3         ;; R0 = a, from x5FFB
STR R0, R6, #0          ; Store the value of R0 at the &R6 currently(Put my loot in a chest)

JSR ADD_VALUE

; Pop int added
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int a
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; else if(selection == 'r')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if char selection is equal to 'r'
ELSE_IF_R
LD R1, LOWERCASE_R
NOT R1, R1
ADD R1, R1, #1
ADD R1, R0, R1
BRnp CONTINUE_WHILE_LOOP

; int r
ADD R6, R6, #-1			; R6 = x5FFB
AND R0, R0, #0
STR R0, R6, #0

; Display prompt
LEA R0, PROMPT_REMOVE
PUTS

; Call TRAP service routine for getting number here
; For testing purposes, let's use 12
;AND R0, R0, #0			; Comment this out after implementing your TRAP service routine
;ADD R0, R0, #12			; Comment this out after implementing your TRAP service routine
TRAP x40
; Store number entered into int r
STR R0, R5, #-3

; node_t **head (&head) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FFA
ADD R0, R5, #-1			; R0 = &head = x5FFD
STR R0, R6, #0

; int removed (r) (input to removeValue())
ADD R6, R6, #-1			; R6 = x5FF9
LDR R0, R5, #-3
STR R0, R6, #0

JSR REMOVE_VALUE

; Pop int removed
ADD R6, R6, #1			; R6 = x5FFA

; Pop node_t **head
ADD R6, R6, #1			; R6 = x5FFB

; Pop int r
ADD R6, R6, #1			; R6 = x5FFC

BRnzp CONTINUE_WHILE_LOOP

; Loop back to check the while loop condition again
CONTINUE_WHILE_LOOP
BRnzp CHECK_WHILE

BREAK_WHILE_LOOP

; Pop local variables in main
ADD R6, R6, #2			; R6 = x5FFE

; Pop previous frame pointer
LDR R5, R6, #0
ADD R6, R6, #1			; R6 = x5FFF

; Pop return address
LDR R7, R6, #0
ADD R6, R6, #1			; R6 = x6000

HALT

STACK_BASE .FILL x6000
WORDZ .FILL Gloabls ; Needs to be closer, because I cant reach it in lc3

LOWERCASE_A .FILL x0061
LOWERCASE_P .FILL x0070
LOWERCASE_Q .FILL x0071
LOWERCASE_R .FILL x0072

PROMPT_MENU .STRINGz 	"Available options:\np - Print linked list\na - Add value to linked list\nr - Remove value from linked list\nq - Quit\nChoose an option: "
PROMPT_PRINT .STRINGz 	"\nContents of the linked list: \n"
PROMPT_ADD .STRINGz 	"\nType a number to add: \n"
PROMPT_REMOVE .STRINGz 	"\nType a number to remove: \n"
Gloabls
.BLKW #100
NEWLINE .STRINGz "\n"
ARROW .STRINGz " -> "





; void printList(node_t **head)
PRINT_LIST
ADD R6, R6, #-1 
STR R7, R6, #0

ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

ADD R6, R6, #-1
STR R3, R6, #0

ADD R6, R6, #-1
STR R2, R6, #0

ADD R6, R6, #-1
STR R1, R6, #0

ADD R6, R6, #-1
STR R0, R6, #0


LDR R0, R5, #2
LDR R1, R0, #0 ;current is in R1

;If curr == 0
;Print the newline



PRINT_ARROWS
ADD R1, R1, #0
    BRnz CUR_EQ_NULL
    LDR R0, R1, #0 ;Switch from LDR into R3 to R0 so my trap can see it
    ;ADD R2, R2, R3 testing
    TRAP x41
    LDR R1, R1, #1 
    BRnz CUR_EQ_NULL
LEA R0, ARROW
PUTS
BR PRINT_ARROWS
CUR_EQ_NULL
LEA R0, NEWLINE
PUTS

LDR R0, R6, #0 ;Pop R0
ADD R6, R6, #1

LDR R1, R6, #0 ;Pop R1
ADD R6, R6, #1

LDR R2, R6, #0 ;Pop R2
ADD R6, R6, #1

LDR R3, R6, #0 ;Pop R3
ADD R6, R6, #1


LDR R5, R6, #0 ;Pop R5
ADD R6, R6, #1

LDR R7, R6, #0 ;Pop R7 
ADD R6, R6, #1




RET

; void addValue(node_t **head, int added) ;need to check for null pointers
ADD_VALUE
ADD R6, R6, #-1 
STR R7, R6, #0

ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0


ADD R6, R6, #-1
STR R3, R6, #0

ADD R6, R6, #-1
STR R2, R6, #0

ADD R6, R6, #-1
STR R1, R6, #0

ADD R6, R6, #-1
STR R0, R6, #0




;R5 + 3 = my headf
LDR R0, R5, #3 
;If my head is 0 = null pointer, I dont think I would need to check for index out of bounds but Ill throw n on branch ;anyways
LDR R1, R0, #0 ;Store the value in R1 at R2
BRz NULL_PTR 

    LIST_STEP_THROUGH
    ADD R0, R1, #1
    LDR R2, R1, #1
BRz NULL_PTR
    ADD R1 R2, #0
    BR LIST_STEP_THROUGH
NULL_PTR

ADD R1, R4, #0
ADD R4, R4, #2

STR R1, R0, #0

LDR R2, R5, #2 ;2nd param -> R2
STR R2, R1, #0

AND R2, R2, #0
STR R2, R1, #1





LDR R0, R6, #0 ;Pop R0
ADD R6, R6, #1

LDR R1, R6, #0 ;Pop R1
ADD R6, R6, #1

LDR R2, R6, #0 ;Pop R2
ADD R6, R6, #1

LDR R3, R6, #0 ;Pop R3
ADD R6, R6, #1


LDR R5, R6, #0 ;Pop R5
ADD R6, R6, #1

LDR R7, R6, #0 ;Pop R7 
ADD R6, R6, #1
;with example(31) before RET R6 = x5FF9
RET

; void removeValue(node_t **head, int removed)
;Set the head to the next 
REMOVE_VALUE
ADD R6, R6, #-1 
STR R7, R6, #0

ADD R6, R6, #-1
STR R5, R6, #0
ADD R5, R6, #0

ADD R6, R6, #-1
STR R4, R6, #0

ADD R6, R6, #-1
STR R3, R6, #0

ADD R6, R6, #-1
STR R2, R6, #0

ADD R6, R6, #-1
STR R1, R6, #0

ADD R6, R6, #-1
STR R0, R6, #0


LDR R0, R5, #3  ;R0 is &head
LDR R1, R0, #0  ;Curr head is in R1

LDR R2, R5, #2
NOT R2, R2
ADD R2, R2, #1 ;R2 now is my inverted value

;Mybe I can flip R1, loop through the LL and if I subtract the current value from its NOT, I would need a branch for the result for on zero 
ADD R1, R1, #0

REMOVE
ADD R1, R1, #0

    BRz REM_DONE
    LDR R3, R1, #0
    ADD R3, R2, R3
    BRz ELEMENT_FOUND
    ADD R0, R1, #1
    LDR R1, R1, #1 
BR REMOVE
ELEMENT_FOUND
LDR R3, R1, #1 ;R3 now is pointing at the next addr
STR R3, R0, #0
REM_DONE


LDR R0, R6, #0 ;Pop R0
ADD R6, R6, #1

LDR R1, R6, #0 ;Pop R1
ADD R6, R6, #1

LDR R2, R6, #0 ;Pop R2
ADD R6, R6, #1

LDR R3, R6, #0 ;Pop R3
ADD R6, R6, #1

LDR R4, R6, #0 ;Pop R4
ADD R6, R6, #1


LDR R5, R6, #0 ;Pop R5
ADD R6, R6, #1

LDR R7, R6, #0 ;Pop R7 
ADD R6, R6, #1

RET

.END