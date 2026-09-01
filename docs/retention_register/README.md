# Retention Register

`retention_register` is a parameterizable portable model of visible sequential
state and an explicitly saved retention image.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

```sh
make MODULE=retention_register clean open-source
make MODULE=retention_register release-manifest
```

Ordinary flip-flops inferred from this model are not physical retention cells.
A power-gated release requires technology binding, a valid retention supply,
power-aware verification, VC LP, DFT, timing, power, and physical signoff.
