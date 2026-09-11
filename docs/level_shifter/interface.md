# Interface specification

[Return to the repository README](../../README.md).

## Overview

`level_shifter` preserves a digital vector across a declared unidirectional
voltage-domain boundary. It has no clock, reset, state, handshake, or isolation
behavior.

## Parameters

| Parameter | Default | Legal values | Description |
|---|---:|---|---|
| `WIDTH` | `1` | Integers greater than or equal to `1` | Number of shifted bits |
| `DIRECTION` | `0` | `0` or `1` | `0`: low-to-high, `1`: high-to-low |

## Ports

| Port | Direction | Width | Description |
|---|---|---:|---|
| `i_data` | Input | `WIDTH` | Source-domain data |
| `o_data` | Output | `WIDTH` | Destination-domain data |

## Functional contract

When both domains are powered and stable, `o_data` equals `i_data` bit for bit,
including `X` and `Z` values in four-state simulation. Direction is static design
intent and does not select a runtime datapath.

The module introduces zero architectural cycles of latency. Cell and interconnect
delay must come from the characterized implementation library, never from RTL.

## Integration contract

- UPF or an explicit technology-binding layer must map every bit to an approved
  level-shifter cell exactly once.
- Source and destination domains, voltage ranges, direction, supplies, cell set,
  location, and legal power states must be documented.
- The wrapper does not provide isolation. A switchable source requires a separate
  isolation strategy or an approved combined cell.
- Voltage translation does not provide CDC or reset-domain synchronization.
- Multi-bit ordering must be preserved, and timing-sensitive buses require a
  reviewed skew constraint.
- VC LP or an equivalent qualified low-power checker is mandatory at the first
  integration containing both voltage domains and the inserted cells.

## Portable power profile

The baseline UPF defines separate source and destination supplies at nominal
0.8 V and 1.0 V, one legal `BOTH_ON` state, a bidirectional insertion rule, and
destination-side placement. These values qualify portable intent only and must
be replaced by characterized project voltage pairs. The profile intentionally
contains no isolation or retention because both domains remain on.

## Physical integration contract

- Map each signal bit to exactly one approved level-shifter cell, or use an
  approved multi-bit cell with demonstrably preserved bit ordering.
- Place inserted cells at the destination-domain boundary unless the selected
  technology library requires another documented location.
- Connect and verify both characterized supply rails. Combined
  isolation-level-shifter cells must also receive the required always-on
  controls and supplies.
- Retain low-power checks showing complete insertion coverage, legal direction,
  correct voltage-domain crossings, and no unintended optimization around the
  cells.
- Use characterized timing arcs for static timing analysis and constrain skew
  where a shifted vector has a timing relationship between bits.
- Retain placement, routing, power-connectivity, DRC, and LVS evidence from the
  representative multi-voltage integration.

The supplied Nangate45 OpenROAD configuration exercises flow plumbing only. It
does not contain characterized voltage translation cells or dual-voltage power
delivery and therefore cannot provide physical signoff evidence for this block.
