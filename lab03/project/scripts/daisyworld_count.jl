using Pkg
Pkg.activate(".")

using DelimitedFiles
using Plots

mkpath("plots/daisyworld_count")

data = readdlm("data/daisyworld_simple/daisy_counts.csv", ',', skipstart=1)
steps = data[:,1]
white = data[:,2]
black = data[:,3]

p = plot(steps, black, label="black", color=:black,
    xlabel="tick", ylabel="daisy count",
    title="Число маргариток")

plot!(p, steps, white, label="white", color=:orange)

savefig(p, "plots/daisyworld_count/daisy_count.png")
println("График количества маргариток сохранён")
