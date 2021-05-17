module adder64_wrapper (
	input         logic [63:0]  op1,
	input         logic [63:0]  op2,
	input         logic  carry_in,
	output         logic [63:0]  result,
	output         logic  carry_out
);


	adder64_if if0;

	always_comb begin
		if0.op1	=	op1;
		if0.op2	=	op2;
		if0.carry_in	=	carry_in;
		result = if0.result;
		carry_out = if0.carry_out;
	end

	adder64 inst0 (if0.inst);

endmodule : adder64_wrapper
