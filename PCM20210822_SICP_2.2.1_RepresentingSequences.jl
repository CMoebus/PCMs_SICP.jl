### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 5a4de43f-0218-441c-9d2e-09e7d2e60cb7
begin 
	#----------------------------------------------------------------------------
	using Pluto
	using Plots	
	using LaTeXStrings, Latexify
	using GraphRecipes
	#----------------------------------------------------------------------------
	println("pkgversion(Pluto)              = ", pkgversion(Pluto))
	println("pkgversion(Plots)              = ", pkgversion(Plots))
	println("pkgversion(Latexify)           = ", pkgversion(Latexify))
	println("pkgversion(GraphRecipes)       = ", pkgversion(GraphRecipes))
	#----------------------------------------------------------------------------
end # begin

# ╔═╡ 373a14a0-036b-11ec-3063-73539b537973
md"
=====================================================================================

#### SICP: [2.2.1 Representing Sequences](https://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e1) 

##### file: PCM20210822\_SICP\_2.2.1\_RepresentingSequences.jl

##### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/05/11 ***
=====================================================================================

"

# ╔═╡ 15d15f7e-ae79-4f36-87ca-0363ea9f598e
md"
---
##### 0. Introduction
*One of the useful structures we can build with pairs is a sequence -- an ordered collection of data objects. There are, of course, many ways to represent sequences in terms of pairs.*(SICP, 1996, 2016)

In the first part 3. we implement *lists* like in Scheme as a sequence of $cons$-cells which are constructed as $NamedTuple$s. In the second part 4. we implement *lists* as $Vector$s. This works even for elements of *different* type. In this case Julia *automatically* sets *pointers* the correct way.

"

# ╔═╡ 40af5180-4d61-4b0a-84d7-9f9431bbd4ed
md"
---
##### 1. Topics
- *pair*
- *sequence*
- *type* and *constructor* $Tuple$
- *named tuple* $NamedTuple$
- *box-and-pointer* structure
- *tuple* $Tuple$
- *list*
- *array* $Array$
- function $push!$
- *slurping* parameter
- *spitting* argument
- *constructor* $cons$
- *selectors* $car, cdr$
- *lists* as $Vector\{Any\}, Vector\{Int\}$
"

# ╔═╡ 5b5c992a-69eb-4fac-8817-11e6650e0141
md"
---
##### 2. Libraries and Service Functions
"

# ╔═╡ 6f38d96c-ab5f-4572-981d-0bc2bc3fcb5c
md"
##### 2.1 Libraries
"

# ╔═╡ 28190d71-6346-4c23-a8ce-f686f8393463
md"
---
##### 2.2 Abbreviations (*alias* names)
"

# ╔═╡ 04a3c30a-ccce-469c-9fa5-2b451082be8a
md"
---
##### 2.3 Service Functions

###### Function $ppBoxPointerStructureAsFlatList$ alias $pp$
- Converts a flat *latent* box-pointer structure into a *manifest* *list* representation with parentheses $(...)$ (a flat Scheme list).
- This even works - like in Scheme - for *differently* typed $car$-elements of the flat *latent* box-pointer structure

"

# ╔═╡ 278e3d83-0583-459a-adec-95843b3314fd
md"
---
##### 3. SICP-Scheme-like *functional* Julia
"

# ╔═╡ b2eb614e-8369-40f1-a7df-2551a3e20c9d
md"
---
##### 3.1 *Pair* as $NamedTuple$
---
###### 3.1.1 *Constructor* $cons$: *1st* Method of Function $cons$

$cons: Any \times Any \rightarrow NamedTuple$

$\;$

$cons: (x, y) \mapsto cons(x, y) \mapsto (car=x, cdr=y) \mapsto (x \bullet y)$

$\;$

where:

$cons(x, y), (car=x, cdr=y)\;;\;\text{ are Julia } expressions$ 

and

$(x \bullet y)\;;\;\text{ is the traditional textual Scheme representation of the box-and-pointer storage structure}$

$\;$
$\;$

"

# ╔═╡ ecbb360b-42d8-4ee8-8356-2028b1e5ccba
# (default) *untyped* constructor 'cons' with named fields 'car' and 'cdr'
cons(car, cdr)::NamedTuple = (car=car, cdr=cdr)  
#     ^    ^                   ^--------^------------- named fields
#     ^----^-------------------^--------^------------- parameter

# ╔═╡ 76b9bc7c-8afd-4e1d-a727-7646f377b09d
md"
---
###### 3.1.2 *Selector* $car$: *1st* Method of Function $car$

$car: NamedTuple \rightarrow Any$

$\;$

$car: (car=x, cdr=y) = (x \bullet y) \mapsto x$

$\;$
$\;$

"

# ╔═╡ f7000508-5beb-4d1f-8d9f-ca0dd98d94af
car(cons::NamedTuple) = cons.car  # definition of selector 'car'
#^-------------------------------- function name
#    ^------------------^--------- parameter
#                            ^---- field name

# ╔═╡ 0aee1b26-b063-4a95-acc9-b8bd02aef7de
md"
---
###### *Selector* $car$: *2nd* Method of Function $car$ 

$car: Tuple \rightarrow Any$

$\;$

$car: (x, y) = (x \bullet y) \mapsto x$

$\;$
$\;$

"

# ╔═╡ 50807964-0f4b-4455-a881-6660bcae5cc6
car(list::Tuple) = list[1]

# ╔═╡ 100ac0a5-9f7d-4563-9fac-03967cb82e17
md"
---
###### 3.1.3 *Selector* $cdr$: *1st* Method of Function $cdr$

$cdr: NamedTuple \rightarrow Any$

$\;$

$cdr: (car=x, cdr=y) = (x \bullet y) \mapsto y$

$\;$
$\;$

"

# ╔═╡ e4bc1b01-7e3f-41ad-b054-e52912c9357c
cdr(cons::NamedTuple) = cons.cdr          # definition of selector 'cdr'
#^----------------------------------------- function name
#    ^-------------------^----------------- parameter 
#                             ^------------ field name

# ╔═╡ f92b1571-2b83-43a1-b250-18cd8bd8aa71
md"
---
###### *Selector* $cdr$: *2nd* Method of Function $cdr$

$cdr: Tuple \rightarrow Tuple$

$\;$

$cdr: (x \bullet y) \mapsto y$

$\;$
$\;$

"

# ╔═╡ 96c24cba-865e-4bb8-bdba-a402ded802b1
md"
---
###### 3.1.4 Further Selectors $cadr, caddr, cadddr$
"

# ╔═╡ c71dea9a-f38a-4508-9e15-1aabb14cb7b0
md"
---
##### 3.1.5 Structures based on *Pairs*
*Pairs* can combine *differenty* typed elements (**Fig. 2.2.1** - **Fig. 2.2.4**).
"

# ╔═╡ 5a6d3aa0-cd51-4c8a-a5cd-4cb1082b5135
md""" 
---


                      +-----+-----+      +-------+
                ----->|  o  |  o--|----->| "two" |
                      +--|--+-----+      +-------+
                         |
                         v
                     +---+--+
                     | :one |
                     +------+



**Fig 2.2.1**:  *Latent* box-and-pointer structure generated by $cons(:one,\text{"two"})$ (c.f.. Fig. 2.2, SICP, 1996)

"""

# ╔═╡ b4ef7e20-499d-4019-a694-f5e88c3e0d67
md""" 
---


                      +-------+-------+      +-------+-------+
                ----->|   o   |   o---|----->|   o   |   o   |
                      +---|-- +-------+      +---|---+---|---+
                          |                      |       |
                          v                      v       v
                  +-------+-------+          +------+ +------+
                  |   o   |   o   |          |   3  | | 4.0  |
                  +---|---+---|---+          +------+ +------+
                      |       |
                      v       v
                 +------+  +-------+
                 | :one |  | "two" |
                 +------+  +-------+


**Fig 2.2.2**:  *Latent* box-and-pointer structure generated by $cons(cons(:one, \text{"two"}), cons(3, 4.0))$ (c.f. Fig. 2.3.left, SICP, 1996)

"""

# ╔═╡ 49d36791-24d6-4c7e-bec6-7593e8889478
md""" 
---


                      +-----+-----+      +-------+
                ----->|  o  |  o--|----->|  4.0  | 
                      +--|--+-----+      +-------+
                         |
                         v
                   +-----+-----+        +-----+-----+
                   |  o  |  o--|------->|  o  |  o  |
                   +--|--+-----+        +--|--+--|--+
                      |                    |     |
                      v                    v     v
                  +------+           +-------+ +-------+
                  | :one |           | "two" | |   3   |
                  +------+           +-------+ +-------+


**Fig 2.2.3**: *Latent* box-and-pointer structure generated by $cons(cons(:one, cons(\text{"two"}, 3)), 4.0)$ (c.f. Fig. 2.3.right, SICP, 1996)

"""

# ╔═╡ 47ff8a5c-4682-48c7-8080-272a73f38c3d
md"
---
##### 3.2 Sequences
*One of the useful structures we can build with pairs is a sequence (an ordered collection of data objects). There are, of course, many ways to represent sequences in terms of pairs.* (SICP, 1996, 2016)

"

# ╔═╡ c28d2764-d19a-45e2-9e42-b581f6b6e734
md"""
---
###### 3.2.1 *Flat* Box-and-Pointer Structures (= Scheme *Lists*)
*One particularly straightforward representation is illustrated in figure 2.2.4, where the sequence :one, "two", 3, 4.0 is represented as a chain of pairs. The car of each pair is the corresponding item in the chain, and the cdr of the pair is the next pair in the chain. The cdr of the final pair signals the end of the sequence by pointing to a distinguished value that is not a pair, represented in box-and-pointer diagrams as a diagonal line and in programs as the value of the variable :nil. The entire sequence is constructed by nested cons operations* (SICP, 1996, 2016; slightly modified)

"""

# ╔═╡ 4f343982-2aba-40ff-9d9d-f630ed4673f7
md"""


          +-----+-----+      +-----+-----+      +-----+-----+      +-----+-----+
    ----->|  o  |  o--|----->|  o  |  o--|----->|  o  |  o--|----->|  o  |  /  |
          +--|--+-----+      +--|--+-----+      +--|--+-----+      +--|--+-----+
             |                  |                  |                  | 
             v                  v                  v                  v
         +------+           +-------+           +-----+            +-----+
         | :one |           | "two" |           |  3  |            | 4.0 |
         +------+           +-------+           +-----+            +-----+


          
**Fig 2.2.4**:  The *latent* box-and-pointer structure of a *chain* (= *list*) of pairs generated by $cons(:one, cons(\text{ "two" },cons(3, cons(4.0, :nil))))$ (c.f. Fig. 2.4, SICP, 1996)

"""

# ╔═╡ 59c894bb-735e-4434-8a38-d5439d1edec1
md"
---
###### 3.2.2 *Lists*
*Such a sequence of pairs, formed by nested conses, is called a list, and Scheme provides a primitive called list to help in constructing lists.* (SICP, 1996, 2016)
"

# ╔═╡ 54b14609-6552-40e9-9410-cbf8b8694a04
md"
---
###### *Constructor* $listElementsToBoxPointer$ (*alias* $list$)
Constructs from a *sequence* of *arguments* (= *elements*) a *latent box-and-pointer* structure of *type* $NamedTuple$ which is a *sequence* or *list* of evaluated arguments (= a Scheme *list*)

$listElementsToBoxPointer: Any \times ... \rightarrow NamedTuple$

$\;$

The *list* is a *conceptualization* of a *latent* *box-and-pointer* structure implemented as $cons$-cells of *type* $NamedTuple$. 

The code of $listElementsToBoxPointer$ contains two different uses of $...$:

- definition: *<function>(<par>...)* means *slurping*: *many* arguments are slurped into *one* parameter

- call: *<function>(<arg>...)* means *splatting*: *one* argument is splatted into *many* parameters

$\;$

"

# ╔═╡ 79733f7a-fc76-4dff-9f2c-5774b334ce36
md"""
---
    oneThroughFour::NamedTuple
         |
         |
         v     +-----+-----+      +-----+-----+      +-----+-----+      +-----+-----+
         +---->|  o  |  o--|----->|  o  |  o--|----->|  o  |  o--|----->|  o  |  /  |
               +--|--+-----+      +--|--+-----+      +--|--+-----+      +--|--+-----+
                  |                  |                  |                  |   
                  v                  v                  v                  v
              +------+           +-------+           +-----+            +-----+
              | :one |           | "two" |           |  3  |            | 4.0 |
              +------+           +-------+           +-----+            +-----+


        
**Fig. 2.2.5**: *sequence* or *box-and-pointer* structure $oneThroughFour$ = $list(:one, \text{"two"}, 3, 4.0)$ (c.f. Fig. 2.4, SICP, 1996)

"""

# ╔═╡ 702449f7-20c2-43c9-a9a0-5be31ce61c4f
md"""
---
      myList::NamedTuple
         |
         |
         v      +---+---+    +---+---+    +---+---+    +---+---+    +---+---+
         +----->| o | o-|--->| o | o-|--->| o | o-|--->| o | o-|--->| o | / |
                +-|-+---+    +-|-+---+    +-|-+---+    +-|-+---+    +-|-+---+
                  |            |            |            |            |
                  v            v            v            v            v
               +----+       +----+       +----+       +----+       +----+
               |  1 |       |  2 |       |  3 |       |  4 |       |  5 |
               +----+       +----+       +----+       +----+       +----+


 
**Fig. 2.2.6**: Different types of elements in $myList = list(1, 2, 3, 4, 5)$

"""

# ╔═╡ a5ba5446-2f0e-4bba-8b36-77bcffd83c0e
md"
---
###### *Selector*: *1st* Method of Function $cadr$
"

# ╔═╡ 385dd0f4-f12d-475b-9ec6-5144e73112f2
md"
---
###### *Selector*: *1st* Method of Function $caddr$
"

# ╔═╡ 8d56041d-17f2-4699-968c-7580eac4a6ef
md"
---
###### *Selector*: *1st* Method of Function $cadddr$
"

# ╔═╡ 1428e283-676a-4553-8987-25eeb97d904a
md"
---
##### 3.3 List Operations
"

# ╔═╡ 7ac3bbee-5b12-4f0e-b2ef-b7244fb793fc
md"
---
###### 3.3.1 *1st* Method of Function $listRef$
"

# ╔═╡ 76d27715-78ad-4d67-826e-0c49ec95636d
md"
---
###### *2nd* Method of Function $listRef$
"

# ╔═╡ af79cdc3-a4bf-4343-9371-9258da74be2b
md"
for $$n=0$$, $$list\_ref$$ should be the $$car$$ of the list
"

# ╔═╡ 20a4cca9-dd1b-4f60-82ef-ad50d13de35c
md"
---
###### 3.3.2 *1st* *Tailrecursive* Method of Function $lengthListBoxPointer$ (*alias* $length$)

"

# ╔═╡ a802dec0-ed35-468d-b4e2-a36a6405ec0d
md"
---
###### *1st* *Iterative* Method of Function $lengthListBoxPointer2$ (*alias* $length2$)
"

# ╔═╡ 49338ccd-1767-4fac-b7db-3ba7e04492ee
md"
---
###### 3.3.3 *1st* Recursive Method of Function $appendBoxAndPointerStructures$ (*alias* $append$)
"

# ╔═╡ 4ae3bca1-94a5-4464-92d8-1b76e710a652
md"
---
##### 3.4 Mapping Over Lists
"

# ╔═╡ 5b9d814c-0878-44ef-913e-00cc89ad4639
md"
---
###### 3.4.1 *1st* Method of Function $scaleListBoxPointerStructure$ (*alias* $scaleList$)
"

# ╔═╡ 005c006a-697c-4f6f-9f18-78c99af79e7b
md"
---
###### 3.4.2 *1st* Method of Function $myMap$
"

# ╔═╡ 8a462e3e-cbfb-47bc-8f4d-7f147c4e2cdd
md"
---
##### 4. *Idiomatic* Julia
---
##### 4.1 *List* Operations
"

# ╔═╡ 31576ae3-a89a-413a-92cd-6fe1eaba2d08
md"
---
###### 4.1.1 *1st* Method of Function $listElementsAsVector(elements...)::Vector$ (*alias* $listAsVector$)
 - implemented as Julia *Vector* and ...
 - the $elements$ *parameter* in $list2$ is *slurping* and ...
 - the $elements$ *argument* in $[elements::Any...]$ is *spitting*

$listElementsToVector: Any \times ... \rightarrow [Any,...]$

$\;$

"

# ╔═╡ 698cefd3-3243-43b1-872b-33d6427fe0d0
listElementsAsVector(elements...)::Vector = [elements...]

# ╔═╡ 9dc33f4f-33a3-4855-b0a2-f908a163ebf7
md"
---
    
    
    oneThroughFour2::Vector{Int}
             |                     
             v
             |            +---------->+---->+---->+---->+
             |            ^           v     v     v     v
             v            |        +-----+-----+-----+-----+
             +----------->+------->|  1  |  2  |  3  |  4  |
                                   +-----+-----+-----+-----+
                    

        
**Fig. 2.2.7**: *sequence* or *list* $oneThroughFour2$ = $listElementsToVector(1,2,3,4)$ implemented as an Julia $Vector{Int}$

"

# ╔═╡ eefc868f-a339-4499-b450-e1dfbbbed481
md"""
---
      myList2::Vector{Any}
             |                     
             v
             |            +---------->+---->+---->+---->+-----+
             |            ^           v     v     v     v     v
             v            |        +-----+-----+-----+-----+-----+
             +----------->+------->|  o  |  o  |  o  |  o  |  o  |
                                   +--|--+--|--+--|--+--|--+--|--+
                                      |     |     |     |     |
                                      v     v     v     v     v
                                   +-----+-----+-----+-----+-----+      
                                   | :a  | :b  |  3  |  4  |"foo"|
                                   +-----+-----+-----+-----+-----+
                    

         
**Fig. 2.2.8**: $myList2 = listElementsToVector(:a, :b, 3, 4, \text{"foo"})$ implemented as a Julia *Vector{Any}*

---
"""

# ╔═╡ a5bda10e-20e7-4cd9-877a-f392a8c1c44b
md"
---
###### 4.1.2 *2nd* Method of *Constructor* $cons$ 
"

# ╔═╡ c1645190-174d-424a-abbd-c2abb488b7ba
# definition of a second variant for function 'cons'
cons(car::Any, list::Vector)::Vector = 
	pushfirst!(list[1:end], car)

# ╔═╡ 9abffca7-23c0-4287-8b54-f69d1f95a19f
cons(:one, "two")                 # similar but not identical to SICP, 1996, Fig 2.2

# ╔═╡ ec7d66b4-02f2-4996-93a2-1ce943bcbd3a
typeof(cons(:one, "two"))

# ╔═╡ e980b7d8-1c8b-4354-9bbd-313539b5c6ec
cons(            # Fig 2.2.2, similar but not identical to SICP, 1996, Fig. 2.3.left
	cons(:one, "two"), 
	cons(3, 4.0))  

# ╔═╡ 8203d83e-9ba8-40c2-8fb1-1f0f1f4a508c
cons(           # Fig 2.2.3, similar but not identical to SICP, 1996, Fig. 2.3.right
	cons(1, 
		cons(2, 3)), 
	4)                        

# ╔═╡ 77a6bc9b-6948-40f7-85f4-862e1824d436
cons(:one,           # Fig 2.2.4, similar but not identical to SICP, 1996, Fig. 2.4
	cons("two",
		cons(3, 
			cons(4.0, :nil))))          

# ╔═╡ 413f608d-5bf5-4f93-9ef0-a9d6d7f8583b
#              parameter 'elements' -----------v   slurps arguments
function listElementsAsBoxPointerStructure(elements...)::NamedTuple        
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else                          
		# argument 'elements[2:end]...'  spits its elements  ---v
		cons(elements[1], listElementsAsBoxPointerStructure(elements[2:end]...))
	end # if
end # function listElementsAsBoxPointerStructure

# ╔═╡ 74d753ce-50a6-4075-9108-eec2aca841c1
md"
---
###### 4.1.3 *3rd* Method of *Selector* $car$
"

# ╔═╡ 8812f55d-1d06-49bd-a967-24077b720a39
car(list::Vector)::Any = first(list::Vector)

# ╔═╡ 3c6644b3-003a-44d1-b8f7-bc41edd467b3
md"
---
###### 4.1.4 *2nd* Method of *Selector* $cdr$
"

# ╔═╡ a66e8fe3-9f44-4d02-9e21-439cca73cd89
cdr(list::Vector)::Vector = list[2:end]::Vector

# ╔═╡ e196666e-3a31-4f64-8ee6-caa9de9b0853
md"
---
###### 4.1.5 *Application* of *Selector* Combinations $cadr$ ...
"

# ╔═╡ bec12008-cf9e-4768-bccc-b39d83634617
md"
---
###### 4.1.6 *1st* Method of Function $lengthBoxPointerStructure3$ (*alias* $length3$)
... implemented with $while$ and type $NamedTuple{(:car, :cdr)}$
"

# ╔═╡ bcc67c53-de8b-462e-b5d3-5825740e1b92
md"
---
###### 4.1.7 *3rd* Method of function $listRef$
"

# ╔═╡ 7177cb33-9202-4394-a1b2-89255bbdfcd4
function listRef(list::Vector, n)::Any
	list[n+1]
end

# ╔═╡ 8ee31694-4e27-49a2-9570-a586cd998d91
md"
---
###### 4.1.8 *1st* Method of Function $length$ ...
... implemented with Julia's $Vector$
"

# ╔═╡ 8b8671fd-2af1-4b59-beca-1ce8ac51dbc7
function length(list::Vector)::Int
	lastindex(list)
end # function length

# ╔═╡ f5d45f7c-9507-4f5c-ad55-4b51951fad75
cdr(list::Tuple)::Tuple = 
	Tuple([list[j] for j in 2:length(list)])

# ╔═╡ 6f28288b-0cd9-4d32-b80b-1145a582a562
#----------------------------------------------------------------------------------
# - pretty-prints a flat box-pointer structure 
#    (= a Scheme list) as a flat Tuple
# - this even works (!) for differently typed $car$s in the pointer structure,
#    though the representation is an $Array$-typed value 
# - push!(collection, items...) -> collection
#    Insert one or more items in collection. 
#    If collection is an ordered container, 
#    the items are inserted at the end (in the given order).
# - A tuple is a fixed-length container that can hold any values of different types, #    but cannot be modified (it is immutable). 
#    The values can be accessed via indexing. 
#    Tuple literals are written with commas and parentheses
#-----------------------------------------------------------------------------------
function ppBoxPointerStructureAsFlatList(consList::NamedTuple)::Tuple  
	# tail-recursive ppIter
	#-------------------------------------------------------------------------------
	function ppIter(ppArray, consList)
		if consList == cons(:nil, :nil)                            # case 1
			ppArray
		elseif (car(consList) !== :nil) && (cdr(consList) == :nil) # case 2
			push!(ppArray, car(consList))
		else
			ppIter(push!(ppArray, car(consList)), cdr(consList))   # case 3
		end # if
	end # ppIter
	#-------------------------------------------------------------------------------
	Tuple(ppIter([], consList))
	#-------------------------------------------------------------------------------
end # function ppBoxPointerStructureAsFlatList

# ╔═╡ 6aad4e64-3a52-47bc-a69e-2a534ab2497a
begin 
	cadr   = car ∘ cdr
	caddr  = car ∘ cdr ∘ cdr
	cadddr = car ∘ cdr ∘ cdr ∘ cdr
end

# ╔═╡ 95836205-128f-489e-b767-303adf325916
# according SICP first element should have index == 0
function listRef(items::NamedTuple, n::Int)::Any
	if ==(n, 0)
		car(items)
	else
		try 
			listRef(cdr(items), -(n, 1))
		catch
			@warn "no lookup beyond end of list"
		end # try
	end
end # function listRef

# ╔═╡ c5c02c4f-6676-4a73-92a5-0d8a4c49330f
function lengthListBoxPointerStructure(list::NamedTuple)
	#-------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#-------------------------------------------------------------
	if null(list) 
		0
	elseif singleItem(list)
		1
	else
		+(1, lengthListBoxPointerStructure(cdr(list)))
	end # if
end # function lengthListBoxPointerStructure

# ╔═╡ 550ec189-2017-4489-b301-865986b6a8cf
function lengthListBoxPointerStructure2(list::NamedTuple)
	#-------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#-------------------------------------------------------------
	function lengthIter(tempList, count)
		if null(tempList) 
			count
		elseif singleItem(tempList)
			count + 1
		else
			lengthIter(cdr(tempList), +(1, count))
		end # if
	end
	#-----------------------------------------------------------
	lengthIter(list, 0)
end # function lengthListBoxPointerStructure2

# ╔═╡ 589badfa-1f1c-4f1e-8ca2-06f98c34b53b
function appendBoxPointerStructures(list1::NamedTuple, list2::NamedTuple) 
	#------------------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#------------------------------------------------------------------------
	if null(list1)
		list2
	elseif singleItem(list1)
		cons(car(list1), list2)
	else
		cons(car(list1), appendBoxPointerStructures(cdr(list1), list2))
	end # if
end # appendBoxPointerStructures

# ╔═╡ b33110e1-8a30-4831-908e-833104b37494
function scaleListBoxPointerStructure(list::NamedTuple, factor::Number)::NamedTuple
	#------------------------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#------------------------------------------------------------------------------
	if null(list)
		list
	elseif singleItem(list)
		cons(car(list) * factor, :nil)
	else
		cons(car(list) * factor, 
			 scaleListBoxPointerStructure(cdr(list), factor))
	end # if
end # function scaleListBoxPointerStructure

# ╔═╡ f62445fd-e6c0-4e3a-bc49-5f213a7f2192
function myMap(proc::Function, list::NamedTuple)
	#---------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#---------------------------------------------------------------
	if null(list)
		list
	elseif singleItem(list)
		cons(proc(car(list)), :nil)
	else
		cons(proc(car(list)), myMap(proc, (cdr(list))))
	end # if
end # function myMap

# ╔═╡ b5054052-cb2d-4486-9b24-cdeb4eaf6aef
function scaleListBoxPointerStructure2(list::NamedTuple, factor::Number)
	myMap(x -> *(x, factor), list)
end # function scaleListBoxPointerStructure2

# ╔═╡ a02680a3-5457-4e3d-ba31-54b257e2bd90
function lengthBoxPointerStructure3(list::NamedTuple{(:car, :cdr)})::Int
	#-----------------------------------------------------------------------
	null(list) = 
		(car(list) == :nil) && (cdr(list) == :nil)
	singleItem(list) = 
		(car(list) !== :nil) && (cdr(list) == :nil)
	#-----------------------------------------------------------------------
	tempList, count = list, 0
	if null(tempList) 
			count
	else 
		while !singleItem(tempList)
			tempList, count = cdr(tempList), count + 1
		end # while
		count + 1
	end # if
	#-----------------------------------------------------------------------
end # function lengthBoxPointerStructure3

# ╔═╡ b70fb646-3288-4e9a-8703-a2941da79fe5
begin
	#-----------------------------------------------------------
	append(list1::NamedTuple, list2::NamedTuple) =		
		appendBoxPointerStructures(
			list1::NamedTuple, list2::NamedTuple)
	length(list::NamedTuple) = 
		lengthListBoxPointerStructure(
			list::NamedTuple)
	length2(list::NamedTuple) = 
		lengthListBoxPointerStructure2(
			list::NamedTuple)
	length3(list::NamedTuple{(:car, :cdr)})::Int =
		lengthBoxPointerStructure3(
			list::NamedTuple{(:car, :cdr)})::Int
	list(elements...)::NamedTuple = 
		listElementsAsBoxPointerStructure(
			elements...)::NamedTuple
	listAsVector(elements...)::Vector =
		listElementsAsVector(
			elements...)::Vector
	pp(consList::NamedTuple)::Tuple  =	
		ppBoxPointerStructureAsFlatList(
			consList::NamedTuple)::Tuple	
	scaleList(list::NamedTuple, factor::Number)::NamedTuple =
		scaleListBoxPointerStructure(
			list::NamedTuple, factor::Number)::NamedTuple
	scaleList2(list::NamedTuple, factor::Number)::NamedTuple = 
		scaleListBoxPointerStructure2(
			list::NamedTuple, factor::Number)::NamedTuple
	#-----------------------------------------------------------
end # begin

# ╔═╡ d2c3f11b-59eb-43a0-98eb-10a209a34bb1
pp(cons(:nil, :nil))

# ╔═╡ 399e9f84-a318-409e-83eb-91c4c8418b21
pp(cons(:a, :nil))

# ╔═╡ 5cec6d4d-4124-46a4-9400-d3c7bfeaa2b2
pp(                                     # latent box-pointer structure of Fig. 2.2.4
	cons(:one,                       
		cons("two",
			cons(3, 
				cons(4.0, :nil)))))

# ╔═╡ 19dfb768-a350-4e70-a6fe-0d1f8eae96c4
oneThroughFour =                                   # latent box-and-pointer structure
	list(:one, "two", 3, 4.0)

# ╔═╡ c71f6b2b-db7b-4514-8b0a-91c5032689dc
typeof(oneThroughFour) <: NamedTuple

# ╔═╡ 3049ab44-f2a2-4baf-9765-301392337c3f
car(oneThroughFour)

# ╔═╡ be65d3f7-84cf-4d9d-9f8e-171f09745d23
cdr(oneThroughFour)                                # latent box-and-pointer structure

# ╔═╡ 8c47ee7a-7bb5-44e3-aeb1-12f2f9f368eb
car(cdr(oneThroughFour))

# ╔═╡ 606fa931-1420-4df3-b0c2-c903d161fb6b
cons(10, oneThroughFour)                           # latent box-and-pointer structure

# ╔═╡ 88b6b567-3fc1-4af1-aecb-f1f1c0c1e75f
cons(5, oneThroughFour)                            # latent box-and-pointer structure

# ╔═╡ 54011493-0526-4b6c-9f91-0b5cf4808bb9
pp(oneThroughFour)                                 # list similar to Scheme list

# ╔═╡ 062906e4-1e1c-4d3d-8d18-ba3689c82b67
pp(cdr(oneThroughFour))                            # list similar to Scheme list

# ╔═╡ dee2d0c4-3431-4355-9c02-c15b8e335256
pp(cons(10, oneThroughFour))                       # similar to Scheme list

# ╔═╡ c81d8ac8-e2bb-42aa-9bf5-f0651decd804
list(1, 2, 3, 4, 5)                              # latent box-and-pointer structure

# ╔═╡ 1efc3f69-28f7-46fb-ba00-2dc1c434234b
myList =  list(1, 2, 3, 4, 5)                    # list similar to Scheme list

# ╔═╡ f8a80d98-dc38-4766-a3da-e65756a30ef7
typeof(myList) <: NamedTuple

# ╔═╡ efb2cdf0-b929-4b91-8ebf-22df244e577c
car(myList)                                        # similar to Scheme

# ╔═╡ 4439e6b7-27c1-4a8f-adc9-9de9b4efcc82
cdr(myList)                                        # latent box-and-pointer structure

# ╔═╡ 96e38418-c4e3-4563-aee8-fe75f8f7df9c
cadr(myList)

# ╔═╡ 6c199988-a987-410d-8be7-629862e4e60a
caddr(myList)

# ╔═╡ a5ff358d-d467-424d-930f-59e3ef4bcc5c
cadddr(myList)

# ╔═╡ 6cf0c87e-f929-4d13-b71f-d9c7ed90c5af
typeof(myList)

# ╔═╡ 65d4a253-36fa-4977-b657-23af6bdaae31
typeof(myList)

# ╔═╡ 0b604a38-b37a-470c-8fcb-4644ed88f4ee
pp(myList)

# ╔═╡ fd289ea7-e422-42cc-94b3-79de0c62fcba
pp(cdr(myList))                                    # list similar to Scheme list

# ╔═╡ 0bf35cab-4249-4984-be04-cffb3aab352d
squares = list(1, 4, 9, 16, 25)              # latent box-and-pointer structure

# ╔═╡ e13349e0-3a7a-4245-b6f7-5b8ea019053a
pp(squares)                                  # list similar to Scheme list

# ╔═╡ b5fb717e-2988-4492-aa46-ac835b2099b5
odds = list(1, 3, 5, 7)

# ╔═╡ 52391fbc-87ac-42b1-8790-8dda0d3e1008
pp(odds)

# ╔═╡ 9e453d79-4c54-4c6c-bf4d-7b982fed5a18
length2(list())

# ╔═╡ c234ab19-8fa7-4963-bd88-3077c3924502
length2(list(:a))

# ╔═╡ 501ea091-049c-4bfc-86bf-d820dd59ecf7
length2(list(:a, :b))

# ╔═╡ 7ce00f81-566a-414d-9feb-b25907f5443d
length2(odds)

# ╔═╡ 74057de4-cf91-413d-b4f6-5e10ea2d5ece
myMap(abs, list(-10, 2.5, -11.6, 17))

# ╔═╡ 1a387789-4234-4a4b-80ae-1de62ca7162b
pp(myMap(abs, list(-10, 2.5, -11.6, 17))) 

# ╔═╡ 06f3b046-2650-4755-aada-3865688fa612
myMap(x -> *(x, x), list(1, 2, 3, 4))

# ╔═╡ 7df7fc3c-5408-48ba-9a27-08bab8eebc8c
pp(myMap(x -> *(x, x), list(1, 2, 3, 4)))

# ╔═╡ 4c522af5-eea5-458c-8c1c-b6403d4d9e69
scaleList2(list(), 10)

# ╔═╡ d01d3225-4bf0-4a94-9c08-155a137876f0
scaleList2(list(1, 2, 3, 4, 5), 10)

# ╔═╡ e07aa3d4-549e-4158-b1e7-8419872e8cc9
pp(scaleList2(list(1, 2, 3, 4, 5), 10))

# ╔═╡ 224d8870-bb45-4ace-86eb-200e1a7868f9
oneThroughFour2 = listAsVector(1, 2, 3, 4)

# ╔═╡ c342f048-5b35-4ef4-b8c8-9e6c54838ae8
typeof(oneThroughFour2)

# ╔═╡ 41a0e04c-d9ec-465c-922c-dca7e37d13a0
typeof(oneThroughFour2) <: Vector

# ╔═╡ 3e067d96-b35e-4054-aefc-04fa0dca3184
cons(10, oneThroughFour2)

# ╔═╡ 621dbe13-519e-4ef1-8be8-258b3bbd9fc2
car(oneThroughFour2)

# ╔═╡ 8dd4d38c-9e64-4a9c-b554-39120e41d9db
cdr(oneThroughFour2)

# ╔═╡ 7f77a89d-e662-4857-aa4c-47d162fc09a0
car(cdr(oneThroughFour2))

# ╔═╡ d5e77221-31e5-469b-99af-38953626bb77
cadr(oneThroughFour2)

# ╔═╡ 1d4cf0a0-187d-4c62-8589-0184d21e8ee1
myList2 = listAsVector(:a, :b, 3, 4, "foo")

# ╔═╡ de40c17b-3fce-4abf-ba77-df817ae9dedf
typeof(myList2)

# ╔═╡ d423cecc-a792-4ef5-8db0-0740b30c9d83
typeof(myList2) <: Vector{Any}

# ╔═╡ cd34304a-8cc9-465d-bccc-18a9f5b9c121
length3(list())

# ╔═╡ 614c56ac-09a5-4f35-b92f-1d8cabbf6ecb
length3(list(:a))

# ╔═╡ 8728a302-43ab-468c-a051-6b0491674a88
length3(list(:a, :b))

# ╔═╡ ffe04f45-008e-4465-aeec-1c5c18f2157e
length3(odds)

# ╔═╡ 9d0e664d-8758-4b7a-bee7-6d077e70fe1e
# idiomatic Julia with broadcasting '.^2'
squares2 = listAsVector(1, 2, 3, 4, 5).^2              # broadcasting over vectors 

# ╔═╡ e6fbc325-8e4b-4941-8bf8-6975603747ab
squares2

# ╔═╡ 26f808f5-a6d3-4d87-bcf7-a3479c9ef225
typeof(squares2)

# ╔═╡ dc8e15fd-f995-4eb8-88e0-21212ebdbc0c
odds2 = listAsVector(1, 3, 5, 7)

# ╔═╡ c9746c18-26f8-47d0-9be7-9e3621921e1b
# according SICP first element should have index == 0
function listRef(items::Vector, n::Int)::Any
	if 0 <= n < length(items)
		items[n + 1]
	else
		"error: look up beyond end of list"
	end
end # function listRef

# ╔═╡ 8cdd6637-2fa5-4e69-b4ff-8d572bf9d48b
listRef(myList, 0)

# ╔═╡ ff8a8790-bd88-42d7-82e2-5cf3c6793786
listRef(myList, 1)

# ╔═╡ 4e219348-7a26-42b7-8fc6-c37df3bf2278
listRef(myList, 2)

# ╔═╡ acae06c7-e7ba-4f0c-9dff-f2836b9ad985
listRef(myList, 3)

# ╔═╡ b179e95a-b77a-4f18-9dae-cf8c0dfbe915
listRef(myList, 4)

# ╔═╡ ea6b2b22-7b9c-4e92-9da8-8492decd234d
listRef(myList, 5)

# ╔═╡ 2844c5a8-b20d-4979-a3e5-533e6b83e7fc
listRef(squares, 0)                          # for index == 0 it's the first element 

# ╔═╡ 8c855187-3f21-47bf-93d8-4c1400674bf6
listRef(squares, 0) == car(squares)

# ╔═╡ b022a613-510f-4f9b-9540-94718884b3f4
listRef(squares, 3)                          # for index == 3 it's the 4th element 

# ╔═╡ cf8956ba-61d3-4027-9d49-ad8cbfed97b4
listRef(squares2, 3)

# ╔═╡ d1b4d1b1-7d6d-4059-b451-a97d798c4dd6
listRef(squares2, 0)

# ╔═╡ 39d7227c-3586-4f62-875f-d72c08aa455a
listRef(squares2, 3)

# ╔═╡ 54fa7582-ca53-495c-bcfc-73b57c01d9a8
length(odds)

# ╔═╡ ae19c5ea-9767-46ef-9677-7070a2c98346
length(squares2)

# ╔═╡ 97d8ea55-d515-4eb2-a907-17cdc9be51d4
length(odds2)

# ╔═╡ b12de1c2-bfef-4679-975b-141ad169e11a
md"
---
###### 4.1.9 *2nd* Method of $append$ 
... implemented with Julia's $Vector$
"

# ╔═╡ 9ddf31fb-8fed-42f9-9e0d-c0c75f008cee
function append(list1::Vector, list2::Vector)::Vector
	#-------------------------------------------------
	null(list::Array)::Bool = list == []
	#-------------------------------------------------
	if null(list1)
		list2
	else 
		cons(car(list1), append(cdr(list1), list2))
	end	
end

# ╔═╡ 6048f7e3-5570-4449-9c60-de2f44794b2a
append(squares, odds)

# ╔═╡ 0e0d818b-d998-4a8b-b4bf-f8a88ab7dc4c
pp(append(squares, odds))

# ╔═╡ 00414b7f-b1d9-424e-ab38-2a1a1d64da8f
append(odds, squares)


# ╔═╡ eb27d136-d979-43d9-b102-600f82870792
pp(append(odds, squares))

# ╔═╡ 6a0e5893-3135-4883-ba7c-1805fa55ed73
append(squares2, odds2)

# ╔═╡ 421c396e-f71b-4c4c-9a3d-141e8d6cccd3
append(odds2, squares2)

# ╔═╡ 8060aeae-6cbc-4b26-b9f1-29d572b7bab3
first(odds2)

# ╔═╡ 87e8768c-d562-444d-be5a-176fa08a393d
last(odds2)

# ╔═╡ 6daaebb1-454b-4908-8ae8-e8fc4c8bcc76
copy(odds2[1:3])

# ╔═╡ 3108621b-98a7-4c97-9a33-445b766e04f5
function append2(list1::Vector, list2::Vector)::Vector
	#------------------------------------------------------
	null(list::Array)::Bool = list == []
	#------------------------------------------------------
	function appendIter(list1::Array, list1_list2::Array)
		if 	null(list1)
			list1_list2
		else 
			appendIter(list1[1:end-1], cons(last(list1),list1_list2))
		end
	end
	appendIter(list1, list2)
end

# ╔═╡ ac3533c1-08f4-4dc7-8a21-102d9b5fa3a7
append2(squares2, odds2)

# ╔═╡ 8ee3adf2-81ec-4aaf-8dfc-f17f20c7308e
append2(odds2, squares2)

# ╔═╡ 96fdc3f7-e75a-4697-b48a-ee7dac5301c8
function append3(list1::Vector, list2::Vector)::Vector
	#-------------------------------------------------
	null(list::Array)::Bool = list == []
	#-------------------------------------------------
	list1_list2 = list2
	while !null(list1)
		list1, list1_list2 = list1[1:end-1], cons(last(list1),list1_list2)
	end
	list1_list2
end

# ╔═╡ 1a6184d4-359f-477a-9e31-1c68fe40ba73
append3(squares2, odds2)

# ╔═╡ 3f14629f-e2de-40d5-a661-dc2c819a3e4a
append3(odds2, squares2) 

# ╔═╡ 53388b16-6443-4aac-b6b6-d23a8e8b7c9d
function append4(list1::Vector, list2::Vector)::Vector
	vcat(list1, list2)
end

# ╔═╡ 27ce665c-c137-42aa-a331-5345cc9f21de
append4(squares2, odds2)

# ╔═╡ 76f49cd8-8116-47c8-b4b6-b52154e08364
append4(odds2, squares2) 

# ╔═╡ 5f38b665-766a-4032-a26b-036b476790a2
md"
---
##### 4.2 Mapping over lists
"

# ╔═╡ af1109e0-47ad-4ab2-8209-27bb8f880bb5
md"
###### 4.2.1 *2nd* Method of $scaleList$ ...
... implemented with Julia's *broadcasting* over $Vector$s
"

# ╔═╡ 50b38ed0-84c2-4dac-b2ec-9f21e6ae1333
function scaleList(list::Vector, factor::Number)::Vector
	list.*factor
end

# ╔═╡ 0b7050d5-1824-407a-b14e-42e2b96c367b
scaleList(list(), 10)

# ╔═╡ 689180cf-ab0d-4488-a272-ca960a37c3f4
pp(scaleList(list(), 10))   

# ╔═╡ ac560a9b-faac-47d1-948c-88d94fee7fcc
scaleList(list(1, 2, 3, 4, 5), 10)

# ╔═╡ 6daa1278-575f-4b8e-bd2f-0db8e6ccf7f3
pp(scaleList(list(1, 2, 3, 4, 5), 10))

# ╔═╡ aacaabd9-0614-4799-887c-9b122c6c8519
scaleList(listAsVector(1, 2, 3, 4, 5), 10)

# ╔═╡ f5af7525-2be7-48a5-b938-c2344b6f2bff
typeof(scaleList(listAsVector(1, 2, 3, 4, 5), 10))

# ╔═╡ b988b6bb-f3a2-4a10-b4d8-b437a74779f9
listAsVector(-10, 2.5, -11.6, 17)

# ╔═╡ 2a76cc50-c918-45b8-ab64-8d03228f113e
map(abs, listAsVector(-10, 2.5, -11.6, 17))

# ╔═╡ 7a1d9398-453b-4616-97c2-c6e463f78b25
map(listAsVector(-10, 2.5, -11.6, 17)) do item
	abs(item)
end

# ╔═╡ 89e4b01a-1ad7-486a-994c-f53061de9f04
map(x -> x^2, listAsVector(1, 2, 3, 4))

# ╔═╡ 17aaf21c-d037-45a9-bbbf-63218db57adf
map(listAsVector(1, 2, 3, 4)) do item
	item^2
end

# ╔═╡ 454a1c03-7353-4909-b244-13ffd61fd9ea
function scaleList3(list::Vector, factor::Number)::Vector
	map(list) do item
		item * factor
	end # map
end # function scaleList3

# ╔═╡ 17180638-2950-4f62-801a-b6eeedda28ef
scaleList3(listAsVector(1, 2, 3, 4, 5), 10)

# ╔═╡ 5e347078-c971-424d-8466-0b7a8162661c
md"
---
##### 5. Summary
We implemented *sequences* in a SICP-like manner simulating *Scheme-lists*. *cons
-cells* were implemented as $NamedTuple$. 

The alternative implementation was done by Juia's $Vector$-type. This could be achieved even when the *type* of elements were *different*. In this case pointers we set *automatically correct* by the Julian compiler. If efficiency is of concern Julian *vectors* and only *one-type* vector elements should be preferred. 
"

# ╔═╡ a43f0bce-8507-4b33-9862-f11999071a59
md"
##### 6. References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996; last visit 2025/05/05
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://sarabander.github.io/sicp/html/index.xhtml#Top), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2025/05/05
"

# ╔═╡ 41e8c05a-fd5e-4d94-a14c-ed60b6570d59
md"
---
##### end of ch. 2.2.1
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

[compat]
GraphRecipes = "~0.5.13"
LaTeXStrings = "~1.4.0"
Latexify = "~0.16.7"
Plots = "~1.40.13"
Pluto = "~0.20.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "e19ed3c31fb623d0b3840423501980d3a0a7155a"

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
# ╟─373a14a0-036b-11ec-3063-73539b537973
# ╟─15d15f7e-ae79-4f36-87ca-0363ea9f598e
# ╟─40af5180-4d61-4b0a-84d7-9f9431bbd4ed
# ╟─5b5c992a-69eb-4fac-8817-11e6650e0141
# ╟─6f38d96c-ab5f-4572-981d-0bc2bc3fcb5c
# ╠═5a4de43f-0218-441c-9d2e-09e7d2e60cb7
# ╟─28190d71-6346-4c23-a8ce-f686f8393463
# ╠═b70fb646-3288-4e9a-8703-a2941da79fe5
# ╟─04a3c30a-ccce-469c-9fa5-2b451082be8a
# ╠═6f28288b-0cd9-4d32-b80b-1145a582a562
# ╟─278e3d83-0583-459a-adec-95843b3314fd
# ╟─b2eb614e-8369-40f1-a7df-2551a3e20c9d
# ╠═ecbb360b-42d8-4ee8-8356-2028b1e5ccba
# ╟─76b9bc7c-8afd-4e1d-a727-7646f377b09d
# ╟─f7000508-5beb-4d1f-8d9f-ca0dd98d94af
# ╟─0aee1b26-b063-4a95-acc9-b8bd02aef7de
# ╠═50807964-0f4b-4455-a881-6660bcae5cc6
# ╟─100ac0a5-9f7d-4563-9fac-03967cb82e17
# ╠═e4bc1b01-7e3f-41ad-b054-e52912c9357c
# ╟─f92b1571-2b83-43a1-b250-18cd8bd8aa71
# ╠═f5d45f7c-9507-4f5c-ad55-4b51951fad75
# ╟─96c24cba-865e-4bb8-bdba-a402ded802b1
# ╠═6aad4e64-3a52-47bc-a69e-2a534ab2497a
# ╟─c71dea9a-f38a-4508-9e15-1aabb14cb7b0
# ╟─5a6d3aa0-cd51-4c8a-a5cd-4cb1082b5135
# ╠═9abffca7-23c0-4287-8b54-f69d1f95a19f
# ╠═ec7d66b4-02f2-4996-93a2-1ce943bcbd3a
# ╟─b4ef7e20-499d-4019-a694-f5e88c3e0d67
# ╠═e980b7d8-1c8b-4354-9bbd-313539b5c6ec
# ╟─49d36791-24d6-4c7e-bec6-7593e8889478
# ╠═8203d83e-9ba8-40c2-8fb1-1f0f1f4a508c
# ╟─47ff8a5c-4682-48c7-8080-272a73f38c3d
# ╟─c28d2764-d19a-45e2-9e42-b581f6b6e734
# ╟─4f343982-2aba-40ff-9d9d-f630ed4673f7
# ╠═77a6bc9b-6948-40f7-85f4-862e1824d436
# ╠═d2c3f11b-59eb-43a0-98eb-10a209a34bb1
# ╠═399e9f84-a318-409e-83eb-91c4c8418b21
# ╠═5cec6d4d-4124-46a4-9400-d3c7bfeaa2b2
# ╟─59c894bb-735e-4434-8a38-d5439d1edec1
# ╟─54b14609-6552-40e9-9410-cbf8b8694a04
# ╠═413f608d-5bf5-4f93-9ef0-a9d6d7f8583b
# ╟─79733f7a-fc76-4dff-9f2c-5774b334ce36
# ╠═19dfb768-a350-4e70-a6fe-0d1f8eae96c4
# ╠═c71f6b2b-db7b-4514-8b0a-91c5032689dc
# ╠═54011493-0526-4b6c-9f91-0b5cf4808bb9
# ╠═3049ab44-f2a2-4baf-9765-301392337c3f
# ╠═be65d3f7-84cf-4d9d-9f8e-171f09745d23
# ╠═062906e4-1e1c-4d3d-8d18-ba3689c82b67
# ╠═8c47ee7a-7bb5-44e3-aeb1-12f2f9f368eb
# ╠═606fa931-1420-4df3-b0c2-c903d161fb6b
# ╠═dee2d0c4-3431-4355-9c02-c15b8e335256
# ╠═88b6b567-3fc1-4af1-aecb-f1f1c0c1e75f
# ╟─702449f7-20c2-43c9-a9a0-5be31ce61c4f
# ╠═c81d8ac8-e2bb-42aa-9bf5-f0651decd804
# ╠═1efc3f69-28f7-46fb-ba00-2dc1c434234b
# ╠═f8a80d98-dc38-4766-a3da-e65756a30ef7
# ╠═0b604a38-b37a-470c-8fcb-4644ed88f4ee
# ╠═efb2cdf0-b929-4b91-8ebf-22df244e577c
# ╠═4439e6b7-27c1-4a8f-adc9-9de9b4efcc82
# ╠═fd289ea7-e422-42cc-94b3-79de0c62fcba
# ╟─a5ba5446-2f0e-4bba-8b36-77bcffd83c0e
# ╠═96e38418-c4e3-4563-aee8-fe75f8f7df9c
# ╟─385dd0f4-f12d-475b-9ec6-5144e73112f2
# ╠═6c199988-a987-410d-8be7-629862e4e60a
# ╟─8d56041d-17f2-4699-968c-7580eac4a6ef
# ╠═a5ff358d-d467-424d-930f-59e3ef4bcc5c
# ╟─1428e283-676a-4553-8987-25eeb97d904a
# ╟─7ac3bbee-5b12-4f0e-b2ef-b7244fb793fc
# ╠═95836205-128f-489e-b767-303adf325916
# ╟─76d27715-78ad-4d67-826e-0c49ec95636d
# ╠═c9746c18-26f8-47d0-9be7-9e3621921e1b
# ╠═6cf0c87e-f929-4d13-b71f-d9c7ed90c5af
# ╠═8cdd6637-2fa5-4e69-b4ff-8d572bf9d48b
# ╠═ff8a8790-bd88-42d7-82e2-5cf3c6793786
# ╠═4e219348-7a26-42b7-8fc6-c37df3bf2278
# ╠═acae06c7-e7ba-4f0c-9dff-f2836b9ad985
# ╠═b179e95a-b77a-4f18-9dae-cf8c0dfbe915
# ╠═65d4a253-36fa-4977-b657-23af6bdaae31
# ╠═ea6b2b22-7b9c-4e92-9da8-8492decd234d
# ╠═0bf35cab-4249-4984-be04-cffb3aab352d
# ╠═e13349e0-3a7a-4245-b6f7-5b8ea019053a
# ╠═2844c5a8-b20d-4979-a3e5-533e6b83e7fc
# ╟─af79cdc3-a4bf-4343-9371-9258da74be2b
# ╠═8c855187-3f21-47bf-93d8-4c1400674bf6
# ╠═b022a613-510f-4f9b-9540-94718884b3f4
# ╟─20a4cca9-dd1b-4f60-82ef-ad50d13de35c
# ╠═c5c02c4f-6676-4a73-92a5-0d8a4c49330f
# ╠═b5fb717e-2988-4492-aa46-ac835b2099b5
# ╠═52391fbc-87ac-42b1-8790-8dda0d3e1008
# ╠═54fa7582-ca53-495c-bcfc-73b57c01d9a8
# ╟─a802dec0-ed35-468d-b4e2-a36a6405ec0d
# ╠═550ec189-2017-4489-b301-865986b6a8cf
# ╠═9e453d79-4c54-4c6c-bf4d-7b982fed5a18
# ╠═c234ab19-8fa7-4963-bd88-3077c3924502
# ╠═501ea091-049c-4bfc-86bf-d820dd59ecf7
# ╠═7ce00f81-566a-414d-9feb-b25907f5443d
# ╟─49338ccd-1767-4fac-b7db-3ba7e04492ee
# ╠═589badfa-1f1c-4f1e-8ca2-06f98c34b53b
# ╠═6048f7e3-5570-4449-9c60-de2f44794b2a
# ╠═0e0d818b-d998-4a8b-b4bf-f8a88ab7dc4c
# ╠═00414b7f-b1d9-424e-ab38-2a1a1d64da8f
# ╠═eb27d136-d979-43d9-b102-600f82870792
# ╟─4ae3bca1-94a5-4464-92d8-1b76e710a652
# ╟─5b9d814c-0878-44ef-913e-00cc89ad4639
# ╠═b33110e1-8a30-4831-908e-833104b37494
# ╠═0b7050d5-1824-407a-b14e-42e2b96c367b
# ╠═689180cf-ab0d-4488-a272-ca960a37c3f4
# ╠═ac560a9b-faac-47d1-948c-88d94fee7fcc
# ╠═6daa1278-575f-4b8e-bd2f-0db8e6ccf7f3
# ╟─005c006a-697c-4f6f-9f18-78c99af79e7b
# ╠═f62445fd-e6c0-4e3a-bc49-5f213a7f2192
# ╠═74057de4-cf91-413d-b4f6-5e10ea2d5ece
# ╠═1a387789-4234-4a4b-80ae-1de62ca7162b
# ╠═06f3b046-2650-4755-aada-3865688fa612
# ╠═7df7fc3c-5408-48ba-9a27-08bab8eebc8c
# ╠═b5054052-cb2d-4486-9b24-cdeb4eaf6aef
# ╠═4c522af5-eea5-458c-8c1c-b6403d4d9e69
# ╠═d01d3225-4bf0-4a94-9c08-155a137876f0
# ╠═e07aa3d4-549e-4158-b1e7-8419872e8cc9
# ╟─8a462e3e-cbfb-47bc-8f4d-7f147c4e2cdd
# ╟─31576ae3-a89a-413a-92cd-6fe1eaba2d08
# ╠═698cefd3-3243-43b1-872b-33d6427fe0d0
# ╟─9dc33f4f-33a3-4855-b0a2-f908a163ebf7
# ╠═224d8870-bb45-4ace-86eb-200e1a7868f9
# ╠═c342f048-5b35-4ef4-b8c8-9e6c54838ae8
# ╠═41a0e04c-d9ec-465c-922c-dca7e37d13a0
# ╟─eefc868f-a339-4499-b450-e1dfbbbed481
# ╠═1d4cf0a0-187d-4c62-8589-0184d21e8ee1
# ╠═de40c17b-3fce-4abf-ba77-df817ae9dedf
# ╠═d423cecc-a792-4ef5-8db0-0740b30c9d83
# ╟─a5bda10e-20e7-4cd9-877a-f392a8c1c44b
# ╠═c1645190-174d-424a-abbd-c2abb488b7ba
# ╟─74d753ce-50a6-4075-9108-eec2aca841c1
# ╠═8812f55d-1d06-49bd-a967-24077b720a39
# ╟─3c6644b3-003a-44d1-b8f7-bc41edd467b3
# ╠═a66e8fe3-9f44-4d02-9e21-439cca73cd89
# ╠═3e067d96-b35e-4054-aefc-04fa0dca3184
# ╠═621dbe13-519e-4ef1-8be8-258b3bbd9fc2
# ╠═8dd4d38c-9e64-4a9c-b554-39120e41d9db
# ╠═7f77a89d-e662-4857-aa4c-47d162fc09a0
# ╟─e196666e-3a31-4f64-8ee6-caa9de9b0853
# ╠═d5e77221-31e5-469b-99af-38953626bb77
# ╟─bec12008-cf9e-4768-bccc-b39d83634617
# ╠═a02680a3-5457-4e3d-ba31-54b257e2bd90
# ╠═cd34304a-8cc9-465d-bccc-18a9f5b9c121
# ╠═614c56ac-09a5-4f35-b92f-1d8cabbf6ecb
# ╠═8728a302-43ab-468c-a051-6b0491674a88
# ╠═ffe04f45-008e-4465-aeec-1c5c18f2157e
# ╠═9d0e664d-8758-4b7a-bee7-6d077e70fe1e
# ╠═cf8956ba-61d3-4027-9d49-ad8cbfed97b4
# ╠═e6fbc325-8e4b-4941-8bf8-6975603747ab
# ╠═26f808f5-a6d3-4d87-bcf7-a3479c9ef225
# ╠═ae19c5ea-9767-46ef-9677-7070a2c98346
# ╟─bcc67c53-de8b-462e-b5d3-5825740e1b92
# ╠═7177cb33-9202-4394-a1b2-89255bbdfcd4
# ╠═d1b4d1b1-7d6d-4059-b451-a97d798c4dd6
# ╠═39d7227c-3586-4f62-875f-d72c08aa455a
# ╠═dc8e15fd-f995-4eb8-88e0-21212ebdbc0c
# ╟─8ee31694-4e27-49a2-9570-a586cd998d91
# ╠═8b8671fd-2af1-4b59-beca-1ce8ac51dbc7
# ╠═97d8ea55-d515-4eb2-a907-17cdc9be51d4
# ╟─b12de1c2-bfef-4679-975b-141ad169e11a
# ╠═9ddf31fb-8fed-42f9-9e0d-c0c75f008cee
# ╠═6a0e5893-3135-4883-ba7c-1805fa55ed73
# ╠═421c396e-f71b-4c4c-9a3d-141e8d6cccd3
# ╠═8060aeae-6cbc-4b26-b9f1-29d572b7bab3
# ╠═87e8768c-d562-444d-be5a-176fa08a393d
# ╠═6daaebb1-454b-4908-8ae8-e8fc4c8bcc76
# ╠═3108621b-98a7-4c97-9a33-445b766e04f5
# ╠═ac3533c1-08f4-4dc7-8a21-102d9b5fa3a7
# ╠═8ee3adf2-81ec-4aaf-8dfc-f17f20c7308e
# ╠═96fdc3f7-e75a-4697-b48a-ee7dac5301c8
# ╠═1a6184d4-359f-477a-9e31-1c68fe40ba73
# ╠═3f14629f-e2de-40d5-a661-dc2c819a3e4a
# ╠═53388b16-6443-4aac-b6b6-d23a8e8b7c9d
# ╠═27ce665c-c137-42aa-a331-5345cc9f21de
# ╠═76f49cd8-8116-47c8-b4b6-b52154e08364
# ╟─5f38b665-766a-4032-a26b-036b476790a2
# ╟─af1109e0-47ad-4ab2-8209-27bb8f880bb5
# ╠═50b38ed0-84c2-4dac-b2ec-9f21e6ae1333
# ╠═aacaabd9-0614-4799-887c-9b122c6c8519
# ╠═f5af7525-2be7-48a5-b938-c2344b6f2bff
# ╠═b988b6bb-f3a2-4a10-b4d8-b437a74779f9
# ╠═2a76cc50-c918-45b8-ab64-8d03228f113e
# ╠═7a1d9398-453b-4616-97c2-c6e463f78b25
# ╠═89e4b01a-1ad7-486a-994c-f53061de9f04
# ╠═17aaf21c-d037-45a9-bbbf-63218db57adf
# ╠═454a1c03-7353-4909-b244-13ffd61fd9ea
# ╠═17180638-2950-4f62-801a-b6eeedda28ef
# ╟─5e347078-c971-424d-8466-0b7a8162661c
# ╟─a43f0bce-8507-4b33-9862-f11999071a59
# ╟─41e8c05a-fd5e-4d94-a14c-ed60b6570d59
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
