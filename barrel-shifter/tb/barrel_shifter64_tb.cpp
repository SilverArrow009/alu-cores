#include <verilated.h>
#include "obj_dir/Vbarrel_shifter64_wrapper.h"
#include <iostream>
#include <bits/stdc++.h>

#define NUM_TEST_CASES 4
#define TEST_MODE "MANUAL"

using namespace std;

long bit_rotate (long in, int shamt, bool dir) {
    if(dir) {   // rotate right
        long result = (in >> shamt) | (in << (64-shamt));
        return result;
    } else {
        long result = (in << shamt) | (in >> (64-shamt));
        return result;
    }
}

int main (int argc, char** argv, char** env)
{
    // Instantiate the dut
    Vbarrel_shifter64_wrapper* dut = new Vbarrel_shifter64_wrapper;
    // declare signals to validate the results
    long in, result;
    unsigned shamt, mode;
    // simulate for n times
    for (int i = 0; i < NUM_TEST_CASES; i++)
    {
        // Choose random inputs
        if(TEST_MODE == "RANDOM") {
            in = rand();
            shamt = rand() % 64;
            mode = rand() % 4;
        } else {
            in = 0x80000000;
            shamt = 1;
            mode = 5;
        }
        // calculate result
        switch (mode)
        {
            case 1: result = in >> shamt; break;    // right shift
            case 4: result = bit_rotate(in, shamt, false); break;   // left rotate
            case 5: result = bit_rotate(in, shamt, true); break;    // right rotate
            default: result = in << shamt; break; // left shift
        }
        // Assign the inputs
        dut->in = in;
        dut->shift_amount = shamt;
        dut->shift_type = mode;
        // Evaluate the model
        dut->eval();
        // Report the results
        printf("in = %x, shift_amount = %ld, shift_type = %x\t", in, shamt, mode );
        if (result == dut->result) {
            cout << "OUTPUT MATCHES" << endl;
        } else {
            printf("OUTPUT MISMATCHES. Expected result = %x, actual result = %x\n", result, dut->result );
        }
    }
    // Free up the allocated space
    delete dut;
    return 0;
}