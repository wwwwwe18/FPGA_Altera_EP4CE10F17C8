`timescale 1 ns/ 1 ps
module top_key_beep_vlg_tst();

reg key;
reg sys_clk;
reg sys_rst_n;
                                              
wire beep;
                      
top_key_beep i1 (
	.beep(beep),
	.key(key),
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n)
);

initial                                                
	begin
		sys_clk = 1'b0;
		sys_rst_n = 1'b0;
		key = 1'b1;
		#100 sys_rst_n = 1'b1;
		
		#100 key = 1'b0;	// Bounce
		#100 key = 1'b1;	// Bounce
		#60  key = 1'b0;
		#300 key = 1'b1;
		#60  key = 1'b0;
		#300 key = 1'b1;
end
                                                 
always #10 sys_clk = ~sys_clk;

endmodule