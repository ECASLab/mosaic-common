# Verification plan

[Return to the module documentation index](README.md).

## Objectives

Verification establishes exact binary-to-one-hot mapping, validity reporting,
disabled activity suppression, invalid-code rejection, deterministic X/Z
behavior, non-power-of-two support, derived parameter enforcement, and absence
of retained state.

## Requirements traceability

| ID | Requirement | Evidence |
| --- | --- | --- |
| `REQ-DEC-001` | Every enabled legal selection activates exactly its corresponding bit | Exhaustive simulation, bound assertions, formal proof |
| `REQ-DEC-002` | Disabled operation produces zero and is invalid | Exhaustive simulation, assertions, formal proof |
| `REQ-DEC-003` | Out-of-range encodings produce zero and are invalid | Exhaustive non-power-of-two profiles, assertions, formal proof |
| `REQ-DEC-004` | Output is always one-hot or zero | Assertion and exhaustive formal proof |
| `REQ-DEC-005` | Unknown enable or selection fails closed and is detected | Icarus X/Z qualification campaign |
| `REQ-DEC-006` | `NUM_OUTPUTS=1` and non-power-of-two counts work | Profiles 1, 3, and 5 plus formal proof |
| `REQ-DEC-007` | Invalid parameter values fail elaboration | Negative qualification campaign |
| `REQ-DEC-008` | Synthesized logic preserves RTL behavior | Yosys synthesis and EQY |
| `REQ-DEC-009` | The leaf has no state, clock, reset, or broad timing exception | Static intent validation |

## Parameter matrix

| Profile | `NUM_OUTPUTS` | Purpose |
| --- | ---: | --- |
| `outputs_1` | 1 | Minimum configuration and one-bit derived select width |
| `outputs_2` | 2 | Small power-of-two decode |
| `outputs_3` | 3 | Small non-power-of-two decode with one invalid encoding |
| `outputs_4` | 4 | Directional-port use case |
| `outputs_5` | 5 | Extended non-power-of-two decode |
| `outputs_8` | 8 | Register or bank selection |
| `outputs_16` | 16 | Context selection |
| `outputs_32` | 32 | Large flat decode |

Each profile runs lint, formatting, elaboration, generic synthesis, formal
proof, equivalence, simulation, and static-intent checks. The minimum profile
also owns parameter-negative and four-state campaigns because those campaigns
compile dedicated fixtures independently from the selected profile.

## Simulation plan

For each profile, the self-checking test exhausts every binary selection with
enable low and high. It then exercises every ordered pair of legal selections
and a deterministic randomized sequence with simultaneous control changes.

The checks cover every legal selection and every invalid encoding. Power-of-two
profiles have no invalid binary encoding, so that requirement is vacuous there.

## Assertion and coverage plan

Assertions are bound to every `decoder` instance and check:

- Exact output and validity equations
- One-hot-or-zero output encoding
- Zero output for disabled or invalid operation
- Fail-closed behavior for unknown controls
- Detection of unknown controls in four-state simulation

Functional cover statements observe disabled operation, legal operation, first
and last selections, invalid selections where representable, and activation of
each generated output. Code and user coverage use the module-owned policy.

## Formal plan

The harness leaves enable and selection unconstrained. A depth-one complete
combinational proof establishes output encoding, legal selection behavior,
invalid selection handling, and absence of state without assumptions.

Formal cover mode checks reachability of the reusable coverage model. An
invalid-selection cover is unreachable by construction for power-of-two output
counts and is reviewed as a vacuous configuration-specific goal.

## Negative and four-state qualification

The negative campaign proves that the self-checking test rejects an
enable-inverted mutant. It also confirms that zero outputs and an inconsistent
`SELECT_WIDTH` fail elaboration with module-specific diagnostics.

Pinned Icarus campaigns inject X and Z independently into `i_enable` and
`i_select`. Each disabled-monitor control proves that the RTL produces zero.
The paired monitor case proves that verification detects the unknown control.

## Exit criteria

- [x] All eight profiles pass their declared portable flow matrix.
- [x] Negative and four-state campaigns pass.
- [x] Assertions execute without unexpected failures.
- [x] Formal proof and RTL-to-netlist equivalence pass.
- [x] Coverage goals are met or narrowly reviewed.
- [x] Static timing and power intent validation passes.
- [x] The release checklist is complete under reviewed exception `DEC-CI-001`.
