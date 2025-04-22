#!/bin/bash

TMP_DIR="interpret_tmp"

(
    cd interpreter || exit 1
    make
)

mkdir -p $TMP_DIR

interpreter/mipsinterpret $1 $TMP_DIR/asmexe.mips $TMP_DIR/asmmem.mips lab3_test.py
