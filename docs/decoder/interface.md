# Interface specification

[Return to the module documentation index](README.md).

## Overview

`decoder` is a zero-latency, combinational binary-to-one-hot decoder. It is
intended for routing controls, write enables, register selection, context
selection, functional-unit activation, and similar control paths.

The primitive does not define opcodes, instruction formats, datatype legality,
context transitions, or tile-specific behavior. Higher-level logic remains
responsible for those policies.

## Parameters

| Parameter | Default | Legal values | Description |
| --- | ---: | --- | --- |
| `NUM_OUTPUTS` | `4` | Integers greater than or equal to `1` | Number of decoded outputs |
| `SELECT_WIDTH` | Derived | `(NUM_OUTPUTS > 1) ? $clog2(NUM_OUTPUTS) : 1` | Binary selection width |

Overriding `SELECT_WIDTH` with a value other than the derived width is illegal.
Non-power-of-two values of `NUM_OUTPUTS` are supported.

## Ports

| Port | Direction | Width | Description |
| --- | --- | ---: | --- |
| `i_enable` | Input | `1` | Active-high decode enable |
| `i_select` | Input | `SELECT_WIDTH` | Binary selection |
| `o_decoded` | Output | `NUM_OUTPUTS` | Active-high one-hot result |
| `o_select_valid` | Output | `1` | Legal enabled selection indicator |

`o_decoded[0]` corresponds to selection zero. In general,
`o_decoded[N]` corresponds to `i_select == N`.

## Behavior

| Condition | `o_decoded` | `o_select_valid` |
| --- | --- | ---: |
| Enabled and legal selection | Only `o_decoded[i_select]` is high | `1` |
| Disabled | All zero | `0` |
| Enabled and out-of-range selection | All zero | `0` |
| Unknown or high-impedance enable | All zero | `0` |
| Unknown or high-impedance selection | All zero | `0` |

The output is always one-hot or zero. Invalid inputs never wrap, retain an old
value, or activate an unintended output. Four-state verification also flags
unknown controls so integration errors remain visible despite fail-closed RTL.

## Timing contract

- Architectural latency is zero cycles.
- Initiation interval is one cycle between surrounding registered stages.
- The module has no internal state, clock, reset, or backpressure.
- Timing paths exist from `i_enable` and `i_select` to both outputs.

A registered or hierarchical decoder changes the latency contract and must use
a separate module.

## Integration contract

- `i_enable` and `i_select` must be coherent in the consuming clock domain.
- Asynchronous sources must be synchronized before reaching this leaf.
- Decoded outputs may drive enables but must not directly gate clocks.
- Physical clock control must use an approved integrated clock-gating cell.
- Operation, route, datatype, and destination legality remain external.
- Voltage and power-domain crossings require integration-level protection.

## Low-power intent

When disabled, selection changes do not propagate to `o_decoded` or
`o_select_valid`. This suppresses downstream activity. The behavior is logical
activity control and is not UPF isolation, retention, or power gating.
