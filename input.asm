.ORIG x4000



;Store my return address
ADD R6, R6, #-1
STR R7, R6, #0



;Save Registers before use
ADD R6, R6, #-1
STR R1, R6, #0


ADD R6, R6, #-1
STR R2, R6, #0

ADD R6, R6, #-1
STR R3, R6, #0

ADD R6, R6, #-1
STR R4, R6, #0



AND R1, R1, #0
AND R0, R0, #0
GETC;Writes first char to R0
OUT
ADD R1, R0, #0 ;Store R0 value into R1
AND R2, R2, #0
AND R3, R3, #0
ADD R3, R3, #10
AND R4, R4, #0
LD R4, ASCII_TO_DEC



ADD R1, R1, R4

LOOP_START
ADD R2, R2, R1
ADD R3, R3, #-1
BRp LOOP_START
;After tens   loop finishes for my example, R2 = 30

GETC ; Writes second char to R0
OUT
ADD R0, R0, R4


;Put result into R0
ADD R0, R2, R0



;Get my loot 
LDR R4, R6, #0 ;Pop R4
ADD R6, R6, #1

LDR R3, R6, #0 ;Pop R3
ADD R6, R6, #1

LDR R2, R6, #0 ; Pop R2
ADD R6, R6, #1

LDR R1, R6, #0 ; Pop R1
ADD R6, R6, #1

LDR R7, R6, #0 ; Pop R7
ADD R6, R6, #1


;Return R0 value
RET




ASCII_TO_DEC .FILL #-48
.END
