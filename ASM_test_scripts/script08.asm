        .text
main:
        addi   $t0, $zero, 1         # counter = 1
        addi   $t1, $zero, 100       # upper bound
        addi   $t2, $zero, 0         # sum = 0

loop:
        add    $t2, $t2, $t0         # sum += counter
        addi   $t0, $t0, 1           # counter++

        slt    $t3, $t1, $t0         # if upper < counter → done
        beq    $t3, $zero, loop

        # done
        # $t2 should be 5050
        beq    $zero, $zero, exit

exit:
        nop
