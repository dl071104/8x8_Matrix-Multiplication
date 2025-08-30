
module Task2(

	input clk,
	input start,
	input reset,
	output reg done,
	output reg [10:0] clock_count,
	output reg [2:0] state,
	output reg [2:0] Position,
	output reg [2:0] rowA,
	output reg [2:0] columnB,
	output reg signed [7:0] A,
	output reg signed [7:0] B,
	output reg signed [7:0] CheckA,
	output reg signed [7:0] CheckB,
	output reg signed [18:0] CheckC,
	output reg signed [18:0] InputC,
	output reg signed [18:0] MEM,
	output reg [5:0] addrC,
	output reg [5:0] addrA, addrB,
	output reg CheckClear,
	output reg rowFlag
);




wire signed [7:0] inA;
wire signed [7:0] inB;
reg signed [7:0] mdiA, mdiB;
wire signed [18:0] mem;
reg macc_clear;
reg mwrC;
reg mwrA = 0;
reg mwrB = 0;
wire signed [18:0] macc_out;
integer RowA = 4'd0;  //Max is 7

integer ColumnB = 4'd0;  //Max is 7

integer position = 4'd0; //Max is 7


integer RowFlag = 4'd0;

//FSM declarations
reg [2:0] nextstate;

localparam S0 = 3'd0; //default
localparam S1 = 3'd1; //compute
localparam S2 = 3'd2; //done

  RAM_A Matrix_A(
    .data_out(inA), 
    .addr(addrA), 
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

  MAC UUT(
    .inA(A), 
    .inB(B), 
    .clk(clk), 
    .macc_clear(macc_clear), 
    .macc_out(macc_out)
  );

 always@(*) begin
 Position <= position;
 rowA <= RowA;
 columnB <= ColumnB;
 CheckA <= inA;
 CheckB <= inB;
 CheckC <= macc_out;
 rowFlag <= RowFlag;
 CheckClear <= macc_clear; //Check this
 MEM <= mem;
		addrB <= ColumnB * 8 + (position);
		if ( (rowFlag == 1) && (ColumnB == 7))
		addrA <= RowA + 1;
		else
 		addrA <= RowA + ((position) * 8);

		if ((RowA!=0) && (ColumnB == 0))
		addrC <= RowA + ((ColumnB - 1) * 8) -1;
		else
		addrC <= RowA + ((ColumnB - 1) * 8);
	
			mwrC <= (position == 1);
			InputC <= macc_out;

 end 
 
always @(*) begin
	//	if (flag == 0) begin
		A <= inA;
		B <= inB;
		macc_clear <= (position == 1);
	//end
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


		if (position < 8) begin
		position <= position + 1;
		//mwrC <= 0;
		if (position == 7 & ColumnB == 7)
		RowFlag <= 1;
		else 
		RowFlag <= 0;
		end
		
		if (position == 8) begin
			position <= 1;
		
			
			
				if (ColumnB < 7) begin
					ColumnB <= ColumnB + 1;
				end
				else if (ColumnB == 7) begin
					ColumnB <= 0;
					RowA <= RowA + 1;
				end
		end 
	//	if (RowA == 7 && Column == 7)
	//	done <= 1;
	//	end
		end
	S2: begin//
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
	if (RowA == 8 && ColumnB == 0)
	nextstate <= S2;
	else
	nextstate <= S1;
	end
	S2: begin
	if (reset)
	nextstate <= S0;
	else
	nextstate <= S2;
	end
	endcase
	end
endmodule

