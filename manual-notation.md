# Argument Notation — Manual Version

A paper-and-pencil syntax for structuring academic arguments. Functionally equivalent to the categorical code version: states are objects, claims are morphisms, chains compose, and the zoom relation between levels mirrors functoriality.

---

## Core symbols

| Symbol | Meaning |
|--------|---------|
| `[State]` | Reader knowledge state — what the reader holds as true at this point |
| `↓ claim` | Claim: advances reader from the state above to the state below |
| `⊗` | Both states required simultaneously (parallel input wires) |
| `(E)` `(T)` `(R)` | Literature type: **E**mpirical / **T**heoretical / **R**eview |
| `(!)` | Naked assertion — no literature support; flags a gap |
| `?` `~` `*` `✓` | Status: **stub** / **drafted** / **cited** / **complete** |

---

## Claim syntax

Single claim:
```
[StateIn]
  ↓ * claim_name (E)   "one-line note or source"
[StateOut]
```

Chain of claims (composition):
```
[A]
  ↓ ? claim_one (T)   "note"
[B]
  ↓ ~ claim_two (E)   "note"
[C]
  ↓ * claim_three (R) "note"
[D]
```

Parallel inputs (tensor product `⊗`):
```
[A] ⊗ [B]
  ↓ * claim_name (T)
[C]
```

---

## Section syntax

A section is a named chain with a declared entry and exit state. The chain must be unbroken — this is the coherence check you perform by eye.

```
=== SECTION TITLE ===
entry:  [EntryState]
exit:   [ExitState]

[EntryState]
  ↓ * claim_one (R)    "background — what everyone accepts"
[IntermediateState]
  ↓ ? claim_two (E)    "load-bearing — each cited position needs support"
[ContestedTerritory]
  ↓ ~ claim_three (!)  "author's inference — naked assertion, no cite needed"
[ExitState]
```

If you cannot draw an unbroken path from `entry` to `exit`, the section has a structural gap. Fix the gap before writing prose.

---

## Paper-level syntax

A full paper is a chain of sections. Each section's exit state must match the next section's entry state — this is the functoriality condition written by hand.

```
=== PAPER TITLE ===

[InitialReaderState]
  ↓ SECTION 1: Introduction
[SharedKnowledge ⊗ Puzzle]
  ↓ SECTION 2: NC Approaches
[NCApproachEstablished]
  ↓ SECTION 3: OC Approaches
[OCFrameworkEstablished]
  ↓ SECTION 4: OC informs NC
[SynergyMotivated]
  ↓ SECTION 5: Points of Synergy
[SynergyDemonstrated]
  ↓ SECTION 6: Conclusion
[ImplicationEstablished]
```

---

## Zoom relation (functoriality on paper)

A section at the paper level can be "zoomed into" to reveal its internal claim chain. The zoom is valid if the internal chain's entry/exit states match the section's entry/exit at the paper level.

```
SECTION 3: OC Approaches
  entry:  [NCApproachEstablished]
  exit:   [OCFrameworkEstablished]
  zoom ↓
    [NCApproachEstablished]
      ↓ ? oc_gradient_view (T)
    [GradientView]
      ↓ ? epistemic_limits (R)
    [EpistemicLimits]
      ↓ * hard_problem_framing (R)
    [HardProblemContext]
      ...
    [OCFrameworkEstablished]   ← must match exit above
```

If the zoomed chain does not reach `[OCFrameworkEstablished]`, the section does not fulfil its promise at the paper level.

---

## Literature annotation

Collect citations per claim at the end of the section draft:

```
CITATIONS
  claim_one      (R): Nagel1974, Chalmers1995
  claim_two      (E): CrickKoch1998, Lamme2005
  claim_three    (T): Friston2010
```

Naked assertions `(!)` appear here with no entries — they are the claims that need a literature search or need to be reframed as inferences.

---

## Status workflow

Work left-to-right across the status ladder. Never write prose for a claim whose upstream states are still stubs — fix topology first, then write.

```
?  stub     — note exists, claim not yet formulated
~  drafted  — prose written, citation not yet inserted
*  cited    — citation present, not yet verified
✓  complete — verified, fits in chain
```

---

## Minimal working example (section draft on index cards)

Each index card = one claim:

```
┌─────────────────────────────────────────┐
│ from:   [GroupDynamics]                 │
│ claim:  oscillation_is_automatic        │
│ to:     [OscillationPhysics]            │
│ lit:    (T) Buzsaki2006                 │
│ status: ?                               │
│ note:   "synchronized groups produce   │
│          waves automatically —          │
│          physical principle"            │
└─────────────────────────────────────────┘
```

Lay cards on a table in order. An unbroken chain from the section's entry card to its exit card means the section is structurally ready to write.
