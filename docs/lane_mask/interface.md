# Interface specification

[Return to the repository README](../../README.md).

## Overview

`lane_mask` is a zero-latency combinational leaf that produces one canonical
activity decision for each vector lane. It contains no clock, reset, handshake,
storage, reduction, or data-path behavior.

## Parameters

| Parameter | Type | Default | Legal values | Description |
|---|---|---:|---|---|
| `LANES` | `int unsigned` | `4` | Integers greater than or equal to `1` | Independently controlled lanes |

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_operation_valid` | Input | `1` | Global operation validity |
| `i_lane_valid` | Input | `LANES` | Per-lane input validity |
| `i_lane_mask` | Input | `LANES` | Architectural lane enable mask |
| `i_lane_predicate` | Input | `LANES` | Per-lane execution predicate |
| `o_lane_active` | Output | `LANES` | Canonical active-lane vector |
| `o_lane_isolate` | Output | `LANES` | Active-high inactive-lane isolation request |
| `o_lane_write_mask` | Output | `LANES` | Base write mask for active lanes |

## Behavior

For each lane `n`:

```text
o_lane_active[n] = i_operation_valid AND i_lane_valid[n]
                   AND i_lane_mask[n] AND i_lane_predicate[n]
o_lane_isolate[n] = NOT o_lane_active[n]
o_lane_write_mask[n] = o_lane_active[n]
```

`i_operation_valid` must always be known. Per-lane controls must be known while
the operation is valid. Unknown-control qualification requires a four-state
simulation gate before release.

## Integration contract

- All inputs must be coherent in one consuming clock domain.
- Outputs must not directly gate a physical clock.
- The write mask must be combined with the destination write request.
- Inactive lanes must not update state or contribute arbitrary reduction data.
- Controls and lane data must remain aligned through downstream pipelines.
