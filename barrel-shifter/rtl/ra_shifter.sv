module ra_shifter (
    shifter_if shift_if
);
    stage_if if0, if1, if2, if3, if4, if5;
    stage_ra #(.SHAMT(1)) stage0 (if0.inst);
    stage_ra #(.SHAMT(2)) stage1 (if1.inst);
    stage_ra #(.SHAMT(4)) stage2 (if2.inst);
    stage_ra #(.SHAMT(8)) stage3 (if3.inst);
    stage_ra #(.SHAMT(16))stage4 (if4.inst);
    stage_ra #(.SHAMT(32))stage5 (if5.inst);

    // Connect the interfaces
    always_comb begin : connection
        // Cascade the stages
        if0.in = shift_if.in;
        if1.in = if0.out;
        if2.in = if1.out;
        if3.in = if2.out;
        if4.in = if3.out;
        if5.in = if4.out;
        shift_if.result = if5.out;
        
        // Assign the control signals
        if0.sig = shift_if.shift_amount[0];
        if1.sig = shift_if.shift_amount[1];
        if2.sig = shift_if.shift_amount[2];
        if3.sig = shift_if.shift_amount[3];
        if4.sig = shift_if.shift_amount[4];
        if5.sig = shift_if.shift_amount[5];

    end
endmodule : ra_shifter