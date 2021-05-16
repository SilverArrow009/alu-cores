package alu_utils;
    function logic[63:0] twos_complement(logic [63:0] in);
        in = (~in) + 1;
        return in;
    endfunction
endpackage