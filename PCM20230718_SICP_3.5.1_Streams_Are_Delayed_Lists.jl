### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ f58ce280-421a-447a-83ce-b87d3f53e58d
using Primes

# ╔═╡ bcace280-258c-11ee-0c90-1943c2f560fa
md"
====================================================================================
#### SICP: [3.5.1 Streams Are Delayed Lists](https://web.mit.edu/6.001/6.037/sicp.pdf)
##### file: PCM20230718\_SICP\_3.5.1\_Streams\_Are\_Delayed\_Lists.jl
##### Julia/Pluto.jl-code (1.9.2/0.19.26) by PCM *** 2023/07/27 ***

====================================================================================
"

# ╔═╡ a5beb46b-df99-4fd1-9dbb-ea8dfd84a6b8
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ 0b528dd5-6118-42aa-8a2e-a6ca1753aec9
md"
---
##### 3.5.1.1 SICP-Scheme like functional Julia
"

# ╔═╡ 6fd11c30-0eec-4fb8-a34d-06df24bec5c1
md"
---
###### Constructors
"

# ╔═╡ aaefe422-444e-44fc-8dbd-e39dd89eb398
#---------------------------------------------------
# taken from ch. 2.2.1
#---------------------------------------------------
struct Cons
	car
	cdr
end

# ╔═╡ 45545028-cab7-4742-8fd7-07ca5e091d96
cons(car, cdr) = Cons(car, cdr)     # 'Cons' is a structure with 'car' and 'cdr'

# ╔═╡ 93fc8894-5a52-45a3-9676-d6f2a815fad6
#=
#----------------------------------------------
# taken from 3.3.1
#----------------------------------------------
mutable struct mCons # 'mutable' is dangerous ! 
	car
	cdr
end # struct mCons
=#

# ╔═╡ 76005389-4410-41b9-a26d-82ffe7f21ed9
#---------------------------------------------------
# taken from ch. 2.2.1
#---------------------------------------------------
list(elements...) = 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], list(elements[2:end]...))
	end #if

# ╔═╡ 28d427d3-75c9-4a51-b461-1b27ea560fca
#---------------------------------------------------
# taken from ch. 2.2.1
#---------------------------------------------------
function enumerateInterval(low, high; initial = :nil) 
	if >(low, high)             
		initial
	else
		cons(low, enumerateInterval(+(low, 1), high; initial)) 
	end # if                                    
end # function enumerateInterval

# ╔═╡ 6404d550-b7c1-4edb-930d-97290775c66e
itvl_010 = enumerateInterval(0, 10)

# ╔═╡ bfab936d-9e01-45ac-a2f7-4bd4bd35e153
md"
---
###### Selectors
"

# ╔═╡ c1976f25-450f-42f7-ab66-49a5e56546f8
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
car(cons::Cons) = cons.car

# ╔═╡ faeede4e-ccf3-4128-b118-5db0f1308351
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
cdr(cons::Cons) = cons.cdr

# ╔═╡ 24f150d3-7e00-41fa-bc7c-5c85077431ed
#------------------------------------------------------------------------------------
# taken from 3.3.3.1
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

# ╔═╡ 103f5491-0deb-4fbf-b3d8-76a4286ce815
pp(itvl_010)

# ╔═╡ c2f636d5-5b07-4cf9-a25a-c8560170c103
md"
---
###### Predicates
"

# ╔═╡ 4c5af6e4-195d-40af-b9cf-c741b9e0d7d8
#--------------------------------------------------------
# taken from ch. 2.2.1
#--------------------------------------------------------
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function null

# ╔═╡ 01a523e6-7da8-476a-9bf8-ca2f84511f96
#------------------------------------------------------------
# taken from ch. 2.2.3
#   'accumulate' (without postfix '2') is Julia's accumulate
#------------------------------------------------------------
function accumulate2(op, initial, sequence)  
	if null(sequence)
		initial
	else
		op(car(sequence), 
			accumulate2(op, initial, cdr(sequence)))
	end # if
end # function accumulate

# ╔═╡ 7fcaa7ea-52e3-42be-b494-4ecc318379aa
accumulate2(+, 0, list(0, 1, 2, 3, 4, 5))

# ╔═╡ 81d9dda8-3cb2-4ab1-96fa-19f28d8a879c
#--------------------------------------------------------
# taken from ch. 2.2.3
# filter (without postfix '2') is Julia builtin function 
#--------------------------------------------------------
function filter2(predicate, sequence)   
	if null(sequence)
		:nil
	elseif predicate(car(sequence))
		cons(
			car(sequence), 
			filter2(predicate, cdr(sequence)))
	else
		filter2(predicate, cdr(sequence))
	end # if
end # function filter2

# ╔═╡ 0c47d0eb-db60-4ca7-b5ca-7a1e86d579d4
pp(filter2(isodd, list(1, 2, 3, 4, 5)))

# ╔═╡ b6b51c96-9c21-4b4e-9e29-24d42c0ad75b
md"
---
###### [*Sum of Primes*](https://web.mit.edu/6.001/6.037/sicp.pdf) in an Interval $[a, b]$: Standard Iterative Style by Tail-Recursion
(SICP, p.318(print, [html](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-24.html#%_sec_3.5.1)), [p.431(pdf)](https://web.mit.edu/6.001/6.037/sicp.pdf))
"

# ╔═╡ b4ec578a-07db-49cd-8a5b-c3bc4a8ea80f
function sumPrimes(a, b)                          #  SICP, p.318 
	function iter(count, accum)
		count > b ? accum :
		if isprime(count)                         # Julia's isprime
			iter(+(count, 1), +(count, accum)) 
		else
			iter(+(count, 1), accum)
		end # if
	end # function iter
	iter(a, 0)
end # function sumPrimes

# ╔═╡ 34524b57-c71d-4718-93db-68f9278ab3ea
sumPrimes(0, 0)

# ╔═╡ 48a0ce27-464d-4b15-aef5-73b80a4f363e
sumPrimes(0, 1)

# ╔═╡ a2f38e84-3e91-4c35-9097-d81999a7b8fa
sumPrimes(0, 2)

# ╔═╡ 39741aa7-83de-4332-81dc-12f41836dc6e
sumPrimes(0, 3)

# ╔═╡ b99baae6-4de8-435b-84c8-fb2eaa5985b8
sumPrimes(0, 10)                         # ==> 17  -->  :)

# ╔═╡ 5a98e257-7a8f-4771-8a29-ac5b4faa2775
sumPrimes(0, 100)                        # ==> 1060  -->  :)

# ╔═╡ 15f717e8-7196-46d7-b252-1241bfb20cd8
sumPrimes(0, 1000)                       # ==> 76127  -->  :)

# ╔═╡ f6ce4638-173f-44df-a99e-7cf14c21f9a7
md"
---
###### *Sum of Primes* within an Interval $[a, b]$: Standard Iterative Style by $While$-Loop
"

# ╔═╡ 8126771c-6e40-4dd7-84fb-7d395ef32e37
function sumPrimes2(a, b) 
	count = a
	accum = 0
	while !(count > b)
		if isprime(count)  
			accum = +(count, accum)
		end # if
		count = +(count, 1)
	end # while
	accum
end # function sumPrimes2

# ╔═╡ 0a0ab68a-c564-4d79-beec-fde44d004d2c
sumPrimes2(0, 1000)                        # ==> 76127  -->  :)

# ╔═╡ e46254fb-ceda-4009-a462-870f7849f8c9
md"
---
###### *Sum of Primes* within an Interval $[a, b]$:  By Function Composition
*Selecting* after *Reducing* after *Filtering* after *Constructing* a complete *Collection*
"

# ╔═╡ e66c1018-8bd0-450e-ade3-80d0c1849e8a
function sumPrimes3(a, b)                  # ==> SICP, p.318
	accumulate2(+, 0, filter2(isprime, enumerateInterval(a, b)))
end # function sumPrimes3

# ╔═╡ 4a46e5c4-9893-4fe3-8201-110192d41db9
sumPrimes3(0, 10)                          # ==> 17  -->  :)

# ╔═╡ 86f2cfc3-5d80-413e-a22c-14b0e3f5f1ce
sumPrimes3(0, 1000)                        # ==> 76127  -->  :)

# ╔═╡ 3ea6e3c8-eece-4e1d-a9a7-052bb8331036
md"
---
###### Compute the *2nd Prime* in the Interval $[a, b]$ by Function Composition
"

# ╔═╡ 4e8e8ac8-baa1-490d-9ae7-fb509c46e27f
function secondPrime(a, b)                 # ==> SICP, p.318
	car(cdr(filter2(isprime, enumerateInterval(a, b))))
end # function secondPrime

# ╔═╡ 49b5b648-af84-40e6-93be-262178c6052f
secondPrime(0, 10)

# ╔═╡ 5946ab1d-b398-44f2-9f37-271108128d2a
convert(Int, 1E4)

# ╔═╡ 13012820-dab2-4ead-a09d-775bf705ec74
md"
---
The task $(car(cdr(filter prime? (enumerate-interval 10000 1000000))))$ (SICP, p.318)
leads by direct transpilation of SICP-Scheme into Julia to a 'StackOverflowError'. So we switch later to Julia's *generators* which does avoid that error.
"

# ╔═╡ 37d3791d-28fe-4092-b674-51d7c910b897
convert(Int, 1E6)

# ╔═╡ 5080a5d0-985b-446f-9a6d-dafebaafa174
secondPrime(convert(Int, 1E4), convert(Int, 1E6))

# ╔═╡ e040af07-3e93-493d-95c7-b7711a4019cd
md"
---
##### 3.5.1.2 Streams
"

# ╔═╡ 2a5befc0-667f-4aad-859d-d55f4479b7b8
md"
---
###### 3.5.1.2.1 Basic Stream Functions
"

# ╔═╡ 222f7053-7d27-459e-bf37-9267dc0f41cb
md"
###### Implementation of $delay$ and $force$
(SICP, p.323f)
"

# ╔═╡ d198f25a-3cb7-422d-96a7-34a9deaef218
md"
SICP-authors (p.321, footnote 56) write, that $delay$ and $consStream$ should be *special forms* which do *not* evaluate some of its arguments. This is called *call-by-need* or *lazy-evaluation*. So $delay$ delays its only and $consStream$ its second argument. Because Julia does not offer *call-by-need* we have to simulate that by embedding *arguments* of function calls into the *body* of anonymous *closures*.

"

# ╔═╡ 953de913-31fa-4834-90a8-113a9d7b8331
# should be called with an anonymous closure
begin
	delay(closure::Function) = closure                 # SICP, p.323
	delay(arg) = 
		println("arg of 'delay' should be embedded in the body of the closure '()->arg'")
end # begin

# ╔═╡ cfdd912c-8a18-4438-b215-58195da4b6bf
md"
###### *Delaying* evaluation of *argument* by embedding in an anonymous function
"

# ╔═╡ 12a2f481-6dfb-475b-a173-b7738eaf6a9b
delay(2+3)

# ╔═╡ 740d54d6-6b95-405a-a2a1-ede8fb1b12aa
delayedExpr5 = delay(() -> 2+3)                         # call with closure

# ╔═╡ 7e3882a8-a13e-4ea8-a33f-adb0e38253e9
delayedExpr5                                            # ==> ()-> 2+3

# ╔═╡ 1bb7b41e-23c7-4e14-95c3-c1ac7c4d3955
delayedExpr5()

# ╔═╡ fe07ce11-1755-4495-aec2-b57ff49d4738
begin
	force(delayedObject::Function) = delayedObject()    # SICP, p.323
    force(argument) = println("argument of force should be an anonymous closure '()->...'")
end # begin

# ╔═╡ a3993473-692f-493c-a2a8-2855d1dcf281
force(3+5)

# ╔═╡ ae86a9e4-ec64-4c16-8cc5-077a95cdc891
force(delayedExpr5)                                     # ==> 5  -->  :)

# ╔═╡ 489e7fad-3d9e-4ec5-a3bd-cbf4823c0432
force(delay(() -> 2+3))                                 # ==> 5  -->  :)

# ╔═╡ 2c94b8c6-2e70-4bc8-82cd-bca7369dbc76
md"
---
###### Scheme-like Constructors
"

# ╔═╡ a4387001-2617-48a3-b1f9-7c4003935906
theEmptyStream = list(:nil)                             # SICP, p.319, footnote 54

# ╔═╡ 4c93bba9-5fa2-47cf-863a-2fe7b84200a0
begin
	#------------------------------------------------------------------------------
	function consStream(x, arg::Function)               # SICP, p.321, footnote 56
		cons(x, delay(arg))
	end # function consStream
	#------------------------------------------------------------------------------
	function consStream(x, arg)                         # SICP, p.321, footnote 56
		println("the 2nd arg of consStream should be an anonymous closure ()->arg")
	end # function consStream
	#------------------------------------------------------------------------------
end # begin

# ╔═╡ cf2330fc-42e4-4712-8c16-5250703781f4
consStream((), theEmptyStream)

# ╔═╡ 7acf7a35-0440-49c5-80dc-4d9866084412
emptyStream = consStream(:nil, () -> theEmptyStream)

# ╔═╡ 6975833d-5ee6-49ed-8f3f-efe4336e3a23
md"
---
###### Scheme-like Selectors
"

# ╔═╡ fc8a51ea-16e4-4186-9e3b-66dca96de452
streamCar(stream) = car(stream)                      #  SICP, p.319

# ╔═╡ 4c278fc7-ddd3-4898-95d2-51400f0c7319
streamCdr(stream) = cdr(stream)                      #  SICP, p.319

# ╔═╡ be5515a4-7590-4686-b94c-4a8dcd805dd5
md"
---
###### Scheme-like Predicates
"

# ╔═╡ 3990f7d2-b9fb-478b-abef-bd8fdc7546f4
streamNull = null                                    #  SICP, p.319, footnote 54

# ╔═╡ b4b97dd2-4324-46fb-8d97-f1cca1d73754
streamNull(emptyStream)

# ╔═╡ 0cd51fd5-c0e2-4722-9ae3-da4c5c1b9c1f
function streamRef(stream::Function, n)                        #  SICP, p.319
	if ==(n, 0)
		streamCar(stream())
	else
		streamRef(streamCdr(stream()), -(n, 1))
	end # if
end # function streamRef

# ╔═╡ 4522244e-cbd5-4da2-963e-0ec76a4476df
md"
--- 
###### Basic Stream Functions
"

# ╔═╡ 8c8e31af-f95e-4426-84c0-0d3405410962
function streamEnumerateInterval(low, high)          #  SICP, p.321
	if !(low < high)
		theEmptyStream
	else
		consStream(low, () -> streamEnumerateInterval(+(low, 1), high))
	end # if
end # function streamEnumerateInterval

# ╔═╡ 59f38885-326a-41d8-a5f5-17aaee0d4a67
streamEnumerateInterval(0, 0)

# ╔═╡ 2cfe5b8d-5a27-45d0-bb13-6272023535ff
streamNull(streamEnumerateInterval(0, 0))

# ╔═╡ 57b98ae5-1e50-481c-8a8a-017fc41eebdc
function streamFilter(pred, stream::Function)        #  SICP, p.322
	if streamNull(stream())
		theEmptyStream                               #  ==> Cons(:nil, :nil)  -->  :)
	elseif pred(streamCar(stream()))
		consStream(
			streamCar(stream()), 
			() -> streamFilter(pred, streamCdr(stream())))
	else 
		streamFilter(pred, streamCdr(stream()))
	end # if
end # function streamFilter

# ╔═╡ e60ed676-fb04-49ee-9fe7-62def4722a66
isprime(0)

# ╔═╡ 43d77dde-55a3-4a1d-a02f-0c5b7bb480ee
isprime(1)

# ╔═╡ 599dbc6d-5e4f-4662-94b6-fb5aae84e813
isprime(2)

# ╔═╡ a8672aa1-9734-4d07-a47b-0a895b8857dc
isprime(3)

# ╔═╡ 8a0f9abc-21dd-46bb-b08e-ab20619b25c1
streamNull((() -> streamEnumerateInterval(0, 0))())

# ╔═╡ 79ee2d96-203a-4fc2-b0a0-c01bc57bda46
streamFilter(isprime, () -> streamEnumerateInterval(0, 0))

# ╔═╡ c90e9a6c-fdfa-40ac-8e9d-0822a4ac29a7
streamFilter(isprime, () -> streamEnumerateInterval(0, 1))

# ╔═╡ bf83b37a-8f27-416e-b413-90b3182e1598
streamFilter(isprime, () -> streamEnumerateInterval(0, 3))

# ╔═╡ 58c46f3c-a428-4d97-89e7-0d7ed3b96839
md"
---
###### 3.5.1.2.2 The Stream Implementation in Action
(SICP, p.321ff)
"

# ╔═╡ 882e76d3-ec46-4aaa-83ad-eb3a46f24760
stream1E5 = () -> streamEnumerateInterval(0, convert(Int, 1E5))

# ╔═╡ cfd7f42f-0c7a-46ac-9999-90f072b2df8f
streamRef(stream1E5, 9999)

# ╔═╡ 00558f9f-aae3-4c15-9db2-f61880a7a661
streamCar(force(streamCdr(stream1E5())))

# ╔═╡ 48756b2c-e02b-44f1-8bb4-3241d95ea9bf
md"
---
###### 1st prime in the interval $low, high$
"

# ╔═╡ 565c7b4c-70ba-4539-ad16-9dec50deb87a
streamCar(streamFilter(isprime, () -> streamEnumerateInterval(0, 15)))

# ╔═╡ fdc6dc94-d863-4b08-b30a-752b82c1e393
streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(0, 15)))

# ╔═╡ 46bdac59-d64f-43f1-831e-513868f89196
md"
---
###### 2nd prime in the interval $low, high$
"

# ╔═╡ 5dbe7e39-c16a-424e-a126-9c3601545b22
streamCar(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(0, 15)))())

# ╔═╡ 4f5205e4-44a0-4ff6-a3ba-bf5e03dc3ab2
streamCar(force(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(0, 15)))))

# ╔═╡ ff22ed83-77fc-4647-9a81-acc9934895d5
streamCar(force(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(100, 1000)))))

# ╔═╡ 98b97d1e-d8e4-4990-8240-ab7740e91c93
streamCar(force(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(convert(Int, 1E2), convert(Int, 1E3))))))   #  SICP, p.321

# ╔═╡ 27e0a31e-83e8-413c-90f7-6be46a58def8
isprime(1001), isprime(1003), isprime(1005), isprime(1007), isprime(1009), isprime(1011), isprime(1013), isprime(1019), isprime(1021)

# ╔═╡ dfe8a34f-ec71-480a-bb40-361dc201d4a3
streamCar(force(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(convert(Int, 1E3), convert(Int, 1E4))))))   #  SICP, p.321

# ╔═╡ 71e19cfa-99d2-475d-be44-7c602fe16bdb
streamCar(force(streamCdr(streamFilter(isprime, () -> streamEnumerateInterval(convert(Int, 1E4), convert(Int, 1E5))))))   #  SICP, p.321

# ╔═╡ 5374e515-5e45-4355-9b2f-1e6f5d292728
streamCar(force(streamCdr(streamFilter(isprime, () ->     streamEnumerateInterval(convert(Int, 1E4), convert(Int, 1E6))))))   #  SICP, p.321

# ╔═╡ fd277186-3980-4541-a557-03c96251377e
md"
---
+++++++
"

# ╔═╡ 651d91cb-f88e-4efe-aed1-04f1fd99e394
md"
The example on SICP(p.321) cannot be replicated in Julia with the interval $streamEnumerateInterval(10000, 1000000)$ because of the StackOverFlowError. So we have to reimplement that in idiomatic Julia with *generators*.
"

# ╔═╡ 843c8285-8fd8-4515-89bf-9cfa38cc081a
md"
---
##### 3.5.1.3 Idiomatic Julia
"

# ╔═╡ fd9cb7a3-190f-4a14-bd81-373a11ff205a
md"
###### Nesting Function Calls with $last, accumulate, filter, isprime, a:b$
"

# ╔═╡ 6404417e-ee27-422e-b894-430b0484ecb5
function sumPrimes4(a, b) 
	# accumulate(+, filter(isprime, a:b), init=0) # ==> vector of cumulative sums
	last(accumulate(+, filter(isprime, a:b), init=0)) # last cumulative sum
end # function sumPrimes4

# ╔═╡ dbf7482b-a12e-45a4-81a9-c64e410d2f7c
sumPrimes4(0, 10)                  # ==> 17 -->  :)

# ╔═╡ 2d37f74e-aff9-494b-9d24-ed5c6f1ea256
sumPrimes4(0, 1000)                # ==> 76127  -->  :)

# ╔═╡ 0a3fdb90-d9cf-46bf-bb7d-d4203e2b9f95
function sumPrimes5(a, b)
	last(accumulate(+, (i for i in a:b if isprime(i)), init=0))
end # function sumPrimes5

# ╔═╡ 32b1fb25-35c1-4f84-8d30-d9f61d123d91
sumPrimes5(0, 10)  

# ╔═╡ f794d125-d074-4a2f-b145-1e5ac039309c
sumPrimes5(0, convert(Int, 1E3))   # ==> 76127  -->  :)

# ╔═╡ 381c63dc-83ec-4327-af5d-e88aa2a5101e
md"
---
###### Compute the 2nd prime in the interval $[a, b]$
"

# ╔═╡ cee8b671-aa8d-48bd-83f9-9821ced44679
#----------------------------------------------------------------------------
# extract the second element from the collection of primes 
#   which are output from a filtered generator expression
#----------------------------------------------------------------------------
function secondPrime2(a, b)
	(item, state1) = iterate(i for i in a:b if isprime(i)) # ==> (1007, 1)
	iterate((i for i in a:b if isprime(i)), state1)[2]     # ==> 1009
end # function secondPrime2

# ╔═╡ f120fc70-9802-4a94-8e1f-f6ede6e9c638
convert(Int, 1E4)

# ╔═╡ da198a9f-ea55-4f8f-ab21-e11c6972f4cc
secondPrime2(convert(Int, 1E4), convert(Int, 1E5))  #  ==> 10009  -->  :)

# ╔═╡ dc28b878-a2b6-4dc7-92b1-8560be5e353b
isprime(10001), isprime(10003), isprime(10007), isprime(10009)

# ╔═╡ 46909792-d176-4dc5-a20f-423f88f6e9f5
secondPrime2(convert(Int, 1E4), convert(Int, 1E6))  #  ==> 10009  -->  :)

# ╔═╡ 533a4165-1bee-4086-86ef-c015749a7e57
#----------------------------------------------------------------------------
# extract the nth-element from the collection of primes 
#   which are output from a filtered generator expression
#   default is n=2
#----------------------------------------------------------------------------
function secondPrime3(a, b; n=2)
	j = 1
	(item, state) = iterate(i for i in a:b if isprime(i))
	while !(j == n)
		j += 1
		(item, state) = iterate((i for i in a:b if isprime(i)), state)
	end # while
	item
end # function secondPrime3

# ╔═╡ c8611f00-e988-42e4-a998-d1a6162f2c60
secondPrime3(convert(Int, 1E4), convert(Int, 1E6))       #  ==> 10009  -->  :)

# ╔═╡ 843ffeee-84de-4157-a20b-a6cf31c2dcf7
secondPrime3(convert(Int, 1E4), convert(Int, 1E6), n=3)  #  ==> 10037  -->  :)

# ╔═╡ 49ed21e5-9c2d-4f8b-bbe2-a4aed65d503d
md"
---
##### References
"

# ╔═╡ 5fa3f4b6-a909-4de5-ae25-826f6af6881b
md"
---
##### end of Ch. 3.5.1
"

# ╔═╡ 1a6ad183-9846-462b-8c2e-d0f9816df11c
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
Primes = "~0.5.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "5a563fd5f9f3da9fba9e3731cc14275567a45417"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "311a2aa90a64076ea0fac2ad7492e914e6feeb81"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.3"
"""

# ╔═╡ Cell order:
# ╟─bcace280-258c-11ee-0c90-1943c2f560fa
# ╠═a5beb46b-df99-4fd1-9dbb-ea8dfd84a6b8
# ╠═f58ce280-421a-447a-83ce-b87d3f53e58d
# ╟─24f150d3-7e00-41fa-bc7c-5c85077431ed
# ╟─0b528dd5-6118-42aa-8a2e-a6ca1753aec9
# ╟─6fd11c30-0eec-4fb8-a34d-06df24bec5c1
# ╠═aaefe422-444e-44fc-8dbd-e39dd89eb398
# ╠═45545028-cab7-4742-8fd7-07ca5e091d96
# ╠═93fc8894-5a52-45a3-9676-d6f2a815fad6
# ╠═76005389-4410-41b9-a26d-82ffe7f21ed9
# ╠═28d427d3-75c9-4a51-b461-1b27ea560fca
# ╠═6404d550-b7c1-4edb-930d-97290775c66e
# ╠═103f5491-0deb-4fbf-b3d8-76a4286ce815
# ╠═01a523e6-7da8-476a-9bf8-ca2f84511f96
# ╠═7fcaa7ea-52e3-42be-b494-4ecc318379aa
# ╟─bfab936d-9e01-45ac-a2f7-4bd4bd35e153
# ╠═c1976f25-450f-42f7-ab66-49a5e56546f8
# ╠═faeede4e-ccf3-4128-b118-5db0f1308351
# ╠═81d9dda8-3cb2-4ab1-96fa-19f28d8a879c
# ╠═0c47d0eb-db60-4ca7-b5ca-7a1e86d579d4
# ╟─c2f636d5-5b07-4cf9-a25a-c8560170c103
# ╠═4c5af6e4-195d-40af-b9cf-c741b9e0d7d8
# ╟─b6b51c96-9c21-4b4e-9e29-24d42c0ad75b
# ╠═b4ec578a-07db-49cd-8a5b-c3bc4a8ea80f
# ╠═34524b57-c71d-4718-93db-68f9278ab3ea
# ╠═48a0ce27-464d-4b15-aef5-73b80a4f363e
# ╠═a2f38e84-3e91-4c35-9097-d81999a7b8fa
# ╠═39741aa7-83de-4332-81dc-12f41836dc6e
# ╠═b99baae6-4de8-435b-84c8-fb2eaa5985b8
# ╠═5a98e257-7a8f-4771-8a29-ac5b4faa2775
# ╠═15f717e8-7196-46d7-b252-1241bfb20cd8
# ╟─f6ce4638-173f-44df-a99e-7cf14c21f9a7
# ╠═8126771c-6e40-4dd7-84fb-7d395ef32e37
# ╠═0a0ab68a-c564-4d79-beec-fde44d004d2c
# ╟─e46254fb-ceda-4009-a462-870f7849f8c9
# ╠═e66c1018-8bd0-450e-ade3-80d0c1849e8a
# ╠═4a46e5c4-9893-4fe3-8201-110192d41db9
# ╠═86f2cfc3-5d80-413e-a22c-14b0e3f5f1ce
# ╟─3ea6e3c8-eece-4e1d-a9a7-052bb8331036
# ╠═4e8e8ac8-baa1-490d-9ae7-fb509c46e27f
# ╠═49b5b648-af84-40e6-93be-262178c6052f
# ╠═5946ab1d-b398-44f2-9f37-271108128d2a
# ╟─13012820-dab2-4ead-a09d-775bf705ec74
# ╠═37d3791d-28fe-4092-b674-51d7c910b897
# ╠═5080a5d0-985b-446f-9a6d-dafebaafa174
# ╟─e040af07-3e93-493d-95c7-b7711a4019cd
# ╟─2a5befc0-667f-4aad-859d-d55f4479b7b8
# ╟─222f7053-7d27-459e-bf37-9267dc0f41cb
# ╟─d198f25a-3cb7-422d-96a7-34a9deaef218
# ╠═953de913-31fa-4834-90a8-113a9d7b8331
# ╟─cfdd912c-8a18-4438-b215-58195da4b6bf
# ╠═12a2f481-6dfb-475b-a173-b7738eaf6a9b
# ╠═740d54d6-6b95-405a-a2a1-ede8fb1b12aa
# ╠═7e3882a8-a13e-4ea8-a33f-adb0e38253e9
# ╠═1bb7b41e-23c7-4e14-95c3-c1ac7c4d3955
# ╠═fe07ce11-1755-4495-aec2-b57ff49d4738
# ╠═a3993473-692f-493c-a2a8-2855d1dcf281
# ╠═ae86a9e4-ec64-4c16-8cc5-077a95cdc891
# ╠═489e7fad-3d9e-4ec5-a3bd-cbf4823c0432
# ╟─2c94b8c6-2e70-4bc8-82cd-bca7369dbc76
# ╠═a4387001-2617-48a3-b1f9-7c4003935906
# ╠═4c93bba9-5fa2-47cf-863a-2fe7b84200a0
# ╠═cf2330fc-42e4-4712-8c16-5250703781f4
# ╠═7acf7a35-0440-49c5-80dc-4d9866084412
# ╠═b4b97dd2-4324-46fb-8d97-f1cca1d73754
# ╟─6975833d-5ee6-49ed-8f3f-efe4336e3a23
# ╠═fc8a51ea-16e4-4186-9e3b-66dca96de452
# ╠═4c278fc7-ddd3-4898-95d2-51400f0c7319
# ╟─be5515a4-7590-4686-b94c-4a8dcd805dd5
# ╠═3990f7d2-b9fb-478b-abef-bd8fdc7546f4
# ╠═0cd51fd5-c0e2-4722-9ae3-da4c5c1b9c1f
# ╟─4522244e-cbd5-4da2-963e-0ec76a4476df
# ╠═8c8e31af-f95e-4426-84c0-0d3405410962
# ╠═59f38885-326a-41d8-a5f5-17aaee0d4a67
# ╠═2cfe5b8d-5a27-45d0-bb13-6272023535ff
# ╠═57b98ae5-1e50-481c-8a8a-017fc41eebdc
# ╠═e60ed676-fb04-49ee-9fe7-62def4722a66
# ╠═43d77dde-55a3-4a1d-a02f-0c5b7bb480ee
# ╠═599dbc6d-5e4f-4662-94b6-fb5aae84e813
# ╠═a8672aa1-9734-4d07-a47b-0a895b8857dc
# ╠═8a0f9abc-21dd-46bb-b08e-ab20619b25c1
# ╠═79ee2d96-203a-4fc2-b0a0-c01bc57bda46
# ╠═c90e9a6c-fdfa-40ac-8e9d-0822a4ac29a7
# ╠═bf83b37a-8f27-416e-b413-90b3182e1598
# ╟─58c46f3c-a428-4d97-89e7-0d7ed3b96839
# ╠═882e76d3-ec46-4aaa-83ad-eb3a46f24760
# ╠═cfd7f42f-0c7a-46ac-9999-90f072b2df8f
# ╠═00558f9f-aae3-4c15-9db2-f61880a7a661
# ╟─48756b2c-e02b-44f1-8bb4-3241d95ea9bf
# ╠═565c7b4c-70ba-4539-ad16-9dec50deb87a
# ╠═fdc6dc94-d863-4b08-b30a-752b82c1e393
# ╟─46bdac59-d64f-43f1-831e-513868f89196
# ╠═5dbe7e39-c16a-424e-a126-9c3601545b22
# ╠═4f5205e4-44a0-4ff6-a3ba-bf5e03dc3ab2
# ╠═ff22ed83-77fc-4647-9a81-acc9934895d5
# ╠═98b97d1e-d8e4-4990-8240-ab7740e91c93
# ╠═27e0a31e-83e8-413c-90f7-6be46a58def8
# ╠═dfe8a34f-ec71-480a-bb40-361dc201d4a3
# ╠═71e19cfa-99d2-475d-be44-7c602fe16bdb
# ╠═5374e515-5e45-4355-9b2f-1e6f5d292728
# ╟─fd277186-3980-4541-a557-03c96251377e
# ╟─651d91cb-f88e-4efe-aed1-04f1fd99e394
# ╟─843c8285-8fd8-4515-89bf-9cfa38cc081a
# ╟─fd9cb7a3-190f-4a14-bd81-373a11ff205a
# ╠═6404417e-ee27-422e-b894-430b0484ecb5
# ╠═dbf7482b-a12e-45a4-81a9-c64e410d2f7c
# ╠═2d37f74e-aff9-494b-9d24-ed5c6f1ea256
# ╠═0a3fdb90-d9cf-46bf-bb7d-d4203e2b9f95
# ╠═32b1fb25-35c1-4f84-8d30-d9f61d123d91
# ╠═f794d125-d074-4a2f-b145-1e5ac039309c
# ╟─381c63dc-83ec-4327-af5d-e88aa2a5101e
# ╠═cee8b671-aa8d-48bd-83f9-9821ced44679
# ╠═f120fc70-9802-4a94-8e1f-f6ede6e9c638
# ╠═da198a9f-ea55-4f8f-ab21-e11c6972f4cc
# ╠═dc28b878-a2b6-4dc7-92b1-8560be5e353b
# ╠═46909792-d176-4dc5-a20f-423f88f6e9f5
# ╠═533a4165-1bee-4086-86ef-c015749a7e57
# ╠═c8611f00-e988-42e4-a998-d1a6162f2c60
# ╠═843ffeee-84de-4157-a20b-a6cf31c2dcf7
# ╟─49ed21e5-9c2d-4f8b-bbe2-a4aed65d503d
# ╟─5fa3f4b6-a909-4de5-ae25-826f6af6881b
# ╟─1a6ad183-9846-462b-8c2e-d0f9816df11c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
