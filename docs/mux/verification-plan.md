# Verification Plan

[Return to the module documentation index](README.md).

## Objectives

Verification establishes exact input selection, validity reporting,
deterministic invalid behavior, deterministic X/Z handling, non-power-of-two
support, parameter enforcement, and absence of retained state.

## Requirements Traceability

| ID | Requirement | Evidence |
| --- | --- | --- |
| `REQ-MUX-001` | Every legal selection forwards exactly the corresponding input | Exhaustive simulation, bound assertions, formal proof |
| `REQ-MUX-002` | Every invalid binary encoding returns `DEFAULT_VALUE` and invalid status | Non-power-of-two profiles, assertions, formal proof |
| `REQ-MUX-003` | Unknown or high-impedance selection fails closed and is detected | Icarus X/Z qualification campaign |
| `REQ-MUX-004` | Changes to selected data propagate | Directed and randomized simulation, assertions |
| `REQ-MUX-005` | Changes only to unselected data preserve the functional output | Directed transition test, exact output assertion |
| `REQ-MUX-006` | Minimum, wide, power-of-two, and non-power-of-two configurations work | Six parameter profiles |
| `REQ-MUX-007` | Illegal structural parameters fail elaboration | Negative qualification campaign |
| `REQ-MUX-008` | Synthesized logic preserves RTL behavior | Yosys synthesis and EQY |
| `REQ-MUX-009` | The leaf has no state, clock, reset, or broad timing exception | Static intent validation |

## Parameter Matrix

| Profile | `NUM_INPUTS` | `DATA_WIDTH` | Purpose |
| --- | ---: | ---: | --- |
| `inputs_1_width_1` | 1 | 1 | Minimum boundary and invalid selection one |
| `inputs_2_width_8` | 2 | 8 | Small power-of-two selector |
| `inputs_3_width_16` | 3 | 16 | Representative non-power-of-two coverage profile |
| `inputs_4_width_32` | 4 | 32 | Scalar datapath selector |
| `inputs_5_width_64` | 5 | 64 | Wider non-power-of-two selector |
| `inputs_8_width_128` | 8 | 128 | Vector datapath selector |

Each profile uses a declared `DEFAULT_VALUE` and runs formatting, lint,
elaboration, generic synthesis, formal proof, equivalence, simulation, and
static-intent checks. The minimum profile also owns parameter-negative and
four-state qualification campaigns.

## Simulation Plan

For each profile, the self-checking test exhausts every selection encoding with
zero, one, and distinct input words. It exercises every ordered pair of legal
selections, selected-data changes, unselected-data changes, both invalid-region
boundaries when present, and deterministic randomized data and selection.

The `NUM_INPUTS=1` profile proves that the derived selection width never becomes
zero. Non-power-of-two profiles prove that unused binary encodings do not wrap
or select an unintended input.

## Assertion and Coverage Plan

Assertions are bound to every `mux` instance and check the exact output and
validity equations. They also prove fail-closed output behavior for an unknown
selection and report unknown controls in four-state simulation.

Coverage observes every legal input selection, first and last inputs, invalid
encodings, zero and all-one selected words, distinct input words, every ordered
legal transition, selected and unselected data changes, and legal-invalid
boundary transitions. Cumulative completion bins require all binary selection
encodings and all ordered legal selection pairs to occur. The representative
three-input profile qualifies code, toggle, user, and formal cover evidence.

## Formal Plan

The harness leaves every data bit and the selection unconstrained. A depth-one
complete combinational proof establishes exact selection and default behavior
without assumptions. Formal cover proves reachability of legal, boundary,
pattern, distinct-data, and invalid-selection scenarios.

Selection-set and transition-matrix completion are sampled in simulation because
they require history. The formal model independently proves exact behavior for
every unconstrained data and selection value.

## Negative and Four-State Qualification

The negative campaign proves that the self-checking test rejects a mutant that
never asserts `o_select_valid`. It also confirms that zero input count, zero
data width, inconsistent `SEL_WIDTH`, and unknown `DEFAULT_VALUE` fail
elaboration with module-specific diagnostics.

Pinned Icarus campaigns inject X and Z into `i_select`. Disabled-monitor cases
prove the RTL returns the configured default. Paired monitor cases prove the
verification layer detects the unknown selection.

## Exit Criteria

- [x] All six profiles pass their declared portable flow matrix.
- [x] Negative and four-state campaigns pass.
- [x] Assertions execute without unexpected failures.
- [x] Formal proof and RTL-to-netlist equivalence pass.
- [x] Coverage goals are met or narrowly reviewed.
- [x] Static timing and power intent validation passes.
- [ ] The release checklist is complete.
