// Interface for 64-bit adder_subtractor
    interface adder_subtractor_if;
        logic [63:0] op1;
        logic [63:0] op2;
        logic [63:0] result;
        logic carry_out;
        logic mode;

        modport inst (
            input op1,
            input op2,
            input mode,
            output result,
            output carry_out
        );
    endinterface