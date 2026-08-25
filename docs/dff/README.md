# DFF documentation

[Return to the repository README](../../README.md).

This directory contains the design-owned contract and evidence policy for
`mosaic_dff`.

## Documents

1. [Interface specification](interface.md) defines parameters, ports, behavior,
   timing, reset semantics, and integration assumptions.
2. [Verification plan](verification-plan.md) maps requirements to simulation,
   assertions, formal proof, synthesis, and equivalence evidence.
3. [Reviewed waivers](waivers.md) records approved tool exceptions. The current
   design uses no source or lint waiver.
4. [Release checklist](release-checklist.md) defines the evidence required before
   publishing a reusable revision.

Shared orchestration and tool-adapter behavior is documented by the pinned
[`mosaic-flow`](../../mosaic-flow/docs/README.md) methodology.

Generated reports are evidence for the exact source and tool revisions that
produced them. They do not constitute release approval by themselves.
