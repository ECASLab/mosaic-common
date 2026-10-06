# Verification plan

[Return to the module documentation index](README.md).

## Objectives

Verification establishes bitwise non-inverting behavior, both static directions,
parameter boundaries, bus ordering, four-state propagation, absence of state, and
portable constraint intent.

## Initial evidence

| Environment | Configurations | Purpose |
|---|---|---|
| Verilator simulation | Widths `1,2,4,8,16,32,64`, both directions | Directed, exhaustive small-width, and randomized wide-data checking |
| Bound assertions | All simulated configurations | Equality and assertion-antecedent coverage |
| SymbiYosys | Widths `1,4,16,64`, both directions | Complete combinational proof |
| EQY | Default width and direction | RTL-to-Yosys-netlist equivalence |
| Icarus four-state simulation | Width `4`, both directions | Exact `X` and `Z` propagation |
| Executable constraint check | Portable combinational profile | Interface budget and absence of broad exceptions |
| Executable power-intent check | Always-on two-domain UPF profile | Domains, supplies, states, port associations, insertion rule, and exclusions |
| Fault injection | All portable configurations and default netlist | Four functional mutations, two illegal parameter values, and one inequivalent candidate |

## Integration evidence

The portable campaign cannot prove electrical translation. Integration must add
power-aware simulation, VC LP or equivalent structural checks, characterized
multi-voltage timing, representative power analysis, insertion coverage, supply
connectivity, and physical verification for every shifted bit.
