
module ExtraCredit_C(
    input clk, rst,
    output reg [5:0] addrC,
	 output reg [10:0] clock_cycle, clock_cycle_computation,

    output wire signed [18:0] inputC,              
	 output reg signed [18:0] MEM,
	 //output reg signed [7:0] INA1, INA2, INB,
	 output reg mwrC,
    output reg done,
	 output reg flag,
	 output reg signed[18:0] C00, C10, C20, C30, C40, C50, C60, C70,
	 output reg signed[7:0] A00, A10, A20, A30, A40, A50, A60, A70,
	 output reg signed[7:0] B00, B01, B02, B03, B04, B05, B06, B07
	 

);
    //reg [3:0] count;
   // wire signed [7:0] inA1, inA2, inB;
	 reg signed [7:0] ARow0 [0:15], ARow1[0:15], ARow2[0:15], ARow3[0:15], ARow4[0:15], ARow5[0:15], ARow6[0:15], ARow7[0:15];
	 reg signed [7:0] BCol0 [0:15], BCol1[0:15], BCol2[0:15], BCol3[0:15], BCol4[0:15], BCol5[0:15], BCol6[0:15], BCol7[0:15];
	 wire signed [7:0] ARow_0 [0:15], ARow_1[0:15], ARow_2[0:15], ARow_3[0:15], ARow_4[0:15], ARow_5[0:15], ARow_6[0:15], ARow_7[0:15];
	 wire signed [7:0] BCol_0 [0:15], BCol_1[0:15], BCol_2[0:15], BCol_3[0:15], BCol_4[0:15], BCol_5[0:15], BCol_6[0:15], BCol_7[0:15];
	 wire signed [18:0] mem;
    wire [7:0] outp_south[0:77], outp_east[0:77];
    wire [18:0] result[0:63];
	 //reg [5:0] addrC_counter;
	 reg mwrA = 1'b0;
	 reg mwrB = 1'b0;
	 reg [7:0] mdi = 8'b0;
	 
	 integer zero = 0;
	 integer s = 0;
	 	 integer d = 0;
		 	 integer f = 0;
			 	 integer g = 0;
				 	 integer h = 0;
					 	 integer j = 0;
						 	 integer k = 0;
							 	 integer l = 0;
								 	 integer p = 0;
									 integer FLAG = 3'd2;
	 integer i;
	 genvar a;
	 
    generate
	 for (a = 0; a < 8; a = a + 1) begin : store
          
                RAMDUAL_A Matrix01 (
                    .data_out1(ARow_0[a]),
						  .data_out2(ARow_1[a+1]),
						  .addr1(6'd56-a*8),
						  .addr2(6'd57-a*8),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					 RAMDUAL_B Matrix_01(
						  .data_out1(BCol_0[a]),
						  .data_out2(BCol_1[a+1]),
						  .addr1(6'd7-a),
						  .addr2(6'd15-a),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					 RAMDUAL_A Matrix23 (
                    .data_out1(ARow_2[a+2]),
						  .data_out2(ARow_3[a+3]),
						  .addr1(6'd58-a*8),
						  .addr2(6'd59-a*8),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					  RAMDUAL_B Matrix_23(
						  .data_out1(BCol_2[a+2]),
						  .data_out2(BCol_3[a+3]),
						  .addr1(6'd23-a),
						  .addr2(6'd31-a),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					  RAMDUAL_A Matrix45 (
                    .data_out1(ARow_4[a+4]),
						  .data_out2(ARow_5[a+5]),
						  .addr1(60-a*8),
						  .addr2(61-a*8),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					 RAMDUAL_B Matrix_45(
						  .data_out1(BCol_4[a+4]),
						  .data_out2(BCol_5[a+5]),
						  .addr1(6'd39-a),
						  .addr2(6'd47-a),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					  RAMDUAL_A Matrix67 (
                    .data_out1(ARow_6[a+6]),
						  .data_out2(ARow_7[a+7]),
						  .addr1(6'd62-a*8),
						  .addr2(6'd63-a*8),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					 RAMDUAL_B Matrix_67(
						  .data_out1(BCol_6[a+6]),
						  .data_out2(BCol_7[a+7]),
						  .addr1(6'd55-a),
						  .addr2(6'd63-a),
						  .mdi(mdi),
						  .clk(clk),
						  .mwr(mwr)
                );
					 
					 
            end
				
    endgenerate
	 
	 
	 always @(posedge clk) begin
    for (s = 0; s < 16; s = s + 1) begin
        if (s < 8) begin
            ARow0[s] <= ARow_0[s];  // Load values from memory (only first 8 elements)
				BCol0[s] <= BCol_0[s];
        end else begin
            ARow0[s] <= 0;  // Zero padding for remaining elements
				BCol0[s] <= 0;
				end
    end
	 //s = s+1;
	 
end
	 
	 	 always @(posedge clk) begin
		 for (d = 0; d < 16; d = d + 1) begin
        if (d < 9 && d>0) begin
            ARow1[d] <= ARow_1[d];  // Load values from memory (only first 8 elements)
				BCol1[d] <= BCol_1[d];
        end else begin
            ARow1[d] <= 0;  // Zero padding for remaining elements
				BCol1[d] <= 0;
	 end
	 end
	 //d = d+1;

	 
end

	 	 always @(posedge clk) begin
    for (f = 0; f < 16; f = f + 1) begin
        if (f < 10 && f>1) begin
            ARow2[f] <= ARow_2[f];  // Load values from memory (only first 8 elements)
				BCol2[f] <= BCol_2[f];
        end else begin
            ARow2[f] <= 0;  // Zero padding for remaining elements
				BCol2[f] <= 0;
	 end
	 end
	// f = f + 1;
	 
end

	 	 always @(posedge clk) begin
    for (g = 0; g < 16; g = g + 1) begin
        if (g < 11 && g>2) begin
            ARow3[g] <= ARow_3[g];  // Load values from memory (only first 8 elements)
				BCol3[g] <= BCol_3[g];
        end else begin
            ARow3[g] <= 0;  // Zero padding for remaining elements
				BCol3[g] <= 0;
	 end
	 end
	 //g = g + 1; 
end

	 	 always @(posedge clk) begin
    for (h = 0; h < 16; h = h + 1) begin
        if (h < 12 && h>3) begin
            ARow4[h] <= ARow_4[h];  // Load values from memory (only first 8 elements)
				BCol4[h] <= BCol_4[h];
        end else begin
            ARow4[h] <= 0;  // Zero padding for remaining elements
				BCol4[h] <= 0;
	 end
	 end
	// h = h + 1;
	 
end
	 
	 always @(posedge clk) begin
    for (j = 0; j < 16; j = j + 1) begin
        if (j < 13 && j>4) begin
            ARow5[j] <= ARow_5[j];  // Load values from memory (only first 8 elements)
				BCol5[j] <= BCol_5[j];
        end else begin
            ARow5[j] <= 0;  // Zero padding for remaining elements
				BCol5[j] <= 0;
	 end
	 end
	//j = j +1;
	 
end

always @(posedge clk) begin
    for (k = 0; k < 16; k = k + 1) begin
        if (k < 14 && k>5) begin
            ARow6[k] <= ARow_6[k];  // Load values from memory (only first 8 elements)
				BCol6[k] <= BCol_6[k];
        end else begin
            ARow6[k] <= 0;  // Zero padding for remaining elements
				BCol6[k] <= 0;
	 end
	 end
	// k = k+1;
end




always @(posedge clk) begin
    for (p = 0; p < 16; p = p + 1) begin
        if (p < 15 && p>6) begin
            ARow7[p] <= ARow_7[p];  // Load values from memory (only first 8 elements)
				BCol7[p] <= BCol_7[p];
        end else begin
            ARow7[p] <= 0;  // Zero padding for remaining elements
				BCol7[p] <= 0;
	 end
	 end
	// p = p+1;
	 
end

    RAMOUTPUT RAMOUTPUT (
        .data_out(mem), 
        .addr(addrC),
        .mdi(inputC),
        .clk(clk),
        .mwr(mwrC)
    );
	 
	 
	 always@(*) begin
	 flag<= FLAG;
	 MEM <= mem;
	 //first column of A
	 A00 <= ARow0[i];
	 A10 <= ARow1[i];
	 A20 <= ARow2[i];
	 A30 <= ARow3[i];
	 A40 <= ARow4[i];
	 A50 <= ARow5[i];
	 A60 <= ARow6[i];
	 A70 <= ARow7[i];
	 //first row of B;
	 
	 B00 <= BCol0[i];
	 B01 <= BCol1[i];
	 B02 <= BCol2[i];
	 B03 <= BCol3[i];
	 B04 <= BCol4[i];
	 B05 <= BCol5[i];
	 B06 <= BCol6[i];
	 B07 <= BCol7[i];
	 //first column of C
	 C00 <= result[0];
	 C10 <= result[1];
	 C20 <= result[2];
	 C30 <= result[3];
	 C40 <= result[4];
	 C50 <= result[5];
	 C60 <= result[6];
	 C70 <= result[7];
	 end

	 
	 //from north and west
	block P00 (BCol0[i], ARow0[i], clk, rst, outp_south[00], outp_east[00], result[0]);
	//from north, go to left, P01 -> P02 -> P03 -> P04
	block P01 (BCol1[i], outp_east[00], clk, rst, outp_south[01], outp_east[01], result[8]);
	block P02 (BCol2[i], outp_east[01], clk, rst, outp_south[02], outp_east[02], result[16]);
	block P03 (BCol3[i], outp_east[02], clk, rst, outp_south[03], outp_east[03], result[24]);
   block P04 (BCol4[i], outp_east[03], clk, rst, outp_south[04], outp_east[04], result[32]);
	block P05 (BCol5[i], outp_east[04], clk, rst, outp_south[05], outp_east[05], result[40]);
	block P06 (BCol6[i], outp_east[05], clk, rst, outp_south[06], outp_east[06], result[48]);
	block P07 (BCol7[i], outp_east[06], clk, rst, outp_south[07], outp_east[07], result[56]);
	
	//from west
	///// go down, P00 -> P10 -> P20 -> P30
	block P10 (outp_south[00], ARow1[i], clk, rst, outp_south[10], outp_east[10], result[1]);
	block P20 (outp_south[10], ARow2[i], clk, rst, outp_south[20], outp_east[20], result[2]);
	block P30 (outp_south[20], ARow3[i], clk, rst, outp_south[30], outp_east[30], result[3]);
	block P40 (outp_south[30], ARow4[i], clk, rst, outp_south[40], outp_east[40], result[4]);
	block P50 (outp_south[40], ARow5[i], clk, rst, outp_south[50], outp_east[50], result[5]);
	block P60 (outp_south[50], ARow6[i], clk, rst, outp_south[60], outp_east[60], result[6]);//
	block P70 (outp_south[60], ARow7[i], clk, rst, outp_south[70], outp_east[70], result[7]);
	
	//no direct inputs
	//second row  P11 -> P12 -> P13 -> P14

	
	block P11 (outp_south[01], outp_east[10], clk, rst, outp_south[11], outp_east[11], result[9]);
	block P12 (outp_south[02], outp_east[11], clk, rst, outp_south[12], outp_east[12], result[17]);
	block P13 (outp_south[03], outp_east[12], clk, rst, outp_south[13], outp_east[13], result[25]);
	block P14 (outp_south[04], outp_east[13], clk, rst, outp_south[14], outp_east[14], result[33]);
	block P15 (outp_south[05], outp_east[14], clk, rst, outp_south[15], outp_east[15], result[41]);
	block P16 (outp_south[06], outp_east[15], clk, rst, outp_south[16], outp_east[16], result[49]);
	block P17 (outp_south[07], outp_east[16], clk, rst, outp_south[17], outp_east[17], result[57]);

	//third row
	block P21 (outp_south[11], outp_east[20], clk, rst, outp_south[21], outp_east[21], result[10]);
	block P22 (outp_south[12], outp_east[21], clk, rst, outp_south[22], outp_east[22], result[18]);
	block P23 (outp_south[13], outp_east[22], clk, rst, outp_south[23], outp_east[23], result[26]);
	block P24 (outp_south[14], outp_east[23], clk, rst, outp_south[24], outp_east[24], result[34]);
	block P25 (outp_south[15], outp_east[24], clk, rst, outp_south[25], outp_east[25], result[42]);
	block P26 (outp_south[16], outp_east[25], clk, rst, outp_south[26], outp_east[26], result[50]);
	block P27 (outp_south[17], outp_east[26], clk, rst, outp_south[27], outp_east[27], result[58]);
	
	
	//fourth row
	block P31 (outp_south[21], outp_east[30], clk, rst, outp_south[31], outp_east[31], result[11]);
	block P32 (outp_south[22], outp_east[31], clk, rst, outp_south[32], outp_east[32], result[19]);
	block P33 (outp_south[23], outp_east[32], clk, rst, outp_south[33], outp_east[33], result[27]);
	block P34 (outp_south[24], outp_east[33], clk, rst, outp_south[34], outp_east[34], result[35]);
	block P35 (outp_south[25], outp_east[34], clk, rst, outp_south[35], outp_east[35], result[43]);
	block P36 (outp_south[26], outp_east[35], clk, rst, outp_south[36], outp_east[36], result[51]);
	block P37 (outp_south[27], outp_east[36], clk, rst, outp_south[37], outp_east[37], result[59]);
	
	//fifth row
	block P41 (outp_south[31], outp_east[40], clk, rst, outp_south[41], outp_east[41], result[12]);
	block P42 (outp_south[32], outp_east[41], clk, rst, outp_south[42], outp_east[42], result[20]);
	block P43 (outp_south[33], outp_east[42], clk, rst, outp_south[43], outp_east[43], result[28]);
	block P44 (outp_south[34], outp_east[43], clk, rst, outp_south[44], outp_east[44], result[36]);
	block P45 (outp_south[35], outp_east[44], clk, rst, outp_south[45], outp_east[45], result[44]);
	block P46 (outp_south[36], outp_east[45], clk, rst, outp_south[46], outp_east[46], result[52]);
	block P47 (outp_south[37], outp_east[46], clk, rst, outp_south[47], outp_east[47], result[60]);
	
	//sixth row
	block P51 (outp_south[41], outp_east[50], clk, rst, outp_south[51], outp_east[51], result[13]);
	block P52 (outp_south[42], outp_east[51], clk, rst, outp_south[52], outp_east[52], result[21]);
	block P53 (outp_south[43], outp_east[52], clk, rst, outp_south[53], outp_east[53], result[29]);
	block P54 (outp_south[44], outp_east[53], clk, rst, outp_south[54], outp_east[54], result[37]);
	block P55 (outp_south[45], outp_east[54], clk, rst, outp_south[55], outp_east[55], result[45]);
	block P56 (outp_south[46], outp_east[55], clk, rst, outp_south[56], outp_east[56], result[53]);
	block P57 (outp_south[47], outp_east[56], clk, rst, outp_south[57], outp_east[57], result[61]);
		
		//seventh row
	block P61 (outp_south[51], outp_east[60], clk, rst, outp_south[61], outp_east[61], result[14]);
	block P62 (outp_south[52], outp_east[61], clk, rst, outp_south[62], outp_east[62], result[22]);
	block P63 (outp_south[53], outp_east[62], clk, rst, outp_south[63], outp_east[63], result[30]);
	block P64 (outp_south[54], outp_east[63], clk, rst, outp_south[64], outp_east[64], result[38]);
	block P65 (outp_south[55], outp_east[64], clk, rst, outp_south[65], outp_east[65], result[46]);
	block P66 (outp_south[56], outp_east[65], clk, rst, outp_south[66], outp_east[66], result[54]);
	block P67 (outp_south[57], outp_east[66], clk, rst, outp_south[67], outp_east[67], result[62]);
	
		//eighth row
	block P71 (outp_south[61], outp_east[70], clk, rst, outp_south[71], outp_east[71], result[15]);
	block P72 (outp_south[62], outp_east[71], clk, rst, outp_south[72], outp_east[72], result[23]);
	block P73 (outp_south[63], outp_east[72], clk, rst, outp_south[73], outp_east[73], result[31]);
	block P74 (outp_south[64], outp_east[73], clk, rst, outp_south[74], outp_east[74], result[39]);
	block P75 (outp_south[65], outp_east[74], clk, rst, outp_south[75], outp_east[75], result[47]);
	block P76 (outp_south[66], outp_east[75], clk, rst, outp_south[76], outp_east[76], result[55]);
	block P77 (outp_south[67], outp_east[76], clk, rst, outp_south[77], outp_east[77], result[63]);
	 

	assign inputC = result[addrC];
	 
	 
always @(posedge clk or posedge rst) begin

clock_cycle <= clock_cycle + 1;


if (result[63]!= 1947)
clock_cycle_computation <= clock_cycle_computation + 1;

    if (rst) begin
		clock_cycle <= 0;
        done <= 0;
        i <= 0;
        mwrC <= 0;
		  addrC <= 0;
		  clock_cycle_computation <= 0;
    end else begin

			
			if (i < 14) 
				i <= i + 1;
				else
				i <= 15;
				mwrC <= 1;
			
		  if (BCol0[i] == 0 && ARow0[i] == 0) begin
	

			addrC <= addrC + 1;
			end
	
			
		  if (addrC == 63)begin

		  addrC = addrC+0;
		  mwrC <= 0;
		  done <= 1;
		  end

    end    
    end

	 


endmodule
