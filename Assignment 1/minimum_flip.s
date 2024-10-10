    .data
examples:
    .word 1, 2, 3
    .word 51041, 65280, 716177407
    .word 143165576, 715827882, 1

expected_res:
    .word 0
    .word 14
    .word 23

correct_msg:
    .asciz "Correct"

wrong_msg:
    .asciz "Wrong"

newline:
    .asciz ".\n"

    .text
    .global main
main:
    la    t0, examples        # t0 = address of examples
    la    t1, expected_res    # t1 = address of expected_res
    li    t2, 3               # t2 = number of examples
    li    t3, 0               # t3 = for loop counter

loop_example:
    beq   t2, t3, end_main    # if counter == 3, goto end_main

    # load the current example's value
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)

    jal   ra, min_flips       # call min_flips

    lw    a1, 0(t1)           # load the current expected result
    jal   ra, print_result    # call print_result 

    addi  t0, t0, 12          # move to the next example
    addi  t1, t1, 4           # move to the next expected result

    addi  t3, t3, 1           # increment loop counter
    j     loop_example

end_main:
    # exit program
    li    a7, 10              # syscall exit
    ecall

# min flips function
min_flips:
    # preserve t0-t3 registers
    addi  sp, sp, -16
    sw    t0, 0(sp)
    sw    t1, 4(sp)
    sw    t2, 8(sp)
    sw    t3, 12(sp)
    
    li    t0, 0               # flips = 0
    li    t1, 31              # i = 31, 31 bits

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
    mv    a0, t0              # restore return value
    
    # restore t0-t3 registers
    lw    t0, 0(sp)
    lw    t1, 4(sp)
    lw    t2, 8(sp)
    lw    t3, 12(sp)
    addi  sp, sp, 16
    
    ret

# print result function
print_result:
    bne    a0, a1, wrong_case # if a0 != a1, goto wrong_case

    la     a0, correct_msg
    li     a7, 4
    ecall
    j     end_print

wrong_case:
    la     a0, wrong_msg
    li     a7, 4
    ecall

end_print:
    la     a0, newline
    li     a7, 4
    ecall

    ret