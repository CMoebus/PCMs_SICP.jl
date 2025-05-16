### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ ecc2589d-889f-410a-9f1b-432482e62945
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

# ╔═╡ d04d7df0-04f9-11ec-36dc-8b535428902a
md"
=====================================================================================
#### SICP: [2.2.2 Hierarchical Structures](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-15.html#%_sec_2.2.2)

###### file: PCM20210824\_SICP\_2.2.2\_HierarchicalStructures.jl

###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/05/15 ***
=====================================================================================
"

# ╔═╡ 15124342-34b6-483b-b929-1ba1ed12388f
md"
---
##### 0. Introduction
*The representation of sequences in terms of lists generalizes naturally to represent sequences whose elements may themselves be sequences.*(SICP, 1996, 2016)

First, we implement *hierarchical structures* like in Scheme as *nested lists*. But different from 2.2.1 the lists are *not* grounded in $NamedTuple$s. Instead they are implemented as *box-and-pointer* structures by Julia's $struct\ Cons$.

Then, we do the same by *nesting* Julia's $Vector$. For both implementation strategies we supply the usual *list* functions $list, length, append, pp, ...$

"

# ╔═╡ e7a974fb-0d53-44ce-ad04-d4caf2cae09d
md"
---
##### 1. Topics

- *type* $Union$
- data type *constructor* $struct$
- *name* of dataype $Cons$
- *types* $Symbol, Atom, Vector,...$
- *mapping* by $map...$, $map...do...$
"

# ╔═╡ b71c8e74-8cae-4cf1-a71e-de7e338b8d3c
md"
---
##### 2. Libraries, Types, Aliases, and Service Functions
##### 2.1 Libraries
"

# ╔═╡ b36e1e82-a472-4597-9608-c8dd7d95cff2
md"
---
##### 2.2 *Self-defined* Types
"

# ╔═╡ 4579401d-32ea-47a1-9f6a-c6af3b4a73ba
md"
###### *Declaration* of Scheme-like type $Atom$ as an $Union$-type
"

# ╔═╡ 79217d66-5068-4211-a848-b3a8eb5d7719
Atom = Union{Number, Symbol, Char, String}               # similar to Scheme-Atom

# ╔═╡ 0db7d233-284a-45ba-9957-baed4ed6a388
TupleOrAtom = Union{Tuple, Atom}

# ╔═╡ 5b293e22-4105-4ef7-9a4e-a6d99ed79a7b
VectorOrAtom = Union{Vector, Atom}

# ╔═╡ 6b82f579-7f9b-41fe-a8ac-fc205d496e22
md"
---
##### 2.3 Service Functions
"

# ╔═╡ 7ad4c19a-515d-4280-bf46-b6c1814ef3b4
md"
---
###### 2.3.1 *1st* Method of Function $ppBoxPointerStructureAsFlatList$ (*alias* $pp$)
This method pretty-prints a *latent flat* box-and-pointer structure implemented as $NamedTuple$ as a *manifest simple* $Tuple$.

This function will *not* be used in 2.2.2.
"

# ╔═╡ 4b8e1599-eccd-4831-a864-c5e5dadd63fa
md"
---
###### *1st* Method of Function $ppConsStructureAsArrayList$ (*alias* $pp$)
This method pretty-prints a *latent hierarchical* $Cons$-structure as a *manifest* structure of type nested $Array$.
"

# ╔═╡ 51a6edd1-2f09-42ba-97b1-d4d6e35ab43a
md"
---
##### 2.4 Aliases
"

# ╔═╡ 5c74f030-ab29-4f08-b1d5-cd85221d051f
md"
---
##### 3. SICP-Scheme-like *functional* Julia
"

# ╔═╡ dd0551fe-def3-443a-b3a6-44fa40d6052c
md"
---
##### 3.1 *DataType* $Cons$ with *Fields* $car, cdr$
"

# ╔═╡ fa966866-52a9-4cda-a0c8-904a75f7e6d3
md"
---
###### 3.1.1 Declaration of data type $Cons$ with $struct$
*The most commonly used kind of type in Julia is a [$struct$](https://docs.julialang.org/en/v1/base/base/#struct), specified as a name and a set of fields.* ([Julia doc](https://docs.julialang.org/en/v1/base/base/#struct)).

"

# ╔═╡ 5d822320-3148-49f7-98e2-b631a21bbf90
struct Cons
	car
	cdr
end

# ╔═╡ 61dc50d8-758a-4191-b26f-bac7b8db8ac3
ConsOrAtom  = Union{Cons, Atom}

# ╔═╡ 4094bdf5-44fb-4d86-8e35-3775f3e3b7e3
typeof(Cons)

# ╔═╡ de2a9fbf-3a35-40af-9d37-f1ffea264970
subtypes(Cons)

# ╔═╡ ca4ffb2a-7daf-463d-ab7a-379308b448c9
supertype(Cons)

# ╔═╡ dc887cc3-e2b4-4bc6-b781-844dd43d8781
md"
---
###### 3.1.2 *1st* Method of *Constructor* $cons$  
"

# ╔═╡ b02c31ac-9e45-492e-97fe-41601b602723
# idiomatic Julia with 1st (default) method of cons
cons(car::Any, cdr::Any)::Cons = Cons(car, cdr)::Cons   

# ╔═╡ c690eb5d-b921-4373-a3f4-34a0580554f6
md"
---
###### 3.1.3 *1st* Method of *Selector* $car$
"

# ╔═╡ ca05de56-fb03-4cf2-86ec-f749028c7309
# 1st method for car
car(consCell::Cons) = consCell.car

# ╔═╡ 6ae69d96-8097-42ba-8e73-be9bc4015332
md"
---
###### 3.1.4 *1st* Method of *Selector* $cdr$
"

# ╔═╡ 1fb40b33-47b7-4c26-ab58-1df36bbee490
cdr(consCell::Cons)::Any = consCell.cdr

# ╔═╡ 365e26e1-55fe-4633-a9c7-cb23759af772
md"
---
##### 3.2 *Type* $Atom$ and its *Comparisons*

"

# ╔═╡ 2a1c5fbb-aa49-4f21-b638-d5852d2f3172
Atom <: Cons                         # ==> false -->  :)

# ╔═╡ bc7e1c04-5f2c-4cb0-b28d-e21ee486a772
Cons <: Atom                         # ==> false -->  :)

# ╔═╡ f4992192-d11f-4637-ae9f-dba7ae946ba8
typeof(:nil) <: Symbol <: Atom

# ╔═╡ 08c26d41-cf4b-4094-84e0-efea7882cac7
typeof(:nil) <: Cons                 # ==> false -->  :)

# ╔═╡ 86579050-bc57-45cf-965f-affabc23c6e0
md"
---
##### 3.3 *SICP*-content in Julia
---
##### 3.3.1 *Sequences* or *Flat Lists*
SICP figures 2.2 and 2.3 only display *dotted pairs* or *box-pointer structures* which are because of *lacking* end cells with a special *mark* $:nil$ *not* identical to lists. Here we modify these *box-pointer structures* by introducing a *end* cell consisting of a $cons$-*cell* with a $:nil$-*atom* in the second field. These structures are equivalent to *lists* as we know from *Scheme*.

"

# ╔═╡ 8c38accf-8ca7-418e-aadb-f4c7aacc4eb4
md"""
---
                             +-----+-----+      +-----+-----+
                   l1 ------>|  o  |  o->|----->|  o  |  /  |
                             +--|--+-----+      +--|--+-----+
                                |                  | 
                                v                  v
                            +-------+          +-------+
                            | :one  |          | "two" |
                            +-------+          +-------+

**Fig. 2.2.2.1** *Latent* Box- and Pointer Structure of *list* $l1 = cons(:one, cons(\text{"two"}, :nil))$ (c.f. Fig. 2.2, SICP, 1996, 2016)

"""

# ╔═╡ a5d360c8-81e4-467e-bb20-21b71ba7431b
typeof(Cons) <: DataType

# ╔═╡ 86bf6099-373f-4427-94ba-ba3f14bfea50
typeof(Cons) == DataType

# ╔═╡ 6388d4e9-38a1-4f00-bbf0-e1a903083460
md"""
---


               l1 ----->o----->o----->:nil         l1 ----->o
                        |      |                           / \
                        v      v                          /   \  
                      :one   "two"                       /     o
                                                        /     / \
                                                       /     /   \
                                                      v     v     v
                                                    :one  "two"  :nil

**Fig. 2.2.2.2** *Latent abstract* Binary Directed Tree of *list* $l1 = cons(:one, cons(\text{"two"}, :nil))$ (c.f. Fig. 2.2, SICP, 1996, 2016)

"""

# ╔═╡ 538d762c-ae92-4f1f-b5c7-41c541dc626d
md"
---
                             +-----+-----+      +-----+-----+
                   l2 ------>|  o  |  o->|----->|  o  |  /  |
                             +--|--+-----+      +--|--+-----+
                                |                  | 
                                v                  v
                            +-------+          +-------+
                            |   3   |          |  4.0  |
                            +-------+          +-------+

**Fig. 2.2.2.3** *Latent* Box- and Pointer Structure of *list* $l2 = cons(3, cons(4.0, :nil))$ (c.f. Fig. 2.2, SICP, 1996, 2016)

"

# ╔═╡ d3d2ae26-c985-4856-bbb8-983d09b594ee
md"
---


               l2 ----->o----->o----->:nil         l2 ----->o
                        |      |                           / \
                        v      v                          /   \  
                        3     4.0                        /     o
                                                        /     / \
                                                       /     /   \
                                                      v     v     v
                                                      3    4.0   :nil

**Fig. 2.2.2.4** *Latent abstract* Binary Directed Trees of *list* $l2 = cons(3, cons(4.0, :nil))$

"

# ╔═╡ 87ddfa5a-8648-4719-a40d-ee4d0894de8e
md"
---
###### *List Constructor* $listElementsToConsStructure$ (*alias* $list$)
"

# ╔═╡ 10bc180b-55cb-477e-b437-678ab3156b75
typeof(:nil) <: Atom

# ╔═╡ a52df543-ddad-49c3-a6bb-0bbcf32575f4
md"
---
###### *1st* Method of $listLength$ (*alias* $length$)
"

# ╔═╡ 4bc61cf4-fdae-4746-8b2e-98a1b1f53307
md"
---
##### 3.3.2 *Hierarchical* (Box- and Pointer) *Structures* (= *Nested Lists*)
"

# ╔═╡ 1cfbab4a-c1a8-49e9-bcc4-79ee773ead30
md"""
---
                  +-----+-----+
    binaryTree1-->|  o  |  o->|-------------------------->+
                  +--|--+-----+                           |
                     |                                    v
                     |                              +-----+-----+      +-----+-----+ 
                     |                    l2 ------>|  o  |  o->|----->|  o  |  /  |
                     |                              +--|--+-----+      +--|--+-----+ 
                     |                                 |                  | 
                     v                                 v                  v
               +-----+-----+      +-----+-----+     +-----+            +-----+
     l1 ------>|  o  |  o->|----->|  o  |  /  |     |  3  |            | 4.0 |
               +--|--+-----+      +--|--+-----+     +-----+            +-----+ 
                  |                  | 
                  v                  v
              +-------+          +-------+
              | :one  |          | "two" |
              +-------+          +-------+

**Fig. 2.2.2.5** *Box- & Pointer*-structure of a *nested list* generated by $cons(l1, l2)$ (c.f. Fig 2.5, SICP, 1996, 2016)

"""

# ╔═╡ 6d4eb0e4-1392-4ffa-a8c4-ec2f3d0d1b1b
md"
---
###### 3.3.2.1 Application of *List*-Functions
"

# ╔═╡ 0119977a-57e9-47a2-9c1b-48ddd4d62f90
md"""
---

                             l2
                              |
                              v
       binaryTree1 ---->o---->o---->o--->:nil     binaryTree1 ----->o
                        |     |     |                              / \       
                        |     v     v                             /   \
                        |     3    4.0                           /     \    l2
                        v                                       /       \   /
               l1 ----->o---->o---->:nil                       /         \ /
                        |     |                               v           v
                        |     |                       l1 ---->o           o
                        v     v                              / \         / \
                      :one  "two"                           /   \       /   \
                                                           v     v     v     v
                                                        :one     o     3     o
                                                                / \         / \
                                                               /   \       /   \
                                                              v     v     v     v
                                                            "two"  :nil  4.0   :nil

                    pp(l1) ==> (:one, "two")
                    pp(l2) ==> (3, 4.0)
           pp(binaryTree1) ==> ((one, "two"), 3, 4.0)
   
          
**Fig. 2.2.2.6**: Graphical respresentations of *latent* binary tree (equivalent of a *nested list*) implemented with *structs* and generated by $binaryTree1 = cons(l1, l2)$ (c.f. Fig 2.6, SICP, 1996)

"""

# ╔═╡ fbfcb81f-1741-4904-9b8e-c7890be30d71
md"
ASS (= Abelson, Sussman & Sussman) replace $nil$ by $'()$ (cf. SICP, 1996, p.101. So $'()$'s meaning is the empty list. 
Similarly we mark the 'end-of-list' in the *storage* structure ($Cons$*-structure*) as '*:nil*' and in its *manifestation* (*print*-list) as $()$.
"

# ╔═╡ be2f75ca-2934-49de-a982-9858bbf2c10e
md"
---
###### *1st* Method of $countLeavesOfNestedList$ (*alias* $countLeaves$)
"

# ╔═╡ 887c2e8d-08fc-4dce-9e1f-0938dea1623b
md"
---
###### 3.3.2.2 *Mapping* over Trees
---
###### *1st* Method of $scaleTree$

"

# ╔═╡ 5e287813-4d57-48ad-a3e4-20247476512c
md"
---
##### 4. Idiomatic *imperative* or *typed* Julia
"

# ╔═╡ 6f38cfce-c626-4f9c-8ce9-417965ea5372
md"
---
##### 4.1 *Constructor* and *Selectors*
"

# ╔═╡ 2e9de7fd-b00e-4ce1-ba68-d647497e57fe
md"
---
###### *2nd* Method of Scheme-like *Constructor* $cons$ using Julia's $Array$
"

# ╔═╡ f7dabac5-0421-4581-8d87-00ce9d8eeeb1
md"
Now, *this* $cons$ constructs an array. This *cannot* be pretty-printed by $pp$

"

# ╔═╡ 41aef6dd-e5bd-44a7-9878-696a1a97e452
# idiomatic Julia with 2nd method of cons
function cons(car::VectorOrAtom, vector::Vector)::Vector
	pushfirst!(vector, car)
end

# ╔═╡ 991b1ce6-a5ef-43ed-8999-32811fdbc344
md"
---
###### *2nd* Method of Scheme-like *Selector* $car$ using Julia's $Array$
"

# ╔═╡ ec154684-ff2b-473c-8ffe-c40d03631091
# 2nd method for car
car(xs::Vector) = xs[1]

# ╔═╡ 49c58521-2ca3-48ad-b3d3-ff6b66efad83
md"
---
###### *2nd* Method of Scheme-like *Selector* $cdr$ using $Array$
"

# ╔═╡ 3444dab8-dd66-4bc3-bfb0-269ecd2f714a
cdr(xs::Vector) = xs[2:end]

# ╔═╡ c219beca-688b-4642-be6d-adefc1448e44
#------------------------------------------------------------------------------------
# this method pretty-prints a latent hierarchical cons-structure as a nested 
#    tuple structure which has similarity with a Lisp- or Scheme-list
# also used in 3.3.1 and 3.3.2.1
#------------------------------------------------------------------------------------
function ppConsStructureAsTuple(consStruct::ConsOrAtom)::TupleOrAtom
	#--------------------------------------------------------------------------------
	function ppIter(consStruct, arrayList)
		#----------------------------------------------------------------------------
		if consStruct == :nil                               # termination case 1 
			Tuple([])
		elseif typeof(consStruct) <: Atom                   # termination case_2 
			consStruct
		#----------------------------------------------------------------------------
		# one-element list                                  # termination case_3 
		elseif (typeof(car(consStruct)) <: Atom) && (cdr(consStruct) == :nil)
			Tuple(push!(arrayList, ppConsStructureAsTuple(car(consStruct))))
		#----------------------------------------------------------------------------
		# flat multi-element list
		elseif (car(consStruct) == :nil) && (typeof(cdr(consStruct)) <: Cons)
			ppIter(cdr(consStruct), push!(arrayList, ()))
		elseif (typeof(car(consStruct)) <: Atom) && (typeof(cdr(consStruct)) <: Cons)
			ppIter(cdr(consStruct), push!(arrayList, car(consStruct)))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
			elseif (typeof(car(consStruct)) <: Cons) && (cdr(consStruct) == :nil)
				Tuple(push!(arrayList, ppConsStructureAsTuple(car(consStruct))))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
		elseif (typeof(car(consStruct)) <: Cons) && (typeof(cdr(consStruct)) <: Cons)
			ppIter(cdr(consStruct), push!(arrayList, ppConsStructureAsTuple(car(consStruct))))
		#----------------------------------------------------------------------------
		else
			error("==> unknown case for: $consStruct")
		end # if
	end # ppIter
	#--------------------------------------------------------------------------------
	ppIter(consStruct, [])      
end # function ppConsStructureAsTuple
#------------------------------------------------------------------------------------

# ╔═╡ 5d4bf8f1-8b3c-41f3-ab41-711d56a30be3
function listLength(cons::Cons)::Int
	if (car(cons) == :nil) && (cdr(cons) == :nil)
		0
	elseif !(car(cons) == :nil) && (cdr(cons) == :nil)
		1
	else 
		1 + listLength(cdr(cons))
	end # if
end # function listLength

# ╔═╡ e5689ef0-53de-4027-803e-778e762771e6
function countLeavesOfNestedList(list::ConsOrAtom)::Int
	#----------------------------------------------------------------
	isEmpty(list) = 
		list == () || list == :nil
	#----------------------------------------------------------------
	if isEmpty(list)
		0
	elseif isEmpty(car(list))
		countLeavesOfNestedList(cdr(list))
	elseif typeof(car(list)) <: Atom
		1 + countLeavesOfNestedList(cdr(list))
	else
		countLeavesOfNestedList(car(list)) + countLeavesOfNestedList(cdr(list))
	end # if
end # function countLeavesOfNestedList

# ╔═╡ a0c8c208-a947-4120-a84b-3c60fd5d9c40
md"
---
##### 4.2 *Hierarchical* Structures
"

# ╔═╡ 31cd0a63-70f5-425d-bd2e-df9243a3198a
md"""
---

                             l4
                              |
                              |
       binaryTree 2---->o---->o---->o--->[]       binaryTree2 ----->o
                        |     |     |                              / \       
                        |     |     |                             /   \
                        |     3    4.0                           /     \    l4
                        |                                       /       \   /
               l3 ----->o---->o---->[]                         /         \ /
                        |     |                       l3 ---->o           o
                        |     |                              / \         / \
                      :one  "two"                           /   \       /   \
                                                        :one     o     3     o
                                                                / \         / \
                                                               /   \       /   \
                                                            "two"  []    4.0   []

                    Tuple(l3) := (:one, "two")
                    Tuple(l4) := (3, 4.0)
           Tuple(binaryTree2) := ((one, "two"), 3, 4.0)
   
          
**Fig. 2.2.2.7** (s.a. SICP, 1996, Fig 2.6) Graphical respresentations of *latent* binary tree implemented with *arrays* and generated by 'binaryTree2 = cons(l3, l4)' and *manifest* list structures of binary trees

---
"""

# ╔═╡ 541eecaa-26aa-4a31-906b-c177065e3f21
md"
---
###### *1st* Method of *Constructor* $listElementsAsVector$ (*alias* $listAsVector$)
"

# ╔═╡ d158f290-f890-422b-b978-c92cdfeb358f
listElementsAsVector(xs::Any...)::Vector = 
	[xs::Any...]::Vector  # slurping and spitting

# ╔═╡ 72cfcaa3-a5b1-484a-9829-d2bd3024f90b
md"
---
###### *3rd* Method of *Constructor* $cons$
"

# ╔═╡ caebe503-a0a2-4782-aea3-7456ac3ea1a6
# idiomatic Julia with 3rd method of cons
function cons(list1::Vector, list2::Vector)::Vector
	list1 = push!([], list1)
	append!(list1, list2)
end

# ╔═╡ 240749a9-559e-4567-ba29-379dbc8ae52a
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
function ppBoxPointerStructureAsFlatTuple(consList::NamedTuple)::Tuple  
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
end # function ppBoxPointerStructureAsFlatTuple

# ╔═╡ 786c0bd8-932f-46a3-9cd3-11a626f523fc
l1 = cons(:one, cons("two", :nil))

# ╔═╡ b668cc81-d500-42e3-9ca4-a957a8df118e
typeof(l1)

# ╔═╡ 1b9205c4-eb62-436d-906d-7850b0a82c63
typeof(l1) <: ConsOrAtom

# ╔═╡ 715f429d-7656-4014-aebf-974ed05f0cc1
car(l1)

# ╔═╡ a5ef6c4b-b6c5-4ad8-ac43-ea4a204deadd
cdr(l1)                                         # ==> Cons("two", :nil) -->   :)

# ╔═╡ d046b762-098f-4c26-b57b-6f4ee7497032
car(cdr(l1))                                    # ==> "two"  -->  :)

# ╔═╡ 4daee6d9-39e2-4d9c-915e-3787c8eb1bbc
cdr(l1)

# ╔═╡ f5a5cb9b-5148-43e3-aea2-9e62a23ca471
l2 = cons(3, cons(4.0, :nil))   # ==> Cons(3, Cons(4.0, :nil))

# ╔═╡ 286754b5-505d-43a4-99b9-aa57f789dea4
car(l2)

# ╔═╡ a3571fdb-fa31-4db6-b6f3-c71d7f2e94e0
cdr(l2)                          # ==> Cons(4.0, :nil)

# ╔═╡ 88ee71e8-4b91-4a27-ab79-7dd6fbe49aa7
car(cdr(l2))

# ╔═╡ bc81d8ad-7477-48fd-8a89-a673f815562e
l1, l2                                          # arguments are left intact !

# ╔═╡ 682249be-d6ea-4f86-9c52-d3931b7cb613
function listElementsToConsStructure(elements...)::Cons 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], listElementsToConsStructure(elements[2:end]...))
	end #if
end # function listElementsToConsStructure

# ╔═╡ cc9478f7-5e21-4c2f-9569-56215f5f2565
# works with 1st method of cons
binaryTree1 = cons(l1, l2)                      # c.f. SICP, Fig. 2.5

# ╔═╡ 882e4324-afd3-42a2-90a0-58da4a21fad9
binaryTree1      # ==> Cons(Cons(:one, Cons("two", :nil)), Cons(3, Cons(4.0, :nil)))

# ╔═╡ ad0ac826-330d-43bd-b86f-7a13d591057e
car(binaryTree1)                                # ==> Cons(:one, Cons("two", :nil))

# ╔═╡ 73c07fcb-5aa3-45b7-abd1-50e2af4b095c
cdr(binaryTree1)                                # ==> Cons(3, Cons(4.0, :nil))

# ╔═╡ d9a102a8-99cb-42d4-b7f6-7b04b2eddd70
car(car(binaryTree1))                           # ==> :one -->:

# ╔═╡ 0df51397-7df5-49a8-9fb1-c686a548546e
car(cdr(car(binaryTree1)))                      # ==> "two"

# ╔═╡ 5e271af9-a6d5-4366-a8be-d29615a56990
car(cdr(binaryTree1))                           # ==> 3 -->  :)

# ╔═╡ 21eab018-1d2b-405c-bb13-aac7d61f0586
car(cdr(cdr(binaryTree1)))                      # ==> 4.0 -->

# ╔═╡ 30e97964-4c4a-430a-afe5-46e6a387fd1f
function scaleTree(tree::ConsOrAtom, factor)::ConsOrAtom
	#----------------------------------------------------
	null(x) = x == :nil
	isnumber(x::Any) = typeof(x) <: Number
	isvector(x::Any) = typeof(x) == Vector{Any}
	#----------------------------------------------------
	if null(tree)
		:nil
	elseif isnumber(car(tree))
		cons(factor * car(tree), scaleTree(cdr(tree), factor))
	else 
		cons(scaleTree(car(tree), factor), scaleTree(cdr(tree), factor))
	end
end # function scaleTree

# ╔═╡ a33ffcf7-7e38-49c9-83b7-64b1794d8bf8
l3 = cons(:one, cons("two", []))

# ╔═╡ 86891f4e-b52c-4389-9f2a-76e5481bcc9c
typeof(l3)

# ╔═╡ e5041f5d-afd4-4760-852e-e57fa3e9263a
l3

# ╔═╡ 1265e29f-5935-4d42-945c-39055ab96870
l4 = cons(3, cons(4.0, []))

# ╔═╡ 87c89cef-bb05-47d6-807d-a8a0b56b72b4
binaryTree3 = cons(l3, cons(l4, []))

# ╔═╡ d5804b42-9925-42eb-86ec-25503f56bcc6
md"
---
###### *1st* Method of $vectorLength$ (*alias* $length$)
"

# ╔═╡ ca3ec019-de3d-4cee-8e77-556bb0a6a7e9
function vectorLength(vector::Vector)::Int
	if (car(vector) == []) && (cdr(vector) == [])
		0
	elseif !(car(vector) == []) && (cdr(vector) == [])
		1
	else 
		1 + vectorLength(cdr(vector))
	end # if
end # function listLength

# ╔═╡ ce44c3fc-0496-465f-a9c1-2503018c0fa8
md"
---
###### *1st* Method of $countLeavesOfNestedVector$ (*alias* $countLeaves$)
"

# ╔═╡ 7f3a6426-e72d-4ae9-a3e9-79c437116391
function countLeavesOfNestedVector(vector::VectorOrAtom)::Int
	#----------------------------------------------------------------
	isEmpty(vector) = 
		vector == []
	#----------------------------------------------------------------
	if isEmpty(vector)
		0
	elseif isEmpty(car(vector))
		countLeavesOfNestedVector(cdr(vector))
	elseif typeof(car(vector)) <: Atom
		1 + countLeavesOfNestedVector(cdr(vector))
	else
		countLeavesOfNestedVector(car(vector)) + countLeavesOfNestedVector(cdr(vector))
	end # if
end # function countLeavesOfNestedVector

# ╔═╡ 45153ccb-497a-4aa7-a0a2-e13af8aefcad
begin
	countLeaves(list::ConsOrAtom)::Int =
		countLeavesOfNestedList(
			list::ConsOrAtom)::Int
	countLeaves(vector::VectorOrAtom)::Int =
		countLeavesOfNestedVector(
			vector::VectorOrAtom)::Int
	length(list::Cons)::Int = 
		listLength(list::Cons)::Int
	length(vector::Vector)::Int =
		vectorLength(vector::Vector)::Int
	list(elements...)::Cons =
		listElementsToConsStructure(elements...)::Cons
	listAsVector(xs::Any...)::Vector =
		listElementsAsVector(
			xs::Any...)::Vector
	pp(consList::NamedTuple)::Tuple  =	
		ppBoxPointerStructureAsFlatTuple(
			consList::NamedTuple)::Tuple	
	pp(consStruct::ConsOrAtom)::TupleOrAtom = 			
		ppConsStructureAsTuple(
			consStruct::ConsOrAtom)::TupleOrAtom
	pp(consStruct::Vector)::TupleOrAtom = 			
		ppVectorAsTuple(
			consStruct::Vector)::TupleOrAtom
end # begin

# ╔═╡ 25355519-8622-47f1-941a-9f81fdaaf8db
function ppVectorAsTuple(oldVector::Vector)::TupleOrAtom
	#--------------------------------------------------------------------------------
	function ppIter(oldVector::Vector, newVector::Vector)::TupleOrAtom
		#----------------------------------------------------------------------------
		if oldVector == []                                  # termination case 1 
			Tuple([])
		elseif typeof(oldVector) <: Atom                    # termination case_2 
			oldVector
		#----------------------------------------------------------------------------
		# one-element vector                                # termination case_3 
		elseif (typeof(car(oldVector)) <: Atom) && (cdr(oldVector) == [])
			Tuple(push!(newVector, pp(car(oldVector))))
		#----------------------------------------------------------------------------
		# flat multi-element vector
		elseif (car(oldVector) == []) && (typeof(cdr(oldVector)) <: Vector)
			ppIter(cdr(oldVector), push!(newVector, []))
		elseif (typeof(car(oldVector)) <: Atom) && (typeof(cdr(oldVector)) <: Vector)
			ppIter(cdr(oldVector), push!(newVector, car(oldVector)))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
			elseif (typeof(car(oldVector)) <: Vector) && (cdr(oldVector) == [])
				Tuple(push!(newVector, pp(car(oldVector))))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
		elseif (typeof(car(oldVector)) <: Vector) && (typeof(cdr(oldVector)) <: Vector)
			ppIter(cdr(oldVector), push!(newVector, pp(car(oldVector))))
		#----------------------------------------------------------------------------
		else
			error("==> unknown case for: $oldVector")
		end # if
	end # ppIter
	#--------------------------------------------------------------------------------
	ppIter(oldVector, [])      
end # function ppVectorAsTuple
#------------------------------------------------------------------------------------

# ╔═╡ 97b87ad4-f74c-483f-8777-690ebd82bdef
pp(l1)                                 # ==> (:one, "two") -->  :)

# ╔═╡ c6cb1f95-404a-4192-8be2-b1e94c2759c4
typeof(pp(l1))

# ╔═╡ 3c7a64b9-4a73-4144-8bf4-c88aac838e54
typeof(pp(l1)) <: TupleOrAtom

# ╔═╡ 76ca37f6-71ba-4320-aa19-1e73f53bb65d
pp(cdr(l1))                                     # ==> ("two") -->  :)

# ╔═╡ 2e6f007b-b747-412d-b16b-e8808183e5fc
pp(car(cdr(l1)))                                # ==> "two"  -->  :)

# ╔═╡ 8550486d-a796-46d3-a8fd-07e0a7f294bd
pp(l2)                          # ==> (3, 4.0) -->  :)

# ╔═╡ b9a5c6e4-7f67-42e4-9380-6d999a3df17d
pp(cdr(l2))                      # ==> Cons(4.0, :nil) ==> (4.0) -->  :)

# ╔═╡ 5f36dae2-253b-4d86-97d6-2acde397e463
pp(:nil)                              # ==> () -->  :)

# ╔═╡ be1f7a7f-618b-4525-b796-78a5d1d1e54a
pp(cons(:nil, :nil))                  # ==> (()) -->  :)

# ╔═╡ 7d470294-9c69-4ab8-82da-e8a2a7c5b576
list(())                              # ==> Cons((), :nil)

# ╔═╡ 604cd972-cac5-4f2d-a98e-bb7c858f05f9
typeof(list(()))

# ╔═╡ 171ab6fa-048e-4330-a506-045f1523dc8a
pp(list())                            # ==> Cons((), :nil) ==> (()) -->  :)

# ╔═╡ 803803c4-b675-4003-af82-bd017318bf81
list(:one)                            # ==> Cons(:one, :nil) -->  :)

# ╔═╡ 18fa2ee8-8fd3-498c-bf72-4cae930fb4cf
pp(Cons(:one, :nil))                  # ==>  (:one)

# ╔═╡ d1af268e-309d-49ba-a9f7-170f7be73669
pp(list(:one))                        # ==> Cons(:one, :nil) ==> (:one)  -->    :) 

# ╔═╡ fd74dd1e-c197-444f-9d3a-796426884648
list(:one, "two")                     # ==> Cons(:one, Cons("two", :nil))

# ╔═╡ f9570f49-7923-469e-925c-9ed0f33bc163
pp(list(:one, "two"))                 # ==> (:one, "two") -->  :)

# ╔═╡ 539afad3-cc60-4dde-a5d7-e1c32580182a
length(cons(:nil, :nil))

# ╔═╡ 8ffc46f5-e9a1-43d0-be9a-79dd7dad2361
length(cons("two", :nil))

# ╔═╡ ee6478c8-3639-4530-a025-e4177f98c202
length(l1)

# ╔═╡ 3925c180-8a08-4dd2-b315-e3f9f8d2b7e1
length(cdr(l1))

# ╔═╡ ad034edc-d673-40a0-82e7-35803a5ecffe
pp(binaryTree1)                                 # ==> ((:one, "two"), 3, 4.0)

# ╔═╡ 1ce376af-a0c2-400f-a655-41ae0bdab251
pp(car(binaryTree1))                            # ==> (:one, "two") -->  :)

# ╔═╡ 746146a0-10f1-44f1-a73b-92c62fe574b2
pp(cdr(binaryTree1))                            # ==> (3, 4.0) -->  :)

# ╔═╡ 2293586c-3aa4-4fc1-9bf8-00467a396ccd
length(binaryTree1)

# ╔═╡ fcaf4ffc-ab66-4052-bc07-cb0cf7379f0a
binaryTree2 = cons(list(:one, "two"), list(3, 4.0))  #  SICP, 1996, p. 108

# ╔═╡ a8db6a56-0a67-434d-bc42-4ce0db57f2a2
binaryTree1 == binaryTree2             # binaryTree1 and binaryTree2 are equal 

# ╔═╡ 36bb0117-9634-4147-8ff6-1ba5dee2f9f9
binaryTree1 === binaryTree2            # binaryTree1 and binaryTree2 are identical

# ╔═╡ c9300481-e4be-4827-8f73-ac9a8fe406b5
binaryTree2

# ╔═╡ de53597d-c61a-4d4c-9b16-45c5a08a98db
x = binaryTree2

# ╔═╡ 638ba491-dd79-43e2-a6de-46382d99e77f
pp(binaryTree2 )                       # ==> ((:one, "two"), 3, 4.0)

# ╔═╡ b99a3642-466f-439e-928b-257a525a9e2b
length(binaryTree2)

# ╔═╡ 5758cda8-317f-41f7-87fc-bf53998d4fc6
list(list(:one, "two"))               # ==> Cons(Cons(:one, Cons("two", :nil)), :nil)

# ╔═╡ 2ab796bc-449d-4386-aaf2-20615bf1281e
# ==> Cons(Cons(:one, Cons("two", :nil)), Cons(3, Cons(4.0, :nil)))  
#      --> equivalent to binaryTree1
list(list(:one, "two"), 3, 4.0) 

# ╔═╡ ffbed260-a5e3-4906-85db-f6debea5b00d
pp(list(list(:one, "two"), 3, 4.0))    # ==> ((:one, "two"), 3, 4.0) -->  :)

# ╔═╡ ea483827-a735-4cfa-85fd-75cf2fe910f4
pp(list(list(:one, "two")))            # ==> ((:one, "two")) -->  :)

# ╔═╡ 7e4dad09-01ef-4bc6-8bdb-507ab580a2e7
pp(list(list(list(:one, "two")), 3, 4.0)) 
                                       # ==> (((:one, "two")), 3, 4.0) --> :)

# ╔═╡ 60f45d12-55d9-4e07-b841-8e68f010428a
list(list(list(:one, "two")), list(list(3), 4.0))

# ╔═╡ ef0f3822-5ec3-4d54-a518-7100a2820d87
pp(list(list(list(:one, "two")), list(list(3), 4.0)))

# ╔═╡ 0f45f9a6-6877-42fc-83e2-377d1758d401
pp(binaryTree2)

# ╔═╡ 8830c7df-e37c-4f81-879d-3ded6267e266
list(binaryTree2, binaryTree2)

# ╔═╡ f7797441-d376-4a56-b837-a488c3742ea5
list(list(x, x), list(x, x))

# ╔═╡ 3e662ba4-b303-4093-9d15-999140ff0d18
pp(list(list(x, x), list(x, x)))

# ╔═╡ dd325dc8-884b-4c0f-9d55-45aa2cbf3a87
listLength(list(x, x))

# ╔═╡ b3897a4b-cd3a-421b-8a53-01e9aec6b8b9
countLeaves(Cons((), :nil))

# ╔═╡ 23994cc6-0e65-4093-856b-be3ac3ede4de
countLeaves(list((:a)))

# ╔═╡ 1e4b5fdc-1959-45fc-8aca-39abfd0ba58b
countLeaves(l1)

# ╔═╡ e35dbec5-abbd-4604-8295-f33ac7e2a186
pp(l3)   

# ╔═╡ e39b2826-e9ee-4f92-aeae-3f4bb6263db0
pp(l4)

# ╔═╡ dadfc45e-0ba6-4890-af4d-868219630c3b
pp(binaryTree3)                                      # nested list

# ╔═╡ 69bce858-176d-4764-a553-1ffe7b26319f
listAsVector()

# ╔═╡ cdd7254a-bae0-489c-82f4-bbc9b93a8ea1
pp(listAsVector())

# ╔═╡ d06e076c-9665-4b7a-b4f3-e26b055bc717
lOne = listAsVector(:one, "two")

# ╔═╡ 0d88594c-6dfc-4e43-85e0-0980834983d0
pp(lOne)

# ╔═╡ 278e1371-d51f-4db0-a39e-12e2be14da40
lTwo = listAsVector(3, 4.0)

# ╔═╡ 02342aa2-29a3-4274-b345-38dc17ab0eef
# works with 3rd method of cons
lThree = cons(lOne, lTwo)                   # c.f. SICP, Fig. 2.6

# ╔═╡ b51610de-dd9e-4ed4-a4a3-6cb769862473
typeof(lThree)

# ╔═╡ a5843028-cfa1-4d42-a2ed-3eb2e337389e
car(lThree)

# ╔═╡ eeb9b7e4-1bd1-4f08-ad33-70b1b05bbaef
car(car(lThree))

# ╔═╡ a59a0629-c827-4bcf-8598-d389f76d546d
car(cdr(car(lThree)))

# ╔═╡ 6b754818-d7e8-4955-9a74-616f32fb98cc
car(cdr(lThree))

# ╔═╡ ae38a6d9-8285-4093-b796-53668427d464
car(cdr(cdr(lThree)))

# ╔═╡ a141433d-227f-4f15-98a5-f3d04e40fe99
pp(lTwo)

# ╔═╡ 481d9d41-2487-4b1d-8752-04fbf1f15766
binaryTree4 = listAsVector(listAsVector(:one, "two"), 3, 4.0) # c.f. SICP, Fig. 2.6

# ╔═╡ 333b5c86-34ed-473c-b30a-f23b0735d2a2
pp(binaryTree4)                     

# ╔═╡ f1a88238-cd46-4c81-927c-80881d9c3ca3
pp(lThree)                               

# ╔═╡ 9f567c95-9bc5-48f7-816f-91061a73eeda
pp(car(lThree))

# ╔═╡ 7437e352-80d0-49ae-b928-b7997e9f877e
pp(car(car(lThree)))

# ╔═╡ a6ac7d8c-4f40-410b-8eaa-b16438f34081
pp(car(cdr(car(lThree))))

# ╔═╡ ec4c39b2-54d7-4659-8c35-f823bfec550e
length(lThree)

# ╔═╡ 00ea7172-d6e6-4202-b3de-ed1f013f9429
lThree

# ╔═╡ 910e7d3f-efa4-4212-a384-010131b27715
countLeaves(lThree)

# ╔═╡ 0387258c-3a71-4f39-bd08-9ee2ce0c425e
listAsVector(lThree, lThree)

# ╔═╡ 952f98c6-eb3d-40a0-b2cc-43b2791a1d14
countLeaves(listAsVector(lThree, lThree))

# ╔═╡ d5f4cf53-02ed-4a5e-ac87-286e02bbfde9
length(listAsVector(lThree, lThree))             

# ╔═╡ fa40277a-ddc9-4538-9746-c6845b67e415
countLeaves(listAsVector(lThree, lThree))

# ╔═╡ 187a562d-9a82-4499-9a8f-d8f7e4ec454c
countLeaves(binaryTree3)

# ╔═╡ 9d12cb69-4bc2-4aff-9166-20b5787d704b
typeof(car([:one])) <: Atom

# ╔═╡ f51af477-c809-4f07-a38f-538ac6b00ec8
md"
---
##### 4.3 *Mapping* over Trees
---
###### *2nd* Method of $scaleTree$

"

# ╔═╡ 1489b23b-aa5c-4812-9914-56db0979fa50
function scaleTree(vector::Vector, factor::Number)
	#---------------------------------------------
	null(vector) = vector == []
	isNumber(x::Any) = typeof(x) <: Number
	isVector(x::Any) = typeof(x) == Vector{Any}
	#---------------------------------------------
	if null(vector)
		vector
	elseif isNumber(car(vector))
		cons(factor * car(vector), scaleTree(cdr(vector), factor))
	else 
		cons(scaleTree(car(vector), factor), scaleTree(cdr(vector), factor))
	end # if
end # function scaleTree

# ╔═╡ c32f258c-1b0d-418f-b682-27566177b152
scaleTree(list(1, list(2, list(3, 4), 5), list(6, 7)), 10)

# ╔═╡ 35e18b20-cc3c-49b2-8de4-60450163a772
pp(scaleTree(list(1, list(2, list(3, 4), 5), list(6, 7)), 10))

# ╔═╡ 3014af89-278f-426c-a4a3-46840dd86e9b
l5 = listAsVector(1, listAsVector(2, listAsVector(3, 4), 5), listAsVector(6, 7))

# ╔═╡ 9f7aeced-191e-4a92-a27b-0d02a321dfc3
scaleTree(l5, 10)

# ╔═╡ 9ffb3d31-1038-4d94-9529-cd25b4b43259
md"
---
###### *1st* Method of $scaleTree3$

"

# ╔═╡ 404a4b60-2cc2-40d5-ada8-9a020bd200a5
function scaleTree3(tree::Vector, factor::Number)
	#---------------------------------------------
	isNumber(x::Any) = typeof(x) <: Number
	isVector(x::Any)  = typeof(x) == Vector{Any}
	#---------------------------------------------
	map(subtree ->
		if isNumber(subtree)
			subtree * factor
		else
			scaleTree3(subtree, factor) 
		end, tree)
end # function scaleTree3

# ╔═╡ ae7f3fcc-886f-4b06-8e20-371b8a0cf5cb
scaleTree3(l5, 10)

# ╔═╡ a2f420a9-6279-4855-85ca-b3489e01ae8f
md"
---
###### *1st* Method of $scaleTree4$

"

# ╔═╡ f84c82c9-d004-497c-9f64-71c9e3f7219d
function scaleTree4(tree::Vector, factor::Number)
	#---------------------------------------------
	isNumber(x::Any) = typeof(x) <: Number
	isVector(x::Any) = typeof(x) == Vector{Any}
	#---------------------------------------------
	map(tree) do subtree
		if isNumber(subtree)
			subtree * factor
		else
			scaleTree4(subtree, factor) 
		end # if
	end # do
end # function scaleTree4

# ╔═╡ 47701d24-b015-452d-9b53-6ef244a27860
scaleTree4(l5, 10)

# ╔═╡ f51e8787-0904-4351-9d2a-bd5cc87cb70d
md"
---
##### 5. Summary

We implemented *hierarchical* data structures and ordinary *list* functions with Julia's $struct$ and $Array$. For efficiency reasons *arrays* should be the preferred method for implementing Scheme *lists*.
"

# ╔═╡ 0802559e-7777-43fb-a2ea-1b21a68bd034
md"
---
##### 6. References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996, last visit 2025/05/14

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://web.mit.edu/6.001/6.037/sicp.pdf), Cambridge, Mass.: MIT Press, (2/e), 2016, last visit 2025/05/14

"

# ╔═╡ 51873a3d-f856-4f7b-8fd6-4270445ac525
md"
---
##### end of ch. 2.2.2
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)**](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─d04d7df0-04f9-11ec-36dc-8b535428902a
# ╟─15124342-34b6-483b-b929-1ba1ed12388f
# ╟─e7a974fb-0d53-44ce-ad04-d4caf2cae09d
# ╟─b71c8e74-8cae-4cf1-a71e-de7e338b8d3c
# ╠═ecc2589d-889f-410a-9f1b-432482e62945
# ╟─b36e1e82-a472-4597-9608-c8dd7d95cff2
# ╟─4579401d-32ea-47a1-9f6a-c6af3b4a73ba
# ╠═79217d66-5068-4211-a848-b3a8eb5d7719
# ╠═61dc50d8-758a-4191-b26f-bac7b8db8ac3
# ╠═0db7d233-284a-45ba-9957-baed4ed6a388
# ╠═5b293e22-4105-4ef7-9a4e-a6d99ed79a7b
# ╟─6b82f579-7f9b-41fe-a8ac-fc205d496e22
# ╟─7ad4c19a-515d-4280-bf46-b6c1814ef3b4
# ╠═240749a9-559e-4567-ba29-379dbc8ae52a
# ╟─4b8e1599-eccd-4831-a864-c5e5dadd63fa
# ╠═c219beca-688b-4642-be6d-adefc1448e44
# ╠═25355519-8622-47f1-941a-9f81fdaaf8db
# ╟─51a6edd1-2f09-42ba-97b1-d4d6e35ab43a
# ╠═45153ccb-497a-4aa7-a0a2-e13af8aefcad
# ╟─5c74f030-ab29-4f08-b1d5-cd85221d051f
# ╟─dd0551fe-def3-443a-b3a6-44fa40d6052c
# ╟─fa966866-52a9-4cda-a0c8-904a75f7e6d3
# ╠═5d822320-3148-49f7-98e2-b631a21bbf90
# ╠═4094bdf5-44fb-4d86-8e35-3775f3e3b7e3
# ╠═de2a9fbf-3a35-40af-9d37-f1ffea264970
# ╠═ca4ffb2a-7daf-463d-ab7a-379308b448c9
# ╟─dc887cc3-e2b4-4bc6-b781-844dd43d8781
# ╠═b02c31ac-9e45-492e-97fe-41601b602723
# ╟─c690eb5d-b921-4373-a3f4-34a0580554f6
# ╠═ca05de56-fb03-4cf2-86ec-f749028c7309
# ╟─6ae69d96-8097-42ba-8e73-be9bc4015332
# ╠═1fb40b33-47b7-4c26-ab58-1df36bbee490
# ╟─365e26e1-55fe-4633-a9c7-cb23759af772
# ╠═2a1c5fbb-aa49-4f21-b638-d5852d2f3172
# ╠═bc7e1c04-5f2c-4cb0-b28d-e21ee486a772
# ╠═f4992192-d11f-4637-ae9f-dba7ae946ba8
# ╠═08c26d41-cf4b-4094-84e0-efea7882cac7
# ╟─86579050-bc57-45cf-965f-affabc23c6e0
# ╟─8c38accf-8ca7-418e-aadb-f4c7aacc4eb4
# ╠═786c0bd8-932f-46a3-9cd3-11a626f523fc
# ╠═b668cc81-d500-42e3-9ca4-a957a8df118e
# ╠═97b87ad4-f74c-483f-8777-690ebd82bdef
# ╠═c6cb1f95-404a-4192-8be2-b1e94c2759c4
# ╠═a5d360c8-81e4-467e-bb20-21b71ba7431b
# ╠═86bf6099-373f-4427-94ba-ba3f14bfea50
# ╠═1b9205c4-eb62-436d-906d-7850b0a82c63
# ╠═3c7a64b9-4a73-4144-8bf4-c88aac838e54
# ╟─6388d4e9-38a1-4f00-bbf0-e1a903083460
# ╠═715f429d-7656-4014-aebf-974ed05f0cc1
# ╠═a5ef6c4b-b6c5-4ad8-ac43-ea4a204deadd
# ╠═76ca37f6-71ba-4320-aa19-1e73f53bb65d
# ╠═d046b762-098f-4c26-b57b-6f4ee7497032
# ╠═2e6f007b-b747-412d-b16b-e8808183e5fc
# ╟─538d762c-ae92-4f1f-b5c7-41c541dc626d
# ╠═f5a5cb9b-5148-43e3-aea2-9e62a23ca471
# ╠═8550486d-a796-46d3-a8fd-07e0a7f294bd
# ╟─d3d2ae26-c985-4856-bbb8-983d09b594ee
# ╠═286754b5-505d-43a4-99b9-aa57f789dea4
# ╠═a3571fdb-fa31-4db6-b6f3-c71d7f2e94e0
# ╠═b9a5c6e4-7f67-42e4-9380-6d999a3df17d
# ╠═88ee71e8-4b91-4a27-ab79-7dd6fbe49aa7
# ╟─87ddfa5a-8648-4719-a40d-ee4d0894de8e
# ╠═682249be-d6ea-4f86-9c52-d3931b7cb613
# ╠═5f36dae2-253b-4d86-97d6-2acde397e463
# ╠═10bc180b-55cb-477e-b437-678ab3156b75
# ╠═be1f7a7f-618b-4525-b796-78a5d1d1e54a
# ╠═7d470294-9c69-4ab8-82da-e8a2a7c5b576
# ╠═604cd972-cac5-4f2d-a98e-bb7c858f05f9
# ╠═171ab6fa-048e-4330-a506-045f1523dc8a
# ╠═803803c4-b675-4003-af82-bd017318bf81
# ╠═18fa2ee8-8fd3-498c-bf72-4cae930fb4cf
# ╠═d1af268e-309d-49ba-a9f7-170f7be73669
# ╠═fd74dd1e-c197-444f-9d3a-796426884648
# ╠═f9570f49-7923-469e-925c-9ed0f33bc163
# ╟─a52df543-ddad-49c3-a6bb-0bbcf32575f4
# ╠═5d4bf8f1-8b3c-41f3-ab41-711d56a30be3
# ╠═539afad3-cc60-4dde-a5d7-e1c32580182a
# ╠═8ffc46f5-e9a1-43d0-be9a-79dd7dad2361
# ╠═ee6478c8-3639-4530-a025-e4177f98c202
# ╠═3925c180-8a08-4dd2-b315-e3f9f8d2b7e1
# ╠═4daee6d9-39e2-4d9c-915e-3787c8eb1bbc
# ╟─4bc61cf4-fdae-4746-8b2e-98a1b1f53307
# ╟─1cfbab4a-c1a8-49e9-bcc4-79ee773ead30
# ╟─6d4eb0e4-1392-4ffa-a8c4-ec2f3d0d1b1b
# ╠═cc9478f7-5e21-4c2f-9569-56215f5f2565
# ╠═882e4324-afd3-42a2-90a0-58da4a21fad9
# ╠═ad034edc-d673-40a0-82e7-35803a5ecffe
# ╠═ad0ac826-330d-43bd-b86f-7a13d591057e
# ╠═1ce376af-a0c2-400f-a655-41ae0bdab251
# ╠═73c07fcb-5aa3-45b7-abd1-50e2af4b095c
# ╠═746146a0-10f1-44f1-a73b-92c62fe574b2
# ╠═d9a102a8-99cb-42d4-b7f6-7b04b2eddd70
# ╠═0df51397-7df5-49a8-9fb1-c686a548546e
# ╠═5e271af9-a6d5-4366-a8be-d29615a56990
# ╠═21eab018-1d2b-405c-bb13-aac7d61f0586
# ╠═bc81d8ad-7477-48fd-8a89-a673f815562e
# ╠═2293586c-3aa4-4fc1-9bf8-00467a396ccd
# ╟─0119977a-57e9-47a2-9c1b-48ddd4d62f90
# ╠═fcaf4ffc-ab66-4052-bc07-cb0cf7379f0a
# ╠═a8db6a56-0a67-434d-bc42-4ce0db57f2a2
# ╠═36bb0117-9634-4147-8ff6-1ba5dee2f9f9
# ╠═638ba491-dd79-43e2-a6de-46382d99e77f
# ╠═b99a3642-466f-439e-928b-257a525a9e2b
# ╟─fbfcb81f-1741-4904-9b8e-c7890be30d71
# ╠═5758cda8-317f-41f7-87fc-bf53998d4fc6
# ╠═2ab796bc-449d-4386-aaf2-20615bf1281e
# ╠═ffbed260-a5e3-4906-85db-f6debea5b00d
# ╠═ea483827-a735-4cfa-85fd-75cf2fe910f4
# ╠═7e4dad09-01ef-4bc6-8bdb-507ab580a2e7
# ╠═60f45d12-55d9-4e07-b841-8e68f010428a
# ╠═ef0f3822-5ec3-4d54-a518-7100a2820d87
# ╠═c9300481-e4be-4827-8f73-ac9a8fe406b5
# ╠═0f45f9a6-6877-42fc-83e2-377d1758d401
# ╠═8830c7df-e37c-4f81-879d-3ded6267e266
# ╠═de53597d-c61a-4d4c-9b16-45c5a08a98db
# ╠═f7797441-d376-4a56-b837-a488c3742ea5
# ╠═3e662ba4-b303-4093-9d15-999140ff0d18
# ╠═dd325dc8-884b-4c0f-9d55-45aa2cbf3a87
# ╟─be2f75ca-2934-49de-a982-9858bbf2c10e
# ╠═e5689ef0-53de-4027-803e-778e762771e6
# ╠═b3897a4b-cd3a-421b-8a53-01e9aec6b8b9
# ╠═23994cc6-0e65-4093-856b-be3ac3ede4de
# ╠═1e4b5fdc-1959-45fc-8aca-39abfd0ba58b
# ╟─887c2e8d-08fc-4dce-9e1f-0938dea1623b
# ╠═30e97964-4c4a-430a-afe5-46e6a387fd1f
# ╠═c32f258c-1b0d-418f-b682-27566177b152
# ╠═35e18b20-cc3c-49b2-8de4-60450163a772
# ╟─5e287813-4d57-48ad-a3e4-20247476512c
# ╟─6f38cfce-c626-4f9c-8ce9-417965ea5372
# ╟─2e9de7fd-b00e-4ce1-ba68-d647497e57fe
# ╟─f7dabac5-0421-4581-8d87-00ce9d8eeeb1
# ╠═41aef6dd-e5bd-44a7-9878-696a1a97e452
# ╟─991b1ce6-a5ef-43ed-8999-32811fdbc344
# ╠═ec154684-ff2b-473c-8ffe-c40d03631091
# ╟─49c58521-2ca3-48ad-b3d3-ff6b66efad83
# ╠═3444dab8-dd66-4bc3-bfb0-269ecd2f714a
# ╟─a0c8c208-a947-4120-a84b-3c60fd5d9c40
# ╠═a33ffcf7-7e38-49c9-83b7-64b1794d8bf8
# ╠═86891f4e-b52c-4389-9f2a-76e5481bcc9c
# ╠═e5041f5d-afd4-4760-852e-e57fa3e9263a
# ╠═e35dbec5-abbd-4604-8295-f33ac7e2a186
# ╠═1265e29f-5935-4d42-945c-39055ab96870
# ╠═e39b2826-e9ee-4f92-aeae-3f4bb6263db0
# ╟─31cd0a63-70f5-425d-bd2e-df9243a3198a
# ╠═87c89cef-bb05-47d6-807d-a8a0b56b72b4
# ╠═dadfc45e-0ba6-4890-af4d-868219630c3b
# ╟─541eecaa-26aa-4a31-906b-c177065e3f21
# ╠═d158f290-f890-422b-b978-c92cdfeb358f
# ╠═69bce858-176d-4764-a553-1ffe7b26319f
# ╠═cdd7254a-bae0-489c-82f4-bbc9b93a8ea1
# ╠═d06e076c-9665-4b7a-b4f3-e26b055bc717
# ╠═0d88594c-6dfc-4e43-85e0-0980834983d0
# ╠═278e1371-d51f-4db0-a39e-12e2be14da40
# ╠═a141433d-227f-4f15-98a5-f3d04e40fe99
# ╠═481d9d41-2487-4b1d-8752-04fbf1f15766
# ╠═333b5c86-34ed-473c-b30a-f23b0735d2a2
# ╟─72cfcaa3-a5b1-484a-9829-d2bd3024f90b
# ╠═caebe503-a0a2-4782-aea3-7456ac3ea1a6
# ╠═02342aa2-29a3-4274-b345-38dc17ab0eef
# ╠═b51610de-dd9e-4ed4-a4a3-6cb769862473
# ╠═f1a88238-cd46-4c81-927c-80881d9c3ca3
# ╠═a5843028-cfa1-4d42-a2ed-3eb2e337389e
# ╠═9f567c95-9bc5-48f7-816f-91061a73eeda
# ╠═eeb9b7e4-1bd1-4f08-ad33-70b1b05bbaef
# ╠═7437e352-80d0-49ae-b928-b7997e9f877e
# ╠═a59a0629-c827-4bcf-8598-d389f76d546d
# ╠═a6ac7d8c-4f40-410b-8eaa-b16438f34081
# ╠═6b754818-d7e8-4955-9a74-616f32fb98cc
# ╠═ae38a6d9-8285-4093-b796-53668427d464
# ╟─d5804b42-9925-42eb-86ec-25503f56bcc6
# ╠═ca3ec019-de3d-4cee-8e77-556bb0a6a7e9
# ╠═ec4c39b2-54d7-4659-8c35-f823bfec550e
# ╟─ce44c3fc-0496-465f-a9c1-2503018c0fa8
# ╠═7f3a6426-e72d-4ae9-a3e9-79c437116391
# ╠═00ea7172-d6e6-4202-b3de-ed1f013f9429
# ╠═910e7d3f-efa4-4212-a384-010131b27715
# ╠═0387258c-3a71-4f39-bd08-9ee2ce0c425e
# ╠═952f98c6-eb3d-40a0-b2cc-43b2791a1d14
# ╠═d5f4cf53-02ed-4a5e-ac87-286e02bbfde9
# ╠═fa40277a-ddc9-4538-9746-c6845b67e415
# ╠═187a562d-9a82-4499-9a8f-d8f7e4ec454c
# ╠═9d12cb69-4bc2-4aff-9166-20b5787d704b
# ╟─f51af477-c809-4f07-a38f-538ac6b00ec8
# ╠═1489b23b-aa5c-4812-9914-56db0979fa50
# ╠═3014af89-278f-426c-a4a3-46840dd86e9b
# ╠═9f7aeced-191e-4a92-a27b-0d02a321dfc3
# ╟─9ffb3d31-1038-4d94-9529-cd25b4b43259
# ╠═404a4b60-2cc2-40d5-ada8-9a020bd200a5
# ╠═ae7f3fcc-886f-4b06-8e20-371b8a0cf5cb
# ╟─a2f420a9-6279-4855-85ca-b3489e01ae8f
# ╠═f84c82c9-d004-497c-9f64-71c9e3f7219d
# ╠═47701d24-b015-452d-9b53-6ef244a27860
# ╟─f51e8787-0904-4351-9d2a-bd5cc87cb70d
# ╟─0802559e-7777-43fb-a2ea-1b21a68bd034
# ╟─51873a3d-f856-4f7b-8fd6-4270445ac525
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
