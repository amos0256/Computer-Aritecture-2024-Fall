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

    # example 1
    la t0, example_1        # load address of example_1
    lw a0, 0(t0)
    lw a1, 4(t0)
    lw a2, 8(t0)
    jal ra, min_flips       # call min_flips
    # print the result of example 1
    jal print_result

    # example 2
    la t0, example_2        # load address of example_2
    lw a0, 0(t0)
    lw a1, 4(t0)
    lw a2, 8(t0)
    jal ra, min_flips       # call min_flips
    # print the result of example 1
    jal print_result

    # example 3
    la t0, example_3        # load address of example_3
    lw a0, 0(t0)
    lw a1, 4(t0)
    lw a2, 8(t0)
    jal ra, min_flips       # call min_flips
    # print the result of example 3
    jal print_result

    # exit the program
    li a7, 10
    ecall

max_num:
    addi sp, sp, -16
    sw ra, 12(sp)           # save return address

    mv t4, t1               # set temporary max A
    blt t4, t2, check_B     # if A < B, goto check_B
    j check_C               # goto check_C

check_B:
    mv t4, t2               # set max to B

check_C:
    blt t4, t3, end_max_num # if max < C, goto end_max_num
    mv t4, t3               # set max to C
    
end_max_num:
    mv t1, t4
    lw ra, 12(sp)           # restore return address
    addi sp, sp, 16         # restore stack
    ret

min_flips:
    li t0, 0                # flips = 0

    # compute the maxBit = 31 - __builtin_clz(maxNum(a, b, c))
    jal max_num              # call max_num function

    li t2, 31               # t2 = 31
    clz t3, t1              # t3 = __builtin_clz(max_num)
    sub t4, t2, t3          # t4 = maxBit

    li t5, 0                # i counter

for_loop:
    bgt t5, t4, end_loop    # if i > maxBit, goto end_loop

    # extract bitA, bitB, bitC
    srl t6, t1, t5          # t6 = a >> i
    andi t6, t6, 1          # bitA = (a >> i) & 1
    srl t3, t2, t5          # t3 = b >> i
    andi t3, t3, 1          # bitB = (b >> i) & 1
    srl t4, t3, t5          # t4 = c >> i
    andi t4, t4, 1          # bitC = (c >> i) & 1

    # compute the flip times
    beq t4, x0, flip_case   # if bitC == 0, goto flip_case
    beq t6, x0, check_bitB  # if bitA == 0, goto check_bitB
    j end_inner_if

check_bitB:
    beq t3, x0, add_flip    # if bitB == 0, goto add_flip
    j end_inner_if

add_flip:
    addi t0, t0, 1          # flips += 1

flip_case:
    add t0, t0, t6          # flips += bitA
    add t0, t0, t3          # flips += bitB
    j end_case

end_case:
    addi t5, t5, 1          # i++
    j for_loop              # goto for_loop

end_loop:
    ret

print_result:
    mv t6, a0               # t0 = minimum flips result
    
    la a0, format
    li a7, 4
    ecall

    mv a0, t6
    li a7, 1
    ecall

    la a0, newline
    li a7, 4
    ecall

    ret