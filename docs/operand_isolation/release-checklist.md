# Release Checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registry, RTL top, testbench top, formal top, filelists, flow inputs,
  report paths, and CI matrix consistently use `operand_isolation` within
  `mosaic-common`._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1` and a fully known `WIDTH`-bit `CLAMP_VALUE` are legal. The
  qualified matrix covers widths 1, 8, 16, 32, 64, 128, and 256 with zero,
  all-one, and nontrivial pattern clamp classes._
- [x] Unsupported modes and external assumptions are explicit.
  _The leaf does not provide power-domain isolation, retention, level shifting,
  synchronization, state holding, glitch filtering, or protocol cancellation.
  The consumer owns isolation legality, control timing, and operation capture._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `0bd222f`, tag `MF20260910V1`, with flow
  version `0.8.0`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The policy requires portable lint, formatting, elaboration, generic
  synthesis, formal, equivalence, simulation, and static-intent checks. The
  remaining standalone adapters record reviewed policy `SKIP` results._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
  _The parameter types, active-high isolation control, transparent equation,
  clamp equation, and X/Z behavior agree with `rtl/operand_isolation.sv`._
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Architectural latency is zero cycles. The leaf has no handshake,
  backpressure, acknowledgement, or runtime error interface. An X/Z isolation
  control propagates an unknown output and is reported by verification._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _Asserting `i_isolate` drives `CLAMP_VALUE`. Reset is not applicable, test
  integration must permit transparent operation, and this architectural clamp
  is explicitly distinguished from UPF power-domain isolation._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The consumer must assert isolation only when the operand is unused, keep the
  control stable before capture, synchronize asynchronous requests, and align
  isolation with valid, ready, stall, kill, predicate, lane-mask, and pipeline
  state._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
  _All seven supported parameter profiles record `PASS`._
- [x] Verible formatting records the expected status.
  _All module-owned SystemVerilog and property sources use four-space
  indentation and record `PASS`._
- [x] Slang elaboration records the expected status.
  _Every supported width and clamp profile elaborates successfully._
- [x] Verilator lint records the expected status.
  _All seven profiles record `PASS` with assertions and coverage wrappers in
  their layered filelists._
- [x] Yosys generic synthesis records the expected status.
  _Every profile synthesizes to combinational logic. The representative
  `WIDTH=16` pattern clamp contains 16 generic gates and no state._
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The retained portable lint, elaboration, synthesis, simulation, formal, and
  equivalence logs contain no warning or error requiring a waiver._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
  _The traceability table covers pass-through, clamping, input independence,
  illegal control, parameter legality, combinational behavior, activity
  reduction, synthesis structure, and equivalence._
- [x] All supported parameter configurations have evidence.
  _Native and container regressions pass for widths 1, 8, 16, 32, 64, 128,
  and 256 across zero, all-one, and nontrivial pattern clamp classes._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Directed, per-bit, alternating, deterministic long-sequence, isolated-input
  activity, inverted-control mutation, invalid-width, invalid-X/Z-clamp, and
  X/Z-control campaigns pass. Reset is not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Bound assertions check transparent and isolated equations plus unknown
  controls. All 19 required functional, transition, and integration coverpoints
  are observed in the representative coverage run._
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness has no assumptions and leaves both operands and the
  isolation control symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The combinational contract and twin-DUT input-independence properties pass
  by complete induction at depth one for every supported profile._
- [x] RTL-to-Yosys-netlist equivalence passes.
  _EQY proves the `o_data` partition equivalent for all seven profiles._
- [x] Functional and code coverage goals are met or deviations are approved.
  _The representative profile reaches 100 percent effective line coverage,
  100 percent branch coverage, 99.5495 percent toggle coverage, 100 percent
  user coverage, all 19 named points, and formal cover reachability.
  `OI-COV-001` approves the exact X/Z default-arm line exclusion, which is
  qualified separately by passing four-state simulation._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both constraint sets describe a combinational leaf and intentionally create
  no clock._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _Matching SDC files constrain input transition, output load, every
  input-to-output path, and explicit operand and isolation-control paths. Clock
  uncertainty, timing exceptions, and asynchronous clock paths do not apply._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf has no clock, reset, state, or internal crossing. The consumer must
  provide coherent operands and controls and synchronize any asynchronous
  isolation request before this module._
- [x] CDC violations are resolved or narrowly waived.
  _CDC and RDC are policy `SKIP` at this stateless leaf. No crossing is waived,
  and destination-domain analysis remains an integration requirement._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The module has no state or internal test mode. Integration must make
  `i_isolate` controllable so transparent mode exposes the downstream cone._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _Portable static intent validates one always-on domain and forbids isolation,
  level shifting, retention, and power-switch strategies at this architectural
  leaf. Actual power crossings remain owned by the consumer._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Their expected standalone status is reviewed policy `SKIP` because the
  required clock, reset, scan, power-state, and technology context exists only
  in the consumer. No commercial result is represented as `PASS`._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Approved policy `SKIP` for the technology-independent leaf. Technology-mapped
  synthesis is mandatory in the first consuming datapath._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys generic synthesis passes for every profile and produces only
  combinational logic. The representative `WIDTH=16` patterned implementation
  contains 16 generic gates and no state._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Approved policy `SKIP` until registered launch and capture boundaries,
  libraries, and operating corners are selected by the consumer._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _Portable static intent validates a complete input-to-output maximum-delay
  budget and explicit `i_data` and `i_isolate` path budgets in both SDC files._
- [x] PrimePower uses representative SAIF activity.
  _Approved policy `SKIP` at leaf level. Mapped isolated and ungated consumers
  must be compared with identical representative activity before claiming
  technology-specific energy savings._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Standalone SAIF is not applicable while PrimePower is disabled. The portable
  regression instead records downstream transitions for three use cases and
  explicitly documents that these counts are not power estimates._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is functional correctness and demonstrably lower
  downstream activity with unchanged active behavior. Numeric PPA targets are
  deferred to a mapped consuming datapath._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _Release manifests record the portable toolchain, constraints, source hashes,
  module and methodology revisions, and technology-independent scope. PDK,
  library, and corner identities are conditional integration evidence._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _Approved policy `SKIP` for standalone qualification. The committed Nangate45
  configuration is exploratory collateral, not a qualified implementation._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable to this portable leaf release. The clamp must be placed near
  its downstream cone, and integration owns control fanout, buffering,
  congestion, voltage areas, utilization, and margins._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation is outside the standalone release scope. The
  consuming block owns placement, routing, extraction, control timing, DRC, and
  LVS. Clocking is not applicable inside this leaf._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical or foundry signoff result is claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _`OI-COV-001` records the only requested exclusion and points to its dedicated
  four-state qualification evidence._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _`OI-COV-001` records the affected line, technical justification, dedicated
  evidence, owner, reviewer, creation and approval dates, and objective removal
  condition._
- [x] Generated waiver drafts are not treated as approved policy.
  _The coverage-policy exclusion is manually scoped to one exact RTL line. No
  generated draft has been promoted into project policy._
- [x] Expired waivers have been removed or re-reviewed.
  _No operand-isolation waiver is expired._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _`make MODULE=operand_isolation clean all-profiles PROFILE_JOBS=4` passes all
  seven profiles, including the width-one negative and four-state campaigns._
- [x] The pinned Docker image builds and its portable gate passes.
  _Image `sha256:5d6dfaec931c37c2ea69c1103053e0c3eea34899f0692d09a2302ba5a2b426d9`
  was built from the current Dockerfile and pinned `mosaic-flow` revision. Its
  complete seven-profile matrix, representative coverage, and release manifest
  validation pass._
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _`actionlint` and the exact native and container commands pass locally. This
  item requires a committed revision and completed GitHub-hosted jobs for that
  exact revision._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are reviewed policy `SKIP` for portable leaf qualification.
  Their integration requirements remain mandatory and no commercial execution
  is inferred._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _Dirty-tree diagnostic manifests validate in native and container contexts,
  identify the module and `mosaic-flow` revisions, record configuration and
  tool metadata, and hash required inputs and evidence._
- [ ] CI or release storage retains logs and required databases.
  _The workflow uploads native and container reports, work databases, and CI
  diagnostics with `if-no-files-found: error`. Artifact IDs and retention dates
  can be recorded only after the committed workflow completes._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Consuming-integration handoff

- [x] The CDC and RDC disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no clock, reset, state, synchronizer, or
  internal domain crossing. The consumer must analyze operand sources,
  isolation-control generation, clock and reset domains, and reconvergence._
- [x] The DFT disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no state, scan element, generated clock, or
  internal test mode. The consumer must make `i_isolate` controllable, force
  transparent mode for ATPG, and preserve downstream observability._
- [x] The VC LP disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: portable static intent validates one always-on domain and
  forbids UPF isolation, retention, level shifting, and power switches at this
  architectural clamp. The consumer must run VC LP on its real domains,
  supplies, power states, crossings, and sequencing._
- [x] The PrimeTime disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: meaningful timing requires registered launch and capture
  boundaries, target libraries, operating corners, and final control fanout.
  The consumer must close both operand-to-output and control-to-output paths._
- [x] The PrimePower disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: a standalone clamp cannot demonstrate net power savings.
  The consumer must compare mapped isolated and ungated downstream cones using
  identical representative activity and annotation coverage._
- [x] The physical-signoff disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: placement and routing are meaningful only with the actual
  downstream cone, control distribution, voltage areas, target PDK, and loads.
  The consumer owns extraction, timing, power integrity, DRC, and LVS._

These reviewed skips close the portable leaf checklist only. The transferred
requirements remain mandatory before a multiplier, MAC, ALU, vector lane,
address generator, or other consumer can claim integration signoff or silicon
power savings.

## Known methodology limitation

The pinned `mosaic-flow` parameter-profile schema does not admit
`coverage_qualification` in a profile flow list. Native and container CI force
coverage for `width_16_pattern`, preserve its passing status as
`forced-status.txt`, restore the profile-owned status to `SKIP`, and index the
passing supplemental evidence in the release manifest.

## Final commands

```sh
git submodule status
make MODULE=operand_isolation PROFILE=width_16_pattern flow-config-check
make MODULE=operand_isolation clean all-profiles PROFILE_JOBS=4
make MODULE=operand_isolation PROFILE=width_16_pattern FORCE_FLOW=1 open-coverage
```

Run commercial commands only in the licensed consuming environment after the
datapath, libraries, corners, activity, test intent, and power intent exist.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from local `PASS` files.
