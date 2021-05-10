`include "adder64_if.sv"

module adder64_tb;
    adder64_if if0;
    adder64 add0(if0.inst);
    
    initial begin
        if0.op1  =   64'd24; if0.op2  =   64'd24; if0.carry_in = 1'b0;
        // $display($sformatf("op1 = %h, op2 = %h, carry_in = %h, result = %h, carry_out = %h", if0.op1, if0.op2, if0.carry_in, if0.result, if0.carry_out));
    end
    
endmodule