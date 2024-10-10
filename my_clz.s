my_clz:
#########################################################################
# argument:                                                             
#   x                       <- a0                                       
# variable:                                                             
#   count                   <- t0                                       
#   i                       <- t1
# return value:                                                         
#   count                   <- a0                                        
#########################################################################
li      t0, 0x0         # int count = 0
li      t1, 0x1F        # int i = 31
    
li      t2, 0x1         # 1U
CLZ_LOOP:
sll     t3, t2, t1      # t3 <- (1U << i)
and     t3, a0, t3      # t3 <- x & (1U << i)
beq     t3, x0, CLZ_IF_END
CLZ_IF:
mv      a0, t0
ret
CLZ_IF_END:
        
addi    t0, t0, 0x1     # count++
addi    t1, t1, -0x1    # --i
bge     t1, x0, CLZ_LOOP
    
mv      a0, t0
ret