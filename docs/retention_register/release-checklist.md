# Retention Register Release Checklist

Use this checklist for every supported module configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module, RTL top, testbench top, formal top, filelists, flow
  inputs, reports, and work paths consistently use `retention_register` within
  the `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1`, known `WIDTH`-bit reset values, synchronous or asynchronous
  active-low reset, and enable-present or enable-absent operation are supported.
  The initial regression covers widths 1, 8, 16, 32, 64, and 128 across all
  structural reset and enable combinations._
- [x] Unsupported modes and external assumptions are explicit.
  _The interface excludes power switching, isolation, voltage translation,
  clock gating, acknowledgements, synchronization, nonvolatile retention, and
  recovery after retention-supply loss. Physical retention requires an
  always-on controller, main and retention supplies, project power sequencing,
  approved cells, complete UPF, DFT, and technology-bound signoff._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The retention-register policy enables the eight portable flows and reports
  OpenROAD plus every licensed adapter as disabled for the initial model
  qualification. EQY correctly depends on Yosys synthesis._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _The interface is a one-cycle state element without handshake, backpressure,
  or error outputs. Save and restore priorities are explicitly documented._
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The portable model requires legal, synchronous save and restore controls and
  an always-on retention supply in a technology-bound implementation._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The complete portable gate passes without unresolved warnings or waivers._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _The regression covers widths 1, 8, 16, 32, 64, and 128 with both reset
  styles and both enable configurations._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Positive, reset, save, restore, hold, update, randomized, and width-boundary
  tests pass. A negative test detects simultaneous save/restore, while Icarus
  detects unknown reset, enable, save, and restore controls. Invalid parameters
  are guarded by elaboration-time fatal checks in the RTL._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _All reset, save, restore, update, and applicable hold coverpoints have hits._
- [x] Formal assumptions are reviewed for overconstraint.
  _Only illegal simultaneous save/restore and enable during power-management
  operations are excluded, matching the documented protocol._
- [x] Formal proofs pass at justified depth or by complete proof.
  _SymbiYosys bounded model checking passes through 12 cycles. This qualifies
  the initial portable model, while an inductive proof remains desirable._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The campaign reaches every executable RTL line and all required toggles after
  excluding only parameter-constant alternatives on lines 36 and 49._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both collateral sets use the 10 ns `i_clk` definition._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable check confirms the 10 ns clock, 0.2 ns uncertainty, 1 ns
  interface delays, and the narrowly scoped asynchronous reset false path._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf contains one clock domain. The optional asynchronous reset is
  declared for reset-domain analysis and save/restore controls are synchronous._
- [x] CDC violations are resolved or narrowly waived.
  _No asynchronous data crossing exists inside the leaf. System-level power
  controller crossings remain an integration responsibility._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _No test mode is implemented in this portable model. Scan replacement and
  retention-cell test behavior require the selected library and SoC DFT policy._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The preliminary UPF declares main and retention supplies, three power states,
  and the retention strategy. Library mapping remains intentionally open._
- [ ] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Policy `SKIP` for the technology-independent model. Required when mapping to
  an approved retention cell in a target library._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys generic synthesis passes and is sufficient for portable RTL quality.
  Technology QoR is deferred to integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Policy `SKIP` until target libraries, corners, and retention checks exist._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _All synchronous interface ports receive input or output delays. Only
  `i_rstb` is excluded in the asynchronous profile, with no broad exception._
- [x] PrimePower uses representative SAIF activity.
  _Policy `SKIP`; representative activity and mapped retention cells belong to
  the consuming design._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable to the portable release and required at integration._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is functional correctness and synthesizability. Numeric
  PPA targets require a selected technology._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _No PDK release is claimed. The open-source tool versions and generic
  constraints are retained by the module evidence._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is policy `SKIP` because an open generic library cannot validate a
  true retention-cell implementation._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable at leaf portable qualification; these are integration inputs._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation is outside this portable release scope._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical signoff claim is made._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _There are no retention-register waivers to expire._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image builds at digest `9ab3d7e3a6e3` and passes the
  portable flow, constraints, assertion coverage, negative tests, four-state
  checks, and release-manifest generation for `retention_register`._
- [ ] GitHub Actions passes using the recorded gitlink revision.
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are policy `SKIP` for portable RTL qualification. VC LP,
  mapped synthesis, STA, DFT, and power become mandatory at technology binding._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The generated release manifest records repository and methodology revisions,
  tool identities, selected flows, constraints, UPF, and evidence hashes._
- [ ] CI or release storage retains logs and required databases.
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
