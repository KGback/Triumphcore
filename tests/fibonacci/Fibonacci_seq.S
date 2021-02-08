add x0,x0,x0;
add x0,x0,x0;
add x0,x0,x0;
add x0,x0,x0;
lw x4, 3(x0);
lw x5, 1(x0);
lw x6, 2(x0);
add x7,x5,x6;
sw x6,1(x0);
sw x7,2(x0);
sub x4,x4,x1;
nop;
nop;
bne x4,x0,-4;
nop;
nop;
bne x4,x7,-16
nop;
nop;