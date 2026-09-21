# Project configuration

[Return to the module documentation index](README.md).

## Registered tops

| Purpose | Top |
| --- | --- |
| RTL | `decoder` |
| Simulation | `decoder_tb` |
| Formal | `decoder_formal` |

The module is registered in `config/modules.json`. Module-owned variables and
flow policy live in `config/modules/decoder.mk` and
`config/modules/decoder-flows.mk`.

## Source composition

Properties, assertions, and coverage use separate filelists. The simulation
and formal adapters compose those reusable sources according to their selected
flow without embedding them in the RTL filelist.

## Flow policy

Portable lint, formatting, elaboration, Yosys synthesis, SymbiYosys proof, EQY,
Verilator simulation, qualification campaigns, and static-intent validation are
required.

OpenROAD and commercial adapters are disabled for the standalone leaf. CDC,
DFT, low-power signoff, technology-mapped timing, activity-based power, and
physical implementation are transferred to the first consuming design that
provides real domains, libraries, loads, activity, and placement context.

## Generated output isolation

All generated reports and work databases are profile-scoped under:

```text
reports/decoder/<profile>/
work/decoder/<profile>/
```

This permits concurrent execution of decoder profiles and other modules.
