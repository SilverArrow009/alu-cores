module barrel_shifter64 (
    barrel_shifter64_if iface0
);
    // interfaces for shifters
    shifter_if ll_if, rl_if, la_if, ra_if;
    
    // instantiate the shifter modules
    ll_shifter ll_shift0(ll_if.inst);
    rl_shifter rl_shift0(rl_if.inst);
    la_shifter la_shift0(la_if.inst);
    ra_shifter ra_shift0(ra_if.inst);

    // Assign the signals

    always_comb begin : shift_selector
        case (iface0.shift_type)
            2'b00: begin
                ll_if.in = iface0.in;
                ll_if.shift_amount = iface0.shift_amount;
                iface0.result = ll_if.result;
            end 
            2'b01: begin
                rl_if.in = iface0.in;
                rl_if.shift_amount = iface0.shift_amount;
                iface0.result = rl_if.result;
            end 
            2'b10: begin
                la_if.in = iface0.in;
                la_if.shift_amount = iface0.shift_amount;
                iface0.result = la_if.result;
            end 
            2'b11: begin
                ra_if.in = iface0.in;
                ra_if.shift_amount = iface0.shift_amount;
                iface0.result = ra_if.result;
            end 
        endcase
    end
endmodule