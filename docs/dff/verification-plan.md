# Verification plan

[Return to the repository README](../../README.md).

## Objectives

Verification must establish reset priority, enabled capture, disabled hold,
unconditional capture, nonzero reset values, structural parameter selection, and
synthesizability without generated clocks or unintended state.

## Environments

| Environment | Top | Purpose |
|---|---|---|
| Verilator simulation | `mosaic_dff_tb` | Self-checking directed and randomized parameter regression |
| VCS simulation | `mosaic_dff_tb` | Licensed regression and SAIF generation |
| Bound SVA | `mosaic_dff_sva` | Control, reset, capture, and hold checks per instance |
| SymbiYosys | `mosaic_dff_formal` | Four-structure safety proof with symbolic inputs |
| EQY | `mosaic_dff` | Default-profile RTL-to-Yosys-netlist equivalence |
| Static frontends | `mosaic_dff` | Style, lint, elaboration, and synthesizability |

## Traceability

| ID | Requirement | Simulation | Assertion or formal evidence |
|---|---|---|---|
| `DFF-RST-001` | Reset loads `RESET_VALUE` | Clocked and mid-cycle reset tests | Reset SVA and formal reset properties |
| `DFF-RST-002` | Reset has priority over enable and data | Reset while capture is requested | Formal reset properties |
| `DFF-DATA-001` | Enabled mode captures `i_d` | Directed and random capture | `output_updates_when_enabled` |
| `DFF-HOLD-001` | Enabled mode holds while disabled | Directed and random hold | `output_holds_when_disabled` |
| `DFF-DATA-002` | No-enable mode ignores `i_enable` | Both no-enable reset variants | `output_updates_without_enable` |
| `DFF-CTL-001` | Active controls are known | Normal regression | Known-control assertions |
| `DFF-STR-001` | All four structures elaborate | Seven-instance regression | Slang, Verilator, and formal elaboration |
| `DFF-SYN-001` | Exactly `WIDTH` state bits synthesize | Not applicable | Yosys and commercial synthesis reports |
| `DFF-EQY-001` | Synthesis preserves behavior | Not applicable | EQY SAT proof |

## Parameter matrix

| Width | Reset style | Enable style | Reset value | Simulation | Formal |
|---:|---|---|---|---|---|
| `1` | Synchronous | Enabled | Zero | Required | Structural equivalent |
| `1` | Asynchronous | Enabled | Zero | Required | Structural equivalent |
| `8` | Synchronous | Enabled | `8'hA5` | Required | Structural equivalent |
| `32` | Asynchronous | Enabled | `32'h5A5A_A5A5` | Required | Structural equivalent |
| `32` | Synchronous | Always capture | Zero | Required | Structural equivalent |
| `32` | Asynchronous | Always capture | `32'hC3C3_3C3C` | Required | Structural equivalent |
| `128` | Synchronous | Enabled | Nonzero | Required | Structural equivalent |
| `4` | All four combinations | Both | `4'hA` | Not applicable | Required |

Each simulation checker runs directed reset, capture, hold, mid-cycle reset, and
64 randomized capture or hold cycles. The top fails on mismatch or timeout.

## Formal proof

The harness instantiates synchronous and asynchronous reset variants with and
without enable. Inputs are symbolic. It proves reset state, enabled update,
disabled hold, and unconditional capture, and covers reset and enable transitions.

The asynchronous reset properties intentionally model assertion independently of
the functional clock. No assumption permits asynchronous data or enable use.

## Coverage

Required functional scenarios are represented by the parameter matrix and bound
cover properties. Commercial regressions should additionally collect statement,
branch, expression, toggle, assertion, and functional coverage. Every output bit
must toggle to zero and one outside reset for representative widths.

## Negative qualification

Temporary fault injection must demonstrate detection of an incorrect reset value,
capture while disabled, failure to capture while enabled, enable use in the
always-capture profile, and RTL/netlist mismatch. Faults must not remain in a
reviewed branch.

## Exit criteria

- Every matrix configuration elaborates and simulates.
- Bound assertions pass and their meaningful antecedents are reached.
- Formal safety properties prove and cover goals are reachable.
- Verible, Slang, Verilator, Yosys, and EQY checks pass.
- OpenROAD passes when a qualified OpenROAD Flow Scripts platform is enabled.
- Commercial static, synthesis, timing, and power checks pass when release scope
  requires them.
- Every exception is recorded in [`waivers.md`](waivers.md).
- Evidence corresponds to the reviewed source and methodology revisions.
