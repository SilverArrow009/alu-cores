// Interface for 64-bit adder
    interface adder64_if;
        logic [63:0] op1;
        logic [63:0] op2;
        logic [63:0] result;
        logic carry_out;
        logic carry_in;

        modport inst (
            input op1,
            input op2,
            input carry_in,
            output result,
            output carry_out
        );
    endinterface