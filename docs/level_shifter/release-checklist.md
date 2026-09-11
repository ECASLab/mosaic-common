# Release checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and all design-owned tops use `level_shifter` within
  `mosaic-common`._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1` and both static `DIRECTION` values are documented. Widths 1, 2,
  4, 8, 16, 32, and 64 are simulated in both directions._
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _Eight portable flows are enabled. Technology and commercial flows remain
  disabled pending characterized multi-voltage integration._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The wrapper is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Architectural latency is zero cycles. Handshake, backpressure, and runtime
  error reporting are outside this primitive._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _Powered behavior, unavailable-domain behavior, isolation ownership, and the
  distinction between RTL and electrical translation are documented._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _Source and destination domains, static direction, one-cell-per-bit mapping,
  CDC, isolation, supply, skew, and power-state responsibilities are recorded._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
  _Yosys correctly reduces the technology-independent identity model to a
  zero-cell connection. This is not evidence of physical voltage translation._
- [x] No unresolved warning is hidden outside the reviewed waiver files.

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
  _Portable requirements are mapped to simulation, assertions, formal,
  equivalence, four-state simulation, coverage, or constraint checks. The plan
  separately identifies mandatory integration evidence._
- [x] All supported parameter configurations have evidence.
  _Both directions and representative widths from 1 through 64 are exercised.
  Every legal positive integer width is not claimed to be simulated._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Positive, boundary, exhaustive small-width, randomized wide-data, and
  four-state tests pass. The negative campaign detects inverted, constant,
  reversed-bit, and partial-corruption mutations, rejects `WIDTH=0` and
  `DIRECTION=2`, and detects an inequivalent candidate netlist. Reset and runtime
  error outputs are not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Zero and one coverpoints are reached in all 14 configurations. Mixed data is
  reached in all 12 configurations where `WIDTH > 1`._
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness contains no assumptions and leaves input data symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _Bitwise preservation passes by induction at depth 1 for both directions and
  representative widths 1, 4, 16, and 64._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The open-source campaign records `2/2` applicable executable lines and
  `1016/1016` applicable toggles, with every required coverpoint reached._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _No clock exists in the combinational wrapper._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable constraint gate validates a 5 ns portable maximum delay from
  every input to every output, 0.1 ns input transition, and 0.01 output load. It
  rejects clocks, false paths, and asynchronous clock groups._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The wrapper contains no clock, reset, or state. Voltage translation is not a
  synchronizer, so any CDC or reset-domain crossing is integration-owned._
- [x] CDC violations are resolved or narrowly waived.
  _CDC analysis is not applicable to the isolated wrapper. It becomes mandatory
  at the first integration containing asynchronous sources and consumers._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The RTL contains no state or test mode. The inserted technology cells and
  their surrounding paths require integration-level DFT review._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The executable power-intent gate validates separate source and destination
  domains and supplies, nominal 0.8 V and 1.0 V states, the sole legal
  `BOTH_ON` state, input and output supply associations, a bidirectional
  destination-side insertion rule, and the intentional absence of isolation and
  retention in the always-on profile. Integration must replace nominal values,
  add switchable states and isolation when required, and bind approved cells._
- [ ] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Open-source lint passes. VC Lint, CDC, and DFT are approved leaf-level skips,
  but VC LP is not waived. VC LP or an equivalent qualified checker is required
  at the first complete multi-voltage integration level._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable to the portable wrapper release. Design Compiler is an
  approved conditional `SKIP`; it becomes mandatory when integration selects a
  PDK, source and destination voltage libraries, operating corners, and an
  insertion or explicit-binding strategy._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys confirms that the technology-independent identity model contains two
  one-bit ports and zero logic cells, with no state, latch, or structural
  problem. This is the expected portable result, not level-shifter cell QoR.
  Library-mapped area and timing are mandatory at integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Not applicable to the portable wrapper release. PrimeTime is an approved
  conditional `SKIP`; it becomes mandatory with characterized arcs for both
  voltage directions, neighboring registers, and extracted interconnect._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The portable gate covers all input-to-output paths and prohibits timing
  exceptions. Library-aware multi-voltage coverage remains open above._
- [x] PrimePower uses representative SAIF activity.
  _Not applicable to the zero-cell portable wrapper. PrimePower is an approved
  conditional `SKIP`; integration must use representative crossing activity and
  the characterized multi-voltage cell network._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because standalone PrimePower is disabled. Integration must
  review annotation coverage for every shifted bit, inserted cell, isolation
  function, and neighboring logic._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is behavioral, structural, and power-intent correctness,
  all of which pass. Integration owns technology-specific targets including
  translation, routing, buffering, isolation, and voltage-scaling benefit._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The release manifest records portable tool versions, methodology revision,
  configuration, SDC, CDC, DFT, UPF, and technology-independent scope. PDK,
  level-shifter libraries, voltage pairs, and corners are explicitly absent and
  become mandatory integration identities._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _SKIP at portable-wrapper scope. The Nangate45 configuration is preliminary
  flow collateral and has neither characterized multi-voltage cells nor the two
  required supply rails. The first physical integration must use the project
  platform and an approved level-shifter cell library._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _SKIP at portable-wrapper scope because the identity RTL contains no physical
  cell to floorplan. Integration must document voltage areas, destination-side
  cell placement, rail access, utilization margins, and routing congestion for
  the inserted cells._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation is outside this portable wrapper's release scope.
  Integration must retain insertion coverage, correct shift direction,
  one-cell-per-bit or approved multi-bit mapping, dual-supply connectivity,
  destination-domain placement, routing, characterized timing, and clean DRC
  and LVS evidence. Clock implementation is not applicable to this
  combinational wrapper, while surrounding-path timing remains required._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _The Nangate45 configuration is a flow-integration aid only. No physical or
  multi-voltage signoff result is claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable until a waiver is proposed._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _No level-shifter waiver exists._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated locally with `MODULE=level_shifter`._
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image built as
  `sha256:9ab3d7e3a6e3a940cfbbd7ab6d026d57a29004b67bb94d2b5942be8d42aa1be6`
  from the pinned `mosaic-flow` revision `8fb2950`. The portable flow,
  constraint and power-intent checks, assertion coverage, fault injection,
  four-state simulation, and release manifest all pass inside the image._
- [x] GitHub Actions passes using the recorded gitlink revision.
  _Run `33434290737` passes for module revision `06101a0` with the
  `mosaic-flow` gitlink at `8fb2950`. Native and container jobs completed
  successfully for all seven registered modules. The level-shifter jobs passed
  the portable flow, constraint and power-intent checks, assertion coverage,
  fault injection, four-state simulation, and release-manifest gates._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Approved `SKIP` at portable-wrapper scope. No commercial result is inferred.
  VC LP and technology-bound timing, power, and physical evidence remain
  mandatory at the first complete integration with source and destination
  voltage libraries and inserted level-shifter cells._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The local release manifest records revisions, portable tool versions, input
  hashes, technology-independent scope, configuration, and generation date. It
  correctly marks the current uncommitted source tree as dirty._
- [x] CI or release storage retains logs and required databases.
  _Run `33434290737` retains `level_shifter-native-reports` artifact
  `9773849929` and `level_shifter-container-reports` artifact `9773985357`
  through November 29, 2026. The artifacts preserve module reports, release
  manifests, and CI diagnostics from both qualified environments._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=level_shifter flow-config-check
make MODULE=level_shifter clean open-source
make MODULE=level_shifter constraint-check
make MODULE=level_shifter assertion-coverage
make MODULE=level_shifter fault-injection
make MODULE=level_shifter four-state-check
make MODULE=level_shifter release-manifest
make synopsys-check-env
make MODULE=level_shifter synopsys-all CDC_TOOL=vc
```

Run the Synopsys commands only after source and destination voltage libraries,
UPF strategies, approved cells, and release-specific adapters are qualified.
Select `CDC_TOOL=sg` instead when that engine is the approved project policy.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from the presence of `PASS` files in a local
working tree.
