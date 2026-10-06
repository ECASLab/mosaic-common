# Project Configuration

[Return to the module documentation index](README.md).

The module is registered as `mux` in `config/modules.json`. Its tops, filelists,
flow inputs, and output paths are defined by `config/modules/mux.mk`. Required
and disabled adapters are defined by `config/modules/mux-flows.mk`.

## Portable Release Policy

The standalone leaf requires:

- Verible lint and formatting
- Slang elaboration
- Verilator lint and self-checking simulation
- Yosys generic synthesis
- SymbiYosys proof and cover reachability
- EQY RTL-to-netlist equivalence
- Negative and four-state qualification campaigns
- Portable SDC and UPF static-intent validation
- Representative code, toggle, user, and formal coverage qualification

The six supported elaborations are declared in
`config/parameter-profiles/mux.json`. The representative coverage profile is
`inputs_3_width_16`.

## Integration-Owned Checks

Standalone policy disables VC Lint, CDC, SpyGlass DFT, VC LP, Design Compiler,
PrimeTime, PrimePower, and OpenROAD. The leaf has no state, clock, reset, scan
element, internal domain crossing, or independent physical boundary.

Those checks remain required where the consuming design selects libraries,
operating corners, source and destination domains, test intent, power states,
loads, placement, routing, and representative activity. A disabled adapter is
a reviewed `SKIP`, never a `PASS`.

## Evidence Paths

```text
reports/mux/<profile>/
work/mux/<profile>/
```

Use `make MODULE=mux PROFILE=<profile> flow-config-check` before interpreting
results. Release manifests must identify the module revision, pinned
`mosaic-flow` revision, selected parameters, tools, constraints, and evidence.
