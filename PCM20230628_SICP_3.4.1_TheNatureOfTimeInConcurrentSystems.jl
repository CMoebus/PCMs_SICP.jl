### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 90a3c9d0-15ae-11ee-0e7d-d9080cd697e2
md"
====================================================================================
#### SICP: 3.4.1 The Nature of Time in Concurrent Systems
###### file: PCM20230628_SICP_3.4.1_TheNatureOfTimeInConcurrentSystems.jl
###### Julia/Pluto.jl-code (1.9.1/0.19.25) by PCM *** 2023/06/29 ***

====================================================================================
"

# ╔═╡ 00ba36b9-21e8-4b1e-b987-35a23a36b9a6
md"
---
##### 3.4.1.1 Two Depositors Sharing an Account

**SICP, Fig. 3.29** demonstrates the desastrous effect of interleaving bank account *actions* (= *events*). The following code prevents this by *encapsulating* and *serializing* the three events in the *function* (= *process*) $withdraw$:
- (1) *accessing* balance
- (2) *computing* new value of balance
- (3) *setting* balance to this new value
"

# ╔═╡ 55d27648-834d-4ab6-a736-0050213ae022
#---------------------------------------------------------------------------------
# shared account
function makeSharedAccount( ;owners::Tuple{Symbol, Symbol} = (:Peter, :Paul)) 
	balance = 100
	function withdraw(amount, name)
		(name in owners) ? true : error("name=$name is not an owner")
		if balance >= amount 
			balance = balance + amount  # new subtraction replaced by -addtion
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	withdraw
end # function makeSharedAccount
#---------------------------------------------------------------------------------

# ╔═╡ 16a49488-bcb4-404c-9f03-5fffee2a05c7
md"
All *withdraw* processes start a *series* of events which *cannot* be interleaved by events of other processes. Each possible order of $withdraw$ processes comes to an end with the same result 65. No other endresult like $90$ or $75$ as in Fig. 3.29 is possible.
"

# ╔═╡ 73c8b14f-3bcf-426b-b0d4-3e04e4c3bf98
let # order Peter >> Paul
	sharedAccountA = makeSharedAccount()
	sharedAccountA(-10, :Peter)            # Peter
	sharedAccountA(-25, :Paul)             # Paul
end # let

# ╔═╡ e40970c8-ed2a-47e1-802b-b80faae4d5d2
let # order Paul >> Peter
	sharedAccountB = makeSharedAccount()
	sharedAccountB(-25, :Paul)             # Paul
	sharedAccountB(-10, :Peter)            # Peter
end # let

# ╔═╡ 86e78c31-a6d6-4834-9594-bc7dec7455c7
md"
---
##### 3.4.1.2 Concurrent and Sequential Processes

**SICP, Fig.3.30** displays the *concurrent* and *sequential* transactions related towards a *shared* and a *private* bankaccount. We want to simulate that with ordinary Julia-code.
"

# ╔═╡ 5e084728-89ec-4bcd-909b-8e3866eb378f
#---------------------------------------------------------------------------------
# Paul's private account
function makePrivateAccount(owner::Symbol) 
	balance = 300
	function deposit(amount, name)
		name == owner ? true : error("name=$name is not an owner")
		balance = balance + amount  # new subtraction replaced by -addtion
	end # function deposit
	deposit
end # function makePrivateAccount

# ╔═╡ 67dd4b33-0c2b-4307-b7f4-2bf684041703
let # order Peter >> Paul
	sharedAccountC  = makeSharedAccount()
	privateAccountD = makePrivateAccount(:Peter)
	privateAccountC = makePrivateAccount(:Paul)
	# concurrent balance check of shared account and deposit by wrong owner
	# sharedAccountC(  0, :Peter), privateAccountC(5, :Peter) # ==> Peter not an owner
	sharedAccountC(-10, :Peter), privateAccountC(5, :Paul)  # concurrent
	sharedAccountC(-25, :Paul),  privateAccountC(0, :Paul)  # concurrent
end # let

# ╔═╡ 8918328a-23fb-46b3-851b-89dce8334bcc
md"
---
##### end of Ch. 3.4.1
"

# ╔═╡ 43dfa275-b8f2-4908-a5e0-476b389667bf
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"


# ╔═╡ Cell order:
# ╟─90a3c9d0-15ae-11ee-0e7d-d9080cd697e2
# ╟─00ba36b9-21e8-4b1e-b987-35a23a36b9a6
# ╠═55d27648-834d-4ab6-a736-0050213ae022
# ╟─16a49488-bcb4-404c-9f03-5fffee2a05c7
# ╠═73c8b14f-3bcf-426b-b0d4-3e04e4c3bf98
# ╠═e40970c8-ed2a-47e1-802b-b80faae4d5d2
# ╟─86e78c31-a6d6-4834-9594-bc7dec7455c7
# ╠═5e084728-89ec-4bcd-909b-8e3866eb378f
# ╠═67dd4b33-0c2b-4307-b7f4-2bf684041703
# ╟─8918328a-23fb-46b3-851b-89dce8334bcc
# ╟─43dfa275-b8f2-4908-a5e0-476b389667bf
