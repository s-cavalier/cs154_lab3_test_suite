#!/bin/bash

# Compile executable
(
    cd interpreter || exit 1
    make
)

SCRIPT_DIR="ASM_test_scripts"
TMP_DIR="interpret_tmp"
ALL_PASSED=true

mkdir -p $TMP_DIR

for file in "$SCRIPT_DIR"/*.asm; do
    if [[ -f "$file" ]]; then
        echo "Running: ./interpreter/mipsinterpret $file $TMP_DIR/asmexe.mips $TMP_DIR/asmmem.mips lab3_test.py"
        OUTPUT=$(./interpreter/mipsinterpret "$file" $TMP_DIR/asmexe.mips $TMP_DIR/asmmem.mips lab3_test.py)
        echo "$OUTPUT"

        # Look for "Passed!" in the output
        if echo "$OUTPUT" | grep -q "Passed!"; then
            echo -e "\e[92mTest passed for $file\e[0m"
        else
            echo -e "\e[91mTest failed for $file\e[0m"
            ALL_PASSED=false
        fi
        echo ""
    fi
done

if $ALL_PASSED; then
    echo -e "\e[92m\e[5mAll tests passed!\e[0m"
else
    echo -e "\e[91mDidn't pass all tests.\e[0m"
fi
