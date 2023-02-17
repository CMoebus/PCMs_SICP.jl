### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 59cb8400-ac7e-11ed-31d8-1f388a3668e0
md"
====================================================================================
#### SICP: [3.2.3 Frames as the Repository of Local State](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3)
##### file: PCM20230214\_SICP\_3.2.3\_FramesAsRepositoryOfLocalState.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/17 ***

====================================================================================
"

# ╔═╡ 13d3d9bf-0607-42f2-8cd7-071efe62da0f
md"
##### 3.2.3.1 Scheme-like Julia
"

# ╔═╡ 5c807704-367f-456f-a662-435764006cd2
# definition with 'function'
function makeWithDraw1(balance) 
	amount -> 
		>=(balance, amount) ?
		balance -= amount :
		"insufficient funds"
end # function makeWithdraw

# ╔═╡ 205a9dfe-38a8-4caa-be1a-79ca27a9d340
w1 = makeWithDraw1(100)

# ╔═╡ df53aaeb-817a-47e0-bec8-9a3be1fd201a
w1(50)

# ╔═╡ 61b42dc2-18dd-44fa-919e-803852d68427
md"
###### $makeWithDraw1$ (above) and $makeWithDraw2$ (below) are equivalent definitions
"

# ╔═╡ e0a55fd8-e887-47f0-9519-57aa83a8e241
# definition with assignment of lambda-expression 'balance -> ...'
makeWithDraw2 =
	balance -> 
		amount -> 
			>=(balance, amount) ?
			balance -= amount :
			"insufficient funds"

# ╔═╡ 6ca2031d-f7ef-4303-9c20-bbf25dde37a4
w2 = makeWithDraw2(200)

# ╔═╡ fbb40881-d204-40bf-a827-f86d00b05635
w2(50)

# ╔═╡ 4ef4f6df-f568-41c5-ad04-16525752a520
md"""
---
###### Simulated global environment *E0* after *definition* of $makeWithDraw$

Result is a *binding* of variable name $makeWithDraw$ with the *higher-order* $\lambda$-function (cf. [Fig. 3.6, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):

$balance \rightarrow ....''insufficient funds''$
"""

# ╔═╡ c3f6d564-b16e-47e9-b2d0-88d8f1bb1ef1
let                                               # global environment E0
	#---------------------------------------------------------------------
	makeWithDraw =                                # binding 'makeWitDraw'             
		closureInE0 =                             # ...with 'closureInE0'
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#---------------------------------------------------------------------
	w1 = makeWithDraw(100)
	w1(50)
end # let global environment E0

# ╔═╡ 136e5a22-6456-4b4a-ada0-bd17f9f6d980
md"""
---
###### Simulated local environment *E1* after *application* $makeWithDraw(100)$  
Result is a *closure* with *nonlocal* variable $balance$ (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"""

# ╔═╡ f7cdad03-20ac-4f1c-9fd7-043e8b65eeb8
let                                               # global environment E0
	#---------------------------------------------------------------------
	makeWithDraw =                                # binding 'makeWitDraw'             
		closureInE0 =                             # ...with 'closureInE0'
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#---------------------------------------------------------------------
	let                                           #  local environment E1
		#-----------------------------------------------------------------
		balance = 100                             #  binding 'balance'
		#-----------------------------------------------------------------
		closureInE1 =                             # closure in E1 ...
			amount ->                             
				>=(balance, amount) ?   #  ...with free variable 'balance'
				balance -= amount :
				"insufficient funds"
		#-----------------------------------------------------------------
	end # let local environment E1
	#---------------------------------------------------------------------
	# w1 = makeWithDraw(100)
	# w1(50)
end # let global environment E0

# ╔═╡ 834e4e28-b884-4945-a687-74ba401b7168
md"
---
###### Simulated global environment *E0* after *assignment* $$w1 = makeWithDraw(100)$$
Result is a new binding for $w1$ in *E0*  (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"

# ╔═╡ d7076991-5dd5-42e0-b849-7f658fb43762
let                                               # global environment E0
	#-------------------------------------------------------------------------
	makeWithDraw =                          # binding 'makeWitDraw' in E0             
		closureInE0 =                       # ...with 'closureInE0'
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-------------------------------------------------------------------------
	w1 =                                          # binding 'w1' in E0 
	#-------------------------------------------------------------------------
		let                                           #  local environment E1
			#-----------------------------------------------------------------
			balance = 100                             #  binding 'balance'
			#-----------------------------------------------------------------
			closureInE1 =                             # closure in E1 ...
				amount ->                             
					>=(balance, amount) ?   #  ...with free variable 'balance'
					balance -= amount :
					"insufficient funds"
		#---------------------------------------------------------------------
	end # let local environment E1
	#-------------------------------------------------------------------------
	# w1 = makeWithDraw(100)
	# w1(50)
end # let global environment E0

# ╔═╡ 5ff13056-9e59-4dd5-875b-d104e3cd1fe7
md"
---
###### Simulated local environment *E2* after *application* $$w1(50)$$
Result is the reduced $balance=100-50\Rightarrow 50$ (cf. Fig. 3.8-9, SICP, 1996):
"

# ╔═╡ 40f34058-0978-4203-be35-23c97c7a335d
let                                                   # global environment E0
	#-------------------------------------------------------------------------
	makeWithDraw =                              # binding 'makeWitDraw' in E0 
	#-------------------------------------------------------------------------
		closureInE0 =                                 # ...with 'closureInE0'
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-------------------------------------------------------------------------
	w1 =                                            #      binding 'w1' in E0 
	#-------------------------------------------------------------------------
		let                                         #    local environment E1
			#-----------------------------------------------------------------
			balance = 100                           # binding 'balance' in E1
			#-----------------------------------------------------------------
			closureInE1 =                           #           closure in E1
				amount ->                             
					>=(balance, amount) ?           # free variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-----------------------------------------------------------------
			let                                     #    local environment E2
				amount = 50                         #  binding 'amount' in E2
				#-------------------------------------------------------------
				>=(balance, amount) ?
					balance -= amount :
					"insufficient funds"
				#-------------------------------------------------------------
			end  #  let local environment E2
			#-----------------------------------------------------------------
		end # let local environment E1
	#-------------------------------------------------------------------------
	# w1 = makeWithDraw(100)
	# w1(50)
end # let global environment E0

# ╔═╡ 53e00671-e18d-468e-922d-83728af1a00a
md"
---
###### Simulated global environment *E0* after *application* $w1(50)$ and after *assignment* $$w2 = makeWithDraw(100)$$
Result is a new binding for $w2$ in *E0* and a new value of $balance = 100-10\Rightarrow90$ in object $w2$ and *2nd* environment *E1*. There is a slight deviation in correspondance between our code and [Fig. 3.10, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996). The closure $closureInE1$ appears two-times in the code. Maybe a compiler is able to avoid code duplications:
"

# ╔═╡ 7b990a9c-7966-4773-ab8b-418514703fd5
let                                                   # global environment E0
	#-------------------------------------------------------------------------
	makeWithDraw =                              # binding 'makeWitDraw' in E0 
	#-------------------------------------------------------------------------
		closureInE0 =                                 # ...with 'closureInE0'
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-------------------------------------------------------------------------
	w1 =                                            #      binding 'w1' in E0 
	#-------------------------------------------------------------------------
		let                                         #    local environment E1
			#-----------------------------------------------------------------
			balance = 100                           # binding 'balance' in E1
			#-----------------------------------------------------------------
			closureInE1 =                           #           closure in E1
				amount ->                             
					>=(balance, amount) ?           # free variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-----------------------------------------------------------------
			let                                     #    local environment E2
				amount = 50                         #  binding 'amount' in E2
				#-------------------------------------------------------------
				>=(balance, amount) ?
					balance -= amount :
					"insufficient funds"
				#-------------------------------------------------------------
			end  #  let local environment E2
			#-----------------------------------------------------------------
		end # let local environment E1
	#-------------------------------------------------------------------------
	w2 =                                            #      binding 'w2' in E0 
	#-------------------------------------------------------------------------
		let                                         #    local environment E1
			#-----------------------------------------------------------------
			balance = 100                           # binding 'balance' in E1
			#-----------------------------------------------------------------
			closureInE1 =                           #           closure in E1
				amount ->                             
					>=(balance, amount) ?           # free variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-----------------------------------------------------------------
		end # let local environment E1
	#-------------------------------------------------------------------------
	# w1 = makeWithDraw(100)
	# w1(50) ==> 50
	# w2 = makeWithDraw(100)
	w2(10)  # ==> 90
end # let global environment E0

# ╔═╡ f79a2b5d-6a88-4579-8345-a083b0ddfed6
md"
---
##### end of ch. 3.2.3
"

# ╔═╡ 885934c6-b121-437d-89ea-0ec2b739830b
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
# ╟─59cb8400-ac7e-11ed-31d8-1f388a3668e0
# ╟─13d3d9bf-0607-42f2-8cd7-071efe62da0f
# ╠═5c807704-367f-456f-a662-435764006cd2
# ╠═205a9dfe-38a8-4caa-be1a-79ca27a9d340
# ╠═df53aaeb-817a-47e0-bec8-9a3be1fd201a
# ╟─61b42dc2-18dd-44fa-919e-803852d68427
# ╠═e0a55fd8-e887-47f0-9519-57aa83a8e241
# ╠═6ca2031d-f7ef-4303-9c20-bbf25dde37a4
# ╠═fbb40881-d204-40bf-a827-f86d00b05635
# ╟─4ef4f6df-f568-41c5-ad04-16525752a520
# ╠═c3f6d564-b16e-47e9-b2d0-88d8f1bb1ef1
# ╟─136e5a22-6456-4b4a-ada0-bd17f9f6d980
# ╠═f7cdad03-20ac-4f1c-9fd7-043e8b65eeb8
# ╟─834e4e28-b884-4945-a687-74ba401b7168
# ╠═d7076991-5dd5-42e0-b849-7f658fb43762
# ╟─5ff13056-9e59-4dd5-875b-d104e3cd1fe7
# ╠═40f34058-0978-4203-be35-23c97c7a335d
# ╟─53e00671-e18d-468e-922d-83728af1a00a
# ╠═7b990a9c-7966-4773-ab8b-418514703fd5
# ╟─f79a2b5d-6a88-4579-8345-a083b0ddfed6
# ╟─885934c6-b121-437d-89ea-0ec2b739830b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
