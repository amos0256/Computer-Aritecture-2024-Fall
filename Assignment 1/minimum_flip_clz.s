    .data
example_1:
    .word 1, 2, 3
example_2:
    .word 51041, 65280, 716177407
example_3:
    .word 143165576, 715827882, 1

format:
    .asciz "Minimum flips is "
newline:
    .asciz ".\n"

    .text
    .global main
main:
    # example_1
    la    t0, example_1       # load address of example_1
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # example_2
    la    t0, example_2       # load address of example_2
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # example_3
    la    t0, example_3       # load address of example_3
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # exit program
    li    a7, 10              # syscall exit
    ecall

# my_clz function
my_clz:
    li    t0, 0               # counter = 0
    li    t1, 31              # i counter
    li    t2, 1
    
my_clz_loop:
    bltz  t1, end_my_clz      # if t1 < 0, goto end_my_clz
    sll   t3, t2, t1          # t3 = 1 << i
    and   t4, a0, t3          # t4 = x & (1 << i)
    bnez  t4, end_my_clz      # if t4 == 1, goto end_my_clz
    addi  t0, t0, 1           # count++
    addi  t1, t1, -1          # i--
    j     my_clz_loop

end_my_clz:
    mv    a0, t0              # return the count
    ret

# max number function
max_num:
    mv    t0, a0              # set temporary max a
    blt   t0, a1, set_b       # if a < b, goto set_b
    j     check_c             # goto check_c

set_b:
    mv    t0, a1              # set max to b

check_c:
    blt   a2, t0, end_max_num # if max > c, goto end_max_num
    mv    t0, a2              # set max to c
    
end_max_num:
    mv    a0, t0
    ret

# min flips function
min_flips:
    # push the input parameters into the stack
    addi  sp, sp, -16         # allocate space on the stack
    sw    ra, 12(sp)
    sw    a0, 0(sp)
    sw    a1, 4(sp)
    sw    a2, 8(sp)

    jal   ra, max_num         # find the maximum of a, b, c
    jal   ra, my_clz          # compute the leading zero
    
    li    t0, 0               # flips = 0
    li    t1, 31
    sub   t1, t1, a0          # i = 31 - number of leading zero

    # restore the input parameters from the stack
    lw    a0, 0(sp)
    lw    a1, 4(sp)
    lw    a2, 8(sp) 
    addi  sp, sp, 12          # deallocate space from the stack

loop:
    bltz  t1, end_loop        # if i < 0, goto end_loop

    srl   t2, a0, t1          # bitA = (a >> i) & 1
    andi  t2, t2, 1

    srl   t3, a1, t1          # bitB = (b >> i) & 1
    andi  t3, t3, 1

    srl   t4, a2, t1          # bitC = (c >> i) & 1
    andi  t4, t4, 1

    beqz  t4, add_flip        # if bitC == 0, goto add_flip
    beqz  t2, check_b         # if bitA == 0, goto check_b
    j     continue_loop

add_flip:
    add   t0, t0, t2          # flips += bitA
    add   t0, t0, t3          # flips += bitB
    j     continue_loop

check_b:
    bnez  t3, continue_loop   # if bitB != 0, goto continue_loop
    addi  t0, t0, 1           # flips += 1

continue_loop:
    addi  t1, t1, -1          # i--
    j     loop

end_loop:
    mv     a0, t0             # restore return value
    lw     ra, 0(sp)
    addi   sp, sp, 4
    ret

# print result function
print_result:
    mv     t0, a0             # t0 = minimum flips result
    
    la     a0, format
    li     a7, 4
    ecall

    mv     a0, t0
    li     a7, 1
    ecall

    la     a0, newline
    li     a7, 4
    ecall

    ret