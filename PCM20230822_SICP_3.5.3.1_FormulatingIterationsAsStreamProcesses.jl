### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ f60d9200-40ca-11ee-1616-ef0eddaa3046
md"
====================================================================================
#### SICP: 3.5.3.1 Formulating Iterations as Stream Processes
##### file: PCM20230822\_SICP\_3.5.3.1\_FormulatingIterationsAsStreamProcesses.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/08/24 ***

====================================================================================
"

# ╔═╡ 8f60f243-84cc-459f-a4c0-8f0868f15c3c
md"
###### Types
"

# ╔═╡ 1c596a51-b2b0-473b-93b8-f38e0c112dfc
UnOfUnRaTaFiDroRes = Union{UnitRange, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop, Base.Iterators.Rest}

# ╔═╡ 2456e0a7-6130-409b-bbd0-856a5e0133b0
md"
---
###### Constructors
"

# ╔═╡ ca016430-5024-4a55-bb7b-7937308b3985
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ ac421bd5-80bd-4e4c-b6e0-e0f6e7960992
cons(car, cdr) = Cons(car, cdr)   

# ╔═╡ 395f8672-7579-4c56-99cb-01731e573d9e
md"
---
###### Selectors
"

# ╔═╡ fa8c4417-872b-44ab-af2e-f17093191000
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ c184daa1-f0f5-4621-942c-8913e731de72
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 8babc4af-c27b-4c71-935f-511a29685183
begin
	streamCar(stream::Cons) = car(stream)                      #  SICP, p.319
	streamCar(stream::UnitRange{Int64}) = Iterators.first(stream) 
	streamCar(iter::UnOfUnRaTaFiDroRes) = Iterators.first(iter)   # from ch. 3.5.2.1
end # begin

# ╔═╡ f4aac41d-bfc4-44e9-9bbc-bb899277ece9
begin
	streamCdr(stream::Cons) = cdr(stream)                      #  SICP, p.319
	streamCdr(iter::UnOfUnRaTaFiDroRes) = Iterators.drop(iter, 1) # from ch. 3.5.2.1
end # begin

# ╔═╡ 89ab012e-685e-49a7-829c-288eee4b45fd
md"
---
###### Predicates
"

# ╔═╡ 8642ed96-6203-4667-af12-6133bc162311
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ 95d59175-a065-44d4-b766-19111b8fcc62
streamNull = null   

# ╔═╡ 5334f467-dea0-4c31-8c28-0dddfddc0bfd
md"
---
###### $delay$ and $force$
"

# ╔═╡ 19a077fd-ea04-417f-91af-6b5f90e3eb11
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

# ╔═╡ 5115e155-2580-4529-b76c-34b2230ca037
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

# ╔═╡ 54c9d40d-23b4-4408-884d-cba79055953f
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $argument of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ 2c274a25-9ff4-48e6-b201-5990a09ac182
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

# ╔═╡ 48428d71-7005-41ba-8378-e1ba1c361366
md"
---
###### [Functor](https://en.wikipedia.org/wiki/Functor_(functional_programming)) $streamMap$
"

# ╔═╡ 454e405d-31b4-48ee-867f-b0a07b6aa3e5
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

# ╔═╡ cc4110a6-70a8-4156-a25e-519e482ea53f
md"
---
###### Approximation of $sqrt$ by a Stream
(SICP, p.334)
"

# ╔═╡ 478f0932-7c43-4ce2-9897-f43d4c2c5676
function sqrtImprove(guess, x)                          # SICP, p. 334
	let average(x, y)  = (x + y)/2.0
		average(guess, x / guess)
	end # let
end # function sqrtImprove

# ╔═╡ c6a8884f-6d67-4c03-b0d7-cf250bab9286
sqrtImprove(2, 4)

# ╔═╡ 359d32a9-40a9-4f4f-9ff9-70f2c4385fd1
myGuesses = streamCons(1.0, () -> myGuesses)           # trial stream 

# ╔═╡ 60d8eaef-7608-404d-8429-e3e6c8091610
function sqrtStream(x)                                 # SICP, p. 335
	guesses = streamCons(1.0, 
				() -> streamMap(guess -> sqrtImprove(guess, x), guesses))
end # function sqrtStream

# ╔═╡ 70ed4f4e-ea4f-4bcc-b1bd-16e6d486ee38
sqrtStream(2)

# ╔═╡ 2564367c-8631-48d0-ad2c-8258431e3ef8
streamRef(sqrtStream(2), 0)

# ╔═╡ cc7f5517-0c7c-4a9d-836c-0a6a5ac76bce
streamRef(sqrtStream(2), 1)

# ╔═╡ 28469973-8ae6-44ca-8ed8-994dac67e600
streamRef(sqrtStream(2), 2)

# ╔═╡ 23ace7e1-e82f-4184-9467-b4e5a090052c
streamRef(sqrtStream(2), 3)

# ╔═╡ b43dc11e-c7ca-4550-be61-1ccecfc8c694
collect(streamRef(sqrtStream(2), i) for i in 0: 5)     # SICP, p. 335

# ╔═╡ 62bb1276-ca51-4ffb-869e-a0085f819a8a
md"
---
###### Julia's $sqrt(2) = 1.4142135623730951$
"

# ╔═╡ 2b5da126-b9fd-4837-bcf7-c1f1c4272210
sqrt(2)                             

# ╔═╡ 1f261aff-ebb0-44f4-a406-cc659a8d30b9
md"
---
###### Approximation of $\pi$ by a stream
(SICP, p.335)
"

# ╔═╡ 62028099-9256-40ee-88b7-bb8822b3bd0e
myOnes = streamCons(1, () -> myOnes)  # streamCons 2nd arg expects a closure

# ╔═╡ 4aac0ba3-d2db-4e3d-a751-7818fbedbc01
function partialSums(stream::Cons; sum=0)             # ex.3.55, SICP, p.331
	sum += streamCar(stream)
	streamCons(sum, () -> partialSums(force(streamCdr(stream)), sum=sum))
end # function partialSums

# ╔═╡ d31f5e02-a2f5-42b0-b894-8c26ead04da5
function streamsAdd(stream1, stream2)                 # SICP, p.329
	streamMap(+, stream1, stream2)
end # function streamsAdd

# ╔═╡ 9a183ef4-89ad-4639-a94c-d5b97bf5bc24
myIntegers = streamCons(1, () -> streamsAdd(myOnes, myIntegers)) 

# ╔═╡ ca612509-4d0d-42c5-80d5-a9af0cef5ac9
partialSums(myIntegers)

# ╔═╡ f9c71d96-9567-40d1-a689-8d2decf11cd9
collect(streamRef(partialSums(myIntegers), i) for i in 0:10)  # SICP, p.331

# ╔═╡ f1f688c4-5afa-45c3-89ba-45843d144cd0
function piSummands(n)                                        # SICP, p.335
	streamCons(1.0/n, () -> streamMap(-, piSummands(n+2)))
end # function piSummands

# ╔═╡ a503e28c-b7f3-4f49-8eba-a647c4191304
piStream = streamMap(x -> x*4.0, partialSums(piSummands(1)))  # SICP, p.335

# ╔═╡ 8bd4cc11-dee0-4fc7-b6d8-9ca26ec843b1
collect(streamRef(piStream, i) for i in 0:7)                  # SICP, p.335

# ╔═╡ 1f84d592-9556-4b5a-ad80-29988285c4b6
md"
---
###### Julia's $\pi = 3.1415926535897...$
"

# ╔═╡ 13a917fc-bca9-4368-96e8-28285b6fca8f
π

# ╔═╡ 428715c0-691f-4c1f-bda4-c30a3fb6db79
md"
*This gives us a stream of better and better approximations to $\pi$, although the approximation converges rather slowly. Eight terms of the sequence bound the value of $\pi$ between 3.284 and 3.017.* (SICP, 1996, p.336)

Contrary to this we count only 6 terms outside this bound.
"

# ╔═╡ 9520ef52-1af4-44e6-94f5-0874ba9821d4
let count = 0
	for i in 0:100
		(streamRef(piStream, i) < 3.017 || 3.284 < streamRef(piStream, i)) ? 
			count += 1 : 
			nothing 
	end # for
	count
end # let

# ╔═╡ a8a2007b-a924-4931-86e5-d9545129f290
collect(streamRef(piStream, i) for i in 0:99)

# ╔═╡ b37383e6-e9cb-4866-abbf-98aae70eda3f
md"
---
###### Transformation of a Stream with a *Stream Accelerator*: Euler's acceleration to $\pi$
(SICP, p.336)
"

# ╔═╡ e472abe7-5394-43bc-ae0e-1afed9726cdf
md"

$S_{n+2} = S_{n+1} - \frac{(S_{n+1} - S_n)^2}{S_{n-1} - 2S_n + S_{n+1}}$
$\;$
$\;$

"

# ╔═╡ e30ad338-a8b4-41b9-b775-a8d4a9211d0f
function eulerTransform(stream::Cons)                # SICP, p. 336
	let s_nMin1     = streamRef(stream, 0)           # S_{n-1}
		s_n         = streamRef(stream, 1)           # S_n
		s_nPlus1    = streamRef(stream, 2)           # S_{n+1}
		numerator   = (s_nPlus1 - s_n)^2
		denominator = (s_nMin1 - 2*s_n + s_nPlus1)
		ratio    = numerator/denominator
		streamCons(s_nPlus1 - ratio, () -> eulerTransform(force(streamCdr(stream))))
	end # let
end # function eulerTransform

# ╔═╡ b593b6f8-b639-4727-82f0-e3690e6c6356
eulerTransform(piStream)

# ╔═╡ 21fab306-2fda-4dcd-a26f-16feb2ae1228
collect(streamRef(eulerTransform(piStream), i) for i in 0:7)

# ╔═╡ 4a6b5768-ada2-45ac-b8ac-9942291c7d93
collect(streamRef(eulerTransform(piStream), i) for i in 0:99)

# ╔═╡ 312ea6cb-2149-4437-827b-40805950fece
md"
This gives us a stream of better and better approximations to $\pi$. The approximation converges rather fast. Zero terms of the sequence bound the value of $\pi$ between 3.284 and 3.017. 
"

# ╔═╡ c98f82b7-fcab-4e6e-8dd0-f94bf0fe032f
let count = 0
	eulerStream = eulerTransform(piStream)
	for i in 0:100
		(streamRef(eulerStream, i) < 3.017 || 3.284 < streamRef(eulerStream, i)) ? 
			count += 1 : 
			nothing 
	end # for
	count
end # let

# ╔═╡ 9d0c9fe9-78ab-461d-8adb-796399b9b148
md"
---
###### *Tableau* (= Stream of Streams)
*Each stream is the transform of the preceeding one* (SICP, p.337)
"

# ╔═╡ 1c7f98eb-83f0-41b3-b751-a697187ef4f1
md"
---
$makeTableau$
"

# ╔═╡ 22958e7c-0ec5-44d6-96e5-d18728712a6f
function makeTableau(transform::Function, stream::Cons)          # SICP, p.337
	streamCons(stream, () -> makeTableau(transform, transform(stream)))
end # function makeTableau

# ╔═╡ e6c7c065-c440-4197-8583-ef3f58ca1b72
md"
---
$acceleratedSequence$
"

# ╔═╡ 9e1e3e13-6f8c-4761-8c7c-64f19b348b25
makeTableau(eulerTransform, piStream)

# ╔═╡ 5a0452cf-b21a-46e5-96b4-a0d7cd90e996
streamMap(streamCar, makeTableau(eulerTransform, piStream))

# ╔═╡ 9fb0a2b5-77a2-42d8-8e03-2e491b16949e
function acceleratedSequence(transform::Function, stream::Cons)
	streamMap(streamCar, makeTableau(transform, stream))
end # function acceleratedSequence

# ╔═╡ 289dd639-1722-49e0-a871-4729db736f13
acceleratedSequence(eulerTransform, piStream)                  # SICP, p.337

# ╔═╡ 8ea21f89-1bf9-4bb5-aa9a-6ea83722541c
collect(streamRef(acceleratedSequence(eulerTransform, piStream), i) for i in 0:7)

# ╔═╡ e4c7a716-0875-4f2d-b4e2-5b5b00fabac2
md"
*The result is impressive. Taking eight terms of the sequence yields the correct value of $\pi$ to 14 decimal places*. (SICP, p.337)
"

# ╔═╡ 9f57cc73-1daf-40ec-853a-9706d7980b68
abs(streamRef(acceleratedSequence(eulerTransform, piStream), 7) - π)

# ╔═╡ 4ca2b2fd-67ad-4a5b-b0da-d60e90c9e5ff
md"
---
##### End of ch. 3.5.3
"

# ╔═╡ f0948bbb-b455-440c-a4ec-de5af201f17f
md"
---
##### References

- Wikipedia; [Functor](https://en.wikipedia.org/wiki/Functor_(functional_programming)); last visit 2023/08/23

"

# ╔═╡ a6d539d8-618a-4dfd-8a15-50750051396e
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ Cell order:
# ╟─f60d9200-40ca-11ee-1616-ef0eddaa3046
# ╟─8f60f243-84cc-459f-a4c0-8f0868f15c3c
# ╠═1c596a51-b2b0-473b-93b8-f38e0c112dfc
# ╟─2456e0a7-6130-409b-bbd0-856a5e0133b0
# ╠═ca016430-5024-4a55-bb7b-7937308b3985
# ╠═ac421bd5-80bd-4e4c-b6e0-e0f6e7960992
# ╠═5115e155-2580-4529-b76c-34b2230ca037
# ╟─395f8672-7579-4c56-99cb-01731e573d9e
# ╠═fa8c4417-872b-44ab-af2e-f17093191000
# ╠═c184daa1-f0f5-4621-942c-8913e731de72
# ╠═8babc4af-c27b-4c71-935f-511a29685183
# ╠═f4aac41d-bfc4-44e9-9bbc-bb899277ece9
# ╠═2c274a25-9ff4-48e6-b201-5990a09ac182
# ╟─89ab012e-685e-49a7-829c-288eee4b45fd
# ╠═8642ed96-6203-4667-af12-6133bc162311
# ╠═95d59175-a065-44d4-b766-19111b8fcc62
# ╟─5334f467-dea0-4c31-8c28-0dddfddc0bfd
# ╠═19a077fd-ea04-417f-91af-6b5f90e3eb11
# ╠═54c9d40d-23b4-4408-884d-cba79055953f
# ╟─48428d71-7005-41ba-8378-e1ba1c361366
# ╠═454e405d-31b4-48ee-867f-b0a07b6aa3e5
# ╟─cc4110a6-70a8-4156-a25e-519e482ea53f
# ╠═478f0932-7c43-4ce2-9897-f43d4c2c5676
# ╠═c6a8884f-6d67-4c03-b0d7-cf250bab9286
# ╠═359d32a9-40a9-4f4f-9ff9-70f2c4385fd1
# ╠═60d8eaef-7608-404d-8429-e3e6c8091610
# ╠═70ed4f4e-ea4f-4bcc-b1bd-16e6d486ee38
# ╠═2564367c-8631-48d0-ad2c-8258431e3ef8
# ╠═cc7f5517-0c7c-4a9d-836c-0a6a5ac76bce
# ╠═28469973-8ae6-44ca-8ed8-994dac67e600
# ╠═23ace7e1-e82f-4184-9467-b4e5a090052c
# ╠═b43dc11e-c7ca-4550-be61-1ccecfc8c694
# ╟─62bb1276-ca51-4ffb-869e-a0085f819a8a
# ╠═2b5da126-b9fd-4837-bcf7-c1f1c4272210
# ╟─1f261aff-ebb0-44f4-a406-cc659a8d30b9
# ╠═62028099-9256-40ee-88b7-bb8822b3bd0e
# ╠═9a183ef4-89ad-4639-a94c-d5b97bf5bc24
# ╠═4aac0ba3-d2db-4e3d-a751-7818fbedbc01
# ╠═ca612509-4d0d-42c5-80d5-a9af0cef5ac9
# ╠═d31f5e02-a2f5-42b0-b894-8c26ead04da5
# ╠═f9c71d96-9567-40d1-a689-8d2decf11cd9
# ╠═f1f688c4-5afa-45c3-89ba-45843d144cd0
# ╠═a503e28c-b7f3-4f49-8eba-a647c4191304
# ╠═8bd4cc11-dee0-4fc7-b6d8-9ca26ec843b1
# ╟─1f84d592-9556-4b5a-ad80-29988285c4b6
# ╠═13a917fc-bca9-4368-96e8-28285b6fca8f
# ╟─428715c0-691f-4c1f-bda4-c30a3fb6db79
# ╠═9520ef52-1af4-44e6-94f5-0874ba9821d4
# ╠═a8a2007b-a924-4931-86e5-d9545129f290
# ╟─b37383e6-e9cb-4866-abbf-98aae70eda3f
# ╟─e472abe7-5394-43bc-ae0e-1afed9726cdf
# ╠═e30ad338-a8b4-41b9-b775-a8d4a9211d0f
# ╠═b593b6f8-b639-4727-82f0-e3690e6c6356
# ╠═21fab306-2fda-4dcd-a26f-16feb2ae1228
# ╠═4a6b5768-ada2-45ac-b8ac-9942291c7d93
# ╟─312ea6cb-2149-4437-827b-40805950fece
# ╠═c98f82b7-fcab-4e6e-8dd0-f94bf0fe032f
# ╟─9d0c9fe9-78ab-461d-8adb-796399b9b148
# ╟─1c7f98eb-83f0-41b3-b751-a697187ef4f1
# ╠═22958e7c-0ec5-44d6-96e5-d18728712a6f
# ╟─e6c7c065-c440-4197-8583-ef3f58ca1b72
# ╠═9e1e3e13-6f8c-4761-8c7c-64f19b348b25
# ╠═5a0452cf-b21a-46e5-96b4-a0d7cd90e996
# ╠═9fb0a2b5-77a2-42d8-8e03-2e491b16949e
# ╠═289dd639-1722-49e0-a871-4729db736f13
# ╠═8ea21f89-1bf9-4bb5-aa9a-6ea83722541c
# ╟─e4c7a716-0875-4f2d-b4e2-5b5b00fabac2
# ╠═9f57cc73-1daf-40ec-853a-9706d7980b68
# ╟─4ca2b2fd-67ad-4a5b-b0da-d60e90c9e5ff
# ╟─f0948bbb-b455-440c-a4ec-de5af201f17f
# ╟─a6d539d8-618a-4dfd-8a15-50750051396e
