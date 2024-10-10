.data
test_num: .word 20
test_data: .word 2, 14227, 22674, 28864, 31649, 20975, 22181, 11350, 20409, 18526, 1399, 10944, 28693, 24509, 29763, 25829, 15952, 20041, 12062, 27150
golden:.word 30, 18, 17, 17, 17, 17, 17, 18, 17, 17, 21, 18, 17, 17, 17, 17, 18, 17, 18, 17
pass_msg: .string "All test data passed!\n"
error_msg: .string "Something wrong!\n"

.text
j   MAIN
no_for_loop_clz:
#########################################################################
# argument:                                                             
#   x                       <- a0                                       
# variable:                                                             
#   count                   <- t0
# return value:                                                         
#   count                   <- a0                                        
#########################################################################
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

MAIN:
li      s0, 19
la      t0, test_data   # int test_data[20] = {25448, 1422, ...    
la      t1, golden      # int golden[20] = {17, 18, 17, 17, ...
lw      t2, test_num    
li      t3, 0x1         # bool pass = true;
li      t4, 0x0         # int i = 0

MAIN_FOR:
lw      a0, 0(t0)   # a0 = test_data[0]
# caller save
addi    sp, sp, -24
sw      ra, 0(sp)
sw      t0, 4(sp)
sw      t1, 8(sp)
sw      t2, 12(sp)
sw      t3, 16(sp)
sw      t4, 20(sp)
jal     ra, no_for_loop_clz
# retrieve caller save
lw      ra, 0(sp)
lw      t0, 4(sp)
lw      t1, 8(sp)
lw      t2, 12(sp)
lw      t3, 16(sp)
lw      t4, 20(sp)
addi    sp, sp, 24
mv      t5, a0
lw      t6, 0(t1)   # t6 = golden[0]
beq     t5, t6, END_IF_ERROR    # if (my_clz(test_data[i]) != golden[i])
IF_ERROR:
li      t3, 0x0         # pass = false;
END_IF_ERROR:

addi    t4, t4, 0x1     # i++
addi    t0, t0, 0x4     # point to test_data[i]
addi    t1, t1, 0x4     # point to test_data[i]
blt     t4, t2, MAIN_FOR
END_MAIN_FOR:

bne     t3, x0, IF_PASS
ELSE_NOT_PASS:
# printf("Something wrong!");
addi    a0, x0, 1
la      a1, error_msg
addi    a2, x0, 22
addi    a7, x0, 64
ecall
li      a7, 10
ecall
IF_PASS:
# printf("All test data passed!"); 
addi    a0, x0, 1
la      a1, pass_msg
addi    a2, x0, 22
addi    a7, x0, 64
ecall
END_IF_PASS:
# return
li      a7, 10
ecall