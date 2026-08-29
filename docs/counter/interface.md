# Interface specification

[Return to the module documentation index](README.md).

This file defines the public `counter` hardware contract. Every behavior on
which another block depends is mapped to evidence in the
[verification plan](verification-plan.md).

## Overview

`counter` is a parameterizable binary up/down counter for event accounting,
loop control, FIFO pointer arithmetic, timeout detection, and observability. It
supports synchronous clear and load commands, saturating or wrapping arithmetic,
registered overflow and underflow events, and a combinational direction-aware
terminal indication.

The module does not provide Gray encoding, CDC synchronization, prescaling,
programmable step values, register mapping, or interrupt generation.

## Parameters

| Parameter | Type | Default | Legal values | Description |
| --- | --- | --- | --- | --- |
| `WIDTH` | `int unsigned` | `32` | Positive integers | Width of the count and load value |
| `RESET_VALUE` | `logic [WIDTH-1:0]` | `'0` | Any `WIDTH`-bit value | Value loaded by reset and clear |
| `ASYNC_RESET` | `bit` | `0` | `0`, `1` | Selects synchronous or asynchronous reset |
| `SATURATE` | `bit` | `1` | `0`, `1` | Selects wrapping or saturating boundary behavior |

`WIDTH=0` produces an elaboration-time fatal error. The remaining parameters are
static and select behavior during elaboration.

## Clocks and resets

| Signal | Role | Active edge or level | Behavior |
| --- | --- | --- | --- |
| `i_clk` | Functional clock | Rising edge | Samples commands, direction, and load data |
| `i_rstb` | Active-low reset | Low level | Loads `RESET_VALUE` and clears both events |

When `ASYNC_RESET=0`, reset is sampled at the rising clock edge. When
`ASYNC_RESET=1`, assertion updates registered state without waiting for an edge.
Asynchronous reset release must be synchronized externally and must satisfy the
selected implementation's recovery and removal requirements.

## Ports

| Port | Direction | Width | Description |
| --- | --- | --- | --- |
| `i_clk` | Input | 1 | Functional clock |
| `i_rstb` | Input | 1 | Active-low reset |
| `i_enable` | Input | 1 | Enables increment or decrement |
| `i_clear` | Input | 1 | Synchronously loads `RESET_VALUE` |
| `i_load` | Input | 1 | Synchronously loads `i_load_value` |
| `i_direction` | Input | 1 | Zero increments and one decrements |
| `i_load_value` | Input | `WIDTH` | Programmable load value |
| `o_count` | Output | `WIDTH` | Current count |
| `o_overflow` | Output | 1 | Registered increment-boundary event |
| `o_underflow` | Output | 1 | Registered decrement-boundary event |
| `o_terminal` | Output | 1 | Current boundary for the selected direction |

## Functional behavior

Commands follow this priority:

```text
reset > clear > load > enable > hold
```

| Highest-priority condition | Next `o_count` | Events |
| --- | --- | --- |
| Reset asserted | `RESET_VALUE` | Both clear |
| `i_clear == 1` | `RESET_VALUE` | Both clear |
| `i_load == 1` | `i_load_value` | Both clear |
| Enabled increment below maximum | `o_count + 1` | Both clear |
| Enabled decrement above zero | `o_count - 1` | Both clear |
| No active command | Previous `o_count` | Both clear |

At an increment boundary, `o_overflow` pulses for one cycle. At a decrement
boundary, `o_underflow` pulses for one cycle. The events cannot assert together.
In saturating mode the count holds at the boundary. In wrapping mode it moves to
the opposite boundary.

`o_terminal` is combinational and does not require `i_enable`. It is high at
maximum while increment direction is selected and at zero while decrement
direction is selected.

## Timing contract

- State-update latency is one rising edge.
- The initiation interval is one cycle.
- There is no ready, valid, or backpressure protocol.
- Event outputs describe the boundary attempt accepted at the previous edge.
- `o_terminal` changes combinationally with count or direction.
- Inputs must meet setup and hold requirements for `i_clk`.
- The committed timing profiles define a 10 ns clock, 0.1 ns uncertainty, and
  0.5 ns input and output delays.

The arithmetic feedback and terminal comparison may become critical paths for
large values of `WIDTH`.

## Errors and illegal use

The module has no runtime error output. `i_direction` must be known whenever an
arithmetic command is active. An unknown direction drives `o_terminal` low and
is reported by assertions. Unknown reset, clear, load, or enable controls are
also assertion failures.

Controls and `i_load_value` must belong to the `i_clk` domain. Counter values or
events crossing into another domain require an external approved CDC mechanism.
This module must not be treated as a reset synchronizer or synchronized FIFO
pointer implementation.

## Low-power behavior

No internally generated or gated clock is used. The count holds when no command
is active and a saturating count holds at its selected boundary. Event state is
cleared on inactive cycles. Clock-gating insertion, isolation, retention, and
power-domain sequencing belong to the integrating design.

## Integration assumptions

- `i_clk` remains available while state updates are required.
- Reset assertion and release follow the selected reset-style contract.
- All functional inputs are synchronous to `i_clk` except asynchronous reset
  assertion when enabled.
- Consumers sample registered events in the `i_clk` domain.
- FIFO integrations add Gray coding and pointer synchronization separately.
- Test and scan insertion are owned by the integrating design.

## Production replacement checklist

- [x] Replace the example overview and behavior.
- [x] Document every parameter and legal combination.
- [x] Document every port, clock, reset, and protocol relationship.
- [x] State latency, throughput, ordering, and backpressure.
- [x] Define errors, illegal inputs, and recovery.
- [x] Define disabled, test-mode, reset, and low-power behavior.
- [x] Link each requirement to verification evidence.
- [ ] Review this document with both module and integration owners.
