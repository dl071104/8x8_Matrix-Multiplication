`timescale 1ns/10ps

// Test bench module
module tb_lab6;

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
wire [10:0] clock_count;
wire [2:0] state;
wire [2:0] position, RowA1, RowA2, ColumnB;
wire signed [7:0] CheckA1, CheckA2, CheckB, InputA1, InputA2, InputB;
wire signed [18:0] macc_out1, macc_out2, C1_in_buffer, C2_in_buffer, MEM, EntryC;
wire [5:0] addrC, addrA1, addrA2, addrB, IndexC1, IndexC2;
wire CheckClear, rowFlag, Flag1, Flag2, Flag0, FlagN1, mwrC;

/////////////////////////////////////////////////////////
//              Submodule Instantiation                //
/////////////////////////////////////////////////////////

/*****************************************
|------|    RENAME TO MATCH YOUR MODULE */
Task3 DUT
(
    .clk   (clk),
    .start (start),
    .reset (reset),
    .done       (done),
    .clock_count (clock_count),
	 .state(state),
	 .Position(position),
	 .rowA1(RowA1),
	 .rowA2(RowA2),
	 .columnB(ColumnB),
	 .CheckA1(CheckA1),
	 .CheckA2(CheckA2),
	 .CheckB(CheckB),
	 .C_1(macc_out1),
	 .C_2(macc_out2),
	 .C1_in_BUFFER(C1_in_buffer),
	 .C2_in_BUFFER(C2_in_buffer),
	 .CheckClear(CheckClear),
	 .A1(InputA1),
	 .A2(InputA2),
	 .B(InputB),
	 .InputC(EntryC),
	 .MEM(MEM),
	 .addrC(addrC),
	 .IndexC1(IndexC1),
	 .IndexC2(IndexC2),
	 .addrA1(addrA1),
	 .addrA2(addrA2),
	 .addrB(addrB),
	 .rowFlag(rowFlag),
	 .flag1(Flag1),
	 .flag2(Flag2),
	 .flag0(Flag0),
	 .flagN1(FlagN1),
	 .mwrC(mwrC)
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

  $display("Running Time = %d clock cycles",clock_count);

  $stop; // End Simulation
end


// Clock
 initial 
		forever
			begin
				#5 clk = 1;
			$display("######################################");	
			$display("start = %b, reset = %b, state = %b, clock_count = %d, rowFlag = %d, FlagN1 = %d, Flag0 = %d, Flag1 = %d, Flag2 = %d", start, reset, state, clock_count, rowFlag, FlagN1, Flag0, Flag1, Flag2);
			$display("A1_in_RAM = %d, A2_in_RAM = %d, B_in_RAM = %d, inputA1 = %d, inputA2 = %d inputB = %d, macc_out1 = %d, macc_out2 = %d macc_clear = %d", CheckA1, CheckA2, CheckB, InputA1, InputA2, InputB, macc_out1, macc_out2, CheckClear);
			$display("C1_in_buffer = %d, C2_in_buffer = %d, memory write C = %d, MEM = %d, addrC = %d, current IndexC1 = %d, current_IndexC2 = %d, mwrC = %d", C1_in_buffer, C2_in_buffer, EntryC, MEM, addrC, IndexC1, IndexC2, mwrC);
			$display("position = %d, RowA1 = %d, RowA2 = %d, ColumnB = %d, AddrA1 = %d, AddrA2 = %d, AddrB = %d", position, RowA1, RowA2, ColumnB,addrA1, addrA2, addrB);
			
				 #5 clk = 0;
			end

endmodule