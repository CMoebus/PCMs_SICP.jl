### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 045c0f14-d043-4912-8156-e271d302c13a
using Primes

# ╔═╡ 2ae8d380-3e88-11ee-2a26-efa9cdda3dee
md"
====================================================================================
#### SICP: 3.5.2.3 Infinite Streams III: Defining Streams Implicitly
##### file: PCM20230819\_SICP\_3.5.2.3\_Infinite\_Streams\_III.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/08/23 ***

====================================================================================
"


# ╔═╡ 035513c2-f2d8-4adc-8d68-4950cf6c29dd
md"
##### Types
"

# ╔═╡ 57a69783-306c-46a2-8fb9-aec76ed0cff4
UnOfUnRaTaFiDroRes = Union{UnitRange, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop, Base.Iterators.Rest}

# ╔═╡ fcb349ce-8f54-46a8-94aa-ace11c2f0d33
md"
---
##### Constructors
"

# ╔═╡ e206b659-6f6a-4bb6-bde0-3d23623580e7
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ 1d8a2016-c72d-486e-9edc-797add167d69
ConsOrUnitRangeOfIntegers = Union{Cons, UnitRange{Int64}}

# ╔═╡ 9b701972-4a50-4966-ba4d-34fbceaefca9
cons(car, cdr) = Cons(car, cdr)   

# ╔═╡ 81db4020-f7e5-491f-a099-79fc7f0b9ba4
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
list(elements...)::Cons = 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], list(elements[2:end]...))
	end #if

# ╔═╡ 76166193-b15a-49d9-8005-375f2d955732
theEmptyStream = list(:nil)::Cons   

# ╔═╡ 792b612c-5851-40bf-af06-53f5311a4108
md"
---
##### Selectors
"

# ╔═╡ 6a863d44-f6f9-4a27-b5cd-28b2e123e601
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ a0034e16-db79-4bcb-b770-32e252bd74bd
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 4fd8043d-b87c-4055-afef-5c7a0bb52246
begin
	streamCar(stream::Cons) = car(stream)                      #  SICP, p.319
	streamCar(stream::UnitRange{Int64}) = Iterators.first(stream) 
	streamCar(iter::UnOfUnRaTaFiDroRes) = Iterators.first(iter)   # from ch. 3.5.2.1
end # begin

# ╔═╡ 4c2f7496-964d-4bed-bc3a-7147313ba238
begin
	streamCdr(stream::Cons) = cdr(stream)                      #  SICP, p.319
	streamCdr(iter::UnOfUnRaTaFiDroRes) = Iterators.drop(iter, 1) # from ch. 3.5.2.1
end # begin

# ╔═╡ 5b8edc38-e0c0-4db1-8157-eb351db69656
md"
---
##### Predicates
"

# ╔═╡ b2edebde-f3b4-44df-96d7-52604bb6b7ea
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ dbebbc18-f879-4993-80b2-9e11144ad595
streamNull = null                                             #  SICP, p.319, ref 54

# ╔═╡ 58b47271-7474-4926-a02e-79eab40ca1a2
md"
---
##### *Delaying* and *Enforcing*
"

# ╔═╡ dc005dd8-24d9-4c34-9c17-4b1e9d8caad3
#-----------------------------------------------------------------------------------
# should be called with an anonymous closure
#-----------------------------------------------------------------------------------
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	delay(closure::Function)::Function = closure                 # SICP, p.323
	#-------------------------------------------------------------------------------
	delay(arg) = 
		println("the expression to be delayed should be embedded in the body of an anonymous closure '() -> expression'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ b1f9ca69-a21f-448f-a68f-15151224a4ad
begin
	#===============================================================================#
	# method 1: (Real, Function) -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(x::Real, closure::Function)::Cons # SICP, p.321, footnote 56
		cons(x, delay(closure))
	end # function streamCons
	#===============================================================================#
	# method 2: (Cons, Function) -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(x::Cons, closure::Function)::Cons # SICP, p.321, footnote 56
		cons(x, delay(closure))
	end # function streamCons
	#===============================================================================#
	# method 2: (Int64, UnOfUnRaTaFiDro) -> Cons                   # SICP, p.321, footnote 56
	#--------------------------------------------------------------------------------
	function streamCons(x::Int64, range::UnOfUnRaTaFiDroRes)::Cons 
		cons(x, range)
	end # function streamCons
	#===============================================================================#
	# method 3: default
	#--------------------------------------------------------------------------------
	function streamCons(args...)                         # SICP, p.321, footnote 56
		println("the 2nd argument of streamCons should be either an anonymous closure () -> arg...")
		println("... or of type 'UnOfUnRaTaFiDroRes'")
	end # function streamCons
	#--------------------------------------------------------------------------------
end # begin

# ╔═╡ 08b8bec1-24bf-4d10-9514-1f34560ec4f0
#------------------------------------------------------------------------------
# generates Cons-Structure or UnitRange{Int64}
#------------------------------------------------------------------------------
function integersStartingFrom(
	n::Integer; outputType = :Cons)::ConsOrUnitRangeOfIntegers # SICP, p.326
	#--------------------------------------------------------------------------
	if outputType == :Cons
		streamCons(n, () -> integersStartingFrom(n+1))::Cons   # new: ()-> ...
	#--------------------------------------------------------------------------
	elseif outputType == :UnitRange
		let maxInt = typemax(Int)
			iter::UnitRange{Int64} = (n:maxInt)::UnitRange{Int64}
		end # let
	#--------------------------------------------------------------------------
	else
		println("unknown outputType = $outputType")
	end # if
end # function integersStartingFrom

# ╔═╡ 2520330b-81f4-4b33-bf56-ba5879b90408
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $argument of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 76ee9e04-cfdd-4584-9914-6c3d48fdc16b
begin
	#--------------------------------------------------------------------------------
	function streamMap(proc::Function, stream::Cons)::Cons          # SICP, p.320
		if streamNull(stream)
			theEmptyStream
		else
			streamCons(
				proc(streamCar(stream)),
				() -> streamMap(proc, force(streamCdr(stream))))
		end # if
	end # method streamsMap
	#--------------------------------------------------------------------------------
	# streamMap deviates considerably from SICP's stream-map on p.325
	#--------------------------------------------------------------------------------
	function streamMap(proc::Function, stream1::Cons, stream2::Cons)::Cons          
		if (streamNull(stream1) || streamNull(stream2))
			theEmptyStream
		else
			streamCons(
				proc(streamCar(stream1), streamCar(stream2)),
					() -> streamMap(
					proc, force(streamCdr(stream1)), force(streamCdr(stream2))))
		end # if
	end # method streamMap
	#--------------------------------------------------------------------------------
end

# ╔═╡ a7b44e7c-b515-4f5d-bed0-2a2819881800
begin
	#-------------------------------------------------------------------------------
	function streamRef(stream::Function, n::Integer)         #  SICP, p.319
		if ==(n, 0)
			streamCar(force(stream))                         #  new: 'force'
		else
			streamRef(streamCdr(force(stream)), -(n, 1))     #  new: 'force'
		end # if
	end # function streamRef
	#-------------------------------------------------------------------------------
	function streamRef(stream::Cons, n::Integer)             #  SICP, p.319
		if ==(n, 0)
			streamCar(stream)                               
		else
			streamRef(streamCdr(stream), -(n, 1))    
		end # if
	end # function streamRef3
	#-------------------------------------------------------------------------------
	function streamRef(stream::UnitRange{Int64}, n::Integer) #  SICP, p.319
		Iterators.first(Iterators.take(Iterators.drop(stream, -(n, 1)), 1))
	end # function streamRef
	#-------------------------------------------------------------------------------
 	function streamRef(args...) 
		println("1st arg should be an anonymous closure with stream as body '() -> stream'...")
	end # function streamRef
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ ef06d162-9eb8-43b7-8e25-1e446a3b75d0
begin
	#--------------------------------------------------------------------------------
	function streamFilter(pred, stream::Function)::Cons  # SICP, p.322
		if  streamNull(force(stream))                    # terminal condition
			theEmptyStream::Cons                         # ==> Cons(:nil, :nil) --> :)
		#-----------------------------------------------------------------------------
		elseif pred(streamCar(force(stream::Function)))  # if pred == true ...
			streamCons(
				streamCar(force(stream)),                # ... then keep
				() -> streamFilter(pred, 
						streamCdr(force(stream))))::Cons 
		#-----------------------------------------------------------------------------
		else                                             # if pred == false ...
			streamFilter(pred, streamCdr(force(stream))) # ... the leave out
		end # if
	end # function streamFilter
	#--------------------------------------------------------------------------------
    function streamFilter(pred, stream::UnitRange{Int64})
		println("2) pred = $pred, stream = $stream")
		Iterators.filter(pred, stream)
	end # function streamFilter
	#--------------------------------------------------------------------------------
	function streamFilter(args...) 
		println("2nd argument in 'streamFilter' should be closure with stream embedded in body '() -> stream'")
	end # function streamFilter
	#--------------------------------------------------------------------------------
end # begin

# ╔═╡ 30899b6d-8002-40b3-8f36-59942cb60c61
md"
---
##### Test Applications
"

# ╔═╡ 9f711f5c-c827-47dd-a97a-7656fc51cff0
myOnes = streamCons(1, () -> myOnes)  # streamCons 2nd arg expects a closure

# ╔═╡ de21f743-5967-4374-abab-1d96a7463cd4
myOnesClosure = () -> myOnes

# ╔═╡ 09a496ab-b7d7-4ffc-b8f7-26913d884de1
streamRef(myOnesClosure, 10)

# ╔═╡ d27f1a73-f8fa-4904-b01d-c9d7e6f6430f
[streamRef(myOnesClosure, i) for i in 0:10]

# ╔═╡ 724645bc-0462-4c41-acfd-35ecbbd55494
md"
---
###### $addStreams$
(SICP, p.329)
"

# ╔═╡ d9ccf775-9566-4e0f-8bde-7f1e1a3b6ca0
function streamsAdd(stream1, stream2)
	streamMap(+, stream1, stream2)
end # function streamsAdd

# ╔═╡ 2593e03a-a5d1-438c-a67f-dd76e4a97d30
streamsAdd(myOnes, myOnes)

# ╔═╡ d03ca7eb-c511-4c96-bbeb-0ffc5e3ec6dc
collect(Int64, streamRef(streamsAdd(myOnes, myOnes), i) for i in 0:20)

# ╔═╡ ef660098-d0e5-41ae-ac77-a916a868e6f9
[streamRef(streamsAdd(myOnes, myOnes), i) for i in 0:20]

# ╔═╡ cf6414c1-c53a-4907-825a-6be26978eb80
myIntegers = streamCons(1, () -> streamsAdd(myOnes, myIntegers))  

# ╔═╡ 2d820867-5e90-4838-a7cf-7756df805c4e
myIntegersClosure = () -> myIntegers

# ╔═╡ 7db30522-0be2-4f27-ba07-71aab0cb997d
collect(streamRef(myIntegersClosure, i) for i in 0:20)

# ╔═╡ 31840a7b-bfa1-4a51-85b4-332021766ff2
[streamRef(myIntegersClosure, i) for i in 0:20]

# ╔═╡ d9d60d48-da87-47d3-b627-963a2c0d6a10
md"
---
###### Stream of *Fibonacci*-Numbers
(SICP, p.329)
"

# ╔═╡ 447d69d6-a799-4b55-ab68-5e1feaa9ec8e
myFibs =                                                    # SICP, p.329
	streamCons(0, 
		() -> streamCons(1, 
			() -> streamsAdd(force(streamCdr(myFibs)), myFibs)))

# ╔═╡ 143b57b3-6d98-4799-acf5-73c4b676df59
collect(streamRef(() -> myFibs, i) for i in 0:20)

# ╔═╡ 6ae36c5e-4afb-4f86-91e3-ecb1827fcd3b
myFibsClosure = () -> myFibs

# ╔═╡ 50bbfc83-d0aa-4f1b-b5f6-ed24a14ba061
collect(streamRef(myFibsClosure, i) for i in 0:20)

# ╔═╡ d745ef82-fd53-4d10-89b1-64c41f5dcf1e
streamMap(x -> x + 3, myOnes)

# ╔═╡ aacba8db-c079-4265-a811-43aad4c4ebbd
[streamRef(streamMap(x -> x + 3, myOnes), i) for i in 0:20]

# ╔═╡ bf7f0c8c-ad27-4c78-b5f2-e758c54dd9e9
[streamRef(streamMap(x -> x + 3, myOnes), i) for i in 0:20]

# ╔═╡ 0c25cfbb-b9b0-4167-8a4a-747ddca287dc
function streamScale(stream, scaleFactor)                # SICP, p.329
	streamMap(x -> x * scaleFactor, stream)
end # function streamScale

# ╔═╡ f56d03f8-3940-4b64-b00f-21c67eed17da
five = 2

# ╔═╡ 85c9e73f-7a83-498b-a1d3-4d53019647fe
collect(streamRef(streamScale(myIntegers, five), i) for i in 0:20)

# ╔═╡ 88c71323-0647-47ca-b6c4-97efbf6a81da
double = streamCons(1, () -> streamScale(double, 2))            # SICP, p.330

# ╔═╡ e76b3a61-374d-4adc-81bc-2e64fdf0390b
doubleClosure = () -> double

# ╔═╡ be2219f4-ef1b-4d82-9d52-1b4e56056a91
collect(streamRef(doubleClosure, i) for i in 0:20)

# ╔═╡ 5ba5db2b-1f19-4e6d-b07a-8dcff501d0f4
md"
---
###### Stream of Primes
(SICP, p.330)
"

# ╔═╡ 285ce67e-02fd-415e-b4b3-964c17251ca0
myPrimes = streamCons(2, () -> streamFilter(isprime, () -> integersStartingFrom(3)))

# ╔═╡ 123392cf-0393-4b05-a073-1d5d55eeaa81
streamRef(myPrimes, 10)

# ╔═╡ 2871b52c-7e9e-4afc-92e4-249192dd638f
collect(streamRef(myPrimes, i) for i in 0:20)

# ╔═╡ 16a307e7-e9ea-4e71-9666-e83d673996e5
md"
---
##### End of ch. 3.5.2.3
"

# ╔═╡ ea506d43-ed7e-4050-af4d-498c089286a9
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"

[compat]
Primes = "~0.5.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "ec70d52ab3207da196977cc3143724c876e07a2a"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "4c9f306e5d6603ae203c2000dd460d81a5251489"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.4"
"""

# ╔═╡ Cell order:
# ╟─2ae8d380-3e88-11ee-2a26-efa9cdda3dee
# ╠═045c0f14-d043-4912-8156-e271d302c13a
# ╟─035513c2-f2d8-4adc-8d68-4950cf6c29dd
# ╠═57a69783-306c-46a2-8fb9-aec76ed0cff4
# ╠═1d8a2016-c72d-486e-9edc-797add167d69
# ╟─fcb349ce-8f54-46a8-94aa-ace11c2f0d33
# ╠═e206b659-6f6a-4bb6-bde0-3d23623580e7
# ╠═9b701972-4a50-4966-ba4d-34fbceaefca9
# ╠═81db4020-f7e5-491f-a099-79fc7f0b9ba4
# ╠═b1f9ca69-a21f-448f-a68f-15151224a4ad
# ╠═76166193-b15a-49d9-8005-375f2d955732
# ╠═76ee9e04-cfdd-4584-9914-6c3d48fdc16b
# ╠═08b8bec1-24bf-4d10-9514-1f34560ec4f0
# ╟─792b612c-5851-40bf-af06-53f5311a4108
# ╠═6a863d44-f6f9-4a27-b5cd-28b2e123e601
# ╠═a0034e16-db79-4bcb-b770-32e252bd74bd
# ╠═4fd8043d-b87c-4055-afef-5c7a0bb52246
# ╠═4c2f7496-964d-4bed-bc3a-7147313ba238
# ╠═a7b44e7c-b515-4f5d-bed0-2a2819881800
# ╠═ef06d162-9eb8-43b7-8e25-1e446a3b75d0
# ╟─5b8edc38-e0c0-4db1-8157-eb351db69656
# ╠═b2edebde-f3b4-44df-96d7-52604bb6b7ea
# ╠═dbebbc18-f879-4993-80b2-9e11144ad595
# ╟─58b47271-7474-4926-a02e-79eab40ca1a2
# ╠═dc005dd8-24d9-4c34-9c17-4b1e9d8caad3
# ╠═2520330b-81f4-4b33-bf56-ba5879b90408
# ╟─30899b6d-8002-40b3-8f36-59942cb60c61
# ╠═9f711f5c-c827-47dd-a97a-7656fc51cff0
# ╠═de21f743-5967-4374-abab-1d96a7463cd4
# ╠═09a496ab-b7d7-4ffc-b8f7-26913d884de1
# ╠═d27f1a73-f8fa-4904-b01d-c9d7e6f6430f
# ╟─724645bc-0462-4c41-acfd-35ecbbd55494
# ╠═d9ccf775-9566-4e0f-8bde-7f1e1a3b6ca0
# ╠═2593e03a-a5d1-438c-a67f-dd76e4a97d30
# ╠═d03ca7eb-c511-4c96-bbeb-0ffc5e3ec6dc
# ╠═ef660098-d0e5-41ae-ac77-a916a868e6f9
# ╠═cf6414c1-c53a-4907-825a-6be26978eb80
# ╠═2d820867-5e90-4838-a7cf-7756df805c4e
# ╠═7db30522-0be2-4f27-ba07-71aab0cb997d
# ╠═31840a7b-bfa1-4a51-85b4-332021766ff2
# ╟─d9d60d48-da87-47d3-b627-963a2c0d6a10
# ╠═447d69d6-a799-4b55-ab68-5e1feaa9ec8e
# ╠═143b57b3-6d98-4799-acf5-73c4b676df59
# ╠═6ae36c5e-4afb-4f86-91e3-ecb1827fcd3b
# ╠═50bbfc83-d0aa-4f1b-b5f6-ed24a14ba061
# ╠═d745ef82-fd53-4d10-89b1-64c41f5dcf1e
# ╠═aacba8db-c079-4265-a811-43aad4c4ebbd
# ╠═bf7f0c8c-ad27-4c78-b5f2-e758c54dd9e9
# ╠═0c25cfbb-b9b0-4167-8a4a-747ddca287dc
# ╠═f56d03f8-3940-4b64-b00f-21c67eed17da
# ╠═85c9e73f-7a83-498b-a1d3-4d53019647fe
# ╠═88c71323-0647-47ca-b6c4-97efbf6a81da
# ╠═e76b3a61-374d-4adc-81bc-2e64fdf0390b
# ╠═be2219f4-ef1b-4d82-9d52-1b4e56056a91
# ╟─5ba5db2b-1f19-4e6d-b07a-8dcff501d0f4
# ╠═285ce67e-02fd-415e-b4b3-964c17251ca0
# ╠═123392cf-0393-4b05-a073-1d5d55eeaa81
# ╠═2871b52c-7e9e-4afc-92e4-249192dd638f
# ╟─16a307e7-e9ea-4e71-9666-e83d673996e5
# ╟─ea506d43-ed7e-4050-af4d-498c089286a9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
