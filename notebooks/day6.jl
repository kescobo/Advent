using Advent2020

part1 = sum(grp-> length(Set(grp)), eachgroup(get_data(6), ""))

sum(eachgroup(get_data(6))) do grp
    length(intersect([Set(p) for p in split(grp)]...))
end
