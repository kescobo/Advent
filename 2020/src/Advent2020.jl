module Advent2020

# Utilities
export get_data

# Day 1
export in_to_int,
       accounting

# Day 2
export parse_day2_input,
       isvalidpw_sled,
       isvalidpw_toboggan



using Combinatorics



#############
# Functions #
#############

# Utiliites

_get_input_path(day) = joinpath(@__DIR__, "..", "data", "day_$day.txt")
get_data(day) = eachline(_get_input_path(day))

# Day 1

function in_to_int(input)
    return parse.(Int, input)
end

function accounting(input, n)
    for c in combinations(input, n)
        reduce(+, c) == 2020 && return reduce(*, c)
    end
    error("No combinations of $n elements sum to 2020")
end

# Day 2

function parse_day2_input(line)
    (counts, letter, pw) = split(line, ' ')
    (lower, upper) = parse.(Int, split(counts, '-'))
    letter = first(letter)
    return (password=pw, letter=letter, lower=lower, upper=upper)
end # module

function isvalidpw_sled(pw, letter, lower, upper)
    c = 0
    for i in eachindex(pw)
        pw[i] == letter && (c += 1)
        c > upper && return false
    end
    return c >= lower
end

function isvalidpw_toboggan(pw, letter, lower, upper)
    (pw[lower] == letter) ⊻ (pw[upper] == letter)
end

end # module