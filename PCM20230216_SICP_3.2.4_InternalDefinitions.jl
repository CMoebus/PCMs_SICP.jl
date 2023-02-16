### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ c8631290-ae0c-11ed-173b-9d7387f2c549
md"
====================================================================================
#### SICP: [3.2.4 Internal Definitions](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e4)
##### file: PCM20230216\_SICP\_3.2.4\_InternalDefinitions.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/16 ***

====================================================================================
"


# ╔═╡ a51b896f-3a5c-4b5b-bfea-ef26fb6588b5
md"
##### 3.2.4.1 Scheme-like Julia
"

# ╔═╡ cee8e162-9634-4fe7-a438-6778ea5a82d3
function mySqrt(x)
	#---------------------------------------
	function goodEnough(guess)
		<(abs(-(square(guess), x)), 0.001)
	end # function goodEnough
	#---------------------------------------
	function improve(guess)
		average(guess, /(x, guess))
	end # function improve
	#---------------------------------------
	function sqrtIter(guess)
		goodEnough(guess) ?
			guess :
			sqrtIter(improve(guess))
	end # function sqrtIter
	#---------------------------------------
	function square(x) 
		x * x
	end # function square
	#---------------------------------------
	function average(x, y)
		(x + y)/2.0
	end # function average
	#---------------------------------------
	sqrtIter(1.0)
end # function mySqrt

# ╔═╡ 33d12028-a191-4546-ba62-54bc7c3c1bac
mySqrt(2)

# ╔═╡ 5215a91d-9416-4de4-b1c3-38327194034a
mySqrt(2)^2

# ╔═╡ a0bfec70-523f-4030-8265-860d27372cac
mySqrt(4)

# ╔═╡ b16eef0c-d3b9-4e99-b670-55f60c98412f
mySqrt(4)^2

# ╔═╡ 1c09fa26-1007-4fbf-949a-12af9e5b1225
md"
###### Global and local definitions mit $let$ and $\lambda$-expressions
"

# ╔═╡ bad831b4-dff1-473a-94ed-3aabdc388e88
let 
	#--------------------------------------------------------------------------------
	mySqrt2        =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		square     =      x -> x * x                         #  local environment E1
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		#----------------------------------------------------------------------------
		sqrtIter(1.0)
	end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2(2)^2
 # global environment E0
end # let  global environment E0

# ╔═╡ a25e7902-6ee9-415b-bedf-3453a1c4fc7e
md"
---
##### 3.2.4.2 Simulation of environments with *nested* $let$s
"

# ╔═╡ b539fcc1-c866-4903-83af-b3c2a721e32e
md"
###### Algorithm with nested $let$s
"

# ╔═╡ c061fb55-3379-4a83-bd81-7c461206e2c0
let 
	#--------------------------------------------------------------------------------
	mySqrt2        =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		square     =      x -> x * x                         #  local environment E1
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		#----------------------------------------------------------------------------
		sqrtIter(1.0)
	end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2(2)^2
 # global environment E0
end # let  global environment E0

# ╔═╡ a28b0a63-6df9-4423-ab8e-ca458dcfabbb
md"
---
###### Environments *E0* and *E1* after *global* and *internal* (=local) definitions
"

# ╔═╡ c66c2258-25c4-4442-a955-f9f3f19bc964
let 
	#--------------------------------------------------------------------------------
	mySqrt2        =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		square     =      x -> x * x                         #  local environment E1
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		#----------------------------------------------------------------------------
	end # let local environment E1
	#--------------------------------------------------------------------------------
 # global environment E0
end # let  global environment E0

# ╔═╡ 523391cc-e2f4-49a4-ba9d-5c205b3843be
md"
---
###### Environments *E0* and *E1* after *application* $mySqrt2(2)$
Result is new binding $x=2$ (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ 485a50a9-0858-4639-813b-9d003d1d8e8b
let 
	#--------------------------------------------------------------------------------
	# mySqrt2      =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		x          = 2.0
		square     =      x -> x * x                         #  local environment E1
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		#----------------------------------------------------------------------------
		sqrtIter(1.0)
	end # let local environment E1
	#--------------------------------------------------------------------------------
 # global environment E0
end # let  global environment E0

# ╔═╡ 8e565a5a-8381-465a-b79f-a63f493b3570
md"
---
###### Environments *E0*, *E1*, and *E2* after *application* $sqrtIter(1.0)$
Result is new binding $guess=1.0$ (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ c6581a0f-8690-459b-9c12-2c01846e0018
let 
	#--------------------------------------------------------------------------------
	# mySqrt2      =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		x          = 2.0
		square     =      x -> x * x                         #  local environment E1
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		#----------------------------------------------------------------------------
		let 
			#------------------------------------------------------------------------
			guess = 1.0                                     #  local environment E2
			#------------------------------------------------------------------------
			goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))
		end #  # let local environment E2
	end # let local environment E1
	#--------------------------------------------------------------------------------
end # let  global environment E0

# ╔═╡ 3d56eebc-132c-4231-94f4-6cbd2fe51985
md"
---
###### Environments *E0*, *E1*, and *E2* after *application* $goodEnough(1.0)$
Result is new binding $guess=1.0$ (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ f80e0478-a0fa-4c3c-ab63-8ef4a96fe00e
let 
	#--------------------------------------------------------------------------------
	# mySqrt2      =      x ->                               # global environment E0
	#--------------------------------------------------------------------------------
	let 
		#----------------------------------------------------------------------------
		x          = 2.0                                     #  local environment E1
		square     =      x -> x * x                        
		goodEnough = guess  -> <(abs(-(square(guess), x)), 0.001)
		improve    = guess  -> average(guess, /(x, guess))
		sqrtIter   = guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

		average    = (x, y) -> (x + y)/2.0
		let 
			#------------------------------------------------------------------------
			guess = 1.0                                     #  local environment E2
			#------------------------------------------------------------------------
			let
				#--------------------------------------------------------------------
				guess = 1.0                                 #  local environment E3
				sqrtIter(improve(guess))
				#--------------------------------------------------------------------
			end # let local environment E3
			#------------------------------------------------------------------------
		end #  # let local environment E2
		#----------------------------------------------------------------------------
	end # let local environment E1
	#--------------------------------------------------------------------------------
end # let  global environment E0

# ╔═╡ 8e10c0ad-7347-45d7-9892-2f7a62800850
md"
---
##### end of ch. 3.2.3
"


# ╔═╡ 045fba1d-ec31-4716-b674-905cdb9dc7dd
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─c8631290-ae0c-11ed-173b-9d7387f2c549
# ╟─a51b896f-3a5c-4b5b-bfea-ef26fb6588b5
# ╠═cee8e162-9634-4fe7-a438-6778ea5a82d3
# ╠═33d12028-a191-4546-ba62-54bc7c3c1bac
# ╠═5215a91d-9416-4de4-b1c3-38327194034a
# ╠═a0bfec70-523f-4030-8265-860d27372cac
# ╠═b16eef0c-d3b9-4e99-b670-55f60c98412f
# ╟─1c09fa26-1007-4fbf-949a-12af9e5b1225
# ╠═bad831b4-dff1-473a-94ed-3aabdc388e88
# ╟─a25e7902-6ee9-415b-bedf-3453a1c4fc7e
# ╟─b539fcc1-c866-4903-83af-b3c2a721e32e
# ╠═c061fb55-3379-4a83-bd81-7c461206e2c0
# ╟─a28b0a63-6df9-4423-ab8e-ca458dcfabbb
# ╠═c66c2258-25c4-4442-a955-f9f3f19bc964
# ╟─523391cc-e2f4-49a4-ba9d-5c205b3843be
# ╠═485a50a9-0858-4639-813b-9d003d1d8e8b
# ╟─8e565a5a-8381-465a-b79f-a63f493b3570
# ╠═c6581a0f-8690-459b-9c12-2c01846e0018
# ╟─3d56eebc-132c-4231-94f4-6cbd2fe51985
# ╠═f80e0478-a0fa-4c3c-ab63-8ef4a96fe00e
# ╟─8e10c0ad-7347-45d7-9892-2f7a62800850
# ╟─045fba1d-ec31-4716-b674-905cdb9dc7dd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
