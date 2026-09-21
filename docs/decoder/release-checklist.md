# Decoder Release Checklist

Use this checklist for every supported decoder configuration. A passing
portable gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registry, RTL top, testbench top, formal top, filelists, flow inputs,
  reports, and work paths consistently use `decoder` in `mosaic-common`. The
  Docker image is labeled as the common-module CI environment._
- [x] Supported parameter values and configurations are listed.
  _`NUM_OUTPUTS >= 1` is legal and `SELECT_WIDTH` must retain its derived value.
  The qualified matrix covers output counts 1, 2, 3, 4, 5, 8, 16, and 32._
- [x] Unsupported modes and external assumptions are explicit.
  _The leaf does not validate opcodes, datatypes, routes, contexts, domains, or
  protocols. Integration owns source coherence, architectural legality, and
  any synchronization or voltage-domain protection._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `0bd222f`, tag `MF20260910V1`, with flow
  version `0.8.0`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _The portable policy enables lint, formatting, elaboration, generic
  synthesis, formal, equivalence, simulation, qualification campaigns, and
  static-intent checks._

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
  _The documented parameters, ports, active-high encoding, validity output,
  fail-closed behavior, and bit ordering match `rtl/decoder.sv`._
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Latency is zero cycles. There is no handshake or backpressure. An invalid
  enabled selection is reported by deasserting `o_select_valid`._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _Disabled, invalid, and unknown controls produce zero outputs. Reset and test
  behavior are not applicable. Output suppression is logical activity control,
  not UPF isolation._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The consumer must provide coherent controls in one domain, validate the
  higher-level operation, and never use decoded outputs as physical clocks._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
  _All decoder-owned SystemVerilog and property sources use four-space
  indentation._
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
  _Every qualified profile synthesizes to combinational logic without a latch,
  flip-flop, memory, loop, or unresolved reference._
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The portable gate passes without a decoder warning waiver._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Native and CI-equivalent container regressions pass for all eight declared
  output counts._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Exhaustive legal and invalid selections, disabled operation, ordered legal
  transitions, random controls, the one-output boundary, invalid parameters,
  an inverted-enable mutant, and X/Z controls pass. Reset is not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Bound assertions check the exact equations, one-hot-or-zero encoding,
  disabled and invalid behavior, and unknown controls. Directed stimulus reaches
  each applicable condition._
- [x] Formal assumptions are reviewed for overconstraint.
  _The combinational proof leaves enable and selection unconstrained and uses no
  assumptions._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The depth-one combinational proofs complete for every qualified profile._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The representative `NUM_OUTPUTS=3` profile reaches 100 percent line, branch,
  and user coverage, 97.7273 percent toggle coverage, all ten required sampled
  points, and all six formal cover statements. No exclusion is used._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both SDC files describe a combinational block and intentionally create no
  clock._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _Both SDC files apply matching input transition, output load, complete
  input-to-output delay, and path-specific enable and select budgets. No clock
  uncertainty, false path, multicycle path, or asynchronous exception applies._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf contains no clock, reset, domain, or crossing. The consumer must
  synchronize asynchronous sources and prove enable and selection coherence._
- [x] CDC violations are resolved or narrowly waived.
  _CDC and RDC are policy `SKIP` at this combinational leaf. They remain required
  in the consuming design and are not represented as standalone `PASS` results._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The leaf has no state, test mode, or internally generated clock. Integration
  owns the controllability and observability of the selected destinations._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _Portable static intent declares one always-on domain and forbids isolation,
  level-shifting, retention, and power-switch strategies at this leaf._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Their expected standalone status is policy `SKIP`. Open-source lint and
  portable static intent pass. Domain, test, and library-dependent checks move
  to the consumer and no commercial `PASS` is claimed._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Policy `SKIP` for the technology-independent leaf. Mapped synthesis becomes
  mandatory in the first consuming implementation._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys generic synthesis passes for every output count. The representative
  three-output decoder maps to six generic combinational cells and no state._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Policy `SKIP` until launch and capture boundaries, target libraries, loads,
  and operating corners are selected. No PrimeTime `PASS` is claimed._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _Every input-to-output combination receives a maximum delay, with explicit
  select-to-output, select-to-valid, enable-to-output, and enable-to-valid
  budgets._
- [x] PrimePower uses representative SAIF activity.
  _Policy `SKIP` at leaf level. PrimePower remains mandatory before a consuming
  design claims technology-specific energy savings._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _The portable regression measures functional and toggle coverage but does not
  relabel those results as SAIF or power evidence. Annotation review transfers
  to the mapped consuming design._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is correct combinational decoding and zero output
  activity while disabled. Numeric PPA targets are deferred to integration._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _Validated manifests identify the technology-independent scope, tool versions,
  methodology revision, constraints, and hashes. No PDK or signoff corner is
  selected for the standalone leaf._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is a reviewed policy `SKIP` because physical implementation is not
  part of the standalone decoder release. The checked-in configuration is
  preliminary integration collateral, not release evidence._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable to the technology-independent leaf. These values depend on
  placement with the register file, bank, route, or control block it drives._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation does not belong to this leaf's release scope. The
  consuming block must retain implementation and signoff evidence._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No standalone physical result or foundry-signoff claim is made._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _`DEC-CI-001` records the external hosted-execution and artifact-retention
  block for the qualified decoder revision._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _`DEC-CI-001` records both run and check-run IDs, exact revisions, local
  replacement evidence, owner, reviewer, approval date, and removal condition._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _`DEC-CI-001` remains active only while GitHub rejects jobs before execution._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _`make MODULE=decoder clean all-profiles PROFILE_JOBS=4` passes all eight
  supported output counts. The exact 38-entry repository module-profile matrix
  also passes natively, including three representative coverage gates and the
  required clock-gate and write-gate OpenROAD runs._
- [x] The pinned Docker image builds and its portable gate passes.
  _Image `sha256:5d6dfaec931c37c2ea69c1103053e0c3eea34899f0692d09a2302ba5a2b426d9`
  was built from the pinned `MF20260910V1` methodology. Its complete 38-entry
  matrix, representative coverage gates, and manifest validations pass._
- [x] The GitHub Actions disposition is reviewed for the recorded revision.
  _Push run `35551308160` and pull-request run `35551684468` for revision
  `0ace813` were rejected before their first step because of failed account
  payments or the configured spending limit. No flow executed or failed. Under
  approved exception `DEC-CI-001`, the exact native and container workflow
  commands pass locally and the hosted result is recorded as
  `BLOCKED_EXTERNAL`, not `PASS`._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are reviewed policy `SKIP` for portable leaf qualification.
  They are mandatory where identified in the consuming integration and are not
  reported as `PASS` here._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _All 38 native and all 38 container manifests validate for module revision
  `0ace813` and pinned methodology revision `0bd222f`. They record configuration
  and tool metadata and hash required inputs and evidence._
- [x] The CI and release-evidence retention disposition is reviewed.
  _GitHub could not create artifacts because both hosted runs were rejected
  before execution. Under `DEC-CI-001`, local native and container logs,
  reports, coverage evidence, physical evidence, and release manifests are
  retained in ignored evidence directories. The exception expires when hosted
  execution can be repeated and artifact IDs and retention dates recorded._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Consuming-integration handoff

- [x] The VC Lint disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: Verible, Verilator, Slang, Yosys, and formal checks cover the
  standalone RTL. The consuming project may require VC Lint under its signoff
  policy._
- [x] The CDC and RDC disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no clock, reset, state, or crossing. The
  consumer must analyze the domains that generate the controls and receive the
  decoded enables._
- [x] The DFT disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no state, scan element, generated clock, or test
  mode. The consumer must prove destination controllability and observability._
- [x] The VC LP disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: portable static intent validates one always-on leaf domain.
  The consumer must analyze actual supplies, power states, crossings, and
  isolation or level-shifting requirements._
- [x] The mapped synthesis and PrimeTime disposition is reviewed.
  _Reviewed `SKIP`: generic synthesis proves a combinational implementation.
  The consumer must map and close every select and enable path with its selected
  libraries, loads, boundaries, and corners._
- [x] The PrimePower disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: output suppression is functionally proven but no energy
  saving is claimed. The consumer must use representative annotated activity._
- [x] The physical-signoff disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: placement-dependent delay, congestion, fanout, glitches,
  extraction, DRC, and LVS belong to the consuming implementation._

These reviewed skips close the portable leaf checklist only. The transferred
requirements remain mandatory before a register file, context memory, tile,
NoC router, or other consumer can claim integration or silicon signoff.

## Known methodology limitation

The pinned `mosaic-flow` profile schema does not yet accept
`coverage_qualification` in a parameter-profile flow list. CI therefore forces
three-output coverage before manifest generation, stores `forced-status.txt`,
restores the profile-owned status to `SKIP`, and indexes the passing evidence.
This enforced handoff is validated and is not a decoder release deviation.

## Final commands

```sh
git submodule status
make MODULE=decoder PROFILE=outputs_3 flow-config-check
make MODULE=decoder clean all-profiles PROFILE_JOBS=4
make MODULE=decoder PROFILE=outputs_3 FORCE_FLOW=1 open-coverage
make MODULE=decoder PROFILE=outputs_3 release-manifest release-manifest-validate
```

Run commercial commands only in the licensed consuming environment after the
source and destination domains, libraries, corners, activity, test intent, and
power intent are available.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from `PASS` files in a local working tree.
