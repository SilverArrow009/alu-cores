interface shifter_if;
    logic [63:0] in;    
    logic [5:0] shift_amount;
    logic [63:0] result;

    modport inst (
    input in,
    input shift_amount,
    output result
    );
endinterface //shifter_if
