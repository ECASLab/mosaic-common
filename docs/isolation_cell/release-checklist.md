# Isolation Cell Release Checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module, RTL top, testbench top, formal top, filelists, flow
  inputs, reports, and work paths consistently use `isolation_cell` within the
  `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1`, known `WIDTH`-bit clamp constants, and both static control
  polarities are supported. The portable regression exercises widths 1, 2, 4,
  8, 16, 32, and 64 with zero, one, and mixed clamp values._
- [x] Unsupported modes and external assumptions are explicit.
  _The interface documentation excludes voltage translation, retention, power
  switching, sequencing, synchronization, buffering, handshaking, and direct
  use on clocks or asynchronous resets. Physical isolation requires an
  always-on control source, protocol-safe clamps, complete project UPF, approved
  cells, and integration-level low-power signoff._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The isolation-cell policy enables the eight portable flows and reports
  OpenROAD plus every licensed adapter as disabled for the initial wrapper
  qualification. EQY correctly depends on Yosys synthesis._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _The wrapper adds zero architectural cycles and has no handshake,
  backpressure, or runtime error output. Unknown isolation control is illegal
  and is handled conservatively by the RTL model._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _Pass-through, active isolation, unknown-control, source-off, and portable UPF
  behavior are documented. Reset and local test modes are not present._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The interface records the always-on control, shutdown and wakeup ordering,
  per-signal clamp rationale, one-isolation-function-per-bit rule, and combined
  level-shifter requirements._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _Every enabled RTL-quality gate passes without a module waiver._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Widths 1, 2, 4, 8, 16, 32, and 64, both polarities, and zero, one, and mixed
  clamps pass. Arbitrarily large legal widths are supported but are not claimed
  to be exhaustively simulated._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Directed, walking, alternating, randomized, X/Z, invalid-width,
  invalid-clamp, four mutation, and inequivalent-netlist tests pass. Reset is
  not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Active isolation, inactive isolation, and data differing from the clamp are
  exercised in every parameterized checker instance._
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness contains no assumptions and leaves data and control
  symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _Both control polarities and all output bits pass complete combinational proof
  at depth 1._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The open-source campaign records `4/4` executable RTL lines and `1368/1368`
  toggle records after reviewed exclusions for invalid elaborations and static
  polarity alternatives. All required assertion antecedents are hit._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _No clock exists in this combinational wrapper._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable SDC gate validates a 5 ns all-input to all-output maximum
  delay, 0.1 ns input transition, and 0.01 output load, and rejects clocks and
  broad timing exceptions._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The wrapper does not synchronize data or isolation control and has no reset.
  Clock and reset relationships of source, controller, and destination remain
  explicit integration responsibilities._
- [x] CDC violations are resolved or narrowly waived.
  _Standalone CDC is not applicable to this stateless leaf. Integration must
  analyze asynchronous control release, reconvergence, and channel coherence._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The RTL has no state or test mode. Inserted cells, isolation overrides,
  always-on supplies, and scan paths require integration-level DFT review._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The executable portable-intent gate validates switchable source and active
  destination domains, separate supplies, `BOTH_ON` and `SOURCE_OFF` states,
  always-on control association, clamp-zero active-high isolation, parent-side
  placement, and intentional absence of retention and level shifting._
- [ ] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Open-source lint passes. VC Lint, standalone CDC, and leaf DFT are approved
  skips, but VC LP is not waived. A qualified low-power checker must validate
  complete insertion, clamp, polarity, always-on connectivity, legal power
  states, and any combined level shifting in the first power-gated integration._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Approved `SKIP` at portable-wrapper scope. Design Compiler becomes mandatory
  when the project binds or inserts characterized isolation cells._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys reports one generic `ANDNOT` cell for the default clamp-zero,
  active-high, one-bit configuration, with no state or structural problem. This
  generic gate is not credited as physical isolation._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Approved `SKIP` at portable-wrapper scope. Integration must time both
  data-to-output and isolation-control-to-output arcs in every relevant power
  mode and corner._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The portable constraint gate covers every input-to-output path and prohibits
  exceptions. Library-aware timing and power-mode case analysis remain
  integration requirements._
- [x] PrimePower uses representative SAIF activity.
  _Approved `SKIP` at portable-wrapper scope. Integration power analysis must
  include pass-through traffic, assertion and release, source corruption while
  clamped, isolated idle time, and shutdown frequency._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable while PrimePower is disabled. The power-gated integration
  must retain annotation coverage for data, control trees, cells, and both
  relevant supply contexts._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is functional and structural correctness. Isolation
  area, delay, leakage, control distribution, and power-gating break-even are
  owned by the technology-bound integration._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The release manifest records portable tools, source inputs, constraints, and
  technology-independent scope. PDK, isolation-cell library, voltage, and
  corner identities are conditional integration evidence._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _Approved `SKIP` at portable-wrapper scope. The Nangate45 configuration is
  preliminary flow collateral and has no qualified isolation cells, switchable
  voltage areas, or always-on control supply infrastructure._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable to the portable wrapper. Integration must justify voltage
  areas, legal boundary or parent-side placement, always-on rail access,
  control-tree fanout, congestion, utilization, and channel-skew margins._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation is outside this wrapper release. The power-gated
  integration must retain per-bit insertion coverage, supply connectivity,
  placement, routing, timing, power integrity, DRC, and LVS evidence. Clocking
  is not applicable inside the wrapper._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical or power-gating signoff result is claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable until a waiver is proposed._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _No isolation-cell waiver exists._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated locally with `MODULE=isolation_cell`._
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image built as
  `sha256:9ab3d7e3a6e3a940cfbbd7ab6d026d57a29004b67bb94d2b5942be8d42aa1be6`
  from the pinned `mosaic-flow` revision `8fb2950`. The portable flow,
  constraint and power-intent checks, assertion coverage, fault injection,
  invalid-parameter tests, four-state simulation, and release manifest all
  pass inside the image._
- [x] GitHub Actions passes using the recorded gitlink revision.
  _Run `33453975143` passes for module revision `adeae84` with the
  `mosaic-flow` gitlink at `8fb2950`. Native and container jobs completed
  successfully for all seven registered modules. The isolation-cell jobs passed
  the portable flow, constraint and power-intent checks, assertion coverage,
  fault injection, invalid-parameter tests, four-state simulation, and
  release-manifest gates._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Approved `SKIP` at portable-wrapper scope. No commercial result is inferred.
  VC LP, technology-bound synthesis, timing, power, DFT, and physical evidence
  remain mandatory for a complete power-gated integration release._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The local release manifest records module and methodology revisions,
  portable tool versions, input hashes, technology-independent scope,
  configuration, and generation date, and marks the current source tree dirty._
- [x] CI or release storage retains logs and required databases.
  _Run `33453975143` retains `isolation_cell-native-reports` artifact
  `9780800252` and `isolation_cell-container-reports` artifact `9780884320`
  through November 30, 2026. The artifacts preserve module reports, release
  manifests, and CI diagnostics from both qualified environments._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=isolation_cell flow-config-check
make MODULE=isolation_cell clean open-source
make MODULE=isolation_cell constraint-check
make MODULE=isolation_cell assertion-coverage
make MODULE=isolation_cell fault-injection
make MODULE=isolation_cell four-state-check
make MODULE=isolation_cell release-manifest
make synopsys-check-env
make MODULE=isolation_cell synopsys-all CDC_TOOL=vc
```

Run the Synopsys commands only in the licensed environment after all
release-specific adapters are qualified. Select `CDC_TOOL=sg` instead when that
engine is the approved project policy.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from the presence of `PASS` files in a local
working tree.
