# Interface Specification

[Return to the module documentation index](README.md).

## Overview

`write_gate` is a zero-latency, per-bit write-control suppressor. It accepts a
write request and an active-high suppression decision, then emits either a
permitted write enable or a suppressed-write indication for each bit. It has no
clock, reset, state, handshake, acknowledgement, or data path.

## Parameter

| Parameter | Default | Legal values | Description |
| --- | ---: | --- | --- |
| `WIDTH` | `1` | Integers greater than or equal to `1` | Independently gated write enables |

An invalid `WIDTH=0` must fail elaboration.

## Ports

| Port | Direction | Width | Description |
| --- | --- | ---: | --- |
| `i_write_enable` | Input | `WIDTH` | Original active-high write request |
| `i_suppress` | Input | `WIDTH` | Active-high suppression decision |
| `o_write_enable` | Output | `WIDTH` | Permitted request sent to state |
| `o_write_suppressed` | Output | `WIDTH` | Observation that a requested write was blocked |

## Behavior

For each bit `n`:

```text
o_write_enable[n] = i_write_enable[n] AND NOT i_suppress[n]
o_write_suppressed[n] = i_write_enable[n] AND i_suppress[n]
```

| `i_write_enable[n]` | `i_suppress[n]` | `o_write_enable[n]` | `o_write_suppressed[n]` |
|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

The two outputs are mutually exclusive for every bit and their bitwise OR
reproduces a known input request. Unknown or high-impedance `i_write_enable`
is illegal. Unknown or high-impedance `i_suppress` is illegal when its request
bit is asserted. The four-state campaign detects both cases.

## Integration Contract

The consumer must prove that each asserted suppression bit is architecturally
legal and aligned with its write request. It must also ensure that the controls
are synchronous and coherent in the destination domain and meet the
destination write-enable timing. This module does not provide data comparison,
transaction cancellation, clock gating, CDC synchronization, retention,
isolation, or protocol responses.

Suppressing a write is never sufficient evidence of a power benefit. Any power
claim must measure the switching saved in the consuming register, memory,
counter, or write network.
