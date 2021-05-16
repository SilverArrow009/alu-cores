module full_adder_cla (
    input a, b, c_in,
    output bit sum, c_out
);
    bit Pi, Gi;
    always_comb begin
    // Assign to the relevant variables
    assign Pi   =   a ^ b;
    assign Gi   =   a & b;
    assign sum  =   Pi ^ c_in;
    assign c_out=   Gi | (Pi & c_in);
    end
endmodule
