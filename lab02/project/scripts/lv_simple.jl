using Pkg
Pkg.activate(".")

using DataFrames
using Plots
using Statistics

script_name = splitext(basename(PROGRAM_FILE))[1]
mkpath(joinpath("plots", script_name))
mkpath(joinpath("data", script_name))

# Параметры модели
α = 0.1
β = 0.02
δ = 0.01
γ = 0.3

# Начальные условия
x0 = 40.0
y0 = 9.0

# Временные параметры
dt = 0.01
tmax = 200.0
ts = collect(0.0:dt:tmax)

prey = zeros(length(ts))
predator = zeros(length(ts))

prey[1] = x0
predator[1] = y0

# Явная схема Эйлера
for n in 1:length(ts)-1
    dx = α * prey[n] - β * prey[n] * predator[n]
    dy = δ * prey[n] * predator[n] - γ * predator[n]

    prey[n+1] = prey[n] + dt * dx
    predator[n+1] = predator[n] + dt * dy
end

x_star = γ / δ
y_star = α / β

df = DataFrame(t=ts, prey=prey, predator=predator)
CSV_path = joinpath("data", script_name, "lv_results.csv")
open(CSV_path, "w") do io
    println(io, "t,prey,predator")
    for row in eachrow(df)
        println(io, string(row.t, ",", row.prey, ",", row.predator))
    end
end

println("Модель Лотки-Вольтерры")
println("α = ", α)
println("β = ", β)
println("δ = ", δ)
println("γ = ", γ)
println("x* = ", round(x_star, digits=3))
println("y* = ", round(y_star, digits=3))
println("min prey = ", round(minimum(prey), digits=2))
println("max prey = ", round(maximum(prey), digits=2))
println("min predator = ", round(minimum(predator), digits=2))
println("max predator = ", round(maximum(predator), digits=2))

plt1 = plot(ts, [prey predator],
    label=["Жертвы" "Хищники"],
    xlabel="Время",
    ylabel="Популяция",
    title="Модель Лотки-Вольтерры",
    linewidth=2,
    size=(900, 500))

plt2 = plot(prey, predator,
    label="Фазовая траектория",
    xlabel="Жертвы",
    ylabel="Хищники",
    title="Фазовый портрет",
    linewidth=2,
    size=(800, 500))
scatter!(plt2, [x_star], [y_star], label="Стационарная точка")

savefig(plt1, joinpath("plots", script_name, "lv_dynamics.png"))
savefig(plt2, joinpath("plots", script_name, "lv_phase_portrait.png"))

println("Моделирование LV завершено успешно!")
