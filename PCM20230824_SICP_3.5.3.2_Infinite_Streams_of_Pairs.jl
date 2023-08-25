### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 4690a7a2-511f-4570-941f-21efa905a7f2
using Primes

# ╔═╡ 25946280-4281-11ee-2e98-b16cc3b2e923
md"
====================================================================================
#### SICP: 3.5.3.2 Infinite Streams of Pairs
##### file: PCM20230824\_SICP\_3.5.3.2\_Infinite\_Streams\_of\_Pairs.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/08/25 ***

====================================================================================
"

# ╔═╡ 1fbf4e02-855c-4492-9c55-75bb8ec83464
md"
###### Types
"

# ╔═╡ 84a8aa8e-8ec0-4daf-a7e5-c1ef8e3a9fa3
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ f38761d8-e0a6-4428-ad80-8fcb209efb83
UnOfUnRaTaFiDroRes = Union{UnitRange, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop, Base.Iterators.Rest}

# ╔═╡ 007d368c-8c08-42f5-b69b-55b25af9871d
md"
---
###### Constructors
"

# ╔═╡ c49d85e7-9fe1-4f1f-ac49-98a5d588ae27
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ 05cf6029-b8bd-43b1-a929-7c2e56f1ec1a
cons(car, cdr) = Cons(car, cdr)  

# ╔═╡ b86bd92b-9a36-4bd5-95bb-0f3a8cd03916
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

# ╔═╡ f323fd9a-245a-46c9-99a2-071c1469d7fb
md"
---
###### Selectors
"

# ╔═╡ 6c5484c5-8066-45fe-a7ca-b5684e113ee2
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ 011c5ddd-5d0a-471d-99df-c82542d05c98
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ b4f803d1-f6de-42c5-bd1c-f8519d2253b4
cadr(cons::Cons) = car(cdr(cons))

# ╔═╡ c425713d-dd79-4436-bbcd-4d240d751260
begin
	streamCar(stream::Cons) = car(stream)                      #  SICP, p.319
	streamCar(stream::UnitRange{Int64}) = Iterators.first(stream) 
	streamCar(iter::UnOfUnRaTaFiDroRes) = Iterators.first(iter)   # from ch. 3.5.2.1
end # begin

# ╔═╡ 1ba550c8-a4d2-4437-864c-4d243566d00c
begin
	streamCdr(stream::Cons) = cdr(stream)                      #  SICP, p.319
	streamCdr(iter::UnOfUnRaTaFiDroRes) = Iterators.drop(iter, 1) # from ch. 3.5.2.1
end # begin

# ╔═╡ ecb1338d-13e4-4a8e-b24d-fe537b3a2cf0
md"
---
###### Predicates
"

# ╔═╡ dced81e2-72fa-4858-b649-af1608df1d9f
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ dacd4708-ef64-4c12-a3c9-3d529e091005
streamNull = null   

# ╔═╡ ee7d4bdb-15af-487c-ac14-a9ff0cd926f9
md"
---
###### PrettyPrint
"

# ╔═╡ 23a0d026-d8b0-4406-8e99-20529ba00074
#------------------------------------------------------------------------------------
# this method pretty-prints a latent hierarchical cons-structure as a nested 
#    tuple structure which has similarity with a Lisp- or Scheme-list
# also used in 3.3.1 and 3.3.2.1
# case 4 (one-dotted-pair) is new here for ch-3.3.3.1
#------------------------------------------------------------------------------------
function pp(consStruct)
	#--------------------------------------------------------------------------------
	function pp_iter(consStruct, arrayList)
		#----------------------------------------------------------------------------
		if consStruct == :nil                               # termination case 1 
			()
		elseif typeof(consStruct) <: Atom                   # termination case_2 
			consStruct
		#----------------------------------------------------------------------------
		# one-element list                                  # termination case_3 
		elseif (typeof(car(consStruct)) <: Atom) && (cdr(consStruct) == :nil)
			Tuple(push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		# one-dotted-pair                                   # termination case_4
		elseif (typeof(car(consStruct)) <: Atom) && (typeof(cdr(consStruct)) <: Atom)
			Tuple(push!(arrayList, car(consStruct), cdr(consStruct)))
		#----------------------------------------------------------------------------
		# flat multi-element list
		elseif (car(consStruct) == :nil) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, ()))
		elseif (typeof(car(consStruct)) <: Atom) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, car(consStruct)))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
			elseif (typeof(car(consStruct)) <: Cons) && (cdr(consStruct) == :nil)
				Tuple(push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
		elseif (typeof(car(consStruct)) <: Cons) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		else
			error("==> unknown case for: $consStruct")
		end # if
	end # pp_iter
	#--------------------------------------------------------------------------------
	pp_iter(consStruct, [])      
end # function pp
#------------------------------------------------------------------------------------

# ╔═╡ 4268d929-835e-48f7-b1c9-97ad211dba6e
md"
--- 
$delay \text{ and } force$
"

# ╔═╡ aec5868d-4b9a-417d-b7e0-900a7939c51f
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

# ╔═╡ 30a6bd99-b227-4635-bcdc-c403ce3a3d28
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

# ╔═╡ eaf1d540-e556-4b36-80d2-9f9ec2b5629b
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $argument of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 2b34a07b-2dec-46fd-9c18-633f8f1bd55f
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

# ╔═╡ 1c67c40f-bc04-42ee-aa78-7f020e99ace2
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

# ╔═╡ 1d5ed6b4-e5c4-4837-ae0d-4e230c9a62a8
md"
---
###### Functor $streamMap$
"

# ╔═╡ 12240131-6198-4db4-9c72-1e6170afabf2
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

# ╔═╡ 9d4b173e-eacf-44e0-a8d1-9f28141c1f5d
function streamsAdd(stream1, stream2)
	streamMap(+, stream1, stream2)
end # function streamsAdd

# ╔═╡ 84098c98-3c1e-4d82-8f83-1959230b7ea0
md"
---
##### Applications
"

# ╔═╡ 771d1ebc-c80d-4168-b546-244a70525894
md"
---
###### How to generate $integerPairs$ ?
(SICP, p.339)
"

# ╔═╡ 0a8cd09e-fb49-42cd-9436-20107ce35dca
myOnes = streamCons(1, () -> myOnes)         # streamCons 2nd arg expects a closure

# ╔═╡ 2372cf9c-fd88-4bf5-b33a-b57391521826
myIntegers = streamCons(1, () -> streamsAdd(myOnes, myIntegers)) 

# ╔═╡ 6cea3b20-faeb-48ba-9eba-9b500a67e982
collect(streamRef(myIntegers, i) for i in 0:20)

# ╔═╡ 220eb653-15d6-4621-9a17-f6f063c5ffd4
function interleave(stream1, stream2)                    # SICP, p.341
	if streamNull(stream1)
		stream2
	else
		streamCons(
			streamCar(stream1),
			() -> interleave(stream2, force(streamCdr(stream1))))
	end # if
end # function interleave

# ╔═╡ 0665ab4d-d692-476c-854f-190dbcb96a3e
intPairs = interleave(myOnes, myIntegers)

# ╔═╡ 8cd5868b-3e89-4a47-ad42-f7359e864b82
collect(streamRef(intPairs, i) for i in 0:21)

# ╔═╡ 743ec5d9-d26c-4119-a191-03542e007063
function pairs(stream1, stream2)                         # SICP, p.341
	streamCons( 
		list(streamCar(stream1), streamCar(stream2)),
		() -> interleave(
			streamMap(x -> list(streamCar(stream1), x), force(streamCdr(stream2))),
			pairs(force(streamCdr(stream1)), force(streamCdr(stream2)))))
end # function pairs

# ╔═╡ 27da431a-fd57-480a-9072-2bab5d5e9861
integerPairs = pairs(myIntegers, myIntegers)                       

# ╔═╡ c8833065-79ed-4ded-b206-ba7cf36ce8f6
streamRef(pairs(myIntegers, myIntegers), 0)

# ╔═╡ 3ee73438-c8c5-4b92-b6ca-bedbb9bdee60
pp(streamRef(pairs(myIntegers, myIntegers), 0))

# ╔═╡ bc094475-4920-447f-9531-7530b409f9fb
# ex 3.66, SICP, p.341
collect(streamRef(pairs(myIntegers, myIntegers), i) for i in 0:21) 

# ╔═╡ fbfa03e1-2a56-4937-90e4-e3b5e7d7fa2b
# ex 3.66, SICP, p.341
collect(pp(streamRef(pairs(myIntegers, myIntegers), i)) for i in 0:21) 

# ╔═╡ 90df6574-ba2f-444d-93eb-a22e7ec039ff
streamFilter(pair -> isprime( +(car(pair), cadr(pair))), () -> integerPairs)

# ╔═╡ 735524b2-cd7d-4362-a4d9-4ac3ec43fea9
filteredPairs = 
	streamFilter(pair -> isprime( +(car(pair), cadr(pair))), () -> integerPairs)

# ╔═╡ c4cf655f-0c9f-498b-b56c-4946953a9234
typeof(filteredPairs)

# ╔═╡ d3d4122e-11ce-41df-a8d9-e3375a9f190f
streamMap(pair -> +(car(pair), cadr(pair)), filteredPairs)

# ╔═╡ 1b8cb4fd-df57-4cca-a17e-0265ab6abdb8
collect(streamRef(streamFilter(pair -> isprime(+(car(pair), cadr(pair))), () -> integerPairs), i) for i in 0:21)

# ╔═╡ f8d236f6-1488-49cd-bc51-6a5ee0617386
tuples = collect(pp(streamRef(streamFilter(pair -> isprime(+(car(pair), cadr(pair))), () -> integerPairs), i)) for i in 0:41)

# ╔═╡ 73b3709f-e8ec-4072-837d-0c2976c465ca
[(tuple[1], tuple[2], tuple[1] + tuple[2]) for tuple in tuples]

# ╔═╡ 6efe3695-1dd2-4eea-87c1-ae08fb80ea83
md"
---
##### End of ch. 3.5.3.2
"

# ╔═╡ 6a8648f9-ee33-498f-a078-7ca42efd1d09
md"
---
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
# ╟─25946280-4281-11ee-2e98-b16cc3b2e923
# ╠═4690a7a2-511f-4570-941f-21efa905a7f2
# ╟─1fbf4e02-855c-4492-9c55-75bb8ec83464
# ╠═84a8aa8e-8ec0-4daf-a7e5-c1ef8e3a9fa3
# ╠═f38761d8-e0a6-4428-ad80-8fcb209efb83
# ╟─007d368c-8c08-42f5-b69b-55b25af9871d
# ╠═c49d85e7-9fe1-4f1f-ac49-98a5d588ae27
# ╠═05cf6029-b8bd-43b1-a929-7c2e56f1ec1a
# ╠═30a6bd99-b227-4635-bcdc-c403ce3a3d28
# ╠═b86bd92b-9a36-4bd5-95bb-0f3a8cd03916
# ╟─f323fd9a-245a-46c9-99a2-071c1469d7fb
# ╠═6c5484c5-8066-45fe-a7ca-b5684e113ee2
# ╠═011c5ddd-5d0a-471d-99df-c82542d05c98
# ╠═b4f803d1-f6de-42c5-bd1c-f8519d2253b4
# ╠═c425713d-dd79-4436-bbcd-4d240d751260
# ╠═1ba550c8-a4d2-4437-864c-4d243566d00c
# ╠═2b34a07b-2dec-46fd-9c18-633f8f1bd55f
# ╠═1c67c40f-bc04-42ee-aa78-7f020e99ace2
# ╟─ecb1338d-13e4-4a8e-b24d-fe537b3a2cf0
# ╠═dced81e2-72fa-4858-b649-af1608df1d9f
# ╠═dacd4708-ef64-4c12-a3c9-3d529e091005
# ╟─ee7d4bdb-15af-487c-ac14-a9ff0cd926f9
# ╟─23a0d026-d8b0-4406-8e99-20529ba00074
# ╟─4268d929-835e-48f7-b1c9-97ad211dba6e
# ╠═aec5868d-4b9a-417d-b7e0-900a7939c51f
# ╠═eaf1d540-e556-4b36-80d2-9f9ec2b5629b
# ╟─1d5ed6b4-e5c4-4837-ae0d-4e230c9a62a8
# ╠═9d4b173e-eacf-44e0-a8d1-9f28141c1f5d
# ╠═12240131-6198-4db4-9c72-1e6170afabf2
# ╟─84098c98-3c1e-4d82-8f83-1959230b7ea0
# ╟─771d1ebc-c80d-4168-b546-244a70525894
# ╠═0a8cd09e-fb49-42cd-9436-20107ce35dca
# ╠═2372cf9c-fd88-4bf5-b33a-b57391521826
# ╠═6cea3b20-faeb-48ba-9eba-9b500a67e982
# ╠═0665ab4d-d692-476c-854f-190dbcb96a3e
# ╠═8cd5868b-3e89-4a47-ad42-f7359e864b82
# ╠═220eb653-15d6-4621-9a17-f6f063c5ffd4
# ╠═743ec5d9-d26c-4119-a191-03542e007063
# ╠═27da431a-fd57-480a-9072-2bab5d5e9861
# ╠═c8833065-79ed-4ded-b206-ba7cf36ce8f6
# ╠═3ee73438-c8c5-4b92-b6ca-bedbb9bdee60
# ╠═bc094475-4920-447f-9531-7530b409f9fb
# ╠═fbfa03e1-2a56-4937-90e4-e3b5e7d7fa2b
# ╠═90df6574-ba2f-444d-93eb-a22e7ec039ff
# ╠═735524b2-cd7d-4362-a4d9-4ac3ec43fea9
# ╠═c4cf655f-0c9f-498b-b56c-4946953a9234
# ╠═d3d4122e-11ce-41df-a8d9-e3375a9f190f
# ╠═1b8cb4fd-df57-4cca-a17e-0265ab6abdb8
# ╠═f8d236f6-1488-49cd-bc51-6a5ee0617386
# ╠═73b3709f-e8ec-4072-837d-0c2976c465ca
# ╟─6efe3695-1dd2-4eea-87c1-ae08fb80ea83
# ╟─6a8648f9-ee33-498f-a078-7ca42efd1d09
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
