# Counter documentation

The `counter` module is a reusable parameterizable up/down binary counter with
load, clear, saturating or wrapping arithmetic, boundary events, and a
direction-aware terminal indication.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run its current portable gate from the repository root:

```sh
make MODULE=counter clean open-source
make MODULE=counter release-manifest
```
