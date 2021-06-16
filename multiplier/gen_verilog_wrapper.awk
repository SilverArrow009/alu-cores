#!/usr/bin/gawk -f

BEGIN {
    RS = "\n\n"
    FS = "\n"
}

{
    if ($1 ~ /In column.*/) {
        split($1, temp, ":");
        gsub(" ", "", temp[2]);
        if($NF == "No optimization required") {
            full_adder_pos[temp[2]] = full_adder_pos[temp[2]] " NIL";
            half_adder_pos[temp[2]] = half_adder_pos[temp[2]] " NIL";
            NR++;
        } else {
            split($NF, temp1, ":");
            if ($NF ~ ".*half adders.*") {
                half_adder_pos[temp[2]] = half_adder_pos[temp[2]] " " temp1[2];
            } else if ($NF ~ ".*full adders.*") {
                full_adder_pos[temp[2]] = full_adder_pos[temp[2]] " " temp1[2];
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

function gen_verilog() {
    line_number = 1;
    indent[line_number] = 0 " " 0;
    lines[line_number++] = "module dadda_multiplier ("
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "input logic[" (size-1) ":0] op1,"
    lines[line_number++] = "input logic[" (size-1) ":0] op2,"
    lines[line_number++] = "input logic clk,"
    lines[line_number++] = "output logic[" (2*size-1) ":0] result"
    indent[line_number] = line_number " " 0;
    lines[line_number++] = ");\n"
    indent[line_number] = line_number " " 1;
    lines[line_number++] = "// Define a counter"
    lines[line_number++] = "bit [3:0] counter;"
    lines[line_number++] = "// Define the registers here"
    for (col in max_sizes_cols) {
        lines[line_number++] = "logic[" max_sizes_cols[col] - 1 ":0] col_" col ";"
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
    # lines[line_number++] = 
    # lines[line_number++] = 
    # lines[line_number++] = 
    # lines[line_number++] = 
    # lines[line_number++] = 
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
