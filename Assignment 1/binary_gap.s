.data
input1:   .word   3
input2:   .word   42051
input3:   .word   805306368
format1:  .string "The binary gap of "
format2:  .string " is "
newline:  .asciiz "\n"

.text
binary_gap:
    addi sp, sp, -4
    sw ra, 0(sp)            # save return address

    mv t0, a0               # t0 = input number
    li t1, -1               # last = -1
    li t2, 0                # max_gap = 0
    li t3, 0                # i counter

loop:
    li t4, 32               # 32 bits integer
    bge t3, t4, end_loop    # if i >= 32, goto end_loop

    # check the LSB
    andi t5, t0, 1          # extract the LSB
    beqz t5, shift_right    # if t3 == 0, goto shift_right

    # if (last != -1)
    li t6, -1
    beq t1, t6, update_last # if last == -1, goto update_last

    # if (i - last > max_gap)
    sub t6, t3, t1          # t6 = i - last
    bge t2, t6, update_last # if i - last > max_gap, goto update_last
    mv t2, t6               # max_gap = i - last

update_last:
    mv t1, t3               # last = i

shift_right:
    srli t0, t0, 1          # n >>= 1
    addi t3, t3, 1          # i++
    j loop                  # goto loop

end_loop:
    mv a0, t2               # return max_gap
    lw ra, 0(sp)            # restore return address
    addi sp, sp 4           # restore stack pointer
    jr ra

main:
    # input 1
    la a0, input1           # load address of input1
    lw a0, 0(a0)            # load input1 into a0
    jal ra, binary_gap      # call binary_gap
    # print the result of input 1
    lw a1, input1
    jal print_result

    # input 2
    la a0, input2           # load address of input2
    lw a0, 0(a0)            # load input2 into a0
    jal ra, binary_gap      # call binary_gap
    # print the result of input 2
    lw a1, input2
    jal print_result

    # input 3
    la a0, input3           # load address of input3
    lw a0, 0(a0)            # load input3 into a0
    jal ra, binary_gap      # call binary_gap
    # print the result of input 3
    lw a1, input3
    jal print_result

    # exit the program
    li a7, 10
    ecall

print_result:
    mv t0, a1               # t0 = input value               
    mv t1, a0               # t1 = binary gap result

    la a0, format1
    li a7, 4
    ecall

    mv a0, t0
    li a7, 1
    ecall

    la a0, format2
    li a7, 4
    ecall

    la a0, t1
    li a7, 1
    ecall

    la a0, newline
    li a7, 4
    ecall

    jr ra