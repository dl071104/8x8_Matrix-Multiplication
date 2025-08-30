module RAMOUTPUT(
output reg signed [18:0] data_out,
input [5:0] addr,
input signed[18:0] mdi,
input clk,
input mwr);


reg signed [18:0] mem[63:0] /* synthesis ramstyle = "M9K", ram_init_file = "partI.mif" */;
// (* ramstyle = "M9K" *) reg signed [18:0] mem[63:0];



always @(posedge clk) begin

 if (mwr) begin
 
	mem[addr] <=mdi;
	end
		data_out <= mem[addr];
	end


endmodule
	
