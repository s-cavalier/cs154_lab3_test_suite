        .text
main:
        lui    $t0, 0xCAFE           # $t0 = 0xCAFE0000
        ori    $t0, $t0, 0xBEEF      # $t0 = 0xCAFEBEEF

        addi   $t1, $zero, 200       # memory address
        sw     $t0, 0($t1)
        lw     $t2, 0($t1)

        beq    $t0, $t2, success
        addi   $t3, $zero, -1        # FAIL
        beq    $zero, $zero, exit

success:
        addi   $t3, $zero, 1         # PASS
        beq    $zero, $zero, exit

exit:
        nop
