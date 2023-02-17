### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ c8631290-ae0c-11ed-173b-9d7387f2c549
md"
====================================================================================
#### SICP: [3.2.4 Internal Definitions](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e4)
##### file: PCM20230216\_SICP\_3.2.4\_InternalDefinitions.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/17 ***

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
---
##### 3.2.4.2 Definitions with *nested* $let$ and $\lambda$-expressions and *application* in *E0*
"

# ╔═╡ bad831b4-dff1-473a-94ed-3aabdc388e88
let                                                          # global environment E0
	#--------------------------------------------------------------------------------
	closureInE0 =                                            # 1st binding in E0
		x ->                               
			#------------------------------------------------------------------------
			let                                              #  local environment E1
				#--------------------------------------------------------------------
				square     =      x -> x * x                 # binding in E1
				goodEnough =                                 # binding in E1
					guess  ->                                # binding in E1
						<(abs(-(square(guess), x)), 0.001)
				improve    =                                 # binding in E1
					guess  -> average(guess, /(x, guess))
				sqrtIter   =                                 # binding in E1
					guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

				average    =                                 # binding in E1
					(x, y) -> (x + y)/2.0
				#--------------------------------------------------------------------
				sqrtIter(1.0)
			end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2     = closureInE0                                # 2nd binding in E0
	#--------------------------------------------------------------------------------
	mySqrt2(2)^2                                             # application in E0
end # let  global environment E0

# ╔═╡ e0ca0383-37fd-4b3f-984e-939c6856a151
md"
---
###### Environments *E0* and *E1* after definitions
"

# ╔═╡ ea207616-dba5-457e-a55b-80162996b1d9
let                                                          # global environment E0
	#--------------------------------------------------------------------------------
	closureInE0 =                                            # 1st binding in E0
		x ->                               
			#------------------------------------------------------------------------
			let                                              #  local environment E1
				#--------------------------------------------------------------------
				square     =      x -> x * x                 # binding in E1
				goodEnough =                                 # binding in E1
					guess  ->                                # binding in E1
						<(abs(-(square(guess), x)), 0.001)
				improve    =                                 # binding in E1
					guess  -> average(guess, /(x, guess))
				sqrtIter   =                                 # binding in E1
					guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

				average    =                                 # binding in E1
					(x, y) -> (x + y)/2.0
				#--------------------------------------------------------------------
				sqrtIter(1.0)
			end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2     = closureInE0                                # 2nd binding in E0
	#--------------------------------------------------------------------------------
	# mySqrt2(2)^2                                           # application in E0
end # let  global environment E0

# ╔═╡ 523391cc-e2f4-49a4-ba9d-5c205b3843be
md"
---
###### Environments *E0* and *E1* after *application* $mySqrt2(2)$
Result is new binding $x=2$ (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ 1b3f120f-c2aa-4d42-a7be-adab650428b5
let                                                          # global environment E0
	#--------------------------------------------------------------------------------
	closureInE0 =                                            # 1st binding in E0      
			#------------------------------------------------------------------------
			let                                              #  local environment E1
				#--------------------------------------------------------------------
				x          =   2.0                           # new binding
				square     =      x -> x * x                 # binding in E1
				goodEnough =                                 # binding in E1
					guess  ->                                # binding in E1
						<(abs(-(square(guess), x)), 0.001)
				improve    =                                 # binding in E1
					guess  -> average(guess, /(x, guess))
				sqrtIter   =                                 # binding in E1
					guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

				average    =                                 # binding in E1
					(x, y) -> (x + y)/2.0
				#--------------------------------------------------------------------
				sqrtIter(1.0)
			end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2     = closureInE0                                # 2nd binding in E0
	#--------------------------------------------------------------------------------
	# mySqrt2(2)^2                                           # application in E0
end # let  global environment E0

# ╔═╡ 8e565a5a-8381-465a-b79f-a63f493b3570
md"
---
###### Environments *E0*, *E1*, and *E2* after *application* $sqrtIter(1.0)$
Result is new binding $guess=1.0$ in *E2* (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ 4c1fb8a7-752a-44f6-879d-c889198667d3
let                                                          # global environment E0
	#--------------------------------------------------------------------------------
	closureInE0 =                                            # 1st binding in E0      
			#------------------------------------------------------------------------
			let                                              #  local environment E1
				#--------------------------------------------------------------------
				x          =   2.0                           # new binding
				square     =      x -> x * x                 # binding in E1
				goodEnough =                                 # binding in E1
					guess  ->                                # binding in E1
						<(abs(-(square(guess), x)), 0.001)
				improve    =                                 # binding in E1
					guess  -> average(guess, /(x, guess))
				sqrtIter   =                                 # binding in E1
					guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

				average    =                                 # binding in E1
					(x, y) -> (x + y)/2.0
				#--------------------------------------------------------------------
				let                                          # local environment E2
					#----------------------------------------------------------------
					guess = 1.0                              # binding in E2
					#----------------------------------------------------------------
					goodEnough(guess) ?
						guess :
						sqrtIter(improve(guess))
					#----------------------------------------------------------------
				end #  # let local environment E2
				#--------------------------------------------------------------------
				# sqrtIter(1.0)
			end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2     = closureInE0                                # 2nd binding in E0
	#--------------------------------------------------------------------------------
	# mySqrt2(2)^2                                           # application in E0
end # let  global environment E0

# ╔═╡ 3d56eebc-132c-4231-94f4-6cbd2fe51985
md"
---
###### Environments *E0*, *E1*, and *E2* after *application* $goodEnough(1.0)$
Result is new binding $guess=1.0$ in *E3* (cf. Fig.3.11, SICP, 1996):
"

# ╔═╡ 96955c6d-20ac-46ac-a202-c564a85993d7
let                                                          # global environment E0
	#--------------------------------------------------------------------------------
	closureInE0 =                                            # 1st binding in E0      
			#------------------------------------------------------------------------
			let                                              #  local environment E1
				#--------------------------------------------------------------------
				x          =   2.0                           # new binding
				square     =   x -> x * x                    # binding in E1
				goodEnough =                                 # binding in E1
					guess  ->                                # binding in E1
						<(abs(-(square(guess), x)), 0.001)
				improve    =                                 # binding in E1
					guess  -> average(guess, /(x, guess))
				sqrtIter   =                                 # binding in E1
					guess  -> goodEnough(guess) ?
								guess :
								sqrtIter(improve(guess))

				average    =                                 # binding in E1
					(x, y) -> (x + y)/2.0
				#--------------------------------------------------------------------
				let                                          # local environment E2
					#----------------------------------------------------------------
					guess = 1.0                              # binding in E2
					#----------------------------------------------------------------
					let                                      # local environment E3
						#------------------------------------------------------------
						guess = 1.0                                 
						sqrtIter(improve(guess))
						#------------------------------------------------------------
					end # let local environment E3
				#--------------------------------------------------------------------
				end # let local environment E2
				#--------------------------------------------------------------------
				# sqrtIter(1.0)
			end # let local environment E1
	#--------------------------------------------------------------------------------
	mySqrt2     = closureInE0                                # 2nd binding in E0
	#--------------------------------------------------------------------------------
	# mySqrt2(2)^2                                           # application in E0
end # let  global environment E0

# ╔═╡ 8e10c0ad-7347-45d7-9892-2f7a62800850
md"
---
##### end of ch. 3.2.4
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
# ╟─e0ca0383-37fd-4b3f-984e-939c6856a151
# ╠═ea207616-dba5-457e-a55b-80162996b1d9
# ╟─523391cc-e2f4-49a4-ba9d-5c205b3843be
# ╠═1b3f120f-c2aa-4d42-a7be-adab650428b5
# ╟─8e565a5a-8381-465a-b79f-a63f493b3570
# ╠═4c1fb8a7-752a-44f6-879d-c889198667d3
# ╟─3d56eebc-132c-4231-94f4-6cbd2fe51985
# ╠═96955c6d-20ac-46ac-a202-c564a85993d7
# ╟─8e10c0ad-7347-45d7-9892-2f7a62800850
# ╟─045fba1d-ec31-4716-b674-905cdb9dc7dd
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
