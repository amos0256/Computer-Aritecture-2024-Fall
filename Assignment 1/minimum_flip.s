    .data
example_1:
    .word 2, 6, 5
example_2:
    .word 4, 2, 7
example_3:
    .word 1, 2, 3
format:
    .asciz "Minimum flips is "
newline:
    .asciz ".\n"

    .text
    .global main
main:
    # example_1
    la    t0, example_1        # load address of example_1
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # example_2
    la    t0, example_2        # load address of example_2
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # example_3
    la    t0, example_3        # load address of example_3
    lw    a0, 0(t0)
    lw    a1, 4(t0)
    lw    a2, 8(t0)
    jal   ra, min_flips
    jal   ra, print_result

    # exit program
    li    a7, 10               # syscall exit
    ecall

# min flips function
min_flips:
    li    t0, 0                # flips = 0
    li    t1, 31               # i = 31, 31 bits

loop:
    bltz   t1, end_loop        # if i < 0, goto end_loop

    srl    t2, a0, t1          # bitA = (a >> i) & 1
    andi   t2, t2, 1

    srl    t3, a1, t1          # bitB = (b >> i) & 1
    andi   t3, t3, 1

    srl    t4, a2, t1          # bitC = (c >> i) & 1
    andi   t4, t4, 1

    beqz   t4, add_flip        # if bitC == 0, goto add_flip
    beqz   t2, check_b         # if bitA == 0, goto check_b
    j      continue_loop

add_flip:
    add    t0, t0, t2          # flips += bitA
    add    t0, t0, t3          # flips += bitB
    j      continue_loop

check_b:
    bnez   t3, continue_loop   # if bitB != 0, goto continue_loop
    addi   t0, t0, 1           # flips += 1

continue_loop:
    addi   t1, t1, -1          # i--
    j      loop

end_loop:
    mv     a0, t0              # restore return value
    ret

# print result function
print_result:
    mv t0, a0                  # t0 = minimum flips result
    
    la a0, format
    li a7, 4
    ecall

    mv a0, t0
    li a7, 1
    ecall

    la a0, newline
    li a7, 4
    ecall

    ret