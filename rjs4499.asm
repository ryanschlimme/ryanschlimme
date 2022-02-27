; find the smaller of two 8-bit unsigned integers
; both numbers in memory location x4000, [15:8] is the first, [7:0] is the second
; store the smaller in x4001 [7:0]

.ORIG x3000

LDI R0, MAIN;   place the one-word bit vector into R0
LDI R1, MAIN;   place the one-word bit vector into R1
LD R2, MASK1;   place the first mask into R2
LD R3, MASK2;   place the second mask into R3

AND R0, R2, R0; AND the number with MASK1, result is 8 most significant bits
STI R0, DST1;   store number one into x4002
AND R1, R3, R1; AND the number with MASK2, result is 8 least significant bits

LD R2, SRCMask
LD R3, DSTMask
AND R0, R0, #0; initialize R4 (Result) to 0
; LOOP Start
    AND R4, R1, R2; inspect bit k using the source mask
    BRz #8;         if bit k=0, skip to update masks
    NOT R4, R1;     if bit k=1, OR DSTMask (R3) with number 2 (R1)
    NOT R5, R3
    AND R5, R4, R5
    NOT R0, R5
    ; Subtract out number 2 from answer
    NOT R4, R1
    ADD R4, R4, #1
    ADD R0, R4, R0
    ; Update Masks
    ADD R3, R3, R3
    ADD R2, R2, R2
    BRnp #-12
; LOOP End
STI R0, DST2

; Logic to determine which is larger
LDI R0, DST1; Load first number into R0
LDI R1, DST2; Load second number into R1
NOT R2, R1
ADD R2, R2, #1
ADD R2, R2, R0

; Store to Memory
BRnz #2;        if the value of R5 is negative or 0, skip to next STI
STI R0, DST;    if the value of R5 is positive, store R0 to the destination
BRp #1;         if the value of R5 is positive, proceed to HALT
STI R1, DST;    if the value of R5 is positive, store R1 to the destination

HALT
MAIN .FILL x4000; address for combined number
MASK1 .FILL x00FF
MASK2 .FILL xFF00
SRCMask .FILL x0100
DSTMask .FILL x0001
DST .FILL x4001
DST1 .FILL x4002
DST2 .FILL x4003
.END