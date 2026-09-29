# Multiplexer Release Checklist

Use this checklist for every supported mux configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and Scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registry, RTL top, testbench top, formal top, filelists, flow inputs,
  reports, and work paths consistently use `mux` in `mosaic-common`. The Docker
  image remains the common-module CI environment._
- [x] Supported parameter values and configurations are listed.
  _`NUM_INPUTS >= 1` and `DATA_WIDTH >= 1` are legal. `SEL_WIDTH` must retain
  its derived value and `DEFAULT_VALUE` must contain only known bits. Six
  profiles cover one through eight inputs and one through 128 data bits._
- [x] Unsupported modes and external assumptions are explicit.
  _The leaf does not validate routes, opcodes, datatypes, domains, contexts, or
  protocols. Integration owns source coherence, architectural legality, and
  crossing protection._
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The gitlink is pinned to revision `0bd222f`, tag `MF20260910V1`, with flow
  version `0.8.0`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.
  _Portable policy enables lint, formatting, elaboration, generic synthesis,
  formal, equivalence, simulation, qualification campaigns, coverage, and
  static-intent checks._

## Interface and Architecture

- [x] [Interface specification](interface.md) matches the RTL.
  _The documented parameters, packed input ordering, output equation, validity
  output, fail-closed behavior, and bit ordering match `rtl/mux.sv`._
- [x] Every clock and reset has documented polarity and timing behavior.
  _The module is combinational and has no clock or reset._
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
  _Latency is zero cycles. There is no handshake or backpressure. Invalid and
  unknown selections return `DEFAULT_VALUE` and deassert `o_select_valid`._
- [x] Disabled, reset, test, and low-power behavior are documented.
  _There is no enable, reset, or test mode. Functional output stability for
  unselected input changes does not imply zero internal or upstream activity._
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The consumer must provide coherent data and selection, validate higher-level
  legality, and protect asynchronous or voltage-domain crossings._

## RTL Quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
  _All mux-owned SystemVerilog and property sources use four-space indentation._
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
  _Every qualified profile synthesizes to combinational logic without a latch,
  flip-flop, memory, loop, or unresolved reference._
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The portable gate passes without a mux warning waiver._

## Functional Verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All supported parameter configurations have evidence.
  _Native regressions pass for all six declared profiles._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _The regression exhausts all selection encodings with zero, one, and distinct
  data, every ordered legal transition, selected and unselected data changes,
  randomized activity, invalid parameters, a validity mutant, and X/Z controls.
  Reset is not applicable._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _Bound assertions check exact data and validity equations. Directed stimulus
  reaches legal, invalid, boundary, data-change, and unknown-control cases._
- [x] Formal assumptions are reviewed for overconstraint.
  _The combinational proof leaves every data bit and selection bit unconstrained
  and uses no assumptions._
- [x] Formal proofs pass at justified depth or by complete proof.
  _Depth-one complete combinational proofs pass for all six profiles._
- [x] RTL-to-Yosys-netlist equivalence passes.
- [x] Functional and code coverage goals are met or deviations are approved.
  _The representative three-input, 16-bit profile reaches 100 percent line,
  branch, and user coverage, 95.4392 percent toggle coverage, all 14 required
  sampled points, and all seven formal cover statements without exclusions._

## Constraints and Static Checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both SDC files describe a combinational block and intentionally create no
  clock._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _Both SDC files apply matching input transition, output load, complete
  input-to-output delay, and path-specific data and selection budgets. No clock
  uncertainty, false path, multicycle path, or asynchronous exception applies._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The leaf contains no clock, reset, domain, or crossing. The consumer must
  synchronize asynchronous controls and prove data-selection coherence._
- [x] CDC violations are resolved or narrowly waived.
  _CDC and RDC are policy `SKIP` at this combinational leaf. They remain required
  in the consuming design and are not represented as standalone `PASS` results._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _The leaf has no state, test mode, or internally generated clock. Integration
  owns controllability and observability of the selected data paths._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _Portable static intent declares one always-on domain and forbids isolation,
  level-shifting, retention, and power-switch strategies at this leaf._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Their expected standalone status is policy `SKIP`. Open-source lint and
  portable static intent pass. Domain, test, and library-dependent checks move
  to the consumer and no commercial `PASS` is claimed._

## Synthesis, Timing, and Power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Policy `SKIP` for the technology-independent leaf. Mapped synthesis becomes
  mandatory in the first consuming implementation._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys generic synthesis passes for every input-count and width profile. The
  representative three-input, 16-bit profile maps to 66 generic combinational
  cells and no state._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Policy `SKIP` until launch and capture boundaries, target libraries, loads,
  and operating corners are selected. No PrimeTime `PASS` is claimed._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _Every input-to-output combination receives a maximum delay, with explicit
  data-to-output and selection-to-output budgets._
- [x] PrimePower uses representative SAIF activity.
  _Policy `SKIP` at leaf level. PrimePower remains mandatory before a consumer
  claims technology-specific energy savings._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Portable regression measures functional and toggle coverage but does not
  relabel those results as SAIF or power evidence._
- [x] Power, performance, and area results meet the module targets.
  _The portable target is correct combinational selection and functional output
  stability for unselected data changes. Numeric PPA targets are deferred._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _Portable evidence records tool and constraint identity. No PDK, mapped
  library, operating corner, or signoff target is selected for this leaf._

## Physical Implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is a reviewed policy `SKIP` because physical implementation is not
  part of the standalone mux release. Checked-in configuration is preliminary
  integration collateral._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable to the technology-independent leaf. These values depend on
  placement with the register file, route network, or datapath it selects._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Physical implementation does not belong to this leaf's release scope. The
  consuming block must retain implementation and signoff evidence._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No standalone physical result or foundry-signoff claim is made._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
  _No waiver is currently accepted._
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
  _Not applicable while the waiver register is empty._
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _There are no mux waivers to expire._

## Reproducibility and Evidence

- [x] Native `make clean open-source` passes.
  _`make MODULE=mux clean all-profiles PROFILE_JOBS=4` passes all six supported
  profiles. Representative forced coverage qualification also passes._
- [x] The pinned Docker image builds and its portable gate passes.
  _Image `sha256:5d6dfaec931c37c2ea69c1103053e0c3eea34899f0692d09a2302ba5a2b426d9`
  was built from pinned methodology revision `0bd222f` (`MF20260910V1`). All
  six mux profiles, representative forced coverage, and the six container
  manifest validations pass with the CI-equivalent commands._
- [ ] GitHub Actions passes using the recorded gitlink revision.
  _This requires a committed revision and completed native and container jobs
  for that exact revision._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Commercial gates are reviewed policy `SKIP` for portable leaf qualification.
  They remain mandatory where identified in consuming integration._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _All six native and all six container diagnostic manifests validate. They
  record base module revision `d907c79`, dirty-tree state, pinned methodology
  revision `0bd222f`, profile parameters, technology context, input and evidence
  hashes, generation date, and open-source tool versions. A clean committed
  revision remains necessary for final GitHub release evidence._
- [ ] CI or release storage retains logs and required databases.
  _The workflow uploads native and container reports, work databases, and
  diagnostics. Artifact IDs and retention dates require a committed run._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Consuming-Integration Handoff

- [x] The VC Lint disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: Verible, Verilator, Slang, Yosys, and formal checks cover the
  standalone RTL. The consuming project may require VC Lint under its policy._
- [x] The CDC and RDC disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no clock, reset, state, or crossing. The
  consumer must analyze domains that generate data and selection._
- [x] The DFT disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: the leaf has no state, scan element, generated clock, or test
  mode. The consumer must prove path controllability and observability._
- [x] The VC LP disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: portable static intent validates one always-on leaf domain.
  The consumer must analyze supplies, states, crossings, and required cells._
- [x] The mapped synthesis and PrimeTime disposition is reviewed.
  _Reviewed `SKIP`: generic synthesis proves a combinational implementation.
  The consumer must map and close data and selection paths with chosen libraries,
  loads, boundaries, and corners._
- [x] The PrimePower disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: functional activity behavior is verified but no energy saving
  is claimed. The consumer must use representative annotated activity._
- [x] The physical-signoff disposition is reviewed for portable leaf release.
  _Reviewed `SKIP`: placement-dependent delay, fanout, congestion, glitches,
  extraction, DRC, and LVS belong to the consuming implementation._

These reviewed skips close only their standalone policy decisions. Transferred
requirements remain mandatory before a tile, NoC router, register file, context
memory, functional unit, or other consumer can claim integration or silicon
signoff.

## Known Methodology Limitation

The pinned `mosaic-flow` profile schema does not accept
`coverage_qualification` in a parameter-profile flow list. CI therefore forces
coverage for `inputs_3_width_16`, preserves `forced-status.txt`, restores the
profile-owned status to `SKIP`, and indexes the passing evidence in the release
manifest. This enforced handoff is not a mux release deviation.

## Final Commands

```sh
git submodule status
make MODULE=mux PROFILE=inputs_3_width_16 flow-config-check
make MODULE=mux clean all-profiles PROFILE_JOBS=4
make MODULE=mux PROFILE=inputs_3_width_16 FORCE_FLOW=1 open-coverage
make MODULE=mux PROFILE=inputs_3_width_16 release-manifest release-manifest-validate
```

Run commercial commands only in the licensed consuming environment after the
source and destination domains, libraries, corners, activity, test intent, and
power intent are available.

## Approval Record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from `PASS` files in a local working tree.
