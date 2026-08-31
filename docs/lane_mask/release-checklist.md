# Release checklist

Use this checklist for every supported lane-mask configuration. A passing
portable gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and all design-owned tops use `lane_mask` within the
  `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
  _`LANES >= 1` is supported. The portable regression exercises 1, 2, 4, 8,
  and 16 lanes._
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to qualified revision `8fb2950`, tag
  `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The lane-mask policy enables the eight portable flows and records every
  physical and commercial adapter as disabled for the initial implementation._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _The combinational result has zero registered latency. Handshake,
  backpressure, and runtime error outputs are not applicable._
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The active-high mask convention and the requirement to resolve controls
  before their consumers are recorded._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Representative widths 1, 2, 4, 8, and 16 pass simulation and are instantiated
  in the formal harness. Every legal value of `LANES` is not claimed to have
  been exhaustively simulated._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Directed disabled, all-active, one-hot, tail-mask, independent suppression,
  and randomized cases pass. Reset and runtime error outputs are not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Disabled operation, all-active operation, and suppression by lane validity,
  architectural mask, and predicate each record a positive hit in all five
  simulated configurations._
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness contains no assumptions and leaves every input symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The combinational properties pass by induction at depth 1._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The open-source campaign records `11/11` executable RTL lines and `409/409`
  toggle records after the reviewed invalid-parameter exclusion. All 25
  required assertion-coverpoint instance hits are positive. Six functional
  mutations and one inequivalent candidate are detected._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _No clock exists in this combinational module._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable constraint gate validates a 5 ns maximum delay from all
  inputs to all outputs, 0.1 ns input transition, and 0.01 output load. It also
  rejects clocks, false paths, and asynchronous clock groups._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The module has no clock, reset, state, or internal domain crossing. Inputs
  must already be valid in the consuming domain._
- [x] CDC violations are resolved or narrowly waived.
  _CDC analysis is not applicable to this isolated combinational leaf. Domain
  crossings through its controls remain an integration responsibility._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The leaf contains no state or test mode. Scan architecture is not applicable._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The baseline collateral models one always-powered domain and no state.
  Cross-domain placement and isolation remain integration responsibilities._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _All commercial adapters are approved `SKIP` results for this portable,
  stateless combinational leaf. Open-source lint is required locally. CDC, DFT,
  and low-power analysis become integration gates when domains, state, scan,
  supplies, or isolation behavior are present around the module._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable to the technology-independent release. Design Compiler is an
  approved integration-level `SKIP`; Yosys provides required generic synthesis._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys reports 12 AND and 4 NAND cells for default `LANES=4`, with no state,
  latches, or unresolved structural problem. Technology QoR belongs to the
  consuming integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _PrimeTime is an approved integration-level `SKIP`. The leaf has no sequential
  endpoint; technology-bound combinational timing is checked with its consumers._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The portable constraint gate covers all input-to-output paths and prohibits
  timing exceptions. Library-aware timing coverage remains an integration task._
- [x] PrimePower uses representative SAIF activity.
  _PrimePower is an approved integration-level `SKIP`. Representative activity
  depends on workload masks and the downstream logic whose switching is saved._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because standalone PrimePower is disabled. Integration must
  review annotation coverage for the lane datapaths and mask consumers._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is behavioral and structural correctness. No standalone
  technology-specific PPA target is assigned to this control leaf._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The release manifest records portable tools, configuration, constraints, and
  technology-independent scope. PDK, library, and corner are not applicable
  before integration binding._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is an approved integration-level `SKIP` for the portable release.
  The committed Nangate45 configuration is preliminary collateral only._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable because standalone physical implementation is outside this
  release scope._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation does not belong to this leaf release. Placement,
  global-valid fanout, routing, timing, DRC, and LVS are owned by the consuming
  vector tile or execution block._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical signoff result is currently claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable until a waiver is proposed._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _No lane-mask waiver exists._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated locally for `MODULE=lane_mask`._
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image built as
  `sha256:9ab3d7e3a6e3a940cfbbd7ab6d026d57a29004b67bb94d2b5942be8d42aa1be6`.
  Inside it, the portable flow, constraints, coverage, fault injection,
  four-state check, and release manifest all pass._
- [ ] GitHub Actions passes using the recorded gitlink revision.
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Not applicable to this portable combinational release. Every commercial flow
  records an approved policy `SKIP`; technology and system integration own the
  conditional signoff gates described above._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The release manifest records module revision `95fd2f1`, methodology revision
  `8fb2950`, tool versions, input hashes, technology-independent scope,
  configuration, and generation date. It correctly marks the source tree dirty
  because this is pre-commit evidence._
- [ ] CI or release storage retains logs and required databases.
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=lane_mask flow-config-check
make MODULE=lane_mask clean open-source
make MODULE=lane_mask constraint-check
make MODULE=lane_mask assertion-coverage
make MODULE=lane_mask fault-injection
make MODULE=lane_mask four-state-check
make MODULE=lane_mask release-manifest
make all-modules
```

The portable functional implementation is complete. Coverage, fault injection,
four-state control validation, executable constraint review, integration policy,
and reproducibility evidence remain release work.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from local `PASS` files or a passing portable
gate.
