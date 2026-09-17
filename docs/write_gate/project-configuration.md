# Project Configuration

[Return to the module documentation index](README.md).

`config/modules/write_gate.mk` owns the selected tops, layered file lists,
flow inputs, and report roots. `config/modules/write_gate-flows.mk` enables
the portable lint, elaboration, synthesis, formal, equivalence, simulation,
qualification, and static-intent checks.

The qualified widths are `1, 2, 4, 8, 16, 32, 64, and 128`, declared in
`config/parameter-profiles/write_gate.json`. Width one also runs the
invalid-parameter, mutation, and four-state campaigns because those controls
are width independent.

`PROPERTY_FILELIST`, `ASSERTION_FILELIST`, and `COVERAGE_FILELIST` keep shared
predicates, checking wrappers, and coverage wrappers separate. The normal
testbench binds the combinational assertion and coverage wrappers and
instantiates transition and integration coverage monitors. The formal harness
instantiates the same combinational wrappers and an integration proof that
compares gated next state with an ungated reference.

The leaf remains technology independent. A representative `WIDTH=2` OpenROAD
run checks that the combinational leaf can be synthesized, placed, routed, and
evaluated against its module-owned constraints with the Nangate45 platform.
Commercial lint, CDC, DFT, low-power, synthesis, timing, and power signoff still
require a target library and the stateful destination that receives the gated
control. These integration deferrals are not standalone signoff waivers, and
the representative OpenROAD run is not destination-level signoff.

Both SDC files declare matching input transition, output load, complete
input-to-output delay, and request-to-permit, suppression-to-permit, and
control-to-observation path budgets. The static-intent policy validates their
consistency and a single always-on UPF domain without claiming physical timing
closure.

The pinned flow cannot select coverage from a parameter-profile manifest, and
OpenROAD remains optional in the portable profile matrix. The GitHub workflow
therefore executes width-two coverage and the representative `WIDTH=2`
OpenROAD run with `FORCE_FLOW=1` before generating the native release manifest.
A failure remains fatal and each passing forced status is retained as
`forced-status.txt`. Profile-owned statuses are restored to `SKIP` so manifest
validation remains consistent with the pinned profile schema. The coverage
summary is still indexed as release evidence, while OpenROAD evidence is
indexed explicitly as additional native evidence together with both forced
statuses. The container manifest indexes its forced coverage status.
