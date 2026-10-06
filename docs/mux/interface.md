# Interface Specification

[Return to the module documentation index](README.md).

## Overview

`mux` selects one fixed-width input word using a binary index. The leaf is
purely combinational and has no clock, reset, state, handshake, or backpressure.

The primitive does not validate opcodes, routes, datatypes, contexts, source
domains, or protocol legality. Those policies remain with the consumer.

## Parameters

| Parameter | Default | Legal values | Description |
| --- | ---: | --- | --- |
| `NUM_INPUTS` | `2` | Integers greater than or equal to `1` | Number of selectable words |
| `DATA_WIDTH` | `32` | Integers greater than or equal to `1` | Width of each input and `o_data` |
| `DEFAULT_VALUE` | `'0` | Known zero and one bits fitting `DATA_WIDTH` | Value returned for an invalid or unknown selection |
| `SEL_WIDTH` | Derived | `(NUM_INPUTS > 1) ? $clog2(NUM_INPUTS) : 1` | Binary selection width |

Overriding `SEL_WIDTH` with a value other than the derived width is illegal.
Unknown or high-impedance bits in `DEFAULT_VALUE` are illegal because they
would violate the deterministic fail-closed contract.

## Ports

| Port | Direction | Width | Description |
| --- | --- | ---: | --- |
| `i_data` | Input | `NUM_INPUTS x DATA_WIDTH` | Packed collection of selectable words |
| `i_select` | Input | `SEL_WIDTH` | Binary selection index |
| `o_data` | Output | `DATA_WIDTH` | Selected word or `DEFAULT_VALUE` |
| `o_select_valid` | Output | `1` | Indicates that `i_select` is known and in range |

The declaration order is
`logic [NUM_INPUTS-1:0][DATA_WIDTH-1:0] i_data`. Selection zero maps to
`i_data[0]`. Selection `N` maps to `i_data[N]`.

## Behavior

| Condition | `o_data` | `o_select_valid` |
| --- | --- | ---: |
| Known `i_select < NUM_INPUTS` | `i_data[i_select]` | `1` |
| Out-of-range binary selection | `DEFAULT_VALUE` | `0` |
| Selection contains X or Z | `DEFAULT_VALUE` | `0` |

For `NUM_INPUTS=1`, `SEL_WIDTH` remains one bit. Selection zero is legal and
selection one is invalid.

Changes on unselected inputs do not change the functional value of `o_data`.
They can still consume dynamic power in upstream logic or physical routing.

## Timing Contract

- Architectural latency is zero cycles.
- Initiation interval is one cycle between surrounding registered stages.
- Timing paths exist from every data input to `o_data`.
- Timing paths exist from `i_select` to `o_data` and `o_select_valid`.
- No false path, multicycle path, asynchronous exception, clock uncertainty, or
  reset exception applies inside the leaf.

Large fan-in or width values can exceed a consuming block's timing target. A
pipelined or hierarchical selector changes the latency contract and must use a
different module.

## Integration Contract

- Data and selection must be coherent in the consuming clock-domain context.
- Asynchronous inputs must be synchronized or protected before this leaf.
- Unrelated clock or voltage domains must not be combined without integration
  analysis and the required crossing cells.
- `o_select_valid` may be left unconnected only when configuration validation
  proves every runtime selection legal.
- Operand isolation belongs before high-capacitance sources when the system
  needs to suppress upstream switching.
