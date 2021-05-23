module stage_ll #(parameter shamt = 1) (
    stage_if.inst if0
);
    logic [127:0] shift_bus = 'h0;
    always_comb begin
        if (if0.sig) begin : shift_left_logical
                shift_bus[63+shamt:shamt] = if0.in;
                if0.out = shift_bus[63:0];
            end
        else
            if0.out = if0.in;
    end
endmodule : stage_ll