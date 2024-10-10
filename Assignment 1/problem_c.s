# translate problem C in Quiz 1 from C code to a complete RISC-V assembly program
    .data
examples:
    .word 0x7C00
    .word 0x0001 
    .word 0x3C00

expected_res:
    .word 0x7F800000
    .word 0x33800000
    .word 0x3F800000

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

    lw    a0, 0(t0)           # a0 = example
    jal   ra, fp16_to_fp32
    
    lw    a1, 0(t1)           # a1 = expected result
    jal   ra, print_result

    addi  t0, t0, 4           # move to the next example
    addi  t1, t1, 4           # move to the next expected result

    addi  t3, t3, 1           # increment loop counter
    j     loop_example

end_main:
    # exit program
    li    a7, 10              # syscall exit
    ecall

fp16_to_fp32:
    # preserve ra register
    addi  sp, sp, -4
    sw    ra, 0(sp)           # store return address
    
    # preserve t0-t3 registers
    addi  sp, sp, -16
    sw    t0, 0(sp)
    sw    t1, 4(sp)
    sw    t2, 8(sp)
    sw    t3, 12(sp)

    slli  a0, a0, 16          # shift left by 16 bits to extend to 32-bit

    # sign bit
    li    t0, 0x80000000      # load sign mask
    and   t1, a0, t0          # t1 is sign = w & 0x80000000

    # nonsign bit
    li    t0, 0x7FFFFFFF      # load nonsign mask
    and   t2, a0, t0          # t2 is nonsign = w & 0x7FFFFFFF

    # normalize the number, use my_clz to count leading zeros
    mv    a0, t2
    jal   ra, my_clz
    
    li    t0, 5
    blt   t0, a0, renorm      # if renorm_shift > 5, goto renorm
    li    a0, 0               # renorm_shift = 0
    j     continue 

renorm:
    sub   a0, a0, t0          # renorm_shift -= 5

continue:
    # handle inf_nan_mask
    li    t0, 0x04000000
    add   t3, t2, t0          # inf_nan_mask = nonsign + 0x04000000
    srai  t3, t3, 8           # inf_nan_mask >>= 8
    li    t0, 0x7F800000
    and   t3, t3, t0          # inf_nan_mask

    # handle zero_mask
    addi  t4, t2, -1          # zero_mask = nonsign - 1
    srai  t4, t4, 31          # zero_mask >> 31

    # normalize and adjust exponent
    sll   t5, t2, a0          # shift nonsign left by renorm_shift
    srai  t5, t5, 3           # shift nonsign right by 3
    li    t0, 0x70
    sub   t0, t0, a0          # 0x70 - renorm_shift
    slli  t0, t0, 23          # adjust exponent and place in proper position
    add   t5, t5, t0          # add the adjust exponent to the result

    # combine inf_nan_mask and handle zero case
    or    t5, t5, t3          # or with inf_nan_mask
    not   t4, t4              # invert zero_mask
    and   t5, t5, t4          # zero out result if zero_mask is set

    # combine sign and result
    or    a0, t1, t5          # combine with sign bit

    # restore t0-t3 registers
    lw    t0, 0(sp)
    lw    t1, 4(sp)
    lw    t2, 8(sp)
    lw    t3, 12(sp)
    addi  sp, sp, 16
    
    # restore t0-t3 registers
    lw    ra, 0(sp)
    addi  sp, sp, 4

    ret

# my_clz function
my_clz:
    # preserve t1 and t2 registers
    addi  sp, sp, -8
    sw    t1, 0(sp)
    sw    t2, 4(sp)

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

    # preserve t1 and t2 registers
    lw    t1, 0(sp)
    lw    t2, 4(sp)
    addi  sp, sp, 8

    ret

# print result function
print_result:
    bne   a0, a1, wrong_case  # if a0 != a1, goto wrong_case

    li    a7, 4
    ecall

    la    a0, correct_msg
    li    a7, 4
    ecall
    j     end_print

wrong_case:
    la    a0, wrong_msg
    li    a7, 4
    ecall

end_print:
    la    a0, newline
    li    a7, 4
    ecall

    ret