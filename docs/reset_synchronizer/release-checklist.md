# Release checklist

Use this checklist for every supported reset-synchronizer configuration. A
passing portable gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and all design-owned tops use `reset_synchronizer`
  within the `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
  _`STAGES >= 2` is supported. The portable regression exercises depths 2, 3,
  and 4._
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to qualified revision `8fb2950`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
  _The input reset asserts asynchronously low and releases synchronously on the
  rising edge of `i_clk` after exactly `STAGES` active edges._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Release latency is parameterized. Handshake, backpressure, throughput, and
  runtime error reporting are not applicable to this primitive._
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.
  _One destination clock domain is allowed per instance. Clock-stop,
  reassertion, DFT, low-power, and physical-placement assumptions are recorded._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The expected undriven formal global-clock diagnostic is retained in the
  SymbiYosys logs and reviewed as harness behavior. It is not suppressed or
  treated as a waiver._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Depths 2, 3, and 4 provide representative portable evidence. Every legal
  value of `STAGES` is not claimed to have been exhaustively simulated._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Directed and randomized reset, clock-stop, restart, reassertion, and minimum-
  depth tests pass. `make MODULE=reset_synchronizer four-state-check` uses
  Icarus to demonstrate detection of unknown `i_async_rstb`. Its disabled-
  monitor control proves that the same `X` stimulus otherwise escapes._
- [x] Assertions run in simulation and reach meaningful antecedents.
- [x] Formal assumptions are reviewed for overconstraint.
  _The formal harness contains no assumptions. Clock and reset remain symbolic._
- [x] Formal proofs pass at justified depth or by complete proof.
  _SymbiYosys passes by induction at depth 16._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _Open-source executable-line and toggle goals pass. Required assertion
  antecedents are exercised, and four simulation mutations plus one incorrect
  netlist are detected._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _The synthesis and preliminary OpenROAD profiles use the 10 ns destination
  clock defined on `i_clk`._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The executable constraint check validates destination-clock uncertainty and
  output delay. It rejects blanket stage exceptions and a synchronous delay on
  the raw asynchronous reset, preserving recovery and removal analysis._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The module contains one destination clock domain and one asynchronous reset
  crossing. The interface contract and CDC collateral identify asynchronous
  assertion, synchronous release, prohibited intermediate fanout, prohibited
  raw and synchronized reset reconvergence, and one instance per destination
  domain. Tool signoff remains tracked by the following item._
- [x] CDC violations are resolved or narrowly waived.
  _Not applicable to the isolated leaf release. VC CDC and SpyGlass CDC are
  approved `SKIP` results because the leaf does not contain the reset source or
  functional consumers needed for meaningful signoff. A qualified CDC/RDC
  engine becomes mandatory at the first integration level containing the reset
  source, synchronizer, destination clock domain, and reset consumers._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _SpyGlass DFT is an approved module-level `SKIP`. The leaf interface contains
  no scan network or test mode, so destination-clock and reset controllability,
  observability, and stage scan policy must be qualified with the complete
  MOSAIC/SoC test architecture._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The portable baseline models one always-powered domain with no internal
  isolation or retention. VC LP is an approved conditional `SKIP` and becomes
  mandatory when the source, synchronizer, clock, or consumers cross power or
  voltage domains, or when the destination domain can be switched off._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _All commercial adapters are approved `SKIP` results for the portable leaf
  release. Open-source lint is the required local evidence. CDC/RDC and DFT are
  transferred to the documented integration levels, while VC LP becomes
  mandatory only under the documented power-domain conditions._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable to the portable release. Design Compiler is an approved
  integration-level `SKIP`. Yosys provides the required generic synthesis and
  confirms that the RTL is synthesizable._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys structural statistics are reviewed and confirm the requested
  asynchronous-reset stage structure. Technology-specific QoR and timing belong
  to the consuming ASIC integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Not applicable to the portable release. PrimeTime is an approved integration-
  level `SKIP`. Setup, hold, recovery, removal, and reset pulse-width checks
  become mandatory after technology binding._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The portable constraint-intent gate reviews the destination clock, clock
  uncertainty, output delay, and asynchronous reset treatment. Technology-
  specific timing coverage remains an integration responsibility._
- [x] PrimePower uses representative SAIF activity.
  _Not applicable to this portable primitive release. PrimePower is an approved
  integration-level `SKIP`, where representative reset and clock activity can
  be supplied by the consuming design._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because PrimePower is disabled for the portable release._
- [x] Power, performance, and area results meet the module targets.
  _No technology-specific PPA target is assigned to the reusable primitive.
  Integration owns MTBF, timing, area, and power acceptance._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _Portable tool and constraint identities are retained in the release manifest.
  PDK, library, and corner identities are not applicable before technology
  binding._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _Not applicable to the portable release. OpenROAD is an approved integration-
  level `SKIP`, and the preliminary configuration is not release evidence._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable because physical implementation is outside the portable
  release scope._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation does not belong to this release scope. Close
  placement, ordered stages, reset connectivity, controlled fanout, and physical
  verification must be demonstrated by the consuming implementation._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical signoff result is currently claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated locally with `MODULE=reset_synchronizer` and in the concurrent
  four-module regression._
- [x] The pinned Docker image builds and its portable gate passes.
  _The local CI-equivalent image built from Ubuntu 24.04 and `mosaic-flow`
  revision `8fb2950` as image `sha256:9ab3d7e3a6e3`. Inside that image, the
  portable flow, constraint check, assertion coverage, fault injection,
  four-state check, and release manifest all passed._
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _The module has not yet been validated by a pushed GitHub Actions run._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Not applicable to this portable leaf release. Every commercial flow records
  an approved policy `SKIP`. CDC/RDC remains mandatory at the first complete
  reset-network integration level, DFT belongs to MOSAIC/SoC, and low-power
  analysis is conditional on the consuming power architecture._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The local release manifest validates the enabled portable evidence. It must
  be regenerated after the implementation commit for final release evidence._
- [ ] CI or release storage retains logs and required databases.
  _Local reports exist, but retained CI artifacts require a successful pushed
  workflow run._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=reset_synchronizer flow-config-check
make MODULE=reset_synchronizer clean open-source
make MODULE=reset_synchronizer constraint-check
make MODULE=reset_synchronizer assertion-coverage
make MODULE=reset_synchronizer fault-injection
make MODULE=reset_synchronizer four-state-check
make MODULE=reset_synchronizer release-manifest
make all-modules
```

The portable commands qualify the reusable RTL behavior. ASIC integration always
requires CDC and RDC recognition. MOSAIC/SoC integration owns DFT review, and
low-power signoff becomes mandatory for switchable or multi-voltage use.
Technology mapping, recovery and removal timing, and physical placement remain
integration responsibilities.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from local `PASS` files or a complete portable
gate.
