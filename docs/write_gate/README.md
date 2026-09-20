# Write Gate Documentation

`write_gate` removes architecturally unnecessary write-enable events before
they reach a stateful destination. It is a stateless, combinational control
primitive and never decides whether a particular state update is legal to drop.

- [Interface specification](interface.md)
- [Project configuration](project-configuration.md)
- [Verification plan](verification-plan.md)
- [Power characterization](power-characterization.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run one qualified configuration from the repository root:

```sh
make MODULE=write_gate PROFILE=width_2 clean open-source
```

The pinned `mosaic-flow` profile validator does not admit
`coverage_qualification` in profile declarations, and OpenROAD remains optional
in the portable profile matrix. CI therefore forces the width-two coverage gate
and a representative `WIDTH=2` OpenROAD run before release-manifest generation.
Each passing forced status is retained alongside the reports, while the
profile-owned status remains `SKIP`. The passing coverage summary is indexed in
the manifest. The forced statuses and OpenROAD evidence are indexed explicitly
as additional evidence in the applicable manifest.
