# Verification plan

[Return to the module documentation index](README.md).

## Objectives

Verification establishes deterministic no-request behavior, exact one-hot and
binary agreement, fixed-priority selection, contention reporting, both priority
directions, non-power-of-two widths, and absence of state.

## Initial evidence

| Environment | Configurations | Purpose |
|---|---|---|
| Verilator simulation | Widths `1,2,3,4,5,8,16,32`, both directions | Exhaustive small-width and randomized large-width checking |
| Bound assertions | All simulated configurations | Interface consistency and direction-aware priority checks |
| Verilator coverage | All simulated configurations | Assertion antecedents, executable RTL lines, and toggles |
| SymbiYosys | Widths `1,3,5,8`, both directions | Complete combinational proof |
| EQY | Default width and LSB-first priority | RTL-to-Yosys-netlist equivalence |
| Executable constraint check | Combinational leaf profile | Interface timing budget and absence of broad exceptions |

## Pending release evidence

- Four-state unknown and high-impedance request detection
- Fault-injection qualification
- Complete template-aligned release review
