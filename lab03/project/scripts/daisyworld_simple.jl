using Pkg
Pkg.activate(".")

using Plots
using Random
using Statistics

function run_daisyworld()
    mkpath("plots/daisyworld_simple")
    mkpath("data/daisyworld_simple")

    EMPTY = 0
    WHITE = 1
    BLACK = 2

    n = 30
    steps = 40
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

    function step_model(grid, temp, luminosity, rng)
        n = size(grid, 1)
        newgrid = copy(grid)
        newtemp = copy(temp)

        for i in 1:n, j in 1:n
            newtemp[i, j] = local_temp(grid[i, j], temp[i, j], luminosity)
        end

        for i in 1:n, j in 1:n
            if grid[i, j] != EMPTY
                if rand(rng) < 0.02
                    newgrid[i, j] = EMPTY
                end
            else
                neigh = Tuple{Int,Int}[]
                for di in -1:1, dj in -1:1
                    ni = mod1(i + di, n)
                    nj = mod1(j + dj, n)
                    if !(di == 0 && dj == 0) && grid[ni, nj] != EMPTY
                        push!(neigh, (ni, nj))
                    end
                end
                if !isempty(neigh)
                    parent = rand(rng, neigh)
                    parent_type = grid[parent...]
                    t = newtemp[i, j]
                    growth = max(0.0, 1.0 - abs(t - 22.0) / 20.0)
                    if rand(rng) < 0.15 * growth
                        newgrid[i, j] = parent_type
                    end
                end
            end
        end

        return newgrid, newtemp
    end

    white_counts = Int[]
    black_counts = Int[]
    mean_temps = Float64[]

    p1 = heatmap(surface_temp, title="Daisyworld: шаг 0", colorbar=true)
    savefig(p1, "plots/daisyworld_simple/daisy_step000.png")

    for s in 1:steps
        grid, surface_temp = step_model(grid, surface_temp, solar_luminosity, rng)
        push!(white_counts, count(==(WHITE), grid))
        push!(black_counts, count(==(BLACK), grid))
        push!(mean_temps, mean(surface_temp))

        if s == 5
            p = heatmap(surface_temp, title="Daisyworld: шаг 5", colorbar=true)
            savefig(p, "plots/daisyworld_simple/daisy_step005.png")
        end
        if s == 40
            p = heatmap(surface_temp, title="Daisyworld: шаг 40", colorbar=true)
            savefig(p, "plots/daisyworld_simple/daisy_step040.png")
        end
    end

    open("data/daisyworld_simple/daisy_counts.csv", "w") do io
        println(io, "step,white,black,temperature")
        for i in 1:length(white_counts)
            println(io, "$(i),$(white_counts[i]),$(black_counts[i]),$(mean_temps[i])")
        end
    end

    println("Daisyworld simple завершена")
    println("Белые (последний шаг): ", white_counts[end])
    println("Чёрные (последний шаг): ", black_counts[end])
    println("Средняя температура: ", round(mean_temps[end], digits=2))
end

run_daisyworld()
