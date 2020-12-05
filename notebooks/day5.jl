# https://adventofcode.com/2020/day/5

# --- Day 5: Binary Boarding ---   
#
# - A seat might be specified like FBFBBFFRLR, 
#   where F means "front", B means "back", L means "left", and R means "right".
# - The first 7 characters will either be F or B; 
#   these specify exactly one of the 128 rows on the plane (numbered 0 through 127)
# - the first letter indicates whether the seat is in the front (0 through 63) 
#   or the back (64 through 127). 
#     - The next letter indicates which half of that region the seat is in,
#       and so on until you're left with exactly one row.
# 
# For example, consider just the first seven characters of `FBFBBFFRLR`:
# 
# - Start by considering the whole range, rows 0 through 127.
# - F means to take the lower half, keeping rows 0 through 63.
# - B means to take the upper half, keeping rows 32 through 63.
# - F means to take the lower half, keeping rows 32 through 47.
# - B means to take the upper half, keeping rows 40 through 47.
# - B keeps rows 44 through 47.
# - F keeps rows 44 through 45.
# - The final F keeps the lower of the two, row 44.

# - The last three characters will be either L or R
# - Same idea, but with 0-7 rather than 0-127

using Advent2020
using Test

struct Day5Part1 end
struct Day5Part2 end


example1 = "FBFBBFFRLR"
findseat(example1)
Advent2020.seatid(44,5)

@testset "Part1 examples" begin
    s = findseat("FBFBBFFRLR")
    @test s == (44, 5)
    @test seatid(s...) == 357
    s = findseat("BFFFBBFRRR")
    @test s == (70, 7)
    @test seatid(s...) == 567
    s = findseat("FFFBBBFRRR")
    @test s == (14, 7)
    @test seatid(s...) == 119
    s = findseat("BBFFBBFRLL")
    @test s == (102, 4)
    @test seatid(s...) == 820
end

#-

@time part5_1 = maximum(line-> seatid(findseat(line)...), get_data(5))
@warn "Answer:" count(isvalidpassport, eachrow(day4_data))

# --- Part Two ---
#
# Ding! The "fasten seat belt" signs have turned on. Time to find your seat.
#
# It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.
#
# Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.
#
# What is the ID of your seat?

seats = map(line-> seatid(findseat(line)...), get_data(5)) |> sort
function find_empty(seats)
    (fst, lst) = (firstindex(seats), lastindex(seats))
    for i in eachindex(seats) 
        i == fst && continue
        i == lst && error("Reached the last seat without finding open one")
        seats[i] != seats[i+1] - 1 && return seats[i] + 1
    end
end

@warn "Answer:" find_empty(seats)
@test find_empty(seats) == 603