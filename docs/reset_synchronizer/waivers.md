# Reviewed waivers

[Return to the module documentation index](README.md).

No waiver is currently approved for `reset_synchronizer`.

The two-state Verilator limitation for unknown-input testing is not a waiver.
The required four-state evidence is provided by
`make MODULE=reset_synchronizer four-state-check` using Icarus.

Design Compiler, PrimeTime, PrimePower, and OpenROAD are approved scope skips,
not waivers. Their technology-specific checks are owned by the consuming ASIC
integration.

VC CDC and SpyGlass CDC are disabled only for the portable leaf release. One
approved CDC/RDC engine is mandatory at the first integration level containing
the reset source, synchronizer, destination clock domain, and consumers.
SpyGlass DFT is owned by the complete MOSAIC/SoC test architecture. VC LP is
required only when the documented switchable-domain or multi-voltage conditions
apply. These scope decisions are not waivers from their integration requirements.
