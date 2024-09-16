`timescale 1ns/1ns	// Simulation <time_unit>/<time_precision>

module flow_led_tb();

parameter T = 20;

reg			sys_clk;
reg			sys_rst_n;

wire [3:0]	led;

initial begin
	sys_clk = 1'b0;
	sys_rst_n =1'b0;
	#(T+1)
	sys_rst_n = 1'b1;
end

always #(T/2) sys_clk = ~sys_clk;

flow_led u_flow_led(
	.sys_clk	(sys_clk  ),
	.sys_rst_n  (sys_rst_n),
    .led        (led      )
	);
	
endmodule
