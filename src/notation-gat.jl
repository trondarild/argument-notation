################################################################################
# CATEGORICAL PAPER ARCHITECT: LENS-BASED NARRATIVE COMPOSITION
# Library: Catlab.jl
################################################################################

using GATlab
using Catlab
using Catlab.Theories
using Catlab.CategoricalAlgebra
using Catlab.Graphics
using Catlab.Graphics: Graphviz
using Catlab.WiringDiagrams
using Catlab.Programs

# Narrative lens model: objects = (ForwardState, BackwardState) pairs
# where ForwardState = what the reader knows, BackwardState = what they expect.
# Morphisms = sections/arguments. Implemented as presentations over
# FreeSymmetricMonoidalCategory — no custom @theory needed.

# 2. Define the Presentation (Your "Article Schema")
# This is the 'Text-based version' you requested. 
# You define the "Unity" of the paper by wiring these sections together.

@present ScientificPaper(FreeSymmetricMonoidalCategory) begin
    # Types of Information (States)
    (Context, Gap, Hypothesis, Evidence, Result, Conclusion)::Ob
    (Feedback, Refinement, Validation)::Ob

    # Sections modeled as Morphisms
    # Syntax: section_name::Hom(Input_Wires, Output_Wires)
    
    introduction::Hom(Context, Gap ⊗ Context)
    
    # Methodology takes the Gap and produces a Hypothesis
    methodology::Hom(Gap ⊗ Context, Hypothesis ⊗ Evidence)
    
    # Analysis produces Results but sends back 'Refinement' 
    # to check if the Hypothesis held up
    analysis::Hom(Hypothesis ⊗ Evidence, Result)
    
    # Discussion turns Results into Conclusions 
    # and provides the 'Validation' that flows back to the Introduction
    discussion::Hom(Result, Conclusion ⊗ Validation)
end

# 3. Constructing the "Unity" of the Paper
# We use the @program macro to describe the 'program' of your paper.
# This creates a wiring diagram that acts as your argument graph.

paper_outline = @program ScientificPaper (c::Context) begin
    # The Introduction sets the stage
    g, ctx = introduction(c)
    
    # The Methodology uses that stage to create Evidence
    h, e = methodology(g, ctx)
    
    # The Analysis processes the Evidence
    r = analysis(h, e)
    
    # The Discussion yields the final Conclusion
    concl, val = discussion(r)
    
    # We "yield" the conclusion and the validation wire
    return concl, val
end

# 4. Visualization and Utility Functions
# This allows you to "see" the unity and check for disconnected logic.

function visualize_paper(outline)
    to_graphviz(outline, 
        orientation=TopToBottom, 
        labels=true, 
        node_attrs=Dict(:shape => "box", :style => "filled", :fillcolor => "lavender"))
end

# To use this: 
# 1. Run the script.
# 2. Call `visualize_paper(paper_outline)` to see the graph.
# 3. Add new 'Hom' definitions to ScientificPaper to add sub-arguments.

println("Paper Schema Loaded.")
println("Morphisms available: introduction, methodology, analysis, discussion.")

################################################################################
# PHILOSOPHICAL-THEORETICAL PAPER SCHEMA
# Dialectical structure: puzzle → dialectic → proposal → defense → implication
# Key difference from ScientificPaper: no empirical evidence/methodology;
# arguments proceed through conceptual analysis, objection-reply, and inference.
################################################################################

@present PhilosophicalPaper(FreeSymmetricMonoidalCategory) begin
    # Information states
    (Background, Puzzle, Position, Critique)::Ob
    (Thesis, Concept, Objection, Reply, Implication)::Ob

    # Framing: shared background generates the philosophical puzzle
    framing::Hom(Background, Puzzle ⊗ Background)

    # Dialectic: survey existing positions and expose their shortcomings
    dialectic::Hom(Puzzle ⊗ Background, Position ⊗ Critique)

    # Proposal: the critique motivates a new thesis and its key concepts
    proposal::Hom(Position ⊗ Critique, Thesis ⊗ Concept)

    # Elaboration: developing the thesis surfaces objections
    elaboration::Hom(Thesis ⊗ Concept, Thesis ⊗ Objection)

    # Defense: thesis survives by absorbing objections via replies
    defense::Hom(Thesis ⊗ Objection, Thesis ⊗ Reply)

    # Conclusion: surviving thesis yields implications (and residual reply for traceability)
    conclusion::Hom(Thesis ⊗ Reply, Implication)
end

phil_outline = @program PhilosophicalPaper (b::Background) begin
    puzzle, ctx   = framing(b)
    pos,   crit   = dialectic(puzzle, ctx)
    thesis, conc  = proposal(pos, crit)
    thesis2, obj  = elaboration(thesis, conc)
    thesis3, rep  = defense(thesis2, obj)
    impl          = conclusion(thesis3, rep)
    return impl
end

function visualize_phil_paper(outline)
    to_graphviz(outline,
        orientation=TopToBottom,
        labels=true,
        node_attrs=Dict(:shape => "box", :style => "filled", :fillcolor => "lightyellow"))
end

println("Philosophical Paper Schema Loaded.")
println("Morphisms available: framing, dialectic, proposal, elaboration, defense, conclusion.")

################################################################################
# CITATIONS AND BIBLIOGRAPHY INTEGRATION
# Literature enters as typed wires so unsupported claims are structurally
# visible in the diagram. BibRegistry maps each morphism to the .bib keys
# it consumes, keeping the argument graph and LaTeX pipeline in sync.
################################################################################

struct BibEntry
    key::String        # must match key in .bib file
    lit_type::Symbol   # :empirical | :review | :theoretical
    claim::String      # one-line note on what claim this supports
end

const BibRegistry = Dict{Symbol, Vector{BibEntry}}

# Extended philosophical schema with typed literature wires and a decomposed
# introduction. The introduction's three moves make reader-guiding explicit:
#   background_survey  — settles shared ground (review lit)
#   contested_survey   — maps where views diverge (empirical lit)
#   gap_identification — author's own inference; no citation wire needed

@present PhilosophicalPaperCited(FreeSymmetricMonoidalCategory) begin
    # Core information states
    (Background, SharedKnowledge, ContestedTerritory, Motivation)::Ob
    (Puzzle, Position, Critique, Thesis, Concept)::Ob
    (Objection, Reply, Implication)::Ob

    # Typed literature wires — a missing wire = a naked assertion in the diagram
    (EmpiricalLit, ReviewLit, TheoreticalLit)::Ob

    # ── Introduction (decomposed) ─────────────────────────────────────────────
    # ReviewLit pins down what everyone already accepts
    background_survey::Hom(Background ⊗ ReviewLit, SharedKnowledge ⊗ Background)

    # EmpiricalLit is load-bearing here: each cited position needs its wire
    contested_survey::Hom(SharedKnowledge ⊗ EmpiricalLit, ContestedTerritory)

    # Pure inference — no citation wire; gap follows from the tension
    gap_identification::Hom(ContestedTerritory, Puzzle ⊗ Motivation)

    # ── Body (same dialectical structure as PhilosophicalPaper) ───────────────
    # TheoreticalLit can enter dialectic to ground position survey
    dialectic::Hom(Puzzle ⊗ Background ⊗ TheoreticalLit, Position ⊗ Critique)
    proposal::Hom(Position ⊗ Critique ⊗ Motivation, Thesis ⊗ Concept)
    elaboration::Hom(Thesis ⊗ Concept, Thesis ⊗ Objection)
    defense::Hom(Thesis ⊗ Objection, Thesis ⊗ Reply)
    conclusion::Hom(Thesis ⊗ Reply, Implication)
end

phil_cited_outline = @program PhilosophicalPaperCited (
        b::Background,
        rl::ReviewLit,
        el::EmpiricalLit,
        tl::TheoreticalLit) begin
    sk, b2      = background_survey(b, rl)
    ct          = contested_survey(sk, el)
    puzzle, mot = gap_identification(ct)
    pos, crit   = dialectic(puzzle, b2, tl)
    thesis, con = proposal(pos, crit, mot)
    thesis2, obj = elaboration(thesis, con)
    thesis3, rep = defense(thesis2, obj)
    impl         = conclusion(thesis3, rep)
    return impl
end

function visualize_cited_paper(outline)
    to_graphviz(outline,
        orientation=TopToBottom,
        labels=true,
        node_attrs=Dict(:shape => "box", :style => "filled", :fillcolor => "lightcyan"))
end

# ── BibRegistry utilities ─────────────────────────────────────────────────────

# All unique cite keys referenced anywhere in the registry
function all_cite_keys(reg::BibRegistry)
    keys = String[]
    for entries in values(reg)
        append!(keys, e.key for e in entries)
    end
    unique(keys)
end

# LaTeX \cite{} string for a single morphism — drop into generated .tex source
function render_citations(reg::BibRegistry, morphism::Symbol)
    haskey(reg, morphism) || return ""
    "\\cite{" * join((e.key for e in reg[morphism]), ",") * "}"
end

# Print a summary of which morphisms cite what (for review / debugging)
function print_bib_summary(reg::BibRegistry)
    for (morphism, entries) in sort(collect(reg), by=first)
        println("$(morphism):")
        for e in entries
            println("  [$(e.lit_type)] $(e.key) — $(e.claim)")
        end
    end
end

println("\nPhilosophicalPaperCited Schema Loaded.")

################################################################################
# REVIEW PAPER SCHEMA
#
# Key structural differences from empirical and philosophical schemas:
#   • ReviewLit is the PRIMARY input — the paper is constituted by surveying
#     literature, not by generating hypotheses or dialectical positions
#   • Thematic analysis is ITERATIVE — the same corpus yields multiple Theme
#     wires in parallel, each requiring its own ReviewLit slice
#   • Gap analysis is a FIRST-CLASS output, not incidental to the argument;
#     the paper's contribution is precisely identifying what is missing
#   • No empirical evidence collection or philosophical dialectic
#
# Structure:
#   framing → scope_definition → literature_collection →
#   thematic_analysis (×N) → cross_theme_synthesis →
#   gap_analysis → future_directions
################################################################################

@present ReviewPaper(FreeSymmetricMonoidalCategory) begin
    # ── Information states ────────────────────────────────────────────────────
    (Background, ResearchQuestion, SearchScope)::Ob
    (Corpus, Theme, ThematicStructure, Synthesis)::Ob
    (Gap, Agenda, Implication)::Ob

    # ── Literature wires ──────────────────────────────────────────────────────
    (ReviewLit,)::Ob

    # ── Framing: motivate the review and sharpen the question ─────────────────
    framing::Hom(Background, ResearchQuestion ⊗ Background)

    # ── Scope: explicit inclusion/exclusion criteria ──────────────────────────
    # Background re-enters to anchor scope in domain knowledge
    scope_definition::Hom(ResearchQuestion ⊗ Background, SearchScope)

    # ── Collection: systematic retrieval produces the corpus ─────────────────
    literature_collection::Hom(SearchScope ⊗ ReviewLit, Corpus)

    # ── Thematic analysis: corpus → one Theme per analytical pass ─────────────
    # ReviewLit re-enters so each theme can cite its own subset of the corpus.
    # Repeat this morphism once per theme in the wiring diagram.
    thematic_analysis::Hom(Corpus ⊗ ReviewLit, Corpus ⊗ Theme)

    # ── Structural assembly: parallel Theme wires → ThematicStructure ─────────
    # In the wiring diagram, tensor all Theme outputs before passing here.
    thematic_structure::Hom(Corpus ⊗ Theme ⊗ Theme, ThematicStructure)

    # ── Cross-theme synthesis: patterns, tensions, convergences ──────────────
    cross_theme_synthesis::Hom(ThematicStructure, Synthesis ⊗ Gap)

    # ── Gap analysis: what the literature does not yet address ────────────────
    gap_analysis::Hom(Synthesis ⊗ Gap, Synthesis ⊗ Agenda)

    # ── Future directions: operationalise the agenda ──────────────────────────
    future_directions::Hom(Synthesis ⊗ Agenda, Implication)
end

# Two-theme example outline
review_outline = @program ReviewPaper (
        b   ::Background,
        rl1 ::ReviewLit,    # full corpus retrieval
        rl2 ::ReviewLit,    # literature for theme A
        rl3 ::ReviewLit) begin  # literature for theme B

    rq, b2           = framing(b)
    scope            = scope_definition(rq, b2)
    corpus           = literature_collection(scope, rl1)
    corpus2, theme_a = thematic_analysis(corpus,  rl2)
    corpus3, theme_b = thematic_analysis(corpus2, rl3)
    tstr             = thematic_structure(corpus3, theme_a, theme_b)
    synth, gap       = cross_theme_synthesis(tstr)
    synth2, agenda   = gap_analysis(synth, gap)
    impl             = future_directions(synth2, agenda)
    return impl
end

function visualize_review_paper(outline)
    to_graphviz(outline,
        orientation=TopToBottom,
        labels=true,
        node_attrs=Dict(:shape => "box", :style => "filled", :fillcolor => "lavenderblush"))
end

println("Review Paper Schema Loaded.")
println("Morphisms: framing, scope_definition, literature_collection, thematic_analysis, thematic_structure, cross_theme_synthesis, gap_analysis, future_directions")

################################################################################
# SECTION DRAFT — claim-level scaffolding for structuring jumbled notes
#
# A SectionDraft is a sequence of ClaimStubs, each modelled as a morphism:
#   claim :: ReaderState_in → ReaderState_out
#
# This makes the reading-order dependency graph explicit before any prose is
# written, and surfaces two classes of problems immediately:
#   • disconnected claims  — no upstream state feeds them (floating notes)
#   • naked assertions     — lit_type=:none with no literature wire
#
# Workflow: stub all claims → fix topology in diagram → write in order
# Status ladder: stub → drafted → cited → complete
################################################################################

@enum ClaimStatus stub drafted cited complete

struct ClaimStub
    name::Symbol
    from::Symbol       # reader state presupposed by this claim
    to::Symbol         # reader state established by this claim
    lit_type::Symbol   # :empirical | :theoretical | :review | :none
    status::ClaimStatus
    note::String       # source note (// comment or summary)
end

struct SectionDraft
    name::Symbol
    claims::Vector{ClaimStub}
end

function _status_color(s::ClaimStatus)
    s == stub     ? "lightyellow" :
    s == drafted  ? "lightblue"   :
    s == cited    ? "peachpuff"  :
                    "palegreen"
end

function section_to_dot(draft::SectionDraft)
    lines = [
        "digraph $(draft.name) {",
        "  rankdir=TB;",
        "  node [fontname=Courier, fontsize=10];",
        "  edge [fontname=Courier, fontsize=9];",
    ]
    states = unique(vcat([c.from for c in draft.claims], [c.to for c in draft.claims]))
    for s in states
        push!(lines, "  $s [shape=ellipse, style=filled, fillcolor=white];")
    end
    for c in draft.claims
        short = replace(first(c.note, 50), '"' => "'", '\n' => " ", '\\' => " ")
        length(c.note) > 50 && (short *= "...")
        lit = c.lit_type == :none ? "unsupported!" : string(c.lit_type)
        label = "$(c.name)\\n[$(c.status)] [$(lit)]\\n$(short)"
        color = _status_color(c.status)
        push!(lines, "  $(c.name) [shape=box, style=filled, fillcolor=\"$(color)\", label=\"$(label)\"];")
    end
    for c in draft.claims
        push!(lines, "  $(c.from) -> $(c.name);")
        push!(lines, "  $(c.name) -> $(c.to);")
    end
    push!(lines, """  subgraph cluster_legend {
    label="legend"; style=filled; fillcolor=white; fontname=Courier; fontsize=9;
    node [shape=box, style=filled, fontname=Courier, fontsize=9, width=1.1];
    edge [style=invis];
    l_stub     [label="stub",     fillcolor="lightyellow"];
    l_drafted  [label="drafted",  fillcolor="lightblue"];
    l_cited    [label="cited",    fillcolor="peachpuff"];
    l_complete [label="complete", fillcolor="palegreen"];
    l_stub -> l_drafted -> l_cited -> l_complete;
  }""")
    push!(lines, "}")
    join(lines, "\n")
end

function save_section_diagram(draft::SectionDraft, filename::String)
    open(filename, "w") do io
        run(pipeline(`dot -Tsvg`, stdin=IOBuffer(section_to_dot(draft)), stdout=io))
    end
    println("Saved: $filename")
end

function print_draft_status(draft::SectionDraft)
    counts = Dict(s => 0 for s in instances(ClaimStatus))
    for c in draft.claims; counts[c.status] += 1; end
    println("\n$(draft.name): $(length(draft.claims)) claims — " *
            join(["$(counts[s]) $(s)" for s in instances(ClaimStatus)], ", "))
    naked = filter(c -> c.lit_type == :none && c.status != complete, draft.claims)
    if !isempty(naked)
        println("  Naked assertions (no literature wire):")
        for c in naked; println("    • $(c.name)"); end
    end
    stubs_list = filter(c -> c.status == stub, draft.claims)
    if !isempty(stubs_list)
        println("  Stubs to write:")
        for c in stubs_list
            println("    • $(c.name): $(first(c.note, 70))")
        end
    end
end

println("SectionDraft framework loaded.")

# Save a Graphviz diagram object to an SVG file
function save_diagram(g, filename::String)
    open(filename, "w") do io
        Graphviz.run_graphviz(io, g, format="svg")
    end
    println("Saved: $filename")
end

################################################################################
# THE FUNCTOR: Mapping Argument Logic to Narrative Structure
################################################################################

# If you have a separate "Argument Graph" (Pure Predicate Logic), 
# you can define a Functor to map it into this Paper Structure.

@present ArgumentLogic(FreeCategory) begin
    (P, Q, R)::Ob
    impl::Hom(P, Q)
    prov::Hom(Q, R)
end

# This Functor F maps 'Pure Logic' into 'Paper Sections'
# F = FinFunctor(
#     Dict(:P => :Gap, :Q => :Hypothesis, :R => :Result),
#     Dict(:impl => :methodology, :prov => :analysis),
#     ArgumentLogic, ScientificPaper
# )
