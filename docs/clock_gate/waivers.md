# Reviewed waivers

[Return to the module documentation index](README.md).

## Accepted waivers

ID: `CLOCK-GATE-RTL-001`

Tool and rule: Yosys intentional latch-inference warning.

Affected file and object: `rtl/clock_gate.sv`, signal
`clock_gate.enable_latched`.

Technical justification: Glitch-free clock gating requires the effective enable
to remain transparent only while `i_clk` is low and stable throughout the high
phase. The single inferred low-phase latch is the intended portable functional
model of an integrated clock-gating cell.

Evidence: Yosys reports exactly one `$_DLATCH_N_`, one `$_AND_`, and one `$_OR_`.
Formal verification and EQY equivalence pass, and simulation checks every gated
clock transition against an independent reference model.

Owner: Clock-gate module owner.

Reviewer: Erick Andres Obregon Fonseca.

Created: 2026-08-29.

Expires or removal condition: Remove when the portable implementation no longer
uses a latch model or when a technology binding replaces this source in every
qualified flow.

ID: `CLOCK-GATE-FORMAL-001`

Tool and rule: Yosys/SymbiYosys undriven-wire warning.

Affected file and object: `verif/formal/clock_gate_formal.sv`, signal
`clock_gate_formal.i_clk`.

Technical justification: `i_clk` uses the Yosys `(* gclk *)` attribute and is
intentionally advanced by the formal engine. A procedural clock generator would
change the formal transition model.

Evidence: SymbiYosys passes base-case and induction checks at depth 12.

Owner: Clock-gate module owner.

Reviewer: Erick Andres Obregon Fonseca.

Created: 2026-08-29.

Expires or removal condition: Revisit if the harness stops using the Yosys
global-clock model.

ID: `CLOCK-GATE-FORMAL-002`

Tool and rule: Yosys/SymbiYosys intentional latch-inference warnings.

Affected file and objects: `verif/formal/clock_gate_formal.sv`, signals
`expected_enable` and `reference_valid`.

Technical justification: The independent formal reference model intentionally
uses the same low-phase transparency contract as an ICG enable latch.
`reference_valid` suppresses comparison before the first legal low-phase capture.

Evidence: The reference model proves the DUT output relation by induction with
symbolic functional and test enables and no assumptions.

Owner: Clock-gate module owner.

Reviewer: Erick Andres Obregon Fonseca.

Created: 2026-08-29.

Expires or removal condition: Remove if the formal reference model no longer
uses low-phase latch semantics.
