### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 97fdcd00-a8e9-4d48-ac78-d386240e021c
using Plots

# ╔═╡ d7a858c0-2ba0-11ee-05d3-b1fd5e652709
md"
====================================================================================
#### SICP: 3.5.2.1 Infinite Streams I
##### file: PCM20230726\_SICP\_3.5.2.1\_Infinite\_Streams\_I.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/08/12 ***

====================================================================================
"

# ╔═╡ 6b87a14e-db96-4c34-85de-74c0eedd947b
md"
---
##### 3.5.2.1.1 SICP-Scheme like functional Julia
##### Basic Scheme-like Functions
"

# ╔═╡ a9507893-d5dc-4642-ad40-16608e319de1
md"
###### Constructors
"

# ╔═╡ 6bcc5da3-74fd-4f8a-be7d-08cea9be7385
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ 91eacaa7-3e22-406b-b0b2-c4b88c789d41
cons(car, cdr) = Cons(car, cdr)   

# ╔═╡ 774d7a51-4875-4e22-b4c2-3a4e48022259
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

# ╔═╡ a69c5ea3-cdee-4fff-bd92-28c65dc1796b
md"
###### Selectors
"

# ╔═╡ 7b95ae3a-1151-499d-bbac-cf123d93cd35
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ 08c2c8e9-490f-48d9-b681-38354373cc51
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 2c643f4a-e1df-48dd-b772-a10d028d6d27
md"
###### Predicates
"

# ╔═╡ 7303b132-17bf-435c-8e93-a546d7989d3f
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ 692df292-5ed0-46cc-b301-758341785b93
streamNull = null                                             #  SICP, p.319, ref 54

# ╔═╡ d3dd7622-6a82-4ea2-a88f-45b1a7ced016
md"
---
##### 3.5.2.1.2 Streams
"

# ╔═╡ 9de5244b-1437-4369-b877-17703ebffe5b
md"
---
###### $delay$ and $force$
(SICP, p.323f)

---
The effect of $delay$ can be achieved by *embeddding* the *expression* to be delayed into the *body* of an anonymous *closure*:

$delay(expression) \equiv () \rightarrow expression$
"

# ╔═╡ 15c00413-400a-4140-a994-2c79f592794f
#-----------------------------------------------------------------------------------
# should be called with an anonymous closure
#-----------------------------------------------------------------------------------
begin
	#-------------------------------------------------------------------------------
	delay(closure::Function)::Function = closure                 # SICP, p.323
	#-------------------------------------------------------------------------------
	delay(arg) = 
		println("the expression to be delayed should be embedded in the body of an anonymous closure '() -> expression'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ f64e3348-cf23-4aab-a0ba-fbd93a4af378
md"
---
The effect of $force$ can be achieved by explicitly *calling* the *closure* (= delayed *expression*):

$force(expression) \equiv expression()$
"

# ╔═╡ b8747411-09aa-4c55-964a-70251a15b98b
begin
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $arg of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 449fc579-58bd-4b45-bd90-30afaf601ea4
md"
---
###### Stream Constructors
"

# ╔═╡ 2614347f-4772-48b9-9926-b6e58e8752dc
theEmptyStream = list(:nil)::Cons                         # SICP, p.319, footnote 54

# ╔═╡ 14b3cd5a-60a3-478d-9169-07dec0188fff
begin
	#===============================================================================#
	# method 1: Function -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(x, closure::Function)::Cons       # SICP, p.321, footnote 56
		cons(x, delay(closure))
	end # function streamCons
	#===============================================================================#
	# method 2: UnitRange{Int64}Function -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(x, range::UnitRange{Int64})::Cons # SICP, p.321, footnote 56
		cons(x, range)
	end # function streamCons
	#===============================================================================#
	# method 3: UnitRange{Int64}Function -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(args...)                          # SICP, p.321, footnote 56
		println("the 2nd argument of streamCons should be either an anonymous closure () -> arg...")
		println("... or an unit range 'n:m' of type 'UnitRange{Int64}'")
	end # function streamCons
	#--------------------------------------------------------------------------------
end # begin

# ╔═╡ c7a89432-4ad7-4694-ac9d-b1e4d3215bdb
#-----------------------------------------------------------------------------------
# stream analog of enumerate-interval (ch. 2.2.3) 
#-----------------------------------------------------------------------------------
function streamEnumerateInterval(low::Integer, high::Integer)::Cons   #  SICP, p.321
	if !(low < high)
		theEmptyStream::Cons
	else
		streamCons(low, () -> streamEnumerateInterval(+(low, 1), high))::Cons
	end # if
end # function streamEnumerateInterval

# ╔═╡ 0d072279-4968-468b-9ab5-345a6be7228f
typeof(() -> streamEnumerateInterval(0, 100)) <: Function

# ╔═╡ 5abb9916-0991-4dd6-8827-55b021e5667f
md"
---
###### Stream Selectors
"

# ╔═╡ 753f86e9-3ed4-4fba-b325-07a76316eee7
streamCar(stream::Cons) = car(stream)                    #  SICP, p.319

# ╔═╡ 9c99dbdd-094b-48e3-aed1-d04b378645b7
streamCdr(stream::Cons) = cdr(stream)                    #  SICP, p.319

# ╔═╡ 8f734bd2-e460-4de2-8bac-12c065376c04
md"
---
###### Stream Predicates
"

# ╔═╡ 8c7d7ccf-6d60-4fff-a089-c03ebe9f0858
streamNull(streamEnumerateInterval(0, 0))

# ╔═╡ 484b328a-f060-4d31-b9e4-c70f4f155a1b
md"
---
##### 3.5.2.1.3 Test Applications
"

# ╔═╡ aebb3512-3d4b-47d7-8035-013f59960de7
md"
###### Stream Of Integers
"

# ╔═╡ ac70da16-801a-4ea4-8dc1-79cb7a5d84c2
ConsOrUnitRangeOfIntegers = Union{Cons, UnitRange{Int64}}

# ╔═╡ df518f02-1121-4d8d-bad9-190db5f2343d
# generates Cons-Structure or UnitRange{Int64}
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

# ╔═╡ bf294711-fad1-4cbd-b394-4701653bde06
integersStartingFrom(0)

# ╔═╡ 5a4914af-17b3-4201-9d5a-5f4ff1fa5722
integers::Cons = integersStartingFrom(0)

# ╔═╡ 6d998db2-4de8-46e4-ad96-c2ead8a128ad
integersClosure = () -> integers

# ╔═╡ fe2aa340-29b1-40d6-8ff6-25b41772f345
md"
---
###### Filtering the Stream of Integers
"

# ╔═╡ d4d5e04e-c460-43a7-942e-5cdac3a05d10
function divisible(x::Integer, y::Integer)::Integer           # SICP, p.326
	rem(x, y) ≡ 0 ? true : false
end # function divisable

# ╔═╡ c8b224e9-7794-4bee-aabb-01b51a74d528
divisible(9, 3)

# ╔═╡ aebd9c74-4849-4b86-a0b0-3ada5d523581
divisible(9, 2)

# ╔═╡ b297e3ff-3159-440d-aca8-920988d3c584
md"
---
###### Stream of [Fibonacci's Numbers](https://en.wikipedia.org/wiki/Fibonacci#Fibonacci_sequence)
"

# ╔═╡ ab51084e-ddb1-4fe2-b13f-84d401da6d62
function fibgen(a, b)                                  # SICP, p.326
	streamCons(a, () -> fibgen(b, +(a, b)))            # new: ()-> ...
end # function fibgen

# ╔═╡ e9f3c3b5-5ea9-45f3-8eee-2e2fe1f2e448
md"
The Fibonacci Sequence starts with [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, ...](https://en.wikipedia.org/wiki/Fibonacci_sequence) :
"

# ╔═╡ b9fa2f72-2925-4b58-bcf5-7544c82a1969
md"
---
###### Stream of Primes by [*Sieve of Erathostenes*](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes)
This version is highly inefficient als time measurements with the $@time$-macro and the plot (below) show. So its *not* possible to replicate on a PC the call $(stream\text{-}ref\; primes\; 50)$ in Scheme-like Julia (SICP, p.327). 
"

# ╔═╡ f1973df2-4539-4d37-bcbb-625d0b1dc570
integersStartingFrom2Closure = () -> integersStartingFrom(2)  # SICP, p.327

# ╔═╡ 72998046-3ba4-420b-9eb2-2d615be8da0c
md"
---
###### 1st Scheme-like Functional *Method* of Function $sieve$
"

# ╔═╡ 5812f40b-bfeb-4dfd-87ba-d5d0eb65c743
# prim12 = @time streamRef(primesClosure, 11)

# ╔═╡ b86a4021-b75e-42c5-a6e6-41bdd6c1e6b2
# prim13 = @time streamRef(primesClosure, 12)      #  ==>  41  -->  :)

# ╔═╡ b0f05ecb-f80a-47fc-90c4-a511ab789ec4
secs1Array = [ 0.000002,  0.000030,   0.000053, 0.000990, 0.003579,
	           0.003579,  0.016872,   0.137058, 0.486110, 2.333387,
              13.240374, 64.386527, 298.892458]

# ╔═╡ 282d373f-2335-4ed2-965a-ea030c52f0b3
allocsM1Array = [ 0.0,     0.000012,   0.000101, 0.000575,  0.0036, 
		          0.018,   0.094,      0.470,    2.36,     12.23, 
			     62.61,  316.69,    1590.0]

# ╔═╡ 80fdf4bf-832d-4e05-b68f-a1d965b54169
primesArray = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]  # input length = 13

# ╔═╡ ff06c74e-581c-42b5-938e-99bdfd0e36e3
length(secs1Array)

# ╔═╡ 3699e053-ea50-47f3-8ebd-1cc9b05584fd
length(primesArray)

# ╔═╡ 214cd340-c183-437e-b964-7fa35dd3b405
length(allocsM1Array)

# ╔═╡ 227e7d7e-f868-419a-ba1b-c91425db0c9e
let
	plot(primesArray[1:13], secs1Array[1:13], label="secs1", xlabel="input length", ylabel="secs1", linewidth=1, line=:darkblue, fill=(0, :lightblue), framestyle=:semi, title="Runtimes of Sieve-Of-Erathostenes 1")
end # let

# ╔═╡ bf6e3ff6-f824-45f3-8d92-49a1e03d6e0f
let
	plot(primesArray[1:13], allocsM1Array[1:13], label="allocsM1", 
		xlabel="no of primes ps > 1 found", ylabel="allocsM1", linewidth=1, line=:darkblue, fill=(0, :lightblue), framestyle=:semi, 
		title="Storage Needs of Sieve-Of-Erathostenes 1")
end # let

# ╔═╡ a5b8d317-8b91-4637-8cac-4fa9390a8e3e
md"
---
##### 3.5.2.2 Idiomatic Julia: [Generator Expressions](https://docs.julialang.org/en/v1/manual/arrays/#Generator-Expressions) and [Iterators](https://docs.julialang.org/en/v1/base/iterators/#Iteration-utilities)
"

# ╔═╡ db18ae0e-b60d-4604-bebc-6b085f2b8e4d
UnOfUnRaTaFiDro = Union{UnitRange{Int64}, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop{UnitRange{Int64}}}

# ╔═╡ 0188c7f8-65e8-4c6b-83b0-bd88a41787dc
begin
	#--------------------------------------------------------------------------------
	function streamRef2(stream::UnOfUnRaTaFiDro, n::Integer)      #  SICP, p.319
        Iterators.first(Iterators.take(Iterators.drop(stream, -(n, 1)), 1)) 
	end # function streamRef2
	#---------------------------------------------------------------------------------
	function streamRef2(args...) 
		println("1st arg should be either an anonymous closure with stream as body '() -> stream'...")
		println("... or should be of type UnOfUnRaTaFiDro = Union{UnitRange{Int64}, Base.Iterators.Take, Base.Iterators.Filter, Base.Iterators.Drop{UnitRange{Int64}}}")
	end # function streamRef2
#------------------------------------------------------------------------------------
end

# ╔═╡ 62e64949-3739-494f-a9d0-d4a062b0b631
supertype(Function)

# ╔═╡ 236ec613-efb4-4854-b1e8-992554160dbb
supertype(UnitRange{Int64})

# ╔═╡ 0423152f-1d87-45c5-be21-d6880bb25b4a
supertype(Base.Iterators.Take)

# ╔═╡ 3c33fc61-5ff0-402c-b042-c21eea449b7e
supertype(Base.Iterators.Filter)

# ╔═╡ ef9374d4-74b2-4be1-a9fe-08da1ac1b37e
supertype(Base.Iterators.Drop{UnitRange{Int64}})

# ╔═╡ 4bac2130-9a3c-4f54-b0c4-251b9729cd50
let maxInt = typemax(Int)
	(i for i in 1:maxInt)
end # let

# ╔═╡ b8425ebe-6fc9-4ba1-a1d8-335a1dfd330d
md"
---
###### $streamCar(iter) \equiv Iterators.first(iter)$
"

# ╔═╡ d6175151-c72e-475a-88b8-82a777227bb7
streamCar(iter::UnOfUnRaTaFiDro) = Iterators.first(iter)

# ╔═╡ 44b89b7d-a800-4a0f-8af1-a99e1d8dcfb8
streamCar(integers::Cons)

# ╔═╡ 4c90852b-a23f-4b7e-b15d-ea1673806b49
md"
---
###### $streamCdr(iter) \equiv Iterators.drop(iter, 1)$
"

# ╔═╡ c5130a74-7a54-4ef6-b19f-73bfb992e0aa
streamCdr(iter::UnOfUnRaTaFiDro) = Iterators.drop(iter, 1)

# ╔═╡ c82706be-e538-4757-99c4-41bbfa2de5a3
begin
	#--------------------------------------------------------------------------------
	function streamFilter(pred, stream::Function)::Cons  # SICP, p.322
		if  streamNull(force(stream))                    # new: 'force'
			theEmptyStream::Cons                         # ==> Cons(:nil, :nil) --> :)
		#-----------------------------------------------------------------------------
		elseif pred(streamCar(force(stream)))            # if pred == true
			streamCons(
				streamCar(force(stream)),                # new: 'force'
				() -> streamFilter(pred, 
						streamCdr(force(stream))))::Cons # new: 'force'
		#-----------------------------------------------------------------------------
		else                                             # if not(pred)
			streamFilter(pred, streamCdr(force(stream))) # if pred == false
		end # if
	end # function streamFilter
	#--------------------------------------------------------------------------------
	function streamFilter(args...) 
		println("2nd argument should be closure with stream embedded in body '() -> stream'")
	end # function streamFilter
	#--------------------------------------------------------------------------------
end # begin

# ╔═╡ b7e0835b-415b-473f-abe4-710dfd16891d
streamFilter(iseven, () -> streamEnumerateInterval(0, 21))

# ╔═╡ de2bcf75-0ecf-404c-bd0a-3811ea156baf
noSevens =                                                    # SICP, p.326
	streamFilter((x) -> !(divisible(x, 7)), integersClosure)::Cons

# ╔═╡ 1d43986c-515b-4f75-9164-8afdfef0dc7c
noSevensClosure = () -> noSevens 

# ╔═╡ f031c6c8-df9e-4c66-ab6b-e42696ab0f66
typeof(noSevensClosure) <: Function

# ╔═╡ b455b2e3-454f-4299-b671-29ab381be71f
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
 	function streamRef(args...) 
		println("1st arg should be an anonymous closure with stream as body '() -> stream'...")
	end # function streamRef
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ d1af551b-4c48-475a-9463-b9c062623852
[streamRef(
	() -> streamFilter(
		iseven, 
		() -> streamEnumerateInterval(0, 21)), i) for i in 1:10]

# ╔═╡ e891841c-d1a2-44cc-aeae-3c03bfec142e
streamRef(streamEnumerateInterval(0, 100), 99) # test call with wrong argument

# ╔═╡ f4ea8760-9077-4231-bb1f-01b95e8a14f6
streamRef(() -> streamEnumerateInterval(0, 100), 99) # syntax correct argument

# ╔═╡ 034b21ab-f8cd-47cd-8b1d-c8498162b124
streamRef(integersClosure, 1)

# ╔═╡ 7c7ded6f-488c-41a0-881f-7ad5a947ca0d
streamRef(integersClosure, 98)

# ╔═╡ ff91559b-1d4f-4769-83eb-5de8ea5dd777
[streamRef(noSevensClosure, i) for i in 1:20] # vector or array comprehension

# ╔═╡ c88efbe0-5920-4707-b9e0-ef9ec2550b9d
streamRef(noSevensClosure, 100)                        # SICP, p.326

# ╔═╡ db1cd319-0202-40fe-9925-ee44d4bd2e1e
function fib(n)
	let fibs = fibgen(0, 1) 
		fibsClosure = () -> fibs
		streamRef(fibsClosure, n)   
	end # let
end # function function fib

# ╔═╡ 7cbe6f94-1b73-4a1f-8e21-d8d562b104a3
[fib(i) for i in 0:20]                                 # SICP, p.327

# ╔═╡ 358306a8-da75-45cf-8ab4-7882f80b943f
@time [streamRef(integersStartingFrom2Closure, i) for i in 0:20]    # SICP, p.327

# ╔═╡ c6ae9a79-0773-464a-9f7c-22a0d261cace
begin
#----------------------------------------------------------------------------------
function sieve(stream::Function)::Cons                        # SICP, p.327
	streamCons(
		streamCar(force(stream)), 
			() -> sieve(
				() -> streamFilter(
					(x) -> !(divisible(x, streamCar(force(stream)))), # predicate
					streamCdr(force(stream)))))               # shortened stream
end # function sieve
#----------------------------------------------------------------------------------
function sieve(args...)
	println("the arg of sieve has to be an anonymous closure")
end # function sieve
#----------------------------------------------------------------------------------
end # begin

# ╔═╡ b8df023c-736b-48c7-9fea-d48018040466
primes = sieve(integersStartingFrom2Closure)::Cons             # SICP, p.327

# ╔═╡ 82ef96cc-2a7b-4868-8e6c-8d8524e80ae1
[streamRef(() -> primes, i) for i in 0:9]

# ╔═╡ 17acd73c-bb18-473b-b52e-aeb73c2931ce
primesClosure = () -> primes

# ╔═╡ 62c92a48-4d45-48e2-81ce-ca81162d0e27
[streamRef(primesClosure, i) for i in 0:9]

# ╔═╡ 75433a74-9295-4a85-85b0-e3588ef7050c
prim1 = @time streamRef(primesClosure, 0)

# ╔═╡ c528fc10-4a13-4fb7-a3d9-cf8838d15e81
prim2 = @time streamRef(primesClosure, 1)

# ╔═╡ d6bd7332-7cad-4438-a582-642e521013ec
prim3 = @time streamRef(primesClosure, 2)

# ╔═╡ 2b56575a-0117-40c7-8ef7-387cf7911dad
prim4 = @time streamRef(primesClosure, 3)

# ╔═╡ 33fd6312-1cf9-4e45-8bbc-120fa50f7c7c
prim5 = @time streamRef(primesClosure, 4)

# ╔═╡ d3827dc9-54cb-4864-824d-b431587d6cb3
prim6 = @time streamRef(primesClosure, 5)

# ╔═╡ 93c41001-9534-40a3-947c-2e1c71c32c03
prim7 = @time streamRef(primesClosure, 6)

# ╔═╡ bc3065ee-71b6-42f9-bee3-c7682b24651d
prim8 = @time streamRef(primesClosure, 7)

# ╔═╡ 55ae1274-b6ca-467e-9547-cd432b3ebbb6
prim9 = @time streamRef(primesClosure, 8)

# ╔═╡ 694fc4a9-e532-4127-8cd2-7df0d85c2cd5
prim10 = @time streamRef(primesClosure, 9)

# ╔═╡ 6321ff6a-a5c3-4e99-86c0-03525742d9e3
prim11 = @time streamRef(primesClosure, 10)

# ╔═╡ 0bc660ec-6df9-46df-8939-79636b05bb13
streamCar(primes)                                              # 1st prime

# ╔═╡ 06dbdc2d-24d7-447a-9486-43c28898878e
streamCar(force(streamCdr(primes)))                            # 2nd prime

# ╔═╡ 658f1c3f-7859-40be-a3d4-51fe511195cb
md"
---
###### Testing 
$streamCar, streamCdr, Iterators.take,  Iterators.drop, collect, (Iterators.)filter, filter!$
"

# ╔═╡ 33ff0c2b-b3b0-4c57-abaf-e34bf54a7ef7
integersFrom1::UnitRange{Int64} = 
	integersStartingFrom(1, outputType=:UnitRange)

# ╔═╡ 4f67ef26-a4b5-4fa4-9698-0774e2e3db9e
integersFrom2::UnitRange{Int64} = 
	integersStartingFrom(2, outputType=:UnitRange)

# ╔═╡ 34989762-4f2c-4af5-a771-c1a25929a831
integersFrom5::UnitRange{Int64} = integersStartingFrom(5, outputType=:UnitRange)

# ╔═╡ c0ec1a1e-75e0-4bd7-9665-035231f7589a
streamCar(integersFrom1)                           # ==>  1  -->  :)

# ╔═╡ 988f98f8-833d-43b3-bf43-d21eab3ced8f
streamCdr(integersFrom1)

# ╔═╡ c14ba599-2689-41bd-9059-40cbc5e4b42b
typeof(streamCdr(integersFrom1))

# ╔═╡ 417c3e91-7300-41f5-b099-44ad139d098f
typeof(streamCdr(integersFrom1)) <: UnOfUnRaTaFiDro

# ╔═╡ a98defe8-630d-49f6-a913-7ca9f81f7b8b
streamCar(streamCdr(integersFrom1))                # ==>  2  -->  :)

# ╔═╡ 36158cc6-5828-4ddf-b402-cac77693d731
streamCar(integersFrom5)                           # ==>  5  -->  :)

# ╔═╡ 2c90ea62-0924-4c34-a7b2-0f8ddcdb51e4
streamCar(streamCdr(integersFrom5))                # ==>  6  -->  :)

# ╔═╡ aaba104f-764f-459b-864a-97273bf3edf2
md"
---
###### $Iterators.take(iter, n)$
"

# ╔═╡ b6259cb0-618c-400d-9425-e60b3c96be5d
Iterators.take(integersFrom5, 10)

# ╔═╡ 349d7bac-9d99-42d5-af76-0f5c13a3de54
typeof(Iterators.take(integersFrom5, 10)) 

# ╔═╡ 0af82e2f-3b3c-47a1-9353-27ba95376a53
typeof(Iterators.take(integersFrom5, 10)) <: UnOfUnRaTaFiDro

# ╔═╡ 951884b8-6d58-4016-b0f6-1c5a9f5aa107
Iterators.take(integersFrom5, 10)::Iterators.Take{UnitRange{Int64}}

# ╔═╡ 2cbd1448-5afa-4ca4-b38c-6479b44d603a
typeof(Iterators.take(integersFrom5, 10)) <: UnOfUnRaTaFiDro

# ╔═╡ 5ae16a69-e233-4614-9d4f-44cb61fafb4b
collect(Iterators.take(integersFrom5, 10))

# ╔═╡ b7b0f7f3-6171-4f97-9a60-89ded4e16b8c
typeof(collect(Iterators.take(integersFrom5, 10))) <: Vector <: Array

# ╔═╡ 9c4792ac-63d8-4f63-a0f9-91a16b4deb24
Iterators.drop(integersFrom5, 4)

# ╔═╡ 436975dd-1225-4707-8e77-59a1852eb37f
typeof(Iterators.drop(integersFrom5, 4)) 

# ╔═╡ 07f20823-4478-40cd-abb5-3d8a83947d26
typeof(Iterators.drop(integersFrom5, 4)) <: UnOfUnRaTaFiDro

# ╔═╡ 6018a7b2-2f8d-4823-8f13-96ce59f6859f
streamCar(Iterators.drop(integersFrom5, 4))        # ==>  9  -->  :)

# ╔═╡ 2ef4c71f-0aca-4246-ae49-87986dadcc36
md"
---
###### $filter(predicate, collection)$
[Julia Doc](https://docs.julialang.org/en/v1/base/collections/#Base.filter): Return a *copy* of collection, removing elements for which $pred$ is *false*. The predicate (= *boolean* function) $pred$ is passed *one* argument.
"

# ╔═╡ 0b6aad89-9b6b-4528-8b54-d059fe80c8da
filter(x -> !(divisible(x, 7)), collect(Iterators.take(integersFrom5, 20)))

# ╔═╡ ab05aff1-9c25-46ae-8a4f-513d204abc92
typeof(filter(x -> !(divisible(x, 7)), collect(Iterators.take(integersFrom5, 20))))

# ╔═╡ c2805c10-87c5-401b-a668-c2e21a47d334
md"
---
###### $filter!(predicate, collection)$
*Update* collection $coll$, removing elements for which $pred$ is *false*. The function $pred$ is passed *one* argument.
This function is *eager*.
"

# ╔═╡ e0d6f2b4-8a2e-4bac-af8c-f62a4e63bdd4
filter!(x -> !(divisible(x, 7)), collect(Iterators.take(integersFrom5, 20)))

# ╔═╡ 26ef08b8-9e5a-45ca-8e72-6910b42f0f6c
md"
---
###### $Iterators.filter(predicate, iter)$
Given a *predicate* (function) $pred$ and an iterable object $iter$, return an iterable object which upon iteration yields the elements $x$ of $iter$ that satisfy $pred(x)$. The order of the original iterator is preserved.
This function is *lazy*; that is, it is guaranteed to return in *Θ(1)* time and use *Θ(1)* additional space.

"

# ╔═╡ 849a7a65-9b4e-4d99-9828-1a4828723d15
Iterators.filter(x -> !(divisible(x, 7)), Iterators.take(integersFrom5, 20))

# ╔═╡ 73205c79-d093-4d39-94b0-fa81994b9be5
typeof(Iterators.filter(x -> !(divisible(x, 7)), Iterators.take(integersFrom5, 20)))

# ╔═╡ eb9a6526-a290-41b3-8b06-c2f4fd07ed9e
typeof(
	Iterators.filter(
		x -> !(divisible(x, 7)), 
		Iterators.take(integersFrom5, 20))) <: UnOfUnRaTaFiDro

# ╔═╡ 68114b3e-5348-4d02-b288-ac08bf344624
collect(Iterators.filter(x -> !(divisible(x, 7)), Iterators.take(integersFrom5, 20)))

# ╔═╡ 3aaa324e-8c5e-404f-b84e-1aee4ae264d6
noSevens_V2 =                                                       # SICP, p.326
	Iterators.filter(x -> !(divisible(x, 7)), integersFrom1::UnitRange{Int64})

# ╔═╡ aa33e4ae-7e35-44d5-a893-f9455a0fca29
typeof(noSevens_V2) 

# ╔═╡ 774dec49-dc11-482f-a786-cbc98f64c3ed
typeof(noSevens_V2) <: Base.Iterators.Filter <: UnOfUnRaTaFiDro

# ╔═╡ 65b08e54-bc56-4277-b7ab-83bc15b036cb
collect(Iterators.take(Iterators.drop(noSevens_V2, 5), 20))

# ╔═╡ f5ee7506-5854-45dc-91f2-dabfd2cb0459
collect(Iterators.take(Iterators.drop(noSevens_V2, 5), 20))[10] # 10th element

# ╔═╡ ae100ce2-f235-487b-9783-fa36c520307e
streamRef2(noSevens_V2, 1)              #  ==>  1  -->  :)

# ╔═╡ 5317eed5-8102-4e1d-b26e-383eb214fd80
streamRef2(noSevens_V2, 6)              #  ==>  6  -->  :)

# ╔═╡ ad285d2a-05a8-4081-a4bf-a130991ecd80
streamRef2(noSevens_V2, 7)              #  ==>  8  -->  :)

# ╔═╡ 227521b9-2b15-4464-9a1e-4cd98f824fd1
streamRef2(noSevens_V2, 101)            #  ==>  117  -->  :)   SICP, p.326     

# ╔═╡ 5f85bd19-8e21-4a6c-98c2-df41e8f1290d
md"
---
###### Cumulative sum: $f(n)=\Sigma_{i=0}^n x_i \text{ ;; for }\;n=1,2,3,...\text{ , and } x_n=n-1$
"

# ╔═╡ 472a9c05-5353-4fd5-a9c3-723d0a076a11
maxInt = typemax(Int)

# ╔═╡ 8f783495-2be3-46af-8a7d-8f6c2fcec055
streamRef2(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 5), 1)

# ╔═╡ 751a7f65-a352-4541-9a48-cf794123fafb
streamRef2(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 5), 2)

# ╔═╡ f57a119a-c27b-4a99-aa3f-faf6f392ffcf
streamRef2(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 5), 3)

# ╔═╡ 8db31663-503e-40aa-8926-1d713d00f587
streamRef2(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 5), 4)

# ╔═╡ 2b6b7be7-bf11-424e-9e14-8532ef644a9c
streamRef2(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 5), 5)

# ╔═╡ 6fa7bcf6-30ec-451e-9e68-8c05e959f273
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2)

# ╔═╡ f1aec2ab-15c7-4d61-9dd8-21b46de11840
typeof(Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2))

# ╔═╡ 86de31dc-d2eb-40cb-a281-d9fb62fcad30
typeof(
	Iterators.take(
		Iterators.accumulate(+, 0:1:maxInt; init=0), 2)) <: UnOfUnRaTaFiDro

# ╔═╡ 30f0b494-c962-4dcc-9f8a-75ecc99cf989
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2).xs     # field 'xs'

# ╔═╡ 2fec1003-121c-48b1-bc1b-0850dd5e07cc
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2).xs.f   # field 'xs.f'

# ╔═╡ 69009574-7304-467d-86fa-cab18cd02ff7
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2).xs.itr # field 'xs.itr'

# ╔═╡ bc7e7b1f-cf8d-43eb-8e05-5ceceef9681d
# field 'xs.init'
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2).xs.init 

# ╔═╡ 95441662-4297-4298-b34e-45dddedc3af6
Iterators.take(Iterators.accumulate(+, 0:1:maxInt; init=0), 2).n       # field 'n'

# ╔═╡ 9d0985e8-f6ae-4dc4-af2d-aa602e38d7cc
md"
---
###### $Sieve2$: *2nd* variant of $sieve$ for input type $UofUVWXYZ$
"

# ╔═╡ 38cc3f84-7c55-4280-9bd0-5a849da99e93
md"
---
###### 2nd Iterator-based and 3rd Default *Method* of Function $sieve$
"

# ╔═╡ 83820d03-3d3f-4db1-a16c-e9910eb99bb5
begin        # 2nd variant of 'sieve' for input type 'UnOfUnRaTaFiDro'
	#-------------------------------------------------------------------------------
	function sieve2(stream::UnOfUnRaTaFiDro)::Cons
		streamCons(
			# Iterators.first(stream),
			streamCar(stream),
			() -> sieve2(
				Iterators.filter(
					# x -> !(divisible(x, Iterators.first(stream))),
					x -> !(divisible(x, streamCar(stream))),
					# Iterators.drop(stream, 1))))
					streamCdr(stream))))
	end # function sieve2
	#-------------------------------------------------------------------------------
	function sieve2(args...)
		println("arg should be either an anonymous closure with stream as body '() -> stream'...")
		println("... where 'stream' should be generated by 'streamCons' with a delayed 2nd arg")
		println("...or an UnitRange")
	end # function sieve2
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 0c399c6b-3141-4501-9aaa-b7e1bc8c4a21
sieve2(integersFrom2)

# ╔═╡ 911a9301-2522-4857-8c2c-bd5b9ed0f0ca
primes2Stream = sieve2(integersFrom2)

# ╔═╡ 6bda6ec5-fdd5-4733-8ebf-7cfa1b52cbe6
@time [streamRef(() -> primes2Stream, i) for i in 0:0]

# ╔═╡ 897a75ca-0f0a-4363-a6e2-776cacea7118
@time [streamRef(() -> primes2Stream, i) for i in 0:1]

# ╔═╡ 985a8e78-cb5e-490e-8fc3-3630df2eb150
@time [streamRef(() -> primes2Stream, i) for i in 0:2]

# ╔═╡ d82aef76-c98f-459f-ac28-f5529aadf198
@time [streamRef(() -> primes2Stream, i) for i in 0:3]

# ╔═╡ e41b84a6-59c2-4d52-a00e-58e0f2770715
@time [streamRef(() -> primes2Stream, i) for i in 0:4]

# ╔═╡ a54bcfbe-f5f4-4066-b8d7-af3d053ae221
@time [streamRef(() -> primes2Stream, i) for i in 0:5]

# ╔═╡ 6c76e330-f30a-4baa-bbdf-7f9d8ff178a4
@time [streamRef(() -> primes2Stream, i) for i in 0:6]

# ╔═╡ ee28f02e-fd50-4a26-844b-16a30453cb53
@time [streamRef(() -> primes2Stream, i) for i in 0:7]

# ╔═╡ b48b3505-3958-4f7b-a48c-9d44fccb1031
@time [streamRef(() -> primes2Stream, i) for i in 0:8]

# ╔═╡ 204546c0-0fcf-4564-a6d8-1c49037257bf
@time [streamRef(() -> primes2Stream, i) for i in 0:9]

# ╔═╡ e8b3d3d0-048e-4a7d-bee2-33bc90ae0ac9
@time [streamRef(() -> primes2Stream, i) for i in 0:10]

# ╔═╡ a53e08c9-a7ac-40ce-908f-f253e58d437c
@time [streamRef(() -> primes2Stream, i) for i in 0:11]

# ╔═╡ 761c42bc-a911-46b2-9ae5-54b44b255721
@time [streamRef(() -> primes2Stream, i) for i in 0:12]

# ╔═╡ a60ebc6a-b5a3-4c2c-8af8-efcde5d7d080
@time [streamRef(() -> primes2Stream, i) for i in 0:13]

# ╔═╡ a50ba91d-26a3-495c-9665-b420f0833a7f
@time [streamRef(() -> primes2Stream, i) for i in 0:14]

# ╔═╡ f3e09167-dac7-4cd0-8a04-29e5ac25177e
@time [streamRef(() -> primes2Stream, i) for i in 0:15]

# ╔═╡ 2990ac7f-7563-47c7-b5ef-8877545f679f
@time [streamRef(() -> primes2Stream, i) for i in 0:16]

# ╔═╡ 5aaafb7f-08ca-4253-9c4e-b14f019c51d8
primes2Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53]

# ╔═╡ de9af253-6a0f-4184-a192-2cda4c3267af
length(primes2Array)

# ╔═╡ 9e0370c8-aca6-43e0-98fb-dcbac577ed93
	secs2Array = [ 0.026640,
		0.023324, 0.018580, 0.017353, 0.017084, 0.016607,
		0.016733, 0.027601, 0.017452, 0.022618, 0.019959,
		0.030193, 0.019215, 0.028774, 0.028563, 0.072415]

# ╔═╡ 4ba3a6ad-2ef0-4add-adce-9727a5a1b629
length(secs2Array)

# ╔═╡ 98183b05-7f42-486e-92ce-b6be7aed6dba
	mib2 = [5.88,  5.88,  5.88,  5.88,  5.89,  
		    5.89,  5.90,  5.90,  5.91,  5.92,  
		    5.93,  5.94,  5.95,  5.96,  5.97,
	        5.99]

# ╔═╡ ddd3f56b-31e1-4e0e-aa3d-44617e434433
length(mib2)

# ╔═╡ a07ee1ce-587d-4cd9-a0c6-79c7027cfac6
let
	plot(primes2Array, secs2Array, label="secs2", xlabel="no of primes ps > 1 found",
		ylabel="secs", linewidth=1, line=:red, framestyle=:semi, title="Runtimes of Stream-Sieve-Of-Erathostenes 2")
end # let

# ╔═╡ ca2ccffe-985d-4937-bfdb-181b2c43d586
let
	secs1ArrayEX = append!(secs1Array, [298.892458,298.892458,298.892458])
	plot(primes2Array, secs1ArrayEX[1:16], label="secs1", xlabel="no of primes ps > 1 found", ylabel="secs", linewidth=1, line=:darkblue, fill=(0, :lightblue), framestyle=:semi, title="Runtimes of Stream-Sieve-Of-Erathostenes 2")
	plot!(primes2Array, secs2Array, label="secs2", linewidth=2)
end # let

# ╔═╡ 45f135dc-9d75-4f07-bbae-4dd8cdef8820
md"
The *2nd* method is far more *time-efficient* than the *1st*, but we suffer a *stack overflow*.
"

# ╔═╡ 515badcb-1370-4d5a-afbb-417e66e0f900
let
	plot(primes2Array, mib2, label="MiB 2", xlabel="no of primes ps > 1 found", 			ylabel="MiB", linewidth=1, line=:red, 
		framestyle=:semi, title="Storage of Sieve-Of-Erathostenes 2")
end # let

# ╔═╡ 3da354dc-ac1a-414f-bf22-3bd6b6f22a13
let
	plot(primes2Array, append!(allocsM1Array,[1590.0, 1590.0, 1590.0])[1:16], 
		label="MiB 1", xlabel="no of primes ps > 1 found", ylabel="MiB", linewidth=1, line=:darkblue, fill=(0, :lightblue), 
		framestyle=:semi, title="Storage of Sieve-Of-Erathostenes 2")
	plot!(primes2Array, mib2, label="MiB 2", linewidth=2)
end # let

# ╔═╡ 3446b2f6-4cc0-49d7-b766-e10630893928
md"
---
##### Summary ##### 
Though the 2nd implementation with Julia *iterator* is far more *time-* and *storage-efficient* than the 1st it suffers from *stack-overflow*. We shall try to fix that with *tail-call-optimization (tco)* by detouring with *trampolining*.
"

# ╔═╡ 144250e1-e73e-4fe7-b0e5-68f19d4be28c
md"
---
##### References

- **Wikipedia**; [*Fibonacci Sequence*](https://en.wikipedia.org/wiki/Fibonacci_sequence); last visit 2023/08/08
- **Wikipedia**; [*List of Integer Sequences*](https://en.wikipedia.org/wiki/List_of_integer_sequences); last visit 2023/07/29
- **Wikipedia**: [*Sieve of Erathostenes*](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes); last visit 2023/07/30
"

# ╔═╡ f6896f0e-ff38-4f5a-86f3-dca9921d3e14
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
Plots = "~1.38.17"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "6d92833399d4278ef247d831524369b9da7fbbce"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "dd3000d954d483c1aad05fe1eb9e6a715c97013e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.22.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "5ce999a19f4ca23ea484e92a1774a61b8ca4cf8e"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.8.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cf25ccb972fec4e4817764d01c82386ae94f77b4"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.14"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f61f768bf090d97c532d24b64e07b237e9bb7b6b"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1aa4b74f80b01c6bc2b89992b861b5f210e665b5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.21+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c4d2a349259c8eba66a00a540d550f122a3ab228"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.15.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "2222b751598bd9f4885c9ce9cd23e83404baa8ce"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.3+1"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─d7a858c0-2ba0-11ee-05d3-b1fd5e652709
# ╠═97fdcd00-a8e9-4d48-ac78-d386240e021c
# ╟─6b87a14e-db96-4c34-85de-74c0eedd947b
# ╟─a9507893-d5dc-4642-ad40-16608e319de1
# ╠═6bcc5da3-74fd-4f8a-be7d-08cea9be7385
# ╠═91eacaa7-3e22-406b-b0b2-c4b88c789d41
# ╠═774d7a51-4875-4e22-b4c2-3a4e48022259
# ╟─a69c5ea3-cdee-4fff-bd92-28c65dc1796b
# ╠═7b95ae3a-1151-499d-bbac-cf123d93cd35
# ╠═08c2c8e9-490f-48d9-b681-38354373cc51
# ╟─2c643f4a-e1df-48dd-b772-a10d028d6d27
# ╠═7303b132-17bf-435c-8e93-a546d7989d3f
# ╠═692df292-5ed0-46cc-b301-758341785b93
# ╟─d3dd7622-6a82-4ea2-a88f-45b1a7ced016
# ╟─9de5244b-1437-4369-b877-17703ebffe5b
# ╠═15c00413-400a-4140-a994-2c79f592794f
# ╟─f64e3348-cf23-4aab-a0ba-fbd93a4af378
# ╠═b8747411-09aa-4c55-964a-70251a15b98b
# ╟─449fc579-58bd-4b45-bd90-30afaf601ea4
# ╠═2614347f-4772-48b9-9926-b6e58e8752dc
# ╠═14b3cd5a-60a3-478d-9169-07dec0188fff
# ╠═c7a89432-4ad7-4694-ac9d-b1e4d3215bdb
# ╠═0d072279-4968-468b-9ab5-345a6be7228f
# ╟─5abb9916-0991-4dd6-8827-55b021e5667f
# ╠═753f86e9-3ed4-4fba-b325-07a76316eee7
# ╠═9c99dbdd-094b-48e3-aed1-d04b378645b7
# ╠═c82706be-e538-4757-99c4-41bbfa2de5a3
# ╠═b7e0835b-415b-473f-abe4-710dfd16891d
# ╠═b455b2e3-454f-4299-b671-29ab381be71f
# ╠═d1af551b-4c48-475a-9463-b9c062623852
# ╠═e891841c-d1a2-44cc-aeae-3c03bfec142e
# ╠═f4ea8760-9077-4231-bb1f-01b95e8a14f6
# ╟─8f734bd2-e460-4de2-8bac-12c065376c04
# ╠═8c7d7ccf-6d60-4fff-a089-c03ebe9f0858
# ╟─484b328a-f060-4d31-b9e4-c70f4f155a1b
# ╟─aebb3512-3d4b-47d7-8035-013f59960de7
# ╠═ac70da16-801a-4ea4-8dc1-79cb7a5d84c2
# ╠═df518f02-1121-4d8d-bad9-190db5f2343d
# ╠═bf294711-fad1-4cbd-b394-4701653bde06
# ╠═5a4914af-17b3-4201-9d5a-5f4ff1fa5722
# ╠═44b89b7d-a800-4a0f-8af1-a99e1d8dcfb8
# ╠═6d998db2-4de8-46e4-ad96-c2ead8a128ad
# ╠═034b21ab-f8cd-47cd-8b1d-c8498162b124
# ╠═7c7ded6f-488c-41a0-881f-7ad5a947ca0d
# ╟─fe2aa340-29b1-40d6-8ff6-25b41772f345
# ╠═d4d5e04e-c460-43a7-942e-5cdac3a05d10
# ╠═c8b224e9-7794-4bee-aabb-01b51a74d528
# ╠═aebd9c74-4849-4b86-a0b0-3ada5d523581
# ╠═de2bcf75-0ecf-404c-bd0a-3811ea156baf
# ╠═1d43986c-515b-4f75-9164-8afdfef0dc7c
# ╠═f031c6c8-df9e-4c66-ab6b-e42696ab0f66
# ╠═ff91559b-1d4f-4769-83eb-5de8ea5dd777
# ╠═c88efbe0-5920-4707-b9e0-ef9ec2550b9d
# ╟─b297e3ff-3159-440d-aca8-920988d3c584
# ╠═ab51084e-ddb1-4fe2-b13f-84d401da6d62
# ╠═db1cd319-0202-40fe-9925-ee44d4bd2e1e
# ╟─e9f3c3b5-5ea9-45f3-8eee-2e2fe1f2e448
# ╠═7cbe6f94-1b73-4a1f-8e21-d8d562b104a3
# ╟─b9fa2f72-2925-4b58-bcf5-7544c82a1969
# ╠═f1973df2-4539-4d37-bcbb-625d0b1dc570
# ╠═358306a8-da75-45cf-8ab4-7882f80b943f
# ╟─72998046-3ba4-420b-9eb2-2d615be8da0c
# ╠═c6ae9a79-0773-464a-9f7c-22a0d261cace
# ╠═b8df023c-736b-48c7-9fea-d48018040466
# ╠═82ef96cc-2a7b-4868-8e6c-8d8524e80ae1
# ╠═17acd73c-bb18-473b-b52e-aeb73c2931ce
# ╠═62c92a48-4d45-48e2-81ce-ca81162d0e27
# ╠═0bc660ec-6df9-46df-8939-79636b05bb13
# ╠═06dbdc2d-24d7-447a-9486-43c28898878e
# ╠═75433a74-9295-4a85-85b0-e3588ef7050c
# ╠═c528fc10-4a13-4fb7-a3d9-cf8838d15e81
# ╠═d6bd7332-7cad-4438-a582-642e521013ec
# ╠═2b56575a-0117-40c7-8ef7-387cf7911dad
# ╠═33fd6312-1cf9-4e45-8bbc-120fa50f7c7c
# ╠═d3827dc9-54cb-4864-824d-b431587d6cb3
# ╠═93c41001-9534-40a3-947c-2e1c71c32c03
# ╠═bc3065ee-71b6-42f9-bee3-c7682b24651d
# ╠═55ae1274-b6ca-467e-9547-cd432b3ebbb6
# ╠═694fc4a9-e532-4127-8cd2-7df0d85c2cd5
# ╠═6321ff6a-a5c3-4e99-86c0-03525742d9e3
# ╠═5812f40b-bfeb-4dfd-87ba-d5d0eb65c743
# ╠═b86a4021-b75e-42c5-a6e6-41bdd6c1e6b2
# ╠═b0f05ecb-f80a-47fc-90c4-a511ab789ec4
# ╠═282d373f-2335-4ed2-965a-ea030c52f0b3
# ╠═80fdf4bf-832d-4e05-b68f-a1d965b54169
# ╠═ff06c74e-581c-42b5-938e-99bdfd0e36e3
# ╠═3699e053-ea50-47f3-8ebd-1cc9b05584fd
# ╠═214cd340-c183-437e-b964-7fa35dd3b405
# ╠═227e7d7e-f868-419a-ba1b-c91425db0c9e
# ╠═bf6e3ff6-f824-45f3-8d92-49a1e03d6e0f
# ╟─a5b8d317-8b91-4637-8cac-4fa9390a8e3e
# ╠═db18ae0e-b60d-4604-bebc-6b085f2b8e4d
# ╠═0188c7f8-65e8-4c6b-83b0-bd88a41787dc
# ╠═62e64949-3739-494f-a9d0-d4a062b0b631
# ╠═236ec613-efb4-4854-b1e8-992554160dbb
# ╠═0423152f-1d87-45c5-be21-d6880bb25b4a
# ╠═3c33fc61-5ff0-402c-b042-c21eea449b7e
# ╠═ef9374d4-74b2-4be1-a9fe-08da1ac1b37e
# ╠═4bac2130-9a3c-4f54-b0c4-251b9729cd50
# ╟─b8425ebe-6fc9-4ba1-a1d8-335a1dfd330d
# ╠═d6175151-c72e-475a-88b8-82a777227bb7
# ╟─4c90852b-a23f-4b7e-b15d-ea1673806b49
# ╠═c5130a74-7a54-4ef6-b19f-73bfb992e0aa
# ╟─658f1c3f-7859-40be-a3d4-51fe511195cb
# ╠═33ff0c2b-b3b0-4c57-abaf-e34bf54a7ef7
# ╠═4f67ef26-a4b5-4fa4-9698-0774e2e3db9e
# ╠═34989762-4f2c-4af5-a771-c1a25929a831
# ╠═c0ec1a1e-75e0-4bd7-9665-035231f7589a
# ╠═988f98f8-833d-43b3-bf43-d21eab3ced8f
# ╠═c14ba599-2689-41bd-9059-40cbc5e4b42b
# ╠═417c3e91-7300-41f5-b099-44ad139d098f
# ╠═a98defe8-630d-49f6-a913-7ca9f81f7b8b
# ╠═36158cc6-5828-4ddf-b402-cac77693d731
# ╠═2c90ea62-0924-4c34-a7b2-0f8ddcdb51e4
# ╟─aaba104f-764f-459b-864a-97273bf3edf2
# ╠═b6259cb0-618c-400d-9425-e60b3c96be5d
# ╠═349d7bac-9d99-42d5-af76-0f5c13a3de54
# ╠═0af82e2f-3b3c-47a1-9353-27ba95376a53
# ╠═951884b8-6d58-4016-b0f6-1c5a9f5aa107
# ╠═2cbd1448-5afa-4ca4-b38c-6479b44d603a
# ╠═5ae16a69-e233-4614-9d4f-44cb61fafb4b
# ╠═b7b0f7f3-6171-4f97-9a60-89ded4e16b8c
# ╠═9c4792ac-63d8-4f63-a0f9-91a16b4deb24
# ╠═436975dd-1225-4707-8e77-59a1852eb37f
# ╠═07f20823-4478-40cd-abb5-3d8a83947d26
# ╠═6018a7b2-2f8d-4823-8f13-96ce59f6859f
# ╟─2ef4c71f-0aca-4246-ae49-87986dadcc36
# ╠═0b6aad89-9b6b-4528-8b54-d059fe80c8da
# ╠═ab05aff1-9c25-46ae-8a4f-513d204abc92
# ╟─c2805c10-87c5-401b-a668-c2e21a47d334
# ╠═e0d6f2b4-8a2e-4bac-af8c-f62a4e63bdd4
# ╟─26ef08b8-9e5a-45ca-8e72-6910b42f0f6c
# ╠═849a7a65-9b4e-4d99-9828-1a4828723d15
# ╠═73205c79-d093-4d39-94b0-fa81994b9be5
# ╠═eb9a6526-a290-41b3-8b06-c2f4fd07ed9e
# ╠═68114b3e-5348-4d02-b288-ac08bf344624
# ╠═3aaa324e-8c5e-404f-b84e-1aee4ae264d6
# ╠═aa33e4ae-7e35-44d5-a893-f9455a0fca29
# ╠═774dec49-dc11-482f-a786-cbc98f64c3ed
# ╠═65b08e54-bc56-4277-b7ab-83bc15b036cb
# ╠═f5ee7506-5854-45dc-91f2-dabfd2cb0459
# ╠═ae100ce2-f235-487b-9783-fa36c520307e
# ╠═5317eed5-8102-4e1d-b26e-383eb214fd80
# ╠═ad285d2a-05a8-4081-a4bf-a130991ecd80
# ╠═227521b9-2b15-4464-9a1e-4cd98f824fd1
# ╟─5f85bd19-8e21-4a6c-98c2-df41e8f1290d
# ╠═472a9c05-5353-4fd5-a9c3-723d0a076a11
# ╠═8f783495-2be3-46af-8a7d-8f6c2fcec055
# ╠═751a7f65-a352-4541-9a48-cf794123fafb
# ╠═f57a119a-c27b-4a99-aa3f-faf6f392ffcf
# ╠═8db31663-503e-40aa-8926-1d713d00f587
# ╠═2b6b7be7-bf11-424e-9e14-8532ef644a9c
# ╠═6fa7bcf6-30ec-451e-9e68-8c05e959f273
# ╠═f1aec2ab-15c7-4d61-9dd8-21b46de11840
# ╠═86de31dc-d2eb-40cb-a281-d9fb62fcad30
# ╠═30f0b494-c962-4dcc-9f8a-75ecc99cf989
# ╠═2fec1003-121c-48b1-bc1b-0850dd5e07cc
# ╠═69009574-7304-467d-86fa-cab18cd02ff7
# ╠═bc7e7b1f-cf8d-43eb-8e05-5ceceef9681d
# ╠═95441662-4297-4298-b34e-45dddedc3af6
# ╟─9d0985e8-f6ae-4dc4-af2d-aa602e38d7cc
# ╟─38cc3f84-7c55-4280-9bd0-5a849da99e93
# ╠═83820d03-3d3f-4db1-a16c-e9910eb99bb5
# ╠═0c399c6b-3141-4501-9aaa-b7e1bc8c4a21
# ╠═911a9301-2522-4857-8c2c-bd5b9ed0f0ca
# ╠═6bda6ec5-fdd5-4733-8ebf-7cfa1b52cbe6
# ╠═897a75ca-0f0a-4363-a6e2-776cacea7118
# ╠═985a8e78-cb5e-490e-8fc3-3630df2eb150
# ╠═d82aef76-c98f-459f-ac28-f5529aadf198
# ╠═e41b84a6-59c2-4d52-a00e-58e0f2770715
# ╠═a54bcfbe-f5f4-4066-b8d7-af3d053ae221
# ╠═6c76e330-f30a-4baa-bbdf-7f9d8ff178a4
# ╠═ee28f02e-fd50-4a26-844b-16a30453cb53
# ╠═b48b3505-3958-4f7b-a48c-9d44fccb1031
# ╠═204546c0-0fcf-4564-a6d8-1c49037257bf
# ╠═e8b3d3d0-048e-4a7d-bee2-33bc90ae0ac9
# ╠═a53e08c9-a7ac-40ce-908f-f253e58d437c
# ╠═761c42bc-a911-46b2-9ae5-54b44b255721
# ╠═a60ebc6a-b5a3-4c2c-8af8-efcde5d7d080
# ╠═a50ba91d-26a3-495c-9665-b420f0833a7f
# ╠═f3e09167-dac7-4cd0-8a04-29e5ac25177e
# ╠═2990ac7f-7563-47c7-b5ef-8877545f679f
# ╠═5aaafb7f-08ca-4253-9c4e-b14f019c51d8
# ╠═de9af253-6a0f-4184-a192-2cda4c3267af
# ╠═9e0370c8-aca6-43e0-98fb-dcbac577ed93
# ╠═4ba3a6ad-2ef0-4add-adce-9727a5a1b629
# ╠═98183b05-7f42-486e-92ce-b6be7aed6dba
# ╠═ddd3f56b-31e1-4e0e-aa3d-44617e434433
# ╠═a07ee1ce-587d-4cd9-a0c6-79c7027cfac6
# ╠═ca2ccffe-985d-4937-bfdb-181b2c43d586
# ╟─45f135dc-9d75-4f07-bbae-4dd8cdef8820
# ╠═515badcb-1370-4d5a-afbb-417e66e0f900
# ╠═3da354dc-ac1a-414f-bf22-3bd6b6f22a13
# ╟─3446b2f6-4cc0-49d7-b766-e10630893928
# ╟─144250e1-e73e-4fe7-b0e5-68f19d4be28c
# ╟─f6896f0e-ff38-4f5a-86f3-dca9921d3e14
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
