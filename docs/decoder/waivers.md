# Reviewed waivers

[Return to the module documentation index](README.md).

Each waiver must record the tool and rule, affected object, technical
justification, evidence, owner, reviewer, creation date, and removal condition.

## Accepted waivers

```text
ID: DEC-CI-001
Tool and rule: GitHub Actions hosted execution and release-artifact retention
Affected file and object: Open-source RTL quality gate runs 35551308160 and 35551684468 for module revision 0ace8134770d8d22d824a0f4bd46b14500e9f6d7
Technical justification: GitHub rejected both runs before their first step because recent account payments failed or the spending limit must be increased. No module, profile, tool, or workflow command executed or failed. The exact 38-entry native and container module-profile matrix, representative coverage steps, required OpenROAD steps, and all native and container release-manifest validations pass locally with the pinned methodology and Docker image.
Evidence: GitHub check-run annotations 106186451597 and 106187468422, ci-artifacts/local-native, ci-artifacts/local-native-special, ci-artifacts/local-container, ci-artifacts/local-container-special, reports, and work
Owner: module-maintainers and repository infrastructure owner
Reviewer: Erick Andres Obregon Fonseca
Created: 2026-09-20
Approved: 2026-09-20
Expires or removal condition: Re-run the complete hosted workflow and record its artifact IDs and retention dates when GitHub Actions billing or spending capacity is restored.
```

Generated waiver drafts are diagnostic suggestions and are not approved policy.
