`timescale 1ns/10ps

// Test bench module
module tb_EXC;

// Input Array
/////////////////////////////////////////////////////////
//                  Test Bench Signals                 //
/////////////////////////////////////////////////////////

reg clk;
integer i,j,k;

// Matrices
reg signed [7:0] matrixA [63:0];
reg signed [7:0] matrixB [63:0];
reg signed [18:0] matrixC [63:0];



// Comparison Flag
reg comparison;

/////////////////////////////////////////////////////////
//                  I/O Declarations                   //
/////////////////////////////////////////////////////////
// declare variables to hold signals going into submodule
reg start;
reg reset;


// Misc "wires"
wire done;
wire [10:0] clock_count, clock_count_computation;
wire [2:0] state;
wire [2:0] position, RowA1, RowA2, ColumnB;
wire signed [18:0] memory;
wire signed [18:0] macc_out1, macc_out2, C1_in_buffer, C2_in_buffer, EntryC, inputC;
wire signed [18:0] C00, C10, C20, C30, C40, C50, C60, C70;
wire signed [7:0] A00, A10, A20, A30, A40, A50, A60, A70;
wire signed [7:0] B00, B01, B02, B03, B04, B05, B06, B07;
wire  [5:0] addrC, addrA1, addrA2, addrB, IndexC1, IndexC2;
wire CheckClear, rowFlag, Flag1, Flag2, Flag0, FlagN1, mwrC, FLAG, FLAG2;

//always #5 clk = ~clk;

/////////////////////////////////////////////////////////
//              Submodule Instantiation                //
/////////////////////////////////////////////////////////

/*****************************************
|------|    RENAME TO MATCH YOUR MODULE */
ExtraCredit_C DUT
( 
    .clk   (clk),
    .rst (reset),
	 .clock_cycle(clock_count),
	 .clock_cycle_computation(clock_count_computation),
	 .mwrC  (mwrC),
	 .addrC(addrC),
	 .inputC(inputC),
	 .MEM(memory),
	 .done(done),
	 .C00(C00),
	 .C10(C10),
	 .C20(C20),
	 .C30(C30),
	 .C40(C40),
	 .C50(C50),
	 .C60(C60),
	 .C70(C70),
	 .A00(A00),
	 .A10(A10),
	 .A20(A20),
	 .A30(A30),
	 .A40(A40),
	 .A50(A50),
	 .A60(A60),
	 .A70(A70),
	 .B00(B00),
	 .B01(B01),
	 .B02(B02),
	 .B03(B03),
	 .B04(B04),
	 .B05(B05),
	 .B06(B06),
	 .B07(B07),
	 .flag(FLAG)
  );

initial begin

  //****************************************************
  // CHANGE .TXT FILE NAMES TO MATCH THE ONES USED IN
  // YOUR MEMORY MODULES

  // Initialize Matrices
  $readmemb("C:/Users/86108/Desktop/EEC180/Lab6/test/tb_Task2/ram_a_init.txt",matrixA);
  $readmemb("C:/Users/86108/Desktop/EEC180/Lab6/test/tb_Task2/ram_b_init.txt",matrixB);
  //***************************************************

  /////////////////////////////////////////////////////////
  //                    Perform Test                     //
  /////////////////////////////////////////////////////////

  ////////////
  // PART 1 //
  ////////////
  // Initialize Module

  reset <= 1'b1;    // Assert Reset
  start <= 1'b0;
  clk <= 1'b0;      // Start Clock
  repeat(2) @(posedge clk); // Wait 2 clock cycles
  reset <= 1'b0;
  repeat(2) @(posedge clk); // Wait 2 clock cycles
  start <= 1'b1;
  repeat(1) @(posedge clk); // Wait 1 clock cycle
  start <= 1'b0;

  ////////////
  // PART 2 //
  ////////////

  // ------------------------
  // Wait for done or timeout
  fork : wait_or_timeout
  begin
    repeat(2000) @(posedge clk);
    disable wait_or_timeout;
  end
  begin
    @(posedge done);
    disable wait_or_timeout;
  end
  join
  // End Timeout Routing
  //-------------------------

  /////////////////////////////////////////////////////////
  //                Verify Computation                   //
  /////////////////////////////////////////////////////////

  ////////////
  // PART 3 //
  ////////////

  // Print Input Matrices
  $display("Matrix A");
  for(i=0;i<8;i=i+1) begin
    $display(matrixA[i],matrixA[i+8],matrixA[i+16],matrixA[i+24],matrixA[i+32],matrixA[i+40],matrixA[i+48],matrixA[i+56]);
  end

  $display("\n Matrix B");
    for(i=0;i<8;i=i+1) begin
    $display(matrixB[i],matrixB[i+8],matrixB[i+16],matrixB[i+24],matrixB[i+32],matrixB[i+40],matrixB[i+48],matrixB[i+56]);
  end

  // Generate Expected Result
  for(i=0;i<8;i=i+1) begin
    for(j=0;j<8;j=j+1) begin
      matrixC[8*i+j] = 0;
      for(k=0;k<8;k=k+1) begin
        matrixC[8*i+j] = matrixC[8*i+j] + matrixA[j+8*k]*matrixB[k+8*i];
      end
    end
  end

  // Display Expected Result
  $display("\nExpected Result");
  for(i=0;i<8;i=i+1) begin
    $display(matrixC[i],matrixC[i+8],matrixC[i+16],matrixC[i+24],matrixC[i+32],matrixC[i+40],matrixC[i+48],matrixC[i+56]);
  end

  // Display Output Matrix
  $display("\nGenerated Result");
  for(i=0;i<8;i=i+1) begin
    $display(DUT.RAMOUTPUT.mem[i],DUT.RAMOUTPUT.mem[i+8],DUT.RAMOUTPUT.mem[i+16],DUT.RAMOUTPUT.mem[i+24],DUT.RAMOUTPUT.mem[i+32],DUT.RAMOUTPUT.mem[i+40],DUT.RAMOUTPUT.mem[i+48],DUT.RAMOUTPUT.mem[i+56]);
  end

  ////////////
  // PART 4 //
  ////////////
  
  // Test if the two matrices match
  comparison = 1'b0;
  for(i=0;i<8;i=i+1) begin
    for(j=0;j<8;j=j+1) begin
      if (matrixC[8*i+j] != DUT.RAMOUTPUT.mem[8*i+j]) begin
        $display("Mismatch at indices [%1.1d,%1.1d]",j,i);
        comparison = 1'b1;
      end
    end
  end
  if (comparison == 1'b0) begin
    $display("\nsuccess :)");
  end

  $display("Running Time = %d clock cycles \nRunning Time for computation = %d clock cycles",clock_count, clock_count_computation);

  $stop; // End Simulation
end


initial begin
	wait(done == 1);
	$display("Computation completed at this time: %t", $time);
	end

///////////////////////////////////////////////////	


	
// Clock
 initial 
		forever
			begin
				#5 clk = 1;
		
	//	$display("########");
		$display("rst = %b, done= %d, FLAG = %d, FLAG2 = %d", reset, done, FLAG, FLAG2);
		$display("inputC = %d,  mwrC = %b, addrC = %d, data of addrC =%d", inputC, mwrC, addrC, memory);
		$display("C for first column:  %d   %d   %d   %d   %d   %d   %d   %d", C00, C10, C20, C30, C40, C50, C60, C70);
	//	$display("A for first column:  %d   %d   %d   %d   %d   %d   %d   %d", A00, A10, A20, A30, A40, A50, A60, A70);
	//	$display("B for first row:  %d   %d   %d   %d   %d   %d   %d   %d",  B00, B01, B02, B03, B04, B05, B06, B07);
		
				 #5 clk = 0;
				 
			end 
			
endmodule
