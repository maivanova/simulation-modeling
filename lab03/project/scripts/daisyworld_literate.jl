# # Daisyworld
#
# В этой работе рассматривается упрощённая агентная модель Daisyworld.
# На клеточной сетке существуют белые и чёрные маргаритки.
# Они по-разному влияют на локальную температуру и изменяют состояние среды.

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using Plots
using Random
using Statistics

EMPTY = 0
WHITE = 1
BLACK = 2

n = 30
steps = 20
solar_luminosity = 1.0
surface_temp = fill(22.0, n, n)

rng = MersenneTwister(42)
grid = fill(EMPTY, n, n)

for i in 1:n, j in 1:n
    r = rand(rng)
    if r < 0.2
        grid[i, j] = WHITE
    elseif r < 0.4
        grid[i, j] = BLACK
    end
end

function local_temp(cell, base_temp, luminosity)
    if cell == WHITE
        return base_temp - 4 * luminosity
    elseif cell == BLACK
        return base_temp + 4 * luminosity
    else
        return base_temp
    end
end

for _ in 1:steps
    for i in 1:n, j in 1:n
        surface_temp[i, j] = local_temp(grid[i, j], surface_temp[i, j], solar_luminosity)
    end
end

mkpath("plots/daisyworld_literate")
p = heatmap(surface_temp, title="Daisyworld literate", colorbar=true)
savefig(p, "plots/daisyworld_literate/daisy_literate.png")

println("Literate Daisyworld готова")

# ## Вывод
#
# Модель демонстрирует влияние агентов на локальную температуру
# и позволяет визуализировать пространственную структуру среды.
