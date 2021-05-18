module adder_subtractor (
    adder_subtractor_if.inst if_as64
);
    // Instantiate the interface
    adder64_if if_add64;
    logic [63:0] flipped_op2;

    always_comb begin : add_subtract
        if (if_as64.mode == 1'b0) begin
            if_add64.op1	=	if_as64.op1;
		    if_add64.op2	=	if_as64.op2;
            if_add64.carry_in = 1'b0;
		    if_as64.result = if_add64.result;
		    if_as64.carry_out = if_add64.carry_out;
        end else begin
            flipped_op2 = ~if_as64.op2;
            if_add64.op1	=	if_as64.op1;
		    if_add64.op2	=	flipped_op2;
            if_add64.carry_in = 1'b1;
		    if_as64.result = if_add64.result;
		    if_as64.carry_out = if_add64.carry_out;            
        end
    end
    // Intstantiate the adder
    adder64 inst0(if_add64.inst);
endmodule : adder_subtractor