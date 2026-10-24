`timescale 1ns / 1ps

module main(
    input [15:0] in1, in2,
    input [3:0] sel,
    input dir, cin,
    output reg [15:0] out,
    output reg [4:0] flags
);
    
    wire [15:0] caseresult[12:0];
    wire [4:0] caseflags[12:0];
    
    cla16b case1 (.in1(in1), .in2(in2), .cin(1'b0), .out(caseresult[0]), .flags(caseflags[0]));
    cla16b case2 (.in1(in1), .in2(in2), .cin(1'b1), .out(caseresult[1]), .flags(caseflags[1]));
    sub case3 (.in1(in1), .in2(in2), .out(caseresult[2]), .flags(caseflags[2])); 
    subwithborrow case4 (.in1(in1), .in2(in2), .bin(1'b1), .out(caseresult[3]), .flags(caseflags[3]));
    twoscomp case5 (.in1(in1), .out(caseresult[4]), .flags(caseflags[4]));
    increment case6 (.in1(in1), .out(caseresult[5]), .flags(caseflags[5]));
    decrement case7 (.in1(in1), .out(caseresult[6]), .flags(caseflags[6]));
    and_gate case8 (.in1(in1), .in2(in2), .out(caseresult[7]), .flags(caseflags[7]));
    or_gate case9 (.in1(in1), .in2(in2), .out(caseresult[8]), .flags(caseflags[8]));
    xor_gate case10 (.in1(in1), .in2(in2), .out(caseresult[9]), .flags(caseflags[9]));
    logical_shift case11 (.in1(in1), .dir(dir), .out(caseresult[10]), .flags(caseflags[10]));
    rotator case12 (.in1(in1), .dir(dir), .out(caseresult[11]), .flags(caseflags[11]));
    rotator_carry case13 (.in1(in1), .cin(cin), .dir(dir), .out(caseresult[12]), .flags(caseflags[12]));
    
    always @ (*) begin
        case (sel) 
            4'b0000 : begin  out = caseresult[0]; flags = caseflags[0]; end
            4'b0001 : begin  out = caseresult[1]; flags = caseflags[1]; end
            4'b0010 : begin  out = caseresult[2]; flags = caseflags[2]; end
            4'b0011 : begin  out = caseresult[3]; flags = caseflags[3]; end
            4'b0100 : begin  out = caseresult[4]; flags = caseflags[4]; end
            4'b0101 : begin  out = caseresult[5]; flags = caseflags[5]; end
            4'b0110 : begin  out = caseresult[6]; flags = caseflags[6]; end
            4'b0111 : begin  out = caseresult[7]; flags = caseflags[7]; end
            4'b1000 : begin  out = caseresult[8]; flags = caseflags[8]; end
            4'b1001 : begin  out = caseresult[9]; flags = caseflags[9]; end
            4'b1010 : begin  out = caseresult[10]; flags = caseflags[10]; end
            4'b1011 : begin  out = caseresult[11]; flags = caseflags[11]; end
            4'b1100 : begin  out = caseresult[12]; flags = caseflags[12]; end
            default: ;
        endcase
    end
endmodule