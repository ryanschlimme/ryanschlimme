; find the smaller of two 8-bit unsigned integers
; both numbers in memory location x4000, [15:8] is the first, [7:0] is the second
; store the smaller in x4001 [7:0]

.ORIG x3000

LDI R0, MAIN;   place the one-word bit vector into R0
LDI R1, MAIN;   place the one-word bit vector into R0
LD R2, MASK1;   place the first mask into R2
LD R3, MASK2;   place the second mask into R3

AND R0, R2, R0; AND the number with MASK1, result is 8 most significant bits
AND R1, R3, R1; AND the number with MASK2, result is 8 least significant bits

ADD R4, R1, #0
LD R2, MOVE1
LD R3, MOVE2
;LOOPstart
    AND R4, R4, R3
    BRz #4
    ADD R2, R2, R2
    ADD R3, R3, R3
    BRnp #-5
;LOOPstop

; Logic to determine which is larger
NOT R5, R4
ADD R5, R5, #1
ADD R5, R5, R0

; Store to Memory
BRnz #2;        if the value of R5 is negative or 0, skip to next STI
STI R4, DST;    if the value of R5 is positive, store R0 to the destination
BRp #1;         if the value of R5 is positive, proceed to HALT
STI R0, DST;    if the value of R5 is positive, store R1 to the destination

HALT
MAIN .FILL x4000; address for combined number
MASK1 .FILL x00FF
MASK2 .FILL xFF00
MOVE1 .FILL x0001
MOVE2 .FILL xFF00
DST .FILL x4001
.END