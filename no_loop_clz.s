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