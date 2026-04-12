using Pkg
Pkg.activate(".")

packages = [
    "DrWatson",
    "DifferentialEquations",
    "Plots",
    "DataFrames",
    "CSV",
    "Literate",
    "JLD2",
    "IJulia",
    "BenchmarkTools"
]

println("Проверка окружения проекта")
println("Текущая директория: ", pwd())
println()

for pkg in packages
    try
        Base.require(Symbol(pkg))
        println("✓ ", pkg)
    catch e
        println("✗ ", pkg, " -> ", e)
    end
end

println()
println("✅ Проверка завершена")
