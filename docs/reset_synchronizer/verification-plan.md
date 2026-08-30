# Verification plan

[Return to the repository README](../../README.md).

## Objectives

Verification establishes immediate assertion, exact synchronous release,
stopped-clock behavior, reassertion priority, stage ordering, supported depth,
structural preservation, and synthesis equivalence.

## Environments

| Environment | Top | Purpose |
|---|---|---|
| Verilator simulation | `reset_synchronizer_tb` | Directed and randomized regression at depths 2, 3, and 4 |
| Bound SVA | `reset_synchronizer_sva` | Interface and internal-chain invariants |
| Assertion coverage | `reset_synchronizer_tb` | Antecedent and RTL coverage evidence |
| SymbiYosys | `reset_synchronizer_formal` | Parameterized digital safety proof |
| EQY | `reset_synchronizer` | RTL-to-Yosys-netlist equivalence |
| Mutation campaign | `reset_synchronizer_tb` | Detection of four incorrect implementations and one bad netlist |
| Icarus four-state simulation | `reset_synchronizer_four_state_tb` | Detection of an unknown `i_async_rstb` value |
| Constraint intent | SDC | Clock, output, and exception-policy validation |

## Traceability

| ID | Requirement | Evidence |
|---|---|---|
| `RS-RST-001` | Assertion does not require a clock | Mid-phase and stopped-clock tests, asynchronous SVA |
| `RS-REL-001` | Release takes exactly `STAGES` rising edges | Depth-2, depth-3, and depth-4 checkers |
| `RS-REL-002` | Release occurs only through the final stage | Bound output and no-stage-skip assertions |
| `RS-CLK-001` | A stopped clock holds release pending | Stop/restart regression |
| `RS-PRI-001` | Reassertion clears every intermediate state | Per-stage reassertion loop and asynchronous SVA |
| `RS-STR-001` | Stages use asynchronous-reset flip-flops with no logic between them | RTL attributes, Yosys report, formal proof |
| `RS-EQY-001` | Synthesis preserves interface behavior | EQY proof |
| `RS-NEG-001` | Verification detects unsafe implementations | Four mutations and inequivalent candidate netlist |
| `RS-NEG-002` | Unknown reset input is rejected | Four-state detection run and disabled-monitor control run |

## Parameter matrix

| `STAGES` | Simulation | Assertions | Formal |
|---:|---|---|---|
| `2` | Required | Required | Required |
| `3` | Required | Required | Required |
| `4` | Required | Required | Required |

The portable release supports every value greater than or equal to two. Depths
2, 3, and 4 provide representative minimum, odd, and extended-chain evidence.

## Coverage and negative qualification

Coverage requires positive hits for asserted reset, release in progress,
completed release, and reassertion during release at every simulated depth. The
open-source campaign also requires complete executable RTL line and toggle
coverage.

Fault injection must detect synchronous-only assertion, premature output
release, skipped synchronization stages, incomplete asynchronous clear, and an
incorrect candidate netlist.

`make MODULE=reset_synchronizer four-state-check` uses Icarus to inject `X` on
`i_async_rstb`. The monitored run must fail with `UNKNOWN_RESET_DETECTED`. A
control build with only that monitor disabled must reach
`UNKNOWN_RESET_ESCAPED`, proving that the unknown value and detection path are
both exercised.

## Exit criteria

- Portable lint, formatting, elaboration, synthesis, simulation, formal, and
  equivalence flows pass.
- Depths 2, 3, and 4 pass exact-latency and reassertion tests.
- Required assertion and RTL coverage passes.
- Constraint intent and every mutation test passes.
- Four-state simulation detects an unknown reset input.
- A qualified CDC/RDC engine recognizes the chain at the first integration
  level containing its source, destination domain, and reset consumers.
- MOSAIC/SoC DFT analysis demonstrates reset and clock controllability.
- VC LP passes when the synchronizer participates in switchable or multi-voltage
  integration.
- Physical implementation preserves stage order, fanout, and placement.
- Every exception is recorded in [waivers.md](waivers.md).
