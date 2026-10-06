# Lane mask documentation

The `lane_mask` module combines global operation validity, per-lane validity,
an architectural lane mask, and predicates into canonical execution, isolation,
and base write-mask controls.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run the initial portable qualification from the repository root:

```sh
make MODULE=lane_mask clean open-source
```
