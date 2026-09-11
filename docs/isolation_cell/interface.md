# Interface specification

[Return to the module documentation index](README.md).

## Parameters

| Parameter | Default | Legal values | Description |
|---|---:|---|---|
| `WIDTH` | `1` | Integers greater than or equal to `1` | Number of isolated bits |
| `CLAMP_VALUE` | `'0` | Known `WIDTH`-bit constants | Output while isolation is active |
| `ISOLATE_ACTIVE_HIGH` | `1` | `0` or `1` | Static isolation-control polarity |

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_data` | Input | `WIDTH` | Data from the switchable source domain |
| `i_isolate` | Input | `1` | Always-on isolation control |
| `o_data` | Output | `WIDTH` | Passed or clamped destination-domain data |

## Functional contract

When isolation is inactive, `o_data` equals `i_data`. When isolation is active,
`o_data` equals `CLAMP_VALUE`. The module is combinational, has zero
architectural cycles of latency, no state, no clock, no reset, and no handshake.

An `X` or `Z` control is illegal and must be reported by integration checks. The
RTL nevertheless behaves conservatively through conditional-operator bit
merging. Data bits matching their clamp remain known and differing bits become
unknown. Unknown or high-impedance data passes while isolation is inactive and
cannot affect the known clamp while isolation is active.

## Integration contract

- `i_isolate` must originate from an always-on source and assert before source
  power removal. It may deassert only after power-good and source state validity.
- Every bus bit must map exactly once to an approved isolation function with the
  matching clamp bit, control polarity, supplies, and placement policy.
- A protocol owner must justify each clamp and prove that it cannot create a
  transfer, consume credit, lose accepted work, or violate channel invariants.
- The wrapper provides neither level shifting nor retention. Crossings requiring
  both isolation and translation need separate approved cells or a qualified
  combined cell.
- Generic data isolation must not be used directly on clocks or asynchronous
  resets.

## Portable power profile

The supplied UPF models a source domain that may turn off, an active destination
domain, `BOTH_ON` and `SOURCE_OFF` power states, an active-high clamp-zero
strategy, and parent-side placement. It validates portable intent only. Projects
must adapt clamp value and polarity per instance, provide complete power-state
and sequencing models, and bind approved technology cells.
