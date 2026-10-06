# Power Characterization

[Return to the module documentation index](README.md).

## Standalone Scope

The mux has no clock or sequential state, so clock gating, retention, and
state-save energy do not apply. Portable verification proves only functional
selection behavior and switching coverage. It does not claim a technology-
specific power result.

## Relevant Activity

Dynamic power depends on:

- Toggle rates and correlation of every `i_data` word
- Selection transition rate and transition distance
- Input count and data width
- Logic structure chosen by synthesis
- Fanout and physical routing of `o_data` and `o_select_valid`
- Glitch propagation from data and selection paths

Unselected input changes do not change the functional output, but they may
still toggle upstream logic and internal implementation nodes. Operand
isolation is an integration technique and is intentionally not embedded here.

## Required Integration Evidence

Before a consumer claims an energy benefit, it must use mapped libraries and
representative annotated activity to review:

- Dynamic and leakage power
- SAIF hierarchy and annotation coverage
- Data-to-output and selection-to-output delay
- Area and logic depth
- Glitch activity after implementation
- Isolation and level-shifting for actual voltage-domain crossings

PrimePower or an equivalent signoff flow belongs to the consuming physical
implementation because the standalone leaf has no selected PDK, corner,
placement, routing, or workload activity model.
