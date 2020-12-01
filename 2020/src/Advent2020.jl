module Advent2020

export in_to_int,
       accounting

using Combinatorics

function in_to_int(input)
    return parse.(Int, input)
end

function accounting(input, n)
    for c in combinations(input, n)
        reduce(+, c) == 2020 && return reduce(*, c)
    end
    error("No combinations of $n elements sum to 2020")
end

end # module