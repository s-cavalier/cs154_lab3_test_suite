        .text
main:
        addi   $t0, $zero, 250       # base addr
        addi   $t1, $zero, 42        # value to store
        sw     $t1, 4($t0)           # store at offset

        lw     $t2, 4($t0)           # load from offset

        beq    $t1, $t2, good
        addi   $t3, $zero, -1        # FAIL
        beq    $zero, $zero, exit

good:
        addi   $t3, $zero, 1         # PASS
        beq    $zero, $zero, exit

exit:
        nop
