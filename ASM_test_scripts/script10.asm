        .text
main:
        # $t0 = 0xFFFF0000 via lui
        lui    $t0, 0xFFFF

        # OR with 0x8000 (MSB set if treated as signed)
        # If sign-extended, 0x8000 → 0xFFFF8000 → error
        # If zero-extended, 0x8000 → 0x00008000 → correct

        ori    $t1, $t0, 0x8000      # Expected: 0xFFFF8000 if zero-extended

        # Reference: build expected value manually
        lui    $t2, 0xFFFF
        ori    $t2, $t2, 0x8000      # $t2 = 0xFFFF8000

        # Compare $t1 and $t2
        beq    $t1, $t2, success

        # FAIL path
        addi   $t3, $zero, -1
        beq    $zero, $zero, exit

success:
        addi   $t3, $zero, 1         # PASS

exit:
        nop
