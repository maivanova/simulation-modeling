using Pkg
Pkg.activate(".")

using Agents
using DataFrames
using Plots
using CSV

include("../src/sir_model.jl")

mkpath("plots")
mkpath("data")

params = Dict(
    :Ns => [300, 300, 300],
    :β_und => [0.5, 0.5, 0.5],
    :β_det => [0.05, 0.05, 0.05],
    :infection_period => 14,
    :detection_time => 7,
    :death_rate => 0.02,
    :reinfection_probability => 0.1,
    :Is => [0, 0, 1],
    :seed => 42,
    :n_steps => 100,
)

model = initialize_sir(
    Ns = params[:Ns],
    β_und = params[:β_und],
    β_det = params[:β_det],
    infection_period = params[:infection_period],
    detection_time = params[:detection_time],
    death_rate = params[:death_rate],
    reinfection_probability = params[:reinfection_probability],
    Is = params[:Is],
    seed = params[:seed]
)

times = Int[]
S_vals = Int[]
I_vals = Int[]
R_vals = Int[]
T_vals = Int[]

for step in 1:params[:n_steps]
    Agents.step!(model, 1)
    push!(times, step)
    push!(S_vals, susceptible_count(model))
    push!(I_vals, infected_count(model))
    push!(R_vals, recovered_count(model))
    push!(T_vals, total_count(model))
end

df = DataFrame(
    time = times,
    susceptible = S_vals,
    infected = I_vals,
    recovered = R_vals,
    total = T_vals
)

CSV.write("data/sir_basic.csv", df)

p = plot(
    df.time,
    df.susceptible,
    label = "S",
    xlabel = "Дни",
    ylabel = "Количество",
    title = "SIR basic dynamics"
)
plot!(p, df.time, df.infected, label = "I")
plot!(p, df.time, df.recovered, label = "R")
plot!(p, df.time, df.total, label = "Total", linestyle = :dash)

savefig(p, "plots/sir_basic_dynamics.png")

R0 = params[:β_und][1] / (1 / params[:infection_period])
println("R0 ≈ ", round(R0, digits = 2))
println("Базовый эксперимент завершён")
println("Файлы сохранены:")
println(" - data/sir_basic.csv")
println(" - plots/sir_basic_dynamics.png")
