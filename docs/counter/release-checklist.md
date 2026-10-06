# Release checklist

Use this checklist for every supported counter configuration. A passing portable
gate alone is not sufficient ASIC release evidence.

## Identity and scope

- [x] The module name, repository name, top-level names, and Docker labels agree.
  _The registered module and all design-owned tops use `counter` within the
  `mosaic-common` repository._
- [x] Supported parameter values and configurations are listed.
- [x] Unsupported modes and external assumptions are explicit.
- [x] The `mosaic-flow` gitlink points to a qualified published revision.
  _The current gitlink is pinned to revision `8fb2950`, tag `MF20260816V1`._
- [x] The resolved flow policy has been captured with `make flow-config-check`.

## Interface and architecture

- [x] [Interface specification](interface.md) matches the RTL.
- [x] Every clock and reset has documented polarity and timing behavior.
- [x] Latency, throughput, handshakes, backpressure, and errors are documented.
- [x] Disabled, reset, test, and low-power behavior are documented.
- [x] Integration assumptions and protocol dependencies are reviewed.
  _The documented clock, reset, CDC, event-consumption, FIFO-integration, scan,
  and low-power ownership assumptions are accepted for release._

## RTL quality

- [x] Verible style lint records `PASS` or an approved policy `SKIP`.
- [x] Verible formatting records the expected status.
- [x] Slang elaboration records the expected status.
- [x] Verilator lint records the expected status.
- [x] Yosys generic synthesis records the expected status.
- [x] No unresolved warning is hidden outside the reviewed waiver files.
  _The expected formal global-clock warning is recorded as
  `COUNTER-FORMAL-001`._

## Functional verification

- [x] The [verification plan](verification-plan.md) maps every requirement to a
  test, assertion, formal property, or reviewed combination.
- [x] All currently supported parameter configurations have evidence.
  _The supported release matrix covers representative widths from 1 through 64,
  both reset styles, both arithmetic modes, and a nonzero reset value. It does
  not claim exhaustive testing of every legal `WIDTH` or `RESET_VALUE`. Formal
  covers every reset-style and arithmetic-mode combination at `WIDTH=3`._
- [x] Positive, negative, reset, error, and boundary tests pass.
  _Positive, reset, priority, hold, and arithmetic boundaries pass. The module
  exposes no runtime error output. Eight simulation mutations covering command
  priority, direction, arithmetic modes, events, terminal indication, and reset
  are detected. EQY also rejects an intentionally incorrect candidate netlist._
- [x] Assertions run in simulation and reach meaningful antecedents.
  _All assertions pass. The open-source coverage campaign records positive hits
  for reset, clear, load, both priority conflicts, increment, decrement, hold,
  overflow, and underflow in all eight simulation configurations._
- [x] Formal assumptions are reviewed for overconstraint.
  _The harness contains no assumptions._
- [x] Formal proofs pass at justified depth or by complete proof.
  _The `WIDTH=3` state space passes by induction at depth 12._
- [x] RTL-to-Yosys-netlist equivalence passes.
  _EQY proves the grouped count, event, and terminal partition._
- [x] Functional and code coverage goals are met or deviations are approved.
  _The campaign records `62/62` adjusted executable RTL lines and `1072/1072`
  adjusted Verilator branch/toggle records. Exclusions are limited to the
  four-state-only direction default and static `SATURATE` alternatives. All ten
  functional coverpoints have hits in all eight configurations, and both formal
  cover statements are reached._

## Constraints and static checks

- [x] Synthesis and physical clocks agree unless a difference is documented.
  _Both profiles use a 10 ns `i_clk`. The optional OpenROAD configuration uses
  the synchronous synthesis SDC._
- [x] Input, output, uncertainty, exception, and asynchronous paths are reviewed.
  _The synchronous and asynchronous profiles constrain every input except the
  clock, constrain every output, apply clock uncertainty, and contain no blanket
  reset false path. `make MODULE=counter constraint-check` validates this intent
  and preserves recovery and removal analysis._
- [x] CDC and reset-domain intent covers every domain and crossing.
  _The counter has one functional clock and implements no crossing. All inputs
  are required to be synchronous except asynchronous reset assertion._
- [x] CDC violations are resolved or narrowly waived.
  _Not applicable for this single-domain primitive. CDC adapters are disabled._
- [x] DFT test modes, controllability, observability, and exclusions are reviewed.
  _Scan insertion belongs to the integrating design. The RTL contains no
  generated clock or scan-blocking test behavior._
- [x] UPF power domains, states, isolation, retention, and supplies match the
  architecture.
  _The primitive has no internal low-power control. VC LP is an approved skip._
- [x] VC Lint, selected CDC, SpyGlass DFT, and VC LP adapters are qualified for
  the installed release and all expected statuses pass.
  _Not applicable to the current technology-independent scope. Open-source lint
  is required and the commercial adapters are approved skips._

## Synthesis, timing, and power

- [x] Design Compiler completes with the intended libraries and operating corner.
  _Not applicable. Design Compiler is an approved optional-flow skip and Yosys
  provides required generic synthesis evidence._
- [x] Area, QoR, and synthesis timing reports are reviewed.
  _Yosys structure and generic synthesis status are reviewed. Technology-specific
  area and timing belong to integration._
- [x] PrimeTime reports no release-blocking setup or hold violation.
  _Not applicable. PrimeTime is an approved optional-flow skip._
- [x] Unconstrained paths and constraint coverage are reviewed.
  _The open-source constraint-intent campaign covers the synchronous,
  asynchronous, and OpenROAD-selected profiles. Technology-specific timing
  coverage remains an integration responsibility because Design Compiler and
  PrimeTime are approved skips._
- [x] PrimePower uses representative SAIF activity.
  _Not applicable. PrimePower is an approved optional-flow skip._
- [x] SAIF hierarchy and activity annotation coverage are reviewed.
  _Not applicable because PrimePower is disabled._
- [x] Power, performance, and area results meet the module targets.
  _No technology-specific PPA target is assigned to this reusable primitive._
- [x] PDK, library, tool, constraint, and corner identities are recorded.
  _Open-source tools and constraints are recorded. PDK, library, and corner
  identities are not applicable without technology-specific implementation._

## Physical implementation

- [x] OpenROAD or the selected implementation flow uses the intended platform.
  _OpenROAD is disabled for the current counter policy._
- [x] Floorplan, utilization, aspect ratio, and margins are justified.
  _Not applicable because physical implementation is outside release scope._
- [x] Placement, clocking, routing, timing, DRC, and LVS evidence is retained when
  physical implementation belongs to this module's release scope.
  _Not applicable for this technology-independent release._
- [x] Preliminary open-source physical results are not labeled as commercial
  signoff evidence.
  _No physical signoff result is claimed._

## Waivers

- [x] Every accepted waiver is recorded in [Reviewed waivers](waivers.md).
- [x] Each waiver identifies the tool, rule, object, justification, owner,
  reviewer, date, and removal condition.
- [x] Generated waiver drafts are not treated as approved policy.
- [x] Expired waivers have been removed or re-reviewed.
  _The current waiver has a removal condition and no fixed expiration._

## Reproducibility and evidence

- [x] Native `make clean open-source` passes.
  _Validated with `MODULE=counter`._
- [x] The pinned Docker image builds and its portable gate passes.
  _The counter portable flow and manifest pass in the pinned local container._
- [x] GitHub Actions passes using the recorded gitlink revision.
  _Run `33234112731` passed for commit `561d6f9` with `mosaic-flow` revision
  `8fb2950`. The module-matrix, native, and container jobs completed
  successfully for both `counter` and `dff`._
- [x] Commercial gates pass in the authorized local or self-hosted environment.
  _Not applicable. Every commercial adapter is an approved optional-flow skip._
- [x] Reports identify module revision, methodology revision, tool versions,
  constraints, technology, date, and configuration.
  _The counter release manifest records the evidence required by the current
  policy._
- [x] CI or release storage retains logs and required databases.
  _Run `33234112731` retains `counter-native-reports` and
  `counter-container-reports` through November 27, 2026._
- [x] No generated work database, credential, license, or proprietary library is
  committed to Git.

## Final commands

```sh
git submodule status
make MODULE=counter flow-config-check
make MODULE=counter clean open-source
make MODULE=counter constraint-check
make MODULE=counter assertion-coverage
make MODULE=counter fault-injection
make MODULE=counter release-manifest
make all-modules
```

The constraint, assertion-coverage, and fault-injection targets produce required
retained `PASS` evidence. Commercial commands are omitted because every licensed
adapter is disabled by the reviewed counter policy.

## Approval record

Record the release identifier, reviewed Git revisions, supported configuration,
evidence location, approvers, and approval date in the project's normal release
system. Do not infer approval only from local `PASS` files or a complete portable
gate.
