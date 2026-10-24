`timescale 1ns / 1ps

module decrement(
    input [15:0] in1,
    output [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] subtractionresult;
    wire couttemp;
    
    subberfordec dec (.in1(in1), .in2(~(16'd0)), .cin(~(1'b1)), .out(subtractionresult), .cout(couttemp));
    assign out = subtractionresult;
    
    always @ (*) begin
        if (out == 16'd0) flags[3] = 1'b1;    
        else flags[3] = 1'b0;
        
        flags[4] = couttemp;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module subberfordec (
    input [15:0] in1, in2,
    input cin,
    output [15:0] out,
    output cout
);
    wire [16:0] C;
    assign C[0] = cin;
    genvar i;
    generate 
        for (i = 0; i < 16; i = i+1) begin : generationblock
            adder1b fda(.a(in1[i]), .b(in2[i]), .cin(C[i]), .y(out[i]), .g(), .p(), .cout());
            assign C[i+1] = (C[i] | in1[i]);
        end
    endgenerate
    assign cout = C[16];
endmodule

module subwithborrow(
    input [15:0] in1, in2,
    input bin,
    output reg [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] invertedin2;
    wire tocheckcout, iffinalcout;
    wire [15:0] middleout, finalout, toholdout;
    wire [15:0] invertedcarryoutput;
    
    onescomp invert1(.in1(in2), .out(invertedin2));
    adderforsub asub (.in1(in1), .in2(invertedin2), .cin(~bin), .out(middleout), .cout(tocheckcout));

    onescomp invert2 (.in1(middleout), .out(invertedcarryoutput));
    adderforsub asub2 (.in1(16'd0), .in2(invertedcarryoutput), .cin(~tocheckcout), .cout(iffinalcout), .out(toholdout));

    always @ (*) begin
        if (tocheckcout == 1'b0) begin
            out = toholdout;
            flags[4] = iffinalcout;
            if (out == 16'd0) flags[3] = 1'b1;
            else flags[3] = 1'b0;
            flags[2] = 1'b0;
        end 
        else begin
            out = middleout;
            flags[4] = tocheckcout;
            if (out == 16'd0) flags[3] = 1'b1;
            else flags[3] = 1'b0;
            flags[2] = 1'b1;
        end
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module increment(
    input [15:0] in1,
    output [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] additionresult;
    wire couttemp;
    
    adderforinc inc (.in1(in1), .in2(16'd0), .cin(1'b1), .out(additionresult), .cout(couttemp)); 
    assign out = additionresult;
    
    always @ (*) begin
        if (out == 16'd0) flags[3] = 1'b1;    
        else flags[3] = 1'b0;
        
        flags[4] = couttemp;
        flags[2] = 1'b0;
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module adderforinc (
    input [15:0] in1, in2,
    input cin,
    output [15:0] out,
    output cout
);
    wire [15:0] P;
    wire [16:0] C;
    assign C[0] = cin;
    genvar i;
    generate 
        for (i = 0; i < 16; i = i+1) begin : generationblock
            adder1b fda(.a(in1[i]), .b(in2[i]), .cin(C[i]), .y(out[i]), .g(), .p(P[i]), .cout());
            assign C[i+1] = (C[i] & P[i]);
        end
    endgenerate
    assign cout = C[16];
endmodule

module sub(
    input [15:0] in1, in2,
    output reg [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] invertedin2;
    wire tocheckcout, iffinalcout;
    wire [15:0] middleout, finalout, toholdout;
    wire [15:0] invertedcarryoutput;
    
    onescomp invert1(.in1(in2), .out(invertedin2));
    adderforsub asub (.in1(in1), .in2(invertedin2), .cin(1'b1), .out(middleout), .cout(tocheckcout));

    onescomp invert2 (.in1(middleout), .out(invertedcarryoutput));
    adderforsub asub2 (.in1(16'd0), .in2(invertedcarryoutput), .cin(~tocheckcout), .cout(iffinalcout), .out(toholdout));

    always @ (*) begin
        if (tocheckcout == 1'b0) begin
            out = toholdout;
            flags[4] = iffinalcout;
            if (out == 16'd0) flags[3] = 1'b1;
            else flags[3] = 1'b0;
            flags[2] = 1'b0;
        end 
        else begin
            out = middleout;
            flags[4] = tocheckcout;
            if (out == 16'd0) flags[3] = 1'b1;
            else flags[3] = 1'b0;
            flags[2] = 1'b1;
        end
        flags[1] = 1'b0;
        flags[0] = ^out;
    end
endmodule

module adderforsub (
    input [15:0] in1, in2,
    input cin,
    output [15:0] out,
    output cout
);
    wire [15:0] G;
    wire [15:0] P;
    wire [16:0] C;
    assign C[0] = cin;
    genvar i;
    generate 
        for (i = 0; i < 16; i = i+1) begin : generationblock
            adder1b fda(.a(in1[i]), .b(in2[i]), .cin(C[i]), .y(out[i]), .g(G[i]), .p(P[i]), .cout());
            assign C[i+1] = (C[i] & P[i]) | G[i];
        end
    endgenerate
    assign cout = C[16];
endmodule

module onescomp(
    input [15:0] in1,
    output [15:0] out
);
    assign out = ~in1;
endmodule

module twoscomp (
    input [15:0] in1,
    output wire [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] tempout;
    onescomp one(.in1(in1), .out(tempout));
    assign out = tempout + 1'b1;
    always @ (*) begin
        flags = 5'b00000;
        if (out == 16'd0) flags[3] = 1'b1;
        flags[0] = ^out;
        {flags[4], flags[2], flags[1]} = {3{1'b0}};
    end
endmodule

module adder1b (
    input a, b, cin,
    output y, g, p, cout
);
    assign y = a ^ b ^ cin;
    assign g = a & b;
    assign p = a | b;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module cla16b (
    input [15:0] in1, in2,
    input cin,
    output [15:0] out,
    output reg [4:0] flags
);
    wire [15:0] G;
    wire [15:0] P;
    wire [16:0] C;
    assign C[0] = cin;
    genvar i;
    generate 
        for (i = 0; i < 16; i = i+1) begin : generationblock
            adder1b fda(.a(in1[i]), .b(in2[i]), .cin(C[i]), .y(out[i]), .g(G[i]), .p(P[i]), .cout());
            assign C[i+1] = (C[i] & P[i]) | G[i];
        end
    endgenerate
    
    always @ (*) begin
        flags = 0;
        if (C[16] == 1'b1) flags[4] = 1'b1;
        if (out == 16'd0) flags[3] = 1'b1;
        
        {flags[2], flags[1]} = {2{1'b0}};
        flags[0] = ^out;
    end
endmodule