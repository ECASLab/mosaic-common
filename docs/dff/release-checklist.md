# Release checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [ ] The module name, repository name, top-level names, and Docker labels agree.
  _Current status: final identity review is pending for the uncommitted DFF
  revision in the shared `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
- [x] Unsupported modes and external assumptions are explicit.
- [ ] The `mosaic-flow` gitlink points to a qualified published revision.
  _Current status: the gitlink is pinned to `8fb2950`, but release qualification
  has not been recorded in this checklist._
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
- [ ] No unresolved warning is hidden outside the reviewed waiver files.
  _Current status: SymbiYosys reports the expected undriven formal clock warning,
  but its disposition has not been recorded in the waiver document._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
- [ ] Positive, negative, reset, error, and boundary tests pass.
  _Current status: reset, capture, hold, and randomized matrix tests pass. The
  fault-injection qualification listed in the verification plan is pending._
- [ ] Assertions run in simulation and reach meaningful antecedents.
  _Current status: assertions pass, but antecedent and assertion coverage has not
  been captured as release evidence._
- [ ] Formal assumptions are reviewed for overconstraint.
- [x] Formal proofs pass at justified depth or by complete proof.
- [x] RTL-to-Yosys-netlist equivalence passes.
- [ ] Functional and code coverage goals are met or deviations are approved.
  _Current status: commercial statement, branch, expression, toggle, assertion,
  and functional coverage has not been collected._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Current status: both committed SDC files define a 10 ns `i_clk` with 0.1 ns
  uncertainty._
- [ ] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _Current status: input and output delays are present, but reset exceptions need
  parameter-aware review because `i_rstb` is synchronous when
  `ASYNC_RESET = 0` and asynchronous when `ASYNC_RESET = 1`._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _Not applicable for this release: `mosaic_dff` contains one functional clock
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

- [ ] Design Compiler completes with the intended libraries and operating corner.
  _Current status: Design Compiler, technology libraries, and an approved
  operating corner are not configured in this environment._
- [ ] Area, QoR, and synthesis timing reports are reviewed.
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Not applicable for this release: PrimeTime is an approved optional-flow skip._
- [ ] Unconstrained paths and constraint coverage are reviewed.
- [x] PrimePower uses representative SAIF activity.
  _Not applicable for this release: PrimePower is an approved optional-flow skip._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because PrimePower is disabled for this release._
- [ ] Power, performance, and area results meet the module targets.
- [ ] PDK, library, tool, constraint, and corner identities are recorded.

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
  _Current status: no waiver is accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Current status: the waiver template contains these fields, and there is no
  accepted waiver to instantiate them._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
- [x] The pinned Docker image builds and its portable gate passes.
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _Current status: the latest remote run passed only for the initial commit. The
  current working-tree changes have not been committed or pushed._
- [ ] Commercial gates pass in the authorized local or self-hosted environment.
  _Current status: only VCS simulation and Design Compiler synthesis remain
  enabled commercially. Preflight fails because `vcs` and `dc_shell` are
  unavailable._
- [ ] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _Current status: portable status files exist, but a complete release evidence
  manifest has not been produced._
- [ ] CI or release storage retains logs and required databases.
  _Current status: current logs are local generated artifacts and have not been
  retained by CI for this revision._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make flow-config-check
make clean open-source
make synopsys-check-env
make synopsys-all CDC_TOOL=vc
```

Run the Synopsys commands only in the licensed environment after all
release-specific adapters are qualified. Select `CDC_TOOL=sg` instead when that
engine is the approved project policy.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from the presence of `PASS` files in a local
working tree.
