using Advent2020

function parseline!(bags, line)
    m1 = match(r"^(?<parent>\w+ \w+) bags contain (?<rest>.+)", line)
    isnothing(m1) && error("malformed rule: $line")
    bag = m1[:parent]
    in(bag, keys(bags)) && error("already saw that bag")
    rest = m1[:rest]
    container = Dict{String, Int}()
    rest == "no other bags." && return (bags[bag] = container)
    for m in eachmatch(r"(?<count>\d+) (?<desc>\w+ \w+) bags?", rest)
        container[m[:desc]] = parse(Int, m[:count])
    end
    bags[bag] = container
end

bags = Dict{String, Dict}()
for line in get_data(7)
    parseline!(bags, line)
end

function findparents!(allparents, bag, bagrules)
    parents = findall(d -> any(==(bag), keys(d)), bagrules)
    isempty(parents) && return allparents
    push!(allparents, parents...)
    for parent in parents
        findparents!(allparents, parent, bagrules)
    end
    return allparents
end
part1 = findparents!(Set{String}(), "shiny gold", bags) |> length
function countchildren(bag, bagrules)
    nbags = 0
    contents = bagrules[bag]
    isempty(contents) && return 0
    for (k, v) in contents
        nbags += v*(1 + countchildren(k, bagrules))
    end
    return nbags
end
part2 = countchildren("shiny gold", bags)
