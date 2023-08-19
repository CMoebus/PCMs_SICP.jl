### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 3f4e0f62-36cd-11ee-3b4b-19a4a6b34ac4
md"
====================================================================================
#### SICP: 3.5.2.2 Infinite Streams II: Trampoline and Iterators
##### file: PCM20230809\_SICP\_3.5.2.2\_Infinite\_Streams\_II.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/08/19 ***

====================================================================================
"

# ╔═╡ c639ea45-04d1-4b43-918b-4df56cd7e7bd
md"
---
###### Types
"

# ╔═╡ 8ce48325-a83b-40dd-a99c-4498b5461138
UnOfUnRaTaFiDroRes = Union{UnitRange, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop, Base.Iterators.Rest}

# ╔═╡ 45ff2260-0cd4-40b2-98fb-a6d2665f2631

md"
---
##### 3.5.2.2.1 SICP-Scheme like functional Julia
##### Basic Scheme-like Functions
"

# ╔═╡ e5660842-469f-4572-a08f-83975aeb8295
md"
---
###### Constructors
"

# ╔═╡ 3d660697-61ee-4da5-bd99-859f0c7445ef
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ deb96bbb-3e3b-4967-8e22-0a28168b91fa
ConsOrUnitRangeOfIntegers = Union{Cons, UnitRange{Int64}}

# ╔═╡ f1dc9fa2-63d6-4a3f-b093-4803aff92b4c
cons(car, cdr) = Cons(car, cdr)   

# ╔═╡ 02c3f6f0-177f-4ac5-811a-d64f9c4eb32f
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

# ╔═╡ 124a276b-0081-4ac9-a8c5-e45155f426dc
md"
---
###### Selectors
"

# ╔═╡ 8a7c6bc1-0083-44c0-b67a-b0b42506cc67
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ 60b73cd1-7b64-458c-b9eb-cbeedda08112
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 9051fef4-d10d-4aa7-98bc-df045512af0e
md"
---
###### Predicates
"

# ╔═╡ 1911ae4b-0a39-47ab-a3a6-2f62839cced6
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ 7ef26cc3-b773-4aae-a035-9bc1c8e5de33
md"
---
##### 3.5.2.2.2 Streams with $delay$ and $force$
"

# ╔═╡ 3c4fcd33-fb39-4330-8b86-5cb5b0cb4dd3
md"
---
###### $delay$ and $force$

(SICP, p.323f)
"

# ╔═╡ f6b3c8cc-b81c-4065-9a00-02fba3472048
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

# ╔═╡ db173a72-3586-4ca6-a051-9a7300e75b4a
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $arg of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 4541035e-5d5d-48d9-8771-d1d3ea6129b8
md"
---
###### Constructors
"

# ╔═╡ f2182c81-b268-457d-95af-714925ad9c2f
theEmptyStream = list(:nil)::Cons                         # SICP, p.319, footnote 54

# ╔═╡ ce4857dc-e00a-4849-9c6c-55a9624ed692
begin
	#===============================================================================#
	# method 1: Function -> Cons
	#--------------------------------------------------------------------------------
	function streamCons(x::Int64, closure::Function)::Cons # SICP, p.321, footnote 56
		cons(x, delay(closure))
	end # function streamCons
	#===============================================================================#
	# method 2: UnOfUnRaTaFiDro -> Cons                   # SICP, p.321, footnote 56
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

# ╔═╡ be498571-4ab5-41d3-992d-06e5743cd560
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

# ╔═╡ a1ee6f1a-0f20-4185-83f1-ac346df646a3
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

# ╔═╡ 9e487f14-84b8-460c-a340-9d2e5a2bd399
md"
---
###### Selectors
"

# ╔═╡ 4f2fb7e4-1066-4a83-b2fa-e1c077fffcfd
begin
	streamCar(stream::Cons) = car(stream)                      #  SICP, p.319
	streamCar(stream::UnitRange{Int64}) = Iterators.first(stream) 
	streamCar(iter::UnOfUnRaTaFiDroRes) = Iterators.first(iter)   # from ch. 3.5.2.1
end # begin

# ╔═╡ 82f06c4a-3246-4817-9673-b0c9fda3029e
begin
	streamCdr(stream::Cons) = cdr(stream)                      #  SICP, p.319
	streamCdr(iter::UnOfUnRaTaFiDroRes) = Iterators.drop(iter, 1) # from ch. 3.5.2.1
end # begin

# ╔═╡ 591eca93-ffdb-4c08-acf9-9263adb588b7
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

# ╔═╡ b51b08b3-9991-40a0-a9bb-13ee5b33f3fe
md"
---
###### Predicates
"

# ╔═╡ 1cabcb03-4251-4daf-95a7-3f1abb708fc4
streamNull = null   

# ╔═╡ 06565202-4426-4cc3-8155-c01f2f56c336
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

# ╔═╡ 37200b80-448d-4658-94e4-f2a4943ed172
md"
---
###### Test Applications
"

# ╔═╡ fe8daa11-cc5e-4555-81cb-cc2d20133b97
typeof(Iterators.filter(isodd, 1:30)) <: Base.Iterators.Filter <: UnOfUnRaTaFiDroRes

# ╔═╡ 77ae90a6-adfc-4f72-8b3c-e33785955bd2
streamCons(2, Iterators.filter(isodd, 1:30))

# ╔═╡ 965b5910-cb7f-4929-ab2b-a7a5f809c296
typeof(streamCons(2, Iterators.filter(isodd, 1:30))) <: Vector{Int64} 

# ╔═╡ facf846c-224a-40a8-8983-cab9d268f113
[streamRef(
	() -> streamFilter(
		iseven, 
		() -> streamEnumerateInterval(0, 21)), i) for i in 1:10]

# ╔═╡ 94df8860-73bc-4fec-a3e0-196b37ef6955
streamRef(streamEnumerateInterval(0, 100), 99) # test call with wrong argument

# ╔═╡ 30794155-76b7-422d-ac38-c449798d6f87
streamRef(() -> streamEnumerateInterval(0, 100), 99) # syntax correct argument

# ╔═╡ c2addf90-9a20-4f2f-bd40-3c0a7c65a6aa
streamNull(streamEnumerateInterval(0, 0))

# ╔═╡ 7dceef0f-fb3b-46d3-a2b4-270cf936efb1
integersStartingFrom(0)

# ╔═╡ f55c20de-dd40-41be-b2f7-1146f76e52f2
integersStartingFrom(0, outputType=:Cons)

# ╔═╡ 9944ed75-7bc7-40b1-b514-55afec40df59
integersStartingFrom(0, outputType=:UnitRange)

# ╔═╡ 125171e0-6441-4b7e-b01b-20bea8df604c
md"
---
##### 3.5.2.2.3 Tail Call Optimization (*TCO*) by Detouring with [*Trampoline*](https://en.wikipedia.org/wiki/Trampoline_(computing))

"

# ╔═╡ 2e2c39a1-cc11-44f2-b78a-3e031ec18f22
function trampoline(closure)             # closure === delayed tail recursive call
	while typeof(closure) <: Function
		closure = closure()              # tail recursive call
	end # while
	value = closure                      # return value of last tail-recursive call
end # function trampoline

# ╔═╡ f586edb5-904c-4bf4-b515-f3cdb7b6e52c
md"
---
###### Example: Sum of $1...i...n$ :

$sum = \Sigma_{i=1}^n i \;\;\;\text{ ;; }\text{ for } \; n \rightarrow \infty$

$\;$

---
###### Recursion with *trailing* addition (not suitable for *trampoline*).

"

# ╔═╡ 8d352277-911f-431b-8767-8590960d0d1d
function sum(n)
	if n == 0 
		n 
	else 
		sum(n-1) + n
	end # if
end # function sum

# ╔═╡ 472d4c25-8fe6-40d3-a40c-f5462f90e9c5
@time sum(convert(Int, 1E1))

# ╔═╡ 6183a89d-b08a-4e3c-9233-aa7c64aea328
@time sum(convert(Int, 1E2))

# ╔═╡ 659cad7e-a80b-4d1a-926a-7fd753bb3fc6
@time sum(convert(Int, 1E3))

# ╔═╡ 1bbc1033-8b4b-4c00-a178-a61d41a14fb6
@time sum(convert(Int, 1E4))

# ╔═╡ 9a669429-3221-48fe-a034-caf3a470009e
@time sum(convert(Int, 1E5))        # in Julia this could be avoide by trampoline

# ╔═╡ 9294a584-bd22-4e9b-980a-138fec35f886
md"
---
###### *Tail-recursive* Solution (one step before being suitable for *trampoline*)
Because *Julia* has in contrast to *Scheme* *no* TCO tail recursion doesn't avoid a growing stack. That is the situation where to use a *trampoline*.
"

# ╔═╡ e924d99d-e4c7-4253-8df8-ebfa55a62f89
function sumTailRecursive(n::Integer; acc=0)
	if n == 0 
		acc 
	else 
		sumTailRecursive(n-1::Integer, acc = acc + n)
	end # if
end # function sumTail

# ╔═╡ 49f0ae83-4a20-4d44-9ecc-57f048cba34f
@time sumTailRecursive(convert(Int, 1E1))

# ╔═╡ f803bf9e-62c4-4b20-bf72-53b9c7d00c74
convert(Int, 1E4)

# ╔═╡ eb0e8fd2-3b65-4c59-b42e-2038f9cfd1ac
@time sumTailRecursive(convert(Int, 1E4))

# ╔═╡ acf7e66a-0b32-452f-b53d-07cbc9b1aa8a
convert(Int, 1E5)

# ╔═╡ 8b879cd6-acd8-4274-a112-cabb0181c0d5
@time sumTailRecursive(convert(Int, 1E5))

# ╔═╡ 8204e709-ce1f-4e83-9fbc-df881dc812bb
md"
---
###### *Tail-recursive* solution $sumTailTrampoline$ (suitable for *trampoline*)
The tail-recursive call is embedded in a *delaying* closure.
"

# ╔═╡ 0b920d17-aa10-4e8c-bca8-ecefffdc758f
function sumTailRecursiveTrampoline(n::Integer; acc=0)
	if n == 0 
		acc 
	else 
		# delayed by closure
		() -> sumTailRecursiveTrampoline(n-1::Integer, acc=acc + n)   
	end # if
end # function sumTailRecursiveTrampoline

# ╔═╡ 7381aad8-baf2-42d9-b9f3-6aea9801845e
typeof(() -> sumTailRecursiveTrampoline(convert(Int, 1E5)))

# ╔═╡ 7ef50667-9b82-46c4-b49c-4aacd03a4fd1
typeof(() -> sumTailTrampoline(convert(Int, 1E5))) <: Function

# ╔═╡ 1a184224-a09f-4209-bb8b-3a30d897916c
typeof(() -> sumTailTrampoline(convert(Int, 1E5))) == Function

# ╔═╡ 8ca00e7d-b58a-464e-a95e-13a103da70e1
@time trampoline(() -> sumTailRecursiveTrampoline(convert(Int, 1E4)))

# ╔═╡ ddf5c39b-f8a6-45fb-9263-c1e361126a91
@time trampoline(() -> sumTailRecursiveTrampoline(convert(Int, 1E5)))

# ╔═╡ 728f6b5f-b79f-4a02-9aab-55bf624b40ce
@time trampoline(() -> sumTailRecursiveTrampoline(convert(Int, 1E8)))

# ╔═╡ 8f9f773e-1263-4155-a64c-83a5ea6533d5
md"
---
###### Trampolined version $streamRefTrampoline$ of $streamRef$ 
" 

# ╔═╡ 2f0dc600-be17-4cf5-b8a4-134e07f9b93e
begin
	#-------------------------------------------------------------------------------
	function streamRefTrampoline(stream::Function, n::Integer)         #  SICP, p.319
		if ==(n, 0)
			streamCar(force(stream))                                 
		else
			() -> streamRefTrampoline(streamCdr(force(stream)), -(n, 1))     #  new: 'force'
		end # if
	end # function streamRefTrampoline
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ b8aa300f-7074-4b82-9773-dbd7658e6506
md"
---
###### $sieveTrampoline$
"

# ╔═╡ 9b6c4b24-8b49-4680-97c2-518a86e16860
	function streamFilterTrampoline(pred, stream::Function)::Cons  # SICP, p.322
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
	end # function streamFilterTrampoline

# ╔═╡ b8cfa618-f9cb-4808-b00b-9be7e49481cc
md"
---
##### 3.5.2.2.4 *Iterators*-based *Sieve of Erathostenes*
"

# ╔═╡ 32d365d8-9a7b-4da8-86eb-d949b408c9f4
function divisible(x::Integer, y::Integer)::Integer           # SICP, p.326
	rem(x, y) ≡ 0 ? true : false
end # function divisible

# ╔═╡ 9e48c1c2-62cc-4330-9a22-bfe9d4482a6c
begin 
	#-------------------------------------------------------------------------------
	function sieveTrampoline(stream::Function)::Cons                 # SICP, p.327
		streamCons(
			streamCar(force(stream)), 
				() -> sieveTrampoline(
					() -> streamFilter(
						(x) -> !(divisible(x, streamCar(force(stream)))), # predicate
						streamCdr(force(stream)))))               # shortened stream
	end # function sieveTrampoline
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 0f256ae2-a39d-466a-961b-a7e477958d8b
md"
---
###### $sieve$: *1st* variant of $sieve$ for input type $Function$ (= *Closure*)
The goal of evaluating the *Scheme* expression $(stream\text{-}ref\; primes\; 50) \Rightarrow 233$ within reasonable runtime (SICP, p.327) *cannot* be achieved by this variant of $sieve$.
"

# ╔═╡ 9ca42a74-c351-46df-97f8-71ad47134aa6
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

# ╔═╡ 5627db49-e1ae-4b20-bbb0-46e0f515b7e4
integersStartingFrom2 = integersStartingFrom(2)

# ╔═╡ 1be244fd-de36-46c2-ae83-87f8d9d10d80
integersStartingFrom2

# ╔═╡ f6b449ba-9b62-4b84-b163-d3595cecd791
typeof(integersStartingFrom2)

# ╔═╡ c522564e-9171-4bde-bb78-776213096f72
streamRef(integersStartingFrom2, 999)

# ╔═╡ 78d8833c-062d-4a16-bd2a-50aab61e260c
@time streamRef(integersStartingFrom2, convert(Int, 1E8) -1)

# ╔═╡ 6bd33e68-3504-47bb-bea1-e60d76586ad1
let stream = () -> integersStartingFrom2
	streamCar(force(stream))
end # let

# ╔═╡ 0f8b52d4-fda9-47c9-ad89-77495b3c9174
trampoline(() -> streamRefTrampoline(() -> integersStartingFrom2, 0))

# ╔═╡ e3cc4c42-24ec-48d1-b4c2-9b9bf5ea5f88
trampoline(() -> streamRefTrampoline(() -> integersStartingFrom2, 999))

# ╔═╡ 2b8d2327-d77f-491c-98dc-228274ec840c
@time trampoline(() -> streamRefTrampoline(() -> integersStartingFrom2, convert(Int, 1E8) -1))

# ╔═╡ d20c6fff-5045-4fed-9d5f-e9d43d951ff4
primes2StreamTrampoline = 
	trampoline(() -> sieveTrampoline(() -> integersStartingFrom2))

# ╔═╡ 47c56fac-291f-44f6-97b0-c98160b949ef
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:0]

# ╔═╡ 2a932666-a2fc-4adb-ac36-7153e034f613
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:1]

# ╔═╡ e286d1c8-eeb1-488e-9d83-2ca8d5c702dd
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:2]

# ╔═╡ 81a66a43-3e11-4076-a90c-3f651197f0ee
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:3]

# ╔═╡ f5444fae-943b-48ef-b242-8c49d7a5dbbc
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:4]

# ╔═╡ bd7fd23d-d4e3-471b-91bb-48c92cb678ac
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:5]

# ╔═╡ 72fab2b3-4266-4b0a-8cb3-a9048658cc39
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:6]

# ╔═╡ 5ab63588-8587-4b04-9613-9a921b991421
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:7]

# ╔═╡ 0184f96f-cc01-4b49-8e95-93ce2c1a761a
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:8]

# ╔═╡ b8466b53-ca74-48d5-972c-c8270f243124
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:9]

# ╔═╡ 54d1dc87-9b6d-4bdc-b1a5-e987a187b0e4
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:10]

# ╔═╡ 3fdf383d-affc-4d3b-a1a9-1bce409167af
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:11]

# ╔═╡ d950121b-23c4-417f-8bd4-95cb33a71ba7
@time [trampoline(() -> streamRefTrampoline(() -> primes2StreamTrampoline, i)) for i in 0:12]

# ╔═╡ a5f5b08f-0c70-4734-8843-e9ada8fcf87f
integersStartingFrom2Closure = () -> integersStartingFrom2     # SICP, p.327

# ╔═╡ 0d6adf8d-dfdc-473d-9c92-01dd80816465
primes = sieve(integersStartingFrom2Closure)::Cons             # SICP, p.327

# ╔═╡ 6f89ca1b-cdf3-4443-b12a-8cac90179be7
@time streamRef(() -> primes, 9)

# ╔═╡ ed41bb38-6cf5-4a32-bc17-7c4ef96a43ef
@time [streamRef(() -> primes, i) for i in 0:9]

# ╔═╡ c65ca425-18f1-45a1-96e4-84db9303959b
@time [streamRef(() -> primes, i) for i in 0:10]

# ╔═╡ 23d9e59c-6196-46ee-a09c-e36c97e8572c
md"
---
###### $Sieve2$: *2nd* *Iterators-based* variant of $sieve$ for input type $UnOfUnRaTaFiDroRes$

The goal of evaluating the *Scheme* expression $(stream\text{-}ref\; primes\; 50) \Rightarrow 233$ within reasonable runtime (SICP, p.327) can only be achieved by this variant of $sieve$ by including a *sequence* of $50$ *iteration steps* in the body of the function: 

$(head_{i+1}, rest_{i+1}) = unCons(Iterators.filter(x \rightarrow !(divisible(x, head_i)), rest_i))$
$\;$

$\text{ ;; where: } i=0,1,,...$
.
"

# ╔═╡ 35516203-34c0-4079-9e68-811ae0e09251
md"
The function $unCons$ is proposed in SICP and used in the so called 'Henderson diagram' [Figure 3.31](https://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5_002e2) (SICP, p. 328). SICP's Fig. 3.31 is inspired by Henderson's Fig. 8.17 (Henderson, 1980, p.238).

We define $unCons$ here with Julia's $Iterators.peel$-function:

$unCons = Iterators.peel$
"

# ╔═╡ 6f668654-5b13-4ee2-a61b-3ed143f76970
unCons(stream::UnOfUnRaTaFiDroRes) = Iterators.peel(stream::UnOfUnRaTaFiDroRes)

# ╔═╡ 2ff3f0ba-1119-4108-80be-32976dec5f7a
begin        # 2nd variant of 'sieve' for input type 'UnOfUnRaTaFiDroRes'
	#-------------------------------------------------------------------------------
	function sieve2(stream::UnOfUnRaTaFiDroRes)  
		let (head0, rest0) = unCons(stream)
			(head1, rest1) = unCons(Iterators.filter(x -> !(divisible(x, head0)), rest0))
			(head2, rest2) = unCons(Iterators.filter(x -> !(divisible(x, head1)), rest1))
			(head3, rest3) = unCons(Iterators.filter(x -> !(divisible(x, head2)), rest2))
			(head4, rest4) = unCons(Iterators.filter(x -> !(divisible(x, head3)), rest3))			
			(head5, rest5) = unCons(Iterators.filter(x -> !(divisible(x, head4)), rest4))
			(head6, rest6) = unCons(Iterators.filter(x -> !(divisible(x, head5)), rest5))
			# ......
		end # let
	end # function sieve2
end # begin

# ╔═╡ 5d279d06-9fb6-4aa3-aa66-b58768c63641
maxInt = typemax(Int)

# ╔═╡ f4da3587-b312-447c-8cf8-584055de77f3
integersRangeStartingFrom2 = (2:maxInt)::UnitRange{Int64}

# ╔═╡ acec0bf8-4f16-4a75-9c1e-f51e5680a477
md"
---
###### $Sieve2$: *3rd* *Iterators-based* variant of $sieve$ for input type $UnOfUnRaTaFiDroRes$

The goal of evaluating the *Scheme* expression $(stream\text{-}ref\; primes\; 50) \Rightarrow 233$ within reasonable runtime (SICP, p.327) can easily be achieved by this variant of $sieve$ by transpiling the *Scheme* expression into a *Julia* call after *redesigning* $sieve$ to $sieve3$. This has been done by heavy use of functions from the $Iterators$-API. 
"

# ╔═╡ 0f1c51c4-17e6-45b7-a74f-faac11088785
begin        # 3rd variant of 'sieve' for input type 'UnOfUnRaTaFiDroRes'
	#-------------------------------------------------------------------------------
	function sieve3(stream::UnOfUnRaTaFiDroRes)::Cons
		let (head0, rest0) = unCons(stream)
			streamCons(
				head0, 
				() -> sieve3(Iterators.filter(x -> !(divisible(x, head0)), rest0)))
		end # let
	end # function sieve3
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 936134cc-504b-4ef5-9abf-8ad54526e686
primes3 = sieve3(integersRangeStartingFrom2)

# ╔═╡ 0e618ffe-eaac-4de7-9be7-1e043322854b
streamRef(primes3, 0)

# ╔═╡ 3b70d180-81da-4375-8f4d-b3e363b7ccb6
streamRef(primes3, 1)

# ╔═╡ 400c8e07-64c3-449c-840c-2edca9daa941
@time [streamRef(primes3, i) for i = 0:0]

# ╔═╡ 833259ea-eddf-4192-a7bc-eff6419132ff
@time [streamRef(primes3, i) for i = 0:5]

# ╔═╡ 64acf0db-44d4-47f9-bfd3-6b8f84bada07
@time [streamRef(primes3, i) for i = 0:10]

# ╔═╡ e9e8237a-55b8-48ac-ba8e-bd7e8418cc41
@time [streamRef(primes3, i) for i = 0:15]

# ╔═╡ 87f80123-c44a-4652-902e-c7d3f5a44240
@time [streamRef(primes3, i) for i = 0:20]

# ╔═╡ a3b18a58-c90a-411c-ac65-740acff5f88d
@time [streamRef(primes3, i) for i = 0:25]

# ╔═╡ f90f2023-35bb-422f-a1ff-f591f3de6ec5
@time [streamRef(primes3, i) for i = 0:30]

# ╔═╡ ba2b43b9-ea6f-4bd1-b327-c86e2ab8ba1b
@time [streamRef(primes3, i) for i = 0:35]

# ╔═╡ f6126eb9-b2eb-4e8e-843e-94f3ecd9add9
@time [streamRef(primes3, i) for i = 0:40]

# ╔═╡ 6d0b9f40-1a00-45b8-8ce0-1baaccdda659
@time [streamRef(primes3, i) for i = 0:45]

# ╔═╡ 6e7f24fb-d054-4a0c-8846-cc4e2afaab66
md"
###### Goal of SICP (p.327) achieved !
"

# ╔═╡ 9a76e153-165e-4190-89c8-7616358c9472
@time [streamRef(primes3, i) for i = 0:50] # goal of SICP (p.327) achieved !

# ╔═╡ ec496b82-ef25-4d14-bbc2-2a19d55db690
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:100]

# ╔═╡ 5980e9da-8741-44fa-9318-5d43efffb9b9
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:200]

# ╔═╡ f459ff68-bbd1-41e4-8dd6-b94c8463ab44
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:300]

# ╔═╡ c973e078-1e79-470c-a393-161154f4950a
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:400]

# ╔═╡ c683ac53-a864-4a66-9734-b7c13859c323
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:500]

# ╔═╡ 6c53afac-2f32-4111-8f3f-cd6d1ee60385
@time [streamRef(sieve3(integersRangeStartingFrom2), i) for i = 0:1000]

# ╔═╡ 087801e4-e34e-42ac-b8ba-b838a33aea61
md"
---
##### References

- Henderson, P.; *Functional Programming: Application and Implementation*: Englewood, Cliffs, N.J., 1980, ISBN 0-13-331579-7
- Kereki, F.; *Mastering JavaScripts Functional Programming*; Birmingham-Mumbai: Packt, 2017
- Mehnert, H., Ohlig, J. & Schirmer, St.; *Das Curry-Buch: Funktional programmieren lernen mit JavaScript*; Köln: O'Reilly, 2013, ISBN 978-3-86899-369-1

- Wikipedia: [*Sieve of Erathostenes*](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes); last visit 2023/08/09

- Wikipedia: [*Trampoline*](https://en.wikipedia.org/wiki/Trampoline_(computing)); last visit 2023/08/16

"



# ╔═╡ 99c3312d-3b30-4aec-92dd-df228dbd5888
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ Cell order:
# ╟─3f4e0f62-36cd-11ee-3b4b-19a4a6b34ac4
# ╟─c639ea45-04d1-4b43-918b-4df56cd7e7bd
# ╠═8ce48325-a83b-40dd-a99c-4498b5461138
# ╠═deb96bbb-3e3b-4967-8e22-0a28168b91fa
# ╟─45ff2260-0cd4-40b2-98fb-a6d2665f2631
# ╟─e5660842-469f-4572-a08f-83975aeb8295
# ╠═3d660697-61ee-4da5-bd99-859f0c7445ef
# ╠═f1dc9fa2-63d6-4a3f-b093-4803aff92b4c
# ╠═02c3f6f0-177f-4ac5-811a-d64f9c4eb32f
# ╟─124a276b-0081-4ac9-a8c5-e45155f426dc
# ╠═8a7c6bc1-0083-44c0-b67a-b0b42506cc67
# ╠═60b73cd1-7b64-458c-b9eb-cbeedda08112
# ╟─9051fef4-d10d-4aa7-98bc-df045512af0e
# ╠═1911ae4b-0a39-47ab-a3a6-2f62839cced6
# ╟─7ef26cc3-b773-4aae-a035-9bc1c8e5de33
# ╟─3c4fcd33-fb39-4330-8b86-5cb5b0cb4dd3
# ╠═f6b3c8cc-b81c-4065-9a00-02fba3472048
# ╠═db173a72-3586-4ca6-a051-9a7300e75b4a
# ╟─4541035e-5d5d-48d9-8771-d1d3ea6129b8
# ╠═f2182c81-b268-457d-95af-714925ad9c2f
# ╠═ce4857dc-e00a-4849-9c6c-55a9624ed692
# ╠═be498571-4ab5-41d3-992d-06e5743cd560
# ╠═a1ee6f1a-0f20-4185-83f1-ac346df646a3
# ╟─9e487f14-84b8-460c-a340-9d2e5a2bd399
# ╠═4f2fb7e4-1066-4a83-b2fa-e1c077fffcfd
# ╠═82f06c4a-3246-4817-9673-b0c9fda3029e
# ╠═06565202-4426-4cc3-8155-c01f2f56c336
# ╠═591eca93-ffdb-4c08-acf9-9263adb588b7
# ╟─b51b08b3-9991-40a0-a9bb-13ee5b33f3fe
# ╠═1cabcb03-4251-4daf-95a7-3f1abb708fc4
# ╟─37200b80-448d-4658-94e4-f2a4943ed172
# ╠═fe8daa11-cc5e-4555-81cb-cc2d20133b97
# ╠═77ae90a6-adfc-4f72-8b3c-e33785955bd2
# ╠═965b5910-cb7f-4929-ab2b-a7a5f809c296
# ╠═facf846c-224a-40a8-8983-cab9d268f113
# ╠═94df8860-73bc-4fec-a3e0-196b37ef6955
# ╠═30794155-76b7-422d-ac38-c449798d6f87
# ╠═c2addf90-9a20-4f2f-bd40-3c0a7c65a6aa
# ╠═7dceef0f-fb3b-46d3-a2b4-270cf936efb1
# ╠═f55c20de-dd40-41be-b2f7-1146f76e52f2
# ╠═9944ed75-7bc7-40b1-b514-55afec40df59
# ╟─125171e0-6441-4b7e-b01b-20bea8df604c
# ╠═2e2c39a1-cc11-44f2-b78a-3e031ec18f22
# ╟─f586edb5-904c-4bf4-b515-f3cdb7b6e52c
# ╠═8d352277-911f-431b-8767-8590960d0d1d
# ╠═472d4c25-8fe6-40d3-a40c-f5462f90e9c5
# ╠═6183a89d-b08a-4e3c-9233-aa7c64aea328
# ╠═659cad7e-a80b-4d1a-926a-7fd753bb3fc6
# ╠═1bbc1033-8b4b-4c00-a178-a61d41a14fb6
# ╠═9a669429-3221-48fe-a034-caf3a470009e
# ╟─9294a584-bd22-4e9b-980a-138fec35f886
# ╠═e924d99d-e4c7-4253-8df8-ebfa55a62f89
# ╠═49f0ae83-4a20-4d44-9ecc-57f048cba34f
# ╠═f803bf9e-62c4-4b20-bf72-53b9c7d00c74
# ╠═eb0e8fd2-3b65-4c59-b42e-2038f9cfd1ac
# ╠═acf7e66a-0b32-452f-b53d-07cbc9b1aa8a
# ╠═8b879cd6-acd8-4274-a112-cabb0181c0d5
# ╟─8204e709-ce1f-4e83-9fbc-df881dc812bb
# ╠═0b920d17-aa10-4e8c-bca8-ecefffdc758f
# ╠═7381aad8-baf2-42d9-b9f3-6aea9801845e
# ╠═7ef50667-9b82-46c4-b49c-4aacd03a4fd1
# ╠═1a184224-a09f-4209-bb8b-3a30d897916c
# ╠═8ca00e7d-b58a-464e-a95e-13a103da70e1
# ╠═ddf5c39b-f8a6-45fb-9263-c1e361126a91
# ╠═728f6b5f-b79f-4a02-9aab-55bf624b40ce
# ╠═1be244fd-de36-46c2-ae83-87f8d9d10d80
# ╠═f6b449ba-9b62-4b84-b163-d3595cecd791
# ╠═c522564e-9171-4bde-bb78-776213096f72
# ╠═78d8833c-062d-4a16-bd2a-50aab61e260c
# ╟─8f9f773e-1263-4155-a64c-83a5ea6533d5
# ╠═2f0dc600-be17-4cf5-b8a4-134e07f9b93e
# ╠═6bd33e68-3504-47bb-bea1-e60d76586ad1
# ╠═0f8b52d4-fda9-47c9-ad89-77495b3c9174
# ╠═e3cc4c42-24ec-48d1-b4c2-9b9bf5ea5f88
# ╠═2b8d2327-d77f-491c-98dc-228274ec840c
# ╟─b8aa300f-7074-4b82-9773-dbd7658e6506
# ╠═9b6c4b24-8b49-4680-97c2-518a86e16860
# ╠═9e48c1c2-62cc-4330-9a22-bfe9d4482a6c
# ╠═d20c6fff-5045-4fed-9d5f-e9d43d951ff4
# ╠═47c56fac-291f-44f6-97b0-c98160b949ef
# ╠═2a932666-a2fc-4adb-ac36-7153e034f613
# ╠═e286d1c8-eeb1-488e-9d83-2ca8d5c702dd
# ╠═81a66a43-3e11-4076-a90c-3f651197f0ee
# ╠═f5444fae-943b-48ef-b242-8c49d7a5dbbc
# ╠═bd7fd23d-d4e3-471b-91bb-48c92cb678ac
# ╠═72fab2b3-4266-4b0a-8cb3-a9048658cc39
# ╠═5ab63588-8587-4b04-9613-9a921b991421
# ╠═0184f96f-cc01-4b49-8e95-93ce2c1a761a
# ╠═b8466b53-ca74-48d5-972c-c8270f243124
# ╠═54d1dc87-9b6d-4bdc-b1a5-e987a187b0e4
# ╠═3fdf383d-affc-4d3b-a1a9-1bce409167af
# ╠═d950121b-23c4-417f-8bd4-95cb33a71ba7
# ╟─b8cfa618-f9cb-4808-b00b-9be7e49481cc
# ╠═32d365d8-9a7b-4da8-86eb-d949b408c9f4
# ╟─0f256ae2-a39d-466a-961b-a7e477958d8b
# ╠═9ca42a74-c351-46df-97f8-71ad47134aa6
# ╠═5627db49-e1ae-4b20-bbb0-46e0f515b7e4
# ╠═a5f5b08f-0c70-4734-8843-e9ada8fcf87f
# ╠═0d6adf8d-dfdc-473d-9c92-01dd80816465
# ╠═6f89ca1b-cdf3-4443-b12a-8cac90179be7
# ╠═ed41bb38-6cf5-4a32-bc17-7c4ef96a43ef
# ╠═c65ca425-18f1-45a1-96e4-84db9303959b
# ╟─23d9e59c-6196-46ee-a09c-e36c97e8572c
# ╟─35516203-34c0-4079-9e68-811ae0e09251
# ╠═6f668654-5b13-4ee2-a61b-3ed143f76970
# ╠═2ff3f0ba-1119-4108-80be-32976dec5f7a
# ╠═5d279d06-9fb6-4aa3-aa66-b58768c63641
# ╠═f4da3587-b312-447c-8cf8-584055de77f3
# ╟─acec0bf8-4f16-4a75-9c1e-f51e5680a477
# ╠═0f1c51c4-17e6-45b7-a74f-faac11088785
# ╠═936134cc-504b-4ef5-9abf-8ad54526e686
# ╠═0e618ffe-eaac-4de7-9be7-1e043322854b
# ╠═3b70d180-81da-4375-8f4d-b3e363b7ccb6
# ╠═400c8e07-64c3-449c-840c-2edca9daa941
# ╠═833259ea-eddf-4192-a7bc-eff6419132ff
# ╠═64acf0db-44d4-47f9-bfd3-6b8f84bada07
# ╠═e9e8237a-55b8-48ac-ba8e-bd7e8418cc41
# ╠═87f80123-c44a-4652-902e-c7d3f5a44240
# ╠═a3b18a58-c90a-411c-ac65-740acff5f88d
# ╠═f90f2023-35bb-422f-a1ff-f591f3de6ec5
# ╠═ba2b43b9-ea6f-4bd1-b327-c86e2ab8ba1b
# ╠═f6126eb9-b2eb-4e8e-843e-94f3ecd9add9
# ╠═6d0b9f40-1a00-45b8-8ce0-1baaccdda659
# ╟─6e7f24fb-d054-4a0c-8846-cc4e2afaab66
# ╠═9a76e153-165e-4190-89c8-7616358c9472
# ╠═ec496b82-ef25-4d14-bbc2-2a19d55db690
# ╠═5980e9da-8741-44fa-9318-5d43efffb9b9
# ╠═f459ff68-bbd1-41e4-8dd6-b94c8463ab44
# ╠═c973e078-1e79-470c-a393-161154f4950a
# ╠═c683ac53-a864-4a66-9734-b7c13859c323
# ╠═6c53afac-2f32-4111-8f3f-cd6d1ee60385
# ╟─087801e4-e34e-42ac-b8ba-b838a33aea61
# ╟─99c3312d-3b30-4aec-92dd-df228dbd5888
