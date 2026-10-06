# Write Gate Release Checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registry, RTL top, testbench top, formal top, filelists, flow inputs,
  reports, and work paths consistently use `write_gate` in `mosaic-common`._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1` is legal. The qualified matrix covers widths 1, 2, 4, 8, 16,
  32, 64, and 128, and `WIDTH=0` is rejected during elaboration._
- [x] Unsupported modes and external assumptions are explicit.
  _The leaf does not compare data, cancel transactions, acknowledge protocols,
  synchronize crossings, store state, or provide clock gating, isolation, or
  retention. Integration owns suppression legality and control alignment._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `0bd222f`, tag `MF20260910V1`, with flow
  version `0.8.0`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The portable policy enables lint, formatting, elaboration, generic
  synthesis, formal, equivalence, simulation, and static-intent checks._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Latency is zero cycles. There is no handshake, backpressure, acknowledgement,
  or error interface._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _An inactive write request produces inactive outputs. Reset and test behavior
  belong to the stateful destination. Write suppression is not UPF isolation._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The consumer must prove that each suppressed write is architecturally
  redundant, aligned with its data, and accepted consistently by its protocol._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
  _All module-owned SystemVerilog and property sources use four-space
  indentation._
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
  _The synthesized leaf contains only combinational logic._
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The portable gate passes without a warning waiver._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Native and container regressions cover all eight declared widths._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Truth-table, one-hot, alternating, random, long-idle, long-suppression,
  mutation, invalid-width, and X/Z campaigns pass. Reset is not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Bound assertions check the equations, output exclusivity, request
  partitioning, and unknown controls. Required coverpoints have observed hits._
- [x] Formal assumptions are reviewed for overconstraint.
  _The leaf proof has no assumptions. The integration proof assumes only that a
  suppressed requested bit writes the value already held by the destination._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The combinational contract and one-step state-equivalence proof complete by
  induction for the qualified widths._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _Width-two qualification reaches 100 percent line, branch, and user coverage,
  98.913 percent toggle coverage, all 32 required named points, and formal
  cover reachability. No exclusion is used._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both constraint sets describe a combinational block and intentionally create
  no clock._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _Both SDC files apply matching input transition, output load, complete
  input-to-output delay, and path-specific control-to-output budgets. No clock
  uncertainty, false path, multicycle path, or asynchronous exception applies._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf contains no domain or reset crossing. The consumer must present
  coherent write and suppression controls in the destination domain._
- [x] CDC violations are resolved or narrowly waived.
  _CDC and RDC are policy `SKIP` at this combinational leaf. They remain required
  in a consuming design and are not represented as standalone `PASS` results._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The leaf has no state or test mode. Integration must constrain suppression
  transparently so it cannot block destination controllability._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _Portable static intent declares one always-on domain and forbids isolation,
  level-shifting, retention, and power-switch strategies at this leaf._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Their expected standalone status is policy `SKIP` because the checks require
  destination clock, reset, test, power-state, and library context. The status
  is recorded as `SKIP` or `NOT_RUN`, never `PASS`._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Policy `SKIP` for the technology-independent leaf. Mapped synthesis becomes
  mandatory in the first consuming implementation._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys generic synthesis passes for every width. The representative
  `WIDTH=2` OpenROAD run provides preliminary cell and physical metrics._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Policy `SKIP` until a destination, target library, and operating corners are
  selected. OpenROAD reports no setup or hold violation for the preliminary
  combinational implementation._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _All input-to-output combinations receive a maximum delay, with explicit
  write-request, suppression, and observation path budgets._
- [x] PrimePower uses representative SAIF activity.
  _Policy `SKIP` at leaf level. PrimePower with annotated destination activity
  remains mandatory before claiming technology-specific energy savings._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _The portable regression records destination write events and architectural
  state transitions. These counts validate stimulus but are not SAIF or power._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is correct suppression with reduced destination write
  events and unchanged architectural state. Numeric PPA targets are deferred._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _OpenROAD evidence records the immutable ORFS image, Nangate45 platform,
  module constraints, artifacts, and hashes. No foundry signoff is claimed._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _The representative `WIDTH=2` diagnostic uses Nangate45 and the pinned ORFS
  container image._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _The small combinational leaf uses a deterministic 60 by 60 micrometer die
  and a 50 by 50 micrometer core because the default PDN pitch is larger than
  the leaf logic._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _The exploratory run retains DEF, GDS, ODB, SDC, and netlist artifacts and
  reports zero setup, hold, slew, fanout, capacitance, and routing violations.
  Foundry DRC and LVS remain outside the portable leaf scope._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _The OpenROAD result is documented as a diagnostic, not destination-level or
  foundry signoff._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable while the waiver register is empty._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _There are no write-gate waivers to expire._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _`make MODULE=write_gate clean all-profiles PROFILE_JOBS=4` passes all eight
  supported widths._
- [x] The pinned Docker image builds and its portable gate passes.
  _The CI-equivalent container passes all eight profiles, width-one
  qualification campaigns, width-two coverage, and manifest validation._
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _Local `actionlint` and the CI-equivalent native commands pass. This item
  requires a committed revision and completed native and container workflow
  jobs for that exact revision._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are policy `SKIP` for portable leaf qualification. They are
  mandatory in the consuming integration and cannot be inferred from this item._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _Dirty-tree diagnostic native and container manifests validate the schema,
  record revisions and dirty state, and hash portable, coverage, static-intent,
  and applicable OpenROAD evidence._
- [ ] CI or release storage retains logs and required databases.
  _The workflow is configured to upload native and container reports, work
  databases, and diagnostics with `if-no-files-found: error`. Artifact IDs and
  retention dates can be recorded only after the committed workflow completes._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Consuming-integration handoff

- [x] The CDC and RDC disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no clock, reset, state, or domain crossing.
  The consumer must analyze the destination clock and reset domains plus the
  paths that generate and align both controls._
- [x] The DFT disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no state, scan element, or test mode. The
  consumer must define the transparent suppression value and prove that write
  gating does not prevent destination controllability or observability._
- [x] The VC LP disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: portable static intent validates one always-on leaf domain
  and the absence of isolation, retention, level shifting, and power switches.
  The consumer must analyze its actual supplies, power states, and sequencing._
- [x] The PrimeTime disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no technology-bound destination setup check.
  OpenROAD closes the preliminary combinational paths, while the consumer must
  close request and suppression timing with its selected libraries and corners._
- [x] The PrimePower disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the regression proves fewer destination write events with
  equal architectural state but does not claim energy savings. The consumer
  must compare mapped gated and ungated designs using representative SAIF._
- [x] The physical-signoff disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the Nangate45 OpenROAD implementation is a passing
  diagnostic, not foundry signoff. The consumer must close extraction, DRC,
  LVS, timing, and power with its destination and target PDK._

These reviewed skips close the portable leaf checklist only. The transferred
requirements remain mandatory before a register file, memory, counter, buffer,
or other stateful consumer can claim integration signoff or silicon power
savings.

## Known methodology limitation

The pinned `mosaic-flow` profile schema does not yet accept
`coverage_qualification` in a parameter-profile flow list. CI therefore forces
width-two coverage before manifest generation, stores `forced-status.txt`,
restores the profile-owned status to `SKIP`, and indexes the passing evidence.
This enforced handoff is validated and is not a write-gate release criterion.

## Final commands

```sh
git submodule status
make MODULE=write_gate PROFILE=width_2 flow-config-check
make MODULE=write_gate clean all-profiles PROFILE_JOBS=4
make MODULE=write_gate PROFILE=width_2 FORCE_FLOW=1 open-coverage
make MODULE=write_gate PROFILE=width_2 FORCE_FLOW=1 \
  OPENROAD_EXECUTION_MODE=container open-physical
```

Run commercial commands only in the licensed consuming environment after the
destination, libraries, corners, activity, test intent, and power intent are
available.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from `PASS` files in a local working tree.
