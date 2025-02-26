//*****************************************************
// Project		: 19_hdmi_block_move_top
// File			: serializer_10_to_1
// Editor		: Wenmei Wang
// Date			: 24/02/2025
// Description	: Parallel to serial 10:1
//*****************************************************

module serializer_10_to_1 (

	input			serial_clk_5x	,	// Serial data clock 5x
	input	[9:0]	parallel_data	,	// Parallel_data
	
	output			serial_data_p	,	// Serial differential data
	output			serial_data_n

);

	// reg
	reg		[2:0]	bit_cnt = 0				;
	reg		[4:0]	datain_rise_shift = 0	;
	reg		[4:0]	datain_fall_shift = 0	;
	
	// wire
	wire	[4:0]	datain_rise;
	wire	[4:0]	datain_fall;
	
	// Rising edge - send even bits
	assign datain_rise = {parallel_data[8], parallel_data[6], parallel_data[4], parallel_data[2], parallel_data[0]};
	
	// Falling edge - send odd bits
	assign datain_fall = {parallel_data[9], parallel_data[7], parallel_data[5], parallel_data[3], parallel_data[1]};
	
	// bit_cnt: 0 - 4
	always @(posedge serial_clk_5x) begin
	
		if(bit_cnt == 3'd4)
		
			bit_cnt <= 3'd0;
			
		else
		
			bit_cnt <= bit_cnt + 1'b1;
	
	end
	
	// Left shifter for data rising and falling
	always @(posedge serial_clk_5x) begin
	
		if(bit_cnt == 3'd4) begin
			
			datain_rise_shift <= datain_rise;
			datain_fall_shift <= datain_fall;
			
		end
		else begin
		
			datain_rise_shift <= datain_rise_shift[4:1];
			datain_fall_shift <= datain_fall_shift[4:1];
			
		end
	
	end
	
	// DDIO_OUT p
	ddio_out u_ddio_out_p (
	
		.datain_h	(datain_rise_shift[0]	),
		.datain_l	(datain_fall_shift[0]	),
		.outclock	(serial_clk_5x			),
		.dataout	(serial_data_p			)
	
	);
	
	// DDIO_OUT n
	ddio_out u_ddio_out_n (
	
		.datain_h	(~datain_rise_shift[0]	),
		.datain_l	(~datain_fall_shift[0]	),
		.outclock	(serial_clk_5x			),
		.dataout	(serial_data_n			)
	
	);

endmodule