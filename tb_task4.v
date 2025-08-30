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
wire [2:0] position, ColumnB;
wire [2:0]  RowA1, RowA2, RowA3, RowA4,  RowA5, RowA6, RowA7, RowA8;
wire signed [7:0] CheckA1, CheckA2, CheckA3, CheckA4,CheckA5, CheckA6,CheckA7, CheckA8;
wire signed [7:0] CheckB, InputB;
wire signed [7:0] InputA1, InputA2, InputA3, InputA4, InputA5, InputA6, InputA7, InputA8;
wire signed [18:0] macc_out1, macc_out2, macc_out3, macc_out4, macc_out5, macc_out6, macc_out7, macc_out8;
wire signed [18:0] C1_in_buffer, C2_in_buffer, C3_in_buffer, C4_in_buffer, C5_in_buffer, C6_in_buffer,C7_in_buffer, C8_in_buffer;
wire signed [18:0] MEM, EntryC;
wire [5:0] addrA1, addrA2,addrA3, addrA4, addrA5, addrA6, addrA7, addrA8, addrB;
wire [5:0] addrC;
wire [5:0] IndexC1, IndexC2, IndexC3, IndexC4, IndexC5, IndexC6, IndexC7, IndexC8;
wire CheckClear, rowFlag, Flag1, Flag2, Flag0, FlagN1, mwrC;

/////////////////////////////////////////////////////////
//              Submodule Instantiation                //
/////////////////////////////////////////////////////////

/*****************************************
|------|    RENAME TO MATCH YOUR MODULE */
Task4 DUT
(
    .clk   (clk),
    .start (start),
    .reset (reset),
    .done       (done),
    .clock_count (clock_count),
	 .state(state),
	 .Position(position),
	 /*.rowA1(RowA1),
	 .rowA2(RowA2),
	 .rowA3(RowA3),
	 .rowA4(RowA4),
	 .rowA5(RowA5),
	 .rowA6(RowA6),
	 .rowA7(RowA7),
	 .rowA8(RowA8),*/
	 .columnB(ColumnB),
	/* .CheckA1(CheckA1),
	 .CheckA2(CheckA2),
	 .CheckA3(CheckA3),
	 .CheckA4(CheckA4),
	 .CheckA5(CheckA5),
	 .CheckA6(CheckA6),
	 .CheckA7(CheckA7),
	 .CheckA8(CheckA8),*/
	 .CheckB(CheckB),
	/* .C_1(macc_out1),
	 .C_2(macc_out2),
	 .C_3(macc_out3),
	 .C_4(macc_out4),
	 .C_5(macc_out5),
	 .C_6(macc_out6),
	 .C_7(macc_out7),
	 .C_8(macc_out8), */
	 .C1_in_BUFFER(C1_in_buffer),
	 .C2_in_BUFFER(C2_in_buffer),
	 .C3_in_BUFFER(C3_in_buffer),
	 .C4_in_BUFFER(C4_in_buffer),
	 .C5_in_BUFFER(C5_in_buffer),
	 .C6_in_BUFFER(C6_in_buffer),
	 .C7_in_BUFFER(C7_in_buffer),
	 .C8_in_BUFFER(C8_in_buffer), 
	 .CheckClear(CheckClear),
	 /*.A1(InputA1),
	 .A2(InputA2),
	 .A3(InputA3),
	 .A4(InputA4),
	 .A5(InputA5),
	 .A6(InputA6),
	 .A7(InputA7),
	 .A8(InputA8),*/
	 .B(InputB),
	 .InputC(EntryC),
	 .MEM(MEM),
	 .addrC(addrC),
	 .IndexC1(IndexC1),
	 .IndexC2(IndexC2),
	 .IndexC3(IndexC3),
	 .IndexC4(IndexC4),
	 .IndexC5(IndexC5),
	 .IndexC6(IndexC6),
	 .IndexC7(IndexC7),
	 .IndexC8(IndexC8),
	 /*.addrA1(addrA1),
	 .addrA2(addrA2),
	 .addrA3(addrA3),
	 .addrA4(addrA4),
	 .addrA5(addrA5),
	 .addrA6(addrA6),
	 .addrA7(addrA7),
	 .addrA8(addrA8),*/
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
		//	$display("A in MEM : A0 = %d , A1 = %d , A2 = %d , A3 = %d , A4 = %d , A5 = %d , A6 = %d , A7 = %d ", CheckA1, CheckA2, CheckA3, CheckA4,CheckA5, CheckA6,CheckA7, CheckA8);
		//	$display("MACinputA: A0 = %d , A1 = %d , A2 = %d , A3 = %d , A4 = %d , A5 = %d , A6 = %d , A7 = %d ", InputA1, InputA2, InputA3, InputA4, InputA5, InputA6, InputA7, InputA8);
		//	$display("addrA    : A0 = %d , A1 = %d , A2 = %d , A3 = %d , A4 = %d , A5 = %d , A6 = %d , A7 = %d ", addrA1, addrA2,addrA3, addrA4, addrA5, addrA6, addrA7, addrA8);
		//	$display("ROWA     : A0 = %d , A1 = %d , A2 = %d , A3 = %d , A4 = %d , A5 = %d , A6 = %d , A7 = %d ", RowA1, RowA2, RowA3, RowA4,  RowA5, RowA6, RowA7, RowA8);
			$display("Position = %d, columnB = %d, B_in_mem = %d, B_inputMAC = %d, addrB = %d", position, ColumnB, CheckB, InputB, addrB);
		//	$display("MACOUT C : C0 = %d , C1 = %d , C2 = %d , C3 = %d , C4 = %d , C5 = %d , C6 = %d , C7 = %d ", macc_out1, macc_out2, macc_out3, macc_out4, macc_out5, macc_out6, macc_out7, macc_out8);
			$display("C Buffer : C0 = %d , C1 = %d , C2 = %d , C3 = %d , C4 = %d , C5 = %d , C6 = %d , C7 = %d ", C1_in_buffer, C2_in_buffer, C3_in_buffer, C4_in_buffer, C5_in_buffer, C6_in_buffer,C7_in_buffer, C8_in_buffer);
			$display("C index  : C0 = %d , C1 = %d , C2 = %d , C3 = %d , C4 = %d , C5 = %d , C6 = %d , C7 = %d ", IndexC1, IndexC2, IndexC3, IndexC4, IndexC5, IndexC6, IndexC7, IndexC8);
			$display(" Checkclear = %d, mwrC = %d, C in MEM at addrC = %d, addrC = %d, input C = %d", CheckClear, mwrC, MEM, addrC, EntryC);
			
				 #5 clk = 0;
			end

endmodule