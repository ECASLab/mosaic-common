# Isolation Cell

The `isolation_cell` module is a parameterizable, technology-independent RTL
model of a unidirectional power-domain isolation boundary.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

```sh
make MODULE=isolation_cell clean open-source
make MODULE=isolation_cell constraint-check assertion-coverage fault-injection four-state-check
make MODULE=isolation_cell release-manifest
```

Portable RTL evidence does not qualify physical isolation insertion. A
power-gated integration additionally requires approved cells, libraries, power
states, UPF, power-aware simulation, VC LP, timing, DFT, and physical signoff.
