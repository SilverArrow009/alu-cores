module stage_ra #(parameter shamt = 1)(
    stage_if.inst if0
);
    logic [127:0] shift_bus;
    always_comb begin : shift_right_arithmetic
        if (if0.in[63])
            shift_bus = '1;
        else
            shift_bus = '0;
        if (if0.sig) begin
                shift_bus[127-shamt:64-shamt] = if0.in;
                if0.out = shift_bus[127:64];
            end
        else
            if0.out = if0.in;
    end
endmodule : stage_ra