module Task4(

	input clk,
	input start,
	input reset,
	output reg done,
	output reg [10:0] clock_count,
	output reg [2:0] state,
	output reg [2:0] Position,
	//output reg [2:0] rowA1, rowA2, rowA3, rowA4, rowA5, rowA6, rowA7, rowA8,
	output reg [2:0] columnB,
//	output reg signed [7:0] A1, A2, A3, A4, A5, A6, A7, A8,//A in reg
	output reg signed [7:0] B, //B in reg
	//output reg signed [7:0] CheckA1, CheckA2, CheckA3, CheckA4,CheckA5, CheckA6,CheckA7, CheckA8,// A in mem
	output reg signed [7:0] CheckB,  //B in mem
	//output reg signed [18:0] C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8, //C1 = macc_out1, C2 = macc_out2
	output reg signed [18:0] C1_in_BUFFER, C2_in_BUFFER, C3_in_BUFFER, C4_in_BUFFER, C5_in_BUFFER, C6_in_BUFFER, C7_in_BUFFER, C8_in_BUFFER,
	output reg signed [18:0] InputC,
	output reg signed [18:0] MEM,
	output reg [5:0] addrC, addrB,
	output reg [5:0] IndexC1, IndexC2, IndexC3, IndexC4, IndexC5, IndexC6, IndexC7, IndexC8,
	//output reg [5:0] addrA1, addrA2, addrA3, addrA4, addrA5, addrA6, addrA7, addrA8, addrB,
	output reg CheckClear,
	output reg rowFlag, flag1, flag2, flag0, flagN1,
	output reg mwrC
);
 reg signed [7:0] A1, A2, A3, A4, A5, A6, A7, A8;//A in reg
//reg [5:0] IndexC1, IndexC2, IndexC3, IndexC4, IndexC5, IndexC6, IndexC7, IndexC8;
//reg signed [18:0] C1_in_BUFFER, C2_in_BUFFER, C3_in_BUFFER, C4_in_BUFFER, C5_in_BUFFER, C6_in_BUFFER, C7_in_BUFFER, C8_in_BUFFER;
reg signed [7:0] CheckA1, CheckA2, CheckA3, CheckA4,CheckA5, CheckA6,CheckA7, CheckA8;// A in mem
reg signed [18:0] C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8; //C1 = macc_out1, C2 = macc_out2
reg [5:0] addrA1, addrA2, addrA3, addrA4, addrA5, addrA6, addrA7, addrA8;
reg [2:0] rowA1, rowA2, rowA3, rowA4, rowA5, rowA6, rowA7, rowA8;



//reg signed [18:0] InputC;
wire signed [7:0] inA1,inA2, inA3, inA4, inA5, inA6, inA7, inA8 ;
wire signed [7:0] inB;
reg signed [7:0] mdiA, mdiB;
wire signed [18:0] mem; 
//wire signed [18:0] C1_in_buffer, C2_in_buffer;
reg macc_clear;
//reg mwrC = 0;
reg mwrA = 0;
reg mwrB = 0;
wire signed [18:0] macc_out1, macc_out2, macc_out3, macc_out4, macc_out5, macc_out6, macc_out7, macc_out8;
integer RowA1 = 4'd0;  //Max is 7
integer RowA2 = 4'd1;
integer RowA3 = 4'd2;  //Max is 7
integer RowA4 = 4'd3;
integer RowA5 = 4'd4;  //Max is 7
integer RowA6 = 4'd5;
integer RowA7 = 4'd6;  //Max is 7
integer RowA8 = 4'd7;

integer ColumnB = 5'd0;  //Max is 7
integer position = 4'd0; //Max is 7
integer RowFlag = 4'd0;
integer Flag1 = 4'd0;
integer Flag2 = 4'd0;
integer Flag0 = 4'd0;
integer FlagN1 = 4'd0;
integer C7Flag = 4'd0;

integer LOAD = 4'd6; // 3 cycles to enter C from buffer

//FSM declarations
reg [2:0] nextstate;

localparam S0 = 3'd0; //default
localparam S1 = 3'd1; //compute
localparam S2 = 3'd2; //Load
localparam S3 = 3'd3; //done


  RAMDUAL_A Matrix_A12(
    .data_out1(inA1),
	 .data_out2(inA2), 
    .addr1(addrA1), 
	 .addr2(addrA2),
    .mdi(mdiA), 
    .clk(clk), 
    .mwr(mwrA)
  );
  
  RAMDUAL_A Matrix_A34(
    .data_out1(inA3),
	 .data_out2(inA4), 
    .addr1(addrA3), 
	 .addr2(addrA4),
    .mdi(mdiA), 
    .clk(clk), 
    .mwr(mwrA)
  );
  
  RAMDUAL_A Matrix_A56(
    .data_out1(inA5),
	 .data_out2(inA6), 
    .addr1(addrA5), 
	 .addr2(addrA6),
    .mdi(mdiA), 
    .clk(clk), 
    .mwr(mwrA)
  );
  
  RAMDUAL_A Matrix_A78(
    .data_out1(inA7),
	 .data_out2(inA8), 
    .addr1(addrA7), 
	 .addr2(addrA8),
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
  
  MAC UUT3(
    .inA(A3), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out3)
  );
  
  MAC UUT4(
    .inA(A4), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out4)
  );
    MAC UUT5(
    .inA(A5), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out5)
  );
  
  MAC UUT6(
    .inA(A6), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out6)
  );
    MAC UUT7(
    .inA(A7), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out7)
  );
  
  MAC UUT8(
    .inA(A8), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out8)
  );

 always@(*) begin
 flag1 <= Flag1;
 flag2 <= Flag2;
 flag0 <= Flag0;
 flagN1 <= FlagN1;
 Position <= position;
 
 
 rowA1 <= RowA1;
 rowA2 <= RowA2;
 rowA3 <= RowA3;
 rowA4 <= RowA4;
 rowA5 <= RowA5;
 rowA6 <= RowA6;
 rowA7 <= RowA7;
 rowA8 <= RowA8;
 
 CheckB <= inB;
 columnB <= ColumnB;
 
 
 
 CheckA1 <= inA1;
 CheckA2 <= inA2;
 CheckA3 <= inA3;
 CheckA4 <= inA4;
 CheckA5 <= inA5;
 CheckA6 <= inA6;
 CheckA7 <= inA7;
 CheckA8 <= inA8;

 C_1 <= macc_out1;
 C_2 <= macc_out2;
 C_3 <= macc_out3;
 C_4 <= macc_out4;
 C_5 <= macc_out5;
 C_6 <= macc_out6;
 C_7 <= macc_out7;
 C_8 <= macc_out8;
 
 
 //C1_in_BUFFER <= C1_in_buffer;
 //C2_in_BUFFER <= C2_in_buffer;
 rowFlag <= RowFlag;
 
 CheckClear <= macc_clear; //Check this
 MEM <= mem;
 
 
		addrB <= ColumnB * 8 + (position);
		if ( (rowFlag == 1) && (ColumnB == 7)) begin
		addrA1 <= RowA1 + 0;
		addrA2 <= RowA2 + 0;
		addrA3 <= RowA3 + 0;
		addrA4 <= RowA4 + 0;
		addrA5 <= RowA5 + 0;
		addrA6 <= RowA6 + 0;	
		addrA7 <= RowA7 + 0;
		addrA8 <= RowA8 + 0;
		
		
		end
		else begin
 		addrA1 <= RowA1 + ((position) * 8);
		addrA2 <= RowA2 + ((position) * 8);
		addrA3 <= RowA3 + ((position) * 8);
		addrA4 <= RowA4 + ((position) * 8);
		addrA5 <= RowA5 + ((position) * 8);
		addrA6 <= RowA6 + ((position) * 8);
		addrA7 <= RowA7 + ((position) * 8);
		addrA8 <= RowA8 + ((position) * 8);
		end
		
		// SINGLE INPUT PORT FOR C
		/*
		if ((RowA1!=0)&&(RowA2!=1) && (ColumnB == 0)) begin
		IndexC1<= RowA1 + ((ColumnB - 1) * 8) -2; //
		IndexC2<= RowA2 + ((ColumnB - 1) * 8) -2; //
		IndexC3<= RowA3 + ((ColumnB - 1) * 8) -2; //
		IndexC4<= RowA4 + ((ColumnB - 1) * 8) -2; //
		IndexC5<= RowA5 + ((ColumnB - 1) * 8) -2; //
		IndexC6<= RowA6 + ((ColumnB - 1) * 8) -2; //
		IndexC7<= RowA7 + ((ColumnB - 1) * 8) -2; //
		IndexC8<= RowA8 + ((ColumnB - 1) * 8) -2; //
		end*/
	//	else if ( begin
		
	//	else begin
	//	if (ColumnB != 7) begin
		IndexC1 <= RowA1 + ((ColumnB - 1) * 8);
		IndexC2 <= RowA2 + ((ColumnB - 1) * 8);
		IndexC3 <= RowA3 + ((ColumnB - 1) * 8);
		IndexC4 <= RowA4 + ((ColumnB - 1) * 8);
		IndexC5 <= RowA5 + ((ColumnB - 1) * 8);
		IndexC6 <= RowA6 + ((ColumnB - 1) * 8);
		IndexC7 <= RowA7 + ((ColumnB - 1) * 8);
		IndexC8 <= RowA8 + ((ColumnB - 1) * 8);	
	//	end
		
		//TEST
		/*if (ColumnB == 7) begin
		IndexC1 <= RowA1 + ((ColumnB ) * 8);
		IndexC2 <= RowA2 + ((ColumnB ) * 8);
		IndexC3 <= RowA3 + ((ColumnB ) * 8);
		IndexC4 <= RowA4 + ((ColumnB ) * 8);
		IndexC5 <= RowA5 + ((ColumnB ) * 8);
		IndexC6 <= RowA6 + ((ColumnB ) * 8);
		IndexC7 <= RowA7 + ((ColumnB ) * 8);
		IndexC8 <= RowA8 + ((ColumnB ) * 8);
		end
		*/
			//mwrC <= （(position == 1) | (position == 2））;
			mwrC <= 0;
			if(Flag0 == 0 & Flag1 == 1) begin
			C1_in_BUFFER <= macc_out1;
			C2_in_BUFFER <= macc_out2;
			C3_in_BUFFER <= macc_out3;
			C4_in_BUFFER <= macc_out4;
			C5_in_BUFFER <= macc_out5;
			C6_in_BUFFER <= macc_out6;
			C7_in_BUFFER <= macc_out7;
			C8_in_BUFFER <= macc_out8;

			end
			
			
			//if(FlagN1 == 0 & Flag0 == 0 & Flag1 == 0 & Flag2 == 1) begin
			if(position == 2 ) begin
			InputC <= C1_in_BUFFER;
			addrC <= IndexC1;
			mwrC <= 1;
			end
			
			if(position == 3) begin
			InputC <= C2_in_BUFFER;
			addrC <= IndexC2;
			mwrC <= 1;
			end
			
			
			if(position == 4) begin
			InputC <= C3_in_BUFFER;
			addrC <= IndexC3;
			mwrC <= 1;
			end
			
			if(position == 5) begin
			InputC <= C4_in_BUFFER;
			addrC <= IndexC4;
			mwrC <= 1;
			end
			
			if(position == 6) begin
			InputC <= C5_in_BUFFER;
			addrC <= IndexC5;
			mwrC <= 1;
			end
			
			if(position == 7) begin
			InputC <= C6_in_BUFFER;
			addrC <= IndexC6;
			mwrC <= 1;
			//C7Flag <= 1;
			end
			
			if(Flag0 == 1) begin
			//C7Flag <= 0;
			InputC <= C7_in_BUFFER;
			addrC <= IndexC7;
			mwrC <= 1;
			end
			
			if(position == 1) begin
			InputC <= C8_in_BUFFER;
			addrC <= IndexC8;
			mwrC <= 1;
			end
			/// SEE the mwrC

 end 


always @(*) begin

		A1 <= inA1;
		A2 <= inA2;
		A3 <= inA3;
		A4 <= inA4;
		A5 <= inA5;
		A6 <= inA6;
		A7 <= inA7;
		A8 <= inA8;
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
		
			
			//check following
			
				if (ColumnB < 7) begin
					ColumnB <= ColumnB + 1;
				end
				else if (ColumnB == 7) begin
					ColumnB <= 8; //TEST
					RowA1 <= RowA1 + 0;
					RowA2 <= RowA2 + 0;
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
	if ( ColumnB == 8)
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
