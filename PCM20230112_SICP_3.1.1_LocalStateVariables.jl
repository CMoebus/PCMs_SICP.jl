### A Pluto.jl notebook ###
# v1.0.3

using Markdown
using InteractiveUtils

# ╔═╡ d8bafe14-c726-4177-8560-e173c02bb273
begin
	#---------------------------------------------------------------------
	using Pluto
	#---------------------------------------------------------------------
	println("pkgversion(Pluto)         = ", pkgversion(Pluto))
	#---------------------------------------------------------------------
end # begin

# ╔═╡ f1154a90-c49d-11f1-be18-13da6a92eb8d
md"
====================================================================================
#### SICP: [3.1.1\_Local\_State\_Variables](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-19.html#%_chap_3)
##### file: PCM20230112\_SICP\_3.1.1\_LocalStateVariables.jl
##### Julia/Pluto.jl-code (1.13.1/1.0.3) by PCM *** 2026/10/10 ***

====================================================================================

"

# ╔═╡ da2c6c43-eb1c-4cda-aee2-a1eca66c424f
md"
##### 0. Introduction
---
*One powerful design strategy, which is particularly appropriate to the construction of programs for modeling physical systems, is to base the structure of our programs on the structure of the system being modeled.*

*For each object in the system, we construct a corresponding computational object. For each system action, we define a symbolic operation in our computational model.* 

*Our hope in using this strategy is that extending the model to accommodate new objects or new actions will require no strategic changes to the program, only the addition of the new symbolic analogs of those objects or actions.*

*If we have been successful in our system organization, then to add a new feature or debug an old one we will have to work on only a localized part of the system.* 

*...we will investigate two prominent organizational strategies arising from two rather different 'world views' of the structure of systems.*

*The first organizational strategy concentrates on objects, viewing a large system as a collection of distinct objects whose behaviors may change over time.*

*An alternative organizational strategy concentrates on the streams of information that flow in the system, much as an electrical engineer views a signal-processing system.*(SICP, 1996, 2/e, ch.3)
"

# ╔═╡ b3702414-96e2-4cc6-a36d-46e046c0a04f
md"
---
##### 1. Topics
- *state* variable and computation *history*
- *global* vs. *local* state variable
- *higher-order* function and *message passing* with *dispatch* functions
- *closure* = *anonymous function with free variable* + *surrounding environment*
- *Object factory* with *class-like* function
- *class-like* and *object-like* functions
- (*mutable*) $struct$s
- *outer* and *inner* constructors

"

# ╔═╡ d15211a2-93a9-4b67-9b90-de7d5e0c9807
md"
---
##### 2. Packages
"

# ╔═╡ 8ddec157-40e0-483a-bd84-2900d68a0d79
md"
---
##### 3. Code
---
##### 3.1 SICP-Scheme-like Julia

###### Assignment and Local State
*We ordinarily view the world as populated by independent objects, each of which has a state that changes over time. An object is said to 'have state' if its behavior is influenced by its history.* 

*In a system composed of many objects, the objects are rarely completely independent. Each may influence the states of others through interactions, which serve to couple the state variables of one object to those of other objects. Indeed, the view that a system is composed of separate objects is most useful when the state variables of the system can be grouped into closely coupled subsystems that are only loosely coupled to other subsystems.*

*To illustrate what we mean by having a computational object with time-
varying state, let us model the situation of withdrawing money from a
bank account.* (SICP, 1996, 2/e, ch.3)
"

# ╔═╡ 45bf04de-6178-4308-a3af-10a48b393295
md"
###### Accessing global variables with $global$
Pluto enforces the combination of the two definitions (*variable* $balance$ and the *function* $withdraw$) into one $begin...end$ block.
"

# ╔═╡ 13f4fc16-975c-402e-b7cf-003f4c3fd6b1
begin
	balance = 100
	#-----------------------------------------------------------------------------
	function withdraw(amount)
		global balance                 # refers to outer scope variable 'balance'
		if balance >= amount 
			balance = balance - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#-----------------------------------------------------------------------------
end # begin 

# ╔═╡ 5b58e5dd-a676-4749-bc84-8b7d5383de23
balance

# ╔═╡ 581ec94c-501a-420e-99a4-56d224b96ad2
withdraw(25)                       # 100 - 25 ==> 75 --> :)

# ╔═╡ abf554a6-3649-459a-b36c-2b087cb537aa
withdraw(25)                       #  75 - 25 ==> 50 --> :)

# ╔═╡ ce7df014-6db2-4183-9646-2497663c51aa
withdraw(60)                       #  50 - 60 = -10 ==> "Insufficient Funds"

# ╔═╡ 464adad2-b975-4cc0-ba03-bbd132b33b11
withdraw(15)                       #  50 - 15 ==> 35 --> :)

# ╔═╡ 922b3307-b505-465c-9376-d59db6e0c478
balance                            # *no* encapsulation achieved !   :(

# ╔═╡ 0e149081-e00d-4011-84f9-44ce7716423d
md"
---
###### Making *global* variable $balance$ *local*
*Combining* assignment *with local variables is the general programming technique we will use for constructing computational objects with local state.* (SICP, 1996, 2/e, ch.3)
"

# ╔═╡ dc504b8c-809c-46f2-b728-ca7dc5123842
newWithdraw =                           # value is functional closure
	let balance = 100                   # local environment
		#  ^      
		#  |
		#  +--------------------------- hidden, only visible by 'newWithdraw.balance'
		#
		amount ->                       # closure with nonlocal captured 'balance'
			if balance >= amount 
			#     ^  
			#     |
			#     +--------------------- reference to nonlocal variable 'balance'
			#
				balance = balance - amount 
			else
				"Insufficient Funds"
			end # if
		# this functional closure is returned and bound to variable 'newWithdraw'
	end # let   

# ╔═╡ 8bf16455-fe32-4836-94dd-ce5e808f47fa
newWithdraw              # ... is bound to closure 'let balance ...end'

# ╔═╡ d620a078-3a2b-43fa-aa31-7446eb12db94
newWithdraw(25)          # 100 - 25 ==> 75

# ╔═╡ 8972bbe3-4bfc-44f7-813b-615f256f19c8
newWithdraw(25)          #  75 - 25 ==> 50

# ╔═╡ 383750bd-1a1a-4c0c-ad92-46500717bb48
newWithdraw(60)          #  50 - 60 = -10 ==> "Insufficient Funds"

# ╔═╡ bac77bef-49be-47eb-80c5-6d4f378bb05d
newWithdraw(25)          #  50 - 25 ==> 25

# ╔═╡ e88da5db-90e2-4bb3-8f3b-155ac5823388
balance                  # this is the global variable 'balance', 
                           # in contrast the *local* variable 'balance' has value 25

# ╔═╡ 6d029109-916a-40de-905e-5f6b664fbe3e
newWithdraw.balance      # ==> local variable 'balance' with value 25

# ╔═╡ 7fe15e8c-4f64-4109-ba8a-4291617442b2
md"
---
###### *Object Factory* with *Class-like* Function 
(= closure with local captured $balance$)
"

# ╔═╡ 4d630e60-9126-4ee0-9a18-07ccaaa0b377
function makeWithdraw(balance)
	                 #   ^
	                 #   |
	                 #   +----------- hidden, not observable
	                 #
	#----------------------------------------------------------------------
	amount ->                 #  closure with parameter 'amount' ...
		if balance >= amount  #  ... and free 'balance'
		#    ^                                   
		#    |                                   
		#    +------------------------------- ... nonlocal captured 'balance'
		#
			balance = balance - amount 
		else
			"Insufficient Funds"
		end # if
	#---------------------------------------------------------------------
	# this closure is returned and bound to variable 'makeWithdraw'
end # function makeWithdraw  

# ╔═╡ e932a242-d252-49d9-9e4a-72c7b6b523fe
makeWithdraw                              # ... is bound to closure 'amount -> ...'

# ╔═╡ 947ba50f-6f91-44a8-9e22-2d223caa9d88
md"
---
###### Initialisation of Class = Closure (= *local* environment + *lambda* function)
"

# ╔═╡ 948c3b7b-65cc-446d-a6a3-2e9ee4735c4f
# ... is the closure 'amount -> ...' with balance => 100
makeWithdraw(100)   

# ╔═╡ 91fac18b-ba63-4815-8d61-c3a12fd3fe18
try
	makeWithdraw.balance                  # hidden, not observable
catch error
	println("no field `balance`: $error")
end # try

# ╔═╡ 4008d000-6325-4437-8c0a-ecd0da2b682c
md"
###### Creation of Objects or Instances
*Observe that W1 and W2 are completely independent objects, each with its own local state variable balance. Withdrawals from one do not affect the other.* (SICP, 1996, 2/e, ch.3)
"

# ╔═╡ ae36b76f-5eb0-4492-9e66-58e0f5bb7e3c
# w1 ... is bound to closure 'amount -> ...' with balance => 100
w1 = makeWithdraw(100)   

# ╔═╡ 28c9a051-7c91-4cfc-a9aa-8bc076d7f86f
# w2 ... is bound to closure 'amount -> ...' with balance => 100
w2 = makeWithdraw(100)     

# ╔═╡ bcddc6bb-d51a-46af-a1ca-59adb42421a7
w1        # ... is bound to closure 'amount -> ...' with parameter 'balance => 100'

# ╔═╡ 4aeac98c-465e-4532-8a09-ff0e6ac5a1ef
w2        # ... is bound to closure 'amount -> ...' with parameter 'balance => 100'

# ╔═╡ cd82f43c-6574-4970-b68d-e6f8c25a56a7
w1(50)                         # 100 - 50 ==> 50 --> :)

# ╔═╡ 8f6e657e-2042-4478-9fa9-7fa21023e007
w2(70)                         # 100 - 70 ==> 30 --> :)

# ╔═╡ 629291db-b08b-4e1a-a1df-843328463b4a
balance                        # encapsulation achieved ! local balance is hidden :) 

# ╔═╡ 64233389-ab92-4a0a-ac17-e83bc41196f5
w1.balance                     # w1.balance ==> 50 -->) local balance can be seen :(

# ╔═╡ bc8aa013-219c-44d5-a6dc-4c5f8bf88c9d
typeof(w1)

# ╔═╡ 5ff8b1b1-f13a-4f19-9b88-269dbcc37d4b
propertynames(w1)

# ╔═╡ b6474ffe-152a-4903-a174-4407c9fda1bb
w2.balance                     # w2.balance ==> 30 -->) local balance can be seen :(

# ╔═╡ 811c7780-4caa-4734-a3f8-900e6f0d57e5
propertynames(w2)

# ╔═╡ b7983f84-6063-49eb-9e67-b365f1c343e2
md"
---
##### *Object factory* (constructor function) for *closure-based object* in *message-passing* style

*We can also create objects that handle deposits as well as withdrawals, and thus we can represent simple bank accounts. Here is a procedure that returns a 'bank-account object' with a specified initial balance* (SICP, 1996, 2/e, ch.3). 

We can further describe this code as 

- *Object factory*: Each call to `makeAccount(100)` creates an independent instance with its own encapsulated state (`balance`). This is precisely the role of a factory

- *Class-like function*: This makes sense in a functional context: `makeAccount` takes on the role of a *class* (template plus constructor), and `dispatch` is the value of 'instance'. It is *not* a class in the *strict* sense (type, inheritance, `isa`). `typeof(<instance>)` returns only a function type that says nothing about the 'account'-instance

"

# ╔═╡ d93a0c28-bb1e-4be0-94c2-6ad3e0d61ab9
function makeAccount(balance)             # higher-order class-like function 
	#                   ^
	#                   |
	#                   +---------- parameter is local and *not* outside observable 
	#
	#--------------------------------------------------------------
	function withdraw(amount)
		if balance >= amount
			balance = balance - amount
		else
			 "Insufficient funds"
		end # if
	end # function withdraw
	#---------------------------------------------------------------
	function deposit(amount)
		balance = balance + amount
	end # function deposit
	#---------------------------------------------------------------
	function show()
		balance
	end # function show
	#---------------------------------------------------------------
	function dispatch(message)        # closure 'dispatch'
		if message == "withdraw"
			withdraw                  # free variable in 'dispatch'
		elseif message == "deposit" 
			deposit                   # free variable in 'dispatch'
		elseif message == "show"
			show()                    # free variable in 'dispatch'
		else
			"Unknown request -- makeAccount $message"
		end # if
	end # function dispatch
	#----------------------------------------------------------------------------
	dispatch                          # closure 'dispatch' is the value returned
end # function makeAccount

# ╔═╡ d6f6ee88-d61c-4b2d-8259-290083713cc9
# ... is bound to closure 'message -> ...' with free variable 'balance' ==> 100
makeAccount(100)                           # ==> closure dispatch --> :)

# ╔═╡ b0df71d1-153a-4e95-9ade-7ba36d566747
makeAccount(100)("show")                   # ==> 100 --> :)

# ╔═╡ 5e87516f-3aed-479a-9fa9-b4d75efca730
# ... is bound to closure 'message -> ...' with free variable 'balance' ==> 100
acc06 = makeAccount(100)                   # make new account object 'acc06'

# ╔═╡ 7395ad72-c782-4e3c-8f75-436916f8d061
typeof(acc06)

# ╔═╡ 0a244e62-9442-4ea8-bd3b-a14094efb14a
balance                                    # ==> local balance is hidden --> :)

# ╔═╡ a7215062-957f-4977-b7a8-0c049d272c44
try
	acc06.balance                          # hidden, not observable
catch error
	println("no field `balance`: $error")
end # try

# ╔═╡ b7264327-5277-44f5-a88a-873b20d06141
acc06("deposit")(150)                      # ==> 250 --> :)

# ╔═╡ 9ba476d6-94d8-4cf4-9c96-6b0403965fea
acc06("show")                              # ==> 250 --> :)

# ╔═╡ 4a2b731b-1e2f-4438-b826-ae56aa973942
acc06("getBalance")                        # ==> unknown message "getBalance" --> :)

# ╔═╡ fd11fc93-96a4-433d-821a-45f3b3214652
# ... is bound to closure 'message -> ...' with free variable 'balance' ==> 200
acc07 = makeAccount(200)                   # make new account object 'acc07'

# ╔═╡ b6002485-0d60-47f5-a959-e5d64692c36a
try
	acc07.balance                          # hidden, not observable
catch error
	println("no field `balance`: $error")
end # try

# ╔═╡ 3924a37f-97cd-4219-9db0-bde2171b51ca
acc06("withdraw")(350)                     # ==> "Insufficient funds" --> :)

# ╔═╡ b1461218-97db-46fc-a3f9-84bfc68675d9
acc07("withdraw")(180)                     # ==> 20 --> :)

# ╔═╡ 26defc87-eedb-4681-8c6a-e0313e48d5e9
acc07("show")                              # ==> 20 --> :)

# ╔═╡ a5f361f2-7494-4e0b-b125-368f99599758
acc07("getBalance")                        # ==> unknown message "getBalance" --> :)

# ╔═╡ 2c24d81f-812b-4f88-b424-64a028074629
function makeAccount2(balance)             # higher-order function 'makeAccount2'
	#                   ^
	#                   |
	#                   +------------------- parameter is local and hidden outside
	#
	#---------------------------------------------------------------------
	function withdraw!(amount)
		if balance >= amount  
			balance -= amount
		else
			"Insufficient Funds"
		end # if
	end # function withdraw!
	#-------------------------------------------------
	function deposit!(amount)
		balance +=  amount 
	end # function deposit!
	#-------------------------------------------------
	function show()
		balance
	end # function show
	#-------------------------------------------------------------------------------
	function dispatch(message)                 # closure 'dispatch'
		#--------------------------------------------------------------------
		message == :withdraw! ? withdraw! :    # free variable in 'dispatch'
		#--------------------------------------------------------------------
		message == :deposit! ? deposit! :      # free variable in 'dispatch'
		#--------------------------------------------------------------------
		message == :show ? show() :            # free variable in 'dispatch'
		#--------------------------------------------------------------------
		"Unknown request -- makeAccount $message"
		#--------------------------------------------------------------------
	end # closure dispatch
	#-------------------------------------------------------------------------------
	dispatch                                  # functional return value 'dispatch'
end # function makeAccount2       

# ╔═╡ 7832c0c1-7ef5-487b-9bcf-bdd978f91b4b
# ... is bound to closure 'message -> ...' with free variable 'balance' ==> 100
makeAccount2(100)                             # ==> closure 'dispatch' --> :)

# ╔═╡ dd28ebec-6792-4fec-961b-77099a146cc8
# ... is bound to closure 'message -> ...' with free variable 'balance' ==> 100
acc08 = makeAccount2(100)                     # make new account 'acc08'

# ╔═╡ 07ede056-382f-45c8-889d-5620c9ed245f
try
	acc08.balance                          # hidden, not observable
catch error
	println("no field `balance`: $error")
end # try

# ╔═╡ 4b8ad88b-24b4-48cf-9028-217b1fe11100
acc08(:deposit!)(150)               # ==> :deposit! ==> 250 --> :)

# ╔═╡ 758990a8-69a4-4602-8eac-35fdb4c92767
acc08(:withdraw!)(100)              # ==> :withdraw! ==> 150 --> :)

# ╔═╡ 999c69c1-1fa1-4a98-9a68-67de634996ce
acc08(:show)                        # ==> 150 --> :)

# ╔═╡ 4e171e62-c2dd-4b74-b523-050272b5f177
acc08(:getBalance)          # ==> "Unknown request -- makeAccount getBalance" --> :)

# ╔═╡ 31c21e86-fc10-4947-b095-0c8cad6957b1
md"
---
#### 3.2 Idiomatic Julia
##### 3.2.1 *Recommended* Julia with *Types* and *Multiple-dispatch Functions*
This simple approach is typical *Julian* and recommended by its creators, but as will be demonstrated *encapsulation* of object's field $balance$ *cannot* be achieved. So other propsals have to be followed.
"

# ╔═╡ 869e4571-50ba-4702-bc72-d3ee6c08da7c
begin 
	#---------------------------------------------------------------
	mutable struct Account
		balance::Number                # should be a private field
	end # mutable struct Account
	#---------------------------------------------------------------
	function show(self)
		self.balance
	end # function getBalance
	#-------------------------------------------------
	function withdraw!(self, amount)
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
	#---------------------------------------------------------------
end # begin 


# ╔═╡ 4aad68f3-54da-4ae0-99c7-74e8a06826b3
acc1946 = Account(400)             # ==> object 'acc1946' --> :)

# ╔═╡ 33d02804-571a-4cf5-8511-af608c130f06
acc1947 = Account(300)             # ==> object 'acc1947' --> :)

# ╔═╡ 15fd776f-9570-45e7-9486-0d2624563835
show(acc1946)                      # ==> 400 --> :)

# ╔═╡ 1ac226e6-d5c3-4f74-9058-5dbd27b9e485
show(acc1947)                      # ==> 300 --> :)

# ╔═╡ d306d21c-7110-4515-a685-bec65f517a70
withdraw!(acc1946, 25)             # ==> 375 --> :)

# ╔═╡ 8c47aaae-c4a6-476f-9219-ba7ba6c43bd2
withdraw!(acc1947, 25)             # ==> 275 --> :)

# ╔═╡ 5dda4594-9ef5-4e6a-aeb9-2340262ce1cd
deposit!(acc1946, 125)             # ==> 500 --> :)

# ╔═╡ 84d1fd85-0116-451f-b64b-149e02ab8c4c
deposit!(acc1947, 125)             # ==> 400 --> :)

# ╔═╡ c3865dec-afc9-489b-8caf-55e874713600
acc1946.balance                    #  no encapsulation achieved !   :(

# ╔═╡ 1a1550b2-32b0-4684-940f-4c63effa33cc
acc1947.balance                    #  no encapsulation achieved !   :(

# ╔═╡ 13225636-6618-4ba0-af71-c8e627c96280
md"
---
##### 3.2.2  *Mutable* Types, *Object Factories*, and *Callable Objects* with Type *Methods*
"

# ╔═╡ 3db4d8f9-db34-4a8e-bafe-224bb32b7e27
begin
	abstract type Transaction end 
	#---------------------------------------------------
	struct Withdraw! <: Transaction amount::Float64 end 
	struct Deposit! <: Transaction amount::Float64 end 
	struct Show <: Transaction end 
end # begin

# ╔═╡ 01554bac-8d54-4426-8868-908980e68507
begin
	#--------------------------------------------
	mutable struct MyAccount
		owner::String
		balance::Float64
	end # mutable struct MyAccount
	#--------------------------------------------
	function (self::MyAccount)(op::Withdraw!) 
		if op.amount <= self.balance
			self.balance -= op.amount 
	    	self.balance
		else
			"Insufficient Funds"
		end # if
	end # function
	#--------------------------------------------
	function (self::MyAccount)(op::Deposit!) 
		self.balance += op.amount 
	    self.balance
	end # function
	#--------------------------------------------
	function (self::MyAccount)(op::Show)
		self.balance
	end # function
	#--------------------------------------------
	function (self::MyAccount)(op::Any)
		"Unknown request -- makeAccount $message"
	end # function
	#--------------------------------------------
end # begin

# ╔═╡ 0d71e2cf-919d-4dcd-9de9-ec1d67297dbc
accoun1704 = MyAccount("Claus", 100.0)

# ╔═╡ f674ad09-d5d1-43d3-ad05-70745a769650
accoun1704(Show())

# ╔═╡ e336e1ac-f7cf-4752-afdc-55a76aac366e
accoun1704.balance                       # ==> *not* hidden, but observable --> :(

# ╔═╡ 3d9d79e8-3134-464c-b290-5ed98bbd5810
accoun1704(Withdraw!(25))                # ==> 75 --> :)

# ╔═╡ ca8c9491-b005-4393-8b9e-5cb45e532d40
accoun1704(Withdraw!(125))               # ==> "Insufficient Funds" --> :)

# ╔═╡ 61ff102c-5a38-411c-8e5f-cc0c867969c7
accoun1705 = MyAccount("Alena", 150.0)   # ==> MyAccount("Alena", 150.0) --> :)

# ╔═╡ f6ff2386-3c55-44fd-9cc6-d71136074e02
accoun1705(Show())                       # ==> 150 --> :)

# ╔═╡ b217b35f-56e3-40f4-8c7b-2911a188c2a6
accoun1705(Deposit!(50))                 # ==> 200 --> :)

# ╔═╡ 85561630-fffe-42ee-a0eb-31d0e671b750
md"
---
##### 3.2.3 [*Encapsulation*](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) with Types and Constructors

Under what circumstances is it possible to achieve *encapsulation* despite the fact we have *no* keywords $private$ or $public$ ?

To emphasis the necessity and issue of *encapsulation* of software written in Julia [Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) quotes [Kwong, 2020, ch.8, p.315](https://subscription.packtpub.com/book/programming/9781838648817/11) : 
*Based on the Principle of Least Privilege (POLP), we would consider hiding unnecessary implementation details to the client of the interface. However, Julia's data structure is transparent – all fields are automatically exposed and accessible. This poses a potential problem because any improper usage or mutation can break the system. Additionally, by accessing the fields directly, the code becomes more tightly coupled with the underlying implementation of an object.*

We can demonstrate that in some circumstances it is possible to skim off information from object's fields if their names are known or could be guessed. So explicit *countermeasures* have to be taken. In several blogs *encapsulation* in Julia is a central topic (s.a. *references*, below).
"

# ╔═╡ 4259e000-303f-441b-8418-dfd326cdc987
md"
---
###### [Cox' *Closure* Trick](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/)
...*There is again a creative option with closures to make it even harder to access the properties, similar to the previous section. You initialize a type with functions as properties. Basically you combine functions (everything private) with types (everything public).* [Cox](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/)

Where is the *closure* in Cox' code ? Strictly speaking, only $area()$ is the closure. $Rectangle(width, height)$ is an ordinary function that creates the *closure*.
"

# ╔═╡ e51c0b34-8848-4b1b-8ea3-19c966394a5a
begin
	#--------------------------------------------------------------------------------
	# private type '_Rectangle' (Cox. "the private stuff")
	struct _Rectangle
		_width::Number          # private object ("instance") field, modified
		_height::Number         # private object ("instance") field, modified
		# inner default constructor (is redundant, can be deleted)
		_Rectangle(_width, _height) = new(_width, _height) # default constructor
	end # struct _Rectangle 
	#------------------------------------------------------------------------------
	# the public stuff
	struct Rectangle
	  	area::Function
	end # struct Rectangle
	#------------------------------------------------------------------------------
	# the closure trick: closure 'area()' uses *nonlocal, private* fields of obj '
	function Rectangle(width::Float64, height::Float64)
		  _self = _Rectangle(width, height)
		  area() = _self._width * _self._height       # 'width' modified to '_width'
		#  ^          ^             ^
		#  |          |             |
		#  |          +-------------+----------------nonlocal variables
		#  |
		#  +------------------------------ closure 'area()' with nonlocal 'self._xy'
		#
		  Rectangle(area)             # generation of *public* struct type 'Rectangle'
		#   ^      ^
		#   |      |
		#   |      +------------------ functional argument
		#   +------------------------- *public* struct 'Rectangle' is returned
		#
	end # function Rectangle
	#--------------------------------------------------------------------------------
end # begin

# ╔═╡ d7aefb46-7f49-4d1b-bfa9-e96b770bd04d
# it works!
myRect45 = Rectangle(4.0, 5.0) # ==> returns public struct 'Rectangle'... 
#              ^                      ... with public field 'area'
#              |
#              +--------------------------- call of function 'Rectangle'
#        

# ╔═╡ 9e9d8426-4c22-43fc-830d-c6f40aa84dc7
myRect45.area()                          # ==> 20 --> :)
#          ^
#          |
#          +------------------------------ call of area function in area field
#

# ╔═╡ 13f25096-6c46-40c5-8ec1-dca2198af7bb
try
	myRect45._width                    # ==> encapsulation ! --> :)
catch error
	println("encapsulation achieved !: $error")
end # try

# ╔═╡ 3f713281-5123-4911-b6df-af4253b5b14d
try
	myRect45._height                    # ==> encapsulation ! --> :)
catch error
	println("encapsulation achieved !: $error")
end # try

# ╔═╡ 980ad293-f8a8-4b72-9217-1021eaed6b2c
Rectangle(() -> 42)         # ==> accepts nonsense, not hardened --> :(

# ╔═╡ ffe2c56c-4939-44ea-afa8-28436345bdf1
md"
---
##### Our *Modification* of [Cox's '*closure trick*'](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/): the *Two-Struct-Factory*

Cox provides as a prototypical implementation an *OO-computation* of the *area* of rectangular *objects*. The idea is to *distribute* the generation of *instances* with *private* and *public* fields containing *class methods* over *private* types, *public* types, and a function *closure*.

We *modified* his code proposal slightly. We took his $function\;Rectangle$ (which generates the '*closure*') and put it as an *inner constructor* within the $struct\;Rectangle$. So the role of his '*closure trick*' is moved into and modified to an *inner constructor*.
"

# ╔═╡ a1ccdb55-c54d-4a56-83dd-d3a0f9b12520
md"
###### The *Two-Struct-Factory*: *Public* and *Private* Fields in Types and *Inner* respectively *Outer* Constructors
"

# ╔═╡ 5f39b79a-7974-47ba-89ae-3f0f9c5add11
begin
    #--------------------------------------------------------------------------------
    # private type '_MyRectangle' (Cox. "the private stuff")
    struct _MyRectangle{T <: Real}
          _width::T               # private object ("instance") field
          _height::T              # private object ("instance") field
    end # struct _MyRectangle 
    #--------------------------------------------------------------------------------
    # public type 'MyRectangle' (Cox: "the public stuff")
    struct MyRectangle{F <: Function}
        area::F                   # public object ("instance") field
        #--------------------------------------------------------------------------
        # *inner* constructor 'MyRectangle(width, height)' takes the role 
        #   of a class factory
        function MyRectangle(width::Real, height::Real)
            (width > 0 && height > 0) || throw(ArgumentError("side lengths must be > 0"))
            # generation of private object '_self' ==> '_MyRectangle'
              _self = _MyRectangle(promote(width, height)...) # instance '_self'
            # definition public nullary function 'area'
             area() = _self._width * _self._height   # 'area' is closure
            #----------------------------------------------------------------------
            # return of object with type 'MyRectangle' with public field 'area' 
            new{typeof(area)}(area)      # inner constructor of 'MyRectangle(area)'
        end # function MyRectangle  
        #----------------------------------------------------------------------------
    end # struct MyRectangle
    #--------------------------------------------------------------------------------
end # begin

# ╔═╡ 38e76ee2-4b43-48f4-95f4-2549f1a654df
propertynames(_MyRectangle)

# ╔═╡ 57f437cf-9c90-4005-bd8b-9837cece69e3
try 
	MyRectangle(-3, 4.0)
catch error
	println("ArgumentError: side lengths must be > 0: $error")
end # try

# ╔═╡ 8640cfc9-3baa-42d3-857d-6dd6072f99a6
fieldnames(_MyRectangle)

# ╔═╡ 2231d663-3a9b-420e-abad-713b9740922e
try
	_MyRectangle._width || _MyRectangle._height
catch error
	println("encapsulation achieved: $error")
end # try

# ╔═╡ c42160c9-35f3-4f38-9528-939a543df1e7
try
	_self._width || _self._height
catch error
	println("encapsulation achieved: $error")
end # try

# ╔═╡ 2db0ad5e-a366-4c28-bb1b-c223f824b79a
fieldnames(MyRectangle)           # ==> field 'area' is observable --> :)

# ╔═╡ 8e36cf43-12c4-4efa-bdc0-9443207fcb3c
myRect455 = MyRectangle(4.0, 5.0) # gen. of obj. 'rect45' with public field 'area'

# ╔═╡ 81b2677a-50d2-45a0-b3d8-6fa9c023de90
typeof(myRect455)                 # ==> obj. myRect45 is of type 'MyRectangle' --> :)

# ╔═╡ c23db190-d9b7-4cfd-a843-36c25676caed
try
	fieldnames(myRect455)         # ==> *no* public field names observable --> :)
catch error 
	println("*no* publich field names observable : $error")
end # try

# ╔═╡ 219c1b4b-1297-42e4-9923-be1102e55666
propertynames(myRect455)            # ==> only :area observable --> :)

# ╔═╡ 960b5fe6-70f4-4634-abef-e683d49c9270
try 
	myRect455._width || myRect455._height     #  ==> encapsulation achieved ! --> :)
catch error
	println("encapsulation achieved: $error")
end # try

# ╔═╡ 19900645-c156-442d-a870-d2807c3e5ebc
typeof(myRect455.area)               # ==> _MyRectangle --> :)

# ╔═╡ c71e1ad4-9252-4dcd-946f-15fbb17f6a26
myRect455.area                       # ==> closure --> :)

# ╔═╡ 0daee377-af5d-41a8-8ab4-d9dcc7235b3e
myRect455.area()                     # ==> 20.0 --> :)

# ╔═╡ 8f8c477c-b835-45d2-8d2f-b2d0bca4e691
try 
	MyRectangle(() -> 42)            # ==< not accepted --> :)
catch error
	println("MethodError: $error")
end # try

# ╔═╡ 44c35c05-62f3-4fe5-9950-41f0da0f486f
md"""
---
##### Comparison of both *Cox' Closure Trick* with my *Two-Struct-Factory*
This comparison was made by CLaude (2026/10/06):

*Both use the same closure pattern: a private data type, a public type whose only field is area::Function, and a factory constructor that captures the private object in a closure.*

- *closure pattern*: in public function $area()$
- *private data type*: $\_MyRectangle$ with private fields $\_height, \_width$
- *public data type*: $MyRectangle$ with public field $area::Function$
- *factory constructor*: $MyRectangle(width::Real, height::Real)$
- *private object*: $\_self$
- *closure*: $area() = \_self.\_width * \_self.\_height$

---
##### *Your* version is *stronger* in these respects:

**Invariant**: *Your factory is an inner constructor, so the default Rectangle(f::Function) is suppressed and the only way to get a MyRectangle is through the factory (and its validation). In Cox's version, Rectangle(() -> 42) works.*

**Flexibility**: *::Real plus promote accepts Int, Float64, and mixed arguments. Cox's ::Float64 rejects Rectangle(3, 4).*

**Type stability**: *_MyRectangle{T<:Real} has concrete fields, while Cox's Number fields are abstract and slow the closure's arithmetic.*

**Validation**: *You reject negative side lengths. Cox does no checking.*

---
##### Cox's version is stronger in these respects:

*Simplicity: It's shorter, and the separate outer constructor makes the "constructor has the same name as the type" trick easy to see. Yours requires understanding new and the suppressed default constructor.*

**Shared limitations:**

*r.area._self (r.area.self in Cox) still exposes the "private" state, so encapsulation is by convention only.
The area::Function field is abstract, so r.area() is always dynamically dispatched.
New operations require changing the type, unlike with multiple dispatch.*

*Bottom line: Your version is more robust and preserves the invariant. Cox's is a cleaner teaching example. Showing both side by side works well: Cox for the core idea, yours as the hardened version.* (Claude, 2026/10/06)

"""

# ╔═╡ 61e82065-2c4c-4720-ba1f-dc6eba648b3a
md"
---
##### 3.2.4 *Two-Struct-Factory* in the *Bank Account* Problem
"

# ╔═╡ 1c9daa47-da2d-4788-ab48-3853c926c487
struct InsufficientFunds <: Exception
	balance::Rational{Int}
	requested::Rational{Int}
end # struct InsufficientFunds

# ╔═╡ 99268a08-d632-4e6c-bc2e-236a5739029e
Base.showerror(io::IO, e::InsufficientFunds) =
	print(io, "Insufficient funds: balance ", e.balance, ", requested ", e.requested)

# ╔═╡ 8af25f25-2455-487d-8137-ccf65c71cc5b
begin
	#-----------------------------------------------------------------------------
	mutable struct _MyAccount2Struct        # private class
		#---------------------------------------------------------------
		_balance::Rational{BigInt}          # private field; fixed point
		#---------------------------------------------------------------
	end # mutable struct _MyAccount2Struct
	#-----------------------------------------------------------------------------
	struct MyAccount2Struct{G<:Function, W<:Function, D<:Function} # public class
		#---------------------------------------------------------------
		show::G                             # public field 
		withdraw!::W                        # public field 
		deposit!::D                         # public field 
		#---------------------------------------------------------------
		function MyAccount2Struct(balance::Real)     # inner constructor 
			if !(isfinite(balance) && balance >= 0)
				throw(ArgumentError("balance must be finite and >= 0"))
			end
			#-------------------------------------------------------
			# construct private object
			_self  = _MyAccount2Struct(rationalize(Int, balance))  
			#-------------------------------------------------------
			show() = _self._balance   # closure 'show'
			#-------------------------------------------------------
			function withdraw!(amount::Real)       # function withdraw
				(isfinite(amount) && amount > 0) || 
					throw(ArgumentError("amount must be finite and > 0"))
				amountRat = rationalize(Int, amount)
				if _self._balance >= amountRat 
					_self._balance -= amountRat 
				else
					# throw(ArgumentError("Insufficient Funds"))
					throw(InsufficientFunds(_self._balance, amountRat))
				end # if
			end # function withdraw!
			#-------------------------------------------------------
			function deposit!(amount::Real)       # function deposit!
				(isfinite(amount) && amount > 0) || 
					throw(ArgumentError("amount must be finite and > 0"))
				amountRat = rationalize(Int, amount)
				_self._balance += amountRat
			end # function deposit!
			#---------------------------------------------------------------
			new{typeof(show), typeof(withdraw!), typeof(deposit!)}(show, withdraw!, deposit!) # call of inner constructor
			#---------------------------------------------------------------
		end # inner constructor MyAccount2Struct
	end # struct Account
	#-----------------------------------------------------------------------
end # begin 

# ╔═╡ e3002197-f80e-4b66-9e34-a03a556a2834
acc1234 = MyAccount2Struct(300)

# ╔═╡ 7bb11fbb-f96f-455d-b47c-cd9a2ed1d285
acc1234.show()                           # ==> 300//1 --> :)

# ╔═╡ 864d3484-8c8f-4cb8-a809-56f6799c44e7
acc1234.withdraw!(25)                          # ==> 275//1 --> :)

# ╔═╡ 93a42629-be49-4805-b6de-17136a9ba90f
acc1234.deposit!(50)                           # ==> 325//1 --> :)

# ╔═╡ dc6fe084-cc59-4fe6-bd96-ebd15047313e
try 
	acc1234._balance                           #  encapsulation achieved !    :)
catch error
	println("FieldError: type Main.var....PublicAccountClass has no field `_balance`: $error")
end # try

# ╔═╡ 5af883af-edfc-48d1-bc45-02b7bbcf1994
begin
	acc = MyAccount2Struct(100)
	acc.deposit!(0.1)      # 1001//10
	acc.withdraw!(50)      # 951//10
	acc.withdraw!(1000)    # ArgumentError: Insufficient Funds
end 

# ╔═╡ fbd5030c-10db-4c41-bcad-f84ce098a98d
acc09 = MyAccount2Struct(100)

# ╔═╡ 11f72c21-0128-44fe-ae00-413d04274945
acc09.deposit!(0.1)      # 1001//10

# ╔═╡ 6b2a2ea9-d631-4ec7-840e-bdea13cc1116
acc09.withdraw!(50)      # 951//10

# ╔═╡ ba748428-f7f2-4f74-a310-5a8c70625419
acc09.withdraw!(1000)    # ArgumentError: Insufficient Funds

# ╔═╡ 7143de0a-ee0e-44cd-bbf2-778dd9c59e23
acc09.show()

# ╔═╡ 8cb90211-f95c-46d9-94a1-74b3bdb11781
md"
---
#### 4. Summary

In Section 3.1, we transcribed the Scheme code from SICP 3.1 into Julia. In Section 3.2, we rewrote the Julia code to make it more idiomatic. We then introduced [Cox’s code, known as the “Closure Trick”](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/). This code placed particular emphasis on *encapsulation* and *privacy*. I then refactored Cox’s code into my *Two-struct-factory* using two $struct$s and a *method*. In this *factory*, we moved Cox’s method into the second structure as an *inner constructor*. This has several advantages, as a comparison of the two approaches by Claude demonstrates.

"

# ╔═╡ 6def63a9-f9a5-4283-8d58-bff353859dba
md"
---
#### 5. References
- **Abelson, Sussman & Sussman**; [*SICP, Chapter 3: Modularity, Objects, and State*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-19.html#%_chap_3); last visit 2026/09/29; MIT Press, 1996, 2/e;

- **Abelson, Sussman & Sussman**; [*SICP, Chapter 3: Modularity, Objects, and State*](https://web.mit.edu/6.001/6.037/sicp.pdf); last visit 2026/09/29; MIT Press, 1996, 2/e

- **Cox, M.**, *Julia Encapsulation*, [https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/), last visit 2023/01/18

- **Cox, M.**, [*Julia Encapsulation*](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/), last visit 2026/10/04

- **Grignoli, S.**, *What's the difference between closures and traditional classes?*, [https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes](https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes), last visit 2023/01/20

- **Kwong, T.**, *Hands-On Design Patterns and Best Practices with Julia*, 2020, [https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia](https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia)

---
##### Further Reading
- **Christianson, A.**, *ObjectOrientation and Polymorphism in Julia*, [https://github.com/ninjaaron/oo-and-polymorphism-in-julia](https://github.com/ninjaaron/oo-and-polymorphism-in-julia), last visit 2023/01/18
- **Rackauckas, Ch.**, *Type-Dispatch Design: Post Object-Oriented Programming for Julia*, [http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/](http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/), last visit 2023/01/18
- **Rackauckas, Ch.**, *Multiple Dispatch Designs: Duck Typing, Hierarchies and Traits*, [http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns](http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns), last visit 2023/01/18
"

# ╔═╡ 12684cb0-66ef-46d4-bba5-b911ac8e99be
md"
---
##### end of ch. 3.1.1
"

# ╔═╡ 09080bb0-4d2d-4f54-8429-ba528bc35e29
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"

[compat]
Pluto = "~1.0.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.13.1"
manifest_format = "2.1"
project_hash = "202ab280fb495e13070ad767b4894278695b387e"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "bbe1079eecf9c9fbb52765193ad2bae27ae09bc8"
registries = "General"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.10"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "970758a3d591a2a5c2a907c53f2e2f8c1b1d3537"
registries = "General"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.9"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
registries = "General"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

    [deps.Compat.weakdeps]
    Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.5.5+2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "3c9be947934c38475bafe822c6d61aaed17f0738"
registries = "General"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.6.0"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "4358750bb58a3caefd5f37a4a0c5bfdbbf075252"
registries = "General"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.6"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
registries = "General"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
registries = "General"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "4e468f521e1f9f86891cb07186de5df90360a666"
registries = "General"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.12"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "678f8b7cd246ed441d29ca42a99f5f138be2ecac"
registries = "General"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.5"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
registries = "General"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.GracefulPkg]]
deps = ["Compat", "Pkg", "TOML"]
git-tree-sha1 = "a854d6c0e9fb561b88cd20b4ad64f518cb1bfb8d"
registries = "General"
uuid = "828d9ff0-206c-6161-646e-6576656f7244"
version = "2.4.3"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
registries = "General"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
registries = "General"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
registries = "General"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7204148362dafe5fe6a273f855b8ccbe4df8173e"
registries = "General"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.8.0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LRUCache]]
git-tree-sha1 = "5519b95a490ff5fe629c4a7aa3b3dfc9160498b3"
registries = "General"
uuid = "8ac3fa9e-de4c-5943-b1dc-09c6b5f20637"
version = "1.6.2"
weakdeps = ["Serialization"]

    [deps.LRUCache.extensions]
    SerializationExt = ["Serialization"]

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "0f2da712350b020bc3957f269c9caad516383ee0"
registries = "General"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "1.0.0"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "Zstd_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.18.0+1"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "PCRE2_jll", "Zlib_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.1+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl", "OpenSSL_jll", "Zlib_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.104+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
registries = "General"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
registries = "General"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Malt]]
deps = ["Distributed", "Logging", "RelocatableFolders", "Serialization", "Sockets"]
git-tree-sha1 = "c2335b4e291f2422e2be8abf8936ccad58a98992"
registries = "General"
uuid = "36869731-bdee-424d-aa32-cab38c994e3b"
version = "1.4.1"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
registries = "General"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ff69a2b1330bcb730b9ac1ab7dd680176f5896b8"
registries = "General"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2026.8.13"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "f5db02ae992c260e4826fe78c942954b48e1d9c2"
registries = "General"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
registries = "General"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.6+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "94ba93778373a53bfd5a0caaf7d809c445292ff4"
registries = "General"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.46.0+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "Zstd_jll", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.13.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "Downloads", "ExpressionExplorer", "FileWatching", "GracefulPkg", "HTTP", "HypertextLiteral", "InteractiveUtils", "LRUCache", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PlutoDependencyExplorer", "PrecompileSignatures", "PrecompileTools", "REPL", "Random", "RegistryInstances", "RelocatableFolders", "SHA", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "fe7515cf6ddb62e738d924e4ca2dddaa60ff80ba"
registries = "General"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "1.0.3"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "c3e5073a977b1c58b2d55c1ec187c3737e64e6af"
registries = "General"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.2.2"

[[deps.PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
registries = "General"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
registries = "General"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "5005266de4bfe50e53ff44a5cb5c540b6e47a254"
registries = "General"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.6.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["Base64", "Dates", "FileWatching", "InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
registries = "General"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
registries = "General"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "1.0.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
registries = "General"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
registries = "General"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
registries = "General"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a94d9bdda1b7bed0046cea645639ab3f62196fac"
registries = "General"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.14.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
registries = "General"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
registries = "General"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "908fec9df6c5de98548ead82a468c95ccf6cd263"
registries = "General"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.7.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["CompilerSupportLibraries_jll", "Libdl"]
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.67.1+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.8.2+0"

[registries.General]
url = "https://github.com/JuliaRegistries/General.git"
uuid = "23338594-aafe-5451-b93e-139f81909106"
"""

# ╔═╡ Cell order:
# ╟─f1154a90-c49d-11f1-be18-13da6a92eb8d
# ╟─da2c6c43-eb1c-4cda-aee2-a1eca66c424f
# ╟─b3702414-96e2-4cc6-a36d-46e046c0a04f
# ╟─d15211a2-93a9-4b67-9b90-de7d5e0c9807
# ╠═d8bafe14-c726-4177-8560-e173c02bb273
# ╟─8ddec157-40e0-483a-bd84-2900d68a0d79
# ╟─45bf04de-6178-4308-a3af-10a48b393295
# ╠═13f4fc16-975c-402e-b7cf-003f4c3fd6b1
# ╠═5b58e5dd-a676-4749-bc84-8b7d5383de23
# ╠═581ec94c-501a-420e-99a4-56d224b96ad2
# ╠═abf554a6-3649-459a-b36c-2b087cb537aa
# ╠═ce7df014-6db2-4183-9646-2497663c51aa
# ╠═464adad2-b975-4cc0-ba03-bbd132b33b11
# ╠═922b3307-b505-465c-9376-d59db6e0c478
# ╟─0e149081-e00d-4011-84f9-44ce7716423d
# ╠═dc504b8c-809c-46f2-b728-ca7dc5123842
# ╠═8bf16455-fe32-4836-94dd-ce5e808f47fa
# ╠═d620a078-3a2b-43fa-aa31-7446eb12db94
# ╠═8972bbe3-4bfc-44f7-813b-615f256f19c8
# ╠═383750bd-1a1a-4c0c-ad92-46500717bb48
# ╠═bac77bef-49be-47eb-80c5-6d4f378bb05d
# ╠═e88da5db-90e2-4bb3-8f3b-155ac5823388
# ╠═6d029109-916a-40de-905e-5f6b664fbe3e
# ╟─7fe15e8c-4f64-4109-ba8a-4291617442b2
# ╠═4d630e60-9126-4ee0-9a18-07ccaaa0b377
# ╠═e932a242-d252-49d9-9e4a-72c7b6b523fe
# ╟─947ba50f-6f91-44a8-9e22-2d223caa9d88
# ╠═948c3b7b-65cc-446d-a6a3-2e9ee4735c4f
# ╠═91fac18b-ba63-4815-8d61-c3a12fd3fe18
# ╟─4008d000-6325-4437-8c0a-ecd0da2b682c
# ╠═ae36b76f-5eb0-4492-9e66-58e0f5bb7e3c
# ╠═28c9a051-7c91-4cfc-a9aa-8bc076d7f86f
# ╠═bcddc6bb-d51a-46af-a1ca-59adb42421a7
# ╠═4aeac98c-465e-4532-8a09-ff0e6ac5a1ef
# ╠═cd82f43c-6574-4970-b68d-e6f8c25a56a7
# ╠═8f6e657e-2042-4478-9fa9-7fa21023e007
# ╠═629291db-b08b-4e1a-a1df-843328463b4a
# ╠═64233389-ab92-4a0a-ac17-e83bc41196f5
# ╠═bc8aa013-219c-44d5-a6dc-4c5f8bf88c9d
# ╠═5ff8b1b1-f13a-4f19-9b88-269dbcc37d4b
# ╠═b6474ffe-152a-4903-a174-4407c9fda1bb
# ╠═811c7780-4caa-4734-a3f8-900e6f0d57e5
# ╟─b7983f84-6063-49eb-9e67-b365f1c343e2
# ╠═d93a0c28-bb1e-4be0-94c2-6ad3e0d61ab9
# ╠═d6f6ee88-d61c-4b2d-8259-290083713cc9
# ╠═b0df71d1-153a-4e95-9ade-7ba36d566747
# ╠═5e87516f-3aed-479a-9fa9-b4d75efca730
# ╠═7395ad72-c782-4e3c-8f75-436916f8d061
# ╠═0a244e62-9442-4ea8-bd3b-a14094efb14a
# ╠═a7215062-957f-4977-b7a8-0c049d272c44
# ╠═b7264327-5277-44f5-a88a-873b20d06141
# ╠═9ba476d6-94d8-4cf4-9c96-6b0403965fea
# ╠═4a2b731b-1e2f-4438-b826-ae56aa973942
# ╠═fd11fc93-96a4-433d-821a-45f3b3214652
# ╠═b6002485-0d60-47f5-a959-e5d64692c36a
# ╠═3924a37f-97cd-4219-9db0-bde2171b51ca
# ╠═b1461218-97db-46fc-a3f9-84bfc68675d9
# ╠═26defc87-eedb-4681-8c6a-e0313e48d5e9
# ╠═a5f361f2-7494-4e0b-b125-368f99599758
# ╠═2c24d81f-812b-4f88-b424-64a028074629
# ╠═7832c0c1-7ef5-487b-9bcf-bdd978f91b4b
# ╠═dd28ebec-6792-4fec-961b-77099a146cc8
# ╠═07ede056-382f-45c8-889d-5620c9ed245f
# ╠═4b8ad88b-24b4-48cf-9028-217b1fe11100
# ╠═758990a8-69a4-4602-8eac-35fdb4c92767
# ╠═999c69c1-1fa1-4a98-9a68-67de634996ce
# ╠═4e171e62-c2dd-4b74-b523-050272b5f177
# ╟─31c21e86-fc10-4947-b095-0c8cad6957b1
# ╠═869e4571-50ba-4702-bc72-d3ee6c08da7c
# ╠═4aad68f3-54da-4ae0-99c7-74e8a06826b3
# ╠═33d02804-571a-4cf5-8511-af608c130f06
# ╠═15fd776f-9570-45e7-9486-0d2624563835
# ╠═1ac226e6-d5c3-4f74-9058-5dbd27b9e485
# ╠═d306d21c-7110-4515-a685-bec65f517a70
# ╠═8c47aaae-c4a6-476f-9219-ba7ba6c43bd2
# ╠═5dda4594-9ef5-4e6a-aeb9-2340262ce1cd
# ╠═84d1fd85-0116-451f-b64b-149e02ab8c4c
# ╠═c3865dec-afc9-489b-8caf-55e874713600
# ╠═1a1550b2-32b0-4684-940f-4c63effa33cc
# ╟─13225636-6618-4ba0-af71-c8e627c96280
# ╠═3db4d8f9-db34-4a8e-bafe-224bb32b7e27
# ╠═01554bac-8d54-4426-8868-908980e68507
# ╠═0d71e2cf-919d-4dcd-9de9-ec1d67297dbc
# ╠═f674ad09-d5d1-43d3-ad05-70745a769650
# ╠═e336e1ac-f7cf-4752-afdc-55a76aac366e
# ╠═3d9d79e8-3134-464c-b290-5ed98bbd5810
# ╠═ca8c9491-b005-4393-8b9e-5cb45e532d40
# ╠═61ff102c-5a38-411c-8e5f-cc0c867969c7
# ╠═f6ff2386-3c55-44fd-9cc6-d71136074e02
# ╠═b217b35f-56e3-40f4-8c7b-2911a188c2a6
# ╟─85561630-fffe-42ee-a0eb-31d0e671b750
# ╟─4259e000-303f-441b-8418-dfd326cdc987
# ╠═e51c0b34-8848-4b1b-8ea3-19c966394a5a
# ╠═d7aefb46-7f49-4d1b-bfa9-e96b770bd04d
# ╠═9e9d8426-4c22-43fc-830d-c6f40aa84dc7
# ╠═13f25096-6c46-40c5-8ec1-dca2198af7bb
# ╠═3f713281-5123-4911-b6df-af4253b5b14d
# ╠═980ad293-f8a8-4b72-9217-1021eaed6b2c
# ╟─ffe2c56c-4939-44ea-afa8-28436345bdf1
# ╟─a1ccdb55-c54d-4a56-83dd-d3a0f9b12520
# ╠═5f39b79a-7974-47ba-89ae-3f0f9c5add11
# ╠═38e76ee2-4b43-48f4-95f4-2549f1a654df
# ╠═57f437cf-9c90-4005-bd8b-9837cece69e3
# ╠═8640cfc9-3baa-42d3-857d-6dd6072f99a6
# ╠═2231d663-3a9b-420e-abad-713b9740922e
# ╠═c42160c9-35f3-4f38-9528-939a543df1e7
# ╠═2db0ad5e-a366-4c28-bb1b-c223f824b79a
# ╠═8e36cf43-12c4-4efa-bdc0-9443207fcb3c
# ╠═81b2677a-50d2-45a0-b3d8-6fa9c023de90
# ╠═c23db190-d9b7-4cfd-a843-36c25676caed
# ╠═219c1b4b-1297-42e4-9923-be1102e55666
# ╠═960b5fe6-70f4-4634-abef-e683d49c9270
# ╠═19900645-c156-442d-a870-d2807c3e5ebc
# ╠═c71e1ad4-9252-4dcd-946f-15fbb17f6a26
# ╠═0daee377-af5d-41a8-8ab4-d9dcc7235b3e
# ╠═8f8c477c-b835-45d2-8d2f-b2d0bca4e691
# ╟─44c35c05-62f3-4fe5-9950-41f0da0f486f
# ╟─61e82065-2c4c-4720-ba1f-dc6eba648b3a
# ╠═1c9daa47-da2d-4788-ab48-3853c926c487
# ╠═99268a08-d632-4e6c-bc2e-236a5739029e
# ╠═8af25f25-2455-487d-8137-ccf65c71cc5b
# ╠═e3002197-f80e-4b66-9e34-a03a556a2834
# ╠═7bb11fbb-f96f-455d-b47c-cd9a2ed1d285
# ╠═864d3484-8c8f-4cb8-a809-56f6799c44e7
# ╠═93a42629-be49-4805-b6de-17136a9ba90f
# ╠═dc6fe084-cc59-4fe6-bd96-ebd15047313e
# ╠═5af883af-edfc-48d1-bc45-02b7bbcf1994
# ╠═fbd5030c-10db-4c41-bcad-f84ce098a98d
# ╠═11f72c21-0128-44fe-ae00-413d04274945
# ╠═6b2a2ea9-d631-4ec7-840e-bdea13cc1116
# ╠═ba748428-f7f2-4f74-a310-5a8c70625419
# ╠═7143de0a-ee0e-44cd-bbf2-778dd9c59e23
# ╟─8cb90211-f95c-46d9-94a1-74b3bdb11781
# ╟─6def63a9-f9a5-4283-8d58-bff353859dba
# ╟─12684cb0-66ef-46d4-bba5-b911ac8e99be
# ╟─09080bb0-4d2d-4f54-8429-ba528bc35e29
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
