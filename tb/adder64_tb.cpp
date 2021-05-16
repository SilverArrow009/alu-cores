#include <verilated.h>
#include "obj_dir/Vadder64_wrapper.h"
#include <iostream>

int main (int argc, char** argv, char** env)
{
    Vadder64_wrapper* dut = new Vadder64_wrapper;
    for (int i = 0; i < 5; i++)
    {
        dut->eval();
    }
    delete dut;
    return 0;
}