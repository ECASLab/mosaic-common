# Reset synchronizer documentation

The `reset_synchronizer` module asynchronously asserts an active-low reset and
synchronously releases it into one destination clock domain. The portable RTL
uses a preserved `ASYNC_REG` chain with no functional bypass.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run the portable qualification from the repository root:

```sh
make MODULE=reset_synchronizer clean open-source
make MODULE=reset_synchronizer constraint-check
make MODULE=reset_synchronizer assertion-coverage
make MODULE=reset_synchronizer fault-injection
make MODULE=reset_synchronizer four-state-check
make MODULE=reset_synchronizer release-manifest
```

The CI container runs the same sequence with the pinned `mosaic-flow` revision.
CDC/RDC signoff remains an ASIC-integration requirement because it depends on
the reset network and consuming destination domain.
