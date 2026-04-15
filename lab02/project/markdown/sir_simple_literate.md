```@meta
EditURL = "../scripts/sir_simple_literate.jl"
```

# Модель SIR

В этой работе рассматривается трёхпараметрическая модель SIR.
Популяция делится на три группы:
- S — восприимчивые,
- I — инфицированные,
- R — выздоровевшие.

Базовое репродуктивное число:
$$
R_0 = \frac{c\beta}{\gamma}
$$

````@example sir_simple_literate
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Plots
using Statistics

β = 0.05
c = 10.0
γ = 0.25

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
println("R0 = ", round(R0_model, digits=3))

plt = plot(ts, [S I R],
    label=["S(t)" "I(t)" "R(t)"],
    xlabel="Время",
    ylabel="Количество",
    title="Модель SIR",
    linewidth=2)

mkpath("plots/sir_simple_literate")
savefig(plt, "plots/sir_simple_literate/sir_literate_main.png")
````

## Вывод

При выбранных параметрах наблюдается рост числа инфицированных,
достижение пика эпидемии и последующее затухание.

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

