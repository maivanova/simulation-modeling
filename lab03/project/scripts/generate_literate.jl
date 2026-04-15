using Pkg
Pkg.activate(".")
using Literate

mkpath("src")
mkpath("notebooks")
mkpath("markdown")
mkpath("docs")

input_file = "scripts/daisyworld_literate.jl"

Literate.script(input_file, "src")
Literate.notebook(input_file, "notebooks"; execute=false)
Literate.markdown(input_file, "markdown")

println("Сгенерированы src, notebook и markdown")
