# Scan insertion and test protocol ownership remain with the integrating design.
set_dft_signal -view existing_dft -type Clock -port i_clk -timing {45 55}
set_dft_signal -view existing_dft -type Reset -port i_rstb -active_state 0
