# Clock-gate DFT intent. Qualify these commands against the selected SpyGlass
# DFT release before enabling the commercial adapter.
set_dft_signal -view existing_dft -type Clock -port i_clk -timing {45 55}
set_dft_signal -view existing_dft -type ScanEnable -port i_test_enable -active_state 1

# The integrating test protocol must assert i_test_enable before scan clocks
# begin and hold it active for the required clock-gating setup and hold windows.
# Analysis must prove that every downstream scan element receives the test clock.
