using Pkg
Pkg.activate(".")
using Literate

mkpath("src_generated")
mkpath("notebooks")
mkpath("markdown")
mkpath("docs")

for f in ["scripts/sir_basic_literate.jl", "scripts/sir_beta_literate.jl"]
    Literate.script(f, "src_generated")
    Literate.notebook(f, "notebooks"; execute=false)
    Literate.markdown(f, "markdown")
end

println("Literate-артефакты сгенерированы")
