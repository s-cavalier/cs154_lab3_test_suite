        .text
main:
        addi   $t0, $zero, 5
        addi   $t1, $zero, 10

        slt    $t2, $t0, $t1         # $t2 = 1 (5 < 10)
        slt    $t3, $t1, $t0         # $t3 = 0 (10 !< 5)

        beq    $t2, $t3, fail        # expect not equal
        addi   $t4, $zero, 1         # PASS
        beq    $zero, $zero, exit

fail:
        addi   $t4, $zero, -1        # FAIL
        beq    $zero, $zero, exit

exit:
        nop
