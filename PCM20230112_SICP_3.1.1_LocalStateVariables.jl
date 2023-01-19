### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 3be3adc0-9296-11ed-1f41-6b27f36152dc
md"
====================================================================================
#### SICP: [3.1.1\_Local\_State\_Variables](https://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e1)
##### file: PCM20230112\_SICP:\_3.1.1\_LocalStateVariables.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/19 ***

====================================================================================

"

# ╔═╡ b9751ac2-95b0-43e0-8f0e-f6be4ac565fe
md"
##### *Encapsulation* in Julia
Under what circumstances is it possible to achieve *encapsulation* despite the fact we have *no* keywords $$private$$ or $$public$$.
We can demonstrate that in some circumstances it is possible to skim off information from object's fields if their names are known or could be guessed. So explicit countermeasures have to be taken. In several blogs *encapsulation* in Julia is a central topic (s.a. References).
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
	balance1 = 100
	function withdraw1(amount)#
		global balance1
		if balance1 >= amount 
			begin balance1 = balance1 - amount 
				balance1
			end # begin
		else
			"Insufficient Funds"
		end # if
	end # function withdraw1
end # begin

# ╔═╡ 6c72ecc9-0f66-428e-8063-924125e23bc0
withdraw1(25)

# ╔═╡ 721753d9-33ad-47a1-a422-d272624bf71e
withdraw1(25)

# ╔═╡ 07667dbd-8c42-4c21-a8a4-d6761df2e1f3
withdraw1(60)

# ╔═╡ a6f371d6-45f5-4f1f-979d-e08562f47279
withdraw1(15)

# ╔═╡ 68d841c6-507e-4fb6-b5d3-7c0d2a29e646
balance1                      # *no* encapsulation !

# ╔═╡ 32397461-d435-40bb-809d-061402514161
md"
---
###### Local environment with $$let$$
"

# ╔═╡ 356d0d27-4fc6-4fc7-84bd-8f6050e399c3
newWithdraw =
	let balance2 = 100
		(amount,) ->                      #  closure with nonlocal captured 'balance2'
			if balance2 >= amount 
				begin balance2 = balance2 - amount 
					balance2
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

# ╔═╡ ca3317a3-d38b-419e-95d1-05c85e3ae661
balance2                             #  encapsulation achieved !

# ╔═╡ 790fb3fa-aa5c-47f0-9e99-3bf127062bb2
md"
---
###### Creating *withdrawal processors* (= closure with nonlocal captured 'balance')
"

# ╔═╡ b126c44a-6a0a-480d-a283-a4ccb0ee9d03
function makeWithdraw(balance)
	(amount,) ->                         #  closure with nonlocal captured 'balance'
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

# ╔═╡ a449b683-cb99-4791-92ba-bc39ebc286a1
w2(70)

# ╔═╡ eb28e2de-e61e-4bf0-99e9-c6596038fdce
w1      # value of object w1 is *closure* (= lambda-function with captured 'balance')

# ╔═╡ 4cbeb61a-7eb0-4164-b911-ae15913f4d27
w2      # value of object w1 is *closure* (= lambda-function with captured 'balance')

# ╔═╡ 422509fc-33bb-481d-bb46-4607ad00a0de
w1.balance       # *no* encapsulation !

# ╔═╡ cd6ee275-0e40-4ebf-8dad-2cd2249feade
w2.balance       # *no* encapsulation !

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

# ╔═╡ de816416-9b07-4176-9d5b-338bae10bc0d
acc06 = makeAccount(100)           # make new account 'acc06'

# ╔═╡ 0bb8357a-112f-43e4-899e-9ff252d269a9
acc06

# ╔═╡ ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
acc06(:withdraw)(50)

# ╔═╡ cc533c22-6845-45c3-b706-cda13f7cfbd1
acc06(:getBalance)

# ╔═╡ 9b3f7b70-d151-4d81-b026-1e5d0cbe3110
acc06(:withdraw)(60)

# ╔═╡ 3b4110c5-3e54-4c5f-8d16-603d627a21de
acc06(:getBalance)

# ╔═╡ 5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
acc06(:deposit)(40)

# ╔═╡ 23036e80-430d-4d43-a26d-ad06b43a8e95
acc06(:getBalance)

# ╔═╡ 74731df8-fdb6-4bbc-a384-081117c2e9b6
acc06(:withdraw)(60)

# ╔═╡ 4e4fe55d-3407-4013-8b19-b0c5338ca13e
acc06(:getBalance)

# ╔═╡ b50d9d51-7fb9-438a-beb0-a730dec2e5de
acc06.balance                      #  encapsulation achieved !

# ╔═╡ 6432f188-2e31-4a5f-9a8b-9260106c61ee
acc07 = makeAccount(200)           # make new account 'acc07'

# ╔═╡ c8600cbe-2aab-47e1-ad51-09da9393df5c
acc07.balance                      #  encapsulation achieved !

# ╔═╡ 81196b9d-3e55-4934-87d7-fe2a02a7868a
acc07(:getBalance)

# ╔═╡ b2d1a37d-d5c7-4233-9346-e2c5da7e204d
md"
---
##### 3.1.1.2 Idiomatic Julia with $$mutable$$ $$struct$$, *inner* constructor $$new$$ and *multiple dispatch* and *encapsulation* with $$getProperty$$, and $$setProperty$$
"

# ╔═╡ 1044aa81-2c86-453a-bdf6-6e473033e9ce
mutable struct Account
	# the underscore '_' is only a signal that this 'balance' should be private
	# and encapsulated
	_balance::Float64           # local variable, should be private !
	# 1st explicit (but redundant) inner constructor to bind local var 'balance'
	Account(_balance) =   
		_balance >= 0.0 ? 
		new(_balance) :         # <--- 1st inner constructor
		"negative initial balance not allowed" 
	# 2nd inner constructor to bind local var '_balance' to default value '0.0'
	Account() = new(0.0)        # <--- 2nd inner constructor
end # struct

# ╔═╡ 4412266e-5cfd-43f3-bc40-dcb444dc984b
function withdraw2(object, amount)
	let balance = object._balance
		if balance >= amount 
			begin 
				balance = balance - amount 
				object._balance = balance
			end # begin
		else
			"Insufficient Funds"
		end # if
	end # let
end # function withdraw2

# ╔═╡ f55e1b4d-84da-4491-bc92-fa31f25b026f
function deposit2(object, amount)
	let balance = object._balance
		begin 
			balance = balance + amount 
			object._balance = balance
		end # begin
	end # let
end # function deposit2

# ╔═╡ 79c3cbc9-415f-44a1-a615-5887cf7722d0
function Base.getproperty(obj::Account, sym::Symbol)
	 if sym === :_balance
        throw(error("$sym is a 'private' field, no *direct* access allowed"))
	else # fallback to getfield
        return getfield(obj, sym)
	 end # if
end # function Base.getproperty

# ╔═╡ 9a0efcfa-20a2-4474-a502-d7a44519d039
function Base.setproperty!(obj::Account, sym::Symbol, rhval)
	 if sym === :_balance
        throw(error("$sym is a 'private' field, no *direct* setting allowed"))
	 end # if
end # function Base.setproperty!

# ╔═╡ 620fd9d3-6370-47ba-91d3-75610182a5dd
acc09 = Account(100)

# ╔═╡ 3a1e7bc9-5164-41ed-8f79-86cbc7f45cac
withdraw2(acc09, 50)

# ╔═╡ f4c66f05-039d-408f-96e9-006de5a56bf4
withdraw2(acc09, 60)

# ╔═╡ 64796bde-35cf-485c-a89d-dc35dac790c4
deposit2(acc09, 40)

# ╔═╡ bb1c18e1-3441-464e-8704-247605473fe2
withdraw2(acc09, 60)

# ╔═╡ 40e63b6d-96de-45de-8ce0-8f10b3b8e3f2
acc09._balance                     #  encapsulation achieved !

# ╔═╡ 259e5aad-a279-4bd4-9f7a-448a93e9013a
acc09._balance = 999               #  encapsulation achieved !

# ╔═╡ 22611c1d-eb41-40f2-b439-fecb4d2612c4
acc10 = Account(-100 + 100)

# ╔═╡ fcd59a2c-a930-4bf2-8f3f-6815efe9f776
acc10._balance                     #  encapsulation achieved !

# ╔═╡ 691d36c7-27e5-468d-a211-c2ea5b522243
acc10._balance = 999               #  encapsulation achieved !

# ╔═╡ 2775e29d-375f-46cc-8d38-143d7264c2d3
acc11 = Account()                  #  encapsulation achieved !

# ╔═╡ b94e1bd0-c027-4bec-ad5b-3d42ef89be89
acc11._balance                     #  encapsulation achieved !

# ╔═╡ 8b2a3131-9b97-451e-a87f-516cb9995a31
acc11._balance = 999

# ╔═╡ 7ce887c0-7309-4da6-ac99-2c3cdf05af42
md"
---
##### *Encapsulation* with Private, Public Types, and Closures I

To emphasis the necessity and issue of encapsulation of software written in Julia [Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) quotes [Kwong, 2020, ch.8, p.315](https://subscription.packtpub.com/book/programming/9781838648817/11) : 
*Based on the Principle of Least Privilege (POLP), we would consider hiding unnecessary implementation details to the client of the interface. However, Julia's data structure is transparent – all fields are automatically exposed and accessible. This poses a potential problem because any improper usage or mutation can break the system. Additionally, by accessing the fields directly, the code becomes more tightly coupled with the underlying implementation of an object.*

[Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) provides as a prototypical implementation an OO-area-computation of rectangular objects. The idea is to *distribute* the generation of instances with *private* and *public* fields containing *class methods* over *private* types, *public* types, and a function *closure*.
"

# ╔═╡ 77bfbb6f-715e-47d1-8ac6-355541f1fd99
begin
	# private type '_Rectangle' (Cox. "the private stuff")
	struct _Rectangle
  		width::Float64
  		height::Float64
	end # struct _Rectangle
	#----------------------
	# public type 'Rectangle' (Cox: "the public stuff")
	struct Rectangle
  		area::Function
	end # struct Rectangle
	#----------------------
	# Class 'Rectangle' by function closure 'Rectangle' (Cox: "the closure trick")
	function Rectangle(width::Float64, height::Float64)
  		self = _Rectangle(width, height)  # generation of private object '_Rectangle'
  		area() = self.width * self.height # definition public nullary function 'area'
  	return Rectangle(area)                # generation of object with field 'area'
	end # function Rectangle              # export of object with public field 'area'
end # begin

# ╔═╡ 6c625f30-4244-4980-8615-8c11faa62102
rect45 = Rectangle(4.0, 5.0)  # generation of object 'rect45' with public field 'area'

# ╔═╡ bed00389-ccad-4b48-957b-570b36d6acb6
rect45

# ╔═╡ 72926649-b487-480d-a811-3cdcd4801881
rect45.width                     #  encapsulation achieved !

# ╔═╡ e1239c7c-2fd1-4281-a452-fa3b0dfca253
rect45.height                    #  encapsulation achieved !

# ╔═╡ 460aad5d-3fa9-4f11-b05e-7f9d6775d3a7
rect45.area                      # field 'area' contains the nullary function 'area'

# ╔═╡ 8e0ea6fb-092d-4500-8e6e-3b4ef6f1dd95
rect45.area()                    # application of nullary 'area' function

# ╔═╡ d8fb7198-5a29-464d-83b6-c847a2b4c6d4
md"
---
##### *Encapsulation* with Private, Public Types, and Closures II
- We advocate the idea that the function *closure* should take the role of the conventional *OO-class*.
"

# ╔═╡ aa2b2dba-6f21-45a8-aa0d-9395d008b63a
md"
###### *private* type $$\_Account2$$ with *private* field $$\_balance$$
"

# ╔═╡ c63648ad-755c-46b0-8aa6-10be02a31855
mutable struct _Account2
	_balance
	# 1st explicit (but redundant) inner constructor to bind local var 'balance'
	_Account2(_balance) =   
		_balance >= 0.0 ? 
		new(_balance) :         # <--- 1st inner constructor
		"negative initial balance not allowed" 
	# 2nd inner constructor to bind local var '_balance' to default value '0.0'
	_Account2() = new(0.0)        # <--- 2nd inner constructor
end # mutable struct _Account

# ╔═╡ ec46d9b4-809c-465f-ba9d-8b574b2dff76
md"
###### *public* type $$Account2$$ with *public* fields of $$Function$$ type
"

# ╔═╡ 6bd5f80d-0b8b-4476-9da8-46f00e488ec1
struct Account2
	  withdraw::Function
	   deposit::Function
	getBalance::Function
end # struct Account

# ╔═╡ fc264809-87ea-4050-ac8e-ed5349ef13ef
md"
###### *Mimicking* Class $$makeAccount2$$ by function closure $$makeAccount2$$
"

# ╔═╡ ee123b18-47e0-47b7-a483-abce6ef34df8
function makeAccount2(amount)
	#----------------------------------------------------------------------
	# generation of private object 'eAO' = 'encapsulatedAccountObject'
	eAO = _Account2(amount) 
	#----------------------------------------------------------------------
	# definition of public methods 'withdraw', 'deposit', and 'getBalance'
	#    under use of private field '_balance'
	function withdraw(amount)
		let balance = eAO._balance
			if balance >= amount 
				begin 
					balance = balance - amount 
					eAO._balance = balance
				end # begin
			else
				"Insufficient Funds"
			end # if
		end # let
	end # function withdraw
	#----------------------------------------------------------------------
	function deposit(amount)
		let balance = eAO._balance
			begin 
				balance = balance + amount 
				eAO._balance = balance
			end # begin
		end # let
	end # function deposit
	#----------------------------------------------------------------------
	function getBalance()
		let balance = eAO._balance
			balance
		end # let
	end # function getBalance
	#----------------------------------------------------------------------
	return Account2(withdraw, deposit, getBalance)
end # function makeAccount2

# ╔═╡ fc449af5-3172-4284-b1a4-f486972ce263
 # make instance 'acc1946' by class (=closure) 'makeAccount2'
acc1946 = makeAccount2(200)

# ╔═╡ fac2f24f-28ae-4e45-9dd0-7f94293eacdc
acc1946.balance                           #  encapsulation achieved !

# ╔═╡ b72dba10-d2e6-4e47-8262-62a24d5960ac
acc1946.withdraw

# ╔═╡ da384a7f-f0b8-442f-9d4a-04e857812e04
acc1946.withdraw(20)

# ╔═╡ ae3ee4a5-7b70-44eb-9ad3-69d882831da1
acc1946.balance                            #  encapsulation achieved !

# ╔═╡ f06d6218-3553-4708-90ea-e73b607f703a
acc1946.deposit(40)

# ╔═╡ 243ba1d5-8bad-4a45-b3f1-dd03bf2bfc67
 acc1946.balance                           #  encapsulation achieved !

# ╔═╡ b2b11fb4-a59a-4a45-a708-5e7ab7391aee
 acc1946.getBalance()     # access to private fiel '_balance' only by 'getBalance()'

# ╔═╡ c898f559-6acd-4a6d-9876-4672f7ee3780
md"
---
##### References
- **Cox, M.**, *Julia Encapsulation*, [https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/), last visit 2023/01/18

- **Kwong, T.**, *Hands-On Design Patterns and Best Practices with Julia*, 2020, [https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia](https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia)

---
##### Further Reading
- **Christianson, A.**, *ObjectOrientation and Polymorphism in Julia*, [https://github.com/ninjaaron/oo-and-polymorphism-in-julia](https://github.com/ninjaaron/oo-and-polymorphism-in-julia), last visit 2023/01/18
- **Rackauckas, Ch.**, *Type-Dispatch Design: Post Object-Oriented Programming for Julia*, [http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/](http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/), last visit 2023/01/18
- **Rackauckas, Ch.**, *Multiple Dispatch Designs: Duck Typing, Hierarchies and Traits*, [http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns](http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns), last visit 2023/01/18
"

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
# ╟─b9751ac2-95b0-43e0-8f0e-f6be4ac565fe
# ╟─f071e2c8-736e-4c26-bd6e-b318ca05843a
# ╟─c763cc9d-6a22-443b-b4d2-7d1c233384c7
# ╟─9e764fca-5582-4698-b42b-78937ca7c9f3
# ╠═8daa94e6-a26f-4997-9114-c71e3f4a8b1b
# ╠═6c72ecc9-0f66-428e-8063-924125e23bc0
# ╠═721753d9-33ad-47a1-a422-d272624bf71e
# ╠═07667dbd-8c42-4c21-a8a4-d6761df2e1f3
# ╠═a6f371d6-45f5-4f1f-979d-e08562f47279
# ╠═68d841c6-507e-4fb6-b5d3-7c0d2a29e646
# ╟─32397461-d435-40bb-809d-061402514161
# ╠═356d0d27-4fc6-4fc7-84bd-8f6050e399c3
# ╠═7d2a146b-b41a-46db-ab34-66d12434ba42
# ╠═767ff460-2a2b-4a6b-b244-25bbff57944b
# ╠═09c6cb23-32c7-4d9e-bb88-a75b7e9a14ee
# ╠═c76c6f21-2db9-4cc5-be4f-1de2fa903284
# ╠═ca3317a3-d38b-419e-95d1-05c85e3ae661
# ╟─790fb3fa-aa5c-47f0-9e99-3bf127062bb2
# ╠═b126c44a-6a0a-480d-a283-a4ccb0ee9d03
# ╟─b23008c0-cfcf-4ba6-bb37-6b4f7b04133d
# ╠═e983ccde-b2d3-42c9-9b6f-5a0531bdf54c
# ╠═aae79cf7-dc9a-40b0-a19c-c76effdcbc20
# ╠═ce3e98af-fbfe-4676-b4b6-254d84f877a3
# ╠═a449b683-cb99-4791-92ba-bc39ebc286a1
# ╠═eb28e2de-e61e-4bf0-99e9-c6596038fdce
# ╠═4cbeb61a-7eb0-4164-b911-ae15913f4d27
# ╠═422509fc-33bb-481d-bb46-4607ad00a0de
# ╠═cd6ee275-0e40-4ebf-8dad-2cd2249feade
# ╟─072eb694-9cca-463d-9cbe-bdc06fd33d70
# ╠═5869257d-dcd5-4cf9-a029-52afe752fb65
# ╠═de816416-9b07-4176-9d5b-338bae10bc0d
# ╠═0bb8357a-112f-43e4-899e-9ff252d269a9
# ╠═ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
# ╠═cc533c22-6845-45c3-b706-cda13f7cfbd1
# ╠═9b3f7b70-d151-4d81-b026-1e5d0cbe3110
# ╠═3b4110c5-3e54-4c5f-8d16-603d627a21de
# ╠═5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
# ╠═23036e80-430d-4d43-a26d-ad06b43a8e95
# ╠═74731df8-fdb6-4bbc-a384-081117c2e9b6
# ╠═4e4fe55d-3407-4013-8b19-b0c5338ca13e
# ╠═b50d9d51-7fb9-438a-beb0-a730dec2e5de
# ╠═6432f188-2e31-4a5f-9a8b-9260106c61ee
# ╠═c8600cbe-2aab-47e1-ad51-09da9393df5c
# ╠═81196b9d-3e55-4934-87d7-fe2a02a7868a
# ╟─b2d1a37d-d5c7-4233-9346-e2c5da7e204d
# ╠═1044aa81-2c86-453a-bdf6-6e473033e9ce
# ╠═4412266e-5cfd-43f3-bc40-dcb444dc984b
# ╠═f55e1b4d-84da-4491-bc92-fa31f25b026f
# ╠═79c3cbc9-415f-44a1-a615-5887cf7722d0
# ╠═9a0efcfa-20a2-4474-a502-d7a44519d039
# ╠═620fd9d3-6370-47ba-91d3-75610182a5dd
# ╠═3a1e7bc9-5164-41ed-8f79-86cbc7f45cac
# ╠═f4c66f05-039d-408f-96e9-006de5a56bf4
# ╠═64796bde-35cf-485c-a89d-dc35dac790c4
# ╠═bb1c18e1-3441-464e-8704-247605473fe2
# ╠═40e63b6d-96de-45de-8ce0-8f10b3b8e3f2
# ╠═259e5aad-a279-4bd4-9f7a-448a93e9013a
# ╠═22611c1d-eb41-40f2-b439-fecb4d2612c4
# ╠═fcd59a2c-a930-4bf2-8f3f-6815efe9f776
# ╠═691d36c7-27e5-468d-a211-c2ea5b522243
# ╠═2775e29d-375f-46cc-8d38-143d7264c2d3
# ╠═b94e1bd0-c027-4bec-ad5b-3d42ef89be89
# ╠═8b2a3131-9b97-451e-a87f-516cb9995a31
# ╟─7ce887c0-7309-4da6-ac99-2c3cdf05af42
# ╠═77bfbb6f-715e-47d1-8ac6-355541f1fd99
# ╠═6c625f30-4244-4980-8615-8c11faa62102
# ╠═bed00389-ccad-4b48-957b-570b36d6acb6
# ╠═72926649-b487-480d-a811-3cdcd4801881
# ╠═e1239c7c-2fd1-4281-a452-fa3b0dfca253
# ╠═460aad5d-3fa9-4f11-b05e-7f9d6775d3a7
# ╠═8e0ea6fb-092d-4500-8e6e-3b4ef6f1dd95
# ╟─d8fb7198-5a29-464d-83b6-c847a2b4c6d4
# ╟─aa2b2dba-6f21-45a8-aa0d-9395d008b63a
# ╠═c63648ad-755c-46b0-8aa6-10be02a31855
# ╟─ec46d9b4-809c-465f-ba9d-8b574b2dff76
# ╠═6bd5f80d-0b8b-4476-9da8-46f00e488ec1
# ╟─fc264809-87ea-4050-ac8e-ed5349ef13ef
# ╠═ee123b18-47e0-47b7-a483-abce6ef34df8
# ╠═fc449af5-3172-4284-b1a4-f486972ce263
# ╠═fac2f24f-28ae-4e45-9dd0-7f94293eacdc
# ╠═b72dba10-d2e6-4e47-8262-62a24d5960ac
# ╠═da384a7f-f0b8-442f-9d4a-04e857812e04
# ╠═ae3ee4a5-7b70-44eb-9ad3-69d882831da1
# ╠═f06d6218-3553-4708-90ea-e73b607f703a
# ╠═243ba1d5-8bad-4a45-b3f1-dd03bf2bfc67
# ╠═b2b11fb4-a59a-4a45-a708-5e7ab7391aee
# ╟─c898f559-6acd-4a6d-9876-4672f7ee3780
# ╟─1e4ee91e-d7d4-4ead-ba91-fa755d054126
# ╟─d6236f84-e645-4c30-9fd2-51e60ff59d0f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
