### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 59cb8400-ac7e-11ed-31d8-1f388a3668e0
md"
====================================================================================
#### SICP: [3.2.3 Frames as the Repository of Local State](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3)
##### file: PCM20230214\_SICP\_3.2.3\_FramesAsRepositoryOfLocalState.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/18 ***

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
###### $let$-simulated environment *E0* after *definition* of $makeWithDraw$

Result is a *binding* of variable name $makeWithDraw$ with a *closure* (= *higher-order* $\lambda$-function) in $let$-simulated *global* environment *E0* (cf. [Fig. 3.6, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):

"""

# ╔═╡ 83d587ed-981c-4dec-ba71-554b0addc97d
let                                               # global environment E0
	#----------------------------------------------------------------------
	closureInE0 =                                 # 1st binding
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-----------------------------------------------------------
	makeWithDraw = closureInE0                    # 2nd binding 
	#----------------------------------------------------------------------
	# w1 = makeWithDraw(100)                   1st test (should work here)
	# w1(50)   # ==> 50                        2nd test (should work here)
	#----------------------------------------------------------------------
end # let global environment E0

# ╔═╡ 136e5a22-6456-4b4a-ada0-bd17f9f6d980
md"""
---
###### $let$-simulated local environment *E1* after *application* $makeWithDraw(100)$  
Result is a second *closure* in $let$-simulated *local* environment *E1* with *nonlocal* variable $balance$ (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"""

# ╔═╡ bf55018b-7066-46e1-b81e-378684f5c34c
let                                               # global environment E0
	#----------------------------------------------------------------------
	closureInE0 =                                 # 1st binding in E0
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-----------------------------------------------------------
	makeWithDraw = closureInE0                    # 2nd binding in E0
	#----------------------------------------------------------------------
	let                                           # local environment E1
		#------------------------------------------------------------------
		balance = 100                             #  1st binding in E1
		#------------------------------------------------------------------
		closureInE1 =                             #  2nd binding in E1
			amount ->                             
				>=(balance, amount) ?   #  ...with free variable 'balance'
				balance -= amount :
				"insufficient funds"
		#------------------------------------------------------------------
	end # let local environment E1
	#----------------------------------------------------------------------
	# w1 = makeWithDraw(100)                   1st test (should work here)
	# w1(50)   # ==> 50                        2nd test (should work here)
	#----------------------------------------------------------------------
end # let global environment E0

# ╔═╡ 834e4e28-b884-4945-a687-74ba401b7168
md"
---
###### $let$-simulated environment *E0* after *assignment* $$w1 = makeWithDraw(100)$$
Result is a new binding for $w1$ in *E0*  (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"

# ╔═╡ 45793f66-8011-4b85-9c26-cb79cb953409
let                                               # global environment E0
	#----------------------------------------------------------------------
	closureInE0 =                                 # binding in E0
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-----------------------------------------------------------
	makeWithDraw = closureInE0                    # binding in E0
	#----------------------------------------------------------------------
	object =                                      # binding in E0
	#----------------------------------------------------------------------
		let                                       # local environment E1
			#--------------------------------------------------------------
			balance = 100                         #  1st binding in E1
			#--------------------------------------------------------------
			closureInE1 =                         #  2nd binding in E1
				amount ->                             
					>=(balance, amount) ?         #  ...free 'balance'
					balance -= amount :
					"insufficient funds"
			#--------------------------------------------------------------
		end # let local environment E1
	#----------------------------------------------------------------------
	w1 = object                                   # binding in E0
	# w1(40)   #==> 60                         1st test (should work here)
	#----------------------------------------------------------------------
	# w1 = makeWithDraw(100)                   1st test (should work here)
	# w1(50)   # ==> 50                        2nd test (should work here)
	#----------------------------------------------------------------------
end # let global environment E0

# ╔═╡ f0344e13-d13c-4d0e-96d3-1252b273fec5
md"
---
###### $let$-simulated environment *E0* after *assignment* $$w2 = makeWithDraw(60)$$
Result is a new binding for $w2$ in *E0*  (cf. [Fig. 3.7, 3.10, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996). In contrast to Fig. 3.10 in SICP the code of closure $closureInE1$ appears here in two different places. A compiler should detect that the *code* of $closureInE1$ is identical and optimize that. Only $balance$ in the surrounding environments *E11, E12* have different values $100$ and $60$:
" 

# ╔═╡ 5cc5772b-e1a3-4c78-b334-016bd9b4874e
let                                               # global environment E0
	#----------------------------------------------------------------------
	closureInE0 =                                 # binding in E0
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-----------------------------------------------------------
	makeWithDraw = closureInE0                    # binding in E0
	#----------------------------------------------------------------------
	object11 =                                    # binding in E0
	#----------------------------------------------------------------------
		let                                       # local environment E11
			#--------------------------------------------------------------
			balance = 100                         #  1st binding in E11
			#--------------------------------------------------------------
			closureInE1 =                         #  2nd binding in E11
				amount ->                             
					>=(balance, amount) ?         #  ...free 'balance'
					balance -= amount :
					"insufficient funds"
			#--------------------------------------------------------------
		end # let local environment E11
	#----------------------------------------------------------------------
	object12 =                                    # binding in E0
	#----------------------------------------------------------------------
		let                                       # local environment E12
			#--------------------------------------------------------------
			balance = 60                          #  1st binding in E12
			#--------------------------------------------------------------
			closureInE1 =                         #  2nd binding in E12
				amount ->                             
					>=(balance, amount) ?         #  ...free 'balance'
					balance -= amount :
					"insufficient funds"
			#--------------------------------------------------------------
		end # let local environment E12
	#----------------------------------------------------------------------
	w1 = object11                                   # binding in E0
	w2 = object12                                    # binding in E0
	# w1(40)   # ==> 60                            test (should work here)
	# w2(60)   # ==>  0                            test (should work here)
	# w1(10)   # ==> 50                            test (should work here)
	# w2(10)   # ==> "insufficient funds"          test (should work here)
	# w1(40), w2(60), w1(10), w2(10)  # ==>  (60, 0, 50, "insuff...")
	#----------------------------------------------------------------------
	# w1 = makeWithDraw(100)                   1st test (should work here)
	# w1(50)   # ==> 50                        2nd test (should work here)
	#----------------------------------------------------------------------
end # let global environment E0

# ╔═╡ 5ff13056-9e59-4dd5-875b-d104e3cd1fe7
md"
---
###### $let$-simulated environments after *application* $$w1(50)$$
(cf. Fig. 3.7-10, SICP, 1996). In contrast to SICP the accounts $w1, w2$ are initialized with different values $100, 60$. So the environment *E1* gets different identifiers *E11, E12*, too:
"

# ╔═╡ 6c926024-b1ca-4f48-abaf-58c83a70e8df
let                                               # global environment E0
	#----------------------------------------------------------------------
	closureInE0 =                                 # binding in E0
			balance -> 
				amount -> 
					>=(balance, amount) ?
						balance -= amount :
						"insufficient funds"
	#-----------------------------------------------------------
	makeWithDraw = closureInE0                    # binding in E0
	#----------------------------------------------------------------------
	object11 =                                    # binding in E0
	#----------------------------------------------------------------------
		let                                       # local environment E11
			#--------------------------------------------------------------
			balance = 100                         #  1st binding in E11
			#--------------------------------------------------------------
			closureInE1 =                         #  2nd binding in E11
				amount ->                             
					>=(balance, amount) ?         #  ...free 'balance'
					balance -= amount :
					"insufficient funds"
			#--------------------------------------------------------------
			let                                   #  local environment E2
				amount = 50                       # binding 'amount' in E2
				#----------------------------------------------------------
				>=(balance, amount) ?
					balance -= amount :
					"insufficient funds"
				#----------------------------------------------------------
			end  #  let local environment E2
			#--------------------------------------------------------------
		end # let local environment E11
	#----------------------------------------------------------------------
	object12 =                                    # binding in E0
	#----------------------------------------------------------------------
		let                                       # local environment E12
			#--------------------------------------------------------------
			balance = 60                          #  1st binding in E12
			#--------------------------------------------------------------
			closureInE1 =                         #  2nd binding in E12
				amount ->                             
					>=(balance, amount) ?         #  ...free 'balance'
					balance -= amount :
					"insufficient funds"
			#--------------------------------------------------------------
		end # let local environment E12
	#----------------------------------------------------------------------
	w1 = object11                                   # binding in E0
	w2 = object12                                    # binding in E0
	# w1       # ==> 50                            test (should work here)
	# w2(60)   # ==> 40                            test (should work here)
	# w1       # ==> 50                            test (should work here)
	# w2(10)   # ==> 30                            test (should work here)
	w1, w2(60), w1, w2(10) #  ==> (50, 0, 50, "insuff...")
	#----------------------------------------------------------------------
	# w1 = makeWithDraw(100)                   1st test (should work here)
	# w1(50)   # ==> 50                        2nd test (should work here)
	#----------------------------------------------------------------------
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
# ╠═83d587ed-981c-4dec-ba71-554b0addc97d
# ╟─136e5a22-6456-4b4a-ada0-bd17f9f6d980
# ╠═bf55018b-7066-46e1-b81e-378684f5c34c
# ╟─834e4e28-b884-4945-a687-74ba401b7168
# ╠═45793f66-8011-4b85-9c26-cb79cb953409
# ╟─f0344e13-d13c-4d0e-96d3-1252b273fec5
# ╠═5cc5772b-e1a3-4c78-b334-016bd9b4874e
# ╟─5ff13056-9e59-4dd5-875b-d104e3cd1fe7
# ╠═6c926024-b1ca-4f48-abaf-58c83a70e8df
# ╟─f79a2b5d-6a88-4579-8345-a083b0ddfed6
# ╟─885934c6-b121-437d-89ea-0ec2b739830b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
