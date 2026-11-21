.ORIG x5000

;Store my return address
ADD R6, R6, #-1
STR R7, R6, #0



;Save Registers before use
ADD R6, R6, #-1
STR R3, R6, #0


ADD R6, R6, #-1
STR R2, R6, #0

ADD R6, R6, #-1
STR R1, R6, #0

ADD R6, R6, #-1
STR R0, R6, #0 ;Print will call my trap and then return R0, so i need to save it, Or I could just save every register beforehand, so I can then just have all the register I want 


;Logic somewhere in here

;DISPLAY
;Tens Loop Division
    ADD R2 R0 #0
    AND R1 R1 #0
DIVIDE_LOOP_START
    ADD R2 R2 #-10
BRn DIVIDE_LOOP_END
    ADD R1 R1 #1
    BRnzp DIVIDE_LOOP_START
DIVIDE_LOOP_END
ADD R2 R2 #10 ; get rid of the deficit from -10
;Outputs tens place
LD R3 DEC_TO_ASCII
ADD R1 R1 #0  ;if zero branch and print ones place
BRz ONES_PLACE
ADD R0 R1 R3
OUT
ONES_PLACE
;Outputs Ones place
ADD R0 R2 #0
ADD R0 R3 R0
OUT




;Get my loot 
LDR R0, R6, #0 ;Pop R0 and Get the value from R6 and store it in R0
ADD R6, R6, #1

LDR R1, R6, #0 ;Pop R1
ADD R6, R6, #1

LDR R2, R6, #0 ; Pop R2
ADD R6, R6, #1

LDR R3, R6, #0 ; Pop R3
ADD R6, R6, #1

LDR R7, R6, #0 ; Pop R7
ADD R6, R6, #1


;Return R0 value
RET

DEC_TO_ASCII .FILL #48
.END