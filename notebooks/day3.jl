# https://adventofcode.com/2020/day/3

# # Day 3: Toboggan Trajectory
#
# With the toboggan login problems resolved, you set off toward the airport. 
# While travel by toboggan might be easy, it's certainly not safe:
# there's very minimal steering and the area is covered in trees.
# You'll need to see which angles will take you near the fewest trees.
#
# Due to the local geology, trees in this area only grow on exact integer coordinates in a grid.
# You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. 
# For example:
#
#     ..##.......
#     #...#...#..
#     .#....#..#.
#     ..#.#...#.#
#     .#...##..#.
#     ..#.##.....
#     .#.#.#....#
#     .#........#
#     #.##...#...
#     #...##....#
#     .#..#...#.#
#
# These aren't the only trees, though;
# due to something you read about once involving arboreal genetics and biome stability,
# the same pattern repeats to the right many times:
#
#     ..##.........##.........##.........##.........##.........##.......  --->
#     #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
#     .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
#     ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
#     .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
#     ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
#     .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
#     .#........#.#........#.#........#.#........#.#........#.#........#
#     #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#     #...##....##...##....##...##....##...##....##...##....##...##....#
#     .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
#
# You start on the open square (.) in the top-left corner and need to reach the bottom
# (below the bottom-most row on your map).
#
# The toboggan can only follow a few specific slopes
# (you opted for a cheaper model that prefers rational numbers);
# start by counting all the trees you would encounter for the slope right 3, down 1:
#
# From your starting position at the top-left, 
# check the position that is right 3 and down 1.
# Then, check the position that is right 3 and down 1 from there, 
# and so on until you go past the bottom of the map.
#
# The locations you'd check in the above example are marked here with O
# where there was an open square and X where there was a tree:
#
#     ..##.........##.........##.........##.........##.........##.......  --->
#     #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
#     .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
#     ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
#     .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
#     ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
#     .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
#     .#........#.#........X.#........#.#........#.#........#.#........#
#     #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#     #...##....##...##....##...#X....##...##....##...##....##...##....#
#     .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
#
# In this example, traversing the map using this slope would cause you to encounter 7 trees.
#
# Starting at the top-left corner of your map and following a slope of right 3 and down 1,
# how many trees would you encounter?

# ## Setup

using Advent2020
using Advent2020.SparseArrays
using Test

example1 = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""

example1 = split(example1)

slope1 = (1,3)

function parse_terrain(input)
    xs = Int[]
    ys = Int[]
    for (i, line) in enumerate(input)
        for (j, c) in enumerate(line)
            if c == '#'
                push!(xs, i)
                push!(ys, j)
            end
        end
    end
    return sparse(xs, ys, ones(Bool, length(xs)))
end

function move_tob(terrain, pos, move)
    ncols = size(terrain, 2)

    newi = pos[1] + move[1]
    newj = pos[2] + move[2]
    newj > ncols && (newj -= ncols)
    return (newi, newj)
end

function run_toboggan(terrain, slope)
    nrows = size(terrain, 1)
    # starting pos
    i = 1 # row
    j = 1 # col
    trees = 0
    while true
        (i,j) = move_tob(terrain, (i, j), slope)
        i > nrows && break
        terrain[i,j] && (trees += 1)
    end
    return trees
end
example_terrain = parse_terrain(example1)

@test run_toboggan(example_terrain, slope1) == 7

# ### Answer

terrain = parse_terrain(get_data(3))

run_toboggan(terrain, (slope1))

@test run_toboggan(terrain, (slope1)) == 207

# ## Part 2
#
# Time to check the rest of the slopes -
# you need to minimize the probability of a sudden arboreal stopafter all.
#
# Determine the number of trees you would encounter if,
# for each of the following slopes,
# you start at the top-left corner and traverse the map all the way to the bottom:
#
#     Right 1, down 1.
#     Right 3, down 1. (This is the slope you already checked.)
#     Right 5, down 1.
#     Right 7, down 1.
#     Right 1, down 2.
#
# In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively;
# multiplied together, these produce the answer 336.
#
# What do you get if you multiply together the number of trees encountered on each of the listed slopes?

part2_slopes = [
    (1, 1)
    (1, 3)
    (1, 5)
    (1, 7)
    (2, 1)
]

function solve2(terrain, slopes)
    tree_product = 1
    for slope in slopes
        trees = run_toboggan(terrain, slope)
        tree_product *= trees
    end
    return tree_product
end

@test solve2(example_terrain, part2_slopes) == 336

# ### Answer:

@warn "Part 2 answer:" solve2(terrain, part2_slopes)
@test solve2(terrain, part2_slopes) == 2655892800
