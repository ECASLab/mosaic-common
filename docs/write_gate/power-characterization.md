# Power Characterization

[Return to the module documentation index](README.md).

## Portable Activity Evidence

The open-source regression measures activity at representative stateful
destinations rather than relying only on `o_write_enable` toggles. It compares
an ungated reference with gated register and memory models and records:

- Original write events accepted by the reference destination
- Write events accepted by the gated destination
- Architectural state-bit transitions in both destinations
- State equivalence after every accepted transaction

Stimulus includes no suppression, partial suppression, complete suppression,
short intervals, long suppression intervals, random masks, every supported
width, and both register and memory destinations. The regression fails unless
gated destination write events decrease while architectural state transitions
remain equal. Results use the `WRITE_GATE_ACTIVITY` prefix in the Verilator
simulation report.

These event counts demonstrate useful suppression and validate the activity
model. They are not a cell-library power estimate and must not be reported as
energy savings.

## Integration Signoff

PrimePower signoff remains mandatory in the first consuming integration that
contains the actual register file, memory macro, counter, or write network. The
integration must use annotated activity for an equivalent ungated baseline and
the gated design under the same workload. Reports must separate write-gate
logic, write-enable distribution, destination internal power, suppression
control generation, leakage, and total power.

PrimeTime must verify the request-to-write-enable,
suppression-to-write-enable, and suppressed-indication paths against the
destination setup decision. CDC, RDC, DFT, and VC LP must use the consuming
clock, reset, test, and power-domain context. Until those reports exist, their
status is reviewed `SKIP` or `NOT_RUN` at this technology-independent leaf and
does not block its portable release. The reports remain mandatory before the
consumer can claim integration signoff or technology-specific power savings.
