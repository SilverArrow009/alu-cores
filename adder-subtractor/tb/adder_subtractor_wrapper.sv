module adder_subtractor_wrapper (
	input     logic [63:0]  op1,
	input     logic [63:0]  op2,
	input     logic  mode,
	output     logic [63:0]  result,
	output     logic  carry_out
);


	adder_subtractor_if if0;

	always_comb begin
		if0.op1	=	op1;
		if0.op2	=	op2;
		if0.mode	=	mode;
		result	=	if0.result;
		carry_out	=	if0.carry_out;
	end

	adder_subtractor inst0 (if0.inst);

endmodule : adder_subtractor_wrapper
