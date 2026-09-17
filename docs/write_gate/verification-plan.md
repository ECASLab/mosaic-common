# Verification Plan

[Return to the module documentation index](README.md).

| Requirement | Evidence |
| --- | --- |
| Unsuppressed requested writes propagate | Directed truth table, lane tests, random simulation, assertions, and complete formal proof |
| Suppressed requested writes are blocked and observed | Directed intervals, register and memory destination models, assertions, and formal proof |
| Outputs partition every known request | Unit checks, bound assertion, formal proof, native coverpoint, and formal cover |
| Lanes operate independently | One-hot, alternating, mixed, and random vectors across all qualified widths |
| Unknown controls are detected | Icarus X/Z campaign for request and requested suppression controls |
| Invalid width is rejected | Icarus elaboration-negative campaign for `WIDTH=0` |
| A suppression preserves destination state | Gated register and memory models compared with ungated references under an explicit redundant-write contract |
| Integration suppression is architecturally legal | Simulation checks and formal assumptions require suppressed data to equal the prior destination state |
| Gated and ungated next state are equivalent | Complete formal proof for unconstrained state, data, request, and timing-safe suppression controls |
| Destination write activity is reduced | Register and memory write-event counters compare the ungated baseline with the gated destination |
| RTL remains combinational | Verilator lint, Yosys synthesis, formal proof, and EQY equivalence |

The unit regression exhausts all scalar truth-table classes through all-zero and
all-one vectors, every source-to-destination control transition, every lane,
alternating patterns, long idle and suppressed periods, and back-to-back random
traffic. The integration regression uses both a clocked register bank and a
four-word byte or lane writable memory. Each gated destination is compared with
an ungated reference that receives every original write.

The leaf formal proof has unconstrained symbolic controls and no assumptions.
The integration proof assumes only that a suppressed requested bit writes the
value already held by the destination, then proves gated and ungated next-state
equivalence. Both proofs are complete at depth one. Formal cover establishes
reachability of all truth states, all-bit decisions, zero, partial, and complete
suppression ratios, partitioning, and mixed decisions when `WIDTH > 1`.

The width-two qualification enforces 100 percent line coverage, 100 percent
branch coverage, at least 90 percent toggle coverage, 100 percent user coverage,
32 named functional coverpoints, and a passing formal cover run. Named points
cover every truth state, all-bit permit and suppression, suppression ratios,
all 16 scalar control transitions, destination type, redundant-value reason,
and accepted or idle protocol decisions. Widths one and 128 provide the minimum
and maximum width evidence in the profile matrix.
