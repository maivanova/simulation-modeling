using Agents, Random
using Agents.Graphs
using StatsBase: sample, Weights
using Distributions: Poisson

@agent struct Person(GraphAgent)
    days_infected::Int
    status::Symbol
end

function initialize_sir(;
    Ns = [300, 300, 300],
    migration_rates = nothing,
    β_und = [0.4, 0.4, 0.4],
    β_det = [0.05, 0.05, 0.05],
    infection_period = 14,
    detection_time = 7,
    death_rate = 0.02,
    reinfection_probability = 0.05,
    Is = [0, 0, 1],
    seed = 42
)
    rng = Xoshiro(seed)
    C = length(Ns)

    if migration_rates === nothing
        migration_rates = fill(1 / C, C, C)
    end

    space = GraphSpace(complete_graph(C))
    properties = Dict(
        :Ns => Ns,
        :β_und => β_und,
        :β_det => β_det,
        :migration_rates => migration_rates,
        :infection_period => infection_period,
        :detection_time => detection_time,
        :death_rate => death_rate,
        :reinfection_probability => reinfection_probability,
        :C => C
    )

    model = StandardABM(Person, space; properties, rng, agent_step! = sir_agent_step!)

    for city in 1:C
        for _ in 1:Ns[city]
            add_agent!(city, model, 0, :S)
        end
    end

    for city in 1:C
        if Is[city] > 0
            city_agents = ids_in_position(city, model)
            infected_ids = sample(rng, city_agents, Is[city]; replace=false)
            for id in infected_ids
                model[id].status = :I
                model[id].days_infected = 1
            end
        end
    end

    return model
end

function migrate!(agent, model)
    current_city = agent.pos
    probs = model.migration_rates[current_city, :]
    target = sample(abmrng(model), 1:model.C, Weights(probs))
    if target != current_city
        move_agent!(agent, target, model)
    end
end

function transmit!(agent, model)
    rate = agent.days_infected < model.detection_time ? model.β_und[agent.pos] : model.β_det[agent.pos]
    n_infections = rand(abmrng(model), Poisson(rate))
    n_infections == 0 && return nothing

    neighbors = [a for a in agents_in_position(agent.pos, model) if a.id != agent.id]
    shuffle!(abmrng(model), neighbors)

    for contact in neighbors
        if contact.status == :S
            contact.status = :I
            contact.days_infected = 1
            n_infections -= 1
        elseif contact.status == :R && rand(abmrng(model)) <= model.reinfection_probability
            contact.status = :I
            contact.days_infected = 1
            n_infections -= 1
        end
        n_infections == 0 && return nothing
    end
end

function recover_or_die!(agent, model)
    if agent.status == :I && agent.days_infected >= model.infection_period
        if rand(abmrng(model)) <= model.death_rate
            remove_agent!(agent, model)
        else
            agent.status = :R
            agent.days_infected = 0
        end
    end
end

function sir_agent_step!(agent, model)
    migrate!(agent, model)
    if agent.status == :I
        transmit!(agent, model)
        agent.days_infected += 1
    end
    recover_or_die!(agent, model)
end

infected_count(model) = count(a.status == :I for a in allagents(model))
recovered_count(model) = count(a.status == :R for a in allagents(model))
susceptible_count(model) = count(a.status == :S for a in allagents(model))
total_count(model) = nagents(model)
