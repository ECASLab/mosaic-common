# Clock-gate documentation

The `clock_gate` module is a technology-independent glitch-free clock-gating
wrapper with functional and test enables. Its portable latch-and-AND model must
be mapped to an approved integrated clock-gating cell for ASIC implementation.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run the current portable gate from the repository root:

```sh
make MODULE=clock_gate clean open-source
make MODULE=clock_gate assertion-coverage
make MODULE=clock_gate fault-injection
make MODULE=clock_gate openroad-container
make MODULE=clock_gate release-manifest
```
