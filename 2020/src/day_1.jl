# https://adventofcode.com/2020/day/1

# # --- Day 1: Report Repair ---
# 
# After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.
# 
# The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.
# 
# To save your vacation, you need to get all fifty stars by December 25th.
# 
# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

# ## Setup

using Combinatorics, Test

const input = parse.(Int, readlines("data/day_1.txt"))

# ## Part 1
#
# Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.
# 
# Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.
#
# For example, suppose your expense report contained the following:
#
# ```
# 1721
# 979
# 366
# 299
# 675
# 1456
# ```
#
# In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.
#
# Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

function part1(input)
    entries = parse.(Int, input)
    n = length(entries)
    for (e1, e2) in 
end

testin = [1721, 979, 366, 299, 675, 1456]

@test part1(testin) = 514579

@info "Part 1" part1(input)


function part_2(input)
    nothing
end
@info part_2(input)
