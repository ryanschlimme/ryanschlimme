.ORIG x4000

a .FILL x000B;
b .FILL x000A;
.BLKW #2

LEA R0, #0;
LEA R1, #0;
LD R0, #-5;
LD R1, #-5;

HALT;

.END