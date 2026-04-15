# # Параметрическое сканирование коэффициента β
#
# Здесь исследуется влияние коэффициента заразности β на пик эпидемии.

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Agents
using DataFrames
using Plots
using Statistics

include(joinpath(@__DIR__, "..", "src", "sir_model.jl"))

function run_experiment(beta, seed)
    model = initialize_sir(
        Ns = [300, 300, 300],
        β_und = fill(beta, 3),
        β_det = fill(beta / 10, 3),
        infection_period = 14,
        detection_time = 7,
        death_rate = 0.02,
        reinfection_probability = 0.1,
        Is = [0, 0, 1],
        seed = seed
    )

    peak = 0
    for _ in 1:50
        Agents.step!(model, 1)
        peak = max(peak, infected_count(model))
    end
    return peak
end

betas = collect(0.1:0.1:1.0)
peaks = [run_experiment(b, 42) for b in betas]

mkpath("plots/sir_beta_literate")

p = plot(betas, peaks, marker=:circle, xlabel="β", ylabel="Peak", title="SIR beta scan")
savefig(p, "plots/sir_beta_literate/sir_beta_scan.png")

println("Параметрическая literate готова")

# ## Вывод
#
# При росте коэффициента β пик эпидемии возрастает.
