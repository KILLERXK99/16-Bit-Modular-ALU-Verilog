`timescale 1ns / 1ps

module and_gate(
    input [15:0] in1, in2,
    output wire [15:0] out,
    output reg [4:0] flags
);
    assign out = in1 & in2;
    always @ (*) begin
        flags[4] = 1'b0;
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module or_gate(
    input [15:0] in1, in2,
    output wire [15:0] out,
    output reg [4:0] flags
);
    assign out = in1 | in2;
    always @ (*) begin
        flags[4] = 1'b0;
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module xor_gate(
    input [15:0] in1, in2,
    output wire [15:0] out,
    output reg [4:0] flags
);
    assign out = in1 ^ in2;
    always @ (*) begin
        flags[4] = 1'b0;
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule