
package require ::quartus::project

#system clock:50Mhz
set_location_assignment PIN_M2 -to sys_clk

#system reset
set_location_assignment PIN_M1 -to sys_rst_n

###HDMI
set_location_assignment PIN_A12 -to tmds_clk_n
set_location_assignment PIN_B12 -to tmds_clk_p
set_location_assignment PIN_A9 -to tmds_data_n[2]
set_location_assignment PIN_A10 -to tmds_data_n[1]
set_location_assignment PIN_A11 -to tmds_data_n[0]
set_location_assignment PIN_B9 -to tmds_data_p[2]
set_location_assignment PIN_B10 -to tmds_data_p[1]
set_location_assignment PIN_B11 -to tmds_data_p[0]
