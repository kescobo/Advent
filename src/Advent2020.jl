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

# Day 4
export parse_passport,
       iter_passports,
       isvalidpassport,
       PPField,
       ppfield,
       isvalidfield

# Utilities
using HTTP, Dates, JSON
# Day 1
using Combinatorics
# Day 3
using SparseArrays
# Day 4
using DataFrames


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

# Day 4

function parse_passport(passport)
    entries = split(passport, (' ', ':', '\n'))
    pp = NamedTuple(
        Symbol(entries[i])=>entries[i+1] for i in 1:2:length(entries)
    )
    return pp
end


const PP_FIELDS = (:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid)

struct PPField{x} 
    value::AbstractString
end

getvalue(ppf::PPField) = ppf.value

ppfield(x::Symbol, val) = PPField{x}(string(val))
ppfield(x::AbstractString, val) = ppfield(Symbol(x), val)

isvalidfield(::PPField) = error("No rule defined for this field" )
isvalidfield(::PPField{:cid}) = true


function isvalidfield(ppf::PPField{:byr})
    val = getvalue(ppf)
    occursin(r"^\d{4}$", val) || return false
    yr = parse(Int, val)
    return 1920 <= yr <= 2002

end

function isvalidfield(ppf::PPField{:iyr})
    val = getvalue(ppf)
    occursin(r"^\d{4}$", val) || return false
    yr = parse(Int, val)
    return 2010 <= yr <= 2020
end

function isvalidfield(ppf::PPField{:eyr})
    val = getvalue(ppf)
    occursin(r"^\d{4}$", val) || return false
    yr = parse(Int, val)
    return 2020 <= yr <= 2030
end

function isvalidfield(ppf::PPField{:hgt})
    val = getvalue(ppf)
    m = match(r"^(\d{2,3})(cm|in)$", val)
    isnothing(m) && return false
    (height, unit) = m.captures
    height = parse(Int, height)
    (unit == "cm") && (150 <= height <= 193) && return true
    (unit == "in") && (59 <= height <= 76) && return true
    return false
end

function isvalidfield(ppf::PPField{:hcl})
    val = getvalue(ppf)
    return occursin(r"^#[0-9a-f]{6}$", val)
end

function isvalidfield(ppf::PPField{:ecl})
    val = getvalue(ppf)
    return in(val, ("amb", "blu", "brn", "gry", "grn", "hzl", "oth"))
end

function isvalidfield(ppf::PPField{:pid})
    val = getvalue(ppf)
    return occursin(r"^\d{9}$", val)
end


function iter_passports(batch)
    passports = DataFrame([f=> String[] for f in PP_FIELDS])
    pp = ""
    for line in batch
        if isempty(line)
            push!(passports, parse_passport(pp), cols=:subset)
            pp = ""
            continue
        end
        pp = isempty(pp) ? line : join((pp, line), ' ')
    end
    !isempty(pp) && push!(passports, parse_passport(pp), cols=:subset)
    return passports
end

function isvalidpassport(passport)
    !any(ismissing, (passport[f] for f in PP_FIELDS[1:end-1]))
end



end # module