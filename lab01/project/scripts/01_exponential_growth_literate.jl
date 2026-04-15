# # Модель экспоненциального роста
#
# Рассматривается модель
# $$
# u(t) = u_0 e^{\alpha t}
# $$
# где:
# - $u_0 = 1.0$ — начальное значение,
# - $\alpha = 0.3$ — коэффициент роста.
#
# Ниже формируется таблица значений функции на интервале
# от 0 до 10 с шагом 0.1.

u0 = 1.0
α = 0.3
t0 = 0.0
t1 = 10.0
dt = 0.1

ts = collect(t0:dt:t1)
us = [u0 * exp(α * t) for t in ts]

mkpath("data")
open("data/exponential_growth_literate.csv", "w") do io
    println(io, "t,u")
    for (t, u) in zip(ts, us)
        println(io, string(t, ",", u))
    end
end

println("Первые 5 строк:")
for i in 1:5
    println("t=", ts[i], "  u=", us[i])
end

# ## Вывод
#
# При положительном значении α функция возрастает экспоненциально.
# Результаты сохранены в CSV-файл.
