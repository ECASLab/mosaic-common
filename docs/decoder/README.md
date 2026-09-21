# Parameterizable decoder

[Return to the repository README](../../README.md).

`decoder` converts an enabled binary selection into one active-high output. It
supports non-power-of-two output counts, reports whether a selection is legal,
and fails closed for disabled, invalid, or unknown controls.

## Documentation

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Project configuration](project-configuration.md)
- [Power characterization](power-characterization.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

## Quick start

```sh
make MODULE=decoder PROFILE=outputs_3 flow-config-check
make MODULE=decoder PROFILE=outputs_3 clean open-source
```

Run all qualified parameter profiles with:

```sh
make MODULE=decoder clean all-profiles PROFILE_JOBS=4
```
