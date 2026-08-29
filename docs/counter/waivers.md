# Reviewed waivers

[Return to the module documentation index](README.md).

Each waiver must contain the tool, rule, affected object, technical justification,
owner, reviewer, creation date and expiration or removal condition.

## Verilator waiver procedure

Open-source lint waivers are stored in `flows/verilator_lint/waivers.vlt`. Scope every
waiver to a specific warning rule and, whenever possible, a file plus a line range
or message match. Repository-wide rule suppression is not accepted.

Generate candidate entries with:

```sh
make MODULE=counter open-waiver-draft
```

This creates `reports/counter/verilator_lint/suggested_waivers.vlt`. A generated
waiver is only a starting point. Review the warning, attempt to correct the RTL,
and copy an entry into the committed waiver file only when the behavior is
intentional.

Record each accepted waiver below using this format:

```text
ID:
Tool and rule:
Affected file and object:
Technical justification:
Evidence:
Owner:
Reviewer:
Created:
Expires or removal condition:
```

## Accepted waivers

ID: `COUNTER-FORMAL-001`

Tool and rule: Yosys/SymbiYosys undriven-wire warning.

Affected file and object: `verif/formal/counter_formal.sv`, signal
`counter_formal.i_clk`.

Technical justification: `i_clk` uses the Yosys `(* gclk *)` attribute and is
intentionally left without an RTL driver. The formal engine advances the global
clock while proving the counter transition system. Procedural clock generation
would change the formal clock model and is not part of the synthesizable counter.

Evidence: `make MODULE=counter clean open-source` passes. SymbiYosys proves all
four reset-style and arithmetic-mode combinations by induction. Slang, Verible,
Verilator, and Yosys report no corresponding warning in synthesizable RTL.

Owner: Counter module owner.

Reviewer: Erick Andres Obregon Fonseca.

Created: 2026-08-28.

Expires or removal condition: Revisit if the harness stops using the Yosys
global-clock model, if the warning appears on another object, or if the selected
formal tool release provides an equivalent driven-clock model.
