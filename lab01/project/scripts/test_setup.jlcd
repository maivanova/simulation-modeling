using Pkg
Pkg.activate(".")

using DifferentialEquations
using Plots
using DataFrames
using CSV

function exponential_growth!(du, u, p, t)
    α = p
    du[1] = α * u[1]
end

u0 = [1.0]
α = 0.3
tspan = (0.0, 10.0)

prob = ODEProblem(exponential_growth!, u0, tspan, α)
sol = solve(prob, Tsit5(), saveat=0.1)

plt = plot(
    sol.t,
    first.(sol.u),
    xlabel = "Время t",
    ylabel = "u(t)",
    title = "Экспоненциальный рост, α = 0.3",
    label = "численное решение",
    lw = 2
)

savefig(plt, "plots/exponential_growth.png")

df = DataFrame(
    t = sol.t,
    u = first.(sol.u)
)

CSV.write("data/exponential_growth.csv", df)

println("Первые 5 строк:")
println(first(df, 5))
println()
println("Финальное значение: ", last(df.u))
println("График: plots/exponential_growth.png")
println("Данные: data/exponential_growth.csv")
