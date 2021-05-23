interface stage_if;
    logic [63:0] in;
    logic sig;
    logic [63:0] out;
    
    modport inst (
    input in,
    input sig,
    output out
    );
endinterface //stage_if