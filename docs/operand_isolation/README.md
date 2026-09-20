# Operand Isolation Documentation

`operand_isolation` clamps an inactive datapath operand to a compile-time
constant so downstream combinational logic does not follow irrelevant input
activity. It is a stateless architectural power primitive and is not a UPF
power-domain isolation cell.

- [Interface specification](interface.md)
- [Project configuration](project-configuration.md)
- [Verification plan](verification-plan.md)
- [Power characterization](power-characterization.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run one qualified configuration from the repository root:

```sh
make MODULE=operand_isolation PROFILE=width_16_pattern clean open-source
```

Run the complete supported parameter matrix with:

```sh
make MODULE=operand_isolation clean all-profiles PROFILE_JOBS=4
```

The parameter-profile schema does not select `coverage_qualification`. Native
and container CI therefore force the representative `width_16_pattern`
coverage gate before release-manifest generation, retain its passing status as
additional evidence, and restore the profile-owned status to `SKIP`.
