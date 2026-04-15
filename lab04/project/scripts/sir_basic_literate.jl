# # Агентная модель SIR
#
# В работе рассматривается агентная реализация модели SIR на графе.
# Агенты перемещаются между локациями, заражают других и выздоравливают.

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Agents
using DataFrames
using Plots
using CSV

include(joinpath(@__DIR__, "..", "src", "sir_model.jl"))

model = initialize_sir(
    Ns = [300, 300, 300],
    β_und = [0.5, 0.5, 0.5],
    β_det = [0.05, 0.05, 0.05],
    infection_period = 14,
    detection_time = 7,
    death_rate = 0.02,
    reinfection_probability = 0.1,
    Is = [0, 0, 1],
    seed = 42
)

times = Int[]
S_vals = Int[]
I_vals = Int[]
R_vals = Int[]

for step in 1:50
    Agents.step!(model, 1)
    push!(times, step)
    push!(S_vals, susceptible_count(model))
    push!(I_vals, infected_count(model))
    push!(R_vals, recovered_count(model))
end

mkpath("plots/sir_basic_literate")

p = plot(times, S_vals, label="S", xlabel="Дни", ylabel="Количество", title="SIR literate")
plot!(p, times, I_vals, label="I")
plot!(p, times, R_vals, label="R")

savefig(p, "plots/sir_basic_literate/sir_literate.png")

println("Literate SIR готова")

# ## Вывод
#
# Агентная модель позволяет учитывать стохастичность и пространственную структуру.
