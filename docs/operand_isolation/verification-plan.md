# Verification Plan

[Return to the module documentation index](README.md).

## Verification Objectives

The environment verifies transparent operation, clamped operation, input
independence while isolated, explicit X/Z control handling, parameter legality,
activity reduction, generic synthesis, and RTL-to-netlist equivalence.

## Verification Environments

| Environment | Top | Purpose |
| --- | --- | --- |
| Verilator simulation | `operand_isolation_tb` | Directed, per-bit, transition, randomized, integration, assertion, and coverage checks |
| Icarus qualification | Dedicated fixtures | Mutation, invalid-parameter, and X/Z detection campaigns |
| SymbiYosys | `operand_isolation_formal` | Complete combinational proof and formal cover reachability |
| EQY | `operand_isolation` | RTL-to-Yosys-netlist equivalence |
| Static frontends | `operand_isolation` | Style, formatting, elaboration, lint, and synthesizability |
| Static intent | Policy manifest | Matching SDC semantics and always-on UPF baseline |

## Requirements Traceability

| ID | Requirement | Simulation evidence | Assertion or formal evidence |
| --- | --- | --- | --- |
| `REQ-PASS-001` | `i_isolate=0` preserves `i_data` | Directed, one-hot, alternating, and deterministic sequences | Transparent equation assertion and formal proof |
| `REQ-CLAMP-001` | `i_isolate=1` drives `CLAMP_VALUE` | Every directed class and changing isolated inputs | Clamp equation assertion and formal proof |
| `REQ-INDEP-001` | Input changes cannot affect an isolated output | Long isolated activity intervals | Twin-input formal independence proof |
| `REQ-XCTL-001` | X/Z control is detected and propagates unknown output | Four-state qualification campaign | Unknown-control assertion |
| `REQ-PARAM-001` | Illegal width and unknown clamp are rejected | Negative elaboration fixtures | Static generate checks |
| `REQ-COMB-001` | No state affects the output | Back-to-back mode and data changes | Complete depth-one formal proof |
| `REQ-ACT-001` | Isolation reduces representative downstream activity | Three integration activity models | Not applicable |
| `REQ-SYN-001` | RTL synthesizes to combinational logic | Structural Yosys result | Yosys and lint gates |
| `REQ-EQY-001` | Generic netlist matches the RTL | Not applicable | EQY SAT strategy |

## Parameter Matrix

| Profile | Width | Clamp class | Portable evidence |
| --- | ---: | --- | --- |
| `width_1_zero` | 1 | Zero | Full flow plus negative and X/Z campaigns |
| `width_8_ones` | 8 | All one | Full portable flow |
| `width_16_pattern` | 16 | Nontrivial pattern | Full portable flow and representative coverage |
| `width_32_zero` | 32 | Zero | Full portable flow |
| `width_64_ones` | 64 | All one | Full portable flow |
| `width_128_pattern` | 128 | Nontrivial pattern | Full portable flow |
| `width_256_pattern` | 256 | Nontrivial pattern | Full portable flow |

## Simulation Plan

Each profile checks zero, all-one, alternating, one-hot, inverse one-hot, clamp,
and deterministic long sequences in both modes. The transition monitor covers
isolation assertion and deassertion with stable and changing data, input changes
within each mode, and back-to-back isolated samples.

The integration test drives arithmetic, vector, and address-generation models.
It verifies active functional equality and compares downstream transition counts
under continuing isolated input activity.

## Assertion and Formal Plan

Bound assertions check the transparent and clamped equations and reject an
unknown isolation control. The formal harness instantiates two copies with
independent operands to prove that their outputs are equal whenever isolation is
asserted. The proof has no assumptions and completes at combinational depth one.

Formal cover reuses the functional coverage wrapper to demonstrate reachability
of transparent, isolated, matching-clamp, and differing-clamp scenarios.

## Negative and Four-State Qualification

- A positive control proves the unit fixture can pass with nominal RTL.
- An inverted-control mutant must be detected by the same checker.
- `WIDTH=0` must fail elaboration.
- A clamp containing X or Z must fail elaboration.
- X and Z controls must reach the stimulus control when monitoring is disabled.
- The assertion monitor must fail for the same X and Z injections when enabled.

## Coverage Goals

- At least 95 percent scoped line coverage
- At least 80 percent scoped branch coverage
- At least 90 percent scoped toggle coverage
- 100 percent scoped user coverage
- Every named functional and integration coverpoint observed
- Formal cover reachability passes

The reviewed line exclusion covers only the RTL default arm that propagates an
X/Z isolation control. Verilator cannot execute that arm in binary simulation,
so dedicated Icarus four-state campaigns provide its positive and negative
evidence. Any additional exclusion must identify an exact source counter,
technical reason, owner, and removal condition.

## Exit Criteria

- [ ] Every traced requirement has passing evidence.
- [ ] Every declared parameter profile passes its required flows.
- [ ] Mutation, invalid-parameter, and X/Z campaigns pass.
- [ ] Assertions and formal proofs pass without unreviewed assumptions.
- [ ] RTL-to-netlist equivalence passes.
- [ ] Coverage goals are met or deviations are approved.
- [ ] Static-intent validation passes.
- [ ] All waivers are recorded in [Reviewed waivers](waivers.md).
- [ ] The [release checklist](release-checklist.md) is complete.
