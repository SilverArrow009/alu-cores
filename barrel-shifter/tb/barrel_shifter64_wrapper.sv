module barrel_shifter64_wrapper (
	input     logic [63:0]      in,
	input     logic [5:0]  shift_amount,
	input     bit [2:0]  shift_type,
	output     logic [63:0]  result
);


	barrel_shifter64_if if0;

	always_comb begin
		if0.in	=	in;
		if0.shift_amount	=	shift_amount;
		if0.shift_type	=	shift_type;
		result	=	if0.result;
	end

	barrel_shifter64 inst0 (if0.inst);

endmodule : barrel_shifter64_wrapper
