        .text
main:
        # initialize registers
        addi   $t0, $zero, 15        # $t0 = 15
        addi   $t1, $zero, 27        # $t1 = 27

        # add
        add    $t2, $t0, $t1         # $t2 = 42

        # build 32‑bit patterns
        lui    $t3, 0x1234           # $t3 = 0x1234_0000
        ori    $t3, $t3, 0x5678      # $t3 = 0x1234_5678

        lui    $t4, 0xFFFF           # $t4 = 0xFFFF_0000
        ori    $t4, $t4, 0x000F      # $t4 = 0xFFFF_000F

        # bitwise and
        and    $t5, $t3, $t4         # $t5 = 0x1234_0000

        # slt tests
        slt    $t6, $t0, $t1         # $t6 = 1
        slt    $t7, $t1, $t0         # $t7 = 0

        # branch to set pass/fail in $t8
        beq    $t6, $t7, arith_fail
        beq    $zero, $zero, arith_pass

arith_fail:
        addi   $t8, $zero, -1        # FAIL
        beq    $zero, $zero, exit

arith_pass:
        addi   $t8, $zero, 1         # PASS
        beq    $zero, $zero, exit

exit:
        nop
