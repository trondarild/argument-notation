################################################################################
# RHYTHM & TUBES — Categorical notation
# "Rhythm & Tubes: Points of synergy between organism-centric and
#  neuro-centric approaches to consciousness"
#
# Output: all diagrams saved as SVG files; all printed output → out.txt
################################################################################

const _OUT_DIR = joinpath(@__DIR__, "..", "out")

# Redirect stdout to out/out.txt for the entire session (includes notation-gat.jl output)
const _out_io = open(joinpath(_OUT_DIR, "out.txt"), "w")
redirect_stdout(_out_io)

include(joinpath(@__DIR__, "notation-gat.jl"))

################################################################################
# PAPER-SPECIFIC SCHEMA
# Extends the base philosophical schema with an explicit synergy-point structure.
# The six sections (5.1–5.6) each pass the Thesis and Tinbergen Concept through
# and produce one SynergyPoint. The defense consolidates all six to defeat the
# "too few synergy points?" objection that the authors pre-empt in section 1.
################################################################################

@present RhythmAndTubes(FreeSymmetricMonoidalCategory) begin
    # ── Information states ────────────────────────────────────────────────────
    (Background, SharedKnowledge, ContestedTerritory, Motivation)::Ob
    (Puzzle, Position, Critique, Thesis, Concept)::Ob
    (SynergyPoint, SynergyEvidence, Reply, Implication)::Ob

    # ── Typed literature wires ────────────────────────────────────────────────
    (EmpiricalLit, ReviewLit, TheoreticalLit)::Ob

    # ── Introduction (decomposed) ─────────────────────────────────────────────
    # Sec 1: diverse landscape of consciousness studies → shared ground
    background_survey::Hom(Background ⊗ ReviewLit, SharedKnowledge ⊗ Background)

    # Sec 1: NC (neural sufficiency) vs OC (organism-embedded) → contested territory
    contested_survey::Hom(SharedKnowledge ⊗ EmpiricalLit, ContestedTerritory)

    # Author's inference: the apparent NC/OC asymmetry is misleading
    gap_identification::Hom(ContestedTerritory, Puzzle ⊗ Motivation)

    # ── Sections 2–3: NC vs OC dialectic ─────────────────────────────────────
    # HOT / GWT / local-recurrency  vs  cybernetics / active inference
    dialectic::Hom(Puzzle ⊗ Background ⊗ TheoreticalLit, Position ⊗ Critique)

    # ── Thesis + Tinbergen framework as organizing Concept ────────────────────
    proposal::Hom(Position ⊗ Critique ⊗ Motivation, Thesis ⊗ Concept)

    # ── Sections 5.1–5.6: synergy elaboration ────────────────────────────────
    # Concept (Tinbergen's four questions) enters each section as scaffolding
    # and is returned so subsequent sections can use the same framework.
    # Literature wires reflect the evidentiary load of each section.
    synergy_phenomena ::Hom(Thesis ⊗ Concept ⊗ EmpiricalLit,                   Thesis ⊗ Concept ⊗ SynergyPoint)
    synergy_levels    ::Hom(Thesis ⊗ Concept ⊗ TheoreticalLit,                  Thesis ⊗ Concept ⊗ SynergyPoint)
    synergy_practical ::Hom(Thesis ⊗ Concept,                                    Thesis ⊗ Concept ⊗ SynergyPoint)
    synergy_predictive::Hom(Thesis ⊗ Concept ⊗ TheoreticalLit ⊗ EmpiricalLit,  Thesis ⊗ Concept ⊗ SynergyPoint)
    synergy_brainstem ::Hom(Thesis ⊗ Concept ⊗ TheoreticalLit,                  Thesis ⊗ Concept ⊗ SynergyPoint)
    synergy_access    ::Hom(Thesis ⊗ Concept ⊗ EmpiricalLit,                    Thesis ⊗ Concept ⊗ SynergyPoint)

    # ── Defense: all six SynergyPoints defeat the "too few?" objection ────────
    consolidate::Hom(SynergyPoint ⊗ SynergyPoint ⊗ SynergyPoint ⊗
                     SynergyPoint ⊗ SynergyPoint ⊗ SynergyPoint, SynergyEvidence)
    defense    ::Hom(Thesis ⊗ SynergyEvidence, Thesis ⊗ Reply)

    # ── Section 6: Concluding remarks ────────────────────────────────────────
    conclusion::Hom(Thesis ⊗ Reply, Implication)
end

# Each distinct literature wire is a separate input — forcing explicit tracking
# of which body of literature supports which move in the argument.
rt_outline = @program RhythmAndTubes (
        b        ::Background,
        rl       ::ReviewLit,        # field surveys, Tinbergen, Mayr
        el_nc    ::EmpiricalLit,     # NCC studies comparing NC and OC predictions
        tl_theory::TheoreticalLit,   # HOT / GWT / local recurrency / cybernetics
        el_phenom::EmpiricalLit,     # arousal, qualia, drug-effects studies
        tl_sys   ::TheoreticalLit,   # systems science (Bertalanffy, Mobus & Kalton)
        tl_pp    ::TheoreticalLit,   # FEP / predictive processing theory
        el_pp    ::EmpiricalLit,     # Rao & Ballard-style empirical PP
        tl_stem  ::TheoreticalLit,   # brainstem / affective consciousness theory
        el_access::EmpiricalLit) begin  # filling-in, inattentional blindness, choice blindness

    sk,  b2             = background_survey(b, rl)
    ct                  = contested_survey(sk, el_nc)
    puzzle, mot         = gap_identification(ct)
    pos, crit           = dialectic(puzzle, b2, tl_theory)
    thesis, con         = proposal(pos, crit, mot)

    thesis1, con1, sp1  = synergy_phenomena(thesis,  con,  el_phenom)
    thesis2, con2, sp2  = synergy_levels(thesis1, con1, tl_sys)
    thesis3, con3, sp3  = synergy_practical(thesis2, con2)
    thesis4, con4, sp4  = synergy_predictive(thesis3, con3, tl_pp, el_pp)
    thesis5, con5, sp5  = synergy_brainstem(thesis4, con4, tl_stem)
    thesis6, _con6, sp6 = synergy_access(thesis5, con5, el_access)

    ev                  = consolidate(sp1, sp2, sp3, sp4, sp5, sp6)
    thesis7, rep        = defense(thesis6, ev)
    impl                = conclusion(thesis7, rep)
    return impl
end

################################################################################
# BIBLIOGRAPHY REGISTRY
# Keys must match entries in the paper's .bib file.
# Organised by morphism so render_citations() drops \cite{} into generated LaTeX.
################################################################################

rt_registry = BibRegistry(
    :background_survey => [
        BibEntry("Nagel1974",              :review, "subjectivity as the mark of consciousness"),
        BibEntry("Chalmers1995",           :review, "hard problem of consciousness"),
        BibEntry("Tinbergen1963",          :review, "four questions: phylogeny/function/ontogeny/mechanism"),
        BibEntry("Mayr1961",               :review, "ultimate why-questions vs proximate how-questions"),
        BibEntry("CabralCalderin2025",     :review, "Tinbergen applied to consciousness studies"),
        BibEntry("Fink2018",               :review, "classical philosophical conceptual work"),
        BibEntry("GallagherZahavi2020",    :review, "phenomenological approaches"),
        BibEntry("ClarkChalmers1998",      :review, "extended mind / environmental embedding"),
    ],
    :contested_survey => [
        # NC side
        BibEntry("CrickKoch1998",          :empirical, "early NCC programme"),
        BibEntry("Lamme2005",              :empirical, "local recurrency as NCC"),
        BibEntry("Rosenthal2002",          :empirical, "higher-order thought theory"),
        BibEntry("MashourDehaene2020",     :empirical, "global workspace / fronto-parietal broadcasting"),
        BibEntry("BrownLauLeDoux2019",     :empirical, "HOT and prefrontal NCC"),
        # OC side
        BibEntry("Ciaunica2021a",          :empirical, "embodied consciousness, bodily self"),
        BibEntry("Ciaunica2021b",          :empirical, "embodiment and predictive processing"),
        BibEntry("KirkebyyHinrup2023",     :empirical, "ontogenetic emergence vs NC views"),
    ],
    :dialectic => [
        BibEntry("Baars1997",              :theoretical, "global workspace theory"),
        BibEntry("Block2007",              :theoretical, "local recurrency and phenomenal consciousness"),
        BibEntry("Wiener1948",             :theoretical, "cybernetics: organism control of environment"),
        BibEntry("Ashby1956",              :theoretical, "design for a brain / self-regulation"),
        BibEntry("Friston2010",            :theoretical, "free energy principle"),
        BibEntry("KirkebyyHinrup2020",     :theoretical, "NC machinery independent of input"),
    ],
    :proposal => [
        BibEntry("Tinbergen1963",          :theoretical, "Tinbergen framework as organising scaffold"),
        BibEntry("Nesse2013",              :theoretical, "four questions are complementary and necessary"),
        BibEntry("CabralCalderin2025",     :theoretical, "coherence across explanatory levels"),
    ],
    :synergy_phenomena => [
        BibEntry("Uhlhaas2010",            :empirical, "psychiatric disorders traced to rhythmic dysfunction"),
        BibEntry("Buzsaki2006",            :empirical, "rhythms of the brain / oscillatory binding"),
    ],
    :synergy_levels => [
        BibEntry("VonBertalanffy1969",     :theoretical, "general systems theory"),
        BibEntry("Laszlo1972a",            :theoretical, "systems philosophy"),
        BibEntry("MobusKalton2015",        :theoretical, "systems science: boxes-in-boxes / levels of organisation"),
    ],
    :synergy_practical => [
        # Conceptual section — no specific citations required; the argument
        # follows from the levels-of-analysis framework established in 5.2.
    ],
    :synergy_predictive => [
        BibEntry("Friston2010",            :theoretical, "free energy principle"),
        BibEntry("Hohwy2013",              :theoretical, "predictive mind (unificatory)"),
        BibEntry("Hohwy2020",              :theoretical, "PP: pluralistic vs unificatory perspectives"),
        BibEntry("Clark2016",              :theoretical, "predictive processing (pluralist)"),
        BibEntry("ParrPezzuloFriston2022", :theoretical, "active inference framework"),
        BibEntry("Laukkonen2025",          :theoretical, "3 conditions for consciousness via active inference"),
        BibEntry("Solms2021",              :theoretical, "FEP and affective consciousness"),
        BibEntry("RaoBallard1999",         :empirical,   "top-down / bottom-up predictive coding"),
    ],
    :synergy_brainstem => [
        BibEntry("Solms2021",              :theoretical, "brainstem as seat of felt value / homeostasis"),
        BibEntry("Damasio2000",            :theoretical, "orchestra metaphor / ecological embeddedness"),
        BibEntry("Buzsaki2006",            :theoretical, "oscillatory basis of coordination"),
        BibEntry("Uhlhaas2010",            :empirical,   "rhythm failure and psychiatric disease"),
    ],
    :synergy_access => [
        BibEntry("Block1995",              :theoretical, "access vs phenomenal consciousness"),
        BibEntry("Block2007",              :theoretical, "A-consciousness in empirical work"),
        BibEntry("SimonsChabris1999",      :empirical,   "inattentional blindness / gorilla experiment"),
        BibEntry("Simons2000",             :empirical,   "perception driven by expectation and attention"),
        BibEntry("ZurUllman2003",          :empirical,   "filling-in / central scotoma"),
        BibEntry("Hall2010",               :empirical,   "choice blindness / confabulation"),
        BibEntry("Johansson2005",          :empirical,   "choice blindness original paradigm"),
        BibEntry("Solovey2015",            :empirical,   "peripheral inflation / foveal vs peripheral resolution"),
    ],
    :defense => [
        # Defense rests on the combinatorics argument (sec 1) + diversity of
        # demonstrated synergy points — no new citations; see elaboration sections.
    ],
)

function visualize_rt(outline)
    to_graphviz(outline,
        orientation=TopToBottom,
        labels=true,
        node_attrs=Dict(:shape => "box", :style => "filled", :fillcolor => "honeydew"))
end

################################################################################
# SECTION 3 DRAFT — Organism-centric approaches
#
# Chain: NCApproachEstablished → [3.intro] → [3.1 cells→tubes] →
#        [3.2 oscillation] → [3.3 unity stub] → [3.4 coordination stub]
#        → OCFrameworkEstablished
#
# Colours: yellow=stub, blue=drafted, green=cited, palegreen=complete
################################################################################

sec3_draft = SectionDraft(:Sec3_OC_Approaches, [

    # ── Section 3 opening ──────────────────────────────────────────────────────
    ClaimStub(:oc_gradient_view,
        :NCApproachEstablished, :GradientView,
        :theoretical, stub,
        "OC: no sharp division humans/animals; consciousness comes in degrees"),

    ClaimStub(:epistemic_limits,
        :GradientView, :EpistemicLimits,
        :review, stub,
        "third-person access to non-human consciousness is limited but not zero (pain/pleasure universality)"),

    ClaimStub(:hard_problem_framing,
        :EpistemicLimits, :HardProblemContext,
        :review, cited,
        "Nagel/Levine/Chalmers: why does it feel like something? how does it come about?"),

    # ── 3.1 From Cells to Tubes ────────────────────────────────────────────────
    ClaimStub(:cell_energy_physics,
        :HardProblemContext, :SingleCellThermo,
        :theoretical, stub,
        "individual cells: thermodynamics, energy gradients, waves of information and nutrients"),

    ClaimStub(:grouping_and_coordination_need,
        :SingleCellThermo, :GroupDynamics,
        :empirical, stub,
        "cells form groups (bacteria films); coordination need emerges at borders; signaling required"),

    ClaimStub(:oscillation_is_automatic,
        :GroupDynamics, :OscillationPhysics,
        :theoretical, stub,
        "synchronized groups produce waves automatically (physical principle); broadcast signaling in rhythm"),

    ClaimStub(:sync_as_protoconsciousness,
        :OscillationPhysics, :ProtoConsciousness,
        :theoretical, stub,
        "synchronization → group acts as unity = proto-consciousness; ions/electric fields now group-level"),

    ClaimStub(:specialization_emerges,
        :ProtoConsciousness, :CellSpecialization,
        :empirical, stub,
        "cells in group specialize (different jobs); division of labour at group boundary"),

    ClaimStub(:tubes_emerge,
        :CellSpecialization, :TubeStructure,
        :theoretical, stub,
        "energy-processing specialization → TUBES: gut/digestive tract; remove waste, deliver energy"),

    ClaimStub(:proto_nerve_systems,
        :TubeStructure, :ProtoNervousSystem,
        :theoretical, stub,
        "sensoric cells give action potentials to other networks; optimization → proto nerve systems"),

    ClaimStub(:nerve_cells_long_distance,
        :ProtoNervousSystem, :NerveCellFunction,
        :theoretical, stub,
        "nerve cells: long-distance, specific signaling to specific cells; allows organism to grow bigger"),

    ClaimStub(:directed_behavior,
        :NerveCellFunction, :DirectedBehavior,
        :empirical, stub,
        "approach/avoidance; movement across energy gradient; predator/prey ecology emerges"),

    ClaimStub(:cns_purpose,
        :DirectedBehavior, :ConsciousnessAsCoordination,
        :theoretical, stub,
        "CNS purpose = synchronization + energy + information, fast enough and precise enough. Consciousness IS the group-level coordination need (not individual cells). Cancer analogy."),

    # ── 3.2 Oscillation ────────────────────────────────────────────────────────
    ClaimStub(:homeostasis_requirement,
        :ConsciousnessAsCoordination, :HomeostaticNeed,
        :theoretical, drafted,
        "organisms must continuously put in work; need ongoing free energy input to remain in steady state"),

    ClaimStub(:ecological_embeddedness,
        :HomeostaticNeed, :EcologicalEmbeddedness,
        :theoretical, drafted,
        "organisms not discrete; deeply intertwined with ecology (Damasio orchestra metaphor)"),

    ClaimStub(:multilevel_equilibrium,
        :EcologicalEmbeddedness, :MultiLevelEquilibrium,
        :empirical, cited,
        "equilibrium at multiple scales: whole body → neurons; rhythm dysfunction → psychiatric disorders (Uhlhaas & Singer 2010)"),

    ClaimStub(:rhythmic_binding,
        :MultiLevelEquilibrium, :RhythmicBinding,
        :empirical, cited,
        "life processes oscillate; rhythms hierarchically bind processes; foundation for temporal analysis (Buzsaki 2006)"),

    ClaimStub(:entrainment_integrates_signals,
        :RhythmicBinding, :OscillatoryConsciousness,
        :theoretical, stub,
        "central entrainment integrates sensory signals; metabolic cost ties rhythms to energy states (REFS needed)"),

    # ── 3.3 Unity (stub section) ───────────────────────────────────────────────
    ClaimStub(:unity_mechanism,
        :OscillatoryConsciousness, :UnityDefined,
        :none, stub,
        "3.3 not yet written — define what unity means in OC terms"),

    # ── 3.4 Coordination (stub section) ───────────────────────────────────────
    ClaimStub(:coordination_mechanism,
        :UnityDefined, :OCFrameworkEstablished,
        :none, stub,
        "3.4 not yet written — define coordination mechanism and connect to CNS purpose from 3.1"),
])

################################################################################
# OUTPUT
################################################################################

save_diagram(visualize_rt(rt_outline),   joinpath(_OUT_DIR, "rhythm_tubes.svg"))
save_section_diagram(sec3_draft,         joinpath(_OUT_DIR, "sec3_draft.svg"))

println("\nRhythm & Tubes — $(length(all_cite_keys(rt_registry))) unique cite keys\n")
print_bib_summary(rt_registry)
print_draft_status(sec3_draft)

flush(_out_io)
close(_out_io)
