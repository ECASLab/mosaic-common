# Power characterization

[Return to the module documentation index](README.md).

## Portable claim

The decoder suppresses output activity while `i_enable` is low. Functional
verification proves that selection changes cannot activate a decoded output in
that state.

No standalone energy-saving number is claimed. Dynamic power depends on output
count, selection distribution, fanout, glitches, physical mapping, voltage,
frequency, and downstream capacitance.

## Integration measurements

A consuming project that claims power savings must compare enabled and disabled
activity with representative workloads and retain:

- Mapped technology and operating corner
- Input and output loads
- Selection and enable activity distributions
- SAIF hierarchy and annotation coverage
- Internal, switching, leakage, and total power
- Timing and area effects of the enable path

PrimePower is an integration-level requirement once these inputs exist. The
portable leaf release must not relabel generic synthesis or toggle coverage as
technology-specific power evidence.
