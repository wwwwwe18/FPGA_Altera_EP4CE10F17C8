`timescale 1 ns/ 1 ps

module breath_led_vlg_tst();

reg sys_clk;
reg sys_rst_n;
                                          
wire led;
wire [15:0]	period_cnt;
wire [15:0]	duty_cycle;
wire		inc_dec_flag;
                    
breath_led i1 (
	.led(led),
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.period_cnt(period_cnt),
	.duty_cycle(duty_cycle),
	.inc_dec_flag(inc_dec_flag)
);

initial                                                
	begin
		sys_clk = 1'b0;
		sys_rst_n = 1'b0;
		#40 sys_rst_n = 1'b1;
	end
	
always #10 sys_clk = ~sys_clk;

endmodule

