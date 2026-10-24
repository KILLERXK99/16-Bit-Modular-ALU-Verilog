`timescale 1ns / 1ps

module logical_shift(
    input [15:0] in1,
    input dir,
    output [15:0] out,
    output reg [4:0] flags
);
    reg [15:0] medout;
    always @ (*) begin
        if (dir == 1'b1) medout = in1 >> 1;
        else medout = in1 << 1;
    end
    assign out = medout;

    always @ (*) begin
        flags[4] = 1'b0;
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out; 
    end
endmodule

module rotator (
    input [15:0] in1,
    input dir,
    output [15:0] out,
    output reg [4:0] flags
);
    reg [15:0] midout;
    always @ (*) begin
        if (dir == 1'b1) midout = {in1[0], in1[15:1]};
        else midout = {in1[14:0], in1[15]};
    end
    assign out = midout;

    always @ (*) begin
        flags[4] = 1'b0;
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out; 
    end
endmodule

module rotator_carry (
    input [15:0] in1,
    input dir, cin,  
    output [15:0] out,
    output reg [4:0] flags
);
    wire [16:0] in_c;
    reg [16:0] middlestate, midout;
    
    assign in_c = {cin, in1[15:0]};
    
    always @ (*) begin
        if (dir == 1'b1) begin
            middlestate = in_c >> 1;
            midout = {in1[0], middlestate[15:0]};
        end else begin
            middlestate = in_c << 1;
            midout = {middlestate[16:1], cin};  
        end
    end
    assign out = midout[15:0];

    always @ (*) begin
        flags[4] = midout[16];
        if (out == 16'd0) flags[3] = 1'b1;
        else flags[3] = 1'b0;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out; 
    end
endmodule