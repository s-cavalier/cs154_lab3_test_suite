        .text
main:
        # set up base address and test value
        addi   $t0, $zero, 100       # base = 100
        addi   $t1, $zero, 170       # val = 170

        sw     $t1, 0($t0)           # mem[100] = 170
        lw     $t2, 0($t0)           # $t2 = mem[100]

        # compare
        beq    $t1, $t2, mem_pass
        addi   $t3, $zero, -1        # FAIL
        beq    $zero, $zero, exit

mem_pass:
        addi   $t3, $zero, 1         # PASS
        beq    $zero, $zero, exit

exit:
        nop
