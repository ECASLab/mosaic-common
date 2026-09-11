# Level shifter documentation

The `level_shifter` module is a technology-independent, non-inverting model of a
unidirectional voltage-domain crossing. The RTL assignment is functional
simulation behavior and is not evidence of electrical voltage translation.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run the portable qualification from the repository root:

```sh
make MODULE=level_shifter clean open-source
make MODULE=level_shifter constraint-check
make MODULE=level_shifter assertion-coverage
make MODULE=level_shifter four-state-check
```

An ASIC integration must use approved characterized level-shifter cells and
qualify insertion, direction, supplies, legal power states, timing, power, and
physical connectivity with the final UPF and libraries.

## Release boundary

The repository releases a portable architectural wrapper, not a fabricated
level-shifter cell. Yosys must preserve connectivity while reducing the default
wrapper to zero logic cells. Design Compiler, PrimeTime, PrimePower, and
technology-specific PPA are conditional integration gates because meaningful
results require both voltage libraries, inserted cells, neighboring registers,
physical parasitics, and representative activity. A portable `SKIP` must never
be reused as ASIC signoff evidence.
