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
| Constraint intent | Committed SDC profiles | Clock, uncertainty, interface delay, reset timing, and OpenROAD SDC checks |

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
| `CTR-SDC-001` | Timing profiles constrain the clock and every interface without hiding reset timing | Not applicable | Static constraint-intent campaign |

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

Cover properties exist for reset, clear, load, both priority conflicts,
increment, decrement, hold, overflow, and underflow. The assertion-coverage
campaign requires a positive hit for all ten coverpoints in every one of the
eight simulation configurations.

## Formal plan

The formal harness leaves reset, commands, direction, and load data symbolic and
contains no assumptions. It instantiates synchronous and asynchronous variants
of both saturating and wrapping counters at `WIDTH=3`. Twelve proof steps cover
the complete state space and pass by induction.

The intentionally undriven `(* gclk *)` formal clock is reviewed under
`COUNTER-FORMAL-001`. Counterexamples are retained by SymbiYosys on failures.
The assertion-coverage campaign also runs `counter.cover.sby` and requires both
formal boundary-event cover statements to be reached within 12 steps.

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
| Functional | Commands, priorities, directions, boundaries, modes, and crosses | Ten coverpoints hit in all eight configurations |
| Assertions | Antecedent attempts and vacuity review | All required antecedents have positive hits |
| Code | Executable line and Verilator branch/toggle records | Adjusted 100% for release RTL |
| Formal | Proven properties and reachable cover goals | Proof passes and both covers are reached |

`make MODULE=counter assertion-coverage` requires `62/62` executable RTL lines
and `1072/1072` Verilator branch/toggle records after approved exclusions. The
excluded RTL lines are the four-state-only default direction branch at line 35
and the static `SATURATE` alternatives at lines 57, 64, 89, and 96. A two-state
simulation cannot exercise an unknown direction, and each elaborated instance
can select only one value of a static parameter. All nonexcluded release RTL and
all required functional coverpoints must be hit. Verification-source coverage
is retained for diagnosis but is not a release threshold.

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

## Constraint intent plan

`make MODULE=counter constraint-check` executes the synchronous, asynchronous,
and OpenROAD-selected SDC profiles against a Tcl command model. The campaign
requires a 10 ns `i_clk`, 0.1 ns clock uncertainty, 0.5 ns input delay on every
input except the clock, and 0.5 ns output delay on every output. It rejects
duplicate definitions and any blanket false path that could hide asynchronous
reset recovery or removal timing. The selected profile names must also follow
the module-first file-resolution policy.

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

`make MODULE=counter fault-injection` substitutes eight verification-only RTL
mutants into the production simulation environment. The campaign requires the
existing checker or assertions to detect incorrect clear and load priority,
reversed direction encoding, incorrect saturating and wrapping boundaries,
missing boundary events, incorrect terminal direction, and reset-value
corruption. A ninth test requires EQY to reject a deliberately incorrect
candidate netlist. Per-mutation logs and `PASS` status files are retained under
`reports/counter/fault_injection/`.

## Exit criteria

- [x] Every interface requirement has mapped evidence.
- [x] The current supported configuration matrix completes its required runs.
- [x] Enabled portable flows record `PASS`.
- [x] Disabled flows have a documented policy reason.
- [x] Simulation regressions pass with a deterministic timeout.
- [x] Assertions have meaningful activation demonstrated by a coverage report.
- [x] Formal properties pass by induction without assumptions.
- [x] Equivalence passes for the required synthesis configuration.
- [x] Synchronous, asynchronous, and OpenROAD constraint intent checks pass.
- [x] Coverage goals are met and exclusions are approved.
- [x] Negative testing detects the required mutations.
- [x] All current waivers are recorded in [Reviewed waivers](waivers.md).
- [x] The release checklist is complete.
