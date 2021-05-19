#include <verilated.h>
#include "obj_dir/Vadder_subtractor_wrapper.h"
#include <iostream>
#include <bits/stdc++.h>

#define NUM_TEST_CASES 50

using namespace std;

int main (int argc, char** argv, char** env)
{
    // Instantiate the dut
    Vadder_subtractor_wrapper* dut = new Vadder_subtractor_wrapper;
    // declare signals to validate the results
    long op1, op2, result;
    int mode;
    // simulate for 5 times
    for (int i = 0; i < NUM_TEST_CASES; i++)
    {
        // Choose random inputs
        op1 = rand();
        op2 = rand();
        mode = rand() % 2;
        if(mode) {
            result = op1 - op2;
        } else {
            result = op1 + op2;
        }
        // Assign the inputs
        dut->op1 = op1;
        dut->op2 = op2;
        dut->mode= mode;
        // Evaluate the model
        dut->eval();
        // Report the results
        printf("op1 = %ld, op2 = %ld, mode = %d\t", op1, op2, mode );
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