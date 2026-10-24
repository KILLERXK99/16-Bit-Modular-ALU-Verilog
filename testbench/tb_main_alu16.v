`timescale 1ns / 1ps

module tb_main_alu16;

    // Inputs
    reg [15:0] in1;
    reg [15:0] in2;
    reg [3:0] sel;
    reg dir;
    reg cin;

    // Outputs
    wire [15:0] out;
    wire [4:0] flags;

    // Instantiate the Unit Under Test (UUT)
    main uut (
        .in1(in1), 
        .in2(in2), 
        .sel(sel), 
        .dir(dir), 
        .cin(cin), 
        .out(out), 
        .flags(flags)
    );

    initial begin
        // Initialize Inputs
        in1 = 0; in2 = 0; sel = 0; dir = 0; cin = 0;

        // Wait 10 ns before starting tests
        #10;
        
        $display("Time | sel |   in1  |   in2  | dir | cin ||   out  | flags(C,Z,B,U,P)");
        $monitor("%4t |  %h  | %h | %h |  %b  |  %b  || %h | %b", $time, sel, in1, in2, dir, cin, out, flags);

        // Test Case 1: Addition (sel = 0000)
        in1 = 16'h1234; in2 = 16'h2000; sel = 4'b0000; cin = 0; #10;
        
        // Test Case 2: Subtraction (sel = 0010)
        in1 = 16'h5555; in2 = 16'h1111; sel = 4'b0010; #10;
        
        // Test Case 3: Increment (sel = 0101)
        in1 = 16'h00FF; sel = 4'b0101; #10;
        
        // Test Case 4: AND Gate (sel = 0111)
        in1 = 16'hF0F0; in2 = 16'h0F0F; sel = 4'b0111; #10;
        
        // Test Case 5: Logical Shift Right (sel = 1010, dir = 1)
        in1 = 16'h8000; sel = 4'b1010; dir = 1'b1; #10;
        
        // Test Case 6: Zero Flag Test (Subtraction yielding 0)
        in1 = 16'hAAAA; in2 = 16'hAAAA; sel = 4'b0010; #10;

        // Stop simulation
        $stop;
    end
endmodule