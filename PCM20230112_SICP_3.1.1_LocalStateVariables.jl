### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 3be3adc0-9296-11ed-1f41-6b27f36152dc
md"
====================================================================================
#### SICP: [3.1.1\_Local\_State\_Variables](https://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e1)
##### file: PCM20230112\_SICP:\_3.1.1\_LocalStateVariables.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/02/12 ***

====================================================================================

"

# ╔═╡ 69391423-4be3-473e-a488-f1d8f545a4cb
md"
...
"

# ╔═╡ b9751ac2-95b0-43e0-8f0e-f6be4ac565fe
md"
##### *Encapsulation* in Julia
Under what circumstances is it possible to achieve *encapsulation* despite the fact we have *no* keywords $$private$$ or $$public$$ ?

To emphasis the necessity and issue of encapsulation of software written in Julia [Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) quotes [Kwong, 2020, ch.8, p.315](https://subscription.packtpub.com/book/programming/9781838648817/11) : 
*Based on the Principle of Least Privilege (POLP), we would consider hiding unnecessary implementation details to the client of the interface. However, Julia's data structure is transparent – all fields are automatically exposed and accessible. This poses a potential problem because any improper usage or mutation can break the system. Additionally, by accessing the fields directly, the code becomes more tightly coupled with the underlying implementation of an object.*

We can demonstrate that in some circumstances it is possible to skim off information from object's fields if their names are known or could be guessed. So explicit countermeasures have to be taken. In several blogs *encapsulation* in Julia is a central topic (s.a. *references*, below).
"

# ╔═╡ f071e2c8-736e-4c26-bd6e-b318ca05843a
md"
---
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
	#----------------------------------
	function withdraw(amount)
		global balance
		if balance >= amount 
			balance = balance - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw1
	#----------------------------------
end # begin    

# ╔═╡ 68d841c6-507e-4fb6-b5d3-7c0d2a29e646
balance                            # *no* encapsulation achieved !   :(

# ╔═╡ 32397461-d435-40bb-809d-061402514161
md"
---
###### Local environment with $$let$$
"

# ╔═╡ 356d0d27-4fc6-4fc7-84bd-8f6050e399c3
newWithdraw =
	#  var name 'balance' instead of 'balance2' would do 
	#  but we want to demonstrate that 'balance2' could not skimmed off 
	let balance2 = 100              
		amount ->                   #  closure with nonlocal captured 'balance2'
			if balance2 >= amount 
				balance2 = balance2 - amount 
			else
				"Insufficient Funds"
			end # if
		# this closure is returned and bound to variable 'newWithdraw'
	end # let   

# ╔═╡ 98cec23b-157b-43e0-a13c-05765104ffc2
newWithdraw              # ... is bound to closure 'amount -> ...'

# ╔═╡ 7d2a146b-b41a-46db-ab34-66d12434ba42
newWithdraw(25)          # 100 - 25 ==> 75

# ╔═╡ 767ff460-2a2b-4a6b-b244-25bbff57944b
newWithdraw(25)          #  75 - 25 ==> 50

# ╔═╡ 09c6cb23-32c7-4d9e-bb88-a75b7e9a14ee
newWithdraw(60)          #  50 - 60 = -10 ==> "Insufficient Funds"

# ╔═╡ c76c6f21-2db9-4cc5-be4f-1de2fa903284
newWithdraw(25)          #  50 - 25 ==> 25

# ╔═╡ ca3317a3-d38b-419e-95d1-05c85e3ae661
balance2                 #  encapsulation achieved !  :)

# ╔═╡ 0bc2e381-a79e-414b-be7a-0b18c19f46ac
balance                  # this is the first (global) variable

# ╔═╡ 790fb3fa-aa5c-47f0-9e99-3bf127062bb2
md"
---
###### Creating *withdrawal processors* (= closure with nonlocal captured 'balance')
"

# ╔═╡ b126c44a-6a0a-480d-a283-a4ccb0ee9d03
function makeWithdraw(balance3)
	#  var name 'balance' instead of 'balance3' would do 
	#  but we want to demonstrate that 'balance3' could not skimmed off 
	#----------------------------------------------------------------------
	amount ->                 #  closure with nonlocal captured 'balance3'
		if balance3 >= amount 
			balance3 = balance3 - amount 
		else
			"Insufficient Funds"
		end # if
	#---------------------------------------------------------------------
	# this closure is returned and bound to variable 'makeWithdraw'
end # function makeWithdraw  

# ╔═╡ 0e53929d-b754-4087-b5b6-48949be9c14a
makeWithdraw      # ... is bound to closure 'amount -> ...'

# ╔═╡ b23008c0-cfcf-4ba6-bb37-6b4f7b04133d
md"
###### Creating objects
"

# ╔═╡ f9dc0140-174b-48e5-a911-a9fe894d591f
# ... is the closure 'amount -> ...' with balance3 => 100
makeWithdraw(100)   

# ╔═╡ e983ccde-b2d3-42c9-9b6f-5a0531bdf54c
# ... is bound to closure 'amount -> ...' with balance3 => 100
w1 = makeWithdraw(100)   

# ╔═╡ aae79cf7-dc9a-40b0-a19c-c76effdcbc20
# ... is bound to closure 'amount -> ...' with balance3 => 100
w2 = makeWithdraw(100)          

# ╔═╡ eb28e2de-e61e-4bf0-99e9-c6596038fdce
w1     # ... is bound to closure 'amount -> ...' with balance3 => 100

# ╔═╡ 4cbeb61a-7eb0-4164-b911-ae15913f4d27
w2     # ... is bound to closure 'amount -> ...' with balance3 => 100

# ╔═╡ ce3e98af-fbfe-4676-b4b6-254d84f877a3
w1(50)                         # 100 - 50 ==> 50

# ╔═╡ a449b683-cb99-4791-92ba-bc39ebc286a1
w2(70)                         # 100 - 70 ==> 30

# ╔═╡ 9ededb91-9731-4d06-9977-399a13461d7d
balance3                       # encapsulation achieved !   :)  

# ╔═╡ 422509fc-33bb-481d-bb46-4607ad00a0de
w1.balance3                    # w1 ==> 50

# ╔═╡ 73e7b715-09b3-4902-908c-656102c19a84
fieldnames(w1)

# ╔═╡ 87dec94d-c994-488e-a8d2-37a151d512f7
propertynames(w1)

# ╔═╡ 34623e1f-e782-42c6-ba99-60b996f8c7f4
w2.balance3                   # w2 ==> 30

# ╔═╡ 072eb694-9cca-463d-9cbe-bdc06fd33d70
md"
---
###### Simple Bank Account Objects with *Higher-order* function $dispatch$
" 

# ╔═╡ 5869257d-dcd5-4cf9-a029-52afe752fb65
function makeAccount(balance4)
	#-------------------------------------------------
	function withdraw(amount)
		if balance4 >= amount  
			balance4 = balance4 - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#-------------------------------------------------
	function deposit!(amount)
		balance4 = balance4 + amount 
	end # function deposit!
	#-------------------------------------------------
	function getBalance()
		balance4
	end # function getBalance
	#-------------------------------------------------
	function dispatch(message)
		#---------------------------------------------
		message == :withdraw ? withdraw :
		#---------------------------------------------
		message == :deposit! ? deposit! :
		#---------------------------------------------
		message == :getBalance ? getBalance() :
			"Unknown request -- makeAccount $message"
		#---------------------------------------------
	end # function dispatch
	#-------------------------------------------------
	return dispatch
end # function makeAccount       

# ╔═╡ 5aaa9fc2-048e-4b31-93e9-feeb343f665d
# ... is bound to closure 'message -> ...' with free variable 'balance4' ==> 100
makeAccount(100)    

# ╔═╡ de816416-9b07-4176-9d5b-338bae10bc0d
# ... is bound to closure 'message -> ...' with free variable 'balance4' ==> 100
acc06 = makeAccount(100)           # make new account 'acc06'

# ╔═╡ 6432f188-2e31-4a5f-9a8b-9260106c61ee
# ... is bound to closure 'message -> ...' with free variable 'balance4' ==> 200
acc07 = makeAccount(200)           # make new account 'acc07'

# ╔═╡ 0bb8357a-112f-43e4-899e-9ff252d269a9
# ... is bound to closure 'message -> ...' with free variable 'balance4' ==> 100
acc06                             

# ╔═╡ 3c4560bf-2837-4dc2-8371-f18202c93a23
balance4                    # encapsulation achieved !   :)  

# ╔═╡ 1ce2a07c-f99a-44a1-b88b-cd70c38eef53
acc06.balance4              # encapsulation achieved !   :)  

# ╔═╡ e82ee24b-d905-4042-ab15-1348f6c9332a
fieldnames(acc06)

# ╔═╡ e8791e7b-e578-4096-88d3-c206c664cc60
propertynames(acc06)

# ╔═╡ d90d3c81-5d6a-4ff9-856c-a6be88a30668
acc06(:getBalance)       # encapsulation achieved !   :)  

# ╔═╡ 81196b9d-3e55-4934-87d7-fe2a02a7868a
acc07(:getBalance)       # encapsulation achieved !   :) 

# ╔═╡ 535434c9-b28b-4f69-81ec-5b55f025febd
acc06(:withdraw)         # ... is bound to closure 'amount -> ...'

# ╔═╡ ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
acc06(:withdraw)(50)     # 100 - 50 ==> 50

# ╔═╡ cc533c22-6845-45c3-b706-cda13f7cfbd1
acc06(:getBalance)       # ==> 50

# ╔═╡ 9b3f7b70-d151-4d81-b026-1e5d0cbe3110
acc06(:withdraw)(60)     #  50 - 60 = -10 ==> "Insufficient Funds"

# ╔═╡ 3b4110c5-3e54-4c5f-8d16-603d627a21de
acc06(:getBalance)       # ==> 50

# ╔═╡ 5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
acc06(:deposit!)(40)     # 50 + 40 = 90

# ╔═╡ 23036e80-430d-4d43-a26d-ad06b43a8e95
acc06(:getBalance)       # ==> 90

# ╔═╡ 74731df8-fdb6-4bbc-a384-081117c2e9b6
acc06(:withdraw)(60)     # 90 - 60 ==> 30

# ╔═╡ b50d9d51-7fb9-438a-beb0-a730dec2e5de
acc06.balance4                      #  encapsulation achieved !  :)

# ╔═╡ 23bc9d98-0716-428a-bfd1-8f9dcf992a29
acc07.balance4                      #  encapsulation achieved !  :)

# ╔═╡ 736f13f9-f0d8-4a77-938b-9f184c1bc6f6
balance4                            #  encapsulation achieved !  :)

# ╔═╡ 2524cf60-fb90-4eca-99ab-ca73816fde82
md"
---
#### 3.1.1.2 Idiomatic Julia
"

# ╔═╡ 970ed801-7c4e-4d8b-b24f-b954a8e7f02a
md"
##### 3.1.1.2.1 *Recommended* Julia with *Types* and *Multiple-dispatch Functions*
"

# ╔═╡ 9d11406c-6777-4e75-81ec-49544014f2a9
md"
This simple approach is typical *Julian* and recommended by its creators, but as will be demonstrated *encapsulation* of object's field $balance$ *cannot* be achieved. So other propsals have to be followed.
"

# ╔═╡ 8d3bd44c-a065-4c58-b475-b0261b7f7f71
begin 
	#----------------------------------------------------------
	mutable struct Account
		balance::Number           # should be a private field
	end # mutable struct Account
	#---------------------------------------------------------
	function getBalance(self)
		self.balance
	end # function getBalance
	#-------------------------------------------------
	function withdraw(self, amount)
		if 	self.balance >= amount  
			self.balance -= amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#-------------------------------------------------
	function deposit!(self, amount)
		self.balance += amount 
	end # function deposit!
	#-------------------------------------------------
end # begin 


# ╔═╡ 6c72ecc9-0f66-428e-8063-924125e23bc0
withdraw(25)                       # 100 - 25 ==> 75

# ╔═╡ 721753d9-33ad-47a1-a422-d272624bf71e
withdraw(25)                       #  75 - 25 ==> 50

# ╔═╡ 07667dbd-8c42-4c21-a8a4-d6761df2e1f3
withdraw(60)                       #  50 - 60 = -10 ==> "Insufficient Funds"

# ╔═╡ a6f371d6-45f5-4f1f-979d-e08562f47279
withdraw(15)                       #  50 - 15 ==> 35

# ╔═╡ 799bd826-4a3a-41a8-abe4-fc02f81e3e0b
acc1946 = Account(400)

# ╔═╡ 6dbcadbb-12cb-464a-a248-bd761d0c6aae
acc1947 = Account(300)

# ╔═╡ 69695e61-ae4e-4bbf-beac-f9de6830c91c
getBalance(acc1946)

# ╔═╡ 89bbd3ed-9bf1-47bb-bc96-06017635ceb8
getBalance(acc1947)

# ╔═╡ 3335eaec-669e-46a0-975f-49c61418d491
withdraw(acc1946, 25)

# ╔═╡ 41303df3-689d-4194-95aa-ac1d3f4b045b
withdraw(acc1947, 25)

# ╔═╡ b29100e7-1ce2-4f2e-b031-efb172a722a3
deposit!(acc1946, 125)

# ╔═╡ 6abe7ba2-eb7c-43b4-a3ad-1a5db8d01b77
deposit!(acc1947, 125)

# ╔═╡ 69a854b9-15db-458f-bae7-051883b52714
acc1946.balance            #  no encapsulation achieved !   :(

# ╔═╡ 99c9ef5a-e169-41b3-b33a-db97c4453b95
acc1947.balance            #  no encapsulation achieved !   :(

# ╔═╡ 7ce887c0-7309-4da6-ac99-2c3cdf05af42
md"
---
##### 3.1.1.2.2 *Encapsulation* with Types and Constructors

[Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) provides as a prototypical implementation an OO-area-computation of rectangular objects. The idea is to *distribute* the generation of instances with *private* and *public* fields containing *class methods* over *private* types, *public* types, and a function *closure*.

We modified his code proposal slightly. We took his $function\;Rectangle$ (which generates the '*closure*') and put it as an *inner* constructor within the $struct\;Rectangle$. So the role of his '*closure trick*' is modified to an *inner constructor*.
"

# ╔═╡ 81336351-e171-4a5f-b3e5-fdc920134a6c
md"
###### *Public* and *Private* Fields in Types and *Inner* respectively *Outer* Constructors
"

# ╔═╡ 77bfbb6f-715e-47d1-8ac6-355541f1fd99
begin
	#---------------------------------------------------------------------------------
	# private type '_Rectangle' (Cox. "the private stuff")
	struct _Rectangle
  		_width::Number          # private object ("instance") field
  		_height::Number         # private object ("instance") field
		_Rectangle(_width, _height) = new(_width, _height)
	end # struct _Rectangle 
	#---------------------------------------------------------------------------------
	# public type 'Rectangle' (Cox: "the public stuff")
	struct Rectangle
  		area::Function         # public object ("instance") field
		#-----------------------------------------------------------------------------
		# constructor 'Rectangle' takes the role of a class factory
		# Class 'Rectangle' by function closure 'Rectangle' (Cox: "the closure trick")
		function Rectangle(width::Number, height::Number)
			# generation of private object '_self' ==> '_Rectangle'
  			_self = _Rectangle(width, height) # construction of private object '_self'
			# definition public nullary function 'area'
  			area() = _self._width * _self._height 
			#-------------------------------------------------------------------------
  			# generation of 'Rectangle' object with public field 'area'
			new(area)
			#-------------------------------------------------------------------------
			# return of 'rectangle' object with public field 'area'
		end # function Rectangle   
	#---------------------------------------------------------------------------------
	end # struct Rectangle
end # begin

# ╔═╡ 6d66c9ed-c2bf-483a-a17f-9b9012a8e6f6
propertynames(_Rectangle)

# ╔═╡ d6a7f7a4-58c8-4e3b-b303-c629226f353f
fieldnames(_Rectangle)

# ╔═╡ b2c42ace-2a60-4cab-be02-d5f27d0fa05f
_Rectangle._width

# ╔═╡ 217f5ed0-1d11-486f-992c-4ca8246bfd8e
_self._width

# ╔═╡ 91461427-2389-4a82-828f-3b1e970e61f3
propertynames(Rectangle)

# ╔═╡ ff4ff398-18ea-4fb2-8a01-85e7a73bdd9d
fieldnames(Rectangle)

# ╔═╡ 6c625f30-4244-4980-8615-8c11faa62102
rect45 = Rectangle(4.0, 5.0)  # generation of object 'rect45' with public field 'area'

# ╔═╡ bed00389-ccad-4b48-957b-570b36d6acb6
rect45

# ╔═╡ babf00d0-0fa8-449e-90d2-e9754e756e33
fieldnames(rect45)

# ╔═╡ f3c7b316-b68b-4df2-bf90-8ed0de15a27b
propertynames(rect45)

# ╔═╡ 72926649-b487-480d-a811-3cdcd4801881
rect45._width                     #  encapsulation achieved !    :)

# ╔═╡ 21abbedd-0320-4071-a102-0ebe7d7d5873
rect45.width                      #  encapsulation achieved !    :)

# ╔═╡ e1239c7c-2fd1-4281-a452-fa3b0dfca253
rect45._height                   #  encapsulation achieved !    :)

# ╔═╡ 460aad5d-3fa9-4f11-b05e-7f9d6775d3a7
rect45.area                      # field 'area' contains the nullary function 'area'

# ╔═╡ 8e0ea6fb-092d-4500-8e6e-3b4ef6f1dd95
rect45.area()                    # () ==> 4 * 5 ==> 20.0

# ╔═╡ b0076f41-dc5b-453f-aaed-f89a10e9d357
md"
---
##### 3.1.1.2.3 *Mutable Types* and *Constructors* in the Bank Account Problem
"

# ╔═╡ 2cc5aa62-86d3-4352-a0e6-752d0b0dc495
mutable struct _PrivateAccountClass
	#-----------------------------------------------------
	_balance::Number             # private field 
	#-----------------------------------------------------
end # mutable struct _PrivateAccount

# ╔═╡ 4c487700-fe59-4380-b146-05ed7926ecf6
struct PublicAccountClass
	#-----------------------------------------------------------
	getBalance::Function         # public field 
	withdraw::Function           # public field 
	deposit!::Function           # public field 
	#-----------------------------------------------------------
	function PublicAccountClass(balance)   # outer constructor 
		#-------------------------------------------------------
		# construct private object
		_self = _PrivateAccountClass(balance)  
		#-------------------------------------------------------
		getBalance() = _self._balance # function getBalance
		#-------------------------------------------------------
		withdraw(amount) =            # function withdraw
			_self._balance >= amount ?
			_self._balance -= amount :
			"Insufficient Funds"
		#-------------------------------------------------------
		deposit!(amount) =            # function deposit!
			_self._balance += amount 
		#-------------------------------------------------------
		new(getBalance, withdraw, deposit!) # inner constructor
		#-------------------------------------------------------
	end # function PublicAccountClass
end # struct PublicAccountClass

# ╔═╡ f783e6bb-8845-4004-a170-d60bbbae3dbe
acc1234 = PublicAccountClass(300)

# ╔═╡ 1f2437e0-7c48-4d0e-a7a6-baf09312989a
acc1234.getBalance()

# ╔═╡ eeccf709-d477-4590-9457-4b787bc47309
acc1234.withdraw(25)

# ╔═╡ 7822ee07-6e0d-4482-a209-5f0070ed1191
acc1234.deposit!(50)

# ╔═╡ 1dcc794b-6168-43e9-b242-7432b77ac4f7
acc1234._balance                  #  encapsulation achieved !    :)

# ╔═╡ c898f559-6acd-4a6d-9876-4672f7ee3780
md"
---
##### References
- **Cox, M.**, *Julia Encapsulation*, [https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/), last visit 2023/01/18

- **Grignoli, S.**, *What's the difference between closures and traditional classes?*, [https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes](https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes), last visit 2023/01/20

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
##### end of ch. 3.1.1
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

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─3be3adc0-9296-11ed-1f41-6b27f36152dc
# ╟─69391423-4be3-473e-a488-f1d8f545a4cb
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
# ╠═98cec23b-157b-43e0-a13c-05765104ffc2
# ╠═7d2a146b-b41a-46db-ab34-66d12434ba42
# ╠═767ff460-2a2b-4a6b-b244-25bbff57944b
# ╠═09c6cb23-32c7-4d9e-bb88-a75b7e9a14ee
# ╠═c76c6f21-2db9-4cc5-be4f-1de2fa903284
# ╠═ca3317a3-d38b-419e-95d1-05c85e3ae661
# ╠═0bc2e381-a79e-414b-be7a-0b18c19f46ac
# ╟─790fb3fa-aa5c-47f0-9e99-3bf127062bb2
# ╠═b126c44a-6a0a-480d-a283-a4ccb0ee9d03
# ╠═0e53929d-b754-4087-b5b6-48949be9c14a
# ╟─b23008c0-cfcf-4ba6-bb37-6b4f7b04133d
# ╠═f9dc0140-174b-48e5-a911-a9fe894d591f
# ╠═e983ccde-b2d3-42c9-9b6f-5a0531bdf54c
# ╠═aae79cf7-dc9a-40b0-a19c-c76effdcbc20
# ╠═eb28e2de-e61e-4bf0-99e9-c6596038fdce
# ╠═4cbeb61a-7eb0-4164-b911-ae15913f4d27
# ╠═ce3e98af-fbfe-4676-b4b6-254d84f877a3
# ╠═a449b683-cb99-4791-92ba-bc39ebc286a1
# ╠═9ededb91-9731-4d06-9977-399a13461d7d
# ╠═422509fc-33bb-481d-bb46-4607ad00a0de
# ╠═73e7b715-09b3-4902-908c-656102c19a84
# ╠═87dec94d-c994-488e-a8d2-37a151d512f7
# ╠═34623e1f-e782-42c6-ba99-60b996f8c7f4
# ╟─072eb694-9cca-463d-9cbe-bdc06fd33d70
# ╠═5869257d-dcd5-4cf9-a029-52afe752fb65
# ╠═5aaa9fc2-048e-4b31-93e9-feeb343f665d
# ╠═de816416-9b07-4176-9d5b-338bae10bc0d
# ╠═6432f188-2e31-4a5f-9a8b-9260106c61ee
# ╠═0bb8357a-112f-43e4-899e-9ff252d269a9
# ╠═3c4560bf-2837-4dc2-8371-f18202c93a23
# ╠═1ce2a07c-f99a-44a1-b88b-cd70c38eef53
# ╠═e82ee24b-d905-4042-ab15-1348f6c9332a
# ╠═e8791e7b-e578-4096-88d3-c206c664cc60
# ╠═d90d3c81-5d6a-4ff9-856c-a6be88a30668
# ╠═81196b9d-3e55-4934-87d7-fe2a02a7868a
# ╠═535434c9-b28b-4f69-81ec-5b55f025febd
# ╠═ce1e2507-9cbd-458f-ad60-fc9e4d2cbc7f
# ╠═cc533c22-6845-45c3-b706-cda13f7cfbd1
# ╠═9b3f7b70-d151-4d81-b026-1e5d0cbe3110
# ╠═3b4110c5-3e54-4c5f-8d16-603d627a21de
# ╠═5ae4f78b-6388-4d9c-9f93-ee714d2c9d67
# ╠═23036e80-430d-4d43-a26d-ad06b43a8e95
# ╠═74731df8-fdb6-4bbc-a384-081117c2e9b6
# ╠═b50d9d51-7fb9-438a-beb0-a730dec2e5de
# ╠═23bc9d98-0716-428a-bfd1-8f9dcf992a29
# ╠═736f13f9-f0d8-4a77-938b-9f184c1bc6f6
# ╟─2524cf60-fb90-4eca-99ab-ca73816fde82
# ╟─970ed801-7c4e-4d8b-b24f-b954a8e7f02a
# ╟─9d11406c-6777-4e75-81ec-49544014f2a9
# ╠═8d3bd44c-a065-4c58-b475-b0261b7f7f71
# ╠═799bd826-4a3a-41a8-abe4-fc02f81e3e0b
# ╠═6dbcadbb-12cb-464a-a248-bd761d0c6aae
# ╠═69695e61-ae4e-4bbf-beac-f9de6830c91c
# ╠═89bbd3ed-9bf1-47bb-bc96-06017635ceb8
# ╠═3335eaec-669e-46a0-975f-49c61418d491
# ╠═41303df3-689d-4194-95aa-ac1d3f4b045b
# ╠═b29100e7-1ce2-4f2e-b031-efb172a722a3
# ╠═6abe7ba2-eb7c-43b4-a3ad-1a5db8d01b77
# ╠═69a854b9-15db-458f-bae7-051883b52714
# ╠═99c9ef5a-e169-41b3-b33a-db97c4453b95
# ╠═7ce887c0-7309-4da6-ac99-2c3cdf05af42
# ╟─81336351-e171-4a5f-b3e5-fdc920134a6c
# ╠═77bfbb6f-715e-47d1-8ac6-355541f1fd99
# ╠═6d66c9ed-c2bf-483a-a17f-9b9012a8e6f6
# ╠═d6a7f7a4-58c8-4e3b-b303-c629226f353f
# ╠═b2c42ace-2a60-4cab-be02-d5f27d0fa05f
# ╠═217f5ed0-1d11-486f-992c-4ca8246bfd8e
# ╠═91461427-2389-4a82-828f-3b1e970e61f3
# ╠═ff4ff398-18ea-4fb2-8a01-85e7a73bdd9d
# ╠═6c625f30-4244-4980-8615-8c11faa62102
# ╠═bed00389-ccad-4b48-957b-570b36d6acb6
# ╠═babf00d0-0fa8-449e-90d2-e9754e756e33
# ╠═f3c7b316-b68b-4df2-bf90-8ed0de15a27b
# ╠═72926649-b487-480d-a811-3cdcd4801881
# ╠═21abbedd-0320-4071-a102-0ebe7d7d5873
# ╠═e1239c7c-2fd1-4281-a452-fa3b0dfca253
# ╠═460aad5d-3fa9-4f11-b05e-7f9d6775d3a7
# ╠═8e0ea6fb-092d-4500-8e6e-3b4ef6f1dd95
# ╟─b0076f41-dc5b-453f-aaed-f89a10e9d357
# ╠═2cc5aa62-86d3-4352-a0e6-752d0b0dc495
# ╠═4c487700-fe59-4380-b146-05ed7926ecf6
# ╠═f783e6bb-8845-4004-a170-d60bbbae3dbe
# ╠═1f2437e0-7c48-4d0e-a7a6-baf09312989a
# ╠═eeccf709-d477-4590-9457-4b787bc47309
# ╠═7822ee07-6e0d-4482-a209-5f0070ed1191
# ╠═1dcc794b-6168-43e9-b242-7432b77ac4f7
# ╟─c898f559-6acd-4a6d-9876-4672f7ee3780
# ╟─1e4ee91e-d7d4-4ead-ba91-fa755d054126
# ╟─d6236f84-e645-4c30-9fd2-51e60ff59d0f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
