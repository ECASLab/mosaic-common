# Verification plan

[Return to the repository README](../../README.md).

## Objectives

Verification must establish reset priority, enabled capture, disabled hold,
unconditional capture, nonzero reset values, structural parameter selection, and
synthesizability without generated clocks or unintended state.

## Environments

| Environment | Top | Purpose |
|---|---|---|
| Verilator simulation | `dff_tb` | Self-checking directed and randomized parameter regression |
| VCS simulation | `dff_tb` | Optional licensed regression, disabled for this release |
| Bound SVA | `dff_sva` | Control, reset, capture, and hold checks per instance |
| Assertion coverage | `dff_tb` | Verilator LCOV evidence for required SVA antecedents |
| SymbiYosys | `dff_formal` | Four-structure safety proof with symbolic inputs |
| EQY | `dff` | Default-profile RTL-to-Yosys-netlist equivalence |
| Static frontends | `dff` | Style, lint, elaboration, and synthesizability |
| Constraint intent | SDC profiles | Open-source Tcl validation of clocks, delays, uncertainty, and reset paths |

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
| `DFF-SYN-001` | Exactly `WIDTH` state bits synthesize | Not applicable | Yosys synthesis report |
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
cover properties. Run `make MODULE=dff assertion-coverage` to require positive
hits for reset, reset priority, enabled capture, disabled hold, unconditional
capture, and asynchronous reset assertion. The generated LCOV database and logs
are retained under `reports/dff/assertion_coverage/`.

The open-source Verilator campaign is the release coverage authority for this
module. It requires 100% coverage of executable RTL lines and RTL toggles, plus
a positive hit for every applicable functional coverpoint instance. This also
requires every observed output bit to transition to zero and one outside reset.
Checker and testbench coverage is retained for diagnosis but is excluded from
release thresholds. Separate commercial coverage collection is not required.

## Negative qualification

Run the verification-only mutation campaign with:

```sh
make MODULE=dff fault-injection
```

The simulation campaign substitutes `verif/tb/fault_injection/dff_mutant.sv`
for the production RTL and demonstrates detection of an incorrect reset value,
capture while disabled, failure to capture while enabled, and enable use in the
always-capture profile. Each mutation passes qualification only when the normal
checker or a bound assertion terminates simulation with a failure.

The equivalence campaign compares the production RTL with the deliberately
incorrect candidate netlist under `verif/formal/fault_injection/`. It passes
qualification only when EQY rejects equivalence. Mutation sources are
verification assets and must never appear in production RTL or normal filelists.
Reports are retained under `reports/dff/fault_injection/`.

## Exit criteria

- Every matrix configuration elaborates and simulates.
- Every required assertion antecedent has a recorded coverage hit.
- Every fault-injection mutation is detected by its assigned verification flow.
- Bound assertions pass and their meaningful antecedents are reached.
- Formal safety properties prove and cover goals are reachable.
- Verible, Slang, Verilator, Yosys, and EQY checks pass.
- Synchronous, asynchronous, and exploratory SDC profiles pass static intent checks.
- The release manifest validates and indexes all required `PASS` and approved
  `SKIP` evidence with source, methodology, tool, configuration, and constraint
  identities.
- OpenROAD passes when a qualified OpenROAD Flow Scripts platform is enabled.
- Commercial static, synthesis, timing, and power checks pass when release scope
  requires them.
- Every exception is recorded in [`waivers.md`](waivers.md).
- Evidence corresponds to the reviewed source and methodology revisions.
