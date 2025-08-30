
module Task3(

	input clk,
	input start,
	input reset,
	output reg done,
	output reg [10:0] clock_count,
	output reg [2:0] state,
	output reg [2:0] Position,
	output reg [2:0] rowA1, rowA2,
	output reg [2:0] columnB,
	output reg signed [7:0] A1, A2, //A in reg
	output reg signed [7:0] B, //B in reg
	output reg signed [7:0] CheckA1, CheckA2, // A in mem
	output reg signed [7:0] CheckB,  //B in mem
	output reg signed [18:0] C_1, C_2, //C1 = macc_out1, C2 = macc_out2
	output reg signed [18:0] C1_in_BUFFER, C2_in_BUFFER,
	output reg signed [18:0] InputC,
	output reg signed [18:0] MEM,
	output reg [5:0] addrC,
	output reg [5:0] IndexC1, IndexC2,
	output reg [5:0] addrA1, addrA2, addrB,
	output reg CheckClear,
	output reg rowFlag, flag1, flag2, flag0, flagN1,
	output reg mwrC
);


//reg signed [18:0] BufferC[63:0]; 
//reg signed [18:0] InputC;
wire signed [7:0] inA1,inA2 ;
wire signed [7:0] inB;
reg signed [7:0] mdiA, mdiB;
wire signed [18:0] mem; 
//wire signed [18:0] C1_in_buffer, C2_in_buffer;
reg macc_clear;
//reg mwrC = 0;
reg mwrA = 0;
reg mwrB = 0;
wire signed [18:0] macc_out1, macc_out2;
integer RowA1 = 4'd0;  //Max is 7
integer RowA2 = 4'd1;
integer ColumnB = 4'd0;  //Max is 7
integer position = 4'd0; //Max is 7
integer RowFlag = 4'd0;
integer Flag1 = 4'd0;
integer Flag2 = 4'd0;
integer Flag0 = 4'd0;
integer FlagN1 = 4'd0;


integer LOAD = 4'd2; // 3 cycles to enter C from buffer

//FSM declarations
reg [2:0] nextstate;

localparam S0 = 3'd0; //default
localparam S1 = 3'd1; //compute
localparam S2 = 3'd2; //Load
localparam S3 = 3'd3; //done


  RAMDUAL_A Matrix_A(
    .data_out1(inA1),
	 .data_out2(inA2), 
    .addr1(addrA1), 
	 .addr2(addrA2),
    .mdi(mdiA), 
    .clk(clk), 
    .mwr(mwrA)
  );

  RAM_B Matrix_B(
    .data_out(inB), 
    .addr(addrB), 
    .mdi(mdiB), 
    .clk(clk), 
    .mwr(mwrB)
  );

  RAMOUTPUT RAMOUTPUT(
    .data_out(mem), 
    .addr(addrC), 
    .mdi(InputC), 
    .clk(clk), 
    .mwr(mwrC)
  );

  MAC UUT1(
    .inA(A1), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out1)
  );
  
  MAC UUT2(
    .inA(A2), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out2)
  );

 always@(*) begin
 flag1 <= Flag1;
 flag2 <= Flag2;
 flag0 <= Flag0;
 flagN1 <= FlagN1;
 Position <= position;
 rowA1 <= RowA1;
 rowA2 <= RowA2;
 columnB <= ColumnB;
 CheckA1 <= inA1;
 CheckA2 <= inA2;
 CheckB <= inB;
 C_1 <= macc_out1;
 C_2 <= macc_out2;
 //C1_in_BUFFER <= C1_in_buffer;
 //C2_in_BUFFER <= C2_in_buffer;
 rowFlag <= RowFlag;
 
 CheckClear <= macc_clear; //Check this
 MEM <= mem;
		addrB <= ColumnB * 8 + (position);
		if ( (rowFlag == 1) && (ColumnB == 7)) begin
		addrA1 <= RowA1 + 2;
		addrA2 <= RowA2 + 2;
		end
		else begin
 		addrA1 <= RowA1 + ((position) * 8);
		addrA2 <= RowA2 + ((position) * 8);
		end
		
		// SINGLE INPUT PORT FOR C
		if ((RowA1!=0)&&(RowA2!=1) && (ColumnB == 0)) begin
		IndexC1<= RowA1 + ((ColumnB - 1) * 8) -2; //
		IndexC2<= RowA2 + ((ColumnB - 1) * 8) -2; //
		end
	//	else if ( begin
		
		else begin
		IndexC1 <= RowA1 + ((ColumnB - 1) * 8);
		IndexC2 <= RowA2 + ((ColumnB - 1) * 8); 
		end
			//mwrC <= （(position == 1) | (position == 2））;
			mwrC <= 0;
			if(Flag0 == 0 & Flag1 == 1) begin
			C1_in_BUFFER <= macc_out1;
			C2_in_BUFFER <= macc_out2;
			end
			if(FlagN1 == 0 & Flag0 == 0 & Flag1 == 0 & Flag2 == 1) begin
			InputC <= C1_in_BUFFER;
			addrC <= IndexC1;
			mwrC <= 1;
			end
			
			if(position == 4) begin
			InputC <= C2_in_BUFFER;
			addrC <= IndexC2;
			mwrC <= 1;
			end
			/// SEE the mwrC

 end 


always @(*) begin

		A1 <= inA1;
		A2 <= inA2;
		B <= inB;
		macc_clear <= (position == 1);

end

always @(posedge clk) begin

	clock_count <= clock_count + 1;

	if (reset) begin
	clock_count <= 0;
	state <= S0;
	end

	else begin
	state <= nextstate;
	
	case(state)
	S0: begin
		done <= 0;
		position <= 0;


	end
	
	S1: begin
	
		if(FlagN1 == 1)
			Flag0 <= 1;
			else
			Flag0 <= 0;
		
	   if(Flag0 == 1)
			Flag1 <= 1;
			else
			Flag1 <= 0;
			
			
		if(Flag1 == 1)
			Flag2 <= 1;
			else
			Flag2 <= 0;
			
			
		if (position < 8) begin
		
		position <= position + 1;

		if (position == 7 & ColumnB == 7)
		RowFlag <= 1;
		else 
		RowFlag <= 0;
		
		if (position == 6)
		FlagN1 <= 1;
		else
		FlagN1 <= 0;
		end
		
		
		
		if (position == 8) begin
			position <= 1;
		
			
			
				if (ColumnB < 7) begin
					ColumnB <= ColumnB + 1;
				end
				else if (ColumnB == 7) begin
					ColumnB <= 0;
					RowA1 <= RowA1 + 2;
					RowA2 <= RowA2 + 2;
				end
		end 
		end
		
	S2: begin//
		LOAD <= LOAD - 1;

	end 
	S3: begin 
		done <= 1;
	end//

		endcase
		end
	
		end
		
	always @(*) begin
	case(state)
	S0: begin
	if (start == 1)
	nextstate <= S1;
	else
	nextstate <= S0;
	end
	S1: begin
	if ((RowA1 == 8 | RowA1 == 10) && (RowA2 == 9| RowA2 == 11) && ColumnB == 0)
	nextstate <= S2;
	else
	nextstate <= S1;
	end
	S2: begin
	if (LOAD == 0)
	nextstate <= S3;
	else
	nextstate <= S1;
	end
	S3: begin
	if (reset)
	nextstate <= S0;
	else 
	nextstate <= S3;
	end
	endcase
	end
endmodule
