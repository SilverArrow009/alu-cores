#include <verilated.h>
#include "obj_dir/Vbarrel_shifter64_wrapper.h"
#include <iostream>
#include <bits/stdc++.h>

#define NUM_TEST_CASES 50

using namespace std;

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
        in = rand();
        shamt = rand() % 64;
        mode = rand() % 2;
        // calculate result
        switch (mode)
        {
            case 0: result = in << shamt; break;
            case 1: result = in >> shamt; break;
            // case 2: result = in <<< shamt; break;
            // case 3: result = in <<< shamt; break;
        }
        // Assign the inputs
        dut->in = in;
        dut->shift_amount = shamt;
        dut->shift_type = mode;
        // Evaluate the model
        dut->eval();
        // Report the results
        printf("in = %ld, shift_amount = %ld, shift_type = %d\t", in, shamt, mode );
        if (result == dut->result) {
            cout << "OUTPUT MATCHES" << endl;
        } else {
            printf("OUTPUT MISMATCHES. Expected result = %ld, actual result = %ld\n", result, dut->result );
        }
    }
    // Free up the allocated space
    delete dut;
    return 0;
}