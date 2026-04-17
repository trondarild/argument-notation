# Argument Notation

A notation system for structuring academic arguments before writing them. The core idea: model a paper as a graph where **nodes are reader knowledge states** and **edges are claims** that advance the reader from one state to the next. Making this structure explicit before writing prose exposes gaps, unsupported assertions, and ordering problems early.

Two versions are provided: a **code version** built on category theory (Julia + Catlab) for generating diagrams and managing bibliography, and a **manual version** for paper-and-pencil work with the same underlying logic.

---

## The key idea

Every claim in a paper presupposes something the reader already knows and establishes something new. Writing is hard when these dependencies are implicit. The notation makes them explicit:

```
[SharedKnowledge]
  ↓ * background_survey (R)    "field surveys, canonical frameworks"
[FieldEstablished]
  ↓ ? gap_identification (!)   "author's inference — no citation needed"
[Puzzle]
```

An unbroken chain from a section's entry state to its exit state means the section is structurally ready to write. A gap or a floating node means something is missing.

Unsupported claims are flagged by `(!)` — they have no literature wire, making naked assertions visible before submission rather than during review.

---

## Supported paper types

### Empirical / scientific paper

Standard hypothesis-driven structure: context → gap → hypothesis → evidence → result → conclusion. Literature wires on methodology and analysis; discussion is inference.

### Philosophical / theoretical paper

Dialectical structure: background survey → contested territory → gap identification → dialectic (position survey) → proposal → elaboration → defense → conclusion. Three distinct literature types reflect different evidentiary roles: review lit settles shared ground, empirical lit is load-bearing in the contested survey, theoretical lit grounds the dialectic.

### Review paper

Literature is the primary input throughout, not supporting evidence for claims. Key structural differences:

- **Scope definition** makes inclusion/exclusion criteria explicit before collection
- **Thematic analysis** is iterative — the same corpus wire passes through once per theme, each requiring its own literature slice; adding a theme means adding one morphism
- **Gap analysis** is a first-class output, not incidental — the paper cannot reach its conclusion without producing a `Gap` wire, enforcing that identifying gaps is mandatory

```
[Background]
  ↓ framing
[ResearchQuestion ⊗ Background]
  ↓ scope_definition
[SearchScope]
  ↓ literature_collection (R)
[Corpus]
  ↓ thematic_analysis (R)   ← repeat per theme
[Corpus ⊗ Theme]
  ↓ thematic_structure
[ThematicStructure]
  ↓ cross_theme_synthesis
[Synthesis ⊗ Gap]
  ↓ gap_analysis
[Synthesis ⊗ Agenda]
  ↓ future_directions
[Implication]
```

---

## Manual version

No software required. Full syntax in [`manual-notation.md`](manual-notation.md).

### Symbols at a glance

| Symbol | Meaning |
|--------|---------|
| `[State]` | Reader knowledge state |
| `↓ claim` | Claim advancing reader from state above to state below |
| `⊗` | Both states required as input |
| `(E)` `(T)` `(R)` | Empirical / Theoretical / Review literature |
| `(!)` | Naked assertion — no literature support |
| `?` `~` `*` `✓` | Stub / Drafted / Cited / Complete |

### Workflow

1. List your notes or fragments
2. For each note, write: what must the reader already know (`from`) and what do they know after (`to`)
3. Arrange as a vertical chain — check for gaps
4. Naked assertions `(!)` flag where you need a citation or need to reframe as inference
5. Write prose in chain order, starting from the first `?` stub whose upstream is complete

### Section draft (paper and pencil)

```
=== SECTION TITLE ===
entry:  [EntryState]
exit:   [ExitState]

[EntryState]
  ↓ ? claim_one (T)    "note on what this claim does"
[IntermediateState]
  ↓ * claim_two (R)    "note"
[ExitState]
```

### Paper-level structure

Sections chain the same way claims do. Each section's exit state must equal the next section's entry state — this is the coherence check at the paper level.

```
[InitialReaderState]
  ↓ SECTION 1: Introduction
[FieldEstablished ⊗ Puzzle]
  ↓ SECTION 2: ...
[SectionTwoExit]
  ↓ SECTION 3: ...
  ...
[Implication]
```

---

## Code version

Generates SVG argument diagrams and manages bibliography. Built on [Catlab.jl](https://algebraicjulia.github.io/Catlab.jl/).

### Requirements

- Julia 1.9+
- Graphviz (`brew install graphviz`)
- Julia packages: `Catlab`, `GATlab`

```julia
# Install packages (once, from Julia REPL)
using Pkg; Pkg.add(["Catlab", "GATlab"])
```

### Running

```bash
# Generic schema diagrams (scientific, philosophical, review)
julia src/notation-examples.jl

# Paper-specific driver (add your own paper file here)
julia src/your-paper.jl
```

Diagrams are saved as SVGs in `out/`.

### File layout

```
src/
  notation-gat.jl        library — schemas, SectionDraft, BibRegistry, save_diagram
  notation-examples.jl   generates documentation diagrams for all generic schemas
  your-paper.jl          paper-specific schema, registry, section drafts
papers/                  source documents being notated
out/                     generated diagrams and text (do not edit by hand)
manual-notation.md       paper-and-pencil syntax reference
```

### Diagram status colours

| Colour | Status |
|--------|--------|
| Yellow | Stub — not yet written |
| Blue | Drafted — prose written, no citation |
| Peach | Cited — citation present |
| Pale green | Complete |

### Adding a new paper

1. Create `src/your-paper.jl`, include `notation-gat.jl`
2. Add a `@present YourPaper(FreeSymmetricMonoidalCategory)` block — sections as typed morphisms
3. Wire a `@program` outline
4. Create a `BibRegistry` mapping morphism names to `BibEntry` values
5. Add a `SectionDraft` for any section under active development
6. Call `save_diagram` and `save_section_diagram` to produce output

### Bibliography pipeline

The `BibRegistry` maps morphism names to cite keys matching your `.bib` file:

```julia
render_citations(registry, :background_survey)  # → \cite{key1,key2,...}
all_cite_keys(registry)                          # → minimal key list for bibtool filtering
print_bib_summary(registry)                      # → full annotated listing
```

---

## Concepts

**Reader state** — what the reader holds as established at a given point. Every claim has a presupposed state (input) and an established state (output). Matching these across claims gives you the reading order.

**Claim** — a morphism from one reader state to another. In code: a `ClaimStub`. On paper: an annotated arrow.

**Literature wire** — typed evidence attached to a claim. Missing wire = naked assertion, visible in both the diagram and the status report.

**Zoom / functoriality** — a section at the paper level can be zoomed into its claim-level chain. The zoom is valid if the chain's entry and exit states match the section's declared entry and exit. This is the paper-and-pencil equivalent of a structure-preserving functor between levels.
