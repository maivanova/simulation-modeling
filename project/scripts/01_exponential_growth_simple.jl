u0 = 1.0
α = 0.3
t0 = 0.0
t1 = 10.0
dt = 0.1

ts = collect(t0:dt:t1)
us = [u0 * exp(α * t) for t in ts]

mkpath("data")
open("data/exponential_growth.csv", "w") do io
    println(io, "t,u")
    for (t, u) in zip(ts, us)
        println(io, string(t, ",", u))
    end
end

println("Первые 5 строк:")
for i in 1:5
    println("t=", ts[i], "  u=", us[i])
end

println()
println("Финальное значение: ", us[end])
println("CSV: data/exponential_growth.csv")
