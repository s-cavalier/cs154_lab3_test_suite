#ifndef UTILS_H
#define UTILS_H

#include "Utils.h"
#include <iostream>
using namespace std;

Hardware::Instruction Hardware::instruction_builder(RAM& mem, const WORD& binary_instr) {
    BYTE opcode = static_cast<BYTE>(binary_instr >> 26);
    BYTE rs = static_cast<BYTE>((binary_instr >> 21) & 0b11111);
    BYTE rt = static_cast<BYTE>((binary_instr >> 16) & 0b11111);
    BYTE rd = static_cast<BYTE>((binary_instr >> 11) & 0b11111);
    BYTE funct = static_cast<BYTE>(binary_instr & 0b111111);
    short imm = static_cast<short>(binary_instr & 0xFFFF);

    if (opcode > 4) Utils::assert(rt > 0, "Attempted to write to $zero reg");
    if (opcode == 0 && funct != 0xC) Utils::assert(rd > 0, "Attempted to write to $zero reg");

    switch (opcode) {
        case 8: // ADDI
            return Instruction([rs, rt, imm] (RAM& mem) { mem.rf[rt] = mem.rf[rs] + static_cast<int>(imm); });
        case 0xf: // LUI
            return Instruction([rs, rt, imm] (RAM& mem) { mem.rf[rt] = static_cast<int>(imm) << 16; });
        case 0xd: // ORI
            return Instruction([rs, rt, imm] (RAM& mem) { mem.rf[rt] = mem.rf[rs] + (static_cast<int>(imm) & 0xFFFF); });
        case 0x23: // LW
            return Instruction([rs, rt, imm] (RAM& mem) { mem.rf[rt] = mem.d_mem[ mem.rf[rs] + static_cast<int>(imm) ]; });
        case 0x2b: // SW
            return Instruction([rs, rt, imm] (RAM& mem) { mem.d_mem[ mem.rf[rs] + static_cast<int>(imm) ] = mem.rf[rt];});
        case 0x4:
            return Instruction([rs, rt, imm] (RAM& mem) { if (mem.rf[rs] == mem.rf[rt]) mem.pc += static_cast<int>(imm); });
        default:
            break;
    }

    switch (funct) {
        case 0x20: // ADD
            return Instruction([rd, rs, rt] (RAM& mem) { mem.rf[rd] = mem.rf[rs] + mem.rf[rt]; });
        case 0x24: // AND
            return Instruction([rd, rs, rt] (RAM& mem) { mem.rf[rd] = mem.rf[rs] & mem.rf[rt]; });
        case 0x2a: // SLT
            return Instruction([rd, rs, rt] (RAM& mem) { mem.rf[rd] = (mem.rf[rs] < mem.rf[rt] ? 1 : 0); });
        case 0xC:
            return Instruction([] (RAM& mem) { mem.exit_flag = true; });
        default:
            break;
    }

    Utils::error("Somehow got bad opcode and funct for: " + std::to_string(binary_instr));

    return Instruction(0);

};

bool Parser::valid_instruction(const string& instr) {
    // giant return statement - since its only like 9 instructions idrc it is readable, fast, and inlineable (?) and that is what matters
    // plus the alternatives are for loop or using a hash set, both less readable
    return
    (instr == "add") ||
    (instr == "and") ||
    (instr == "addi") ||
    (instr == "lui") ||
    (instr == "ori") ||
    (instr == "slt") ||
    (instr == "lw") ||
    (instr == "sw") ||
    (instr == "beq");
}

BYTE Parser::reg_name_to_index(const std::string& reg) {
    // Basically just a switch case, but not a thing in C++ so this is how it is
    if (reg == "$zero") return 0;
    if (reg == "$at") return 1;
    if (reg == "$v0") return 2;
    if (reg == "$v1") return 3;
    if (reg == "$a0") return 4;
    if (reg == "$a1") return 5;
    if (reg == "$a2") return 6;
    if (reg == "$a3") return 7;
    if (reg == "$t0") return 8;
    if (reg == "$t1") return 9;
    if (reg == "$t2") return 10;
    if (reg == "$t3") return 11;
    if (reg == "$t4") return 12;
    if (reg == "$t5") return 13;
    if (reg == "$t6") return 14;
    if (reg == "$t7") return 15;
    if (reg == "$s0") return 16;
    if (reg == "$s1") return 17;
    if (reg == "$s2") return 18;
    if (reg == "$s3") return 19;
    if (reg == "$s4") return 20;
    if (reg == "$s5") return 21;
    if (reg == "$s6") return 22;
    if (reg == "$s7") return 23;
    if (reg == "$t8") return 24;
    if (reg == "$t9") return 25;
    if (reg == "$k0") return 26;
    if (reg == "$k1") return 27;
    if (reg == "$gp") return 28;
    if (reg == "$sp") return 29;
    if (reg == "$fp") return 30;
    if (reg == "$ra") return 31;

    Utils::error("Bad register: " + reg);

    return -1;
}

WORD Parser::instr_to_hex(token_string& instr, const unordered_map<string, WORD>& label_table, const WORD& tmp_pc) {
    BYTE opcode = 0, rd = 0, rs = 0, rt = 0, funct = 0;
    short imm = 0;

    if (instr[0] == "addi") opcode = 0x8;
    if (instr[0] == "lui") opcode = 0xf;
    if (instr[0] == "ori") opcode = 0xd;
    if (instr[0] == "lw") opcode = 0x23;
    if (instr[0] == "sw") opcode = 0x2b;
    if (instr[0] == "beq") opcode = 0x4;

    if (instr[0] == "add") funct = 0x20;
    if (instr[0] == "and") funct = 0x24;
    if (instr[0] == "slt") funct = 0x2a;

    if (opcode == 0x23 || opcode == 0x2b ) {
        Utils::assert(instr[1].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1]);
        instr[1].pop_back();

        rt = reg_name_to_index(instr[1]);
        WORD end_of_imm = instr[2].find_first_of('(');
        WORD end_of_string = instr[2].find_first_of(')', end_of_imm);

        int immediate_val = stoi( instr[2].substr(0, end_of_imm) );
        Utils::assert(immediate_val <= 32767 && immediate_val >= -32768, "immediate value out of range [-32768, 32767]:\n" + immediate_val);
        imm = static_cast<short>(immediate_val);

        rs = reg_name_to_index( instr[2].substr(end_of_imm + 1, end_of_string - end_of_imm - 1) );
        return build_i_type(opcode, rs, rt, imm);
    }

    if (opcode == 0xf) {
        Utils::assert(instr[1].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1]);
        instr[1].pop_back();
        rt = reg_name_to_index(instr[1]);

        int immediate_val = stoi( instr[2] );
        Utils::assert(immediate_val <= 32767 && immediate_val >= -32768, "BEQ immediate value out of range (your program too big) [-32768, 32767]:\n" + instr[3] + " => " + to_string(immediate_val));
        imm = static_cast<short>(immediate_val);
        return build_i_type(opcode, rs, rt, imm);
    }

    if (!opcode) {
        Utils::assert(instr[1].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1]);
        instr[1].pop_back();
        Utils::assert(instr[2].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1] + " " + instr[2]);
        instr[2].pop_back();

        rd = reg_name_to_index(instr[1]);
        rs = reg_name_to_index(instr[2]);
        rt = reg_name_to_index(instr[3]);

        return build_r_type(rd, rs, rt, funct);
    }

    Utils::assert(instr[1].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1]);
    instr[1].pop_back();
    Utils::assert(instr[2].back() == ',', "Missing comma:\n" + instr[0] + " " + instr[1] + " " + instr[2]);
    instr[2].pop_back();

    rt = reg_name_to_index(instr[1]);
    rs = reg_name_to_index(instr[2]);

    int immediate_val = 0;
    if (opcode == 4) immediate_val = label_table.at(instr[3]) - tmp_pc - 1;
    else immediate_val = stoi( instr[3] );

    Utils::assert(immediate_val <= 32767 && immediate_val >= -32768, "BEQ immediate value out of range (your program too big) [-32768, 32767]:\n" + instr[3] + " => " + to_string(immediate_val));
    imm = static_cast<short>(immediate_val);
    
    return build_i_type(opcode, rs, rt, imm);
}

WORD Parser::build_i_type(const BYTE& opcode, const BYTE& rs, const BYTE& rt, const short& imm) {
    WORD out = opcode;
    out <<= 5;
    out |= rs;
    out <<= 5;
    out |= rt;
    out <<= 16;
    out |= static_cast<WORD>(imm) & 0xFFFF;

    return out;
}

WORD Parser::build_r_type(const BYTE& rd, const BYTE& rs, const BYTE& rt, const BYTE& funct) {
    WORD out = rs;
    out <<= 5;
    out |= rt;
    out <<= 5;
    out |= rd;
    out <<= 11;
    out |= funct;

    return out;
}

std::string Parser::get_first_token(const std::string& line) {
    if (line.empty()) return "";
    WORD start = line.find_first_not_of(" \t\n\r");
    if (start == WORD(std::string::npos)) return "";
    WORD end = line.find_first_of(" \t\n\r", start);
    
    return line.substr(start, end - start);
}

void Utils::assert(const bool& good_eval, const string& on_error) {
    if (good_eval) return;
    Utils::error(on_error);
}

void Utils::error(const std::string& exit_msg) {
    cerr << "Encountered error:\n" << exit_msg << endl;
    exit(1);
}

#endif