# Interface specification

[Return to the repository README](../../README.md).

## Overview

`dff` stores `WIDTH` state bits. Reset has priority over capture. With
`HAS_ENABLE = 1`, the bank captures `i_d` only when `i_enable` is asserted. With
`HAS_ENABLE = 0`, it captures on every rising edge and ignores `i_enable`.

## Parameters

| Parameter | Type | Default | Legal values | Description |
|---|---|---:|---|---|
| `WIDTH` | `int unsigned` | `1` | Integers greater than zero | Number of stored bits |
| `RESET_VALUE` | `logic [WIDTH-1:0]` | `'0` | Any `WIDTH`-bit value | Value loaded by reset |
| `ASYNC_RESET` | `bit` | `0` | `0`, `1` | Selects synchronous or asynchronous reset |
| `HAS_ENABLE` | `bit` | `1` | `0`, `1` | Selects enabled or unconditional capture |

`ASYNC_RESET` and `HAS_ENABLE` select static generate branches. Runtime logic does
not choose the reset or enable structure. `WIDTH = 0` is rejected during
elaboration.

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_clk` | Input | `1` | Rising-edge functional clock |
| `i_rstb` | Input | `1` | Active-low reset |
| `i_enable` | Input | `1` | Capture enable when `HAS_ENABLE = 1` |
| `i_d` | Input | `WIDTH` | Next state value |
| `o_q` | Output | `WIDTH` | Current registered state |

## Functional behavior

| Condition | Applicable event | Next `o_q` |
|---|---|---|
| `i_rstb = 0` | Rising edge, or falling reset edge in asynchronous mode | `RESET_VALUE` |
| `i_rstb = 1`, enabled mode, `i_enable = 1` | Rising edge | `i_d` |
| `i_rstb = 1`, enabled mode, `i_enable = 0` | Rising edge | Previous `o_q` |
| `i_rstb = 1`, no-enable mode | Rising edge | `i_d` |

Unknown `i_rstb` and, when used, unknown `i_enable` are illegal operating
conditions and are checked by assertions.

## Reset behavior

With `ASYNC_RESET = 0`, reset is sampled only at a rising `i_clk` edge. With
`ASYNC_RESET = 1`, reset assertion immediately schedules `o_q` to
`RESET_VALUE`. Asynchronous reset release must be synchronized externally and
must satisfy recovery and removal requirements.

This module is neither a reset synchronizer nor a CDC synchronizer.

The default synthesis flow elaborates `ASYNC_RESET = 0` and uses
`flows/synthesis/timing.sdc`. Integrations that elaborate
`ASYNC_RESET = 1` must select `flows/synthesis/timing_async.sdc`. Both profiles
time `i_rstb` relative to `i_clk`. The asynchronous profile intentionally keeps
recovery and removal analysis enabled for reset release.

## Timing and integration

- Capture latency is one rising edge.
- Initiation interval is one cycle.
- `i_d` and active `i_enable` must be synchronous to `i_clk`.
- No ready-valid protocol or backpressure is present.
- No internal clock is generated.
- `i_enable` is a functional state control and must not be used as a clock.
- Clock gating, retention, isolation, level shifting, and scan insertion are
  external concerns.

The baseline constraints use a 10 ns clock, 0.1 ns uncertainty, and 0.5 ns input
and output delays. Reset is excluded from synchronous input delay and constrained
as an asynchronous path. Target-specific qualification must review these values.
