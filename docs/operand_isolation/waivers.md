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

```text
ID: OI-CI-001
Tool and rule: GitHub Actions hosted execution and release-artifact retention
Affected file and object: Open-source RTL quality gate runs 35545096382 and 35545136959 for module revision 5c188f974296c2ca60f348a31ac305c1ec8bc5fb
Technical justification: GitHub rejected both runs before their first step because recent account payments failed or the spending limit must be increased. No module, profile, tool, or workflow command executed or failed. The exact 30-entry native and container module-profile matrix, module-specific OpenROAD and coverage steps, and all native and container release-manifest validations pass locally with the pinned methodology and Docker image.
Evidence: GitHub check-run annotations 106169472290 and 106169577949, ci-artifacts/local-native, ci-artifacts/local-native-special, ci-artifacts/local-container, ci-artifacts/local-container-special, reports, and work
Owner: module-maintainers and repository infrastructure owner
Reviewer: Erick Andres Obregon Fonseca
Created: 2026-09-20
Approved: 2026-09-20
Expires or removal condition: Re-run the complete hosted workflow and record its artifact IDs and retention dates when GitHub Actions billing or spending capacity is restored.
```

## Integration Deferrals

Standalone CDC, RDC, DFT, VC LP, Design Compiler, PrimeTime, PrimePower, and
physical signoff are not represented as passing leaf checks. They require the
consuming datapath and its technology, clock, reset, test, power-state, and
activity context. Their leaf policy status is `SKIP`, and the transferred
requirements remain mandatory before an integration can claim signoff or power
savings.
