# Release checklist

Use this checklist for every supported clock-gate implementation. A passing
portable gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and all design-owned tops use `clock_gate` within the
  `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
  _The baseline interface has no functional parameters._
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The source and generated clocks are documented. The module has no reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _These data-interface concepts are not applicable. Illegal unknown controls
  and low-phase enable capture are documented._
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.
  _Enable timing, initialization clocks, scan override, ICG mapping, FPGA use,
  and switchable-domain sequencing are accepted for the portable release._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The intentional RTL latch, formal global clock, and formal reference latches
  are recorded under `CLOCK-GATE-RTL-001`, `CLOCK-GATE-FORMAL-001`, and
  `CLOCK-GATE-FORMAL-002`._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _The module has one parameter-free portable configuration._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Positive, test-override, phase-transition, pulse, and randomized tests pass.
  The module has no reset or runtime error output. Four simulation mutations and
  one RTL/netlist mismatch are detected._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Functional-only, test-only, combined-enable, and disabled coverpoints all
  record positive hits._
- [x] Formal assumptions are reviewed for overconstraint.
  _The harness contains no assumptions. Controls remain symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The portable implementation passes induction at depth 12._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The campaign records `9/9` executable RTL lines and `21/21` toggle records
  with no exclusions, plus positive hits for all four functional coverpoints._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both profiles select `clock_gate.timing.sdc`._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The clock-gate-specific constraint check validates the 10 ns source clock,
  generated clock, uncertainty, both control delays, and absence of broad timing
  exceptions or data output delay on `o_gclk`._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The collateral identifies `source_clk`, derived `gated_clk`, and enable-control
  assumptions. The module contains no reset domain._
- [x] CDC violations are resolved or narrowly waived.
  _The portable module contains one source clock and its synchronous gated
  derivative, with no asynchronous data or reset crossing. Commercial CDC is
  not required for this leaf release. Integration CDC must analyze the actual
  gated-clock consumers._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The portable interface provides `i_test_enable` as the scan override and its
  behavior is covered by simulation, assertions, and formal proof. Downstream
  scan-clock reachability is an integration-level DFT requirement._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The baseline UPF models one always-powered domain. Switchable-domain intent
  remains an integration responsibility._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _These commercial adapters are policy `SKIP` for the technology-independent
  leaf release. VC LP becomes conditional when the gate is placed in a
  switchable domain or a multi-voltage integration._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Design Compiler is policy `SKIP` for the portable release. It becomes a
  required technology-binding gate to prove mapping to an approved ASIC ICG
  cell using the selected libraries and corner._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys confirms one latch, AND, and OR in the portable model. The exploratory
  Nangate45 implementation reports 33 um2 of placed cell area, 1% core
  utilization, zero setup and hold violations, and 4.4092 ns final slack. Exact
  one-ICG mapping remains pending on the target ASIC library._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _PrimeTime is policy `SKIP` for the portable release. Generated-clock timing,
  clock-gating setup and hold checks, latency, and skew must be qualified after
  ICG mapping in the consuming ASIC integration._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The final OpenROAD report checks both control inputs to the enable latch under
  `source_clk`. The generated clock is propagated and the SDC contains no false
  paths, asynchronous groups, or output-delay model on `o_gclk`._
- [x] PrimePower uses representative SAIF activity.
  _PrimePower is policy `SKIP` for the portable leaf release. Representative
  activity requires the gated clock loads and enable duty cycle of a consuming
  block, so this gate belongs to integration._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Standalone SAIF is not a release input because it cannot represent the
  downstream clock load. Integration must review hierarchy and annotation
  coverage before accepting a PrimePower comparison._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is functional and physical feasibility, demonstrated by
  the clean Nangate45 result. Quantified savings against an ungated reference
  are an integration target, where the switched clock load is known._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _The exploratory evidence records the pinned ORFS image digest, Nangate45
  platform and typical library, 10 ns SDC, and module OpenROAD configuration.
  The eventual ASIC technology binding remains part of Design Compiler signoff._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _The enabled flow uses the pinned ORFS image and the open Nangate45 platform._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _A fixed 60 um by 60 um die and 50 um by 50 um core provide the minimum
  repeatable outline needed by the Nangate45 PDN for this three-cell design._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _The flow retains final DEF, GDS, ODB, SDC, and netlist artifacts together with
  floorplan, placement, CTS, route, timing, and KLayout merge reports. Detailed
  routing reports zero violations and KLayout reports no missing or orphan cells.
  This is open-source implementation evidence, not foundry signoff LVS._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _The Nangate45 result qualifies only the portable exploratory implementation._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _The accepted intentional RTL latch is recorded as `CLOCK-GATE-RTL-001`._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _No clock-gate waiver has expired._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
- [x] The pinned Docker image builds and its portable gate passes.
  _The DFF, counter, and clock-gate container commands pass locally._
- [x] GitHub Actions passes using the recorded gitlink revision.
  _Run `33293103235` passes at module revision `4ec4339` with the
  `mosaic-flow` gitlink at `8fb2950`. Native and container jobs pass for DFF,
  counter, and clock gate. The clock-gate native job also passes the pinned
  OpenROAD physical flow, release manifest, and artifact upload._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are not required for this portable release. VC LP, Design
  Compiler, PrimeTime, and PrimePower remain conditional integration gates as
  described above rather than inferred `PASS` results._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The release manifest and OpenROAD evidence record identify revisions, portable
  tool versions, the pinned ORFS image digest, Nangate45, SDC, configuration,
  generation date, and final DEF/GDS hashes._
- [x] CI or release storage retains logs and required databases.
  _The native artifact upload includes module reports plus OpenROAD reports and
  physical results. The container job retains its portable reports separately._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=clock_gate flow-config-check
make MODULE=clock_gate clean open-source
make MODULE=clock_gate constraint-check
make MODULE=clock_gate assertion-coverage
make MODULE=clock_gate fault-injection
make MODULE=clock_gate openroad-container
make MODULE=clock_gate release-manifest
```

Commercial ASIC qualification must additionally demonstrate approved ICG
mapping, generated-clock STA, gating checks, DFT controllability, low-power
intent, physical implementation, and representative power savings.

## Approval record

Record the release identifier, reviewed Git revisions, supported implementation,
technology binding, evidence location, approvers, and approval date in the
project's normal release system. Do not infer approval only from local `PASS`
files or a passing portable gate.
