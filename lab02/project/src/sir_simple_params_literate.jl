using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Plots
using Statistics

β = 0.08
c = 8.0
γ = 0.20

S0 = 990.0
I0 = 10.0
R0_pop = 0.0

dt = 0.1
tmax = 40.0
ts = collect(0.0:dt:tmax)

S = zeros(length(ts))
I = zeros(length(ts))
R = zeros(length(ts))

S[1] = S0
I[1] = I0
R[1] = R0_pop

for n in 1:length(ts)-1
    N = S[n] + I[n] + R[n]
    dS = -β * c * I[n] / N * S[n]
    dI = β * c * I[n] / N * S[n] - γ * I[n]
    dR = γ * I[n]

    S[n+1] = S[n] + dt * dS
    I[n+1] = I[n] + dt * dI
    R[n+1] = R[n] + dt * dR
end

R0_model = c * β / γ
println("Параметрический вариант SIR")
println("R0 = ", round(R0_model, digits=3))

plt = plot(ts, [S I R],
    label=["S(t)" "I(t)" "R(t)"],
    xlabel="Время",
    ylabel="Количество",
    title="SIR с изменёнными параметрами",
    linewidth=2)

mkpath("plots/sir_simple_params_literate")
savefig(plt, "plots/sir_simple_params_literate/sir_params_main.png")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
