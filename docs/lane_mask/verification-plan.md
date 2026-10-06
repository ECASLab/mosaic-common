# Verification plan

[Return to the module documentation index](README.md).

## Objectives

Verification establishes the canonical activity equation, exact derived masks,
lane independence, invalid-operation behavior, parameter support, and absence of
state.

## Qualified environments

| Environment | Configurations | Purpose |
|---|---|---|
| Verilator simulation | `LANES=1,2,4,8,16` | Directed, tail-mask, one-hot, and randomized checks |
| Bound assertions | `LANES=1,2,4,8,16` | Output equations and known-control policy |
| SymbiYosys | `LANES=1,2,4,8,16` | Complete combinational proof |
| EQY | Default `LANES=4` | RTL-to-Yosys-netlist equivalence |
| Verilator coverage | `LANES=1,2,4,8,16` | Assertion antecedents, RTL lines, and toggles |
| Mutation campaign | `LANES=1,2,4,8,16` | Six functional mutations and one inequivalent candidate |
| Icarus four-state simulation | Default `LANES=4` | Unknown global and per-lane control detection |
| Tcl constraint model | Default `LANES=4` | Complete combinational interface timing intent |

## Portable release goals

- Every named assertion antecedent has a positive hit in all five simulated
  configurations.
- Every non-excluded executable RTL line and toggle record is covered.
- All six functional mutations fail the production environment.
- EQY rejects a candidate implementation that omits the architectural mask.
- Every illegal unknown-control class is detected, while the disabled-monitor
  negative control demonstrates that the stimulus can otherwise escape.
- The SDC covers every input-to-output path and contains no clock or broad
  timing exception.

All portable goals pass. Technology mapping, physical implementation, and
system-level CDC, DFT, low-power, timing, and power signoff belong to the
consuming integration.
