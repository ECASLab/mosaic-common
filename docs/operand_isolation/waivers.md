# Reviewed Waivers

[Return to the module documentation index](README.md).

Each accepted waiver must identify the tool, rule, affected object, technical
justification, evidence, owner, reviewer, creation date, and expiration or
removal condition.

## Accepted Waivers

```text
ID: OI-COV-001
Tool and rule: mosaic-flow coverage qualification, RTL line coverage
Affected file and object: rtl/operand_isolation.sv line 27, unknown-control default arm
Technical justification: Verilator coverage runs in binary simulation and cannot execute an X/Z control arm. Dedicated Icarus campaigns prove X and Z output propagation and assertion detection.
Evidence: reports/operand_isolation/width_1_zero/four_state_qualification and config/qualification-campaigns/operand_isolation.json
Owner: module-maintainers
Reviewer: Erick Andres Obregon Fonseca
Created: 2026-09-20
Approved: 2026-09-20
Expires or removal condition: Remove when the qualified coverage source records four-state RTL line execution.
```

## Integration Deferrals

Standalone CDC, RDC, DFT, VC LP, Design Compiler, PrimeTime, PrimePower, and
physical signoff are not represented as passing leaf checks. They require the
consuming datapath and its technology, clock, reset, test, power-state, and
activity context. Their leaf policy status is `SKIP`, and the transferred
requirements remain mandatory before an integration can claim signoff or power
savings.
