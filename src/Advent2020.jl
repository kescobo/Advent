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


# Utilities
using HTTP, Dates, JSON
# Day 1
using Combinatorics
# Day 3
using SparseArrays


#############
# Functions #
#############

# Utiliites (Some modified from https://github.com/SebRollen/AdventOfCode.jl/blob/master/src/AdventOfCode.jl)
_base_url(year, day) = "https://adventofcode.com/$year/day/$day"

function _get_cookies()
    if "AOC_SESSION" ∉ keys(ENV)
        error("Session cookie in ENV[\"AOC_SESSION\"] needed to download data.")
    end
    return Dict("session" => ENV["AOC_SESSION"])
end

function _download_data(year, day)
    result = HTTP.get(_base_url(year, day) * "/input", cookies = _get_cookies())
    if result.status == 200
        return result.body
    end
    error("Unable to download data")
end

function _is_unlocked(year, day)
    time_req = HTTP.get("http://worldclockapi.com/api/json/est/now")
    current_datetime = JSON.parse(String(time_req.body))["currentDateTime"]
    current_date = Date(current_datetime[1:10])
    is_unlocked = current_date >= Date(year, 12, day)
    if !is_unlocked
        @warn "Advent of Code for year $year and day $day hasn't unlocked yet."
    end
    is_unlocked
end

function _setup_data_file(year, day, path)
    if isfile(path)
        @warn "$data_path already exists. AdventOfCode.jl will not redownload it"
        return nothing
    end
    time_req = HTTP.get("http://worldclockapi.com/api/json/est/now")
    current_datetime = JSON.parse(String(time_req.body))["currentDateTime"]
    current_date = Date(current_datetime[1:10])
    if _is_unlocked(year, day)
        data = _download_data(year, day)
        mkpath(splitdir(path)[1])
        open(path, "w+") do io
            write(io, data)
        end
    end
end

_get_input_path(day) = joinpath(@__DIR__, "..", "data", "day_$day.txt")

function get_data(day)
    datapath = _get_input_path(day)
    isfile(datapath) || _setup_data_file(2020, day, datapath)
    eachline(datapath)
end

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