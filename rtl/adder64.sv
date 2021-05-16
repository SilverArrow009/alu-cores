// uncomment the bottom line if not using testbench
// `include "adder64_if.sv"

module adder64 (
    adder64_if.inst if0
);
    logic [63:0] carries;
    // LSB of adder
    full_adder_cla fa0 (
        .a(if0.op1[0]),
        .b(if0.op2[0]),
        .c_in(if0.carry_in),
        .sum(if0.result[0]),
        .c_out(carries[0])
    );
    // MSB of the adder
    full_adder_cla fa2 (
        .a(if0.op1[63]),
        .b(if0.op2[63]),
        .c_in(carries[62]),
        .sum(if0.result[63]),
        .c_out(if0.carry_out)
    );
    // Intermittent bits 
    generate
        genvar i;
        for (i = 1; i<63; i=i+1) begin : adder64
            full_adder_cla fa0 (
                .a(if0.op1[i]),
                .b(if0.op2[i]),
                .c_in(carries[i-1]),
                .sum(if0.result[i]),
                .c_out(carries[i])
            );
        end
    endgenerate
endmodule