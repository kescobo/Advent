### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ c2fabaac-34aa-11eb-3591-d94b9551730a
using Revise, Advent2020, Test

# ╔═╡ 643df736-34aa-11eb-3524-b3b6578f9b18
md"""
# --- Day 2: Password Philosophy ---

Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

For example, suppose you have the following list:

```
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
```

Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?
"""

# ╔═╡ ad7cd836-34aa-11eb-0d43-e727685896f5
md"## Setup"

# ╔═╡ afce5e5e-34ad-11eb-0a01-bd3b4440d767
demodata = [
	"1-3 a: abcde",
	"1-3 b: cdefg",
	"2-9 c: ccccccccc"]

# ╔═╡ 9be24a16-34af-11eb-1f64-4b2d85365ef6
day2data = get_data(2)

# ╔═╡ ca55aade-34b0-11eb-1b00-5b5c2a409f90


# ╔═╡ d2750582-34af-11eb-37ca-3520d89d3edd
md"## Part 1"

# ╔═╡ ca5b38a0-34ad-11eb-03e3-35a4251eaa2f
demo = parse_day2_input.(demodata)

# ╔═╡ d2de1196-34ad-11eb-2f4e-770ec353adc3
demo[1].password

# ╔═╡ eba2cbf4-34ad-11eb-3410-cb7473b49289
demo[1].letter

# ╔═╡ c7af83da-34ae-11eb-1a37-b37854e5bdbc
demo[1].upper

# ╔═╡ fad69e7a-34ad-11eb-00bf-1b1796fac43c
let d = first(demo)
	@info d.password, d.letter, d.lower, d.upper
	isvalidpw(d.password, d.letter, d.lower, d.upper)
end

# ╔═╡ 1e4043f2-34ae-11eb-27a9-7ffc5581d11f
@testset "Demodata" begin
	for line in demo
		@test line.lower < line.upper
	end
	count(line-> isvalidpw(line...), demo) == 2
end

# ╔═╡ cfdbe854-34aa-11eb-2b23-2529b873cdf7
count(line-> isvalidpw(line...), parse_day2_input.(day2data))

# ╔═╡ e1cb1eae-34af-11eb-05af-5dbd5634dc70
md"""
## Part 2

While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

Given the same example list from above:

    1-3 a: abcde is valid: position 1 contains a and position 3 does not.
    1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
    2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.

How many passwords are valid according to the new interpretation of the policies?
"""

# ╔═╡ eedc9fac-34af-11eb-3aea-df963d26e609
@test isvalidpw_toboggan(demo[1]...)

# ╔═╡ 9d9cb944-34b0-11eb-3670-37a23daf738a
@test !isvalidpw_toboggan(demo[2]...)

# ╔═╡ 24eb4b0e-34b1-11eb-3a30-735a701d9db7
@test !isvalidpw_toboggan(demo[3]...)

# ╔═╡ 2d2d398a-34b1-11eb-140b-630057fdf4d8
count(line-> isvalidpw_toboggan(line...), parse_day2_input.(day2data))

# ╔═╡ Cell order:
# ╟─643df736-34aa-11eb-3524-b3b6578f9b18
# ╟─ad7cd836-34aa-11eb-0d43-e727685896f5
# ╠═c2fabaac-34aa-11eb-3591-d94b9551730a
# ╠═afce5e5e-34ad-11eb-0a01-bd3b4440d767
# ╠═9be24a16-34af-11eb-1f64-4b2d85365ef6
# ╠═ca55aade-34b0-11eb-1b00-5b5c2a409f90
# ╟─d2750582-34af-11eb-37ca-3520d89d3edd
# ╠═ca5b38a0-34ad-11eb-03e3-35a4251eaa2f
# ╠═d2de1196-34ad-11eb-2f4e-770ec353adc3
# ╠═eba2cbf4-34ad-11eb-3410-cb7473b49289
# ╠═c7af83da-34ae-11eb-1a37-b37854e5bdbc
# ╠═fad69e7a-34ad-11eb-00bf-1b1796fac43c
# ╠═1e4043f2-34ae-11eb-27a9-7ffc5581d11f
# ╠═cfdbe854-34aa-11eb-2b23-2529b873cdf7
# ╟─e1cb1eae-34af-11eb-05af-5dbd5634dc70
# ╠═eedc9fac-34af-11eb-3aea-df963d26e609
# ╠═9d9cb944-34b0-11eb-3670-37a23daf738a
# ╠═24eb4b0e-34b1-11eb-3a30-735a701d9db7
# ╠═2d2d398a-34b1-11eb-140b-630057fdf4d8
