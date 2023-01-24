### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 70a6b632-9b31-11ed-0879-69b1c734fd11
md"
====================================================================================
#### SICP: 3.1.3 The Costs of Introducing Assignment
##### file: PCM20230123\_SICP\_3.1.3\_TheCostsOfIntroducingAssignment.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/24 ***

====================================================================================
"

# ╔═╡ 45966a49-22d1-40ac-9d60-c1e353ce5bf5
function makeSimplifiedWithdraw(balance)
	amount -> balance = -(balance, amount)
end # function makeSimplifiedWithdraw

# ╔═╡ 0714ea2a-1e77-46c3-a369-8c5d8c79cd9f
w =  makeSimplifiedWithdraw(25)

# ╔═╡ f76f976e-37da-4ba7-9fd0-cb64f06bcacb
w(20)

# ╔═╡ 9029b2c7-4fe1-4ce5-bc65-687c2e97d87d
w(10)

# ╔═╡ 0665cf7a-f200-4227-b45b-4c798cd9abd4
function makeDecrementer(balance)
	amount -> -(balance, amount)
end # function makeDecrementer

# ╔═╡ 9a854270-1c76-4095-882c-5d7c83710898
d = makeDecrementer(25)

# ╔═╡ eb4c3ce9-3bf1-4e40-a440-ba30d4cbe540
d(20)

# ╔═╡ 9895b394-9929-47de-8069-7e6ab3e804c3
d(10)

# ╔═╡ 426ee0b8-c314-49f8-b788-67158eb71896
md"
---
###### Evaluation of $$makeDecrementer(25)(20)$$ according to *substitution* model
"

# ╔═╡ 5ee541b7-8920-424a-b113-1f151c70f8f2
makeDecrementer(25)(20)

# ╔═╡ eaaf14bb-aaa9-411b-bde0-15ae0afbd899
md"
###### 1st reduction step: $$balance/25$$ (= $$balance$$ is substituted by $$25$$)
"

# ╔═╡ 57c4037f-4efe-40cf-a4a6-c77c6b1316c0
let balance = 25
	(amount -> -(balance, amount))(20)
end # let

# ╔═╡ 9799a112-3297-440e-b5a3-5281da23be4a
(amount -> -(25, amount))(20)   # lambda expression has to be put into parentheses

# ╔═╡ bc5350ab-7d0f-4ecd-a718-03faa25562bb
md"
###### 2nd reduction step: $$amount/20$$ (= $$amount$$ is substituted by $$20$$)
"

# ╔═╡ ec731ee3-b4c8-4e21-9f3e-84bb7c959b94
let amount = 20
	-(25, 20)
end # let

# ╔═╡ 8ea8f8c9-15ed-417d-89b3-0ec13efe2e37
-(25, 20)

# ╔═╡ 87c4b236-96e2-4984-9df8-2152ee03781b
-(25, 20) == 25 - 20

# ╔═╡ 9f0d8a17-fb63-45f6-852a-c1e6d910733d
md"
---
###### Evaluation of $$makeSimplifiedWithdraw(25)(20)$$ according to *substitution* model
The evaluation of the expression $$makeSimplifiedWithdraw(25)(20)$$ ends in the nonlogical expression $$(20 \rightarrow 25 = -(25, 20))$$.
"

# ╔═╡ c1bd35d5-85a6-4431-8775-9af70b58f090
let 
	makeSimplifiedWithdraw(25)(20)       # expression is isolated in a let...end block
end # let

# ╔═╡ 640dcb16-9e26-4833-9af9-e7c66e2b0f6c
md"
###### 1st reduction step: $$balance/25$$ (= $$balance$$ is substituted by $$25$$)
"

# ╔═╡ 0b1a88aa-5870-4e00-b412-1cd0c931f58a
let balance = 25                         # expression is isolated in a let...end block
	(amount -> balance = -(balance, amount))(20) 
end # let

# ╔═╡ 43a31914-c787-44bf-a714-5f706a58c991
let                                      # expression is isolated in a let...end block
	(amount -> 25 = -(25, amount))(20) 
end # let

# ╔═╡ 79dfe1ff-1e1f-4f99-9b91-71350c56413a
md"
###### 2nd reduction step: $$amount/20$$ (= $$amount$$ is substituted by $$20$$)
"

# ╔═╡ 45617514-c836-4858-a6c2-4a64f3ff2127
let amount = 20                          # expression is isolated in a let...end block
	(amount -> 25 = -(25, amount)) 
end # let

# ╔═╡ 27337454-608b-48f5-8894-8ade6549fedd
let                                      # expression is isolated in a let...end block
	(20 -> 25 = -(25, 20)) 
end # let

# ╔═╡ 121bb043-3cb6-4bc3-acfb-dbc3ac874648
md"
---
##### Sameness and Change
"

# ╔═╡ f3f658c7-0150-4ae4-8718-1382b38a4b91
d1 = makeDecrementer(25)

# ╔═╡ ebbea5d1-09d1-4589-bd12-b955d7312ac9
d2 = makeDecrementer(25)

# ╔═╡ e07bfb37-8e1b-45b5-9de3-824a4a7195b2
d1 == d2

# ╔═╡ 7e8f4c33-76c1-4bac-a029-e7b6aed5e25e
d1 === d2

# ╔═╡ c0780f37-026c-4fb8-b62f-f86b7fdf50be
w1 = makeSimplifiedWithdraw(25)

# ╔═╡ 05a2ca23-1a16-49fd-bf17-7091e505bdb8
w2 = makeSimplifiedWithdraw(25)

# ╔═╡ 660b01b2-7586-42f5-8f95-65770a251d0d
w1 == w2

# ╔═╡ ecd5d9b4-8d3d-417b-9eee-1d0c128b3c64
w1 === w2

# ╔═╡ 7ce076eb-645d-4f9b-ae7d-770d97b53ec8
w1(20)

# ╔═╡ 4f808c7b-3f19-4ff2-b930-ca7712129ad9
w1(20)

# ╔═╡ 064be84e-5caf-44fc-9a05-5af70e9c3802
w2(20)

# ╔═╡ baedcc8c-a49f-4ebb-b18f-e5335ef13969
md"
---
"

# ╔═╡ 4d8b0d74-36bc-49a3-89db-30ee2d3ef50c
function makeAccount(balance)
	#-------------------------------------------------
	function withdraw(amount)
		if balance >= amount  
			balance = balance - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#-------------------------------------------------
	function deposit(amount)
		balance = balance + amount 
	end # function deposit
	#-------------------------------------------------
	function getBalance()
		balance
	end # function getBalance
	#-------------------------------------------------
	function dispatch(message)
		#--------------------------------------------
		message == :withdraw ? withdraw :
		#--------------------------------------------
		message == :deposit ? deposit :
		#--------------------------------------------
		message == :getBalance ? getBalance() :
			"Unknown request -- makeAccount $message"
		#--------------------------------------------
	end # function dispatch
	#-------------------------------------------------
end # function makeAccount

# ╔═╡ bbee1526-fc3e-4fdb-a3b0-3736ce4da802
petersAccount = makeAccount(100)

# ╔═╡ 836c3b4c-d13c-4f09-ae39-66a450ede494
petersAccount(:withdraw)(40)

# ╔═╡ 7002f6c9-1140-41a5-a8f4-ddc25d0dec74
paulsAccount = makeAccount(100)

# ╔═╡ 011d1447-a16b-47bb-8788-a41797d89077
paulsAccount(:getBalance)                # *not* affect from the above witdraw !

# ╔═╡ cbfc50c0-d7ba-4c0f-8b18-d875fba6d841
petersAccount2 = makeAccount(100)

# ╔═╡ d063c3d0-3f74-4288-945c-0fc579e8d36e
paulsAccount2 = petersAccount2 

# ╔═╡ 5a2dabb2-d6f9-4d14-9f74-7c64355d5717
petersAccount2(:withdraw)(40)

# ╔═╡ faffd59a-9b88-41b4-9fbb-30c5e73dc8ee
paulsAccount2(:getBalance)              # affect from the above witdraw !

# ╔═╡ 04ede3bd-9c35-4b36-9cfc-e320a159803b
md"
---
##### Pitfalls of imperative programming
"

# ╔═╡ 187afbf4-ca6b-40e9-9b1a-4efe4ec5755d
function factorial1(n)
	let product = 1
		counter = 1
		function iter()
			if >(counter, n)
				product
			else
				begin
					product = *(counter, product)  # correct order
					counter = +(counter, 1)
				end # begin
				iter()
			end # if
		end # function iter
		iter()
	end # let
end # function factorial1

# ╔═╡ a45f606a-b523-401c-a0c0-c1bf378ad4a1
factorial1(4)

# ╔═╡ 63b0ae81-f585-408c-a8a7-a5a445d1cf3f
factorial1(6)

# ╔═╡ 8c1eeca0-eeaa-4a77-83a8-531971b1fa3a
function factorial2(n)
	let product = 1
		counter = 1
		function iter()
			if >(counter, n)
				product
			else
				begin
					counter = +(counter, 1)        # reversed, wrong order
					product = *(counter, product)
				end # begin
				iter()
			end # if
		end # function iter
		iter()
	end # let
end # function factorial2

# ╔═╡ 0f94a374-aaff-4240-a863-8041e83cc89e
factorial2(4)

# ╔═╡ 6a92d87d-8ba2-4896-99b8-f82485042eb2
factorial2(6)

# ╔═╡ 925f75c8-b027-410b-b4d9-31c8795ee525
md"
---
##### end of ch. 3.1.3
"

# ╔═╡ 82e9aca5-9b5e-4545-af8f-4e126a04f6c1
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

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─70a6b632-9b31-11ed-0879-69b1c734fd11
# ╠═45966a49-22d1-40ac-9d60-c1e353ce5bf5
# ╠═0714ea2a-1e77-46c3-a369-8c5d8c79cd9f
# ╠═f76f976e-37da-4ba7-9fd0-cb64f06bcacb
# ╠═9029b2c7-4fe1-4ce5-bc65-687c2e97d87d
# ╠═0665cf7a-f200-4227-b45b-4c798cd9abd4
# ╠═9a854270-1c76-4095-882c-5d7c83710898
# ╠═eb4c3ce9-3bf1-4e40-a440-ba30d4cbe540
# ╠═9895b394-9929-47de-8069-7e6ab3e804c3
# ╟─426ee0b8-c314-49f8-b788-67158eb71896
# ╠═5ee541b7-8920-424a-b113-1f151c70f8f2
# ╟─eaaf14bb-aaa9-411b-bde0-15ae0afbd899
# ╠═57c4037f-4efe-40cf-a4a6-c77c6b1316c0
# ╠═9799a112-3297-440e-b5a3-5281da23be4a
# ╟─bc5350ab-7d0f-4ecd-a718-03faa25562bb
# ╠═ec731ee3-b4c8-4e21-9f3e-84bb7c959b94
# ╠═8ea8f8c9-15ed-417d-89b3-0ec13efe2e37
# ╠═87c4b236-96e2-4984-9df8-2152ee03781b
# ╟─9f0d8a17-fb63-45f6-852a-c1e6d910733d
# ╠═c1bd35d5-85a6-4431-8775-9af70b58f090
# ╟─640dcb16-9e26-4833-9af9-e7c66e2b0f6c
# ╠═0b1a88aa-5870-4e00-b412-1cd0c931f58a
# ╠═43a31914-c787-44bf-a714-5f706a58c991
# ╟─79dfe1ff-1e1f-4f99-9b91-71350c56413a
# ╠═45617514-c836-4858-a6c2-4a64f3ff2127
# ╠═27337454-608b-48f5-8894-8ade6549fedd
# ╟─121bb043-3cb6-4bc3-acfb-dbc3ac874648
# ╠═f3f658c7-0150-4ae4-8718-1382b38a4b91
# ╠═ebbea5d1-09d1-4589-bd12-b955d7312ac9
# ╠═e07bfb37-8e1b-45b5-9de3-824a4a7195b2
# ╠═7e8f4c33-76c1-4bac-a029-e7b6aed5e25e
# ╠═c0780f37-026c-4fb8-b62f-f86b7fdf50be
# ╠═05a2ca23-1a16-49fd-bf17-7091e505bdb8
# ╠═660b01b2-7586-42f5-8f95-65770a251d0d
# ╠═ecd5d9b4-8d3d-417b-9eee-1d0c128b3c64
# ╠═7ce076eb-645d-4f9b-ae7d-770d97b53ec8
# ╠═4f808c7b-3f19-4ff2-b930-ca7712129ad9
# ╠═064be84e-5caf-44fc-9a05-5af70e9c3802
# ╟─baedcc8c-a49f-4ebb-b18f-e5335ef13969
# ╠═4d8b0d74-36bc-49a3-89db-30ee2d3ef50c
# ╠═bbee1526-fc3e-4fdb-a3b0-3736ce4da802
# ╠═836c3b4c-d13c-4f09-ae39-66a450ede494
# ╠═7002f6c9-1140-41a5-a8f4-ddc25d0dec74
# ╠═011d1447-a16b-47bb-8788-a41797d89077
# ╠═cbfc50c0-d7ba-4c0f-8b18-d875fba6d841
# ╠═d063c3d0-3f74-4288-945c-0fc579e8d36e
# ╠═5a2dabb2-d6f9-4d14-9f74-7c64355d5717
# ╠═faffd59a-9b88-41b4-9fbb-30c5e73dc8ee
# ╟─04ede3bd-9c35-4b36-9cfc-e320a159803b
# ╠═187afbf4-ca6b-40e9-9b1a-4efe4ec5755d
# ╠═a45f606a-b523-401c-a0c0-c1bf378ad4a1
# ╠═63b0ae81-f585-408c-a8a7-a5a445d1cf3f
# ╠═8c1eeca0-eeaa-4a77-83a8-531971b1fa3a
# ╠═0f94a374-aaff-4240-a863-8041e83cc89e
# ╠═6a92d87d-8ba2-4896-99b8-f82485042eb2
# ╟─925f75c8-b027-410b-b4d9-31c8795ee525
# ╟─82e9aca5-9b5e-4545-af8f-4e126a04f6c1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
