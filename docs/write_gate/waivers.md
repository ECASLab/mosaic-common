# Reviewed Waivers

[Return to the module documentation index](README.md).

No waiver is currently approved for `write_gate`.

Commercial CDC, RDC, DFT, VC LP, PrimeTime, and PrimePower results are deferred
to the first stateful consuming integration. They are reported as `NOT_RUN` or
`SKIP`, never as passing standalone results, and are therefore not waivers from
the integration release criteria. These reviewed skips close only the portable
leaf release scope.

Foundry physical signoff is deferred under the same rule. The passing Nangate45
OpenROAD implementation is diagnostic evidence and must not be represented as
foundry DRC, LVS, extraction, timing, or power signoff.
