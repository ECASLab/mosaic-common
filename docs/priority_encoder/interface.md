# Interface specification

[Return to the repository README](../../README.md).

## Overview

`priority_encoder` is a zero-latency combinational fixed-priority selector. It
contains no clock, reset, state, handshake, acknowledgement, or fairness policy.

## Parameters

| Parameter | Default | Legal values | Description |
|---|---:|---|---|
| `WIDTH` | `4` | Integers greater than or equal to `1` | Request count |
| `LSB_HIGH_PRIORITY` | `1` | `0` or `1` | Selects the fixed priority direction |
| `INDEX_WIDTH` | Derived | `(WIDTH > 1) ? $clog2(WIDTH) : 1` | Binary index width |

Overriding `INDEX_WIDTH` with a value other than the derived width is illegal.

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_request` | Input | `WIDTH` | Active-high requests |
| `o_valid` | Output | `1` | At least one request is asserted |
| `o_index` | Output | `INDEX_WIDTH` | Selected request index |
| `o_onehot` | Output | `WIDTH` | One-hot selected request |
| `o_multiple` | Output | `1` | More than one request is asserted |

## Behavior

With LSB-first priority, index zero is highest priority. With MSB-first priority,
index `WIDTH-1` is highest priority. No request produces zero on every output.
Multiple requests are legal and set `o_multiple` without changing selection.

Unknown or high-impedance request bits are illegal. The portable two-state flow
must be supplemented by a four-state release gate before final qualification.

## Integration contract

- Requests must be coherent in one consuming-domain context.
- Fixed priority may starve lower-priority requesters.
- Request retention, acknowledgement, fairness, and backpressure are external.
- Asynchronous request sources require an approved synchronization mechanism.

## Timing and static-analysis intent

- The standalone leaf has no clock, reset, state, timing exception, or internal
  asynchronous path.
- All input-to-output paths use a 5 ns maximum-delay budget, 0.1 ns input
  transition, and 0.01 output load in the portable constraint profile.
- Requests must be synchronized and coherent before entering the leaf. CDC and
  reset-domain analysis belongs to the first integration containing the request
  sources and their consumers.
- The leaf contains no scan element or test mode. DFT controllability and
  observability are evaluated with the consuming block.
- The baseline UPF places the leaf in one always-powered domain without
  retention. Isolation and level shifting are integration responsibilities when
  requests or outputs cross power or voltage domains.
