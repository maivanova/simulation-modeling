using Pkg
Pkg.activate(".")

packages = [
    "DrWatson",
    "DifferentialEquations",
    "SimpleDiffEq",
    "Tables",
    "DataFrames",
    "StatsPlots",
    "LaTeXStrings",
    "Plots",
    "BenchmarkTools",
    "Statistics",
    "FFTW",
    "Literate",
    "IJulia"
]

println("Проверка окружения lab02")
println("Текущая директория: ", pwd())
println()

for pkg in packages
    try
        Core.eval(Main, Meta.parse("import " * pkg))
        println("✓ ", pkg)
    catch e
        println("✗ ", pkg, " -> ", e)
    end
end

println()
println("✅ Проверка завершена")
