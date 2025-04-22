        .text
main:
        ############################################################################
        # test1: simple arithmetic (add, addi) & compare result == 42
        ############################################################################
        addi   $t1, $zero, 15        # $t1 = 15
        addi   $t2, $zero, 27        # $t2 = 27
        add    $t3, $t1, $t2         # $t3 = 42
        addi   $t4, $zero, 42        # $t4 = expected 42
        beq    $t3, $t4, test2       # if equal → next test
        beq    $zero, $zero, fail    # else → fail

test2:
        ############################################################################
        # test2: memory load/store (sw, lw)
        ############################################################################
        addi   $t5, $zero, 100       # base addr = 100
        addi   $t6, $zero, 170       # value = 170
        sw     $t6, 0($t5)           # Mem[100] = 170
        lw     $t7, 0($t5)           # $t7 = Mem[100]
        beq    $t6, $t7, test3       # if equal → next test
        beq    $zero, $zero, fail    # else → fail

test3:
        ############################################################################
        # test3: ori zero-extension (lui, ori)
        ############################################################################
        lui    $t8, 0xFFFF           # $t8 = 0xFFFF_0000
        ori    $t8, $t8, 0x8000      # $t8 = 0xFFFF_8000 (zero-extended imm)
        lui    $s0, 0xFFFF           # build expected similarly
        ori    $s0, $s0, 0x8000      # $s0 = 0xFFFF_8000
        beq    $t8, $s0, test4       # if match → next test
        beq    $zero, $zero, fail    # else → fail

test4:
        ############################################################################
        # test4: large loop sum 1→50 (addi, add, slt, beq)
        ############################################################################
        addi   $t9, $zero, 1         # counter = 1
        addi   $s1, $zero, 50        # upper bound = 50
        addi   $s2, $zero, 0         # sum = 0

sum_loop:
        add    $s2, $s2, $t9         # sum += counter
        addi   $t9, $t9, 1           # counter++
        slt    $t0, $s1, $t9         # t0 = (50 < counter)
        beq    $t0, $zero, sum_loop  # if not done → repeat

        addi   $s3, $zero, 1275      # expected sum of 1..50 = 1275
        beq    $s2, $s3, test5       # if equal → next test
        beq    $zero, $zero, fail    # else → fail

test5:
        ############################################################################
        # test5: nested branching → classify a value as negative/zero/positive
        ############################################################################
        addi   $t0, $zero, -5        # input value = –5
        addi   $t1, $zero, 0         # zero for comparison

        beq    $t0, $t1, cls_zero    # if input == 0 → zero case
        slt    $t2, $t0, $zero       # t2 = (input < 0)
        beq    $t2, $zero, cls_pos   # if not negative → positive case

        # negative case
        addi   $s4, $zero, -1        # code = –1
        beq    $zero, $zero, cls_done

cls_zero:
        addi   $s4, $zero, 0         # code = 0
        beq    $zero, $zero, cls_done

cls_pos:
        addi   $s4, $zero, 1         # code = 1

cls_done:
        addi   $s5, $zero, -1        # expected code for this input = –1
        beq    $s4, $s5, all_pass    # if match → all tests passed
        beq    $zero, $zero, fail    # else → fail

all_pass:
        addi   $v0, $zero, 1         # overall PASS
        beq    $zero, $zero, exit

fail:
        addi   $v0, $zero, -1        # overall FAIL
        beq    $zero, $zero, exit

exit:
        nop
