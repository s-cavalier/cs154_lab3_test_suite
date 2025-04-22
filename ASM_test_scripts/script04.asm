        .text
main:
        addi   $t0, $zero, 1         # $t0 = 1
        addi   $t1, $zero, 1         # $t1 = 1
        addi   $t2, $zero, 2         # $t2 = 2

        # this branch should trigger (equal)
        beq    $t0, $t1, match
        addi   $t3, $zero, -1        # FAIL path
        beq    $zero, $zero, exit

match:
        # this branch should not trigger
        beq    $t0, $t2, fail        # not taken
        addi   $t3, $zero, 1         # PASS
        beq    $zero, $zero, exit

fail:
        addi   $t3, $zero, -1
        beq    $zero, $zero, exit

exit:
        nop
