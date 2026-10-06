# Priority encoder documentation

The `priority_encoder` module selects one asserted request using a fixed
elaboration-time priority direction and reports binary, one-hot, valid, and
multiple-request results.

- [Interface specification](interface.md)
- [Verification plan](verification-plan.md)
- [Release checklist](release-checklist.md)
- [Reviewed waivers](waivers.md)

Run the initial portable qualification from the repository root:

```sh
make MODULE=priority_encoder clean open-source
```

The portable release uses Yosys for technology-independent structural
qualification. It does not claim library-mapped timing, power, or area signoff.
Design Compiler, PrimeTime, and PrimePower become integration requirements after
the consuming design selects a PDK, libraries, operating corners, constraints,
and representative switching activity.

Standalone physical implementation is outside the portable leaf scope. The
Nangate45 OpenROAD configuration is preliminary collateral only. Placement,
fanout, routing, timing, and physical verification must be performed with the
launching registers, request sources, output loads, and arbitration consumers.
