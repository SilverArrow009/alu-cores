module stage_la #(parameter shamt = 1)(
    stage_if.inst if0
);
    logic [127:0] shift_bus;
    always_comb begin : shift_left_arithmetic
        if (if0.in[63])
            shift_bus = '1;
        else
            shift_bus = '0;
        if (if0.sig) begin
                shift_bus[63+shamt:shamt] = if0.in;
                if0.out = shift_bus[63:0];
            end
        else
            if0.out = if0.in;
    end
endmodule : stage_la