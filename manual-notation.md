# ArgMap — Manual Version

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
  ↓ * claim_name (E)   "one-line note" [source]
[StateOut]
```

Chain of claims (composition):
```
[A]
  ↓ ? claim_one (T)   "note" [source-1]
[B]
  ↓ ~ claim_two (E)   "note" [source-2]
[C]
  ↓ * claim_three (R) "note" [source-3]
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
  ↓ * claim_one (R)    "background — what everyone accepts" [Source-1, source-2]
[IntermediateState]
  ↓ ? claim_two (E)    "load-bearing — each cited position needs support"
[ContestedTerritory]
  ↓ ~ claim_three (!)  "author's inference — naked assertion, no cite needed"
[ExitState]
```

If you cannot draw an unbroken path from `entry` to `exit`, the section has a structural gap. Fix the gap before writing prose.

---

## Identifier naming

Section and subsection transitions in the paper-level chain use stable string identifiers — never numeric labels. Numeric labels break whenever a section is inserted, reordered, or removed. Identifiers remain valid across all such changes.

**Prefix convention**

| Level | Prefix | Example |
|-------|--------|---------|
| Top-level section | `sec_` | `sec_oc_approaches` |
| Subsection | `subsec_` | `subsec_wakef_states` |

**Forming a name** — take the shortest unambiguous snake_case string from the title. Drop articles, prepositions, and generic words (`and`, `the`, `of`, `as`). Keep the load-bearing content words. Aim for 2–4 tokens.

```
"Wakefulness states reorganize coordination"  →  subsec_wakef_states
"Sensory modalities structure wakeful coord." →  subsec_sens_modal
"Altered states as reconfigurations"          →  subsec_altered_states
"Social coordination and what deficits reveal"→  subsec_soc_coord
```

**Inline annotation** — append the full title after ` — ` as a human-readable comment. The identifier is the stable key; the title is documentation.

```
↓ subsec_wakef_states — Wakefulness states reorganize coordination
```

Claim names follow the same snake_case convention without a prefix (they are not sections):

```
↓ * wakefulness_treated_as_scalar (!) "..."
```

---

## Paper-level syntax

A full paper is a chain of sections. Each section's exit state must match the next section's entry state — this is the functoriality condition written by hand. Use `sec_` identifiers, not numeric labels.

```
=== PAPER TITLE ===

[InitialReaderState]
  ↓ sec_introduction — Introduction
[FieldEstablished ⊗ Puzzle]
  ↓ sec_background — Background / Prior Work
[BackgroundEstablished]
  ↓ sec_core_argument — Core Argument
[ThesisEstablished]
  ↓ sec_elaboration — Elaboration / Evidence
[ThesisDeveloped]
  ↓ sec_discussion — Discussion
[ImplicationsDrawn]
  ↓ sec_conclusion — Conclusion
[Implication]
```

For a review paper, `Corpus` and `Gap` are first-class states:

```
=== REVIEW PAPER TITLE ===

[InitialReaderState]
  ↓ sec_intro_scope — Introduction + Scope
[SearchScope]
  ↓ sec_lit_survey — Literature Survey
[Corpus]
  ↓ sec_thematic — Thematic Analysis   (one pass per theme)
[ThematicStructure]
  ↓ sec_synthesis — Synthesis + Gaps
[Synthesis ⊗ Gap]
  ↓ sec_future — Future Directions
[Implication]
```

A paper with subsections uses `subsec_` for the inner chain:

```
[BackgroundEstablished]
  ↓ sec_oc_approaches — Organism-centric approaches

    [OC_Base]
      ↓ subsec_oscillation — Oscillation
    [OscillationEstablished]
      ↓ subsec_wakef_states — Wakefulness states reorganize coordination
    [WakefulnessConceptEstablished]
      ↓ subsec_altered_states — Altered states as reconfigurations
    [AlteredStatesFramed]

[OC_Established]
```

---

## Zoom relation (functoriality on paper)

A section at the paper level can be "zoomed into" to reveal its internal claim chain. The zoom is valid if the internal chain's entry/exit states match the section's entry/exit at the paper level. The identifier in the paper-level chain is the same identifier used as the section header in the zoom.

```
sec_core_argument — Core Argument
  entry:  [BackgroundEstablished]
  exit:   [ThesisEstablished]
  zoom ↓
    [BackgroundEstablished]
      ↓ ? claim_one (T)
    [IntermediateState]
      ↓ ? claim_two (E)
    [AnotherState]
      ↓ * claim_three (R)
    [ThesisEstablished]   ← must match exit above
```

If the zoomed chain does not reach `[ThesisEstablished]`, the section does not fulfil its promise at the paper level.

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

Work top-to-bottom along the status ladder. Never write prose for a claim whose upstream states are still stubs — fix topology first, then write.

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
