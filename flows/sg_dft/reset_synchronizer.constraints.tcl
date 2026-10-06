# SG DFT is an approved leaf-release skip. MOSAIC/SoC DFT integration must
# control i_async_rstb and supply at least STAGES i_clk
# pulses before functional observation. No combinational reset bypass is allowed.
# Synchronizer stages require an explicit scan inclusion or exclusion policy.
