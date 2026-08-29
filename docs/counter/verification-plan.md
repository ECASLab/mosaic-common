# Verification plan

[Return to the module documentation index](README.md).

This plan maps the public [interface specification](interface.md) to unit-level
counter evidence.

## Verification objectives

The counter verification environment checks:

- Synchronous and asynchronous reset
- Clear, load, enable, hold, and command priority
- Increment and decrement behavior
- Saturating and wrapping boundary transitions
- One-cycle overflow and underflow events
- Direction-aware terminal indication
- Minimum, representative, wide, and nonzero-reset configurations
- Generic synthesis and RTL-to-netlist equivalence

## Verification environments

| Environment | Top | Purpose |
| --- | --- | --- |
| Verilator simulation | `counter_tb` | Directed and randomized parameter-matrix regression with bound SVA |
| SymbiYosys | `counter_formal` | Exhaustive transition and terminal proofs |
| EQY | `counter` | Grouped RTL-to-Yosys-netlist equivalence |
| Static frontends | `counter` | Style, formatting, compile, hierarchy, lint, and synthesizability checks |
| Yosys synthesis | `counter` | Generic structure and arithmetic inference |

VCS and commercial static, synthesis, timing, and power environments are disabled
for the current technology-independent release scope.

## Requirements traceability

| ID | Requirement | Simulation | Assertion or formal evidence |
| --- | --- | --- | --- |
| `CTR-RST-001` | Reset loads `RESET_VALUE` and clears events | Clocked and mid-cycle reset sequences | `reset_wins` and async reset assertion |
| `CTR-CLR-001` | Clear has command priority | Clear plus load plus enable test | `clear_wins` and formal transition model |
| `CTR-LOAD-001` | Load has priority over enable | Load plus enable test | `load_wins` and formal transition model |
| `CTR-INC-001` | Increment advances below maximum | Directed and randomized tests | `increment_updates` and formal proof |
| `CTR-DEC-001` | Decrement advances above zero | Directed and randomized tests | `decrement_updates` and formal proof |
| `CTR-SAT-001` | Saturating mode holds at boundaries | Saturating boundary tests | Boundary properties and formal proof |
| `CTR-WRAP-001` | Wrapping mode moves to opposite boundary | Wrapping boundary tests | Boundary properties and formal proof |
| `CTR-EVT-001` | Events pulse once and remain exclusive | Boundary attempt followed by hold | Event assertions and formal exclusivity |
| `CTR-HOLD-001` | Inactive cycles preserve count | Directed and randomized holds | `hold_preserves_count` |
| `CTR-TERM-001` | Terminal matches count and direction | Scoreboard check every cycle | `terminal_matches_direction` and combinational proof |
| `CTR-SYN-001` | RTL synthesizes without structural errors | Not applicable | Yosys synthesis report |
| `CTR-EQY-001` | Generic netlist preserves RTL behavior | Not applicable | EQY grouped SAT proof |

## Simulation plan

Every checker uses an independent reference model and performs:

1. Reset assertion and edge-based reset checking.
2. Clear, load, and enable priority conflicts.
3. Increment to maximum and an overflow attempt.
4. Decrement to zero and an underflow attempt.
5. Event clearing on the following hold cycle.
6. Ninety-six randomized command cycles with randomized load data.
7. Mid-cycle reset assertion to distinguish reset styles.

The regression runs all configurations concurrently and has a deterministic
timeout. Random seeds are not yet captured as release metadata.

## Assertion plan

Assertions are bound through `verif/assertions/counter_bind.sv` and compiled in
the simulation filelist. They cover known controls, priority, arithmetic,
boundary behavior, event exclusivity, hold, terminal indication, and immediate
asynchronous reset assertion.

Cover properties exist for clear, load, increment, decrement, hold, overflow,
and underflow. A quantified assertion-antecedent campaign is still required to
turn these coverpoints into release evidence.

## Formal plan

The formal harness leaves reset, commands, direction, and load data symbolic and
contains no assumptions. It instantiates synchronous and asynchronous variants
of both saturating and wrapping counters at `WIDTH=3`. Twelve proof steps cover
the complete state space and pass by induction.

The intentionally undriven `(* gclk *)` formal clock is reviewed under
`COUNTER-FORMAL-001`. Counterexamples are retained by SymbiYosys on failures.

## Equivalence plan

EQY compares `rtl/counter.sv` with
`work/counter/yosys_synthesis/counter_netlist.v`. Yosys synthesis must record
`PASS` first. Count, event, and terminal outputs are grouped so the count
feedback is not abstracted as an unrelated partition input. A depth-12 SAT
strategy proves the grouped sequential partition.

## Coverage plan

| Coverage type | Required content | Current status |
| --- | --- | --- |
| Requirements | Every interface requirement has mapped evidence | Mapped |
| Functional | Commands, priorities, directions, boundaries, modes, and crosses | Not quantified |
| Assertions | Antecedent attempts and vacuity review | Not quantified |
| Code | Executable line, branch, expression, and toggle goals | Not collected |
| Formal | Proven properties and reachable cover goals | Proof passes, cover report pending |

Release targets and approved exclusions remain to be defined. Until then,
functional and code coverage closure is open.

## Parameter and configuration matrix

| Configuration | Simulation | Formal | Synthesis | Equivalence | Status |
| --- | --- | --- | --- | --- | --- |
| `WIDTH=1`, saturating, synchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=1`, wrapping, synchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=4`, wrapping, synchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=8`, saturating, synchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=16`, nonzero reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=32`, saturating, asynchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=32`, wrapping, asynchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| `WIDTH=64`, saturating, synchronous reset | Required | Covered structurally | Not separate | Not separate | Pass |
| Default parameters | Required | Required modes | Required | Required | Pass |

Formal uses `WIDTH=3` to exhaustively explore every state. Synthesis and
equivalence currently qualify the default parameterization.

## Negative testing

The release fault-injection campaign must demonstrate detection of:

- Incorrect clear or load priority
- Reversed direction encoding
- Saturating behavior that wraps
- Wrapping behavior that saturates
- Missing or persistent overflow and underflow events
- Incorrect terminal direction
- Reset-value corruption
- RTL and synthesized-netlist mismatch

No retained mutation campaign exists yet, so negative-testing closure remains
open.

## Exit criteria

- [x] Every interface requirement has mapped evidence.
- [x] The current supported configuration matrix completes its required runs.
- [x] Enabled portable flows record `PASS`.
- [x] Disabled flows have a documented policy reason.
- [x] Simulation regressions pass with a deterministic timeout.
- [ ] Assertions have meaningful activation demonstrated by a coverage report.
- [x] Formal properties pass by induction without assumptions.
- [x] Equivalence passes for the required synthesis configuration.
- [ ] Coverage goals are met and exclusions are approved.
- [ ] Negative testing detects the required mutations.
- [x] All current waivers are recorded in [Reviewed waivers](waivers.md).
- [ ] The release checklist is complete.
