using Pkg
Pkg.activate(".")

using Agents
using DataFrames
using Plots
using CSV
using Statistics

include("../src/sir_model.jl")

mkpath("plots")
mkpath("data")

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
    for _ in 1:100
        Agents.step!(model, 1)
        peak = max(peak, infected_count(model))
    end

    deaths = 900 - total_count(model)
    final_inf = infected_count(model)
    final_rec = recovered_count(model)

    return (peak = peak, deaths = deaths, final_inf = final_inf, final_rec = final_rec)
end

results = DataFrame(
    beta = Float64[],
    seed = Int[],
    peak = Int[],
    deaths = Int[],
    final_inf = Int[],
    final_rec = Int[]
)

for beta in 0.1:0.1:1.0
    for seed in [42, 43, 44]
        r = run_experiment(beta, seed)
        push!(results, (beta, seed, r.peak, r.deaths, r.final_inf, r.final_rec))
        println("Завершён эксперимент: beta=$(beta), seed=$(seed)")
    end
end

CSV.write("data/beta_scan_all.csv", results)

grouped = combine(groupby(results, :beta),
    :peak => mean => :mean_peak,
    :deaths => mean => :mean_deaths,
    :final_inf => mean => :mean_final_inf,
    :final_rec => mean => :mean_final_rec
)

p = plot(
    grouped.beta,
    grouped.mean_peak,
    marker = :circle,
    label = "Пик эпидемии",
    xlabel = "β",
    ylabel = "Среднее значение",
    title = "Сканирование β"
)
plot!(p, grouped.beta, grouped.mean_deaths, marker = :square, label = "Смертность")
plot!(p, grouped.beta, grouped.mean_final_rec, marker = :diamond, label = "Выздоровевшие")

savefig(p, "plots/beta_scan.png")

println("Сканирование β завершено")
println("Файлы сохранены:")
println(" - data/beta_scan_all.csv")
println(" - plots/beta_scan.png")
