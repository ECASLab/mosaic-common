# Release checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _Current status: the DFF is registered as `dff`, uses the `dff` design
  top, and the Docker source label identifies `ECASLab/mosaic-common`._
- [x] Supported parameter values and configurations are listed.
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _Current status: the gitlink is pinned to `8fb2950`, tagged `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The expected SymbiYosys warning for the intentionally undriven formal global
  clock is reviewed under waiver `DFF-FORMAL-001`._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Reset, capture, hold, randomized parameter-matrix, and boundary-width tests
  pass. The local native and container CI-equivalent runs detect all four
  functional mutations and the RTL/netlist mismatch. The DFF exposes no runtime
  error-reporting interface._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Native and container CI-equivalent runs pass all assertions and retain
  positive LCOV hits for reset, reset priority, enabled capture, disabled hold,
  unconditional capture, and asynchronous reset coverpoints._
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness contains no assumptions. Reset, enable, and data remain
  symbolic, and the global formal clock is covered by waiver `DFF-FORMAL-001`._
- [x] Formal proofs pass at justified depth or by complete proof.
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The open-source Verilator campaign records 100% executable-line and toggle
  coverage for `rtl/dff.sv` and positive hits for every applicable functional
  coverpoint instance. Verification-source coverage is diagnostic, and separate
  commercial coverage collection is not required for this release._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Current status: both committed SDC files define a 10 ns `i_clk` with 0.1 ns
  uncertainty._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The default synchronous and alternative asynchronous SDC profiles constrain
  every input except the clock, apply output delay and clock uncertainty, and
  contain no blanket reset false path. The asynchronous profile preserves
  recovery and removal analysis for reset release. `make constraint-check`
  validates this intent in native and container CI paths._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _Not applicable for this release: `dff` contains one functional clock
  domain and is not a CDC or reset-domain crossing primitive._
- [x] CDC violations are resolved or narrowly waived.
  _Not applicable for this release: VC CDC and SpyGlass CDC are disabled by the
  reviewed DFF flow policy._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _Not applicable for this release: scan insertion and DFT integration are owned
  by the integrating design, so SpyGlass DFT is disabled for this primitive._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _Not applicable for this release: the DFF has no internal power-control
  behavior, so VC LP is disabled and low-power integration remains external._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Not applicable for this release: VC Lint, CDC, DFT, and VC LP are approved
  skips. Verible and Verilator provide the required DFF lint evidence._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable for this release: Design Compiler is an approved optional-flow
  skip. Yosys provides the required technology-independent synthesis evidence._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys structural statistics and synthesis status are reviewed. Technology-
  specific area, QoR, and timing are owned by the integrating design._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Not applicable for this release: PrimeTime is an approved optional-flow skip._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The open-source constraint intent check covers the synchronous, asynchronous,
  and OpenROAD profiles. Technology-specific timing coverage remains an
  integration responsibility because Design Compiler and PrimeTime are skipped._
- [x] PrimePower uses representative SAIF activity.
  _Not applicable for this release: PrimePower is an approved optional-flow skip._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because PrimePower is disabled for this release._
- [x] Power, performance, and area results meet the module targets.
  _Not applicable at primitive release: no technology-specific PPA target is
  assigned to the reusable DFF. PPA acceptance belongs to its integration._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The open-source tool and constraint identities are retained. PDK, library,
  and operating-corner identities are not applicable without a technology-
  specific implementation flow._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _Current status: `FLOW_openroad` is disabled for the DFF profile._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable because physical implementation is outside this release scope._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Not applicable because physical implementation is outside this release scope._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical result is produced or claimed by this release._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _Current status: `DFF-FORMAL-001` records the intentionally undriven global
  clock used by the formal harness._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Current status: `DFF-FORMAL-001` contains every required field._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
- [x] The pinned Docker image builds and its portable gate passes.
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _Current status: run `32812170952` passed for commit `d1f0f20`, before the
  design top was renamed to `dff`. The current revision requires a new run._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Not applicable for this release: VCS, Design Compiler, VC Lint, CDC, DFT,
  VC LP, PrimeTime, and PrimePower are approved optional-flow skips. The DFF
  acceptance gate is fully open-source._
- [ ] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _Current status: portable status files exist, but a complete release evidence
  manifest has not been produced._
- [ ] CI or release storage retains logs and required databases.
  _Current status: run `32812170952` retains artifacts for the previous design
  top. Artifacts for the current `dff` revision require a new CI run._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make flow-config-check
make clean open-source
make constraint-check
make assertion-coverage
make fault-injection
```

Commercial adapters may be enabled by an integrating project when its release
policy requires licensed evidence. They are not part of this DFF release gate.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from the presence of `PASS` files in a local
working tree.
