module barrel_shifter64 (
    barrel_shifter64_if iface0
);
    // interfaces for shifters
    shifter_if ll_if, rl_if, la_if, ra_if, rol_if, ror_if;
    
    // instantiate the shifter modules
    ll_shifter ll_shift0(ll_if.inst);
    rl_shifter rl_shift0(rl_if.inst);
    la_shifter la_shift0(la_if.inst);
    ra_shifter ra_shift0(ra_if.inst);
    rol_shifter rol_shift0(rol_if.inst);
    ror_shifter ror_shift0(ror_if.inst);

    // Assign the signals

    always_comb begin : shift_selector
        case (iface0.shift_type)
            3'b000, 3'b110, 3'b111: begin   // Left logical shift, the default
                ll_if.in = iface0.in;
                ll_if.shift_amount = iface0.shift_amount;
                iface0.result = ll_if.result;
            end 
            3'b001: begin   // Right logical shift 
                rl_if.in = iface0.in;       
                rl_if.shift_amount = iface0.shift_amount;
                iface0.result = rl_if.result;
            end 
            3'b010: begin   // Left arithmetic shift
                la_if.in = iface0.in;
                la_if.shift_amount = iface0.shift_amount;
                iface0.result = la_if.result;
            end 
            3'b011: begin   // Right arithmetic shift
                ra_if.in = iface0.in;
                ra_if.shift_amount = iface0.shift_amount;
                iface0.result = ra_if.result;
            end 
            3'b100: begin   // Bit rotate left
                rol_if.in = iface0.in;
                rol_if.shift_amount = iface0.shift_amount;
                iface0.result = rol_if.result;
            end 
            3'b101: begin   // Bit rotate right
                ror_if.in = iface0.in;
                ror_if.shift_amount = iface0.shift_amount;
                iface0.result = ror_if.result;
            end
        endcase
    end
endmodule