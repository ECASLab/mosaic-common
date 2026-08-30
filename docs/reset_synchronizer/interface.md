# Interface specification

[Return to the repository README](../../README.md).

## Overview

`reset_synchronizer` converts one asynchronous active-low reset source into an
active-low reset whose assertion remains asynchronous and whose release occurs
only on rising edges of one destination clock.

## Parameters

| Parameter | Type | Default | Legal values | Description |
|---|---|---:|---|---|
| `STAGES` | `int unsigned` | `2` | Integers greater than or equal to `2` | Synchronization depth |

`STAGES < 2` is rejected during elaboration. Increasing the value improves
metastability containment at the cost of release latency.

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_clk` | Input | `1` | Rising-edge destination clock |
| `i_async_rstb` | Input | `1` | Asynchronous active-low reset source |
| `o_rstb` | Output | `1` | Active-low reset synchronized for release |

## Behavior

Assertion of `i_async_rstb` clears every stage and `o_rstb` without requiring a
clock edge. After input deassertion, one advances through the chain on each
rising edge and `o_rstb` deasserts after exactly `STAGES` modeled edges. If the
clock stops, release remains pending. Reassertion at any point immediately
clears the complete chain.

An unknown `i_async_rstb` is illegal. The required Icarus four-state gate injects
an unknown value and demonstrates monitor detection because the required
Verilator flow uses a two-state simulation model.

## Integration contract

- One instance serves exactly one destination clock domain.
- Only `o_rstb` may reset functional state in that domain.
- Raw and synchronized reset must not reconverge.
- Intermediate stages may not have functional fanout.
- Clock control must provide at least `STAGES` release edges.
- No scan or functional bypass may asynchronously release `o_rstb`.
- Switchable-domain integration must define power, isolation, clock, and reset
  ordering.
- A qualified CDC/RDC engine must recognize the chain at the first integration
  level containing the reset source, synchronizer, destination clock domain, and
  reset consumers.
- The complete MOSAIC/SoC DFT flow must demonstrate reset and destination-clock
  controllability and define whether synchronization stages participate in scan.
- VC LP is required when the reset source, synchronizer, clock, or consumers
  cross power or voltage domains, or when the destination can be switched off.
- Physical implementation must preserve and colocate the synchronization chain.

The module is not a data, pulse, clock, reset-sequencing, retention, or
power-on-reset component.
