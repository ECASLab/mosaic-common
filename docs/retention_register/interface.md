# Interface specification

[Return to the module documentation index](README.md).

## Parameters

| Parameter | Default | Description |
|---|---:|---|
| `WIDTH` | `1` | Number of retained bits |
| `RESET_VALUE` | `'0` | Known reset value for visible and retained state |
| `ASYNC_RESET` | `0` | Selects asynchronous active-low reset |
| `HAS_ENABLE` | `1` | Enables functional clock-enable behavior |

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_clk` | Input | `1` | Rising-edge functional clock |
| `i_rstb` | Input | `1` | Active-low reset |
| `i_enable` | Input | `1` | Functional update enable |
| `i_save` | Input | `1` | Saves the pre-edge visible state |
| `i_restore` | Input | `1` | Restores the saved image |
| `i_d` | Input | `WIDTH` | Functional next state |
| `o_q` | Output | `WIDTH` | Visible state |

## Behavior

Controls follow `reset > restore > save > functional enable > hold`. Save and
restore are synchronous active-high pulses. Save updates only the retained image
with the pre-edge `o_q`; restore updates only visible state. With
`HAS_ENABLE=0`, normal operation captures `i_d` every rising edge.

Synchronous reset acts on a rising edge. Asynchronous reset assertion immediately
sets both model states to `RESET_VALUE`; release must be synchronized externally.
The module has one-cycle functional latency and no internally generated clock,
handshake, acknowledgement, isolation, level shifting, or power switching.

## Integration contract

- Save and restore must be mutually exclusive, and functional writes must be
  quiesced during either operation.
- Save must complete before clock or main power removal. Restore must occur only
  after main power and clock stability and before isolation release.
- The retention supply and always-on controls must remain valid throughout the
  main-off interval.
- Restore after retention-supply loss is prohibited and requires cold reset or
  full reinitialization.
- Every retained bit requires one approved technology retention function and a
  documented architectural retention rationale.
