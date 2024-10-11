.data
test_data1: .word 323, 929, 728, 175, 795, 464, 117, 994, 537, 629, 744, 254, 359, 554, 624, 231, 309, 198, 734, 531
test_data2: .word 384, 575, 450, 456, 985, 5, 572, 314, 411, 481, 393, 630, 352, 742, 17, 279, 130, 893, 770, 486
golden: .word 1, 1, 2, 1, 5, 1, 13, 2, 3, 37, 3, 2, 1, 2, 1, 3, 1, 1, 2, 9
test_num: .word 20
pass_msg: .string "All test data passed!\n"
error_msg: .string "Something wrong!\n"
.text
j MAIN

trailing_zeros:
#########################################################################
# argument:                                                             
#   x                       <- a0                                     
# variable:                                                             
#                                                                       
# return value:                                                         
#   count                   <- a0                                                           
#########################################################################
# reverse bits
li      t2, 0x55555555
srli    t0, a0, 0x1
and     t0, t0, t2
and     t1, a0, t2
slli    t1, t1, 0x1
or      a0, t1, t0
li      t2, 0x33333333
srli    t0, a0, 0x2
and     t0, t0, t2
and     t1, a0, t2
slli    t1, t1, 0x2
or      a0, t1, t0
li      t2, 0x0F0F0F0F
srli    t0, a0, 0x4
and     t0, t0, t2
and     t1, a0, t2
slli    t1, t1, 0x4
or      a0, t1, t0
li      t2, 0x00FF00FF
srli    t0, a0, 0x8
and     t0, t0, t2
and     t1, a0, t2
slli    t1, t1, 0x8
or      a0, t1, t0
li      t2, 0x0000FFFF
srli    t0, a0, 0x10
and     t0, t0, t2
and     t1, a0, t2
slli    t1, t1, 0x10
or      a0, t1, t0

# count leading zeros
li      t0, 0 # count = 0;
beq     a0, x0, IF_0 # if(x == 0)
j       IF_0_END
IF_0:
li      a0, 32
ret
IF_0_END:

li      t1, 0x0000FFFF
bltu     a0, t1, IF_0x0000FFFF # if (x <= 0x00FFFFFF)
beq     a0, t1, IF_0x0000FFFF
j       IF_0x0000FFFF_END
IF_0x0000FFFF:
addi    t0, t0, 16
slli    a0, a0, 16
IF_0x0000FFFF_END: 

li      t1, 0x00FFFFFF
bltu     a0, t1, IF_0x00FFFFFF # if (x <= 0x00FFFFFF)
beq     a0, t1, IF_0x00FFFFFF
j       IF_0x00FFFFFF_END
IF_0x00FFFFFF:
addi    t0, t0, 8
slli    a0, a0, 8
IF_0x00FFFFFF_END:

li      t1, 0x0FFFFFFF
bltu     a0, t1, IF_0FFFFFFF # if (x <= 0x0FFFFFFF)
beq     a0, t1, IF_0FFFFFFF
j       IF_0FFFFFFF_END
IF_0FFFFFFF:
addi    t0, t0, 4
slli    a0, a0, 4
IF_0FFFFFFF_END:

li      t1, 0x3FFFFFFF
bltu     a0, t1, IF_3FFFFFFF # if (x <= 0x3FFFFFFF)
beq     a0, t1, IF_3FFFFFFF
j       IF_3FFFFFFF_END
IF_3FFFFFFF:
addi    t0, t0, 2
slli    a0, a0, 2
IF_3FFFFFFF_END:

li      t1, 0x7FFFFFFF
bltu     a0, t1, IF_7FFFFFFF # if (x <= 0x7FFFFFFF)
beq     a0, t1, IF_7FFFFFFF
j       IF_7FFFFFFF_END
IF_7FFFFFFF:
addi    t0, t0, 1
IF_7FFFFFFF_END:
mv      a0, t0 # return count
ret


gcd:
#########################################################################
# argument:                                                             
#   u                       <- a0                                       
#   v                       <- a1                                       
# variable:                                                             
#   i                       <- t0
#   j                       <- t1
#   k                       <- t2                                                                  
# return value:                                                         
#   G.C.D.                  <- a0                                                           
#########################################################################
bne     a0, x0, END_IF_U_EQ_ZERO
IF_U_EQ_ZERO:
mv      a0, a1      # return v
ret
END_IF_U_EQ_ZERO:
bne     a1, x0, END_IF_V_EQ_ZERO
IF_V_EQ_ZERO:
ret                 # return u
END_IF_V_EQ_ZERO:
# caller save
addi    sp, sp, -12
sw      ra, 0(sp)
sw      a0, 4(sp)
sw      a1, 8(sp)
jal     ra, trailing_zeros
mv      t0, a0          # int i = trailing_zeros(u)
lw      ra, 0(sp)
lw      a0, 4(sp)
lw      a1, 8(sp)
addi    sp, sp, 12
srl     a0, a0, t0      # u >>= i;
# caller save
addi    sp, sp, -16
sw      ra, 0(sp)
sw      a0, 4(sp)
sw      a1, 8(sp)
sw      t0, 12(sp)
mv      a0, a1          # trailing_zeros(v)
jal     ra, trailing_zeros
mv      t1, a0          # int j = trailing_zeros(v)
lw      ra, 0(sp)
lw      a0, 4(sp)
lw      a1, 8(sp)
lw      t0, 12(sp)
addi    sp, sp, 16
srl     a1, a1, t1      # v >>= j;
blt     t0, t1, IF_I_LESS_THAN_J   # int k = (i < j) ? i : j;
j       ELSE_I_LESS_THAN_J  
IF_I_LESS_THAN_J:
mv      t2, t0
j       END_I_LESS_THAN_J
ELSE_I_LESS_THAN_J:
mv      t2, t1
END_I_LESS_THAN_J:
WHILE_TRUE:
bgt     a0, a1, IF_U_BIGGER_THAN  # if (u > v)
j       END_IF_U_BIGGER_THAN
IF_U_BIGGER_THAN:
mv      t3, a0
mv      a0, a1
mv      a1, t3
END_IF_U_BIGGER_THAN:
sub     a1, a1, a0              # v -= u;

beq     a1, x0, IF_V_EQ_ZERO_IN_LOOP
j       END_IF_V_EQ_ZERO_IN_LOOP
IF_V_EQ_ZERO_IN_LOOP:
sll     a0, a0, t2          # return u << k;
ret
END_IF_V_EQ_ZERO_IN_LOOP:
# caller save
addi    sp, sp, -24
sw      ra, 0(sp)
sw      a0, 4(sp)
sw      a1, 8(sp)
sw      t0, 12(sp)
sw      t1, 16(sp)
sw      t2, 20(sp)
mv      a0, a1                  # trailing_zeros(v);
jal     ra, trailing_zeros
mv      t3, a0                  # t3 = trailing_zeros(v);
lw      ra, 0(sp)
lw      a0, 4(sp)
lw      a1, 8(sp)
lw      t0, 12(sp)
lw      t1, 16(sp)
lw      t2, 20(sp)
addi    sp, sp, 24
srl     a1, a1, t3              # v >>= register  t3;
j       WHILE_TRUE
END_WHILE_TRUE:

MAIN:
la      t0, test_data1          # t0 -> test_data1[0]
la      t1, test_data2          # t1 -> test_data2[0]
la      t2, golden              # t2 -> golden[0]
li      t3, 0x1                 # bool pass = true;
lw      t4, test_num            # t4 = 20
li      t5, 0x0                 # int i = 0
MAIN_FOR:
lw      t6, 0(t0)               # test_data1[t0]
mv      a0, t6
lw      t6, 0(t1)               # test_data2[t0]
mv      a1, t6
# caller save
addi    sp, sp, -28
sw      ra, 0(sp)
sw      t0, 4(sp)
sw      t1, 8(sp)
sw      t2, 12(sp)
sw      t3, 16(sp)
sw      t4, 20(sp)
sw      t5, 24(sp)
jal     ra, gcd
lw      ra, 0(sp)
lw      t0, 4(sp)
lw      t1, 8(sp)
lw      t2, 12(sp)
lw      t3, 16(sp)
lw      t4, 20(sp)
lw      t5, 24(sp)
addi    sp, sp, 28
lw      t6, 0(t2)

bne     a0, t6, IF_ERROR
j       END_IF_ERROR
IF_ERROR:
li      t3, 0x0
END_IF_ERROR:
addi    t0, t0, 4
addi    t1, t1, 4
addi    t2, t2, 4
addi    t5, t5, 0x1         # i++
blt     t5, t4, MAIN_FOR    # i <= 19
END_MAIN_FOR:

beq     t3, x0, ELSE_IF_PASS
IF_PASS:
# printf("All test data passed!");
addi    a0, x0, 1
la      a1, pass_msg
addi    a2, x0, 22
addi    a7, x0, 64
ecall
j END_IF_PASS  
ELSE_IF_PASS:
# printf("Something wrong!");
addi    a0, x0, 1
la      a1, error_msg
addi    a2, x0, 22
addi    a7, x0, 64
ecall
END_IF_PASS:

# return
li      a7, 10
ecall