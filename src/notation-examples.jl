################################################################################
# NOTATION EXAMPLES — produces documentation diagrams for all generic schemas
# defined in notation-gat.jl. Run this to regenerate the library SVGs.
################################################################################

include(joinpath(@__DIR__, "notation-gat.jl"))

const _OUT_DIR = joinpath(@__DIR__, "..", "out")

save_diagram(visualize_paper(paper_outline),            joinpath(_OUT_DIR, "scientific_paper.svg"))
save_diagram(visualize_phil_paper(phil_outline),        joinpath(_OUT_DIR, "philosophical_paper.svg"))
save_diagram(visualize_cited_paper(phil_cited_outline), joinpath(_OUT_DIR, "philosophical_cited.svg"))
save_diagram(visualize_review_paper(review_outline),    joinpath(_OUT_DIR, "review_paper.svg"))
