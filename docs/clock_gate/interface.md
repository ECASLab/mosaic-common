# Interface specification

[Return to the module documentation index](README.md).

## Contract

`clock_gate` suppresses source-clock pulses while disabled and propagates only
complete pulses after either enable is captured during the low clock phase. It
contains no reset and has no functional parameters.

| Port | Direction | Description |
| --- | --- | --- |
| `i_clk` | Input | Ungated source clock |
| `i_enable` | Input | Active-high functional enable |
| `i_test_enable` | Input | Active-high DFT override |
| `o_gclk` | Output | Glitch-free gated clock |

The effective enable is `i_enable | i_test_enable`. Changes made while `i_clk`
is high cannot start, truncate, or extend that high pulse. Changes made while
`i_clk` is low affect the next rising edge.

Unknown enable controls are illegal. The integrating design must provide
timing-safe controls, initialization clock access, scan controllability, and any
required CDC handling. This module does not synchronize, select, divide, or
generate clocks.

## Implementation boundary

The portable RTL intentionally infers one low-phase latch followed by an AND
function. ASIC flows must map each instance to one approved integrated
clock-gating cell and define `o_gclk` as a generated clock. FPGA flows must use
native clock enables or an approved vendor clock-control primitive rather than
ordinary LUT logic on a clock net.

The module-specific baseline UPF places the wrapper in one always-powered power
domain. Integrations that gate a switchable domain must extend the system UPF
with the control-source domain, power states, isolation, retention, and clock
availability sequencing.
