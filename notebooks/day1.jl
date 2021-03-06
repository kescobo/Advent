# https://adventofcode.com/2020/day/1

# # --- Day 1: Report Repair ---
#
# After saving Christmas five years in a row,
# you've decided to take a vacation at a nice resort on a tropical island.
# Surely, Christmas will go on without you.
#
# The tropical island has its own currency and is entirely cash-only.
# The gold coins used there have a little picture of a starfish;
# the locals just call them stars. None of the currency exchanges seem to have heard of them,
# but somehow, you'll need to find fifty of these coins by the time you arrive
# so you can pay the deposit on your room.
#
# To save your vacation, you need to get all fifty stars by December 25th.
#
# Collect stars by solving puzzles.
# Two puzzles will be made available on each day in the Advent calendar;
# the second puzzle is unlocked when you complete the first.
# Each puzzle grants one star. Good luck!
#
# Before you leave,
# the Elves in accounting just need you to fix your expense report (your puzzle input);
# apparently, something isn't quite adding up.
#
# Specifically,
# they need you to find the two entries that sum to 2020 and then multiply those two numbers together.
#
# For example, suppose your expense report contained the following:
#
#     1721
#     979
#     366
#     299
#     675
#     1456
#
# In this list, the two entries that sum to 2020 are 1721 and 299.
# Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.
#
# Of course, your expense report is much larger.
# Find the two entries that sum to 2020; what do you get if you multiply them together?

# ## Setup

using Advent2020
using Test
using Advent2020.Combinatorics

const day1_input = parse.(Int, get_data(1))

# ## Part 1

function check_pairs(input)
    for (i, j) in combinations(input, 2)
        i + j == 2020 && return i * j
    end
    error("No combinations added up to 2020")
end

testin = [1721, 979, 366, 299, 675, 1456]

@test check_pairs(testin) == 514579

part1result = check_pairs(day1_input)
@warn "Answer:" part1result

@test part1result == 381699

# ## Part 2
#
# The Elves in accounting are thankful for your help;
# one of them even offers you a starfish coin they had left over from a past vacation.
# They offer you a second one if you can find three numbers in your expense report
# that meet the same criteria.
#
# Using the above example again,
# the three entries that sum to 2020 are 979, 366, and 675.
# Multiplying them together produces the answer, 241861950.
#
# In your expense report, what is the product of the three entries that sum to 2020?

function check_n(input, n) 
    for c in combinations(input, n)
        reduce(+, c) == 2020 && return reduce(*, c)
    end
    error("No combinations of length $n added up to 2020")
end

@testset "Part2 Demodata" begin
    @test check_n(testin, 3) == 241861950
    @test check_n(day1_input, 2) == check_pairs(day1_input)
end

part2result = check_n(day1_input, 3)
@warn "Answer:" part2result

@test part2result == 111605670

# ## Using Module

@info "Part 1" accounting(day1_input, 2)
@info "Part 2" accounting(day1_input, 3)

@testset "Module Function" begin
    @test accounting(day1_input, 2) == part1result
    @test accounting(day1_input, 3) == part2result
end
