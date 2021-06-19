#!/usr/bin/gawk -f

BEGIN {
    RS = "\n\n"
    FS = "\n"
    cycle = 0;
}

{
    if ($1 ~ /In column.*/) {
        split($1, temp, ":");
        gsub(" ", "", temp[2]);
        if (temp[2] == "0") {
            cycle++;
        }
        if($NF == "No optimization required") {
            full_adder_cyc[cycle "_" temp[2]] = full_adder_cyc[cycle "_" temp[2]] " NIL";
            half_adder_cyc[cycle "_" temp[2]] = half_adder_cyc[cycle "_" temp[2]] " NIL";
            full_adder_pos[temp[2]] = full_adder_pos[temp[2]] " NIL";
            half_adder_pos[temp[2]] = half_adder_pos[temp[2]] " NIL";
            NR++;
        } else {
            split($NF, temp1, ":");
            if ($NF ~ ".*half adders.*") {
                half_adder_pos[temp[2]] = half_adder_pos[temp[2]] " " temp1[2];
                half_adder_cyc[cycle "_" temp[2]] = temp1[2];
            } else if ($NF ~ ".*full adders.*") {
                full_adder_pos[temp[2]] = full_adder_pos[temp[2]] " " temp1[2];
                full_adder_cyc[cycle "_" temp[2]] = temp1[2];
            }
        }
    } else if ($1 ~ "Max size of.*") {
            split($NF, temp, ":");
            gsub(" ", "", temp[2]);
            gsub(" ", "", temp[3]);
            max_sizes_cols[temp[2]] = temp[3];
        }
}

END {
    total_cycles = cycle;
    # for (i in full_adder_cyc) {
    #     print i " : " full_adder_cyc[i]; 
    # }
    for(column in full_adder_pos) {
        full_adder_pos[column] = uniq(full_adder_pos[column]);
        half_adder_pos[column] = uniq(half_adder_pos[column]);
    }
    size = (length(full_adder_pos) + 1) / 2;
    gen_verilog(); 
}

# Function definitions from here

function uniq(string,   str) {
    split(string, foo_arr, " ");
    for (element in foo_arr) {
        val = foo_arr[element];
        bar_arr[val] = val;
    }
    for (element in bar_arr) {
        str = str " " bar_arr[element]
    }
    sub(" ", "", str);
    delete foo_arr;
    delete bar_arr;
    return str;
}

function initialize (weight,    str) {
    str = "";
    for (i=0; i <= weight; i++) {
        j = weight - i;
        if (i < size && j < size) {
            str = str ", " "op1[" i "] & op2[" j "]";                    
        } else {
            continue;
        }
    }
    sub(",", "", str);
    str = "{" str " }";
    return str;
}

function update (cycle, col,   str) {
    str = "";
    curr_col = "col_" col;
    new_col = "{ "
    split(full_adder_cyc[cycle "_" col], temp_sum_full, " ");
    split(half_adder_cyc[cycle "_" col], temp_sum_half, " ");
    split(full_adder_cyc[cycle "_" col-1], temp_carry_full, " ");
    split(half_adder_cyc[cycle "_" col-1], temp_carry_half, " ");

    for (i in  temp_carry_full) {
        if(temp_carry_full[i] == "NIL") {
            continue;
        }
        new_col = new_col "fa_cout_" col-1 "_" temp_carry_full[i] ", ";
    }

    for (i in  temp_carry_half) {
        if(temp_carry_half[i] == "NIL") {
            continue;
        }
        new_col = new_col "ha_cout_" col-1 "_" temp_carry_half[i] ", ";
    }

    for (i in  temp_sum_full) {
        if(temp_sum_full[i] == "NIL" || temp_sum_full[i] == "") {
            continue;
        }
        new_col = new_col "fa_sum_" col "_" temp_sum_full[i] ", ";
        if (temp_sum_full[length(temp_sum_full)] == max_sizes_cols[col]-3) {
            continue;
        } else {
            new_col = new_col "col_" col "[" temp_sum_full[i]+3 ":";
        }
        if (i < length(temp_sum_full)) {
            new_col = new_col temp_sum_full[i+1] "], ";
        }
    }

    if (length(temp_sum_full) > 1 && (temp_sum_half[1] != "NIL" || temp_sum_half[1] != "")) {
        new_col = new_col temp_sum_half[1]-1 "], ";
    }
    
    for (i in  temp_sum_half) {
        if(temp_sum_half[i] == "NIL" || temp_sum_half[i] == "") {
            continue;
        }
        new_col = new_col "ha_sum_" col "_" temp_sum_half[i] ", ";
        new_col = new_col "col_" col "[" temp_sum_half[i]+2 ":";
        if (i < length(temp_sum_half)) {
            new_col = new_col temp_sum_half[i+1] "], ";
        }
    }

    if (temp_sum_half[length(temp_sum_half)] < max_sizes_cols[col] - 1 && temp_sum_half[length(temp_sum_half)] != "NIL" && temp_sum_half[length(temp_sum_half)] != "" ) {
        new_col = new_col max_sizes_cols[col]-1 "], ";
    } else if (temp_sum_half[length(temp_sum_half)] == "NIL" || temp_sum_half[length(temp_sum_half)] == "") {
        if (temp_sum_full[length(temp_sum_full)] == "NIL" || temp_sum_full[length(temp_sum_full)] == "") {
            new_col = new_col "col_" col ", ";
        } else {
            if (temp_sum_full[length(temp_sum_full)] != max_sizes_cols[col]-3) {
                new_col = new_col max_sizes_cols[col]-1 "], ";
            }
        }
    }

    new_col = new_col "}"
    sub(", }", " }", new_col);
    if (new_col == "{ }") {
        str = "col_" col " <= col_" col ";";
    } else {
        str = "col_" col " <= " new_col ";";
    }

    return str;
}

function gen_verilog() {
    line_number = 1;
    indent[line_number] = 0 " " 0;
    lines[line_number++] = "module dadda_multiplier ("
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "input logic[" (size-1) ":0] op1,"
    lines[line_number++] = "input logic[" (size-1) ":0] op2,"
    lines[line_number++] = "input logic clk,"
    lines[line_number++] = "output logic valid,"
    lines[line_number++] = "output logic[" (2*size-1) ":0] result"
    indent[line_number] = line_number " " 0;
    lines[line_number++] = ");\n"
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "// Define a counter";
    lines[line_number++] = "bit [" int(log(total_cycles)/log(2)) ":0] counter;";
    lines[line_number++] = "// Define partial products here";
    lines[line_number++] = "bit [" (2*size-2) ":0] pp1;";
    lines[line_number++] = "bit [" (2*size-2) ":0] pp2;";
    lines[line_number++] = "// Define the registers here"
    for (col in max_sizes_cols) {
        lines[line_number++] = "logic[0:" max_sizes_cols[col] - 1 "] col_" col ";"
    }
    lines[line_number++] = "\n";
    lines[line_number++] = "// Define the full adders and corresponding wires here";
    for (col in full_adder_pos) {
        split(full_adder_pos[col], temp, " ");
        for (pos in temp) {
            if (temp[pos] == "NIL") {
                continue;
            }
            lines[line_number++] = "logic fa_sum_" col "_" temp[pos] ";" ;
            lines[line_number++] = "logic fa_cout_" col "_" temp[pos] ";" ;
            lines[line_number++] = "full_adder fa_" col "_" temp[pos] "(.a(col_" col "[" temp[pos] "]), .b(col_" col "[" temp[pos]+1 "]), .cin(col_" col "[" temp[pos]+2 "]), .sum(fa_sum_" col "_" temp[pos] "), .cout(fa_cout_" col "_" temp[pos] "));" ;   
        }
    }
    lines[line_number++] = "\n";
    lines[line_number++] = "// Define the half adders and corresponding wires here";
    for (col in half_adder_pos) {
        split(half_adder_pos[col], temp, " ");
        for (pos in temp) {
            if (temp[pos] == "NIL") {
                continue;
            }
            lines[line_number++] = "logic ha_sum_" col "_" temp[pos] ";" ;
            lines[line_number++] = "logic ha_cout_" col "_" temp[pos] ";" ;
            lines[line_number++] = "half_adder ha_" col "_" temp[pos] "(.a(col_" col "[" temp[pos] "]), .b(col_" col "[" temp[pos]+1 "]), .sum(ha_sum_" col "_" temp[pos] "), .cout(ha_cout_" col "_" temp[pos] "));" ;   
        }
    }
    lines[line_number++] = "\n"; 
    lines[line_number++] = "// Initialize the columns";
    lines[line_number++] = "always_comb begin : initialize";
    indent[line_number] = line_number " " 2;
    for (col in max_sizes_cols) {
        lines[line_number++] = "col_" col " = " initialize(col) ";"
    }
    indent[line_number] = line_number " " 1;
    lines[line_number++] =  "end\n"
    lines[line_number++] = "// Step through the algorithm"
    lines[line_number++] = "always_ff @(posedge clk) begin : stage"
    indent[line_number] = line_number " " 2;
    lines[line_number++] = "case (counter)";
    indent[line_number] = line_number " " 3;
    for (cyc=1; cyc<=total_cycles; cyc++) {
        lines[line_number++] = "4'd" cyc-1 ": begin";
        indent[line_number] = line_number " " 4;
        for (col in max_sizes_cols) {
            lines[line_number++] = update(cyc, col); 
        }
        if (cyc == total_cycles) {
            lines[line_number++] = "// Assert a valid bit"
            lines[line_number++] = "valid <= 1'b1;"
        }
        indent[line_number] = line_number " " 3;
        lines[line_number++] = "end";
    }
    indent[line_number] = line_number " " 2;
    lines[line_number++] = "endcase";
    lines[line_number++] = "counter <= counter + 1;"
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "end\n"
    lines[line_number++] = "// Calculate the product"
    lines[line_number++] = "always_latch begin"
    indent[line_number] = line_number " " 2;
    lines[line_number++] = "if (valid == 1'b1) begin"
    indent[line_number] = line_number " " 3;
    pp1 = "{ "; pp2 = "{ ";
    asorti(max_sizes_cols, sorted_cols, "@ind_num_desc");
    for (col in sorted_cols) {
        pp1 = pp1 "col_" sorted_cols[col] "[0], "
        if (sorted_cols[col] != 0) {
            pp2 = pp2 "col_" sorted_cols[col] "[1], "            
        }
    }
    pp1 = pp1 "}";
    pp2 = pp2 "}";
    sub(", }", " }", pp1);
    sub(", }", ", 1'b0 }", pp2);
    lines[line_number++] = "pp1 <= " pp1 ";";
    lines[line_number++] = "pp2 <= " pp2 ";";
    indent[line_number] = line_number " " 2; 
    lines[line_number++] = "end"
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "end\n";
    # lines[line_number++] = 
    # lines[line_number++] = 
    indent[line_number] = line_number " " 0;
    lines[line_number++] = "endmodule"

    split(indent[1], id_arr, " ");
    # print all the lines
    for(line in lines) {
        if (indent[line] != "") {
            split(indent[line], id_arr, " ");
            id_attr = id_arr[2];
    }
        for(i=0; i<id_attr; i++) {printf "\t";}
        print lines[line];
    }
}
