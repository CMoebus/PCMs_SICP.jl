### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ efa311b0-a705-11ed-157c-9d78ec5a5f63
md"
====================================================================================
#### nonSICP: [3.1.4\_Julia\_Classes](https://www.functionalnoise.com/pages/2023-01-31-julia-class/)
##### file: PCM20230206\_nonSICP:\_3.1.4\_JuliaClasses.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.14) by PCM *** 2023/02/09 ***

====================================================================================
"


# ╔═╡ 25eddf6d-fa5c-41bc-ba8c-995b701566aa
md"
##### 3.1.4.1 Julia Classes ([Cox's Proposal](https://www.functionalnoise.com/pages/2023-01-31-julia-class/))
"

# ╔═╡ f51cb7ea-c76c-490f-8d55-79d4bf3e4a08
md"
*This post is for educational purposes only.*

*Someone asked in my [Julia Encapsulation post](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/) how to code a more conventional object-oriented class in Julia. If you ignore class inheritance, then I assume we are talking about a composite type with methods inside that you can call via* $object.method(args...)$ (Cox, 2023).
"

# ╔═╡ 7b6036fc-0244-414a-965b-2094bcfa5f95
md"
*Note that in Julia a [method](https://docs.julialang.org/en/v1/manual/methods/#Methods) is an instance of a function. In this post I might be using the terms a little interchangable, due to my mental confusion with some other OO language terminology of methods vs functions. I will also use [type](https://docs.julialang.org/en/v1/manual/types/#Composite-Types) vs class vs struct definitions interchangeable, but an object is an instance of a type.*
"

# ╔═╡ c7c9354c-e6ba-4761-b313-678e93e23fc2
md"
*Pseudo-code of a Julia type with contained methods would look like:* (Cox, 2023)
"

# ╔═╡ 17ae64f2-1121-4aaa-87b5-7058acfcb94c
mutable struct MyClass
	#-------------------------------------------------
	myInt::Int
	#-------------------------------------------------
  	function print_int(self::MyClass)
    	println("hello, I have myInt: $(self.myInt)")
  	end
	#-------------------------------------------------
  	function set_int!(self::MyClass, new_int::Int)
    	self.myInt = new_int
  	end
	#-------------------------------------------------
  	function MyClass(int::Int)
    	return new(int)
  	end
	#-------------------------------------------------
end

# ╔═╡ a4e6a8c1-19de-4560-8dc3-25cb8c410699
md"
*Which you* (should) *then call via:*
"

# ╔═╡ e3dcf172-b00f-4f66-afc5-351fb52ac29e
obj123 = MyClass(5)

# ╔═╡ 53729d2f-a7ad-4751-adc7-3f04f4517512
obj123

# ╔═╡ dbf2b60f-21ba-4fc4-9023-a73e4f8dbd3a
md"
*The struct definition syntax above is actually possible in Julia, but doesn't do what you want. The inner methods are not available as properties. You will get the following error:* (Cox, 2023)

	julia> obj.set_int!(8)
	ERROR: type MyClass has no field set_int!
"

# ╔═╡ 35c302b2-dd84-4187-98fa-71dcad96e370
obj123.set_int!(8)

# ╔═╡ 02b44c49-ff20-40db-b5df-68f6e5cc65bc
obj123.print_int()

# ╔═╡ d6c98cf1-688f-4161-93dc-72981a2c007b
md"
*I think we have two options available:*

- use immutable fields of type function inside the struct

- define a custom $getproperty$ method that returns functions

*Let's try them both and see how they feel.* (Cox, 2023)
"

# ╔═╡ 8128a06f-c7be-42fb-b364-a289aa6428c7
md"
---
##### 3.1.4.1.1 Functions as fields
"

# ╔═╡ b43a441d-059b-4090-ad31-131f26c9e22e
md"
*Simple solution: we turn the functions into immutable fields and set them in the constructor. Please consider all possible horrors if you accidentally make these fields mutable and the user inserts a custom function into your field.*

*I will place the code inside a module, which is typically how you will share your types anyway. This also shows the one advantage of using the dot syntax to access functions. Now you do not have to export the functions or call them via the module namespace, the type itself carries the functions.*
"

# ╔═╡ 6d01f729-8d17-4b84-8ee9-8f726506758f
module MyModule1
	#------------------------------------------------------------
  	mutable struct MyClass
    	myInt::Int
    	# we have these `const` fields since Julia 1.8
    	const print_int::Function
    	const set_int!::Function
		#--------------------------------------------------------
    	function print_int(self::MyClass)
      		println("hello, I have myInt: $(self.myInt)")
		end # function print_int
		#--------------------------------------------------------
    	function set_int!(self::MyClass, new_int::Int)
      		self.myInt = new_int
      		return self
		end # function set_int!
		#---------------------------------------------------------
    	function MyClass(myInt::Int)         # inner constructor
      		obj = new(                     # self-referential obj
					myInt,
        			() -> print_int(obj),  # self-referential obj
        			# (new_int,) -> set_int!(obj, new_int),)
					new_int -> set_int!(obj, new_int)
					)
      		return obj
		end # function MyClass
		#--------------------------------------------------------
	end # mutable struct MyClass
	#------------------------------------------------------------
end # module MyModule1

# ╔═╡ 1b2a65c7-51f3-49aa-b62f-bb2059dd8bc5
md"
*This code works and the inner functions remain somewhat hidden, you cannot directly access them in the module. You can also move the functions outside the struct definition, and into the module. The result will be similar. The difference is that the functions are no longer hidden, you can access them via* $MyModule.print\_int(obj)$.
"

# ╔═╡ 296dbef1-59ea-4630-888a-e4d363ce7378
obj456 = MyModule1.MyClass(5)

# ╔═╡ 9a61e715-1fbc-49ed-863b-c6e04b85107d
obj456.print_int()

# ╔═╡ 6f85375d-329c-46f5-acdd-1bb6e00fcbfb
obj456.set_int!(8).print_int()   # chain of function calls (!)

# ╔═╡ 8294d277-5db0-4635-a9f1-aa8bcb974be1
md"
*For extra fun I made the set_int! return the mutated object, so we can chain the function calls. This is extremely convential looking OO syntax. I did keep the exclamation mark ! for mutating function names. This is Julia after all.*

*Downside of this field::Function approach is that by default you get a lot of circular references in the REPL display. We can get rid of the circular reference display by defining a custom $Base.show$ function. Here's a straightforward attempt:*
"

# ╔═╡ dc03ac80-3f27-46e0-bc84-03951ba89533
function Base.show(io::IO, obj::MyModule1.MyClass)
  print(io, "$(typeof(obj))($(obj.myInt))")
end

# ╔═╡ 1c405bf5-3f65-4a83-afcd-2975b1794daf
md"
*Now it will display more conventially:*
"

# ╔═╡ f565df01-d89f-4398-819f-f2d67b13bcf9
obj456

# ╔═╡ 568b6d78-2b27-4542-8e71-12bf82a6ef62
md"
---
##### 3.1.4.1.2 Functions as custom properties
"

# ╔═╡ 2f054bed-f7ea-4498-889c-5f0957dbc833
md"
*In this approach we will return functions when calling the $getproperty$ method on our custom type. Note that we need to make the functions available in the module scope, so no hiding of functions.*
"

# ╔═╡ 8751dd83-5d28-472e-abf3-81c47895de38
module MyModule2
	#----------------------------------------------------
  	mutable struct MyClass
    	myInt::Int
	end # mutable struct MyClass
	#----------------------------------------------------
  	function print_int(obj::MyClass)
    	println("hello, I have myInt: $(obj.myInt)")
	end # function print_int
	#----------------------------------------------------
  	function set_int!(obj::MyClass, new_int::Int)
    	obj.myInt = new_int
    	return obj
	end # function set_int!
	#----------------------------------------------------
  	function Base.getproperty(obj::MyClass, prop::Symbol)
    	if prop == :myInt
      		return getfield(obj, prop)
    	elseif prop == :print_int
      		return () -> print_int(obj)
    	elseif prop == :set_int!
      		# return (new_int,) -> set_int!(obj, new_int)
			return new_int -> set_int!(obj, new_int)
    	else
      		throw(UndefVarError(prop))
    	end
	end # function Base.getproperty
	#----------------------------------------------------
end # module MyModule2

# ╔═╡ 8fdb7ea4-3df8-4c45-8f76-7f145a5e6592
md"
*Now you can access the functions again as properties:*
"

# ╔═╡ 25536dda-3cbb-450e-b766-d5e098f54ece
obj789 = MyModule2.MyClass(5)

# ╔═╡ 5080b4ad-b1f8-4df8-b90f-62c9c77a81a5
obj789.set_int!(8)

# ╔═╡ 03161d65-58dc-4056-b86c-50f62091a828
obj789.print_int()

# ╔═╡ bf2d1ca8-ff7e-4005-ab0a-e17d23567a53
propertynames(obj789)   # it is astonishing, that the function names don't appear

# ╔═╡ 7f0bc58b-93e2-4956-81bc-dde79bec5099
md"
---
##### 3.1.4.1.3 Cox's Conclusion 
"

# ╔═╡ e892dcfa-8a77-4cb6-b340-bc843d7dc327
md"
*Either of the options above could be automated away with a macro. Let's call that macro $@class$. I will not meta-program that macro here, but then it could look like the pseudo-code at the start. Everything is possible in Julia if you really want it. Some say that's an advantage, some say that's a disadvantage.*
"

# ╔═╡ 746d826b-d645-482b-a3b0-9234f6e9f2fc
module MyModule3
	@class mutable struct MyClass
    	myInt::Int
    	#-------------------------------------------------
		function print_int(self::MyClass)
      		println("hello, I have myInt: $(self.myInt)")
		end # function print_int
    	#-------------------------------------------------
    	function set_int!(self::MyClass, new_int::Int)
      		self.myInt = new_int
		end # function set_int!
		#-------------------------------------------------
	end # @class mutable struct MyClass
end # module MyModule3

# ╔═╡ 5ddd2b6a-cd56-4995-9e68-1801da0a97f2
md"""
*What is considered OO? The Rust manual section "[What is OO](https://doc.rust-lang.org/book/ch17-01-what-is-oo.html)" states:

- Objects contain data and behavior. Confirmed in this post.

- Encapsulation that Hides Implementation Details. Discussed in a [previous post](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/).

- Inheritance as a Type System and as Code Sharing.

Actually Julia objects already contain behavior via multiple dispatch. All I did was implement the syntactic sugar often provided with class-based object oriented programming languages. This might give you more feeling of belonging.

I did not try to write an implementation for class inheritance. Maybe it can be done with some very complex meta-programming. But like the Rust language, a trait based approach is more suitable for Julia, see for example discussions in [Traits.jl](https://github.com/mauro3/SimpleTraits.jl).

To repeat: I wrote this code for educational purposes only. I would not advise to use such coding patterns in large scale Julia code bases. Please stick to exporting (public) methods and keep the style more Julian. But perhaps this post can help you better understand Julia, especially if you have only been exposed to strictly class-based object oriented programming styles.
"""

# ╔═╡ 9a679957-4ab8-4771-8277-55d10832ed80
md"
---
#### 3.1.4.2 Julia Classes: SICP's Bank Account
"

# ╔═╡ c705512b-5596-41a4-b4b1-7475b63bc236
md"
##### Scheme-like Julian Implementation of SICP's Bank Account (cf. ch.3.1.1)
"

# ╔═╡ b8ea3e20-1b62-4a8d-bd13-c136a98a02df
function makeAccount(balance)
	#----------------------------------------------------
	function withdraw(amount)
		if balance >= amount  
			balance = balance - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#----------------------------------------------------
	function deposit(amount)
		balance = balance + amount 
	end # function deposit
	#----------------------------------------------------
	function getBalance()
		balance
	end # function getBalance
	#----------------------------------------------------
	function dispatch(message)
		#------------------------------------------------
		message == :withdraw ? withdraw :
		#------------------------------------------------
		message == :deposit ? deposit :
		#------------------------------------------------
		message == :getBalance ? getBalance() :
			"Unknown request -- makeAccount $message"
		#------------------------------------------------
	end # function dispatch
	#----------------------------------------------------
	dispatch    # explicit return of function 'dispatch'
end # function makeAccount

# ╔═╡ bf9935c3-3cc1-4429-976f-e19079e969ec
acc06 = makeAccount(100)           # make new account 'acc06'

# ╔═╡ e849961d-6e90-4a52-9163-24d5c6db1568
acc06

# ╔═╡ 022d2242-3812-4989-825c-8901689a9d33
acc06(:withdraw)(50)

# ╔═╡ d26985fd-24fb-405c-b69f-beeae76c8613
acc06(:getBalance)

# ╔═╡ fef69797-778f-4fc4-888f-5970f2910ccb
acc06(:withdraw)(60)

# ╔═╡ 9c98b660-3526-4a31-b599-25b99dc3dda1
acc06(:getBalance)

# ╔═╡ 6e80e5fe-169b-438c-8cd7-930afef0d297
acc06(:deposit)(40)

# ╔═╡ 53b5bef6-acbd-4bfb-a182-762f6b119b69
acc06(:getBalance)

# ╔═╡ 46430ee3-4d23-4676-a69c-4ba3fd2d013c
acc06(:withdraw)(60)

# ╔═╡ a5f1e0ef-900b-4f42-917c-bd45bd6c29ca
acc06(:getBalance)

# ╔═╡ bd69fe33-98ff-4713-bbff-5dba9ca02402
acc06.balance                      #  encapsulation achieved !

# ╔═╡ 0834b447-9f92-4aa6-9429-4647a7a70b6f
acc07 = makeAccount(200)           # make new account 'acc07'

# ╔═╡ 6267db0c-3bf7-4956-8975-fea2c5b63c06
acc07.balance                      #  encapsulation achieved !

# ╔═╡ 7cd2f73e-7d3a-44a2-8ad4-6a4264a21e09
acc07(:getBalance)

# ╔═╡ fd4a5d69-151d-417f-9ed5-d851dec8f77a
md"
---
##### 3.1.4.2.1 Functions as fields (inspired by Cox's proposal)
"

# ╔═╡ afbe11e9-7043-43f4-9817-45da041e48b1
module MyModule4
	#--------------------------------------------------------------------
  	mutable struct MakeAccount        # my Julia-Class
		balance::Float64              # object or instance variab
		const getBalance::Function
		const withdraw::Function
		const deposit!::Function
		#------------------------------------------------------
		getBalance(self::MakeAccount) = return self.balance
		#------------------------------------------------------
		function withdraw(self::MakeAccount, amount::Float64)
			if self.balance >= amount  
				self.balance = self.balance - amount 
			else
				"Insufficient Funds"
			end # if
		end # function withdraw
		#------------------------------------------------------
		function deposit!(self::MakeAccount, amount::Float64)
			self.balance = self.balance + amount 
		end # function deposit!
		#------------------------------------------------------
		function MakeAccount(balance::Float64) 
			self = new(                    # inner constructor
				balance, 
				() -> getBalance(self),
				amount -> withdraw(self, amount),
				amount -> deposit!(self, amount)
				)
		end # function MakeAccount
	end # mutable struct Account
		#------------------------------------------------------
end # module MyModule3

# ╔═╡ 0e9b4260-f23e-4ded-8f99-ec50aad10795
account1704 = MyModule4.MakeAccount(100.00)

# ╔═╡ 916a1677-4202-4427-a575-ebba173bc495
account1705 = MyModule4.MakeAccount(200.00)

# ╔═╡ 728c5f2d-563c-4ff3-a772-83f83ba53064
account1704.balance

# ╔═╡ 73d45041-531f-43bd-a52d-69c4b7819cfa
account1705.balance

# ╔═╡ 125bd566-361f-43fd-a53f-67e873d84292
balance

# ╔═╡ b8e3dbd8-e866-4531-b3a3-1ea91890ea20
account1704.getBalance

# ╔═╡ 7977eec0-994f-4e50-aae5-74c3194e344e
account1704.getBalance()

# ╔═╡ 54a1eafe-decf-4e32-be2b-6082b471239d
account1705.getBalance()

# ╔═╡ 23cf584b-464f-4cc8-b2ba-fcd9432a772a
getBalance()

# ╔═╡ 14a92c6e-1bc0-45f9-97d2-bbe0d9d2d6a5
account1704.withdraw(10.0)

# ╔═╡ d9557038-6ea6-4606-8244-f8f97af4f02b
account1705.withdraw(20.0)

# ╔═╡ 6dd58953-7646-4155-8449-6f00742071e6
account1704.deposit!(50.0)

# ╔═╡ 75a98f62-131b-46e9-8a35-6bd3ebfccfa5
account1705.deposit!(50.0)

# ╔═╡ ea86a431-c875-4268-911e-4f624dfde776
account1704.getBalance()

# ╔═╡ a2b03173-3277-48c7-a98a-b69b2330bef6
account1705.getBalance()

# ╔═╡ 0e9b5e56-fed9-4771-8fb0-897fe050a2a6
md"
---
##### 3.1.4.2.2 Functions as Custom Properties (inspired by Cox's Proposal)
"

# ╔═╡ 1ab8239a-320d-49b5-ae1a-7ca46c69545d
module MyModule5
	#------------------------------------------------------
	mutable struct MakeAccount           # my Julia-Class
    	balance::Float64
	end # mutable struct MakeAccount
	#------------------------------------------------------
	getBalance(self::MakeAccount) = return self.balance
	#------------------------------------------------------
	function withdraw(self::MakeAccount, amount::Float64)
		if self.balance >= amount  
			self.balance = self.balance - amount 
		else
			"Insufficient Funds"
		end # if
	end # function withdraw
	#------------------------------------------------------
	function deposit!(self::MakeAccount, amount::Float64)
		self.balance = self.balance + amount 
		return self.balance
	end # function deposit!
	#------------------------------------------------------
  	function Base.getproperty(self::MakeAccount, prop::Symbol)
    	if prop == :balance
      		return getfield(self, prop)
		elseif prop == :getBalance
			return () -> getBalance(self::MakeAccount)
		elseif prop == :withdraw
      		return () -> withdraw(self::MakeAccount, self.balance::Float64)
		elseif prop == :deposit!
			return amount -> deposit!(self::MakeAccount, amount::Float64)
    	else
      		throw(UndefVarError(prop))
		end # if
	end # function Base.getproperty
	#----------------------------------------------------
end # module MyModule5

# ╔═╡ ffeed149-dfde-4fcb-a28a-d58084283927
account1786 = MyModule5.MakeAccount(100.00)

# ╔═╡ d318533a-e9f3-4420-8f49-ffa1082a2a9b
account1788 = MyModule5.MakeAccount(200.00)

# ╔═╡ 6419287b-7090-430b-80e8-ffde2c37d95d
account1786

# ╔═╡ 55355d9d-a4fa-4b32-b763-01a751b2a8ad
account1786.balance

# ╔═╡ d63c4094-905b-45ad-966a-670a9645eebf
account1788.balance

# ╔═╡ 31d5e8c4-426e-4abd-9fe5-8bd7b5aef101
account1786.getBalance()

# ╔═╡ 185dbce7-2630-4c70-9f05-132540712354
account1788.getBalance()

# ╔═╡ 99974b20-213c-47b3-867e-12443d137ada
account1786.deposit!(60.0)

# ╔═╡ 2771dda4-e36e-46b1-8e48-c8315233c69c
account1788.deposit!(160.0)

# ╔═╡ 9a27c067-ae06-4983-81c9-e5498435d7b9
account1786.getBalance()

# ╔═╡ a166df7c-b59e-4393-b132-d1f3f66d32b0
account1788.getBalance()

# ╔═╡ 5ecc7f91-79e9-4439-ad96-d17e00975aec
md"
---
##### References

- Cox, M., Julia Encapsulation, [https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/](https://www.functionalnoise.com/pages/2021-07-02-julia-encapsulation/), last visit 2023/02/09

- Grignoli, S., What's the difference between closures and traditional classes?, [https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes](https://stackoverflow.com/questions/3368713/whats-the-difference-between-closures-and-traditional-classes), last visit 2023/02/09

- Kwong, T., Hands-On Design Patterns and Best Practices with Julia, 2020, [https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia](https://github.com/PacktPublishing/Hands-on-Design-Patterns-and-Best-Practices-with-Julia), last visit 2023/02/09

##### Further Reading

- Christianson, A., ObjectOrientation and Polymorphism in Julia, [https://github.com/ninjaaron/oo-and-polymorphism-in-julia](https://github.com/ninjaaron/oo-and-polymorphism-in-julia), last visit 2023/02/09

- Rackauckas, Ch., Type-Dispatch Design: Post Object-Oriented Programming for Julia, [http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/](http://www.stochasticlifestyle.com/type-dispatch-design-post-object-oriented-programming-julia/), last visit 2023/02/09

- Rackauckas, Ch., Multiple Dispatch Designs: Duck Typing, Hierarchies and Traits, [http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns](http://ucidatascienceinitiative.github.io/IntroToJulia/Html/DispatchDesigns), last visit 2023/02/09
"

# ╔═╡ 50e2c4ad-e51a-4bc0-b3e8-fdcab61a7be5
md"
---
##### End of ch. 3.1.4
"

# ╔═╡ c4665165-8f33-47f3-b761-272b2fab570d
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
# ╟─efa311b0-a705-11ed-157c-9d78ec5a5f63
# ╟─25eddf6d-fa5c-41bc-ba8c-995b701566aa
# ╟─f51cb7ea-c76c-490f-8d55-79d4bf3e4a08
# ╟─7b6036fc-0244-414a-965b-2094bcfa5f95
# ╟─c7c9354c-e6ba-4761-b313-678e93e23fc2
# ╠═17ae64f2-1121-4aaa-87b5-7058acfcb94c
# ╟─a4e6a8c1-19de-4560-8dc3-25cb8c410699
# ╠═e3dcf172-b00f-4f66-afc5-351fb52ac29e
# ╠═53729d2f-a7ad-4751-adc7-3f04f4517512
# ╟─dbf2b60f-21ba-4fc4-9023-a73e4f8dbd3a
# ╠═35c302b2-dd84-4187-98fa-71dcad96e370
# ╠═02b44c49-ff20-40db-b5df-68f6e5cc65bc
# ╟─d6c98cf1-688f-4161-93dc-72981a2c007b
# ╟─8128a06f-c7be-42fb-b364-a289aa6428c7
# ╟─b43a441d-059b-4090-ad31-131f26c9e22e
# ╠═6d01f729-8d17-4b84-8ee9-8f726506758f
# ╟─1b2a65c7-51f3-49aa-b62f-bb2059dd8bc5
# ╠═296dbef1-59ea-4630-888a-e4d363ce7378
# ╠═9a61e715-1fbc-49ed-863b-c6e04b85107d
# ╠═6f85375d-329c-46f5-acdd-1bb6e00fcbfb
# ╟─8294d277-5db0-4635-a9f1-aa8bcb974be1
# ╠═dc03ac80-3f27-46e0-bc84-03951ba89533
# ╟─1c405bf5-3f65-4a83-afcd-2975b1794daf
# ╠═f565df01-d89f-4398-819f-f2d67b13bcf9
# ╟─568b6d78-2b27-4542-8e71-12bf82a6ef62
# ╟─2f054bed-f7ea-4498-889c-5f0957dbc833
# ╠═8751dd83-5d28-472e-abf3-81c47895de38
# ╟─8fdb7ea4-3df8-4c45-8f76-7f145a5e6592
# ╠═25536dda-3cbb-450e-b766-d5e098f54ece
# ╠═5080b4ad-b1f8-4df8-b90f-62c9c77a81a5
# ╠═03161d65-58dc-4056-b86c-50f62091a828
# ╠═bf2d1ca8-ff7e-4005-ab0a-e17d23567a53
# ╟─7f0bc58b-93e2-4956-81bc-dde79bec5099
# ╟─e892dcfa-8a77-4cb6-b340-bc843d7dc327
# ╠═746d826b-d645-482b-a3b0-9234f6e9f2fc
# ╟─5ddd2b6a-cd56-4995-9e68-1801da0a97f2
# ╟─9a679957-4ab8-4771-8277-55d10832ed80
# ╟─c705512b-5596-41a4-b4b1-7475b63bc236
# ╠═b8ea3e20-1b62-4a8d-bd13-c136a98a02df
# ╠═bf9935c3-3cc1-4429-976f-e19079e969ec
# ╠═e849961d-6e90-4a52-9163-24d5c6db1568
# ╠═022d2242-3812-4989-825c-8901689a9d33
# ╠═d26985fd-24fb-405c-b69f-beeae76c8613
# ╠═fef69797-778f-4fc4-888f-5970f2910ccb
# ╠═9c98b660-3526-4a31-b599-25b99dc3dda1
# ╠═6e80e5fe-169b-438c-8cd7-930afef0d297
# ╠═53b5bef6-acbd-4bfb-a182-762f6b119b69
# ╠═46430ee3-4d23-4676-a69c-4ba3fd2d013c
# ╠═a5f1e0ef-900b-4f42-917c-bd45bd6c29ca
# ╠═bd69fe33-98ff-4713-bbff-5dba9ca02402
# ╠═0834b447-9f92-4aa6-9429-4647a7a70b6f
# ╠═6267db0c-3bf7-4956-8975-fea2c5b63c06
# ╠═7cd2f73e-7d3a-44a2-8ad4-6a4264a21e09
# ╟─fd4a5d69-151d-417f-9ed5-d851dec8f77a
# ╠═afbe11e9-7043-43f4-9817-45da041e48b1
# ╠═0e9b4260-f23e-4ded-8f99-ec50aad10795
# ╠═916a1677-4202-4427-a575-ebba173bc495
# ╠═728c5f2d-563c-4ff3-a772-83f83ba53064
# ╠═73d45041-531f-43bd-a52d-69c4b7819cfa
# ╠═125bd566-361f-43fd-a53f-67e873d84292
# ╠═b8e3dbd8-e866-4531-b3a3-1ea91890ea20
# ╠═7977eec0-994f-4e50-aae5-74c3194e344e
# ╠═54a1eafe-decf-4e32-be2b-6082b471239d
# ╠═23cf584b-464f-4cc8-b2ba-fcd9432a772a
# ╠═14a92c6e-1bc0-45f9-97d2-bbe0d9d2d6a5
# ╠═d9557038-6ea6-4606-8244-f8f97af4f02b
# ╠═6dd58953-7646-4155-8449-6f00742071e6
# ╠═75a98f62-131b-46e9-8a35-6bd3ebfccfa5
# ╠═ea86a431-c875-4268-911e-4f624dfde776
# ╠═a2b03173-3277-48c7-a98a-b69b2330bef6
# ╟─0e9b5e56-fed9-4771-8fb0-897fe050a2a6
# ╠═1ab8239a-320d-49b5-ae1a-7ca46c69545d
# ╠═ffeed149-dfde-4fcb-a28a-d58084283927
# ╠═d318533a-e9f3-4420-8f49-ffa1082a2a9b
# ╠═6419287b-7090-430b-80e8-ffde2c37d95d
# ╠═55355d9d-a4fa-4b32-b763-01a751b2a8ad
# ╠═d63c4094-905b-45ad-966a-670a9645eebf
# ╠═31d5e8c4-426e-4abd-9fe5-8bd7b5aef101
# ╠═185dbce7-2630-4c70-9f05-132540712354
# ╠═99974b20-213c-47b3-867e-12443d137ada
# ╠═2771dda4-e36e-46b1-8e48-c8315233c69c
# ╠═9a27c067-ae06-4983-81c9-e5498435d7b9
# ╠═a166df7c-b59e-4393-b132-d1f3f66d32b0
# ╟─5ecc7f91-79e9-4439-ad96-d17e00975aec
# ╟─50e2c4ad-e51a-4bc0-b3e8-fdcab61a7be5
# ╟─c4665165-8f33-47f3-b761-272b2fab570d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
