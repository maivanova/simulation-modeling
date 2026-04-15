using Pkg
Pkg.activate(".")

using DifferentialEquations
using SimpleDiffEq
using Tables
using DataFrames
using StatsPlots
using LaTeXStrings
using Plots
using BenchmarkTools

script_name = splitext(basename(PROGRAM_FILE))[1]
mkpath(joinpath("plots", script_name))
mkpath(joinpath("data", script_name))

function sir_ode!(du, u, p, t)
    (S, I, R) = u
    (β, c, γ) = p
    N = S + I + R
    @inbounds begin
        du[1] = -β * c * I / N * S
        du[2] = β * c * I / N * S - γ * I
        du[3] = γ * I
    end
    nothing
end

δt = 0.1
tmax = 40.0
tspan = (0.0, tmax)
u0 = [990.0, 10.0, 0.0]
p = [0.05, 10.0, 0.25]

R0 = (p[2] * p[1]) / p[3]

prob_ode = ODEProblem(sir_ode!, u0, tspan, p)
sol_ode = solve(prob_ode, dt = δt)

df_ode = DataFrame(Tables.table(sol_ode'))
rename!(df_ode, ["S", "I", "R"])
df_ode[!, :t] = sol_ode.t
df_ode[!, :N] = df_ode.S + df_ode.I + df_ode.R

println("Параметры модели SIR:")
println("β = ", p[1])
println("c = ", p[2])
println("γ = ", p[3])
println("R0 = ", round(R0, digits=3))
println("Средняя продолжительность болезни = ", round(1/p[3], digits=2), " дней")
println("Начальные условия: S0 = ", u0[1], ", I0 = ", u0[2], ", R0 = ", u0[3])

plt1 = @df df_ode plot(:t, [:S :I :R],
    label=[L"S(t)" L"I(t)" L"R(t)"],
    xlabel="Время, дни",
    ylabel="Количество людей",
    title="Модель SIR: Динамика эпидемии",
    linewidth=2,
    legend=:right,
    grid=true,
    size=(800, 500))

peak_idx = argmax(df_ode.I)
peak_time = df_ode.t[peak_idx]
peak_value = df_ode.I[peak_idx]

plt2 = @df df_ode plot(:t, :I,
    label=L"I(t)",
    xlabel="Время, дни",
    ylabel="Количество инфицированных",
    title="Динамика числа зараженных",
    color=:red,
    linewidth=2,
    fill=(0, 0.3, :red),
    grid=true,
    size=(800, 400))

vline!(plt2, [peak_time], color=:black, linestyle=:dash, label=false, linewidth=1)

df_ode[!, :Re] = R0 .* df_ode.S ./ df_ode.N
plt3 = @df df_ode plot(:t, :Re,
    label=L"R_e(t)",
    xlabel="Время, дни",
    ylabel=L"R_e",
    title="Эффективное репродуктивное число",
    color=:green,
    linewidth=2,
    grid=true,
    size=(800, 400))
hline!(plt3, [1.0], color=:red, linestyle=:dash, label="Rₑ=1", linewidth=1.5)

savefig(plt1, joinpath("plots", script_name, "sir_main.png"))
savefig(plt2, joinpath("plots", script_name, "sir_infected.png"))
savefig(plt3, joinpath("plots", script_name, "sir_effective_R.png"))

println("\n=== АНАЛИЗ ===")
println("Пиковое число зараженных: ", round(peak_value, digits=1))
println("Время достижения пика: ", round(peak_time, digits=1), " дней")
println("Итоговое число переболевших: ", round(df_ode.R[end], digits=1))
println("Доля переболевших: ", round(df_ode.R[end]/df_ode.N[1]*100, digits=1), "%")
println("\nМоделирование SIR завершено успешно!")
