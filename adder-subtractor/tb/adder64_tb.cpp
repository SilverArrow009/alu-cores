#include <verilated.h>
#include "obj_dir/Vadder64_wrapper.h"
#include <iostream>
#include <bits/stdc++.h>

using namespace std;

int main (int argc, char** argv, char** env)
{
    // Instantiate the dut
    Vadder64_wrapper* dut = new Vadder64_wrapper;
    // declare signals to validate the results
    long op1, op2, result;
    bool carry_in;
    // simulate for 5 times
    for (int i = 0; i < 5; i++)
    {
        // Choose random inputs
        op1 = rand();
        op2 = rand();
        carry_in = rand();
        result = op1 + op2 + (int) carry_in;
        // Assign the inputs
        dut->op1 = op1;
        dut->op2 = op2;
        dut->carry_in = carry_in;
        // Evaluate the model
        dut->eval();
        // Report the results
        printf("op1 = %ld, op2 = %ld, carry_in = %ld\t", op1, op2, carry_in );
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