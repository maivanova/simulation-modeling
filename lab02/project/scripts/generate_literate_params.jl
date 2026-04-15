using Pkg
Pkg.activate(".")
using Literate

input_file = "scripts/sir_simple_params_literate.jl"

Literate.script(input_file, "src")
Literate.notebook(input_file, "notebooks"; execute=false)
Literate.markdown(input_file, "markdown")

println("✅ Сгенерированы параметрические артефакты")
