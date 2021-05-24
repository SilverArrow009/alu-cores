module stage_rol #(parameter SHAMT = 1) (
    stage_if if0
);
    always_comb begin
        if (if0.sig) begin : rotate_left
                if0.out[63:SHAMT] = if0.in[63:SHAMT];
                if0.out[SHAMT-1:0] = if0.in[SHAMT-1:0];
            end
        else
            if0.out = if0.in;
    end
endmodule : stage_rol