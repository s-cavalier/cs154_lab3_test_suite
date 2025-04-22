        .text
main:
        # initialize loop counter and sum
        addi   $t0, $zero, 10        # counter = 10
        addi   $t1, $zero, 0         # sum = 0

loop:
        add    $t1, $t1, $t0         # sum += counter
        addi   $t0, $t0, -1          # counter--

        beq    $t0, $zero, exit      # if counter==0 → exit
        beq    $zero, $zero, loop    # else repeat

exit:
        nop
