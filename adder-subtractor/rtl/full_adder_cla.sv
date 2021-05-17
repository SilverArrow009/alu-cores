module full_adder_cla (
    input logic a, b, c_in,
    output logic sum, c_out
);
    bit Pi, Gi;
    always_comb begin
    // Assign to the relevant variables
        Pi   =   a ^ b;
        Gi   =   a & b;
        sum  =   Pi ^ c_in;
        c_out=   Gi | (Pi & c_in);
    end
endmodule
