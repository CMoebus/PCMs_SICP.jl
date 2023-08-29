### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 19bfcba0-44ea-11ee-3deb-23929377e658

md"
====================================================================================
#### SICP: 3.5.4 [Streams and Delayed Evaluation](https://sarabander.github.io/sicp/html/3_002e5.xhtml#g_t3_002e5_002e4)
##### file: PCM20230827\_SICP\_3.5.4\_Streams\_and\_Delayed\_Evaluation.jl
##### Julia/Pluto.jl-code (1.9.3/0.19.27) by PCM *** 2023/08/29 ***

====================================================================================
"

# ╔═╡ 6b89241d-0cee-4eee-9eac-ff6a21153e1c
md"
---
###### Types
"

# ╔═╡ c513c1e5-20ad-4a62-97bd-3a8832e55345
UnOfUnRaTaFiDroRes = Union{UnitRange, Base.Iterators.Take, 					   			Base.Iterators.Filter, Base.Iterators.Drop, Base.Iterators.Rest}

# ╔═╡ dc99ea0d-65f3-4511-a5ba-16d3a49c7099
md"
---
###### Constructors
"

# ╔═╡ 4257d7ae-7845-4f07-9e95-25757f07971a
#---------------------------------------------------
# from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end # struct

# ╔═╡ 58dd79dd-eb89-46ed-9899-0b5ba4267419
cons(car, cdr) = Cons(car, cdr)  

# ╔═╡ 333d469a-85ac-4cbe-b9b5-2924b6763c4b
md"
---
###### Selectors
"

# ╔═╡ e8a12556-0e32-4ef5-a934-0cda03415202
#--------------------------------------------------------
# from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ 0a78d7e8-2bf4-4d54-accb-5cd9e04b016f
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 9d1c9d23-410d-47bb-8973-862ac4e56f32
begin
	streamCar(stream::Cons) = car(stream)                      #  SICP, p.319
	streamCar(stream::UnitRange{Int64}) = Iterators.first(stream) 
	streamCar(iter::UnOfUnRaTaFiDroRes) = Iterators.first(iter)   # from ch. 3.5.2.1
end # begin

# ╔═╡ a36a10ba-5272-4642-8055-a23b6efe79d8
begin
	streamCdr(stream::Cons) = cdr(stream)                      #  SICP, p.319
	streamCdr(iter::UnOfUnRaTaFiDroRes) = Iterators.drop(iter, 1) # from ch. 3.5.2.1
end # begin

# ╔═╡ a8230a88-272e-41e3-a7c8-ee345febaf75
md"
---
###### Predicates
"

# ╔═╡ 0083570a-f773-435e-ba94-ec22f3754dfb
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ 16a98d76-cd45-46f5-b94e-d703685de26a
streamNull = null   

# ╔═╡ f93b99e6-fb1f-4bd8-bf20-54676e904068
md"
---
###### Functors
"

# ╔═╡ 9a980096-1af3-4580-ab5c-84442c65574a
md"
---
###### Stream Functions
"

# ╔═╡ fee18b5e-34ab-41a2-8dc4-c21e8aa0cf4b
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

# ╔═╡ 8c9bac43-aebe-4352-97b8-62b058b355a6
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

# ╔═╡ 16967fe9-64fb-464e-b11b-50d9eef4921a
begin                                                            # from 3.5.2.1
	#-------------------------------------------------------------------------------
	force(expression::Function) = expression()                   # SICP, p.323
	#-------------------------------------------------------------------------------
    force(argument) = 
		println("arg $argument of force should be an anonymous closure '() -> ...'")
	#-------------------------------------------------------------------------------
end # begin

# ╔═╡ f5bebcf9-0a8f-450d-ac22-455b1d1bce13
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

# ╔═╡ d745e4c7-40aa-44a4-878d-d8599811782f
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

# ╔═╡ a802a1a8-e2c5-42e8-a335-fdec60de0249
function streamAdd(stream1, stream2)
	streamMap(+, stream1, stream2)
end # function streamsAdd

# ╔═╡ e7ed8016-6e74-499e-b25b-49bb0b2c45f0
function streamScale(stream::Cons, scaleFactor::Real)            # SICP, p.329
	streamMap(x -> x * scaleFactor, stream)
end # function streamScale

# ╔═╡ bfc4363d-7fb2-40ff-9bd2-b60889b1037d
md"
---
###### Applications
"

# ╔═╡ 80585399-360f-464b-85d9-f4b8a5810e5e
md"
---
"

# ╔═╡ 417091c1-c083-4b01-9ed7-05bc86bf9a9e
md"
---
"

# ╔═╡ 0df3ba0c-f08c-4b1a-b3ec-e95971d7f799
md"
---
"

# ╔═╡ 6d4dcc1b-4b5e-439f-b933-cd643e16585b
# SICP, p.347
function integral(delayedIntegrand::Function, initialValue::Real, Δx::Real)::Cons
	integralStream = streamCons(
			initialValue,
			() -> streamAdd(
				streamScale(force(delayedIntegrand), Δx), 
				integralStream))
	integralStream
end # function integral

# ╔═╡ 726ace2c-02d9-42b2-9853-e5e6f9ea8cf0
function solveFirstTrial(f::Function, y0::Real, Δx::Real)     # SICP, p.347
	y  = integral(Δy, y0, Δx)                     # will result in unknown 'Δy' error
	Δy = streamMap(f, y)
	y
end # function solveFirstTrial

# ╔═╡ 3b4e09d3-c26c-4ca7-b079-af76f74088e3
let Δx = 0.1                                      
	y0 = 1.0
	streamRef(solveFirstTrial(y -> y, y0, Δx), convert(Int64, round(1.0/Δx)))
end # let                             # error "unknown 'Δy'" as expected, SICP, p.347

# ╔═╡ f46e9d6f-d4d5-48aa-9d79-22c1a9f7797c
function solveSecondTrial(f::Function, y0::Real, Δx::Real)     # SICP, p.347
	Δy = streamMap(f, y)
	y  = integral(Δy, y0, Δx)                    # will result in unknown 'y' error
	y
end # function solveSecondTrial

# ╔═╡ 8c856238-f518-4792-a9cb-d8b2e9016654
let Δx = 0.1                                      
	y0 = 1.0
	streamRef(solveSecondTrial(y -> y, y0, Δx), convert(Int64, round(1.0/Δx)))
end # let                             # error "unknown 'y'" as expected, SICP, p.347

# ╔═╡ b384b1d0-9e70-4e44-b782-c01d0d0bc0a0
function solve(f::Function, y0::Real, Δx::Real)               # SICP, p.348
	y  = integral(() -> Δy, y0, Δx)                           # delay(...) = () -> ...
	Δy = streamMap(f, y)
	y
end # function

# ╔═╡ d5d89e90-9a71-48c4-83e4-58458fe4e85c
md"
---
###### 1st order, 1st degree, homogenous differential equation (ODE)

$\left (\frac{dy}{dx} = y\right) \Rightarrow (y' = y)$

$\;$

$\;$

and in Julia:

$(y \rightarrow y)$

$\;$

$\;$

with Euler's $e = 2.7182818284590...$ as its solution of the ODE with initial condition $y(0) = 1$ (SICP, p. 348).

"

# ╔═╡ 094ffc36-8ab4-4114-b699-0ce11c453480
let Δx = 0.1
	yDeriv = y -> y
	y0 = 1.0
    n  = 10
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n)
	error = [abs(ℯ - value[i]) for i in 1:n+1]
	(error=error, value=value)
end # let

# ╔═╡ 6ce476ac-39cb-4405-9ef5-5eef50aa34d6
let Δx = 0.09
	yDeriv = y -> y
	y0 = 1.0
    n  = 13
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n-1)
	error = [abs(ℯ - value[i]) for i in 1:n]
	(error=error, value=value)
end # let

# ╔═╡ 57fcdfb8-6379-4301-83b3-5d7f06762b6b
md"
---
The parameter combination $Δx = 0.08$ and $n  = 13$ generates the smallest $error=0.0013419$ and the *best* approximation $2.71962$ to $e$. Even smaller stepwidths $Δx < 0.08$ cannot generate better results contrary to SICP (p.348); see below.
"

# ╔═╡ d6a1b8d4-798a-4a45-88f2-d47886778824
let Δx = 0.08
	yDeriv = y -> y
	y0 = 1.0
    n  = 14
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n-1)
	error = [abs(ℯ - value[i]) for i in 1:n]
	(error=error, value=value)
end # let

# ╔═╡ 1da3c6b6-89a4-4bf0-9522-e9b10e303876
let Δx = 0.07
	yDeriv = y -> y
	y0 = 1.0
    n  = 16
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n-1)
	error = [abs(ℯ - value[i]) for i in 1:n]
	(error=error, value=value)
end # let

# ╔═╡ efddb751-d16e-45a2-9ce8-a33798d19f7d
let Δx = 0.06
	yDeriv = y -> y
	y0 = 1.0
    n  = 18
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n-1)
	error = [abs(ℯ - value[i]) for i in 1:n]
	(error=error, value=value)
end # let

# ╔═╡ d5696cea-a78b-489e-bce6-edf6e18f2aca
let Δx = 0.05
	yDeriv = y -> y
	y0 = 1.0
    n  = 21
	value = collect(streamRef(solve(yDeriv, y0, Δx), i) for i in 0:n-1)
	error = [abs(ℯ - value[i]) for i in 1:n]
	(error=error, value=value)
end # let

# ╔═╡ 7b2a86f1-450f-462c-a461-0ec1fd41048e
md"
---
##### End of ch. 3.5.4
"

# ╔═╡ f217f411-0951-45a9-81af-5e576dd3e43d
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ Cell order:
# ╟─19bfcba0-44ea-11ee-3deb-23929377e658
# ╟─6b89241d-0cee-4eee-9eac-ff6a21153e1c
# ╠═c513c1e5-20ad-4a62-97bd-3a8832e55345
# ╟─dc99ea0d-65f3-4511-a5ba-16d3a49c7099
# ╠═4257d7ae-7845-4f07-9e95-25757f07971a
# ╠═58dd79dd-eb89-46ed-9899-0b5ba4267419
# ╠═8c9bac43-aebe-4352-97b8-62b058b355a6
# ╟─333d469a-85ac-4cbe-b9b5-2924b6763c4b
# ╠═e8a12556-0e32-4ef5-a934-0cda03415202
# ╠═0a78d7e8-2bf4-4d54-accb-5cd9e04b016f
# ╠═9d1c9d23-410d-47bb-8973-862ac4e56f32
# ╠═a36a10ba-5272-4642-8055-a23b6efe79d8
# ╠═f5bebcf9-0a8f-450d-ac22-455b1d1bce13
# ╟─a8230a88-272e-41e3-a7c8-ee345febaf75
# ╠═0083570a-f773-435e-ba94-ec22f3754dfb
# ╠═16a98d76-cd45-46f5-b94e-d703685de26a
# ╟─f93b99e6-fb1f-4bd8-bf20-54676e904068
# ╠═a802a1a8-e2c5-42e8-a335-fdec60de0249
# ╠═d745e4c7-40aa-44a4-878d-d8599811782f
# ╠═e7ed8016-6e74-499e-b25b-49bb0b2c45f0
# ╟─9a980096-1af3-4580-ab5c-84442c65574a
# ╠═fee18b5e-34ab-41a2-8dc4-c21e8aa0cf4b
# ╠═16967fe9-64fb-464e-b11b-50d9eef4921a
# ╟─bfc4363d-7fb2-40ff-9bd2-b60889b1037d
# ╟─80585399-360f-464b-85d9-f4b8a5810e5e
# ╠═726ace2c-02d9-42b2-9853-e5e6f9ea8cf0
# ╠═3b4e09d3-c26c-4ca7-b079-af76f74088e3
# ╟─417091c1-c083-4b01-9ed7-05bc86bf9a9e
# ╠═f46e9d6f-d4d5-48aa-9d79-22c1a9f7797c
# ╠═8c856238-f518-4792-a9cb-d8b2e9016654
# ╟─0df3ba0c-f08c-4b1a-b3ec-e95971d7f799
# ╠═6d4dcc1b-4b5e-439f-b933-cd643e16585b
# ╠═b384b1d0-9e70-4e44-b782-c01d0d0bc0a0
# ╟─d5d89e90-9a71-48c4-83e4-58458fe4e85c
# ╠═094ffc36-8ab4-4114-b699-0ce11c453480
# ╠═6ce476ac-39cb-4405-9ef5-5eef50aa34d6
# ╟─57fcdfb8-6379-4301-83b3-5d7f06762b6b
# ╠═d6a1b8d4-798a-4a45-88f2-d47886778824
# ╠═1da3c6b6-89a4-4bf0-9522-e9b10e303876
# ╠═efddb751-d16e-45a2-9ce8-a33798d19f7d
# ╠═d5696cea-a78b-489e-bce6-edf6e18f2aca
# ╟─7b2a86f1-450f-462c-a461-0ec1fd41048e
# ╟─f217f411-0951-45a9-81af-5e576dd3e43d
