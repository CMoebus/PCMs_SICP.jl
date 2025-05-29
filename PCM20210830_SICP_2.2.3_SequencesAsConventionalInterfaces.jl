### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 81769c4b-f881-46ed-bb34-b4aae56692e2
begin 
	#----------------------------------------------------------------------------
	using Pluto
	using Plots	
	using LaTeXStrings, Latexify
	using GraphRecipes
	using Primes
	#----------------------------------------------------------------------------
	println("pkgversion(Pluto)              = ", pkgversion(Pluto))
	println("pkgversion(Plots)              = ", pkgversion(Plots))
	println("pkgversion(Latexify)           = ", pkgversion(Latexify))
	println("pkgversion(GraphRecipes)       = ", pkgversion(GraphRecipes))
	println("pkgversion(Primes)             = ", pkgversion(Primes))
	#----------------------------------------------------------------------------
end # begin

# ╔═╡ ba6ee9c0-0999-11ec-3197-6b273cb47913
md"
=====================================================================================
### SICP: [2.2.3 Sequences As Conventional Interfaces](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-15.html#%_sec_2.2.3)

###### file: PCM20210830\_SICP\_2.2.3\_SequencesAsConventionalInterfaces.jl

###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/05/29 ***
=====================================================================================
"

# ╔═╡ da0d9d80-35ad-47eb-b8e3-751ed06bb7bc
md"
---
##### 0. Introduction
*In working with compound data, we've stressed how data abstraction permits us to design programs without becoming enmeshed in the details of data representations, and how abstraction preserves for us the flexibility to experiment with alternative representations. In this section, we introduce another powerful design principle for working with data structures -- the use of conventional interfaces.*

*In section 1.3 we saw how program abstractions, implemented as higher-order procedures, can capture common patterns in programs that deal with numerical data. Our ability to formulate analogous operations for working with compound data depends crucially on the style in which we manipulate our data structures.* (SICP, 1996, p.113; 2016, p.154)

"

# ╔═╡ 1c35199b-648f-4147-a3d0-061c5606ae0f
md"
---
**Sequences, implemented here as lists, serve as a conventional interface that permits us to combine processing modules.** *Additionally, when we uniformly represent structures as sequences, we have localized the data-structure dependencies in our programs to a small number of sequence operations. By changing these, we can experiment with alternative representations of sequences, while leaving the overall design of our programs intact.*(SICP, 1996, p.118; 2016, p.161)
"

# ╔═╡ 71fc8524-e0b5-4cab-b6d7-a87e4753e3ff
md"
---
Before we implemented *lists* as *sequences* of $NamedTuple$ or $struct Cons$. Here we switch over to *sequences* of type $Vector$. These are flexible enough to contain not only elements of *same* but also of *different* types.
"

# ╔═╡ 5dedb37c-6a47-490d-bc3c-1f8ac94c6e95
md"
---
##### 1. Topics
- *self-defined* type $Atom$
- *self-defined* type $VectorOrAtom$
- *binary* tree
- *graphical* representation of *binary* trees
- *nested* array
- *mapping* with $map$
- loop with $for$
- mapping with $do$
- *parallel* assignment
- *printing* of test infos with $println$
- *slurping* and *spitting* operator $'...'$
- *function* $foldl, foldr$
- 
"

# ╔═╡ 070962ea-5876-4fdc-8f17-bd851360e2ec
md"
---
##### 2. Libraries, Types, Aliases, and Service Functions

###### 2.1 Libraries
"

# ╔═╡ af7dd73c-17ab-47b6-a26e-a8315b108a8d
md"
---
###### 2.2 *Self-defined* Types
"

# ╔═╡ 2c993a00-c67c-4340-8229-6c77bb99bf89
Atom = Union{Number, Symbol, Char, String}               # similar to Scheme-Atom

# ╔═╡ 79cc2784-f08a-431b-92b7-9cbadcda9e82
VectorOrAtom = Union{Vector, Atom}

# ╔═╡ 9a1a09d8-912b-4249-a34b-60e8feafa8ea
Sequence = Vector 

# ╔═╡ 07dc0c06-766b-4170-ad95-733eb93ea707
Vector <: AbstractVector

# ╔═╡ de0cf05c-78c2-4d2a-b14a-14ff82661073
Sequence <: AbstractVector

# ╔═╡ dcac923c-7ab6-4828-8d10-ad3dd2d331f7
md"
---
###### 2.3 Abbreviations (*alias* names)
The purpose of *aliases* is to bind *short* SICP-like function *names* to *long, informative* Julian *counterparts*.
"

# ╔═╡ 7fc8fce0-a627-4574-8384-b9ec97554228
pp(oldVector::Vector)::TupleOrAtom =
	ppVectorAsTuple(oldVector::Vector)::TupleOrAtom

# ╔═╡ 628828c2-fa11-4b13-a4f7-9bac84424031
md"
---
###### 2.4 Service Functions
"

# ╔═╡ e3557c59-930e-4668-844c-667e45700847
listElementsAsVector(xs::Any...)::Vector = 
	[xs::Any...]::Vector  # slurping and spitting with '...'

# ╔═╡ 34b7facc-bcf8-47cb-a2ff-2a3eb4c05893
list(xs::Any...)::Vector = 
	listElementsAsVector(xs::Any...)::Vector

# ╔═╡ 438e40ec-ac14-4541-9086-c051bcf97372
md"
---
##### 3. SICP-Scheme-like *Functional* Julia
###### 3.1 Constructor $cons$ and Selectors $car, cdr$
"

# ╔═╡ 04d6ca0c-f67d-4cea-9166-20d98115f350
md"
---
###### *1st* Method of *Constructor* $cons$
"

# ╔═╡ d1bb66f0-18f0-4caf-b44c-7a8f27304859
# idiomatic Julia with 1st method of cons
cons(elements...) =               # slurping elements with '...'
	list(elements...)             # spitting elements with '...'

# ╔═╡ fe893e8b-b320-435f-a242-54eab8cb6326
md"
###### *2nd* Method of *Constructor* $cons$
"

# ╔═╡ 3e4877f4-fa79-4c7b-8004-35d5e5bcd798
# idiomatic Julia with 2nd method of cons
function cons(car::Atom, vector::VectorOrAtom)::Vector
	pushfirst!(vector, car)
end

# ╔═╡ fc576d60-5ada-4348-a753-b86a81793d01
md"
---
###### *1st* Method of *Selector* $car$
"

# ╔═╡ e92f11f1-082a-43c3-b55f-1a2f795386d2
# 2nd method for car
car(xs::Vector) = xs[1]

# ╔═╡ 8aba03d0-b7af-4c5e-b990-f660b0384bc7
md"
---
###### *1st* Method of *Selector* $cdr$
"

# ╔═╡ 3c2238a3-158b-426e-b81a-927d4a117525
cdr(xs::Vector) = xs[2:end]

# ╔═╡ a484dd0e-9e53-41d9-89f3-4e6d081fa969
md"
---
##### 3.2 *Example* Functions for Sequences
"

# ╔═╡ ede3a48f-71c0-4ddc-8f98-0590b817ef17
md"
---
###### 3.2.1 *Tree Recursion* in Function $sumOddSquares$ (like in $countLeaves$ in 2.2.2)

*Consider, for example, the following procedure, analogous to the $countLeaves$ procedure of section 2.2.2, which takes a tree as argument and computes the sum of the squares of the leaves that are odd* (SICP, 1996, 2016) 

The characteristics of function $sumOddSquares$ (SICP, 1996, p.113; [2016, p.155](https://web.mit.edu/6.001/6.037/sicp.pdf)) are:

- it *enumerates the leaves of a tree*
- it *filters them, selecting the odd ones*
- it *squares each of the selected ones* 
- it *accumulates the results using* $+$, *starting with* $0.$

"

# ╔═╡ 069ee324-eceb-4f42-ae20-aac2e4478b2b
function sumOddSquares(tree)   
	#---------------------------------------------------------------------------
	# local definitions
	#--------------------------------------------------------------
				null = isempty         # Julia Base.isempty(collection) -> Bool
	isnumber(x::Any) = typeof(x) <: Number
	          isleaf = isnumber
	       square(x) = *(x, x)
	             odd = isodd           # Julia Base.isodd(x::Number) -> Bool
	#---------------------------------------------------------------------------
	# body of function
	#---------------------------------------------------------------
	if null(tree)                      # is tree empty ?
		0
	elseif isnumber(tree)              # is leaf a number ?   
		odd(tree) ? square(tree) : 0   # if leaf is odd then square
	else                               # else step down and recur
		+(sumOddSquares(car(tree)), sumOddSquares(cdr(tree))) # tree recursion
	end # if
end # function sumOddSquares

# ╔═╡ 6f0273fd-b5cf-41e6-bcc1-3e62ec52f760
md"
---
                                            tree
                                             /\
                             car(tree) ---> /  \  <--- cdr(tree)
                                           /   /\
                                          /   /  \ 
                                         /   /    \
                                        /   /      \
                                       /   /        \
                                      /   /          \
                                     /   /            \
                                    /   /              \
                                   /   /\               \
                                  /   /  \               \
                                 /   /   /\               \    
                                /   /   /  \               \
                               /   /   /    \              /\
                              /   /   /      \            /  \
                             /   /   /\       \          /\   \
                            /   /   /  \       \        /  \   \
                           /   /   /   /\      /\      /   /\   \
                          /   /   /   /  \    /  \    /   /  \   \
                         1   2   3   4  :nil 5  :nil 6   7  :nil :nil

                                     ^--- car(cdr(car(cdr(car(cdr(tree)))))) ==> 4
 
**Fig. 2.2.3.1**: Graphical representation of binary $tree$ as nested array $[1, [2, [3, 4], 5], [6, 7]]$

"

# ╔═╡ 9f0808b5-1130-4603-9f8b-7359560f5672
md"
---
            tree
              |
              | cdr                                                    
       1      +-----+------------------------------------+------------------+
          car |     |                                    |                  |
       2      |     +-----------------------+-----+      +-----+-----+      |
              |     |     |                 |     |      |     |     |      |
       3      |     |     +-----+-----+     |     |      |     |     |      |
              |     |     |     |     |     |     |      |     |     |      |
       4      1     2     3     4   :nil    5   :nil     6     7   :nil   :nil

                                ^--- car(cdr(car(cdr(car(cdr(tree))))))

**Fig. 2.2.3.2**: Alternatíve representation of binary tree $tree$ as nested array $[1, [2, [3, 4], 5], [6, 7]]$

"

# ╔═╡ 00e8e8e8-592e-4206-80c9-7308d5d6e151
tree = list(1, list(2, list(3, 4), 5), list(6, 7))

# ╔═╡ 8824f5f4-4f29-48d7-8d07-a5a767c47ac4
typeof(tree) <: Vector <: Array

# ╔═╡ 2bba24d2-79ee-4923-a6b5-e0e9a4d410d9
car(tree)

# ╔═╡ d63ca7af-a13e-4625-bbf5-6024c6a14247
cdr(tree)

# ╔═╡ 4c640fed-d04b-4e57-9548-98ce7bac9f34
car(cdr(car(cdr(car(cdr(tree))))))            # ==>  4 -->  :)

# ╔═╡ e5889629-d634-4814-996f-9e59222ce1fe
car(cdr(car(cdr(car(cdr(tree)))))) == 4

# ╔═╡ dfe2820c-be99-4bda-a48b-64c250938404
sumOddSquares(tree)                           # ==> 84  --> :)

# ╔═╡ 405e17a8-b601-4668-8fc0-cd5a2e99e81e
md"
---
###### 3.2.2 Conventional *Recursion* in $evenFibs$

The characteristics of function $evenFibs$ (SICP, 1996, p.114; [2016, p.155](https://web.mit.edu/6.001/6.037/sicp.pdf)) are:
- it *enumerates the integers from 0 to n*
- it *computes the Fibonacci number for each integer*
- it *filters them, selecting the even ones* 
- it *accumulates the results using cons, starting with the empty list* 
"

# ╔═╡ df45e72d-c361-49a7-8be0-dff4e69f5cba
#---------------------------------------------------------------------------
# idiomatic Julia: backward 'for' and parallel assignment
#---------------------------------------------------------------------------
function fib6(n)
	a     = 1
	b     = 0
	for count = n:-1:1 # from n downto 1 in steps with width 1
		a, b = a + b, a
	end
	b
end

# ╔═╡ 423d5126-9e28-496d-974a-f763527e4b5b
fib6(0), fib6(1), fib6(2), fib6(3), fib6(4), fib6(5), fib6(6), fib6(7), fib6(8), fib6(9), fib6(10) 

# ╔═╡ 0d91a8c9-92dd-4b17-938d-f462aac72cc0
md"
even Fibonacci numbers are $0, 2, 8, 34.$

"

# ╔═╡ cae46dcc-0a3b-4dab-8139-b57c7946a155
function evenFibs(n; nil = [])::VectorOrAtom
	function next(k::Int)::VectorOrAtom
		if >(k, n)
			nil                                # vector (!) is returned
		else
			let f = fib6(k)
				if iseven(f)
					println("k = $k, f = $f ") # output of test info
					cons(f, next( +(k, 1)))
				else
					next( +(k, 1))
				end # if
			end # let
		end # if
	end # function next
	#-------------------------------------------
	next(0)
end # function evenFibs

# ╔═╡ a3dc4444-f515-4e06-8985-959d9c0f72ae
evenFibs(10)

# ╔═╡ 7fd4b1d0-793e-4988-b32f-51b3f06b80b5
evenFibs(10; nil=[])

# ╔═╡ ba00d940-87c6-40b3-9763-4d2cd5ef8722
md"""
---
##### 3.3 Signal-flow Plans

*A signal-processing engineer would find it natural to conceptualize these processes in terms of signals flowing through a cascade of stages, each of which implements part of the program plan, as shown in Fig. 2.2.3.3.* 

*In $sumOddSquares$, we begin with an enumerator, which generates a "signal" consisting of the leaves of a given tree. This signal is passed through a filter, which eliminates all but the odd elements. The resulting signal is in turn passed through a map, which is a "transducer" that applies the square procedure to each element. The output of the map is then fed to an accumulator, which combines the elements using +, starting from an initial 0 (Fig. 2.2.3.4). The plan for $evenFibs2$ is analogous (Fig. 2.2.3.5).* (SICP, 1996, 2016)

"""

# ╔═╡ 437e8e31-b910-4ae3-96d1-cdae20a907b1
md"
---
           +--------+        +--------+        +--------+        +--------+
    signal |  accu- | signal |        | signal | trans- | signal | accu-  | signal
    ------>+  mula- +------->+ filter +------->+        +------->+ mula-  +------>
           |  tor   |        |        |        | ducer  |        | tor    | 
           +--------+        +--------+        +--------+        +--------+ 

**Fig. 2.2.3.3**: Schematic Signal-flow Plan 

"

# ╔═╡ 131bbb1f-25c1-4bd2-af72-4177ebda209e
md"
---
          +---------+        +---------+         +--------+         +---------+
          |         |        |         |         |        | squared | my-     | sum-
     tree | enumer- | leaves | my-     |  odd    |  map:  |   odd   | Accu-   | Odd-
    ----->+ ate-    +------->+ Filter: +-------->+        +-------->+ mulate: +-->
          | Tree    |        | isodd?  | leaves  | square | leaves  | +, 0    | Sqrd
          +---------+        +---------+         +--------+         +---------+ leaves

**Fig. 2.2.3.4**: Signal-flow plan for $sumOddSquares$ (c.f. SICP, 1996, 2016, Fig. 2.7 top)

"

# ╔═╡ c7615112-8c03-43fb-ad3a-e979f6ae951f
md"
---

          +----------+        +--------+       +---------+        +----------+
          | enumer-  |        |        |       |         |        | accu-    | list
     tree |  ate:    | sequ-  |  map:  | fibs  | filter: | even   | mulate   | of
    ----->+          +------->+        +------>+         +------->+ with     +-->
          | integers | ence   |  fib   |       |  even?  | fibs   | cons, () | even
          +----------+        +--------+       +---------+        +----------+ fibs

**Fig. 2.2.3.5**: Signal-flow plan for $evenFibs2$ (c.f. SICP, 1996, 2016, Fig. 2.7 bottom)

"

# ╔═╡ 2d45ac6d-fc78-48b6-a1c1-3bf8923c857e
md"
---
##### 3.4 Sequence Operations
"

# ╔═╡ 9f64b774-8333-48d0-9a60-aede670db6ff
square(x) = *(x, x)

# ╔═╡ 340e3dad-8b91-471e-84ed-8e4ac555ef49
map(square, list(1, 2, 3, 4, 5))          # Julia's Base.map — Function

# ╔═╡ 20697309-9d88-4d3f-a153-849f229cf47a
map(list(1, 2, 3, 4, 5)) do n             # Julia's Base.map — Function with 'do'
 	square(n)
end # map

# ╔═╡ 93c3d676-aa0f-40b3-8c57-fd28ca5acf0c
md"
---
###### 3.4.1 *1st* Method of Scheme-like function $myFilter$
(SICP, 1996, p.115; [2016, p.157](https://web.mit.edu/6.001/6.037/sicp.pdf))

Julia's $Base.filter$ is *different* from our $myFilter.$
"

# ╔═╡ ea228836-2583-4b0e-9f7a-c2d50f9f8230
function myFilter(predicate::Function, sequence::Sequence)::Sequence
	# Base.filter is Julia builtin function
	#---------------------------------------------------------------
	isNull = isempty
	nil  = []
	#---------------------------------------------------------
	if isNull(sequence) 
		nil 
	elseif predicate(car(sequence)) 
		cons(car(sequence), 
			 myFilter(predicate, cdr(sequence))) 
	else
		myFilter(predicate, cdr(sequence))
	end # if
end # function myFilter

# ╔═╡ 888cbf64-05e9-4f6e-a473-3eff43d2085b
typeof(list(1, 2, 3, 4, 5)) <: Sequence

# ╔═╡ 1ee151db-1b91-4400-8474-9d689cb73664
myFilter(isodd, list(1, 2, 3, 4, 5))      

# ╔═╡ a9366254-3a82-4252-8c47-9b51b9dd504d
myFilter(iseven, list(1, 2, 3, 4, 5))   

# ╔═╡ 602ecf93-2e61-44bc-ab45-06477fdff6f6
md"
---
###### 3.4.2 *1st* Method of Scheme-like function $accumulate$
(SICP, 1996, p.116; [2016, p.158](https://web.mit.edu/6.001/6.037/sicp.pdf))

Julia's $Base.accumulate$ is *different* from $myAccumulate.$
"

# ╔═╡ e2bb2ed2-de48-4e53-b566-1e9b6f6c3aa1
# 'accumulate' is Julia's accumulate(op, A; dims::Integer, [init])
function myAccumulate(op::Function, initial, sequence::Vector) 
	#-------------------------------------------------------------
	isnull = isempty  # Julia's Base.isempty - function 'isempty'
	#-------------------------------------------------------------
	if isnull(sequence)
		initial
	else
		op(car(sequence), 
			myAccumulate(op, initial, cdr(sequence)))
	end # if
end # function myAccumulate

# ╔═╡ 7bfc28ac-b41e-4c34-88dc-e74cd363922f
myAccumulate(+, 0, list(1, 2, 3, 4, 5)) 

# ╔═╡ 9b5fc090-e7d5-4783-8c69-e630f203ab04
myAccumulate(*, 1, list(1, 2, 3, 4, 5))

# ╔═╡ d85158bc-1570-47f4-9ef7-6c4966d58440
myAccumulate(*, 1.0, list(1, 2, 3, 4, 5))

# ╔═╡ 866d3228-4d98-4c87-9738-5a5ad2d0c611
myAccumulate(*, 1.0, list(1., 2., 3., 4., 5.))

# ╔═╡ 1b862b47-7789-44d9-9005-ce7b77bec837
# initial is '[]'
myAccumulate(cons, [], list(1, 2, 3, 4, 5))  

# ╔═╡ dcdb3dbc-5415-4c21-8431-da7bba9553ef
sum(myAccumulate(cons, [], list(1, 2, 3, 4, 5))) # Julia's Base.sum - Function

# ╔═╡ 8ecd4de0-f81f-4aee-aed9-c85312138bc1
md"
---
###### 3.4.3 *1st* Method of Scheme-like function $enumerateInterval$
(SICP, 1996, p.116; [2016, p.158](https://web.mit.edu/6.001/6.037/sicp.pdf))

with *keyword* parameter $initial=[]$
"

# ╔═╡ 450f2841-faae-486c-900d-3b830da5b2bd
function enumerateInterval(low, high; initial = []) # keword parameter 'initial'
	if >(low, high)              #  ^-------------------------------- semicolon
		initial
	else
		cons(low, 
			 enumerateInterval( +(low, 1), high; initial)) # keyword argument !
	end # if                                #  ^----------------- semicolon
end # function enumerateInterval

# ╔═╡ ceee3d88-7d76-482e-8eb0-6bb7bbb75b7a
enumerateInterval(2, 7)                       # without keyword argument 'initial'

# ╔═╡ 06f50446-19fe-4826-be42-d9507f2d552a
enumerateInterval(2, 7, initial = [])         # with keyword argument 'initial=[]' !

# ╔═╡ 130a22a0-bbfd-4d69-bd99-194d71906f75
md"
---
###### 3.4.4 *1st* Method of Function $enumerateTree$
(SICP, 1996, p.116; [2016, p.159](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ 5e0adaac-e483-4b9f-a365-6dd843fa1bd7
function enumerateTree(tree::VectorOrAtom)
	if isempty(tree)
		tree
	elseif typeof(tree) <: Atom
		list(tree)
	else
		append!(
			enumerateTree(car(tree)), 
			enumerateTree(cdr(tree)))
		# ^---------------------------------------------- Julian function append!
	end # if
end # function enumerateTree

# ╔═╡ d6aa0941-d958-414d-8930-3c802219d543
list(1, list(2, list(3, 4)), 5)

# ╔═╡ 88ac03d2-6bfe-42a8-96a3-e6acb1d6b5fc
enumerateTree(list(1, list(2, list(3, 4)), 5))

# ╔═╡ 85e2f791-7498-413c-8216-f9ef5c2abd44
tree                                        # tree not(!) modified

# ╔═╡ f5a765fe-e03f-4bea-9d26-e4faf548cf8a
enumerateTree(tree)

# ╔═╡ f77da1eb-2cb3-446b-bb83-506e156456ad
md"
---
###### 3.4.5 *1st* Method of Function $sumOddSquaresSignalFlow$
(SICP, 1996, p.117; [2016, p.159](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ 1f7ce44a-9720-404f-847c-c36601874396
function sumOddSquaresSignalFlow(tree)
	myAccumulate(
		+, 
		0, 
		map(
	#    ^---------------------------------------- Base.map  (Julia function)		
			square, 
			myFilter(
				isodd, 
				enumerateTree(tree))))
end # function sumOddSquaresSignalFlow

# ╔═╡ 76da63a2-821d-41ac-8529-992b01f823f2
tree

# ╔═╡ d7a64fd1-7c9d-43af-bd89-58492a633f12
sumOddSquaresSignalFlow(tree)                   # 1 + 3*3 + 5*5 + 7*7 = 84

# ╔═╡ a5cd4d56-cdb6-49d2-96db-bba5ca680b89
md"
---
###### 3.4.6 *1st* Method of Function $evenFibsSignalFlow$
(SICP, 1996, p.117; [2016, p.159](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ 262fecaf-08ed-48bb-88b3-7891fbb188bf
function evenFibsSignalFlow(n)
	myAccumulate(
		cons, 
		[], 
		myFilter(
			iseven, 
			map(
				fib6, 
				enumerateInterval(0, n, initial=[]))))   
	                    #                  ^----------- keyword 'initial=[]' is                          #              *necessary* to generate an array within 'map'
end # function evenFibsSignalFlow

# ╔═╡ 84669c73-9668-43e4-9201-0b82ec95d9d2
evenFibsSignalFlow(10)

# ╔═╡ 9c3f6eb0-c6eb-48ef-8dfd-c07bfe4f904f
md"
---
###### 3.4.7 *1st* Method of Function $listFibSquares$
(SICP, 1996, p.117; [2016, p.160](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ cf9c5bf0-01ae-41ae-bf64-dba330a36ff5
md"
---
###### 3.4.8 *1st* Method of Function $productOfSquaresOfOddElements$
(SICP, 1996, p.118; [2016, p.160](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ e91a0596-8401-4e34-b1ab-17d6eae08801
function productOfSquaresOfOddElements(sequence)
	myAccumulate(
		*, 
		1, 
		map(
			square, 
			myFilter(isodd, sequence)))
end # function productOfSquaresOfOddElements

# ╔═╡ 07720d55-52a0-409a-9f56-d0525e25f129
productOfSquaresOfOddElements(list(1, 2, 3, 4, 5))

# ╔═╡ 86d62a80-02f7-4c7d-9e90-7c54ee967ba0
md"
---
###### 3.4.9 *1st* Method of Function $salaryOfHighestPaidSoftwareDeveloper$
(SICP, 1996, p.118; [2016, p.160](https://web.mit.edu/6.001/6.037/sicp.pdf))

"

# ╔═╡ dcbb460b-3b1d-4ad1-8c4b-09c157a0f6d5
function salaryOfHighestPaidSoftwareDeveloper(records::Sequence)
	#------------------------------------------------------------
	isSoftwareDev(record) = record[2] == :softwareDev
	getSalary(record)     = record[3]
	#------------------------------------------------------------
	myAccumulate(
		max, 
		0, 
		map(
	  #  ^-------------------------------------------------- Julia Base.map
			getSalary, 
		    filter(isSoftwareDev, records)))
	      #    ^-------------------------------------------- Julia Base.filter
	#----------------------------------------------------
end # function salaryOfHighestPaidSoftwareDeveloper

# ╔═╡ 2abadd4a-c902-42ff-949a-92149fff4d7e
myDataBase =
 [  [:joe,   :carpenter,     80000],
	[:jim,   :butcher,       90000],
	[:buddy, :softwareDev,  100000],
	[:susi,  :softwareDev,  104000],           # <== highest software_dev's salary
	[:joanne,:psychologist,  70000],
	[:fred,  :physician,    120000],
    [:syrah, :lawyer,       160000]]
	

# ╔═╡ 553a1172-96df-423f-be75-38edcf0d8baf
typeof(myDataBase) <: Sequence

# ╔═╡ d8fd852e-76d6-4753-8b7c-0cb0a0cda6a5
salaryOfHighestPaidSoftwareDeveloper(myDataBase)

# ╔═╡ 853fdffc-0faf-482d-b3f5-e4ec364b8388
md"
---
##### 3.5 NonSICP: *Pipelining* the Signal-flow Graph
To implement a *pipeline* we have to *specialize* and *curryfy* all functions in the pipeline. So we *specialize* functions $myFilter, map, myAccumulate$ so that we can obtain *unary* functions, we can use Julia's *pipeline* operator *|>*. The pipeline mimics the signal-flow-graphs *Fig. 2.2.3.3 - 2.2.3.5*. The signal-flow graphs with *curryfied* functions is in Fig. 2.2.3.6 - 2.2.3.7.
"

# ╔═╡ a7092e6e-f3bd-499a-9bd7-a1aafd7aad25
md"
---
###### 3.5.1 *Full Pipeline* $sumOddSquares$ Mimicking Signal-flow Plan *Fig. 2.2.3.6*
"

# ╔═╡ 0ba85815-b5bd-42c9-badd-6f45561b4cb7
md"
---
          +---------+        +---------+         +--------+         +---------+
          | enumer- |        | my-     |         | my-    |         | my-     | 
     tree |  ate-   | sequ-  | Isodd-  | sequ-   | Square | sequ-   | Plus-   | sum
    ----->+ Tree    +------->+ Filter  +-------->+ Map    +-------->+ Accumu- +--->
          |         | ence   |         | ence    |        | ence    | late    | 
          +---------+        +---------+         +--------+         +---------+ 

**Fig. 2.2.3.6**: *Spezialized* Signal-flow plan for $sumOddSquares$ with *curryfied* Filter, Map, and Accumulate (c.f. SICP, 1996, 2016, Fig. 2.7 top)

"

# ╔═╡ 387d7b6b-c8bd-4410-b877-5b62b376aca3
md"
---
###### 3.5.1.1 *Specialized* and *Curryfied* $myIsOddFilter$ Function
"

# ╔═╡ 1eae6170-2429-4ae3-bf98-418c33f6e19c
# specialized and curryfied filter function
myIsOddFilter = 
	enumeration::Sequence -> myFilter(isodd, enumeration)::Sequence

# ╔═╡ c88ef184-1cf2-41fc-a88a-24a7d21f21d0
tree |> enumerateTree

# ╔═╡ 5d59c62a-28a3-46fb-bf50-682ad5521f9b
tree |> enumerateTree |> myIsOddFilter

# ╔═╡ aa521dac-fe13-4c92-bdda-7b424ee986ec
md"
---
###### 3.5.1.2 *Specialized* and *Curryfied* $mySquareMap$ Function
"

# ╔═╡ 05950ae1-7f6e-440a-a5fe-90d71809e1fb
# specialized and curryfied map function
mySquareMap = 
	sequence::Sequence -> map(square, sequence)::Sequence

# ╔═╡ 46f49c82-f49d-4876-926d-3982c7ee5a1a
tree |> enumerateTree |> myIsOddFilter |> mySquareMap

# ╔═╡ a9bafcb9-6c9e-42fc-86f5-8e592eebd2e0
md"
---
###### 3.5.1.3 *Specialized* and *Curryfied* $myPlusAccumulate$ Function
"

# ╔═╡ 1b8e5b4e-451f-40f3-8916-0478c127f9e2
# specialized and curryfied accumulate function
myPlusAccumulate = 
	sequence::Sequence -> myAccumulate(+, 0, sequence)::Atom

# ╔═╡ 2cf952dd-1a98-404f-8e4e-a4f6d0b7863b
md"
---
###### 3.5.1.4 *Full Pipeline* $sumOddSquares$ Mimicking Signal-flow Plan *Fig. 2.2.3.6*
"

# ╔═╡ 18065beb-7aea-466f-a60b-e6f48fd7b55e
# full pipeline mimicking signal-flow graphs *Fig. 2.2.3.6*
tree |> 
	enumerateTree |> 
		myIsOddFilter |> 
			mySquareMap |> 
				myPlusAccumulate

# ╔═╡ 70622924-1662-4dce-83c2-146359482f9a
md"
---
###### 3.5.2 *Full Pipeline* $evenFibs2$ Mimicking Signal-flow Plan *Fig. 2.2.3.7*
"

# ╔═╡ 78ef2823-65be-4971-af90-b8d5ffe804e4
md"
---
          +---------+        +---------+         +--------+         +---------+
          | my-     |        | my-     |         | my-    |         | my-     | 
       n  | Enumer- | sequ-  | Fib-    | sequ-   | isEven | sequ-   | Plus-   | sum
    ----->+ ateFrom-+------->+ Map     +-------->+ Filter-+-------->+ Accumu- +--->
          | zero    | ence   |         | ence    |        | ence    | late    | 
          +---------+        +---------+         +--------+         +---------+ 

**Fig. 2.2.3.7**: *Specialized* Signal-flow plan for $evenFibs2$ with *curryfied* Enumerate, Map, Filter, and Accumulate (c.f. SICP, 1996, 2016, Fig. 2.7 bottom)

"

# ╔═╡ f4297f64-8611-47fb-ac89-52b661b369b4
md"
---
###### 3.5.2.1 *Specialized* and *Curryfied* $myEnumerateFromZero$ Function
"

# ╔═╡ 43cbdebd-8348-4ed3-9d1e-2acfd479e003
# specialized and curryfied enumerateInterval function
myEnumerateFromZero = 
	n::Atom -> enumerateInterval(0, n, initial=[])::Sequence

# ╔═╡ 1340206a-e4b9-4445-8e12-e14d0d2e81a0
 # keyword argument 'initial=[]' is *necessary* to generate an array within 'map'
function listFibSquares(n)
	myAccumulate(
		cons, 
		[], 
		map(
			square, 
			map(
				fib6, 
				myEnumerateFromZero(n))))
end # function listFibSquares

# ╔═╡ f3c7318e-eeb0-4716-b7ab-aceab779e9d6
listFibSquares(10)

# ╔═╡ 636bb4b5-8732-466a-9595-0819f1bb1b0a
10 |> myEnumerateFromZero

# ╔═╡ 89c94f60-6932-4edc-8ab0-3cf506dc383a
md"
---
###### 3.5.2.2 *Specialized* and *Curryfied* $myFibMap$ Function
"

# ╔═╡ f7b59ba2-7b6e-4c33-85b9-f6c94e72147f
# specialized and curryfied map function
myFibMap = 
	sequence::Sequence -> map(fib6, sequence)::Sequence

# ╔═╡ dc89d384-c257-4428-9b6b-3b0c915c5952
10 |> myEnumerateFromZero |> myFibMap

# ╔═╡ 52236d2b-0d9f-48e9-9a99-069300a39789
md"
---
###### 3.5.2.3 *Specialized* and *Curryfied* $myIsEvenFilter$ Function
"

# ╔═╡ f990c703-7b6b-4cd0-8b18-5fe1b932de72
# specialized and curryfied filter function
myIsEvenFilter = 
	enumeration::Sequence -> myFilter(iseven, enumeration)::Sequence

# ╔═╡ a118d71b-6797-42a6-b286-c65243711301
10 |> myEnumerateFromZero |> myFibMap |> myIsEvenFilter

# ╔═╡ 505cdf44-a706-4598-87f2-6379a7cbebc5
md"
---
###### 3.5.2.4 *Full Pipeline* Mimicking Signal-flow Graph *Fig. 2.2.3.7*
"

# ╔═╡ a9aee53a-6912-456c-9f4b-58cc1958ef46
# full pipeline mimicking signal-flow graphs *Fig. 2.2.3.7
10 |> 
	myEnumerateFromZero |> 
		myFibMap |> 
			myIsEvenFilter |> 
				myPlusAccumulate

# ╔═╡ 3e5bb103-5c1f-408b-9725-3d4e3900f6e1
md"
---
###### 3.5.3 *Full Pipeline* for $listFibSquares$
"

# ╔═╡ b4764b3a-a0c1-4fdc-8ccb-c24742db0246
md"
---
          +---------+        +---------+         +--------+         +---------+
          | my-     |        | my-     |         | my-    |         | my-     | 
       n  | Enumer- | sequ-  | Fib-    | sequ-   | Square-| sequ-   | Cons-   | sequ-
    ----->+ ateFrom-+------->+ Map:     +------->+ Map    +-------->+ Accumu- +----->
          | zero    | ence   | fib6    | ence    |        | ence    | late    | ence
          +---------+        +---------+         +--------+         +---------+ 

**Fig. 2.2.3.8**: *Specialized* Signal-flow plan for $listFibSquares$ with *curryfied* Enumerate, Map, and Accumulate.

"

# ╔═╡ 818b6835-3e71-42ce-b717-d6b34120c3ce
10 |> myEnumerateFromZero

# ╔═╡ 85932a61-9d42-4b89-b398-8b190ff44f57
10 |> myEnumerateFromZero |> myFibMap 

# ╔═╡ 4cbf6f5d-1612-4014-b57f-0ca41f981d6a
10 |> myEnumerateFromZero |> myFibMap |> mySquareMap

# ╔═╡ db343d3b-6789-49d4-955c-c65bb78d451e
md"
---
###### 3.5.3.1 *Specialized* and *Curryfied* $myIsEvenFilter$ Function
"

# ╔═╡ f6737420-0a73-42ae-b655-6bd88333630d
# specialized and curryfied accumulate function
myConsAccumulate = 
	sequence::Sequence -> myAccumulate(cons, [], sequence)::Sequence

# ╔═╡ 773c6715-95e4-48f8-b65e-e7e18037d60f
md"
---
###### 3.5.3.2 *Full Pipeline* Mimicking Signal-flow Graph *Fig. 2.2.3.8*
"

# ╔═╡ 56063c42-46aa-4514-83d5-284fcdfaed9b
10 |> 
	myEnumerateFromZero |> 
		myFibMap |> 
			mySquareMap |> 
				myConsAccumulate

# ╔═╡ dcc141f5-61ed-4d2d-9721-6c7a797749b8
md"
---
###### 3.5.4 Sequence Operation: *Pipeline* for $productOfSquaresOfOddElements$
"

# ╔═╡ 00d7c35b-ca2a-4e3c-be59-31cddfe1b588
md"
---
              +---------+        +---------+         +----------+         
              | my-     |        | my-     |         | my-      | 
              | Isodd-  | sequ-  | Square- | sequ-   | Product- | pro-
     -------->+ Filter  +------->+ Map     +-------->+ Accumu-  +------>
              |         | ence   |         | ence    | late     | duct    
              +---------+        +---------+         +----------+         

**Fig. 2.2.3.9**: *Specialized* Signal-flow plan for $productOfSquaresOfOddElements$ with *curryfied* Enumerate, Map, and Accumulate.

"

# ╔═╡ aa8a96e0-24ae-4eff-b35f-9a0538c0a30d
list(1, 2, 3, 4, 5) |> myIsOddFilter

# ╔═╡ 98b0c8a8-48ac-4dd3-a535-0e0030d74333
list(1, 2, 3, 4, 5) |> myIsOddFilter |> mySquareMap

# ╔═╡ d1861390-1592-44b7-bc25-c9a194dd15b5
md"
---
###### 3.5.4.1 *Specialized* and *Curryfied* $myProductAccumulate$ Function
"

# ╔═╡ d165a50b-db37-4012-9056-dbe04c46dc38
# specialized and curryfied accumulate function
myProductAccumulate = 
	sequence::Sequence -> myAccumulate(*, 1, sequence)::Atom

# ╔═╡ 894d0a89-a20c-4a9a-b7f3-3f0c656d6d33
md"
---
###### 3.5.4.2 *Full Pipeline* $productOfSquaresOfOddElements$ Mimicking Signal-flow Graph *Fig. 2.2.3.9*
"

# ╔═╡ 9069564f-3445-487d-a5e3-98508d278b07
list(1, 2, 3, 4, 5) |> 
	myIsOddFilter |> 
		mySquareMap |> 
			myProductAccumulate

# ╔═╡ 98470389-f0b1-47cf-a5d4-8a91b10499df
md"
---
###### 3.5.5 *Full Pipeline*: *Conventional* Data-processing
"

# ╔═╡ 927365af-503e-4005-951b-28c4fbbee92e
function salaryOfHighestPaidSoftwareDev(records)
	#------------------------------------------------------------------
	isSoftwareDev(record) = 
		record[2] == :softwareDev
	salary(record) = 
		record[3]
	mySoftwareDevFilter = 
		records -> filter(isSoftwareDev, records)  
                 #   ^--------------------------------------   Julia Base.filter
	myMapSalary =
		records -> map(salary, records)
	myMaxAccumulate =
		salaries -> myAccumulate(max, 0, salaries)
	#------------------------------------------------------------------
	# myAccumulate(max, 0, map(salary, myFilter(isSoftwareDev, records)))
	# full pipeline mimicking signal flow graph of Fig. 2.2.3.7
	records |> 
		mySoftwareDevFilter |> 
			myMapSalary |> 
				myMaxAccumulate
end

# ╔═╡ 0b02ecc3-d875-4a3a-b6af-36edcdf50a24
salaryOfHighestPaidSoftwareDev(myDataBase)

# ╔═╡ 56837c07-91a6-452b-8c3a-854bbe6a8423
md"
---
##### 3.6 *Nested* Mappings: *Nested* Functions
*We can extend the sequence paradigm to include many computations that are commonly expressed using nested loops.*


"

# ╔═╡ 804a253f-28c4-4eb7-8bc9-ac00c3d80f6d
md"
---
###### 3.6.1 Nested Mapping: *Prime Sum of Pairs* of Integers with $primeSumPairs$

*Consider this problem* (SICP, 1996, p.122; 2016, p.166)

*Given a positive integer $n$, find all ordered pairs of distinct positive integers $i$ and $j$, where* 

$1 \le i \lt j \le n,$

*such that $i + j$ is prime.* (SICP, 1996, p.122)

$\{(i, j)| 1 \le i \lt j \le n; i,j \in \mathbb{N}, (i + j)\in \mathbb{P}\}$

$\;$

*For example, if n is 6, then the pairs are the following* (**Fig. 2.2.3.8**)

"

# ╔═╡ 2acf6798-6f1e-43bb-83df-ec1b41558134
md"
$\begin{array}
& & & & n \text{th pair}\\
  & 1. & 2. & 3. & 4. & 5. & 6. & 7. \\
\hline
i   & 1 & 2 & 1 & 3 & 2 & 1 & 5  \\
j   & 2 & 3 & 4 & 4 & 5 & 6 & 6  \\
\hline
i+j & 3 & 5 & 5 & 7 & 7 & 7 & 11 \\
\end{array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 2.2.3.8**: Table of *Primes* with their Summands $1 \le i < j  \le n=6.$

"

# ╔═╡ a35e90a8-320c-478f-ab35-72f742c52eca
md"
*A natural way to organize this computation is to generate the sequence of all ordered pairs of positive integers less than or equal to n, filter to select those pairs whose sum is prime, and then, for each pair (i, j) that passes through the filter, produce the triple (i,j,i + j).* (SICP, 1996, p. 122; SICP, 2016, p.166)

"

# ╔═╡ f2a779f5-d408-467b-9713-c58fe4db6913
ListOfOrderedPairs::Sequence =
	let n = 6
		myAccumulate(
			append!, 
			[], 
			map(i -> 
					map(j -> 
							list(i, j), 
							enumerateInterval(1, i-1, initial = [])), # 1 ≤ j < i-1
					enumerateInterval(1, n, initial = [])))           # 1 < i ≤ n
	end # let

# ╔═╡ b4d1e9eb-1367-4dda-935c-8d24712dcd96
function flatmap(proc, seq)
	myAccumulate(append!, [], map(proc, seq))
end

# ╔═╡ b94fb940-4cfa-4496-aff6-bdd0014a1c5d
function isPrimeSum(pair)
	#-----------------------------------
	car(pair)  = pair[1]
	cadr(pair) = pair[2]
	#-----------------------------------
	isprime(car(pair) + cadr(pair))
end # function isPrimeSum

# ╔═╡ 19fa3b90-7cae-48dc-95e4-0fa63d4e0339
function makePairSum(pair::Vector)
	#-----------------------------------
	car(pair)  = pair[1]
	cadr(pair) = pair[2]
	#-----------------------------------
	list(car(pair), cadr(pair), '|', +(car(pair), cadr(pair)))
end

# ╔═╡ 977a9138-6530-4eaa-8b5f-df45c43864db
function primeSumPairs(n)
	map(makePairSum, 
		filter(
			isPrimeSum, 
			flatmap(i -> 
						map(j -> 
								list(i, j), 
							enumerateInterval(1, i-1, initial = [])), 
					enumerateInterval(1, n, initial = []))))
end # function primeSumPairs

# ╔═╡ 57462b8a-99ca-4d77-a713-73a2178eaddb
let n = 6
	filter(
		isPrimeSum, 
		flatmap(i -> 
					map(j -> 
							list(i, j), 
						enumerateInterval(1, i-1, initial = [])), 
				enumerateInterval(1, n, initial = [])))
end # let

# ╔═╡ 1a6172b5-10f8-47e7-bdc3-13acb541e9ed
primeTable = primeSumPairs(6)

# ╔═╡ 46aafc6d-96ec-4574-a294-8dc3fa9475fe
function output(primeTable)
	println("  j | ", map(tuple->tuple[1], primeTable))   
 	println("i   | ", map(tuple->tuple[2], primeTable))
 	println("---------------------------")
 	println("i+j |", map(tuple->tuple[4], primeTable))
end # function output

# ╔═╡ d3a95665-1662-451f-98e8-795c62f0c550
output(primeTable)

# ╔═╡ 2dafe1b0-62ca-42b9-a1e6-b494662981c9
md"
---
###### 3.6.2 Nested Mapping: *Permutations* of a set *S* with $permutations$

*...we wish to generate all the permutations of a set S; that is, all the ways of ordering the items in the set. For instance, the permutations of {1,2,3} are {1,2,3}, { 1,3,2}, {2,1,3}, { 2,3,1}, { 3,1,2}, and { 3,2,1}.* (SICP, 1996, p.123; 2016, p.168)

"

# ╔═╡ 8d3c4fcb-9b0b-483f-a3c7-b04bb5a70316
md"
---
###### 3.6.2.1 Function $permutations$ 
(SICP, 1996, p.123f; 2016, p.168)

*Here is a plan for generating the permutations of $S$: For each item $x$ in $S$, recursively generate the sequence of permutations of $S - x$, and adjoin $x$ to the front of each one. This yields, for each $x$ in $S$, the sequence of permutations of $S$ that begin with $x$. Combining these sequences for all $x$ gives all the permutations of $S$:*

$\{cons(x, permutations(S\\x)) | \forall x \in S\}$

$\;$

"

# ╔═╡ 29fa3f53-4193-465d-b44f-c72510d22725
function permutations(setS)
	#-----------------------------------------------------------
	null = isempty
	remove(item, sequence) = 
		filter(x -> !(x == item), sequence)
	#-----------------------------------------------------------
	if null(setS)
		list([])
	else
		flatmap(
				itemX -> 
					map(
						permutationP -> cons(itemX, permutationP),
						permutations(remove(itemX, setS))), 
					setS)
	end # if
end # function permutations

# ╔═╡ b7940f89-9e29-4411-b387-cddc2ac5dc98
permutations([1, 2, 3])

# ╔═╡ 985a5d70-f094-4058-aa6d-956208e260ba
md"
---
##### 3.7 NonSICP: *Nested* Mappings with *Sequential* Pipelines

"

# ╔═╡ 01fb5470-fc33-4e17-905f-67186097fc11
md"
---
###### 3.7.1 *Sequential Pipeline*: *Prime Sum of Pairs* of Integers with $primeSumPairs$
"

# ╔═╡ ff11fa72-77b3-44d6-b278-f5b77d79b19c
# specialized and curryfied enumerateFromOne function
myEnumerateFromTwo = 
	n::Atom -> enumerateInterval(2, n, initial=[])::Sequence

# ╔═╡ 0cab38ea-1151-41c6-8976-d4cbed765051
6 |> myEnumerateFromTwo

# ╔═╡ d0a6aea1-a836-40f1-9255-3ac518d17de2
myEnumerateMap =
	sequence ->
		flatmap(i -> 
				map(j -> 
						list(i, j), 
						enumerateInterval(1, i-1, initial = [])), # 1 ≤ j < i-1
				sequence) 

# ╔═╡ c51d0af0-1d45-46b3-8773-c1f3760da340
6 |> myEnumerateFromTwo |> myEnumerateMap

# ╔═╡ 9cbfe45a-e1ec-4952-bbfe-78c077071807
myIsPrimeFilter =
	sequence -> filter(isPrimeSum, sequence)

# ╔═╡ 3d2442e5-153b-4df3-8b91-70390d549dae
6 |> myEnumerateFromTwo |> 
		myEnumerateMap |>  
			myIsPrimeFilter                                 # pipeline

# ╔═╡ 933e20d9-8a8e-4f7a-85d7-1d8d45edb1e1
myMakePairSum =
	sequence -> map(makePairSum, sequence)

# ╔═╡ 5e4a8521-b6a4-4b70-9fe2-483e9ac724f5
6 |> myEnumerateFromTwo |> 
		myEnumerateMap |>  
			myIsPrimeFilter |>                               # pipeline
	  			myMakePairSum

# ╔═╡ ba40dd59-23e3-48ee-93e0-ef988144c36d
6 |> myEnumerateFromTwo |> 
		myEnumerateMap |>  
			myIsPrimeFilter |>                               # full pipeline
	  			myMakePairSum |>
	             	output

# ╔═╡ e558f9db-04b1-4022-b57f-9ed4e0211982
md"
---
###### 3.7.2 *Sequential Pipeline*: *Permutations* of a set *S* with $permutations$
In general it is *not* possible to implement a *recursive* function by *pipes*. *Pipes* are syntactic sugar for function *composition*.

The only application of a *pipe* is replacing the function application

$f(x) \equiv x\ \text{|>}\ f.$

$\;$

"

# ╔═╡ e4509940-3a56-4b64-b976-0b1f412cbdb1
[1, 2, 3] |> permutations

# ╔═╡ 0d153832-c688-4a2a-b7b9-3caceffbd9e3
md"
---
#### 4. *Idiomatic* Julia
"

# ╔═╡ 0c409eca-1a97-4278-98fc-5c2ddd9d1960
md"
---
###### 4.1 Function $foldr$
"

# ╔═╡ cc107566-ab61-4c25-875d-228939799f5b
# idiomatic Julia-code with rightassociative 'foldr'
function enumerateInterval2(low, high; initial=[])
	foldr(cons, [i for i=low:high]; init=initial)
   #  ^-------------------------------------------- Base.foldr
   #                                          Julia function 'foldr(op, itr; [init])'
end # function enumerateInterval2

# ╔═╡ 261a5fab-bab6-4a10-9676-4e9752f6d044
enumerateInterval2(2, 8)

# ╔═╡ b430b97f-8ba6-4a0c-a663-4ff3f28d5698
# idiomatic Julia-code by substituting 'accumulate' by Julian 'foldr' and keyword parameter 'init=...'
function accumulate5(op::Function, initial::Atom, sequence::Vector{<:Atom})::Atom
	foldr(op, sequence; init=initial)
end

# ╔═╡ 03b9c491-4f2c-40fd-b7ce-bc36a1f995ed
accumulate5(+, 0, list(0, 1, 2, 3, 4, 5))

# ╔═╡ 96b34aed-7c89-48f6-96c2-229c0d2f43bd
accumulate5(*, 1, list(1, 2, 3, 4, 5))  # expects '+' as argument for parameter 'op'

# ╔═╡ 86cfa808-b652-4b7a-bd41-6cd32c967d0c
md"
---
###### 4.2 Function $foldl$
"

# ╔═╡ c8c19b7b-ee0e-434a-874e-cb4485b7e80b
# idiomatic Julia-code by substuting 'accumulate' by Julia's 'foldl' and keyword parameter 'init=...'
function accumulate4(op::Function, initial::Atom, sequence::Vector{<:Atom})::Atom
	foldl(op, sequence; init=initial)
end

# ╔═╡ 3fa44084-bbaa-4726-b35e-af0b77794771
md"
---
###### 4.3 Vector Comprehension 
"

# ╔═╡ 7a6b6044-6751-4041-99e7-0a608019110f
# idiomatic Julia with vector comprehension
function enumerateInterval3(low, high)
	[i for i=low:high]                         # vector comprehension
end # function enumerateInterval3

# ╔═╡ 72ee39ee-a599-4cb8-9429-841ce903e3c1
enumerateInterval3(2, 9)

# ╔═╡ 89999299-e807-4004-ac69-83822267785b
md"
---
###### 4.4 Vector Comprehension with Iterator $iterate$ 
"

# ╔═╡ 8e0fd0e0-610e-4377-9021-35be0c7f30ce
md"
###### 4th (specialized) *partial typed* variant of function $enumerateInterval$
using iterate $IntervalDown(high, low)$ with $iter  = (low: -1 : high)$

$iterate := iterate(iter [, state]) -> Union\{Nothing, Tuple\{Any, Any\}\}$
"

# ╔═╡ 1b592487-ad22-4f14-b374-87743b8ec134
function enumerateInterval4(low, high; initial=:nil)
	let intvl = initial
		iter  = (high: -1 : low)
		next = iterate(iter)
		while next !== nothing
			(item, state) = next
			intvl = cons(item, intvl)
			next = iterate(iter, state)
		end # while
		intvl
	end # let
end

# ╔═╡ a94203ea-b828-457a-a58e-3362a0307f2e
enumerateInterval4(2, 7; initial=[])         # with keyword argument 'initial=[]'

# ╔═╡ 90f2a3c3-b652-4143-a68e-69c6a279b1f1
enumerateInterval4(2, 7, initial=[])         # with keyword argument 'initial=[]'

# ╔═╡ 94efad05-8481-4cd6-a9cb-829671c29c4d
md"
###### 5th (specialized) *partial typed* variant of function $enumerateInterval$
using iterate $IntervalDown(high, low)$ with $iter  = (low: +1 : high)$

$iterate := iterate(iter [, state]) -> Union\{Nothing, Tuple\{Any, Any\}\}$
"

# ╔═╡ de2196da-70b9-4c45-9732-ad5b8e7e4a1e
function enumerateInterval5(low, high; initial=:nil)
	let intvl = initial
		iter  = (low: +1 : high)
		next = iterate(iter)
		while next !== nothing
			(item, state) = next
			intvl = cons(item, intvl)
			next = iterate(iter, state)
		end # while
		intvl
	end # let
end # function enumerateInterval5

# ╔═╡ e27244e4-3002-47c1-ac01-6065017a5c9d
enumerateInterval5(2, 7, initial=[])         # with keyword argument 'initial=[]'

# ╔═╡ 76da54df-e90b-456a-b2a9-e8ca1e3afdb9
md"
---
###### 4.5 Flattening Vectors with $reduce(vcat...)$
"

# ╔═╡ 23dcdc5e-eadd-494e-b414-d106b5cb7026
# function myAccumulate(op::Function, initial, sequence::Vector) 
reduce(vcat, [[[1,2]],[[1,3],[2,3]]])

# ╔═╡ dc25c7fe-542f-46e5-ab6c-83a666a19849
md"
---
##### 5. Summary
SICP recommends to implement function *composition* along *signal flow plans*. These can be implemented by Julia *pipes*. Chains of pipes generate sequences called *pipelines*. These implement *non*recursive *signal flow plans*. *Signals* are implemented by *sequences*.
"

# ╔═╡ a49378fc-331a-47c4-9caa-0a18145fe994
md"
---
##### 6. References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996; last visit 2025/05/16

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://sarabander.github.io/sicp/), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2025/05/16
"

# ╔═╡ e902aa9c-6eac-4d38-80e7-ee252cc30b53
md"
---
###### end of ch. 2.2.3
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphRecipes = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"

[compat]
GraphRecipes = "~0.5.13"
LaTeXStrings = "~1.4.0"
Latexify = "~0.16.7"
Plots = "~1.40.13"
Pluto = "~0.20.6"
Primes = "~0.5.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "165a93fa5ec85fbe5b121f3b288f151c6bd83c9f"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "f7817e2e585aa6d924fd714df1e2a84be7896c60"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.3.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2ac646d71d0d24b44f3f8c84da8c9f4d70fb67df"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.4+0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1713c74e00545bfe14605d2a2be1712de8fbcb58"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

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
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "4358750bb58a3caefd5f37a4a0c5bfdbbf075252"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.6"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "4a8c0a9eebf807ac42f0f6de758e60a20be25ffb"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.3"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.Extents]]
git-tree-sha1 = "063512a13dbe9c40d999c439268539aa552d1ae6"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.5"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "301b5d5d731a0654825f1f2e906990f7141a106b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.16.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "be713866335f48cfb1285bff2d0cbb8304c1701c"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.5.5"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "7ffa4049937aeba2e5e1242274dc052b0362157a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.14"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "98fc192b4e4b938775ecd276ce88f539bcec358e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.14+0"

[[deps.GeoFormatTypes]]
git-tree-sha1 = "8e233d5167e63d708d41f87597433f59a0f213fe"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.4"

[[deps.GeoInterface]]
deps = ["DataAPI", "Extents", "GeoFormatTypes"]
git-tree-sha1 = "294e99f19869d0b0cb71aef92f19d03649d028d5"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.4.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "65e3f5c519c3ec6a4c59f4c3ba21b6ff3add95b0"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.7"

[[deps.GeometryTypes]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "d796f7be0383b5416cd403420ce0af083b0f9b28"
uuid = "4d00f742-c7ba-57c2-abde-4428a4b178cb"
version = "0.8.5"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.GraphRecipes]]
deps = ["AbstractTrees", "GeometryTypes", "Graphs", "InteractiveUtils", "Interpolations", "LinearAlgebra", "NaNMath", "NetworkLayout", "PlotUtils", "RecipesBase", "SparseArrays", "Statistics"]
git-tree-sha1 = "10920601dc51d2231bb3d2111122045efed8def0"
uuid = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
version = "0.5.13"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "3169fd3440a02f35e549728b0890904cfd4ae58a"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LRUCache]]
git-tree-sha1 = "5519b95a490ff5fe629c4a7aa3b3dfc9160498b3"
uuid = "8ac3fa9e-de4c-5943-b1dc-09c6b5f20637"
version = "1.6.2"
weakdeps = ["Serialization"]

    [deps.LRUCache.extensions]
    SerializationExt = ["Serialization"]

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd10d2cc78d34c0e2a3a36420ab607b611debfbb"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.7"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "0f2da712350b020bc3957f269c9caad516383ee0"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a31572773ac1b745e0343fe5e2c8ddda7a37e997"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "321ccef73a96ba828cd51f2ab5b9f917fa73945a"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

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
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Malt]]
deps = ["Distributed", "Logging", "RelocatableFolders", "Serialization", "Sockets"]
git-tree-sha1 = "02a728ada9d6caae583a0f87c1dd3844f99ec3fd"
uuid = "36869731-bdee-424d-aa32-cab38c994e3b"
version = "1.1.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "f5db02ae992c260e4826fe78c942954b48e1d9c2"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "StaticArrays"]
git-tree-sha1 = "f7466c23a7c5029dc99e8358e7ce5d81a117c364"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.10"
weakdeps = ["Graphs"]

    [deps.NetworkLayout.extensions]
    NetworkLayoutGraphsExt = "Graphs"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.5+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "809ba625a00c605f8d00cd2a9ae19ce34fc24d68"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.13"

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

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "Downloads", "ExpressionExplorer", "FileWatching", "FuzzyCompletions", "HTTP", "HypertextLiteral", "InteractiveUtils", "LRUCache", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PlutoDependencyExplorer", "PrecompileSignatures", "PrecompileTools", "REPL", "RegistryInstances", "RelocatableFolders", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "6f31e71063d158b69c1b84c7c3a1a7d4db153143"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.20.6"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "9071bfe6d1c3c51f62918513e8dfa0705fbdef7e"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.2.1"

[[deps.PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

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

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

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
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "9caba99d38404b285db8801d5c45ef4f4f425a6d"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.1+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a5bc75478d323358a90dc36766f3c99ba7feb024"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.6+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "aff463c82a773cb86061bce8d53a0d976854923e"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.5+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "e3150c7400c41e207012b41659591f083f3ef795"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.3+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0ba42241cb6809f1a278d0bcb976e0483c3f1f2d"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+1"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "068dfe202b0a05b8332f1e8e6b4080684b9c7700"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.47+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
git-tree-sha1 = "63406453ed9b33a0df95d570816d5366c92b7809"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+2"
"""

# ╔═╡ Cell order:
# ╟─ba6ee9c0-0999-11ec-3197-6b273cb47913
# ╟─da0d9d80-35ad-47eb-b8e3-751ed06bb7bc
# ╟─1c35199b-648f-4147-a3d0-061c5606ae0f
# ╟─71fc8524-e0b5-4cab-b6d7-a87e4753e3ff
# ╟─5dedb37c-6a47-490d-bc3c-1f8ac94c6e95
# ╟─070962ea-5876-4fdc-8f17-bd851360e2ec
# ╠═81769c4b-f881-46ed-bb34-b4aae56692e2
# ╟─af7dd73c-17ab-47b6-a26e-a8315b108a8d
# ╠═2c993a00-c67c-4340-8229-6c77bb99bf89
# ╠═79cc2784-f08a-431b-92b7-9cbadcda9e82
# ╠═9a1a09d8-912b-4249-a34b-60e8feafa8ea
# ╠═07dc0c06-766b-4170-ad95-733eb93ea707
# ╠═de0cf05c-78c2-4d2a-b14a-14ff82661073
# ╟─dcac923c-7ab6-4828-8d10-ad3dd2d331f7
# ╠═34b7facc-bcf8-47cb-a2ff-2a3eb4c05893
# ╠═7fc8fce0-a627-4574-8384-b9ec97554228
# ╟─628828c2-fa11-4b13-a4f7-9bac84424031
# ╠═e3557c59-930e-4668-844c-667e45700847
# ╟─438e40ec-ac14-4541-9086-c051bcf97372
# ╟─04d6ca0c-f67d-4cea-9166-20d98115f350
# ╠═d1bb66f0-18f0-4caf-b44c-7a8f27304859
# ╟─fe893e8b-b320-435f-a242-54eab8cb6326
# ╠═3e4877f4-fa79-4c7b-8004-35d5e5bcd798
# ╟─fc576d60-5ada-4348-a753-b86a81793d01
# ╠═e92f11f1-082a-43c3-b55f-1a2f795386d2
# ╟─8aba03d0-b7af-4c5e-b990-f660b0384bc7
# ╠═3c2238a3-158b-426e-b81a-927d4a117525
# ╟─a484dd0e-9e53-41d9-89f3-4e6d081fa969
# ╟─ede3a48f-71c0-4ddc-8f98-0590b817ef17
# ╠═069ee324-eceb-4f42-ae20-aac2e4478b2b
# ╟─6f0273fd-b5cf-41e6-bcc1-3e62ec52f760
# ╟─9f0808b5-1130-4603-9f8b-7359560f5672
# ╠═00e8e8e8-592e-4206-80c9-7308d5d6e151
# ╠═8824f5f4-4f29-48d7-8d07-a5a767c47ac4
# ╠═2bba24d2-79ee-4923-a6b5-e0e9a4d410d9
# ╠═d63ca7af-a13e-4625-bbf5-6024c6a14247
# ╠═4c640fed-d04b-4e57-9548-98ce7bac9f34
# ╠═e5889629-d634-4814-996f-9e59222ce1fe
# ╠═dfe2820c-be99-4bda-a48b-64c250938404
# ╟─405e17a8-b601-4668-8fc0-cd5a2e99e81e
# ╠═df45e72d-c361-49a7-8be0-dff4e69f5cba
# ╠═423d5126-9e28-496d-974a-f763527e4b5b
# ╟─0d91a8c9-92dd-4b17-938d-f462aac72cc0
# ╠═cae46dcc-0a3b-4dab-8139-b57c7946a155
# ╠═a3dc4444-f515-4e06-8985-959d9c0f72ae
# ╠═7fd4b1d0-793e-4988-b32f-51b3f06b80b5
# ╟─ba00d940-87c6-40b3-9763-4d2cd5ef8722
# ╟─437e8e31-b910-4ae3-96d1-cdae20a907b1
# ╟─131bbb1f-25c1-4bd2-af72-4177ebda209e
# ╟─c7615112-8c03-43fb-ad3a-e979f6ae951f
# ╟─2d45ac6d-fc78-48b6-a1c1-3bf8923c857e
# ╠═9f64b774-8333-48d0-9a60-aede670db6ff
# ╠═340e3dad-8b91-471e-84ed-8e4ac555ef49
# ╠═20697309-9d88-4d3f-a153-849f229cf47a
# ╟─93c3d676-aa0f-40b3-8c57-fd28ca5acf0c
# ╠═ea228836-2583-4b0e-9f7a-c2d50f9f8230
# ╠═888cbf64-05e9-4f6e-a473-3eff43d2085b
# ╠═1ee151db-1b91-4400-8474-9d689cb73664
# ╠═a9366254-3a82-4252-8c47-9b51b9dd504d
# ╟─602ecf93-2e61-44bc-ab45-06477fdff6f6
# ╠═e2bb2ed2-de48-4e53-b566-1e9b6f6c3aa1
# ╠═7bfc28ac-b41e-4c34-88dc-e74cd363922f
# ╠═9b5fc090-e7d5-4783-8c69-e630f203ab04
# ╠═d85158bc-1570-47f4-9ef7-6c4966d58440
# ╠═866d3228-4d98-4c87-9738-5a5ad2d0c611
# ╠═1b862b47-7789-44d9-9005-ce7b77bec837
# ╠═dcdb3dbc-5415-4c21-8431-da7bba9553ef
# ╟─8ecd4de0-f81f-4aee-aed9-c85312138bc1
# ╠═450f2841-faae-486c-900d-3b830da5b2bd
# ╠═ceee3d88-7d76-482e-8eb0-6bb7bbb75b7a
# ╠═06f50446-19fe-4826-be42-d9507f2d552a
# ╟─130a22a0-bbfd-4d69-bd99-194d71906f75
# ╠═5e0adaac-e483-4b9f-a365-6dd843fa1bd7
# ╠═d6aa0941-d958-414d-8930-3c802219d543
# ╠═88ac03d2-6bfe-42a8-96a3-e6acb1d6b5fc
# ╠═85e2f791-7498-413c-8216-f9ef5c2abd44
# ╠═f5a765fe-e03f-4bea-9d26-e4faf548cf8a
# ╟─f77da1eb-2cb3-446b-bb83-506e156456ad
# ╠═1f7ce44a-9720-404f-847c-c36601874396
# ╠═76da63a2-821d-41ac-8529-992b01f823f2
# ╠═d7a64fd1-7c9d-43af-bd89-58492a633f12
# ╟─a5cd4d56-cdb6-49d2-96db-bba5ca680b89
# ╠═262fecaf-08ed-48bb-88b3-7891fbb188bf
# ╠═84669c73-9668-43e4-9201-0b82ec95d9d2
# ╟─9c3f6eb0-c6eb-48ef-8dfd-c07bfe4f904f
# ╠═1340206a-e4b9-4445-8e12-e14d0d2e81a0
# ╠═f3c7318e-eeb0-4716-b7ab-aceab779e9d6
# ╟─cf9c5bf0-01ae-41ae-bf64-dba330a36ff5
# ╠═e91a0596-8401-4e34-b1ab-17d6eae08801
# ╠═07720d55-52a0-409a-9f56-d0525e25f129
# ╟─86d62a80-02f7-4c7d-9e90-7c54ee967ba0
# ╠═dcbb460b-3b1d-4ad1-8c4b-09c157a0f6d5
# ╠═2abadd4a-c902-42ff-949a-92149fff4d7e
# ╠═553a1172-96df-423f-be75-38edcf0d8baf
# ╠═d8fd852e-76d6-4753-8b7c-0cb0a0cda6a5
# ╟─853fdffc-0faf-482d-b3f5-e4ec364b8388
# ╟─a7092e6e-f3bd-499a-9bd7-a1aafd7aad25
# ╟─0ba85815-b5bd-42c9-badd-6f45561b4cb7
# ╟─387d7b6b-c8bd-4410-b877-5b62b376aca3
# ╠═1eae6170-2429-4ae3-bf98-418c33f6e19c
# ╠═c88ef184-1cf2-41fc-a88a-24a7d21f21d0
# ╠═5d59c62a-28a3-46fb-bf50-682ad5521f9b
# ╟─aa521dac-fe13-4c92-bdda-7b424ee986ec
# ╠═05950ae1-7f6e-440a-a5fe-90d71809e1fb
# ╠═46f49c82-f49d-4876-926d-3982c7ee5a1a
# ╟─a9bafcb9-6c9e-42fc-86f5-8e592eebd2e0
# ╠═1b8e5b4e-451f-40f3-8916-0478c127f9e2
# ╟─2cf952dd-1a98-404f-8e4e-a4f6d0b7863b
# ╠═18065beb-7aea-466f-a60b-e6f48fd7b55e
# ╟─70622924-1662-4dce-83c2-146359482f9a
# ╟─78ef2823-65be-4971-af90-b8d5ffe804e4
# ╟─f4297f64-8611-47fb-ac89-52b661b369b4
# ╠═43cbdebd-8348-4ed3-9d1e-2acfd479e003
# ╠═636bb4b5-8732-466a-9595-0819f1bb1b0a
# ╟─89c94f60-6932-4edc-8ab0-3cf506dc383a
# ╠═f7b59ba2-7b6e-4c33-85b9-f6c94e72147f
# ╠═dc89d384-c257-4428-9b6b-3b0c915c5952
# ╟─52236d2b-0d9f-48e9-9a99-069300a39789
# ╠═f990c703-7b6b-4cd0-8b18-5fe1b932de72
# ╠═a118d71b-6797-42a6-b286-c65243711301
# ╟─505cdf44-a706-4598-87f2-6379a7cbebc5
# ╠═a9aee53a-6912-456c-9f4b-58cc1958ef46
# ╟─3e5bb103-5c1f-408b-9725-3d4e3900f6e1
# ╟─b4764b3a-a0c1-4fdc-8ccb-c24742db0246
# ╠═818b6835-3e71-42ce-b717-d6b34120c3ce
# ╠═85932a61-9d42-4b89-b398-8b190ff44f57
# ╠═4cbf6f5d-1612-4014-b57f-0ca41f981d6a
# ╟─db343d3b-6789-49d4-955c-c65bb78d451e
# ╠═f6737420-0a73-42ae-b655-6bd88333630d
# ╟─773c6715-95e4-48f8-b65e-e7e18037d60f
# ╠═56063c42-46aa-4514-83d5-284fcdfaed9b
# ╟─dcc141f5-61ed-4d2d-9721-6c7a797749b8
# ╟─00d7c35b-ca2a-4e3c-be59-31cddfe1b588
# ╠═aa8a96e0-24ae-4eff-b35f-9a0538c0a30d
# ╠═98b0c8a8-48ac-4dd3-a535-0e0030d74333
# ╟─d1861390-1592-44b7-bc25-c9a194dd15b5
# ╠═d165a50b-db37-4012-9056-dbe04c46dc38
# ╟─894d0a89-a20c-4a9a-b7f3-3f0c656d6d33
# ╠═9069564f-3445-487d-a5e3-98508d278b07
# ╟─98470389-f0b1-47cf-a5d4-8a91b10499df
# ╠═927365af-503e-4005-951b-28c4fbbee92e
# ╠═0b02ecc3-d875-4a3a-b6af-36edcdf50a24
# ╟─56837c07-91a6-452b-8c3a-854bbe6a8423
# ╟─804a253f-28c4-4eb7-8bc9-ac00c3d80f6d
# ╟─2acf6798-6f1e-43bb-83df-ec1b41558134
# ╟─a35e90a8-320c-478f-ab35-72f742c52eca
# ╠═f2a779f5-d408-467b-9713-c58fe4db6913
# ╠═b4d1e9eb-1367-4dda-935c-8d24712dcd96
# ╠═b94fb940-4cfa-4496-aff6-bdd0014a1c5d
# ╠═19fa3b90-7cae-48dc-95e4-0fa63d4e0339
# ╠═977a9138-6530-4eaa-8b5f-df45c43864db
# ╠═57462b8a-99ca-4d77-a713-73a2178eaddb
# ╠═1a6172b5-10f8-47e7-bdc3-13acb541e9ed
# ╠═46aafc6d-96ec-4574-a294-8dc3fa9475fe
# ╠═d3a95665-1662-451f-98e8-795c62f0c550
# ╟─2dafe1b0-62ca-42b9-a1e6-b494662981c9
# ╟─8d3c4fcb-9b0b-483f-a3c7-b04bb5a70316
# ╠═29fa3f53-4193-465d-b44f-c72510d22725
# ╠═b7940f89-9e29-4411-b387-cddc2ac5dc98
# ╟─985a5d70-f094-4058-aa6d-956208e260ba
# ╟─01fb5470-fc33-4e17-905f-67186097fc11
# ╠═ff11fa72-77b3-44d6-b278-f5b77d79b19c
# ╠═0cab38ea-1151-41c6-8976-d4cbed765051
# ╠═d0a6aea1-a836-40f1-9255-3ac518d17de2
# ╠═c51d0af0-1d45-46b3-8773-c1f3760da340
# ╠═9cbfe45a-e1ec-4952-bbfe-78c077071807
# ╠═3d2442e5-153b-4df3-8b91-70390d549dae
# ╠═933e20d9-8a8e-4f7a-85d7-1d8d45edb1e1
# ╠═5e4a8521-b6a4-4b70-9fe2-483e9ac724f5
# ╠═ba40dd59-23e3-48ee-93e0-ef988144c36d
# ╟─e558f9db-04b1-4022-b57f-9ed4e0211982
# ╠═e4509940-3a56-4b64-b976-0b1f412cbdb1
# ╟─0d153832-c688-4a2a-b7b9-3caceffbd9e3
# ╟─0c409eca-1a97-4278-98fc-5c2ddd9d1960
# ╠═cc107566-ab61-4c25-875d-228939799f5b
# ╠═261a5fab-bab6-4a10-9676-4e9752f6d044
# ╠═b430b97f-8ba6-4a0c-a663-4ff3f28d5698
# ╠═03b9c491-4f2c-40fd-b7ce-bc36a1f995ed
# ╠═96b34aed-7c89-48f6-96c2-229c0d2f43bd
# ╟─86cfa808-b652-4b7a-bd41-6cd32c967d0c
# ╠═c8c19b7b-ee0e-434a-874e-cb4485b7e80b
# ╟─3fa44084-bbaa-4726-b35e-af0b77794771
# ╠═7a6b6044-6751-4041-99e7-0a608019110f
# ╠═72ee39ee-a599-4cb8-9429-841ce903e3c1
# ╠═a94203ea-b828-457a-a58e-3362a0307f2e
# ╟─89999299-e807-4004-ac69-83822267785b
# ╟─8e0fd0e0-610e-4377-9021-35be0c7f30ce
# ╠═1b592487-ad22-4f14-b374-87743b8ec134
# ╠═90f2a3c3-b652-4143-a68e-69c6a279b1f1
# ╟─94efad05-8481-4cd6-a9cb-829671c29c4d
# ╠═de2196da-70b9-4c45-9732-ad5b8e7e4a1e
# ╠═e27244e4-3002-47c1-ac01-6065017a5c9d
# ╟─76da54df-e90b-456a-b2a9-e8ca1e3afdb9
# ╠═23dcdc5e-eadd-494e-b414-d106b5cb7026
# ╟─dc25c7fe-542f-46e5-ab6c-83a666a19849
# ╟─a49378fc-331a-47c4-9caa-0a18145fe994
# ╟─e902aa9c-6eac-4d38-80e7-ee252cc30b53
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
