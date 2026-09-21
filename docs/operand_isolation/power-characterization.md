# Power Characterization

[Return to the module documentation index](README.md).

## Portable Activity Evidence

The open-source regression compares equivalent downstream combinational cones
driven directly by `i_data` and through `operand_isolation`. It exercises three
representative classes:

- Arithmetic preprocessing
- Vector bit manipulation
- Address-generation arithmetic

The test alternates active and isolated intervals while input data continues to
change. It checks functional equality in every active interval and fails unless
the isolated cone records fewer output-bit transitions than its ungated
baseline. Results use the `OPERAND_ISOLATION_ACTIVITY` prefix in the simulation
report.

These transition counts validate useful suppression and stimulus quality. They
are not a library-based power estimate and must not be reported as energy
savings.

## Integration Signoff

The consuming implementation must compare isolated and equivalent ungated
designs using the same workload and annotated activity. PrimePower or an
approved alternative must include:

- Isolation logic internal power
- Isolation-control generation and distribution
- Downstream combinational internal and switching power
- Leakage and total power
- Activity annotation coverage

PrimeTime must close both operand and isolation-control paths to the downstream
capture point. CDC, RDC, DFT, and VC LP must use the consuming hierarchy and
must not credit this block as a required power-domain isolation cell.
