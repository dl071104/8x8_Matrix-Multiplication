`timescale 1ns/10ps

// Test bench module
module tb_macc;

// Input Array
/////////////////////////////////////////////////////////
//                  Test Bench Signals                 //
/////////////////////////////////////////////////////////

reg clk;

/////////////////////////////////////////////////////////
//                  I/O Declarations                   //
/////////////////////////////////////////////////////////
// declare variables to hold signals going into submodule
reg signed [7:0] inA, inB;
reg macc_clear;

// Output Signals
wire signed [18:0] macc_out;


/////////////////////////////////////////////////////////
//              Submodule Instantiation                //
/////////////////////////////////////////////////////////

/*****************************************
RENAME SIGNALS TO MATCH YOUR MODULE
******************************************/
MAC DUT
(
    .clk        (clk),
    .macc_clear (macc_clear),
    .inA        (inA),
    .inB        (inB),
    .macc_out    (macc_out)
  );

initial begin

    macc_clear = 1;  // Start with clear active
    inA = 8'sd0;
    inB = 8'sd0;

    // Apply reset
    #10;
    macc_clear = 0;  // Start accumulation

    // Test Case 1: 3 * 2
    inA = 8'sd3; 
    inB = 8'sd2; 
    #10;

    // Test Case 2: 4 * 3 (Accumulating)
    inA = 8'sd4; 
    inB = 8'sd3; 
    #10;

    // Test Case 3: -2 * 5 (Negative input)
    inA = -8'sd2; 
    inB = 8'sd5; 
    #10;

    // Test Case 4: 1 * -3 (Mix sign)
    inA = 8'sd1; 
    inB = -8'sd3; 
    #10;

    // Reset accumulator
    macc_clear = 1;
    inA = 8'sd6;
    inB = 8'sd2;
    #10;
    macc_clear = 0;

    // Test Case 5: 8 * 8 after clear
    inA = 8'sd8;
    inB = 8'sd8;
    #10;

    $stop; // End Simulation
end


initial begin
 $monitor("macc_clear = %b | inA = %d | inB = %d | macc_out = %d", 
              macc_clear, inA, inB, macc_out);
				  end


// Clock
 initial 
		forever
			begin
				#5 clk = 1;
			//$display("macc_clear = %b , inA = %d , inB = %d , macc_out = %d", 
             // macc_clear, inA, inB, macc_out);
				 #5 clk = 0;
			end


endmodule
