### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 3be3adc0-9296-11ed-1f41-6b27f36152dc
md"
====================================================================================
#### SICP: [3.1.1\_Local\_State\_Variables](https://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e1)
##### file: PCM20230112\_SICP:\_3.1.1\_LocalStateVariables.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/15 ***

====================================================================================

"

# ╔═╡ f071e2c8-736e-4c26-bd6e-b318ca05843a
md"
##### 3.1.1.1 SICP-Scheme-like Julia
"

# ╔═╡ c763cc9d-6a22-443b-b4d2-7d1c233384c7
md"
###### Accessing global variables with $$global$$
"

# ╔═╡ 9e764fca-5582-4698-b42b-78937ca7c9f3
md"
Pluto enforces the combination of the two definitions (*variable* $$balance$$ and the *function* $$withdraw$$) into one $$begin...end$$ block.
"

# ╔═╡ 8daa94e6-a26f-4997-9114-c71e3f4a8b1b
begin
	balance = 100
	function withdraw(amount)#
		global balance
		if balance >= amount 
			begin balance = balance - amount 
				balance
			end # begin
		else
			"Insufficient Funds"
		end # if
	end # function amount
end # begin

# ╔═╡ 6c72ecc9-0f66-428e-8063-924125e23bc0
withdraw(25)

# ╔═╡ 721753d9-33ad-47a1-a422-d272624bf71e
withdraw(25)

# ╔═╡ 07667dbd-8c42-4c21-a8a4-d6761df2e1f3
withdraw(60)

# ╔═╡ a6f371d6-45f5-4f1f-979d-e08562f47279
withdraw(15)

# ╔═╡ 32397461-d435-40bb-809d-061402514161
md"
---
###### Local environment with $$let$$
"

# ╔═╡ 356d0d27-4fc6-4fc7-84bd-8f6050e399c3
newWithdraw =
	let balance = 100
		(amount,) -> 
			if balance >= amount 
				begin balance = balance - amount 
					balance
				end # begin
			else
				"Insufficient Funds"
			end # if
	end # let

# ╔═╡ 7d2a146b-b41a-46db-ab34-66d12434ba42
newWithdraw(25)

# ╔═╡ 767ff460-2a2b-4a6b-b244-25bbff57944b
newWithdraw(25)

# ╔═╡ 09c6cb23-32c7-4d9e-bb88-a75b7e9a14ee
newWithdraw(60)

# ╔═╡ c76c6f21-2db9-4cc5-be4f-1de2fa903284
newWithdraw(15)

# ╔═╡ 790fb3fa-aa5c-47f0-9e99-3bf127062bb2
md"
---
###### Creating withdrawal processors
"

# ╔═╡ b126c44a-6a0a-480d-a283-a4ccb0ee9d03
function makeWithdraw(balance)
	(amount,) ->
		if balance >= amount 
			begin balance = balance - amount 
				balance
			end # begin
		else
			"Insufficient Funds"
		end # if
end # function makeWithdraw

# ╔═╡ b23008c0-cfcf-4ba6-bb37-6b4f7b04133d
md"
###### Creating objects
"

# ╔═╡ e983ccde-b2d3-42c9-9b6f-5a0531bdf54c
w1 = makeWithdraw(100)

# ╔═╡ aae79cf7-dc9a-40b0-a19c-c76effdcbc20
w2 = makeWithdraw(100)

# ╔═╡ ce3e98af-fbfe-4676-b4b6-254d84f877a3
w1(50)

# ╔═╡ 5ba004b0-ce75-40ea-980c-de5a6eae6b91
w2(70)

# ╔═╡ 6ad1d45f-9a5c-4cb7-9633-f28f2ff4357f
w2(40)

# ╔═╡ 02890cd7-7b34-4596-92f8-dd22e0f67642
w1(40)

# ╔═╡ 072eb694-9cca-463d-9cbe-bdc06fd33d70
md"
---
###### Creating bank account objects
"

# ╔═╡ 5869257d-dcd5-4cf9-a029-52afe752fb65
function makeAccount(balance)
	#-------------------------------------------------
	function withdraw(amount)
		if balance >= amount 
			begin 
				balance = balance - amount 
				balance
			end # begin
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#-------------------------------------------------
	function deposit(amount)
		begin 
			balance = balance + amount 
			balance
		end # begin
	end # function deposit
	#-------------------------------------------------
	function dispatch(message)
		message == :withdraw ? 
			withdraw :
		message == :deposit ?
			deposit :
			"Unknown request -- makeAccount $message"
	end # function dispatch
	#-------------------------------------------------
end # function makeAccount

# ╔═╡ de816416-9b07-4176-9d5b-338bae10bc0d
acc = makeAccount(100)

# ╔═╡ ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
acc(:withdraw)(50)

# ╔═╡ 9b3f7b70-d151-4d81-b026-1e5d0cbe3110
acc(:withdraw)(60)

# ╔═╡ 5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
acc(:deposit)(40)

# ╔═╡ 74731df8-fdb6-4bbc-a384-081117c2e9b6
acc(:withdraw)(60)

# ╔═╡ b2d1a37d-d5c7-4233-9346-e2c5da7e204d
md"
---
##### 3.1.1.2 Idiomatic Julia with $$mutable$$ $$struct$$, *inner* constructor $$new$$ and *multiple dispatch*
"

# ╔═╡ 1044aa81-2c86-453a-bdf6-6e473033e9ce
mutable struct Account
	balance::Float64
	# 1st explicit (but redundant) inner constructor to bind local var 'balance'
	Account(balance) =   
		balance >= 0.0 ? 
		new(balance) : 
		"negative initial balance not allowed" 
	# 2nd inner constructor to bind local var 'balance' to default value '0.0'
	Account() = new(0.0) 
end # struct

# ╔═╡ 4412266e-5cfd-43f3-bc40-dcb444dc984b
function withdraw2(object, amount)
	let balance = object.balance
		if balance >= amount 
			begin 
				balance = balance - amount 
				object.balance = balance
			end # begin
		else
			"Insufficient Funds"
		end # if
	end # let
end # function withdraw2

# ╔═╡ f55e1b4d-84da-4491-bc92-fa31f25b026f
function deposit2(object, amount)
	let balance = object.balance
		begin 
			balance = balance + amount 
			object.balance = balance
		end # begin
	end # let
end # function deposit2

# ╔═╡ 620fd9d3-6370-47ba-91d3-75610182a5dd
acc01 = Account(100)

# ╔═╡ 40e63b6d-96de-45de-8ce0-8f10b3b8e3f2
acc01.balance

# ╔═╡ 3e1d3c9e-6cae-41d2-bace-c750bb3aecd1
Account(-100)

# ╔═╡ 22611c1d-eb41-40f2-b439-fecb4d2612c4
acc02 = Account(-100 + 100)

# ╔═╡ fcd59a2c-a930-4bf2-8f3f-6815efe9f776
acc02.balance

# ╔═╡ 3a1e7bc9-5164-41ed-8f79-86cbc7f45cac
withdraw2(acc01, 50)

# ╔═╡ f4c66f05-039d-408f-96e9-006de5a56bf4
withdraw2(acc01, 60)

# ╔═╡ 64796bde-35cf-485c-a89d-dc35dac790c4
deposit2(acc01, 40)

# ╔═╡ bb1c18e1-3441-464e-8704-247605473fe2
withdraw2(acc01, 60)

# ╔═╡ 2775e29d-375f-46cc-8d38-143d7264c2d3
acc03 = Account()                 # use of default initial value

# ╔═╡ b94e1bd0-c027-4bec-ad5b-3d42ef89be89
acc03.balance

# ╔═╡ 1e4ee91e-d7d4-4ead-ba91-fa755d054126
md"
---
##### end of ch. 1.1.1
"

# ╔═╡ d6236f84-e645-4c30-9fd2-51e60ff59d0f
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
# ╟─3be3adc0-9296-11ed-1f41-6b27f36152dc
# ╟─f071e2c8-736e-4c26-bd6e-b318ca05843a
# ╟─c763cc9d-6a22-443b-b4d2-7d1c233384c7
# ╟─9e764fca-5582-4698-b42b-78937ca7c9f3
# ╠═8daa94e6-a26f-4997-9114-c71e3f4a8b1b
# ╠═6c72ecc9-0f66-428e-8063-924125e23bc0
# ╠═721753d9-33ad-47a1-a422-d272624bf71e
# ╠═07667dbd-8c42-4c21-a8a4-d6761df2e1f3
# ╠═a6f371d6-45f5-4f1f-979d-e08562f47279
# ╟─32397461-d435-40bb-809d-061402514161
# ╠═356d0d27-4fc6-4fc7-84bd-8f6050e399c3
# ╠═7d2a146b-b41a-46db-ab34-66d12434ba42
# ╠═767ff460-2a2b-4a6b-b244-25bbff57944b
# ╠═09c6cb23-32c7-4d9e-bb88-a75b7e9a14ee
# ╠═c76c6f21-2db9-4cc5-be4f-1de2fa903284
# ╟─790fb3fa-aa5c-47f0-9e99-3bf127062bb2
# ╠═b126c44a-6a0a-480d-a283-a4ccb0ee9d03
# ╟─b23008c0-cfcf-4ba6-bb37-6b4f7b04133d
# ╠═e983ccde-b2d3-42c9-9b6f-5a0531bdf54c
# ╠═aae79cf7-dc9a-40b0-a19c-c76effdcbc20
# ╠═ce3e98af-fbfe-4676-b4b6-254d84f877a3
# ╠═5ba004b0-ce75-40ea-980c-de5a6eae6b91
# ╠═6ad1d45f-9a5c-4cb7-9633-f28f2ff4357f
# ╠═02890cd7-7b34-4596-92f8-dd22e0f67642
# ╟─072eb694-9cca-463d-9cbe-bdc06fd33d70
# ╠═5869257d-dcd5-4cf9-a029-52afe752fb65
# ╠═de816416-9b07-4176-9d5b-338bae10bc0d
# ╠═ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
# ╠═9b3f7b70-d151-4d81-b026-1e5d0cbe3110
# ╠═5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
# ╠═74731df8-fdb6-4bbc-a384-081117c2e9b6
# ╟─b2d1a37d-d5c7-4233-9346-e2c5da7e204d
# ╠═1044aa81-2c86-453a-bdf6-6e473033e9ce
# ╠═4412266e-5cfd-43f3-bc40-dcb444dc984b
# ╠═f55e1b4d-84da-4491-bc92-fa31f25b026f
# ╠═620fd9d3-6370-47ba-91d3-75610182a5dd
# ╠═40e63b6d-96de-45de-8ce0-8f10b3b8e3f2
# ╠═3e1d3c9e-6cae-41d2-bace-c750bb3aecd1
# ╠═22611c1d-eb41-40f2-b439-fecb4d2612c4
# ╠═fcd59a2c-a930-4bf2-8f3f-6815efe9f776
# ╠═3a1e7bc9-5164-41ed-8f79-86cbc7f45cac
# ╠═f4c66f05-039d-408f-96e9-006de5a56bf4
# ╠═64796bde-35cf-485c-a89d-dc35dac790c4
# ╠═bb1c18e1-3441-464e-8704-247605473fe2
# ╠═2775e29d-375f-46cc-8d38-143d7264c2d3
# ╠═b94e1bd0-c027-4bec-ad5b-3d42ef89be89
# ╟─1e4ee91e-d7d4-4ead-ba91-fa755d054126
# ╟─d6236f84-e645-4c30-9fd2-51e60ff59d0f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
