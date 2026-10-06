# Interface Specification

[Return to the module documentation index](README.md).

## Overview

`operand_isolation` is a combinational, technology-independent datapath
primitive. It passes `i_data` while computation is active and drives
`CLAMP_VALUE` while isolation is requested. The clamp prevents irrelevant
upstream activity from propagating into an expensive downstream cone.

This module implements architectural operand isolation. It does not implement
power-domain isolation, retention, level shifting, synchronization, state
holding, protocol cancellation, or glitch filtering.

## Parameters

| Parameter | Type | Default | Legal values | Description |
| --- | --- | --- | --- | --- |
| `WIDTH` | `int unsigned` | `32` | Integers greater than or equal to 1 | Operand width |
| `CLAMP_VALUE` | `logic [WIDTH-1:0]` | `'0` | Known zero and one bits | Constant driven while isolated |

The declared parameter type sizes `CLAMP_VALUE` to exactly `WIDTH` bits.
`WIDTH=0` and a clamp containing X or Z are rejected during elaboration.

## Ports

| Port | Direction | Width | Description |
| --- | --- | --- | --- |
| `i_data` | Input | `WIDTH` | Upstream operand |
| `i_isolate` | Input | 1 | Active-high architectural isolation request |
| `o_data` | Output | `WIDTH` | Transparent or clamped operand |

The module has no clock, reset, state, handshake, or backpressure interface.

## Functional Behavior

| `i_isolate` | `o_data` |
| --- | --- |
| `0` | `i_data` |
| `1` | `CLAMP_VALUE` |
| `X` or `Z` | All bits unknown and an assertion failure in verification |

Pass-through mode preserves the complete four-state value of `i_data`.
Isolation mode prevents changes on `i_data` from changing `o_data`.

## Timing Contract

- Architectural latency is zero cycles.
- The initiation interval is one cycle when placed between registered stages.
- `i_data` to `o_data` and `i_isolate` to `o_data` are combinational paths.
- The integration must make `i_isolate` stable before downstream capture.
- This module does not make an asynchronous control metastability-safe.

The control path can become timing-critical when it drives wide operands or
many instances. Buffering and replication are physical integration decisions.

## Clamp Selection

Zero is the preferred initial value because it often maps to simple gating.
Another value may be selected when it is legal for the downstream function and
reduces activity more effectively. The selected clamp must not trigger an
exception, illegal mode, memory operation, or control action when the
downstream result is inactive.

## Integration Assumptions

- The consumer asserts `i_isolate` only when the downstream result is unused.
- Valid, ready, stall, kill, predicate, lane-mask, and pipeline state remain
  coordinated with the isolation decision.
- `i_data` and `i_isolate` are coherent in the consuming clock domain.
- An asynchronous isolation request is synchronized before reaching this leaf.
- Test mode can force transparent operation when downstream ATPG access needs it.
- UPF inserts approved isolation and level shifting at actual power crossings.

Violating the first assumption can silently corrupt an accepted operation.
That protocol relationship must be verified at the consuming hierarchy.

## Low-Power Scope

The leaf is useful only when saved downstream switching exceeds its area,
delay, and control-generation cost. Unit verification demonstrates activity
suppression in representative combinational cones. Technology-specific energy
savings require a mapped baseline and consuming implementation under identical
activity, libraries, corners, and workloads.
