# Project Configuration

[Return to the module documentation index](README.md).

`config/modules/operand_isolation.mk` owns the tops, layered filelists, flow
inputs, and report roots. `config/modules/operand_isolation-flows.mk` enables
the portable lint, formatting, elaboration, generic synthesis, formal,
equivalence, simulation, qualification, and static-intent checks.

The qualified matrix contains widths 1, 8, 16, 32, 64, 128, and 256. It covers
zero, all-one, and nontrivial clamp classes. The width-one profile owns the
invalid-parameter, mutation, and four-state campaigns because their behavior
does not depend on datapath width.

`PROPERTY_FILELIST`, `ASSERTION_FILELIST`, and `COVERAGE_FILELIST` keep shared
predicates, checking wrappers, and coverage wrappers separate. Simulation and
formal compile the same combinational assertion and coverage definitions.

Both SDC files define matching input transition, output load, complete
input-to-output delay, operand-to-output, and control-to-output constraints.
Portable static-intent validation also checks an always-on UPF baseline that
forbids isolation, level-shifting, retention, and power-switch strategies at
this architectural leaf.

Commercial lint, CDC, DFT, low-power, mapped synthesis, timing, power, and
physical signoff are disabled for standalone portable qualification. They
require the actual downstream datapath, clock and reset domains, test controls,
power states, target libraries, corners, and representative annotated activity.
Their expected leaf status is `SKIP`, not `PASS`.

The pinned parameter-profile schema does not admit `coverage_qualification`.
GitHub Actions therefore reruns the representative width-16 simulation with
`FORCE_FLOW=1`, qualifies native HDL and formal coverage, preserves the passing
status as `forced-status.txt`, restores the profile-owned status to `SKIP`, and
indexes the forced status in the release manifest.
