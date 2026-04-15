using Pkg
Pkg.activate(".")

using DataFrames
using Plots
using Statistics

script_name = splitext(basename(PROGRAM_FILE))[1]
mkpath(joinpath("plots", script_name))
mkpath(joinpath("data", script_name))

# Параметры модели
β = 0.05
c = 10.0
γ = 0.25

# Начальные условия
S0 = 990.0
I0 = 10.0
R0_pop = 0.0

# Временные параметры
dt = 0.1
tmax = 40.0
ts = collect(0.0:dt:tmax)

# Массивы решения
S = zeros(length(ts))
I = zeros(length(ts))
R = zeros(length(ts))

S[1] = S0
I[1] = I0
R[1] = R0_pop

# Явная схема Эйлера
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
Re = R0_model .* S ./ (S .+ I .+ R)

df = DataFrame(t=ts, S=S, I=I, R=R, Re=Re)
CSV_path = joinpath("data", script_name, "sir_results.csv")
open(CSV_path, "w") do io
    println(io, "t,S,I,R,Re")
    for row in eachrow(df)
        println(io, string(row.t, ",", row.S, ",", row.I, ",", row.R, ",", row.Re))
    end
end

println("Параметры модели SIR:")
println("β = ", β)
println("c = ", c)
println("γ = ", γ)
println("R0 = ", round(R0_model, digits=3))

peak_idx = argmax(I)
peak_time = ts[peak_idx]
peak_value = I[peak_idx]

println("Пиковое число зараженных: ", round(peak_value, digits=2))
println("Время пика: ", round(peak_time, digits=2), " дней")
println("Итоговое число переболевших: ", round(R[end], digits=2))

plt1 = plot(ts, [S I R],
    label=["S(t)" "I(t)" "R(t)"],
    xlabel="Время, дни",
    ylabel="Количество людей",
    title="Модель SIR",
    linewidth=2,
    size=(800, 500))

plt2 = plot(ts, I,
    label="I(t)",
    xlabel="Время, дни",
    ylabel="Количество инфицированных",
    title="Динамика зараженных",
    linewidth=2,
    fill=(0, 0.3),
    size=(800, 400))

plt3 = plot(ts, Re,
    label="Re(t)",
    xlabel="Время, дни",
    ylabel="Re",
    title="Эффективное репродуктивное число",
    linewidth=2,
    size=(800, 400))
hline!(plt3, [1.0], linestyle=:dash, label="Re=1")

savefig(plt1, joinpath("plots", script_name, "sir_main.png"))
savefig(plt2, joinpath("plots", script_name, "sir_infected.png"))
savefig(plt3, joinpath("plots", script_name, "sir_effective_R.png"))

println("Моделирование SIR завершено успешно!")
