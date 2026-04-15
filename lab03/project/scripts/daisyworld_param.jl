using Pkg
Pkg.activate(".")

using Plots
using Random

mkpath("plots/daisyworld_param")

const EMPTY = 0
const WHITE = 1
const BLACK = 2

function run_case(init_white, luminosity; n=30, steps=30, seed=42)
    rng = MersenneTwister(seed)
    grid = fill(EMPTY, n, n)
    temp = fill(22.0, n, n)

    for i in 1:n, j in 1:n
        r = rand(rng)
        if r < init_white
            grid[i, j] = WHITE
        elseif r < init_white + 0.2
            grid[i, j] = BLACK
        end
    end

    local_temp(cell, base_temp, lum) =
        cell == WHITE ? base_temp - 4*lum :
        cell == BLACK ? base_temp + 4*lum : base_temp

    for _ in 1:steps
        newgrid = copy(grid)
        for i in 1:n, j in 1:n
            temp[i, j] = local_temp(grid[i, j], temp[i, j], luminosity)
            if grid[i, j] == EMPTY && rand(rng) < 0.03
                newgrid[i, j] = rand(rng, [WHITE, BLACK])
            elseif grid[i, j] != EMPTY && rand(rng) < 0.02
                newgrid[i, j] = EMPTY
            end
        end
        grid = newgrid
    end

    heatmap(temp, title="init_white=$(init_white), L=$(luminosity)", colorbar=true)
end

p1 = run_case(0.2, 1.0)
p2 = run_case(0.8, 1.2)

savefig(p1, "plots/daisyworld_param/daisy_param_case1.png")
savefig(p2, "plots/daisyworld_param/daisy_param_case2.png")

println("Параметрические графики сохранены")
