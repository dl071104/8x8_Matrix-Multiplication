module RAMDUAL_A(
output reg signed [7:0] data_out1, data_out2,
input [5:0] addr1, addr2,
input signed [7:0] mdi,
input clk,
input mwr);


reg [7:0] RAM[63:0] /* synthesis ramstyle = "M9K" */;
 //(* ramstyle = "M9K" *) reg [7:0] RAM[63:0];

 
 
reg [7:0] memory [63:0];
integer i;

initial begin 
	$readmemb("C:/Users/86108/Desktop/EEC180/Lab6/test/tb_Task2/ram_a_init.txt", memory);
	
	for(i = 0; i < 64; i = i + 1) begin
	RAM[i] = memory [i];
	end
end


always @(posedge clk) begin

 if (mwr) begin
 
	RAM[addr1] <=mdi;
	RAM[addr2] <= mdi;
	end
	else begin
		data_out1 <= RAM[addr1];
		data_out2 <= RAM[addr2];
	end
end

endmodule
	
