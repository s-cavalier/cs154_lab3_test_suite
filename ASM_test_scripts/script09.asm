        .text
main:
        # set test input value
        addi   $t0, $zero, -5        # change to 0 or positive to test different paths

        # check if $t0 == 0
        addi   $t1, $zero, 0
        beq    $t0, $t1, is_zero

        # check if $t0 < 0 using slt
        slt    $t2, $t0, $zero
        beq    $t2, $zero, is_positive

        # if we reach here, it's negative
        addi   $t3, $zero, -1        # code: -1 = negative
        beq    $zero, $zero, exit

is_zero:
        addi   $t3, $zero, 0         # code: 0 = zero
        beq    $zero, $zero, exit

is_positive:
        addi   $t3, $zero, 1         # code: 1 = positive
        beq    $zero, $zero, exit

exit:
        nop
