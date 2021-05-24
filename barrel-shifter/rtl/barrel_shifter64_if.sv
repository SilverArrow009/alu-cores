interface barrel_shifter64_if;
    logic [63:0] in;    
    logic [5:0] shift_amount;
    bit [2:0] shift_type;
    logic [63:0] result;

    modport inst (
    input in,
    input shift_amount,
    input shift_type,
    output result
    );
endinterface //barrel_shifter64_if