### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 1111f5e5-cb01-4634-a014-e3c9caa3a15f
begin 
	using Pluto
	using Plots	
	using LaTeXStrings, Latexify
	using GraphRecipes
	#----------------------------------------------------------------
	println("pkgversion(Pluto)         = ", pkgversion(Pluto))
	println("pkgversion(Plots)         = ", pkgversion(Plots))
	println("pkgversion(Latexify)      = ", pkgversion(Latexify))
	println("pkgversion(GraphRecipes)  = ", pkgversion(GraphRecipes))
end # begin

# ╔═╡ e8c1f880-0278-11ec-2538-13bb2f14d606
md"
=====================================================================================
#### SICP: [2.1.1 Arithmetic Operations For Rational Numbers](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e1)

###### file: PCM20210821\_SICP\_2.1.1\_ArithmeticOperationsForRationalNumbers.jl

###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/02/27 ***
=====================================================================================
"

# ╔═╡ 55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
md"
---
##### 0. Introduction

Here we deal with the *representation* of *rational* numbers with simple *algebraic data type* (*ADT*) $Tuple$. $Pair$ or $Rational$. An *ADT* [*is a kind of composite data type ... formed by combining other types*](https://en.wikipedia.org/wiki/Algebraic_data_type).

Mathematically, [*Rationals*](https://en.wikipedia.org/wiki/Rational_number) $\mathbb Q$ are a superset of *integers* $\mathbb Z$ and a subset of *reals* $\mathbb R$:

$\mathbb N \subset \mathbb Z \subset \mathbb Q \subset \mathbb R \subset \mathbb C.$

$\;$

We represent rational numbers as *pairs* of numerator and denominators in *four* alternative ways:
- the *first* mimics the presentation in SICP. It is very *Scheme-like* with *un*named *tuples*. A *Tuple* object has two *un*typed fields $car$ and $cdr$. The construction of a $Tuple$ is delegated to the body of a constructor function $cons1$. 
- the *second* is the first *specialized* way by using Julia's *built-in* type $Pair$. The construction of pairs is delegated to the body of a constructor function $cons2$. The two *fields* can accessed by selectors $first$ and $second$. They are hidden in the *Scheme*-like selector functions $car2$ and $cdr2$.
- the *third* is the second *specialized* way by using Julia's *built-in* type $Rational$. The construction of pairs is delegated to the body of a *Scheme*-like constructor function $cons3$. The two fields can accessed by the functions $numerator$ and $denominator$. They are hidden in the *Scheme*-like selector functions $car3$ and $cdr3$.
- the *fourth* is the most easy and third *specialized* way by using Julia's *built-in* type $Rational$ and its *built-in* operators $+, -, *, /$, and $==$. The construction of rationals is done by using Julia's *built-in* constructon operator *//*. The two fields can accessed by $numerator$ and $denominator$. 

In this chapter we try to avoid Julia's *multiple dispatch*. *Multiple dispatch* is valuable for subordinating *type-different* alternative functions as *methods* under the umbrella of a reduced set of function objects. *multiple dispatch* is allowed only as *methods* in some functions.

Wheras *inputs* to the most *abstract* constructors $makeRat1-3$ are always the *same* their *outputs* differ. Inputs are *Integers* for *numerator* and *denominator* of the ratio. Outputs of constructors *differ* in type (*Tuple*, *Pair*, *Struct*, *Rational*). These output types are the relevant characteristic of each *abstraction tower* (= *abstraction hierachy*).

"

# ╔═╡ 0ba0f38f-f2cd-47c2-8112-07f82cd34936
md"
---
##### 1. Topics
- *algebraic data* type (*ADT*)
- *data* object
- *pair*
- *named* tuple
- *constructor*
- *selector*
- *parallel* assignment
- *type* and *constructor* $Pair$
- *typejoin*
- *type* $Signed$
- *type* $Rational$
- *multiple dispatch*
"

# ╔═╡ 98d28306-c11d-4559-b8a4-1d196e12fcca
md"
---
##### 2. Libraries and Service Functions
###### 2.1 Libraries

"

# ╔═╡ 1a52e675-5297-45da-97ca-a7b859d66c6d
md"
---
###### 2. Service Functions

- *plotHorizontalArrowFromLeftToRight!*
- *plotHorizontalArrowFromRightToLeft!*
- *plotInvUnaryTree!*
- *plotInvBinaryTree!*
- *plotInvTernaryTree!*
"

# ╔═╡ 882c5c98-4339-4648-be77-82f5dd4f7237
begin
	#------------------------------------------------------------------------------
	function plotHorizontalArrowFromLeftToRight!(markOfLeftNode, markOfRightNode, coordinateXOfMiddle, coordinateYOfMiddle; lengthOfLine=2.0, fontSize=9)
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfMiddle-lengthOfLine/2+lengthOfLine/10, coordinateYOfMiddle), 
			(coordinateXOfMiddle+lengthOfLine/2-lengthOfLine/10, coordinateYOfMiddle)], 
			lw=1, linecolor=:black, arrow=true) 
		annotate!(                                         # mark of left node  'x'
			(coordinateXOfMiddle-lengthOfLine/2, coordinateYOfMiddle, text(markOfLeftNode, fontSize, :blue)))                  
		annotate!(                                         # mark of right node 'x'
			(coordinateXOfMiddle+lengthOfLine/2, coordinateYOfMiddle, text(markOfRightNode, fontSize, :blue)))       
	end # function plotHorizontalArrowFromLeftToRight!
	#------------------------------------------------------------------------------
	function plotHorizontalArrowFromRightToLeft!(markOfLeftNode, markOfRightNode, coordinateXOfMiddle, coordinateYOfMiddle; lengthOfLine=2.0, fontSize=9)
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfMiddle+lengthOfLine/2-lengthOfLine/10, coordinateYOfMiddle), 
			(coordinateXOfMiddle-lengthOfLine/2+lengthOfLine/10, coordinateYOfMiddle)], 
			lw=1, linecolor=:black, arrow=true) 
		annotate!(                                         # mark of left node  'x'
			(coordinateXOfMiddle-lengthOfLine/2, coordinateYOfMiddle, text(markOfLeftNode, fontSize, :blue)))                  
		annotate!(                                         # mark of right node 'x'
			(coordinateXOfMiddle+lengthOfLine/2, coordinateYOfMiddle, text(markOfRightNode, fontSize, :blue)))       
	end # function plotHorizontalArrowFromRightToLeft!
	#------------------------------------------------------------------------------
	function plotInvUnaryTree!(markOfLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=2, fontSize=9)
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8),  # root
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree+heightOfTree/8)],                                  # leaf 
			lw=1, linecolor=:black)                      
		annotate!(                                               # mark of leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree, text(markOfLeaf, fontSize, :blue)))                  
		annotate!(                                               # mark of root 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                             
	end # function plotUnaryTree!
	#------------------------------------------------------------------------------
	function plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=1.5, heightOfTree=2, fontSize=9) 
		annotate!(                                          # mark of left leaf 'x'
			(coordinateXOfRootMark-widthOfTree/2, 
			 coordinateYOfRootMark-heightOfTree, 
			 text(markOfLeftLeaf, fontSize, :blue)))         
		plot!([                                     # plot of left vertical arm '|'
			(coordinateXOfRootMark-widthOfTree/2,   
			coordinateYOfRootMark-heightOfTree+heightOfTree/8),  
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		annotate!(                                         # mark of right leaf 'x'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree, 
			text(markOfRightLeaf, fontSize, :blue)))        
		plot!([                                    # plot of right vertical arm '|'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree+heightOfTree/8), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)          
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8)], 
			lw=1, linecolor=:black) 
		annotate!(                                          # mark of root leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                       
	end # function plotBinaryTree!
	#------------------------------------------------------------------------------
	function plotInvTernaryTree!(markOfLeftLeaf, markOfMiddleLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=3.0,
	heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvUnaryTree!(markOfMiddleLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotTernaryTree!
	#------------------------------------------------------------------------------
	function plotInvQuaternyTree!(markOfLeftMostLeaf, markOfLeftLeaf, markOfRightLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=4.0, heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftMostLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree/3, heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotQuaternyTree!
	#------------------------------------------------------------------------------
end # begin

# ╔═╡ d4e48294-c66c-4fa3-9586-89fb825a4ee8
md"
---
##### 3. Arithmetic Operations for Rational Numbers 
(SICP-Scheme-like *functional*, mostly *un*typed Julia)

"

# ╔═╡ f642fc8d-c007-4173-9edc-8ebfb621095e
md"
---
##### 3.1 First *Abstraction Tower*: Data as *Named Pairs*
"

# ╔═╡ d2d4dd60-f2e4-421c-80cd-63fb61faf31c
md"
$\begin {array}{c|c|c}
                    &             \text{First}                  &                  \\
\text{ Operator }   &  \text{Abstraction Tower (=Hierarchy)}    & \text{Level}     \\
\hline
\text{ Abstract}    &            addRat1, subRat1               & \text{level 2}   \\
\text{Operators}    &        mulRat1, divRat1, equalRat1        & \text{Domain}    \\
                    &               printRat                    &                  \\
\hline
\text{Constructor/} &               makeRat1                    & \text{level 1}   \\
\text{Selectors}    &             numer1, denom1                &                  \\
\hline
\text{Constructor/} &                 cons1                     & \text{level 0}   \\
\text{Selectors}    &               car1, cdr1       & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &   dataObject = (car = ... , cdr = ...)    & \text{level -1}  \\
\text{Selectors}    &       dataObject.car1, consCell.cdr1      & \textit{Julia}   \\
\hline
\end {array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 3.1**: First *Abstraction* Tower (= Hierarchy) for *Rational* Number Algebra

"

# ╔═╡ a9130eeb-2b28-41e5-8674-9abee99c8401
md"
---
###### 3.1.1 *Un*typed *Abstract* Functions 
- *addRat1*
- *subRat1*
- *mulRat1*
- *divRat1*
- *equalRat1* 
"

# ╔═╡ dc723ee4-97ce-41a3-88b0-49ccb31c289e
md"
---
###### Addition

$+\;\;: \;\; \mathbb Q\ \times \mathbb Q\ \rightarrow \mathbb Q$

$\;$

$x+y = \frac{n_x}{d_x}+\frac{n_y}{d_y}= \frac{n_x d_y + n_y d_x}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ 68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
md"
---
###### Subtraction

$-\;\; : \;\; \mathbb Q\ \times \mathbb Q\ \rightarrow \mathbb Q$

$\;$

$x-y = \frac{n_x}{d_x}-\frac{n_y}{d_y}= \frac{n_x d_y - n_y d_x}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
md"
---
###### Multiplication

$\cdot\;\;: \;\; \mathbb Q\ \times \mathbb Q\ \rightarrow \mathbb Q$

$\;$

$x \cdot y = \frac{n_x}{d_x} \cdot \frac{n_y}{d_y}= \frac{n_x n_y}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ 0875ee4d-e127-4140-a863-04c3a02c38a5
md"
---
###### Division

$/\;\;: \;\; \mathbb Q\ \times \mathbb Q\ \rightarrow \mathbb Q$

$\;$

$x/y = \left(\frac{n_x}{d_x}\right)/\left(\frac{n_y}{d_y}\right) = \frac{n_x d_y}{d_x n_y}$

$\;$
$\;$

"

# ╔═╡ f74ced3c-487c-4428-bcfc-cc69e5416227
md"
---
###### Equality test

$=\;\;: \;\; \mathbb Q\ \times \mathbb Q\ \rightarrow \mathbb B$

$\;$

$(x=y) \equiv \left(\frac{n_x}{d_x} = \frac{n_y}{d_y}\right) \equiv (n_x d_y = d_x n_y)$

$\;$
$\;$

"

# ╔═╡ 7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
md"
---
###### 3.1.2 *Implementing* *Abstract* Functions of *ADT* by *Constructors* and *Selectors*

"

# ╔═╡ 680c5ec0-6cf2-4b0c-a005-751ef8a7e568
md"
---
###### *1st* (*Un*typed, *without* gcd) Method of Function $makeRat1$
"

# ╔═╡ 810b1eca-eac7-49cb-a34f-8328ea432824
md"
---
###### *2nd* method (*specialized*, *typed*, *with* gcd) of Function $makeRat1$
###### ... with type $$Signed$$ and imperative *looping* construct $while$
"

# ╔═╡ 764ec0e3-66c3-4a67-9473-95380e11250b
md"
---
###### Abstract *Un*typed Selectors $numer, denom$ based on $car, cdr$
"

# ╔═╡ 08ede030-fb83-4337-8c37-f346b1b7ebc0
md"
---
###### 3.1.3 Implementing Data Object *Pair* as Named *Tuple*
*A pair is a data object that can be given a name and manipulated, just like a primitive data object.*(SICP, 1996, p.85)

Scheme's pair *constructor* is $cons$ and *selectors* are $car$ and $cdr$. They will be implemented as Julia-*functions* and -*tuples* with *named* fields. 

The *interface* of pair-related functions $cons, cadr$, and $cdr$ is similar to *[M-expressions](https://en.wikipedia.org/wiki/M-expression)* (= *Meta-language* expressions) introduced by *McCarthy* et al. (1965, p.9). 

...*there are two LISP's: there is the algorithmic language and there is the programming language. The programing language is a data structure representation of the algorithmic language. The algorithmic language is called the* *meta-language* or *M-expr LISP*, *and for historical purposes, the programming language is called* *[S-expr](https://en.wikipedia.org/wiki/S-expression) LISP*  (Allen, J., 1978, p.107).

So the *interface* of our Scheme-like Julia-functions resembles in form and function expressions of *McCarthy's meta-language*.

The three different signatures are (Fig 3.2.1):

"

# ╔═╡ 80ed0fe4-9f5b-4521-8189-f7f1273706fb
md"
$\begin {array}{c|c|c}
\text{Low Language Level} & \text{Low Language Level} & \text{Low Language Level}  \\
\hline
\text{algorithmic:}  &            \text{programming:}         & \text{programming:} \\
\text{M-exprs}       &              \text{S-exprs}            & \text{Julia-exprs} \\
\text{McCarthy, Allen} &         \text{Lisp, Scheme}          & \text{Julia}       \\ 
\hline
\text{cons[<arg1>,<arg2>]}&\text{(cons <arg1> <arg2>)}&\text{cons1(<arg1>,<arg2>)} \\
\hline
\text{car[cons[<a1>,<a2>]]}&\text{(car(cons <a1> <a2>))}&\text{car1(cons1(<a1>,<a2>))}\\
\text{==<a1>}     &     \text{==<a1>}                       &  \text{==<a1>}  \\
\hline
\text{cdr[cons[<a1>,<a2>]]}&\text{(cdr(cons <a1> <a2>))}&\text{cdr1(cons1(<a1>,<a2>))}\\
\text{==<a2>}     &     \text{==<a2>}                       &  \text{==<a2>}  \\
\hline
\end {array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 3.2**: Low Level *constructors* and *selectors* $cons, car$, and $cdr$

"

# ╔═╡ ca947e77-0bd0-4ac3-b44d-df998ea557a8
md"
---
###### Definition of *Constructor* $cons$ ...
... with named fields $car$ and $cdr$
"

# ╔═╡ 8efe03bc-3fce-41d4-b55d-f899984b1068
let yMax = 4
	#--------------------------------------------------------------------------------
	plot(size=(600, 300), xlim=(-1.5, 8.0), ylim=(1, yMax), legend=:false, ticks=:none)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ b068c8b6-7cfd-47c0-9e87-ee4cd7537bce
md"
**Fig. 3.3** *Binary* Tree Representation of $cons1(1, 2) \mapsto (car=1, cdr=2) = (1 \bullet 2)$

"

# ╔═╡ 3b7faab0-b8e0-4bea-894f-16fd35e5727f
# cons(<car1>, <cdr1>) = (car=<car1>, cdr=<cdr1>)
cons1(car1, cdr1) = (car1=car1, cdr1=cdr1)

# ╔═╡ 7ff3b4a0-e00b-424f-8118-897019d0fc20
makeRat1(n, d) = cons1(n, d)                      

# ╔═╡ df37be85-589a-46aa-a14c-8ab67c461ae9
function makeRat1(n::Signed, d::Signed)            # 2nd method
	#----------------------------------------------------------
	function gcd2(a, b) 
		#------------------------------------------------------
		remainder = %              # local function definition
	    #------------------------------------------------------
		b == 0 ? 
			a : 
			gcd(b, remainder(a, b))
		#----------------------------------------=-------------
		while !(b == 0)
			a,b = b, remainder(a, b) # parallel (!) assignment
		end # while
		a
		#----------------------------------------=-------------
	end  # function gcd2
	#----------------------------------------=-----------------
	let g = gcd2(n, d)
		cons1(n ÷ g, d ÷ g)
	end # let
	#----------------------------------------=-----------------
end # function makeRat1

# ╔═╡ 7f3eefe6-e57a-40b3-96cc-056dcd77346d
md"
---
###### Definition of *Selector* $car1$
"

# ╔═╡ 80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
car1(cons1) = cons1.car1                # definition of selector 'car1'

# ╔═╡ 193ae321-0f26-44cc-a48f-1a1b9bc71af8
numer1(x) = car1(x)                      # definition of abstract selector 'numer1'

# ╔═╡ 470be70d-8a49-45c6-a624-98535dddb289
md"
---
###### Definition of *Selector* $cdr$
"

# ╔═╡ 1c695d3b-c88e-4227-8aa1-e88149a4f9f4
cdr1(cons1) = cons1.cdr1                # definition of selector 'cdr'

# ╔═╡ d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
denom1(x) = cdr1(x)                      # definition of abstract selector 'denom1'

# ╔═╡ ca75c0f7-2e85-4436-8544-9b19aa0f57a8
function addRat1(x, y)
	makeRat1( +( 
		*(numer1(x), denom1(y)), *(numer1(y), denom1(x))), 
		*(denom1(x), denom1(y)))
end # function addRat1

# ╔═╡ a181310f-1f46-43b2-8702-a8a60308ccfe
function subRat1(x, y)
	makeRat1( -( 
		*(numer1(x), denom1(y)), *(numer1(y), denom1(x))), 
		*(denom1(x), denom1(y)))
end # function subRat1

# ╔═╡ 778e12ad-bfe7-4f02-a946-894249fe2375
function mulRat1(x, y)
	makeRat1( 
		*(numer1(x), numer1(y)), 
		*(denom1(x), denom1(y)))
end # function mulRat1

# ╔═╡ dce13d9a-7ffd-475a-84de-7826a1198f38
function divRat1(x, y)
	makeRat1(
		*(numer1(x), denom1(y)), 
		*(denom1(x), numer1(y)))
end # function divRat1

# ╔═╡ bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
function equalRat1(x, y)
	*(numer1(x), denom1(y)) == *(denom1(x), numer1(y))
end # function equalRat

# ╔═╡ 9de2fcec-e581-41b6-a09d-0c27b033106e
md"
---
###### 3.1.4 Naming and Tree Representations
"

# ╔═╡ 3fba0329-19ac-485a-a56d-ee64ae0e3573
x = cons1(1, 2)                      # construction of 2-tuple consCell

# ╔═╡ 44d3380a-b2ab-43e1-8f03-a14a9599fac0
typeof(x)                            # NamedTuple{car1::Int64, cdr1::Int64}

# ╔═╡ 44017d8b-476e-4e9c-abac-229e9a2e85d1
car1(x)                              # selection of field 'car' of 2-tuple 

# ╔═╡ 51732672-ee53-46e7-85bf-217f531867cc
cdr1(x)                              # selection of field 'cdr' of 2-tuple consCell

# ╔═╡ a1587038-c11d-4b4b-8436-b098b61f1077
y = cons1(3, 4)               # construction of 2-tuple (= cons-cell) y

# ╔═╡ 118b16a3-093f-4b39-823b-ac167da69615
car1(y)

# ╔═╡ fb4ecf01-1361-43c5-854d-8c83969a2e60
cdr1(y)

# ╔═╡ 6fa45a52-31fd-44c6-9928-4a75a7feccc0
let yMax = 5
	#--------------------------------------------------------------------------------
	plot(size=(600, 300), xlim=(-1.5, 8.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromLeftToRight!("y", "•", 2.0, yMax-2.0;lengthOfLine=4.0)
	plotInvBinaryTree!("3", "4", "•", 4.0, yMax-2.0; widthOfTree=4.0, heightOfTree=1)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ 6a584664-cda8-41c1-8bfe-2b7d5b5e1e28
md"

**Fig. 3.4** *Binary* Tree Representation of *named Pair* $y = cons1(3, 4) = (3 \bullet 4)$

"

# ╔═╡ 099f789b-9fdd-4643-8c6e-b5054af12736
let yMax = 4
	#------------------------------------------------------------------------------
	plot(xlim=(-2.5, 12.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromRightToLeft!("•", "y", 9.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("x", "•", 1.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("z", "•", 2.0, yMax-1.0;lengthOfLine=6.0)
	plotInvBinaryTree!("3", "4", "•", 7.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("•", "•", "•", 5.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ d1cd6289-c53d-4561-9895-4958c3e150b5
md"
**Fig. 3.5** *Binary* Tree Representation of $z \mapsto cons1(x, y) = ((1 \bullet 2) \bullet (3 \bullet 4))$

"

# ╔═╡ 132232a8-495f-4f2c-a08a-da4b898f606b
z = cons1(x, y)                        # construction of 2-tuple Pair named z

# ╔═╡ 768b4543-6d34-4af7-9ee1-6120a33a169d
car1(z)                                # left subtree

# ╔═╡ 8b990c96-d5e2-4e77-ae73-eae3bc399f9d
cdr1(z)                                # right subtree

# ╔═╡ 4e7da88e-e73e-4d15-bd5f-b1eed925322d
car1(car1(z))

# ╔═╡ b13bdc8a-1954-4ade-bfce-26e9e14aef5f
cdr1(car1(z))

# ╔═╡ 9b7d9d52-77c6-4328-8018-3b1e40fb9558
car1(cdr1(z))

# ╔═╡ fb8cfd69-4a4a-4a0d-b2b4-7ffc325ce9b5
cdr1(cdr1(z))

# ╔═╡ 61340177-3808-4a2b-906f-51b801178c6f
md"
---
###### 3.1.5 Output Function $printRat$
(= Transformation of *internal* into *external* form)

"

# ╔═╡ 172db576-f756-4d62-94c3-128c6ac4f847
# idiomatic Julia-code with string interpolation "$(.....)"
printRat(x) = "$(numer1(x))/$(denom1(x))"

# ╔═╡ a9341f5b-8b06-4994-ba6b-58070485c336
md"
---
###### 3.1.6 Applications
"

# ╔═╡ 9b1a0332-0170-424b-be4d-abba0c042ff6
one_half_1 = makeRat1(1, 2)

# ╔═╡ 5e19e77d-ccea-4825-807d-5a278d762978
typeof(one_half_1)

# ╔═╡ cafada61-82c1-4231-bcd8-9887df2be87c
one_third_1 = makeRat1(1, 3)

# ╔═╡ e20d52b3-204c-4105-a362-2b9e66fe22f9
two_twelves_1 = makeRat1(2, 12)             # == 1/6 --> with (!) application of gcd

# ╔═╡ 63d09ac2-193d-49dc-9eff-d5c14f973627
addRat1(one_half_1, one_third_1)                # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 69facaff-5c1f-4c8e-a436-81e8f9cd73b9
equalRat1(makeRat1(2, 3), makeRat1(6, 9))      # 2/3 == 6/9 ==> true -->  :)

# ╔═╡ 45772e1e-aa83-46cd-add7-4f977f58dff0
equalRat1(makeRat1(1, 2), makeRat1(3, 6))  # 1/2 = 3/6 => 1/2 == 1/2 ==> true -->  :)

# ╔═╡ d3d1980c-00f3-4d04-abe5-8705f61b3459
equalRat1(makeRat1(4, 3), makeRat1(120, 90))   # 4/3 == 120/90 ==> true -->  :)

# ╔═╡ a861fc71-5a96-43b4-9a8f-94a603d2cb3b
md"
---
###### nonSICP: [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) 
accurate to seven digits
"

# ╔═╡ aa7ea22e-f330-427e-9d89-408003e6b8f2
355/113

# ╔═╡ bf4034ad-07ff-4400-8aba-3b855fc43a5c
355/113 - π                   # deviation from Julia's π (accurate to seven digits)

# ╔═╡ 03d4c7b4-3618-4d69-ad14-a680758955f9
md"
---
##### 3.2 Second *Abstraction Tower*: Data as Structure $Pair$
(*Idiomatic* Julia with types $Signed$, $Pair$, $\%$, and $while$
"

# ╔═╡ 20fa866b-a9d2-4446-a57a-c01fe145aaac
md"
$\begin {array}{c|c|c}
                    & \text{Abstraction Hierarchy}              &                  \\
\hline
\text{ Abstract}    &             addRat2, subRat2              & \text{level 2}   \\
\text{Operators}    &        mulRat2, divRat2, equalRat2        & \text{Domain}    \\
                    &                printRat                   &                  \\
\hline
\text{Constructor/} &                makeRat2                   & \text{level 1}   \\
\text{Selectors}    &              numer2, denom2               &                  \\
\hline
\text{Constructor/} &                 cons2                     & \text{level 0}   \\
\text{Selectors}    &               car2, cdr2       & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &  dataObject = Pair(first:...,second:...)  & \text{level -1}  \\
\text{Selectors}    &  dataObject.first, dataObject.second      & \textit{Julia}   \\
\hline
\end {array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 3.6**: Second *Abstraction* Tower (= Hierarchy) for *Rational* Number Algebra 

"

# ╔═╡ c68ae171-e6cc-4ef7-970e-1555f76241f3
md"
---
###### 3.2.1 Arithmetic Operations for Rational Numbers 

*Typed, Abstract* Functions

- *addRat2*
- *subRat2*
- *mulRat2*
- *divRat2*
- *equalRat2*

"

# ╔═╡ d84101ea-7172-4e1f-9929-1a23acd7a7c7
md"
---
###### 3.2.2 Abstract Functions with *Type* and *Constructor* $Pair$

"

# ╔═╡ b4c9a74b-5a49-452e-bbf0-44826cd92e46
md"
###### Abstract *Typed* Constructor $makeRat2$
"

# ╔═╡ f46b3ac9-4ae4-42ba-9ef9-6516c96b013c
md"
---
###### *1st* (*Un*typed, *without* gcd) Method of Function $makeRat2$
"

# ╔═╡ 48d6a6b2-aca3-44dc-af73-ede92f0dbc87
md"
---
###### *2nd* method (*specialized*, *typed*, *with* gcd) of Function $makeRat2$
###### ... with type $Signed$ and imperative *looping* construct $while$
"

# ╔═╡ 4e179b9f-021e-4891-8e27-7fa36b827fcf
md"
---
###### Abstract *Typed* Selectors $numer2, denom2$
"

# ╔═╡ cc592f32-8785-4735-badd-de3903c20f05
md"
---
###### 3.2.3 Implementing *Pairs* as *Data Type* $Pair$
---
(*typed*) Functions $cons2, car2$, and $cdr2$
Definition of constructor $cons2$ with constructor $Pair(<part1>, <part2>)$ and fields $first$ and $second$. These selectors are delegated to the *Scheme*-like selectors $car2, cdr2$.

"

# ╔═╡ dd8f85a7-b11a-4502-aab5-55002104447f
typejoin(Int64, Int32)

# ╔═╡ c7a0b1d2-7b73-44ef-97ce-ef76deb89120
md"
---
###### *Multiple* Dispatch: *1st* Method of Function $cons2$
"

# ╔═╡ 0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# idiomatic Julia-code by built-in types 'Signed' and constructor 'Pair'
cons2(car::Signed, cdr::Signed)::Pair =         # car, cdr are parameters here
	Pair(car::Signed, cdr::Signed)::Pair        # constructor Pair

# ╔═╡ 79816302-b87c-4653-8bcb-2a0567f9ad34
md"
---
###### *Multiple* Dispatch: *2nd* Method of Function $cons2$
"

# ╔═╡ 10aa3d47-ca38-4aa4-a9b5-689d2dad3b13
# idiomatic Julia-code by built-in types 'Pair' and constructor 'Pair'
cons2(car::Pair, cdr::Pair)::Pair =             # car, cdr are parameters here
	Pair(car::Pair, cdr::Pair)::Pair            # constructor Pair

# ╔═╡ 3498e844-931f-4d46-a9aa-b9a2d3b892e7
# idiomatic Julia-code by '÷'
function makeRat2(n::Signed, d::Signed)::Pair
	#----------------------------------------------------------
	function gcd2(a::Signed, b::Signed)::Signed
		#---------------------------------------
		remainder = %
		#---------------------------------------
		b == 0 ? a : gcd(b, remainder(a, b))
		#---------------------------------------
		while !(b == 0)
			a,b = b, remainder(a, b) # multiple (!) assignment
		end # while
		a
	end # function gcd2
	#----------------------------------------------------------
	let g = gcd2(n, d)
		cons2(n ÷ g, d ÷ g)::Pair
	end # let
end # function makeRat2

# ╔═╡ 1fddd3ae-5da7-4a32-a53e-077b8f37509c
car2(cons::Pair) =                              # cons is typed parameter here
	cons.first                                  # Pair-selector 'first'

# ╔═╡ 7f5b9164-07c2-4ae1-888d-f601fa9d286c
numer2(x::Pair)::Signed = car2(x::Pair)::Signed

# ╔═╡ b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
cdr2(cons::Pair) =                              # cons is typed parameter here
	cons.second                                 # Pair-selector 'second'

# ╔═╡ 3ca05b52-413f-46aa-9fd7-659227dccbd7
denom2(x::Pair)::Signed = cdr2(x::Pair)::Signed

# ╔═╡ 76e3a4bc-fde2-4440-96c1-c492cc120db0
function addRat2(x::Pair, y::Pair)::Pair
	makeRat2(
		numer2(x) * denom2(y) + numer2(y) * denom2(x), 
		denom2(x) * denom2(y))
end

# ╔═╡ 402d8963-26bc-4db2-b94b-ba4334e1d8fd
function subRat2(x::Pair, y::Pair)::Pair
	makeRat2(
		numer2(x) * denom2(y) - numer2(y) * denom2(x), 
		denom2(x) * denom2(y))
end

# ╔═╡ 09901068-bf38-4392-ab19-66a44d65344d
function mulRat2(x::Pair, y::Pair)::Pair
	makeRat2(
		numer2(x) * numer2(y), 
		denom2(x) * denom2(y))
end

# ╔═╡ 555e6212-22bd-4d0e-b221-edfe32f043f5
function divRat2(x::Pair, y::Pair)::Pair
	makeRat2(
		numer2(x) * denom2(y), 
		denom2(x) * numer2(y))
end

# ╔═╡ afe55885-aba6-4cbc-af2c-23d15bbbf6f5
function equalRat2(x::Pair, y::Pair)::Bool
	numer2(x) * denom2(y) == denom2(x) * numer2(y)
end

# ╔═╡ 62f3e34c-d07d-4b8a-8e49-65e45fe58605
md"
---
###### 3.2.4 Naming and Tree Representations
"

# ╔═╡ ea9117b0-1775-4ae0-9335-1e2e32b78c2d
x2 = cons2(1, 2)                      # construction of Pair

# ╔═╡ b928c2cb-cc3d-4efd-ad83-7aaa1b914138
typeof(x2)                            # Pair{Int64, Int64}

# ╔═╡ c37a487d-1176-4680-8798-be62de8514d3
car2(x2)                              # selection of field 'car' of Pair

# ╔═╡ d64203fa-7400-4587-bc56-f497ded5fa97
cdr2(x2)                              # selection of field 'cdr' of Pair

# ╔═╡ 2dc241a2-900b-4e67-a0c5-921f491400ac
y2 = cons2(3, 4)                      # construction of Pair y2

# ╔═╡ bdc6f5ea-4a76-4b8d-98c0-a043fb677514
car2(y2)

# ╔═╡ e33097fd-50f9-4f8d-9941-75f0ee588d21
cdr2(y2)

# ╔═╡ 9a4ea235-19bf-45be-9740-1ff03747b71c
let yMax = 5
	#--------------------------------------------------------------------------------
	plot(size=(600, 300), xlim=(-1.5, 8.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromLeftToRight!("y2", "•", 2.0, yMax-2.0;lengthOfLine=4.0)
	plotInvBinaryTree!("3", "4", "•", 4.0, yMax-2.0; widthOfTree=4.0, heightOfTree=1)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ 2b81b557-5aa5-409d-b9da-9f5cdf88c0a1
md"

**Fig. 3.7** *Binary* Tree Representation of *named Pair* $y2 = cons2(3, 4) = (3 \bullet 4)$

"

# ╔═╡ 0e482210-86e3-42fb-9803-4c0332d9ee0e
let yMax = 4
	#------------------------------------------------------------------------------
	plot(xlim=(-2.5, 12.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromRightToLeft!("•", "y2", 9.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("x2", "•", 1.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("z2", "•", 2.0, yMax-1.0;lengthOfLine=6.0)
	plotInvBinaryTree!("3", "4", "•", 7.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("•", "•", "•", 5.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ b1a429ca-eeaf-4821-ab92-8bb5dc9c1e48
md"
**Fig. 3.8** *Binary* Tree Representation of $z2 \mapsto cons2(x2, y2) = ((1 \bullet 2) \bullet (3 \bullet 4))$

"

# ╔═╡ 85aee7a8-500e-4d03-af9f-388370f9bab7
z2 = cons2(x2, y2)                        # construction of 2-tuple Pair named z

# ╔═╡ 24fd8f05-c62c-4aee-837c-bcd0c2f5e2e4
car2(z2)                                  # left subtree

# ╔═╡ 8b3c2686-3d8b-418c-87d5-43bc5ae958f1
cdr2(z2)                                  # right subtree

# ╔═╡ 86eb1eed-142d-43a6-a582-d435e05e700d
car2(car2(z2))

# ╔═╡ fd737050-0249-4997-a23a-79547a03d124
cdr2(car2(z2))

# ╔═╡ b06e03cc-4846-4d2d-ba38-2654cdbc3fb8
car2(cdr2(z2))

# ╔═╡ cf730065-7796-4ae7-9f94-8c663503741d
cdr2(cdr2(z2))

# ╔═╡ bbccaeb3-48cf-4f65-9aa2-d0de9940e311
md"
---
###### 3.2.5 Output Function $printRat$
(= Transformation of *internal* into *external* form)
"

# ╔═╡ 1248e659-dcdb-442c-859c-3289d5561c6f
printRat(x::Pair)::String = 
	"$(numer2(x))/$(denom2(x))"

# ╔═╡ edd94612-1772-4c7a-b8d5-cf5b4a540487
md"
---
###### 3.2.6 Applications
"

# ╔═╡ febeec0d-b018-446f-a6a7-0ab067f00d94
Pair(2, 3)                   # ==>  '2 => 3'  -->  :)

# ╔═╡ 0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
a2 = cons2(2, 3)

# ╔═╡ 32e3fc67-3872-4a28-bd6b-9cf06bc094ac
car2(a2)

# ╔═╡ e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
cdr2(a2)

# ╔═╡ cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
typeof(1.2)

# ╔═╡ 591027a4-b002-4346-9f2d-64d59d8ca265
try b2 = cons2(1.2, 3) 
catch
	@warn "arguments are not typed as *Signed* or *Pair*"
end # try

# ╔═╡ 4ee29c75-f689-4332-99b9-d7b0951d4487
one_half2 = makeRat2(1, 2)

# ╔═╡ 86b40359-a87d-477e-9615-6b4803fe4fd7
one_third2 = makeRat2(1, 3)

# ╔═╡ d650d480-08ed-478a-8a9f-92cce23ba072
equalRat2(makeRat2(1, 3), makeRat2(2, 6))        # 1/3 == 2/6 ==> true -->  :)

# ╔═╡ 999406e8-787a-4f2b-9805-eed631fc6f54
equalRat2(makeRat2(1, 2), makeRat2(3, 6))

# ╔═╡ 4bbd2664-5846-4487-b91c-be7ff75a4e81
equalRat2(makeRat2(1, 3), makeRat2(3, 6))

# ╔═╡ abf821d6-3f8a-404d-903d-0a4b49ed9d9b
md"
---
##### 3.3 Third *Abstraction Tower*: Data as Structure $Rational$
(*Idiomatic* Julia with types $Signed$, $Pair$, $Rational$, $\%$, and $while$

"

# ╔═╡ 61794b44-f955-4486-8b1e-863dca1082c2
md"
$\begin {array}{c|c|c}
                    &        \text{Abstraction Hierarchy}       &                  \\
\hline
\text{ Abstract}    &           addRat3, subRat3                & \text{level 2}   \\
\text{Operators}    &       mulRat3, divRat3, equalRat3         & \text{Domain}    \\
                    &                printRat                   &                  \\
\hline
\text{Constructor/} &                makeRat3                   & \text{level 1}   \\
\text{Selectors}    &              numer3, denom3               &                  \\
\hline
\text{Constructor/} &                  cons3                    & \text{level 0}   \\
\text{Selectors}    &                car3, cdr3       & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &       dataObject = car \text{//} cdr       & \text{level -1} \\
\text{Selectors} & numerator(dataObject), denominator(dataObject) & \textit{Julia} \\
\hline
\end {array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 3.9**: Third *Abstraction* Tower (= Hierarchy) for *Rational* Number Algebra

"

# ╔═╡ 317b9fa7-4017-4871-8f90-3b0107240f40
md"
---
###### 3.3.1 Arithmetic Operations for Rational Numbers 

*Typed, Abstract* Functions

- *addRat3*
- *subRat3*
- *mulRat3*
- *divRat3*
- *equalRat3*

"

# ╔═╡ 26593de4-f70d-4aa5-86dd-d09bb6544407
function addRat3(x::Rational, y::Rational)::Rational
	x + y
end # function addRat3

# ╔═╡ 6662d041-af9c-472d-b9fe-efe2c4846267
function subRat3(x::Rational, y::Rational)::Rational
	x - y
end # function subRat3

# ╔═╡ 8fc62f98-9a2e-4fae-83b7-a78118b656d3
function mulRat3(x::Rational, y::Rational)::Rational
	x * y
end # function mulRat3

# ╔═╡ f7bd0981-1534-4c80-9697-e019f29c4a3c
function divRat3(x::Rational, y::Rational)::Rational
	x // y
end # function divRat3

# ╔═╡ b25d2465-7452-43e8-b709-06009642076a
function equalRat3(x::Rational, y::Rational)::Bool
	x == y
end # function equalRat3

# ╔═╡ ce97fbfe-0a85-43c6-980f-18da5e795a98
md"
---
###### 3.3.2 Abstract Functions with *Type* and *Constructor* $Rational$

"

# ╔═╡ 6858b169-b9dc-4a23-8dd3-8951033bd311
# idiomatic Julia-code by '÷'
function makeRat3(n::Int, d::Int)::Rational
	n//d
end # function makeRat3

# ╔═╡ 0a935144-2c44-480b-9c6e-53408b972e89
numer3(x::Rational)::Signed = numerator(x::Rational)::Signed

# ╔═╡ 7c2af484-eea8-4c8c-8891-4aa4923298ae
denom3(x::Rational)::Signed = denominator(x::Rational)::Signed

# ╔═╡ 32927d21-4f21-41ff-b90c-21a9c15a7a26
md"
---
###### 3.3.3 Implementing *Pairs* as *Data Type* $Rational$

"

# ╔═╡ ac00349c-9f45-4d03-a7c1-afc28e665b17
md"
---
###### *Multiple* Dispatch: *1st* Method of Function $cons3$
"

# ╔═╡ 47d605b7-ec32-4b72-a329-bf47e7273972
cons3(car::Signed, cdr::Signed)::Rational = car // cdr

# ╔═╡ 6b655605-da68-498f-ab44-5c8772c6058e
md"
---
###### *Multiple* Dispatch: *2nd* Method of Function $cons3$
"

# ╔═╡ 010a8abc-1dd1-490a-8ff9-215d77bf680f
cons3(car::Rational, cdr::Rational) = cons1(car, cdr)

# ╔═╡ 8f437dbf-1c9f-4679-a0ff-b359c888fb76
md"
---
###### *Multiple* Dispatch: *1st* Method of Function $car3$
"

# ╔═╡ 104edf98-0632-4eee-8ca5-75925a9d9553
car3(cons::Rational)::Signed = numerator(cons)::Signed

# ╔═╡ 5ed5e22f-2d9b-4c6d-9df2-746dc2a7fa71
md"
---
###### *Multiple* Dispatch: *2nd* Method of Function $car3$
"

# ╔═╡ e6e6754c-d86e-449f-a82e-03e0ab2a91cb
car3(cons::NamedTuple)::Rational = car1(cons)

# ╔═╡ bf501c0e-2f13-4dcb-bba8-0d7bb6786222
md"
---
###### *Multiple* Dispatch: *1st* Method of Function $cdr3$
"

# ╔═╡ c356aab4-4717-46a7-b041-aa14800a0253
cdr3(cons::Rational)::Signed = denominator(cons)::Signed

# ╔═╡ 81651481-f3e9-44d5-b98d-47c2b95f0c75
md"
---
###### *Multiple* Dispatch: *2nd* Method of Function $cdr3$
"

# ╔═╡ 0cc14570-1928-423e-acf4-18ee0709cbe0
cdr3(cons::NamedTuple)::Rational = cdr1(cons)

# ╔═╡ 3569cd38-88c2-4bb0-a1a7-f9ed02c75db2
md"
---
###### 3.3.4 Naming and Tree Representations
"

# ╔═╡ 3819fdff-3f8c-44c0-b269-9cc77cff93dd
x3 = cons3(1, 2)                      # construction of Pair

# ╔═╡ d3ac0790-b48b-4edd-a009-9c2ba9709e44
typeof(x3)                            # Rational{Int64}

# ╔═╡ a5ad6f20-5fa3-4aae-93c2-33b864501eb4
car3(x3)                              # selection of field 'car' of Rational

# ╔═╡ 5e19bd16-0f0b-42ca-9409-5b069a7107fc
cdr3(x3)                              # selection of field 'cdr' of dataObject

# ╔═╡ 1e5287d6-2742-4a94-a469-6990d959ccee
y3 = cons3(3, 4)                      # construction of dataObject y3

# ╔═╡ 5da24cc2-b835-4358-9d23-e4d98030f6ca
car3(y3)

# ╔═╡ e19bb6a4-bfe9-498c-81bd-63516e3f1f65
cdr3(y3)

# ╔═╡ 37c7ca8a-43a1-4d3d-9214-0b363f2ae07f
let yMax = 5
	#--------------------------------------------------------------------------------
	plot(size=(600, 300), xlim=(-1.5, 8.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromLeftToRight!("y3", "•", 2.0, yMax-2.0;lengthOfLine=4.0)
	plotInvBinaryTree!("3", "4", "•", 4.0, yMax-2.0; widthOfTree=4.0, heightOfTree=1)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ e13f5b30-f52c-4056-bca2-9daf59e950af
md"

**Fig. 3.7** *Binary* Tree Representation of *Rational* $y3 = cons2(3, 4) = (3 \bullet 4)$

"

# ╔═╡ 5ba5b962-a566-43c2-919c-e9519ad20c61
let yMax = 4
	#------------------------------------------------------------------------------
	plot(xlim=(-2.5, 12.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromRightToLeft!("•", "y3", 9.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("x3", "•", 1.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("z3", "•", 2.0, yMax-1.0;lengthOfLine=6.0)
	plotInvBinaryTree!("3", "4", "•", 7.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("•", "•", "•", 5.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ af5f96a1-9284-40c7-8c49-cf0ab4305343
md"
**Fig. 3.8** *Binary* Tree Representation of $z3 \mapsto cons3(x3, y3) = ((1 \bullet 2) \bullet (3 \bullet 4))$

"

# ╔═╡ 390ab7ba-ddb9-4e0b-8bf1-18fdb5ad7db1
z3 = cons3(x3, y3)                        # construction of Rational named z3

# ╔═╡ 8b086ba6-68dc-4c66-a905-b7540de22cb6
typeof(z3)

# ╔═╡ 633c6220-f7c9-4ee4-863f-5954b651c29f
car3(z3)                                  # left subtree

# ╔═╡ e56b1437-10d7-4369-a913-b92b591b0c01
cdr3(z3)                                  # right subtree

# ╔═╡ 3d2a6473-cd6a-4e28-b363-c1e4f33feebf
car3(car3(z3))

# ╔═╡ 3a43372e-6770-4e0d-9c55-c8225a078b1d
cdr3(car3(z3))

# ╔═╡ cd74e06e-4f9e-4c65-b764-d089129eaaae
car3(cdr3(z3))

# ╔═╡ a6bdb95a-b2f9-4f80-8423-459319af5945
cdr3(cdr3(z3))

# ╔═╡ cd6eb206-171e-4d04-abdd-656ac6fc5b9f
md"
---
###### 3.3.5 Output Function $printRat$
(= Transformation of *internal* into *external* form)
"

# ╔═╡ 6d096e3e-3313-4889-aa5b-387e75912d5e
printRat(x::Rational)::String = "$(numer3(x))/$(denom3(x))"

# ╔═╡ 8bba74f5-f038-448e-9459-8b6a945c293d
methods(printRat)

# ╔═╡ 6931655c-b8bc-4efb-bad1-5061a5b63548
printRat(one_half_1)

# ╔═╡ 1d2a90d7-cf23-4cef-b525-f0e0cb77586f
printRat(one_third_1)

# ╔═╡ c85ab30f-22b4-452d-adb0-401dd0609d79
printRat(two_twelves_1)                      # == 1/6 -->with (!) application of gcd

# ╔═╡ 64d8fdee-f7b2-453d-b595-f3d27c69ed20
printRat(makeRat1(120,90))  # ==> 120/90 = 12/9 = 4/3 -->with (!) application of gcd

# ╔═╡ 60367294-bac2-4c34-bddd-fc8c8c3a2f34
printRat(addRat1(one_half_1, one_third_1))      # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 6009d1d7-f87d-440e-bfd5-389f7a6189fe
printRat(subRat1(one_half_1, one_third_1))      # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ d2c09e98-d6b6-43e0-a493-a5c00700b022
printRat(mulRat1(one_half_1, one_third_1))      # 1/2 * 1/3 = 1/6

# ╔═╡ e8dade6c-874e-4926-bdca-0875509f35ff
printRat(divRat1(one_half_1, one_third_1))      # (1/2)/(1/3) = (1*3)/(2*1) = 3/2

# ╔═╡ 5e3ce89e-16cf-41ab-b65b-0693f152d2e6
printRat(makeRat1(355, 113))

# ╔═╡ 97c12566-f149-46c0-bb00-55686029f523
methods(printRat)

# ╔═╡ 451f4fcd-3cb6-400b-b7eb-b80cb6a5a712
printRat(one_half2)

# ╔═╡ db489898-bef8-4562-adf7-fab1f56e566e
printRat(one_third2)

# ╔═╡ 02fe4860-7fd6-453a-8eb2-a4654d7dd77b
printRat(addRat2(one_half2, one_third2))         # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 04a336e5-b3d0-4c0c-9275-1ad23a1f19e2
printRat(subRat2(one_half2, one_third2))         # 1/2 - 1/3 = 3/6 + 2/6 = 1/6

# ╔═╡ ed2ac17e-497e-4b96-ba9b-ae7d4433c731
printRat(mulRat2(one_half2, one_third2))         # 1/2 * 1/3 = 1/6

# ╔═╡ 55360263-ea18-4987-98c6-396a88afc60e
printRat(divRat2(one_half2, one_third2))         # 1/2 / 1/3 = 1/2 * 3/1 = 3/2

# ╔═╡ 985720fb-c4a2-45cd-9094-6d9363deeca1
printRat(makeRat2(120,90))                       # 120/90 = 4/3 -->  :)

# ╔═╡ cbb3d0bd-bf78-4f6b-b332-2289393697ec
methods(printRat)                 # 3 methods: exploition of multiple dispatch

# ╔═╡ 846b7522-8088-49b4-8848-9f0031e1004e
md"
---
###### 3.3.6 Applications
"

# ╔═╡ 9672253e-c0be-4da5-9c1b-6882ce5f65c3
one_half3 = makeRat3(1, 2)

# ╔═╡ ed140d1c-110e-4fcb-ba43-807b59ac30ef
printRat(one_half3)

# ╔═╡ ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
one_third3 = makeRat3(1, 3)

# ╔═╡ ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
printRat(one_third3)

# ╔═╡ dc14d933-62ac-4cf7-8563-71fda97afc9a
printRat(addRat3(one_half3, one_third3))

# ╔═╡ 47771613-e613-497b-a020-f825a51b012d
printRat(subRat3(one_half3, one_third3))

# ╔═╡ 1a32f5c0-e644-44bc-9b0a-f47905e98f1d
printRat(mulRat3(one_half3, one_third3))

# ╔═╡ 43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
printRat(divRat3(one_half3, one_third3))

# ╔═╡ 1349941f-f280-47f2-814b-32b3b8ac4e4c
equalRat3(makeRat3(1, 3), makeRat3(2, 6))

# ╔═╡ 7242424b-c8da-4452-b104-b3a2411fc0df
equalRat3(makeRat3(1, 2), makeRat3(3, 6))

# ╔═╡ b202fbe1-f987-4e62-8f6f-3af4d3ca1048
equalRat3(makeRat3(1, 3), makeRat3(3, 6))

# ╔═╡ b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
printRat(addRat3(one_third3, one_third3))

# ╔═╡ f38f0544-6113-4ed9-af22-d5d205078492
printRat(makeRat3(120, 90))

# ╔═╡ 9e224adb-b553-40ed-8683-39337bfda2ae
md"
---
##### 3.4 Fourth *Abstraction Tower*: *Direct* Data Access to $Rational$
(*Idiomatic* Julia with types $Signed$, $Pair$, $Rational$, $\%$, and $while$

"

# ╔═╡ e44ece8f-5042-4c0f-a8a2-791622867ad5
md"
$\begin {array}{c|c|c}
                    &        \text{Abstraction Hierarchy}       &                  \\
\hline
\text{ Abstract}    &                                           & \text{level 2}   \\
\text{Operators} &+\;\;\;\;\;\;\; -\;\;\;\;\; *\;\;\;\;\; /\;\;\;\;&\text{Domain}  \\
\hline
\text{Constructor/} &                                           & \text{level 1}   \\
\text{Selectors}    &                                           &                  \\
\hline
\text{Constructor/} &                                           & \text{level 0}   \\
\text{Selectors}    &                                & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &    dataObject = //(numerator, denominator)  & \text{level -1}  \\
\text{Selectors} & numerator(dataObject), denominator(dataObject) & \textit{Julia} \\
\hline
\end {array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

**Fig. 3.9**: Fourth *Degenerate* Abstraction Hierarchy for *Rational* Number Algebra 

"

# ╔═╡ 6b36e481-d44c-468b-b020-ff7219eb6625
md"
##### 3.4.1 Applications (pure Julia-Rational-Operators)
"

# ╔═╡ 20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
one_half_4 = //(1, 2)            # prefix use of '//'

# ╔═╡ 4691017a-0d04-4d94-a874-c78625a49c92
one_half_4 == 1 // 2             # infix

# ╔═╡ 522016b4-5f42-4cf9-acd7-67afd8116d90
one_third_4 = //(1, 3)

# ╔═╡ 4c25c782-decc-4d3b-bc01-31577218c6a7
one_half_4 + one_third_4         # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ da84aea9-d17e-4156-979d-8894066d3e38
one_half_4 - one_third_4         # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
one_half_4 * one_third_4         # 1/2 * 1/3 = 1/6

# ╔═╡ 8cc968c6-5364-4430-9449-aeafd876d567
one_half_4 / one_third_4         # 1/2 / 1/3 = 1/2 * 3/1 = 3/2

# ╔═╡ d88f2af4-e182-4c90-ab88-694834485bb7
1 // 3 == 2 // 6 == //(2, 6)

# ╔═╡ dc47a501-9c50-4e5d-bcea-d2fe9609a76c
1 // 3 == 3 // 6 == //(3, 6)

# ╔═╡ 14c8d0af-5eb0-4d7c-b498-8b30e0724490
one_third_4 + one_third_4

# ╔═╡ 8bd0c86b-fe82-4221-9d4a-66cb192b5649
one_third_4 + one_third_4 == //(2, 3) == 2//3

# ╔═╡ 03a8961e-031e-4671-9bd5-c35c6c603c19
120 // 90

# ╔═╡ a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
md"
###### [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ d44cb419-7a01-4236-b561-a03892cfcead
pi_approximation_4 = 355//113

# ╔═╡ 920121bf-7e84-4873-a32e-3b9ccbed84c4
pi_approx_4 = convert(Float64, pi_approximation_4)

# ╔═╡ 118ba1f9-8643-43c8-b5a0-18b71a61547d
error = abs(pi_approx_4 - π)

# ╔═╡ 3e646cf0-8b6e-4633-b463-e63a212d04aa
md"
---
##### 4. Summary
We have presented four different approaches for dealing with rational numbers. SICP only provides the template for the first solution. Each approach is realized in an *abstraction tower* (= abstraction hierarchy). These towers differ only in their *base* levels, which implement *pairs* of *numerators* and *denominators*. The fourth tower has only two levels. The base level consists only of the *constructor* //. The top level contains the *operations* of the *arithmetic* domain. Here we can use the usual arithmetic *operators* $+,-,∗,/,==$.

"

# ╔═╡ cffadb80-3e20-4600-8419-8d6a59646471
md"
---
##### 5. References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996, last vsit 2025/04/24
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://web.mit.edu/6.001/6.037/sicp.pdf), Cambridge, Mass.: MIT Press, (2/e), 2016, last visit 2025/04/24
- **Allen, J.**, *The Anatomy of Lisp*, New York: McGraw Hill, 1978
- **McCarthy, J., Abrahams, P.W., Edwards, D.J., Hart, T.P., & Levin, M.I.**, *LISP 1.5 Programmer's Manual*, Cambridge, Mass.: The MIT Press, 1965, 1979(11/e) 
- **Wikipedia**; [*Algebraic Data Type (ADT)*](https://en.wikipedia.org/wiki/Algebraic_data_type); last visit 2025/04/25
- **Wikipedia**; [*M-expression*](https://en.wikipedia.org/wiki/M-expression), last visit 2023/02/22
- **Wikipedia**; [*S-expression*](https://en.wikipedia.org/wiki/S-expression), last visit 2023/02/22
- **Wikipedia**; [*Approximation to π*](https://en.wikipedia.org/wiki/Approximations_of_%CF%80), last visit 2022/08/27
"

# ╔═╡ 965557ac-81b4-4cf7-a2e5-3b6efff094be
md"
---
##### end of ch. 2.1.1
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
Latexify = "~0.15.21"
Plots = "~1.35.8"
Pluto = "~0.20.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "2f65cee4d29daf8b2dfa76cf2539d1a31994cb79"

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
git-tree-sha1 = "bf2e6a47b70dfb5d103f300ef83d950239f9fa50"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.2"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

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

[[deps.Formatting]]
deps = ["Logging", "Printf"]
git-tree-sha1 = "fb409abab2caf118986fc597ba84b50cbaf00b87"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.3"

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
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

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

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

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
git-tree-sha1 = "1d4015b1eb6dc3be7e6c400fbd8042fe825a6bac"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.10"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "8c57307b5d9bb3be1ff2da469063628631d4d51e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.21"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    DiffEqBiologicalExt = "DiffEqBiological"
    ParameterizedFunctionsExt = "DiffEqBase"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    DiffEqBiological = "eb300fae-53e8-50a0-950c-e21f52c2b7e0"
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
git-tree-sha1 = "ff3b4b9d35de638936a525ecd36e86a8bb919d11"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.0+0"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

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
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

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
git-tree-sha1 = "ad31332567b189f508a3ea8957a2640b1147ab00"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+1"

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
git-tree-sha1 = "44f6c1f38f77cafef9450ff93946c53bd9ca16ff"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.2"

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
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "b434dce10c0290ab22cb941a9d72c470f304c71d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.8"

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

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

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

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

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

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

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
git-tree-sha1 = "807c226eaf3651e7b2c468f687ac788291f9a89b"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.3+0"

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
git-tree-sha1 = "6fcc21d5aea1a0b7cce6cab3e62246abd1949b86"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.0+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "984b313b049c89739075b8e2a94407076de17449"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.2+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a1a7eaf6c3b5b05cb903e35e8372049b107ac729"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.5+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "b6f664b7b2f6a39689d822a6300b14df4668f0f4"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.4+0"

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
git-tree-sha1 = "dbc53e4cf7701c6c7047c51e17d6e64df55dca94"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+1"

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
git-tree-sha1 = "ab2221d309eda71020cdda67a973aa582aa85d69"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+1"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

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

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6e50f145003024df4f5cb96c7fce79466741d601"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.56.3+0"

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

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

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
# ╟─e8c1f880-0278-11ec-2538-13bb2f14d606
# ╟─55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
# ╟─0ba0f38f-f2cd-47c2-8112-07f82cd34936
# ╟─98d28306-c11d-4559-b8a4-1d196e12fcca
# ╠═1111f5e5-cb01-4634-a014-e3c9caa3a15f
# ╟─1a52e675-5297-45da-97ca-a7b859d66c6d
# ╟─882c5c98-4339-4648-be77-82f5dd4f7237
# ╟─d4e48294-c66c-4fa3-9586-89fb825a4ee8
# ╟─f642fc8d-c007-4173-9edc-8ebfb621095e
# ╟─d2d4dd60-f2e4-421c-80cd-63fb61faf31c
# ╟─a9130eeb-2b28-41e5-8674-9abee99c8401
# ╟─dc723ee4-97ce-41a3-88b0-49ccb31c289e
# ╠═ca75c0f7-2e85-4436-8544-9b19aa0f57a8
# ╟─68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
# ╠═a181310f-1f46-43b2-8702-a8a60308ccfe
# ╟─bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
# ╠═778e12ad-bfe7-4f02-a946-894249fe2375
# ╟─0875ee4d-e127-4140-a863-04c3a02c38a5
# ╠═dce13d9a-7ffd-475a-84de-7826a1198f38
# ╟─f74ced3c-487c-4428-bcfc-cc69e5416227
# ╠═bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
# ╟─7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
# ╟─680c5ec0-6cf2-4b0c-a005-751ef8a7e568
# ╠═7ff3b4a0-e00b-424f-8118-897019d0fc20
# ╟─810b1eca-eac7-49cb-a34f-8328ea432824
# ╠═df37be85-589a-46aa-a14c-8ab67c461ae9
# ╟─764ec0e3-66c3-4a67-9473-95380e11250b
# ╠═193ae321-0f26-44cc-a48f-1a1b9bc71af8
# ╠═d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
# ╟─08ede030-fb83-4337-8c37-f346b1b7ebc0
# ╟─80ed0fe4-9f5b-4521-8189-f7f1273706fb
# ╟─ca947e77-0bd0-4ac3-b44d-df998ea557a8
# ╟─8efe03bc-3fce-41d4-b55d-f899984b1068
# ╟─b068c8b6-7cfd-47c0-9e87-ee4cd7537bce
# ╠═3b7faab0-b8e0-4bea-894f-16fd35e5727f
# ╟─7f3eefe6-e57a-40b3-96cc-056dcd77346d
# ╠═80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
# ╟─470be70d-8a49-45c6-a624-98535dddb289
# ╠═1c695d3b-c88e-4227-8aa1-e88149a4f9f4
# ╟─9de2fcec-e581-41b6-a09d-0c27b033106e
# ╠═3fba0329-19ac-485a-a56d-ee64ae0e3573
# ╠═44d3380a-b2ab-43e1-8f03-a14a9599fac0
# ╠═44017d8b-476e-4e9c-abac-229e9a2e85d1
# ╠═51732672-ee53-46e7-85bf-217f531867cc
# ╠═a1587038-c11d-4b4b-8436-b098b61f1077
# ╠═118b16a3-093f-4b39-823b-ac167da69615
# ╠═fb4ecf01-1361-43c5-854d-8c83969a2e60
# ╟─6fa45a52-31fd-44c6-9928-4a75a7feccc0
# ╟─6a584664-cda8-41c1-8bfe-2b7d5b5e1e28
# ╟─099f789b-9fdd-4643-8c6e-b5054af12736
# ╟─d1cd6289-c53d-4561-9895-4958c3e150b5
# ╠═132232a8-495f-4f2c-a08a-da4b898f606b
# ╠═768b4543-6d34-4af7-9ee1-6120a33a169d
# ╠═8b990c96-d5e2-4e77-ae73-eae3bc399f9d
# ╠═4e7da88e-e73e-4d15-bd5f-b1eed925322d
# ╠═b13bdc8a-1954-4ade-bfce-26e9e14aef5f
# ╠═9b7d9d52-77c6-4328-8018-3b1e40fb9558
# ╠═fb8cfd69-4a4a-4a0d-b2b4-7ffc325ce9b5
# ╟─61340177-3808-4a2b-906f-51b801178c6f
# ╠═172db576-f756-4d62-94c3-128c6ac4f847
# ╠═8bba74f5-f038-448e-9459-8b6a945c293d
# ╟─a9341f5b-8b06-4994-ba6b-58070485c336
# ╠═9b1a0332-0170-424b-be4d-abba0c042ff6
# ╠═5e19e77d-ccea-4825-807d-5a278d762978
# ╠═6931655c-b8bc-4efb-bad1-5061a5b63548
# ╠═cafada61-82c1-4231-bcd8-9887df2be87c
# ╠═1d2a90d7-cf23-4cef-b525-f0e0cb77586f
# ╠═e20d52b3-204c-4105-a362-2b9e66fe22f9
# ╠═c85ab30f-22b4-452d-adb0-401dd0609d79
# ╠═64d8fdee-f7b2-453d-b595-f3d27c69ed20
# ╠═63d09ac2-193d-49dc-9eff-d5c14f973627
# ╠═60367294-bac2-4c34-bddd-fc8c8c3a2f34
# ╠═6009d1d7-f87d-440e-bfd5-389f7a6189fe
# ╠═d2c09e98-d6b6-43e0-a493-a5c00700b022
# ╠═e8dade6c-874e-4926-bdca-0875509f35ff
# ╠═69facaff-5c1f-4c8e-a436-81e8f9cd73b9
# ╠═45772e1e-aa83-46cd-add7-4f977f58dff0
# ╠═d3d1980c-00f3-4d04-abe5-8705f61b3459
# ╟─a861fc71-5a96-43b4-9a8f-94a603d2cb3b
# ╠═5e3ce89e-16cf-41ab-b65b-0693f152d2e6
# ╠═aa7ea22e-f330-427e-9d89-408003e6b8f2
# ╠═bf4034ad-07ff-4400-8aba-3b855fc43a5c
# ╟─03d4c7b4-3618-4d69-ad14-a680758955f9
# ╟─20fa866b-a9d2-4446-a57a-c01fe145aaac
# ╟─c68ae171-e6cc-4ef7-970e-1555f76241f3
# ╠═76e3a4bc-fde2-4440-96c1-c492cc120db0
# ╠═402d8963-26bc-4db2-b94b-ba4334e1d8fd
# ╠═09901068-bf38-4392-ab19-66a44d65344d
# ╠═555e6212-22bd-4d0e-b221-edfe32f043f5
# ╠═afe55885-aba6-4cbc-af2c-23d15bbbf6f5
# ╟─d84101ea-7172-4e1f-9929-1a23acd7a7c7
# ╟─b4c9a74b-5a49-452e-bbf0-44826cd92e46
# ╟─f46b3ac9-4ae4-42ba-9ef9-6516c96b013c
# ╟─48d6a6b2-aca3-44dc-af73-ede92f0dbc87
# ╠═3498e844-931f-4d46-a9aa-b9a2d3b892e7
# ╟─4e179b9f-021e-4891-8e27-7fa36b827fcf
# ╠═7f5b9164-07c2-4ae1-888d-f601fa9d286c
# ╠═3ca05b52-413f-46aa-9fd7-659227dccbd7
# ╟─cc592f32-8785-4735-badd-de3903c20f05
# ╠═dd8f85a7-b11a-4502-aab5-55002104447f
# ╟─c7a0b1d2-7b73-44ef-97ce-ef76deb89120
# ╠═0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# ╟─79816302-b87c-4653-8bcb-2a0567f9ad34
# ╠═10aa3d47-ca38-4aa4-a9b5-689d2dad3b13
# ╠═1fddd3ae-5da7-4a32-a53e-077b8f37509c
# ╠═b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
# ╟─62f3e34c-d07d-4b8a-8e49-65e45fe58605
# ╠═ea9117b0-1775-4ae0-9335-1e2e32b78c2d
# ╠═b928c2cb-cc3d-4efd-ad83-7aaa1b914138
# ╠═c37a487d-1176-4680-8798-be62de8514d3
# ╠═d64203fa-7400-4587-bc56-f497ded5fa97
# ╠═2dc241a2-900b-4e67-a0c5-921f491400ac
# ╠═bdc6f5ea-4a76-4b8d-98c0-a043fb677514
# ╠═e33097fd-50f9-4f8d-9941-75f0ee588d21
# ╟─9a4ea235-19bf-45be-9740-1ff03747b71c
# ╟─2b81b557-5aa5-409d-b9da-9f5cdf88c0a1
# ╟─0e482210-86e3-42fb-9803-4c0332d9ee0e
# ╟─b1a429ca-eeaf-4821-ab92-8bb5dc9c1e48
# ╠═85aee7a8-500e-4d03-af9f-388370f9bab7
# ╠═24fd8f05-c62c-4aee-837c-bcd0c2f5e2e4
# ╠═8b3c2686-3d8b-418c-87d5-43bc5ae958f1
# ╠═86eb1eed-142d-43a6-a582-d435e05e700d
# ╠═fd737050-0249-4997-a23a-79547a03d124
# ╠═b06e03cc-4846-4d2d-ba38-2654cdbc3fb8
# ╠═cf730065-7796-4ae7-9f94-8c663503741d
# ╟─bbccaeb3-48cf-4f65-9aa2-d0de9940e311
# ╠═1248e659-dcdb-442c-859c-3289d5561c6f
# ╠═97c12566-f149-46c0-bb00-55686029f523
# ╟─edd94612-1772-4c7a-b8d5-cf5b4a540487
# ╠═febeec0d-b018-446f-a6a7-0ab067f00d94
# ╠═0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
# ╠═32e3fc67-3872-4a28-bd6b-9cf06bc094ac
# ╠═e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
# ╠═cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
# ╠═591027a4-b002-4346-9f2d-64d59d8ca265
# ╠═4ee29c75-f689-4332-99b9-d7b0951d4487
# ╠═451f4fcd-3cb6-400b-b7eb-b80cb6a5a712
# ╠═86b40359-a87d-477e-9615-6b4803fe4fd7
# ╠═db489898-bef8-4562-adf7-fab1f56e566e
# ╠═02fe4860-7fd6-453a-8eb2-a4654d7dd77b
# ╠═04a336e5-b3d0-4c0c-9275-1ad23a1f19e2
# ╠═ed2ac17e-497e-4b96-ba9b-ae7d4433c731
# ╠═55360263-ea18-4987-98c6-396a88afc60e
# ╠═d650d480-08ed-478a-8a9f-92cce23ba072
# ╠═999406e8-787a-4f2b-9805-eed631fc6f54
# ╠═4bbd2664-5846-4487-b91c-be7ff75a4e81
# ╠═985720fb-c4a2-45cd-9094-6d9363deeca1
# ╟─abf821d6-3f8a-404d-903d-0a4b49ed9d9b
# ╟─61794b44-f955-4486-8b1e-863dca1082c2
# ╟─317b9fa7-4017-4871-8f90-3b0107240f40
# ╠═26593de4-f70d-4aa5-86dd-d09bb6544407
# ╠═6662d041-af9c-472d-b9fe-efe2c4846267
# ╠═8fc62f98-9a2e-4fae-83b7-a78118b656d3
# ╠═f7bd0981-1534-4c80-9697-e019f29c4a3c
# ╠═b25d2465-7452-43e8-b709-06009642076a
# ╟─ce97fbfe-0a85-43c6-980f-18da5e795a98
# ╠═6858b169-b9dc-4a23-8dd3-8951033bd311
# ╠═0a935144-2c44-480b-9c6e-53408b972e89
# ╠═7c2af484-eea8-4c8c-8891-4aa4923298ae
# ╟─32927d21-4f21-41ff-b90c-21a9c15a7a26
# ╟─ac00349c-9f45-4d03-a7c1-afc28e665b17
# ╠═47d605b7-ec32-4b72-a329-bf47e7273972
# ╟─6b655605-da68-498f-ab44-5c8772c6058e
# ╠═010a8abc-1dd1-490a-8ff9-215d77bf680f
# ╟─8f437dbf-1c9f-4679-a0ff-b359c888fb76
# ╠═104edf98-0632-4eee-8ca5-75925a9d9553
# ╟─5ed5e22f-2d9b-4c6d-9df2-746dc2a7fa71
# ╠═e6e6754c-d86e-449f-a82e-03e0ab2a91cb
# ╟─bf501c0e-2f13-4dcb-bba8-0d7bb6786222
# ╠═c356aab4-4717-46a7-b041-aa14800a0253
# ╟─81651481-f3e9-44d5-b98d-47c2b95f0c75
# ╠═0cc14570-1928-423e-acf4-18ee0709cbe0
# ╟─3569cd38-88c2-4bb0-a1a7-f9ed02c75db2
# ╠═3819fdff-3f8c-44c0-b269-9cc77cff93dd
# ╠═d3ac0790-b48b-4edd-a009-9c2ba9709e44
# ╠═a5ad6f20-5fa3-4aae-93c2-33b864501eb4
# ╠═5e19bd16-0f0b-42ca-9409-5b069a7107fc
# ╠═1e5287d6-2742-4a94-a469-6990d959ccee
# ╠═5da24cc2-b835-4358-9d23-e4d98030f6ca
# ╠═e19bb6a4-bfe9-498c-81bd-63516e3f1f65
# ╟─37c7ca8a-43a1-4d3d-9214-0b363f2ae07f
# ╟─e13f5b30-f52c-4056-bca2-9daf59e950af
# ╟─5ba5b962-a566-43c2-919c-e9519ad20c61
# ╟─af5f96a1-9284-40c7-8c49-cf0ab4305343
# ╠═390ab7ba-ddb9-4e0b-8bf1-18fdb5ad7db1
# ╠═8b086ba6-68dc-4c66-a905-b7540de22cb6
# ╠═633c6220-f7c9-4ee4-863f-5954b651c29f
# ╠═e56b1437-10d7-4369-a913-b92b591b0c01
# ╠═3d2a6473-cd6a-4e28-b363-c1e4f33feebf
# ╠═3a43372e-6770-4e0d-9c55-c8225a078b1d
# ╠═cd74e06e-4f9e-4c65-b764-d089129eaaae
# ╠═a6bdb95a-b2f9-4f80-8423-459319af5945
# ╟─cd6eb206-171e-4d04-abdd-656ac6fc5b9f
# ╠═6d096e3e-3313-4889-aa5b-387e75912d5e
# ╠═cbb3d0bd-bf78-4f6b-b332-2289393697ec
# ╟─846b7522-8088-49b4-8848-9f0031e1004e
# ╠═9672253e-c0be-4da5-9c1b-6882ce5f65c3
# ╠═ed140d1c-110e-4fcb-ba43-807b59ac30ef
# ╠═ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
# ╠═ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
# ╠═dc14d933-62ac-4cf7-8563-71fda97afc9a
# ╠═47771613-e613-497b-a020-f825a51b012d
# ╠═1a32f5c0-e644-44bc-9b0a-f47905e98f1d
# ╠═43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
# ╠═1349941f-f280-47f2-814b-32b3b8ac4e4c
# ╠═7242424b-c8da-4452-b104-b3a2411fc0df
# ╠═b202fbe1-f987-4e62-8f6f-3af4d3ca1048
# ╠═b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
# ╠═f38f0544-6113-4ed9-af22-d5d205078492
# ╟─9e224adb-b553-40ed-8683-39337bfda2ae
# ╟─e44ece8f-5042-4c0f-a8a2-791622867ad5
# ╟─6b36e481-d44c-468b-b020-ff7219eb6625
# ╠═20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
# ╠═4691017a-0d04-4d94-a874-c78625a49c92
# ╠═522016b4-5f42-4cf9-acd7-67afd8116d90
# ╠═4c25c782-decc-4d3b-bc01-31577218c6a7
# ╠═da84aea9-d17e-4156-979d-8894066d3e38
# ╠═f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
# ╠═8cc968c6-5364-4430-9449-aeafd876d567
# ╠═d88f2af4-e182-4c90-ab88-694834485bb7
# ╠═dc47a501-9c50-4e5d-bcea-d2fe9609a76c
# ╠═14c8d0af-5eb0-4d7c-b498-8b30e0724490
# ╠═8bd0c86b-fe82-4221-9d4a-66cb192b5649
# ╠═03a8961e-031e-4671-9bd5-c35c6c603c19
# ╟─a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
# ╠═d44cb419-7a01-4236-b561-a03892cfcead
# ╠═920121bf-7e84-4873-a32e-3b9ccbed84c4
# ╠═118ba1f9-8643-43c8-b5a0-18b71a61547d
# ╟─3e646cf0-8b6e-4633-b463-e63a212d04aa
# ╟─cffadb80-3e20-4600-8419-8d6a59646471
# ╟─965557ac-81b4-4cf7-a2e5-3b6efff094be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
