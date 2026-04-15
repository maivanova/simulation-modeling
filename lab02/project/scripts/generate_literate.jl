using Pkg
Pkg.activate(".")
using Literate

mkpath("markdown")
mkpath("notebooks")
mkpath("src")

input_file = "scripts/sir_simple_literate.jl"

Literate.script(input_file, "src")
Literate.notebook(input_file, "notebooks"; execute=false)
Literate.markdown(input_file, "markdown")

println("✅ Сгенерированы:")
println(" - чистый код в папке src/")
println(" - notebook в папке notebooks/")
println(" - markdown в папке markdown/")
