# CS154 Lab3 Testing Suite
This is a jumble of code designed to test the pyrtl-based CPU for CS154's lab3.

### Usage
First, code up any MIPS ASM testing scripts in the `ASM_test_scripts` folder. Make sure that:
- `add, and, addi, lui, ori, slt, lw, sw, beq` are the only instructions used.
- Ensure that an `exit:` label exists with no instructions after, and when you want to exit the program use the instruction `beq $zero, $zero, exit`. This is effectively the same as a syscall, and just tells the compiler/interpreter to loop infinitely or exit, respectively. Then move/copy your python lab file (___must___ be named `ucsbcs154lab3_cpu.py`, as was downloaded) into the same folder.
- Make sure that you have turned the `run_all_tests.sh` into an executable with `chmod +x run_all_tests.sh`, then run `./run_all_tests.sh` to test all of the files in ASM_test_scripts.
- It will compare the final memory values (`d_mem` and `rf`) of the CPU developed on pyrtl with the final memory values of the C++ MIPS interpreter. There should be clear feedback if you passed or not.
- If any do not pass and you want to test a single file, run `chmod +x run_test.sh` once to make `run_test.sh` an executable. Then run `./run_test.sh <script>`, and the compiled instructions will be in `interpret_tmp/asmexe.mips` and the final memory values of the interpreter will be in `interpret_tmp/asmmem.mips` to compare with the final values in your pyrtl CPU. The very first line is a comma-separated list of all of the values in the registers, the second line is a comma-seperated list of all of used RAM memory addresses and the corresponding data stored in them.

### Using the hand-rolled interpreter/compiler
You can also if you want fiddle with the source code or just compile/use the MIPS interpreter in the `interpreter` folder. Just run `make` and then the formatting is `./mipsinterpret <MIPS src> <compile output> <memory output> <lab3_test.py file>`.

### Operating System Dependencies
Assuming you have C++ and Python downloaded, the `lab3_test.py` and interpreter/compiler should both work just fine, but the shell scripts may have issues on Windows specifically since Windows doesn't natively have a way to run them, but you *should* be able to run them with Git Bash, Cygwin, or MinGW, which may have come with g++ if you have C++ installed.

### Trustability
This repo already has 11 different tests in the ASM_test_scripts folder that I have checked and all seem to correctly function when run with the hand-rolled interpreter/compiler. If there are any issues, feel free to mention them.
