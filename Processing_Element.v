 module block(inp_north, inp_west, clk, rst, outp_south, outp_east, result);


input signed[7:0] inp_north, inp_west;
output reg signed[7:0] outp_south, outp_east;
input clk, rst;
output reg signed[18:0] result;
wire signed [18:0] multi;
	always @(posedge rst or posedge clk) begin
		if(rst) begin
			result <= 0;
			outp_east <= 0;
			outp_south <= 0;
		end
		else begin
			result <= result + multi;
			outp_east <= inp_west;
			outp_south <= inp_north;
		end
	end
	assign multi = inp_north*inp_west;
endmodule
