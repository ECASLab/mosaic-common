# Release checklist

Use this checklist for every supported priority-encoder configuration. A passing
portable gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and design-owned tops use `priority_encoder` within
  `mosaic-common`._
- [x] Supported parameter values and configurations are listed.
  _`WIDTH >= 1`, both static priority directions, and the required derived index
  width are documented. Widths 1, 2, 3, 4, 5, 8, 16, and 32 are simulated._
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _Eight portable flows are enabled. Physical and commercial adapters are
  disabled for this initial implementation._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _The result has zero registered latency. Handshake, acknowledgement,
  backpressure, and runtime error outputs are outside this primitive._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _No-request behavior is deterministic. Reset and test modes are not
  applicable; integration owns power optimization._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _Request coherence, starvation, retention, acknowledgement, and asynchronous
  source requirements are recorded._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The retained Yosys log contains ABC's expected informational warning that
  the network is combinational before its internal optimization pass. The flow
  completes with zero structural problems, and the diagnostic is not hidden or
  waived._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Both directions are simulated at widths 1, 2, 3, 4, 5, 8, 16, and 32.
  Formal covers representative boundary and non-power-of-two widths._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _No-request, every single request, all requests, exhaustive patterns through
  width 8, and randomized wider patterns pass. Reset is not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _No-request, valid-request, single-request, lowest-index selection, and
  highest-index selection coverpoints are reached in all 16 simulated
  configurations. Multiple-request behavior is reached in all 14 configurations
  where `WIDTH > 1`; contention is structurally impossible for `WIDTH=1`._
- [x] Formal assumptions are reviewed for overconstraint.
  _The harness contains no assumptions and leaves request vectors symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _Combinational properties pass by induction at depth 1._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The open-source campaign records `9/9` applicable executable RTL lines and
  `768/768` applicable toggles. Exclusions cover invalid-parameter branches,
  constant `WIDTH=1` port states, and inactive elaboration-time priority
  alternatives. Both priority alternatives remain exercised by named
  coverpoints, exhaustive or randomized simulation, and formal proof._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _No clock exists in this combinational module._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable constraint gate validates a 5 ns maximum delay from every
  input to every output, 0.1 ns input transition, and 0.01 output load. It also
  rejects clocks, false paths, and asynchronous clock groups._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf has no clock, reset, state, or internal crossing. Requests must be
  synchronized and coherent before entering the encoder._
- [x] CDC violations are resolved or narrowly waived.
  _CDC analysis is not applicable to the isolated combinational leaf. The first
  integration containing request sources, synchronization, and consumers owns
  CDC and reset-domain signoff._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The leaf contains no state, scan element, test mode, or internal exclusion.
  Controllability and observability are checked with the consuming scan design._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The baseline UPF models one always-powered domain with no retained state.
  Isolation and level shifting become integration requirements when interfaces
  cross switchable or multi-voltage domains._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _All commercial adapters are approved policy `SKIP` results for this portable,
  stateless combinational leaf. Open-source lint remains mandatory locally.
  CDC, DFT, and low-power analysis become integration gates when request
  domains, scan architecture, power states, or voltage crossings are present._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable to the technology-independent leaf release. Design Compiler is
  an approved integration-level `SKIP`; Yosys provides the required generic
  synthesis evidence._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys reports 14 generic combinational cells for the default `WIDTH=4`, with
  no latch, state, or structural problem. Library-mapped area, QoR, and timing
  belong to the consuming integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _PrimeTime is an approved integration-level `SKIP`. The leaf has no sequential
  endpoint; technology-bound combinational timing is checked between the
  launching and capturing registers of its consumer._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The portable constraint gate covers every input-to-output path with a 5 ns
  maximum delay and rejects clocks and broad timing exceptions. Library-aware
  path and constraint coverage remains an integration requirement._
- [x] PrimePower uses representative SAIF activity.
  _PrimePower is an approved integration-level `SKIP`. Representative activity
  depends on request contention, priority direction, width, and workload at the
  consuming arbiter or scheduler._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because standalone PrimePower is disabled. Integration must
  review annotation coverage for all request, selection, and consumer paths._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is behavioral and structural correctness. No standalone
  technology-specific PPA target is assigned to this combinational control
  primitive._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The release manifest records portable tools, configuration, constraint hashes,
  and technology-independent scope. PDK, library, and corner identities are not
  applicable until integration binds the leaf to a target technology._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is an approved integration-level `SKIP` for the portable release.
  The committed Nangate45 configuration is preliminary collateral only._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable because standalone physical implementation is outside this
  leaf release scope. The encoder is placed within its consuming arbitration or
  scheduling block._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation does not belong to this portable leaf release. The
  consuming block owns placement, request and valid fanout, combinational path
  timing, routing, DRC, and LVS with representative registers and loads._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical signoff result is currently claimed. The Nangate45 configuration
  must not be presented as PDK-qualified or commercial signoff evidence._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable until a waiver is proposed._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _No priority-encoder waiver exists._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated locally with `MODULE=priority_encoder`._
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image built as
  `sha256:9ab3d7e3a6e3a940cfbbd7ab6d026d57a29004b67bb94d2b5942be8d42aa1be6`.
  Inside it, the portable flow, constraint check, assertion coverage, and
  release manifest all pass._
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _The workflow matrix includes `priority_encoder` and reads the pinned
  `mosaic-flow` gitlink. This item remains open until a remote run passes for a
  committed module revision._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Not applicable to this portable combinational release. Every commercial flow
  records an approved policy `SKIP`; technology and system integration own the
  conditional signoff gates documented above._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The native and container release manifests record the module revision,
  methodology revision `8fb2950`, portable tool versions, input hashes,
  technology-independent scope, configuration, and generation date. The current
  local manifest correctly marks the uncommitted source tree as dirty._
- [ ] CI or release storage retains logs and required databases.
  _The workflow uploads native and container reports with
  `if-no-files-found: error`. This item remains open until a passing remote run
  provides artifact identifiers and retention dates._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=priority_encoder flow-config-check
make MODULE=priority_encoder clean open-source
make MODULE=priority_encoder constraint-check
make MODULE=priority_encoder assertion-coverage
make MODULE=priority_encoder fault-injection
make MODULE=priority_encoder four-state-check
make MODULE=priority_encoder release-manifest
make all-modules
```

Coverage, negative testing, four-state qualification, executable constraint
review, integration policy, and reproducibility evidence remain release work.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from local `PASS` files or a passing portable
gate.
