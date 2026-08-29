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
make open-waiver-draft
```

This creates `reports/dff/verilator_lint/suggested_waivers.vlt`. A generated waiver is
only a starting point. Review the warning, attempt to correct the RTL, and copy an
entry into the committed waiver file only when the behavior is intentional.

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

ID: `DFF-FORMAL-001`

Tool and rule: Yosys/SymbiYosys undriven-wire warning.

Affected file and object: `verif/formal/dff_formal.sv`, signal
`dff_formal.i_clk`.

Technical justification: `i_clk` is marked with the Yosys `(* gclk *)`
attribute and is intentionally left without an RTL driver. The formal engine
advances this global clock while proving the DFF properties. Adding procedural
clock-generation logic would change the formal clock model and is not required
by the synthesizable `dff` design.

Evidence: `make MODULE=dff clean open-source` completes successfully. The
SymbiYosys proof passes by k-induction, and RTL-to-Yosys-netlist equivalence
also passes. Slang elaboration and the RTL lint flows report no corresponding
warning in the synthesizable design.

Owner: DFF module owner.

Reviewer: Erick Andres Obregon Fonseca.

Created: 2026-08-25.

Expires or removal condition: Revisit if the formal harness stops using the
Yosys global-clock model, if the warning appears on another signal or design
object, or if the selected Yosys/SymbiYosys release provides a driven-clock
model that preserves equivalent proof semantics.
