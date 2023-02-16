### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 59cb8400-ac7e-11ed-31d8-1f388a3668e0
md"
====================================================================================
#### SICP: [3.2.3 Frames as the Repository of Local State](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3)
##### file: PCM20230214\_SICP\_3.2.3\_FramesAsRepositoryOfLocalState.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/16 ***

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
let makeWithDraw =                                # global environment E0
	#---------------------------------------------------------------------
		balance -> 
			amount -> 
				>=(balance, amount) ?
					balance -= amount :
					"insufficient funds"
	#---------------------------------------------------------------------
	# ==> balance -> amount -> >=(...) ? ... : "insufficient funds"
	makeWithDraw                                  # global environment E0
end # let E0

# ╔═╡ 136e5a22-6456-4b4a-ada0-bd17f9f6d980
md"""
---
###### Simulated local environment *E1* after *application* $makeWithDraw(100)$  
Result is a *closure* with *nonlocal* variable $balance$ (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"""

# ╔═╡ 34a98d2a-f1d2-4fb4-9a40-17c0d423140c
let makeWithDraw =                                # global environment E0
	#---------------------------------------------------------------------
	let balance = 100                             #  local environment E1
		#-----------------------------------------------------------------
		amount ->                                 # closure with nonlocal
			>=(balance, amount) ?                 #    variable 'balance'
				balance -= amount :
				"insufficient funds"
		#-----------------------------------------------------------------
    end                                           #  local environment E1  
	#---------------------------------------------------------------------
end # let E0

# ╔═╡ 834e4e28-b884-4945-a687-74ba401b7168
md"
---
###### Simulated global environment *E0* after *assignment* $$w1 = makeWithDraw(100)$$
Result is a new binding for $w1$ in *E0*  (cf. [Fig. 3.7, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"

# ╔═╡ 4e67db1b-a0d1-45a9-9bd8-4f0046eb8bef
let makeWithDraw =                                # global environment E0
	w1 =                                          # new binding of 'w1'
		#-----------------------------------------------------------------
		let balance = 100                         #  local environment E1			
			#-------------------------------------------------------------
			amount ->                             # closure with nonlocal
				>=(balance, amount) ?             #    variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-------------------------------------------------------------
		end                                       #  local environment E1	
	#--------------------------------------------------------------------- 
end # let E0

# ╔═╡ 5ff13056-9e59-4dd5-875b-d104e3cd1fe7
md"
---
###### Simulated local environment *E2* after *application* $$w1(50)$$
Result is the reduced $balance=100-50\Rightarrow 50$ (cf. Fig. 3.8-9, SICP, 1996):
"

# ╔═╡ f5fea325-99f6-41dc-b893-35923ea8dc3d
let makeWithDraw =                                # global environment E0
	w1 =
		#-----------------------------------------------------------------
		let balance = 100                         #  local environment E1			
			#-------------------------------------------------------------
			let amount = 50                       #  local environment E2
				#---------------------------------------------------------
				>=(balance, amount) ?
					balance -= amount :
					"insufficient funds"
			end                                   #  local environment E2
			#-------------------------------------------------------------
		end                                       #  local environment E1	
	#--------------------------------------------------------------------- 
    w1 # ==> 50
end # let E0

# ╔═╡ 53e00671-e18d-468e-922d-83728af1a00a
md"
---
###### Simulated global environment *E0* after *application* $w1(50)$ and *assignment* $$w2 = makeWithDraw(100)$$
Result is a new binding for $w2$ in *E0* and a new value of $balance = 100-0\Rightarrow100$ in object $w2$ (cf. [Fig. 3.10, SICP](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e3), 1996):
"

# ╔═╡ eab8b2f0-dee3-4c23-a363-b4f100ac25e7
let makeWithDraw =                                # global environment E0
	w1 =
		#-----------------------------------------------------------------
		let balance = 50                          #  local environment E1		
			#-------------------------------------------------------------
			amount ->                             # closure with nonlocal
				>=(balance, amount) ?             #    variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-------------------------------------------------------------
			end                                   #  local environment E1
		#----------------------------------------------------------------
	w2 =                                          # new binding of 'w1'
		#-----------------------------------------------------------------
		let balance = 100                         #  local environment E1			
			#-------------------------------------------------------------
			amount ->                             # closure with nonlocal
				>=(balance, amount) ?             #    variable 'balance'
					balance -= amount :
					"insufficient funds"
			#-------------------------------------------------------------
		end                                       #  local environment E1	
	#--------------------------------------------------------------------- 
    w1     # ==> closure 'amount -> ... "insufficient funds"
	w2     # ==> closure 'amount -> ... "insufficient funds" 
    w2(10) # ==> 100
end # let E0

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
# ╠═e0a55fd8-e887-47f0-9519-57aa83a8e241
# ╠═6ca2031d-f7ef-4303-9c20-bbf25dde37a4
# ╠═fbb40881-d204-40bf-a827-f86d00b05635
# ╟─4ef4f6df-f568-41c5-ad04-16525752a520
# ╠═c3f6d564-b16e-47e9-b2d0-88d8f1bb1ef1
# ╟─136e5a22-6456-4b4a-ada0-bd17f9f6d980
# ╠═34a98d2a-f1d2-4fb4-9a40-17c0d423140c
# ╟─834e4e28-b884-4945-a687-74ba401b7168
# ╠═4e67db1b-a0d1-45a9-9bd8-4f0046eb8bef
# ╟─5ff13056-9e59-4dd5-875b-d104e3cd1fe7
# ╠═f5fea325-99f6-41dc-b893-35923ea8dc3d
# ╟─53e00671-e18d-468e-922d-83728af1a00a
# ╠═eab8b2f0-dee3-4c23-a363-b4f100ac25e7
# ╟─f79a2b5d-6a88-4579-8345-a083b0ddfed6
# ╟─885934c6-b121-437d-89ea-0ec2b739830b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
