# Verification plan

[Return to the module documentation index](README.md).

## Requirements and evidence

| Requirement | Evidence |
| --- | --- |
| Disabled gate suppresses pulses | Directed simulation and bound assertions |
| Functional enable propagates complete pulses | Edge-by-edge reference model and formal proof |
| High-phase enable changes do not truncate pulses | Directed and randomized simulation |
| Test enable overrides functional disable | Directed simulation and functional coverpoint |
| Output cannot be high while source clock is low | Bound assertion and formal proof |
| Portable synthesis preserves latch gating | Yosys structure report and EQY equivalence |

The simulation checks the gated-clock value after every relevant source,
control, and output transition. It exercises low- and high-phase changes,
functional and test enables, repeated transitions, long disabled intervals, and
randomized activity. Formal verification compares the DUT against an independent
low-phase latch model after the first legal capture phase.

`make MODULE=clock_gate assertion-coverage` requires positive hits for the
functional-only, test-only, combined-enable, and disabled coverpoints. It also
requires complete executable-line and toggle coverage for the release RTL. The
current campaign records `9/9` executable lines and `21/21` toggle records with
no exclusions.

`make MODULE=clock_gate fault-injection` requires the production checker and
assertions to detect combinational clock gating, a missing test override, an
inverted functional enable, and high-phase enable capture. A fifth negative test
requires EQY to reject a deliberately incorrect combinational candidate netlist.

## Current scope

The open-source gate qualifies the portable functional model. Technology-cell
mapping, generated-clock STA, clock-gating setup and hold checks, DFT clock
controllability, low-power intent, physical clock-tree behavior, and measured
power savings remain integration-level ASIC evidence. The committed baseline
UPF describes only a single always-powered module domain and does not claim a
multi-domain or power-gated implementation.

Module-specific CDC collateral declares the source and generated clocks and
records the control-synchrony assumptions. SpyGlass DFT collateral identifies
`i_clk` as the test clock and `i_test_enable` as the active-high scan override.
The OpenROAD configuration is exploratory only because generic latch-and-gate
placement is not evidence of mapping to an approved integrated clock-gating
cell.

Dedicated generated-clock constraint validation and the remaining release
checklist items must still be completed before module release.
