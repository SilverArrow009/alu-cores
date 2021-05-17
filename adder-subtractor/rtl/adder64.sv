// uncomment the bottom line if not using testbench
// `include "adder64_if.sv"

module adder64 (
    adder64_if.inst if0
);
    // logic carries[63:0];
    generate
        genvar i;
        for(i=0; i<63; i=i+1) begin : carries
            bit carry;
        end
    endgenerate
    // LSB of adder
    full_adder_cla fa0 (
        .a(if0.op1[0]),
        .b(if0.op2[0]),
        .c_in(if0.carry_in),
        .sum(if0.result[0]),
        .c_out(carries[0].carry)
    );
    // MSB of the adder
    full_adder_cla fa2 (
        .a(if0.op1[63]),
        .b(if0.op2[63]),
        .c_in(carries[62].carry),
        .sum(if0.result[63]),
        .c_out(if0.carry_out)
    );
    // Intermittent bits 
    generate
        for (i = 1; i<63; i=i+1) begin : adder64
            full_adder_cla fa3 (
                .a(if0.op1[i]),
                .b(if0.op2[i]),
                .c_in(carries[i-1].carry),
                .sum(if0.result[i]),
                .c_out(carries[i].carry)
            );
        end
    endgenerate
endmodule