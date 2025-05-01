### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 38627173-e982-4047-bd77-6fe4c654f249
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
======================================================================================
##### SICP: [2.1.2 Abstraction Barriers](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e2) (... with *Multiple Dispatch*)

###### file: PCM20210821\_SICP\_2.1.2\_AbstractionBarriers.jl

###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/05/01 ***
======================================================================================
"

# ╔═╡ 55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
md"
---
##### 0. Introduction

In 2.1.1 we presented *three* abstraction towers. Each tower was motivated by a *different* way in constructing a *pair* of *integers*

- as a data object of type $NamedTuple$
- as a data object of type $Pair$
- as a data object of type $Rational.$

In this chapter we exploit *abstraction barriers* and Julia's *multiple dispatch* characteristic. So all *abstract* functions *above* the abstraction barrier in the *domain* (*level 2*: $addRat, subRat, mulRat, divRat$, and $equalRat$) and *selectors* (*level 1*: $numer, denom$) are callable *without* dealing with *concrete* types. 

This is achieved by implementing several *concrete*, *typed methods* for each *abstract function*. This means that a *function call* is *dispatched* towards the matching method. All methods *below* the abstraction barrier are *concrete* and *type dependent*. These methods include $makeRat1, makeRat2, makeRat3$ and all other methods *below* in the *abstraction hierarchy* (Fig. 2.1.2.2)

The overall picture is displayed in Fig. 2.1.2.1 and Fig. 2.1.2.2.
"

# ╔═╡ ac6e9c0b-74bc-4678-88c7-e0324fb08c74
md"
---
##### 1. Topics
- *function*
- *method*
- *multiple dispatch*
- *type* $Bool$
- [*overloading*](https://en.wikipedia.org/wiki/Function_overloading) of operators
"

# ╔═╡ e97e2c65-766d-4e02-987a-99ddece88f85
md"
---
##### 2. Libraries and Service Functions
###### 2.1 Libraries

"

# ╔═╡ 54d411b7-abc4-46e0-9a80-edb6be2943b3
md"
---
###### 2.2 Service Functions
"

# ╔═╡ 61340177-3808-4a2b-906f-51b801178c6f
md"
###### Output Methods $printRat1, printRat2, printRat3$ of Function $printRat$
The methods of $printRat$ map the *internal* form of *data object* to their *external* form.

"

# ╔═╡ 2b87595b-9491-4ebe-acb9-1ab7d43c4678
md"
---
##### 3. Abstraction Hierarchy Exploiting *Multiple Dispatch*
(SICP-Scheme-like *functional*, mostly *un*typed Julia)

We exploit *multiple dispatch* for the *functions* $addRat,subRat,mulRat,divRat,equalRat$ which are *domain-specific* *arithmetic operators* for *rational* numbers in *level 2*. The same characteric is true for the *selectors* in *level *1. These *functions* are called [*overloaden*](https://en.wikipedia.org/wiki/Function_overloading).

This is in contrast to the *constructors* in the same level. These constructors *depend* on the *type* of the chosen *data object*. So we have to implement three *constructor methods* $makeRat\text{1-3}$. 

These constructors are the *entry point* for the *type chain* in the following *dynamic* computational process. Beside these *all* methods below the constructors $makeRat\text{1-3}$ are dependent on the *type* of *data objects*. This is a *static* characteristic.

"

# ╔═╡ a27e5207-ffb7-4f91-ba46-2006be39fd81
md"
$\begin {array}{c|c|c}
                    & \text{Abstraction Hierarchy}              &                  \\
\hline
\text{Arithmetic}   &                                           & \text{level 2}   \\
\text{Operators} & addRat,subRat,mulRat,divRat,equalRat & \text{multiple dispatch} \\
\hline
\text{Selectors/}   &          numer , denom            & \text{multiple dispatch} \\
\text{Constructor}  &      makeRat\text{1-3}                    & \text{level 1}   \\
\hline
\text{Constructor/} &                cons\text{1-3}             & \text{level 0}   \\
\text{Selectors}    &       car\text{1-3} , cdr\text{1-3}     & \text{Scheme-like} \\
\hline
\text{Constructor/} &    dataObject = (car = ... , cdr = ...)   & \text{level -1}  \\
\text{Selectors}    &      dataObject.car, dataObject.cdr       & \text{Julia}     \\
\hline
\text{Constructor/} & dataObject = Pair(first: ... , second: ...) & \text{level -1}\\
\text{Selectors}    & dataObject.first, dataObject.second       & \text{Julia}     \\
\hline
\text{Constructor/} &          dataObject = car // cdr          & \text{level -1}  \\
\text{Selectors}   & numerator(dataObject), denominator(dataObject) & \text{Julia} \\
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
$\;$
$\;$

**Fig. 2.1.2.1** Abstraction Hierarchy for Implementing Rational Number Algebra (cf. Fig. 2.1, SICP, 1996, p.88 or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e2))

"

# ╔═╡ d1ce04e2-d2df-4654-83be-1c037993ea2c
md"
Careful inspection of Fig. 2.1.2.1 reveals that it must be possible to compile the Scheme-like operators of level *0* *out* so that we can reduce the number of levels by *1*. To this end *methods* of level *1* have to be grounded in *methods* of level *-1* instead of *methods* of level *0*.
"

# ╔═╡ e9bddc5e-4ba7-47f3-9d04-bb1f7755c186
md"
$\begin {array}{c|c|c}
                    & \text{Abstraction Hierarchy}              &                  \\
\hline
\text{Arithmetic}   &                                           & \text{level 2}   \\
\text{Operators} & addRat,subRat,mulRat,divRat,equalRat & \text{multiple dispatch} \\
\hline
\text{Selectors/}   &          numer , denom            & \text{multiple dispatch} \\
\text{Constructor}  &      makeRat\text{1-3}                    & \text{level 1}   \\
\hline
\text{Constructor/} &                                           & \text{level 0}   \\
\text{Selectors}    &                                         & \text{Scheme-like} \\
\hline
\text{Constructor/} &    dataObject = (car = ... , cdr = ...)   & \text{level -1}  \\
\text{Selectors}    &      dataObject.car, dataObject.cdr       & \text{Julia}     \\
\hline
\text{Constructor/} & dataObject = Pair(first: ... , second: ...) & \text{level -1}\\
\text{Selectors}    & dataObject.first, dataObject.second       & \text{Julia}     \\
\hline
\text{Constructor/} &          dataObject = car // cdr          & \text{level -1}  \\
\text{Selectors}   & numerator(dataObject), denominator(dataObject) & \text{Julia} \\
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
$\;$
$\;$

**Fig. 2.1.2.2** *Reduced* Abstraction Hierarchy for Implementing Rational Number Algebra (cf. Fig. 2.1, SICP, 1996, p.88 or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e2))

"

# ╔═╡ d4e48294-c66c-4fa3-9586-89fb825a4ee8
md"
---
##### 3.1 Level 2: Multiple Dispatch Arithmetic Functions
The following *functions* are [*overloaden*](https://en.wikipedia.org/wiki/Function_overloading). 

- *addRat*   with 9 *methods* 
- *subRat*   with 9 *methods*
- *mulRat*   with 9 *methods*
- *divRat*   with 9 *methods*
- *equalRat* with 9 *methods*

"

# ╔═╡ dc723ee4-97ce-41a3-88b0-49ccb31c289e
md"
---
###### Addition

$+\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$

$\;$

$x+y = \frac{n_x}{d_x}+\frac{n_y}{d_y}= \frac{n_x d_y + n_y d_x}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ 152b7e64-4ea3-45c8-980f-20fabd582f99
md"
---
$addRat_{1st\ method}: NamedTuple{(:car, :cdr)} \times NamedTuple{(:car, :cdr)} \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ a924f831-9f00-48c4-b426-952f949afc00
md"
---
$addRat_{2nd\ method}: NamedTuple{(:car, :cdr)} \times Pair \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 44a76d47-e90f-4eff-b10e-2e4a919d6758
md"
---
$addRat_{3rd\ method}: NamedTuple{(:car, :cdr)} \times Rational \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 196b5747-9cb3-43ac-9adf-8915cf22e521
md"
---
$addRat_{4th\ method}: Pair \times NamedTuple{(:car, :cdr)} \rightarrow Pair$

$\;$

"

# ╔═╡ f540c73a-5727-414e-a1d2-554a408d1bb7
md"
---
$addRat_{5th\ method}: Pair \times Pair \rightarrow Pair$

$\;$

"

# ╔═╡ 7e7feddd-31f8-46c4-b377-4affdec7c42a
md"
---
$addRat_{6th\ method}: Pair \times Rational \rightarrow Pair$

$\;$

"

# ╔═╡ 81244844-d8ab-498b-afee-84cf663a5af3
md"
---
$addRat_{7th\ method}: Rational \times NamedTuple{(:car, :cdr)} \rightarrow Rational$

$\;$

"

# ╔═╡ e679c12d-f4d9-4c1d-aade-6802c8b01234
md"
---
$addRat_{8th\ method}: Rational \times Pair \rightarrow Rational$

$\;$

"

# ╔═╡ a1d2079d-e8ec-4dba-9bab-666436b725bc
md"
---
$addRat_{9th\ method}: Rational \times Rational \rightarrow Rational$

$\;$

"

# ╔═╡ b901e798-6587-4452-bfc1-fe7895a13996
function addRat(x::Rational,                             # 3 - 3
				y::Rational)::Rational
	x + y
end # method addRat

# ╔═╡ 68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
md"
---
###### Subtraction

$-\;\; : \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$

$\;$

$x-y = \frac{n_x}{d_x}-\frac{n_y}{d_y}= \frac{n_x d_y - n_y d_x}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ 1b95ab13-e2e7-4ea7-83c0-bc8c4ca1d2e7
md"
---
$subRat_{1st\ method}: NamedTuple{(:car, :cdr)} \times NamedTuple{(:car, :cdr)} \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ d1b30696-2026-4393-adb2-efeb10cc09ab
md"
---
$subRat_{2nd\ method}: NamedTuple{(:car, :cdr)} \times Pair \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 014c61cd-7da6-487d-b122-0f44b65fc037
md"
---
$subRat_{3rd\ method}: NamedTuple{(:car, :cdr)} \times Rational \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 94673bca-56d7-41f7-9d04-22048435e648
md"
---
$subRat_{4th\ method}: Pair \times NamedTuple{(:car, :cdr)} \rightarrow Pair$

$\;$

"

# ╔═╡ d5517035-6410-4c48-abf7-c128e519530b
md"
---
$subRat_{5th\ method}: Pair \times Pair \rightarrow Pair$

$\;$

"

# ╔═╡ 9488a987-9987-49cc-869c-5f399e7c41b3
md"
---
$subRat_{6th\ method}: Pair \times Rational \rightarrow Pair$

$\;$

"

# ╔═╡ 7ceb6a3c-7a58-4e8c-adad-5d4568437661
md"
---
$subRat_{7th\ method}: Rational \times NamedTuple{(:car, :cdr)} \rightarrow Rational$

$\;$

"

# ╔═╡ 3a03e2a7-bfd6-4825-885f-e394ee4a801e
md"
---
$subRat_{8th\ method}: Rational \times Pair \rightarrow Rational$

$\;$

"

# ╔═╡ 0159462b-70f1-43d9-8e8f-80552fd47c26
md"
---
$subRat_{9th\ method}: Rational \times Rational \rightarrow Rational$

$\;$

"

# ╔═╡ 6662d041-af9c-472d-b9fe-efe2c4846267
function subRat(x::Rational, 
				y::Rational)::Rational                   # 3 - 3
	x - y
end # method subRat

# ╔═╡ bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
md"
---
###### Multiplication

$\cdot\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$

$\;$

$x \cdot y = \frac{n_x}{d_x} \cdot \frac{n_y}{d_y}= \frac{n_x n_y}{d_x d_y}$

$\;$
$\;$

"

# ╔═╡ 15159a4f-cf52-411c-95b7-f969fa869483
md"
---
$mulRat_{1st\ method}: NamedTuple{(:car, :cdr)} \times NamedTuple{(:car, :cdr)} \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ c7d6c275-1ce0-4d77-b09f-7a99fba7d27b
md"
---
$mulRat_{2nd\ method}: NamedTuple{(:car, :cdr)} \times Pair \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 76abe333-f050-4775-afc0-f89917297688
md"
---
$mulRat_{3rd\ method}: NamedTuple{(:car, :cdr)} \times Rational \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 919bc317-66b5-4b7d-b739-3353f4f86ba6
md"
---
$mulRat_{4th\ method}: Pair \times NamedTuple{(:car, :cdr)} \rightarrow Pair$

$\;$

"

# ╔═╡ be113fde-c15d-4def-b050-ccb13250ae0e
md"
---
$subRat_{5th\ method}: Pair \times Pair \rightarrow Pair$

$\;$

"

# ╔═╡ 15b509c9-b182-4713-8a23-dc5cb5e68161
md"
---
$mulRat_{6th\ method}: Pair \times Rational \rightarrow Pair$

$\;$

"

# ╔═╡ 4e327188-17e3-41dd-8e7f-d7daf3c0a653
md"
---
$mulRat_{7th\ method}: Rational \times NamedTuple{(:car, :cdr)} \rightarrow Rational$

$\;$

"

# ╔═╡ 5d564bd2-0244-468f-a9d8-05628f02206e
md"
---
$mulRat_{8th\ method}: Rational \times Pair \rightarrow Rational$

$\;$

"

# ╔═╡ 1c27cf65-3c75-4307-85b9-7afebfdcc833
md"
---
$mulRat_{9th\ method}: Rational \times Rational \rightarrow Rational$

$\;$

"

# ╔═╡ 0875ee4d-e127-4140-a863-04c3a02c38a5
md"
---
###### Division

$/\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$

$\;$

$x/y = \left(\frac{n_x}{d_x}\right)/\left(\frac{n_y}{d_y}\right) = \frac{n_x d_y}{d_x n_y}$

$\;$
$\;$

"

# ╔═╡ cd626c5d-e52c-47a6-8e5d-017d6cd1e190
md"
---
$divRat_{1st\ method}: NamedTuple{(:car, :cdr)} \times NamedTuple{(:car, :cdr)} \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 85c353d5-0ad0-4ec6-b38e-55b259fe2085
md"
---
$divRat_{2nd\ method}: NamedTuple{(:car, :cdr)} \times Pair \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ bf888421-1ee0-4f91-b818-69328d3738ab
md"
---
$divRat_{3rd\ method}: NamedTuple{(:car, :cdr)} \times Rational \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ fe73efa5-77f5-4a9c-84df-b1b37c606e8c
md"
---
$divRat_{4th\ method}: Pair \times NamedTuple{(:car, :cdr)} \rightarrow Pair$

$\;$

"

# ╔═╡ f5f6c90a-9d81-4918-aa0d-346d9bc05dab
md"
---
$divRat_{5th\ method}: Pair \times Pair \rightarrow Pair$

$\;$

"

# ╔═╡ b97c8f4c-a09b-4710-9800-9b136d2a4c65
md"
---
$divRat_{6th\ method}: Pair \times Rational \rightarrow Pair$

$\;$

"

# ╔═╡ 937201dd-05f3-4d5b-ba80-667c54837b02
md"
---
$divRat_{7th\ method}: Rational \times NamedTuple{(:car, :cdr)} \rightarrow Rational$

$\;$

"

# ╔═╡ 23a7dbfe-a7eb-4591-8743-a36d144a0d5f
md"
---
$divRat_{8th\ method}: Rational \times Pair \rightarrow Rational$

$\;$

"

# ╔═╡ 79e70b98-ce00-4fd5-b03e-df17af794d09
md"
---
$divRat_{9th\ method}: Rational \times Rational \rightarrow Rational$

$\;$

"

# ╔═╡ f74ced3c-487c-4428-bcfc-cc69e5416227
md"
---
###### Equality test
$=\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb B$

$\;$

$(x=y) \equiv \left(\frac{n_x}{d_x} = \frac{n_y}{d_y}\right) \equiv (n_x d_y = d_x n_y)$

$\;$
$\;$

"

# ╔═╡ b8712d12-1412-4a8e-a7ab-362bfdeccd81
md"
---
$equalRat_{1st\ method}: NamedTuple{(:car, :cdr)} \times NamedTuple{(:car, :cdr)} \rightarrow Bool$

$\;$

"

# ╔═╡ 4013c24f-39fc-4b51-aeeb-c87b96360e7e
md"
---
$equalRat_{2nd\ method}: NamedTuple{(:car, :cdr)} \times Pair \rightarrow Bool$

$\;$

"

# ╔═╡ 8c0d74df-a4ae-482f-87ce-ad2e4a574005
md"
---
$equalRat_{3rd\ method}: NamedTuple{(:car, :cdr)} \times Rational \rightarrow Bool$

$\;$

"

# ╔═╡ d79f0229-d42a-4293-abb6-467746a3c1e5
md"
---
$equalRat_{4th\ method}: Pair \times NamedTuple{(:car, :cdr)} \rightarrow Bool$

$\;$

"

# ╔═╡ ed8d4587-371a-47e6-84d0-b9775a48eb02
md"
---
$equalRat_{5th\ method}: Pair \times Pair \rightarrow Bool$

$\;$

"

# ╔═╡ 808660d6-5eb1-4546-90fb-e1a4b328fbe6
md"
---
$equalRat_{6th\ method}: Pair \times Rational \rightarrow Bool$

$\;$

"

# ╔═╡ 3a1e2fc6-64fe-4b3f-8beb-83aa1d987dfe
md"
---
$equalRat_{7th\ method}: Rational \times NamedTuple{(:car, :cdr)} \rightarrow Bool$

$\;$

"

# ╔═╡ 88faf1ad-b0c2-4fbf-bde9-53eb44c7bc54
md"
---
$equalRat_{8th\ method}: Rational \times Pair \rightarrow Bool$

$\;$

"

# ╔═╡ c0a4730c-7132-47e9-932e-27e7060e9fb6
md"
---
$equalRat_{9th\ method}: Rational \times Rational \rightarrow Bool$

$\;$

"

# ╔═╡ 647ac904-63b2-422d-9f7f-9cd971125bd9
md"
---
##### 3.2 Level 1: Constructors and Selectors
"

# ╔═╡ 934515c1-5328-4ef8-9e8a-36d46e1130e7
md"
---
###### 3.2 1 *Methods* of *Constructor* Function $makeRat$
There are at least as many *methods* as there different *output types*.
"

# ╔═╡ 680c5ec0-6cf2-4b0c-a005-751ef8a7e568
md"
---
###### *1st* *constructor* method (default, *un*typed, *without* gcd) of function *makeRat*

$makeRat1 : Int \times Int \rightarrow NamedTuple{(:car, :cdr)}$

$\;$

"

# ╔═╡ 7ff3b4a0-e00b-424f-8118-897019d0fc20
makeRat1(n, d)::NamedTuple{(:car, :cdr)} =
	(car=n, cdr=d)

# ╔═╡ 810b1eca-eac7-49cb-a34f-8328ea432824
md"
###### *2nd* *constructor* method (*typed*, *with* gcd) of function *makeRat*
###### ... with type $Signed$ and imperative *looping* construct $while$

$makeRat1: Signed \times Signed \rightarrow NamedTuple{(:car, :cdr)}\;\;;\text{ with } Signed \subset Int$

$\;$

"

# ╔═╡ df37be85-589a-46aa-a14c-8ab67c461ae9
function makeRat1(n::Signed, d::Signed)::NamedTuple{(:car, :cdr)}
	#----------------------------------------------------------
	function gcd2(a, b) 
		#------------------------------------------------------
		remainder = %          # local function definition
	    #------------------------------------------------------
		b == 0 ? a : gcd(b, remainder(a, b))
		#----------------------------------------=-------------
		while !(b == 0)
			a,b = b, remainder(a, b) # parallel (!) assignment
		end # while
		a
		#----------------------------------------=-------------
	end  # function gcd2
	#----------------------------------------=-----------------
	let g = gcd2(n, d)
		# cons1(n ÷ g, d ÷ g)::NamedTuple{(:car, :cdr)}
		(car=(n ÷ g), cdr=(d ÷ g))::NamedTuple{(:car, :cdr)}
	end # let
	#----------------------------------------=-----------------
end # function make_rat

# ╔═╡ 40745707-b542-43b1-9be3-e8b62f03f594
md"
---
###### Methods for Output Type $Pair$ 
"

# ╔═╡ 0fd6dfda-7893-43e6-a97f-6e5fc237ddfe
md"
$makeRat2: Signed \times Signed \rightarrow Pair \;\;;\text{ with } Signed \subset Int$

$\;$

"

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
		# cons2(n ÷ g, d ÷ g)::Pair
		Pair((n ÷ g)::Signed, (d ÷ g)::Signed)::Pair
	end # let
end # function makeRat2

# ╔═╡ f5ecccb7-0a95-4417-8125-0688af9eed3e
md"
---
###### Methods for Output Type $Rational$ 
"

# ╔═╡ a4aae618-e5d7-4805-aa9a-eba90339f046
md"

$makeRat3: Signed \times Signed \rightarrow Rational \;\;;\text{ with } Signed \subset Int$

$\;$
"

# ╔═╡ 6858b169-b9dc-4a23-8dd3-8951033bd311
# idiomatic Julia-code by '÷'
function makeRat3(n::Int, d::Int)::Rational
	n//d
end # function makeRat3

# ╔═╡ c593932a-c212-4675-b756-ec643fec86e5
md"
---
###### 3.2 2 Selectors: Methods $numer, denom$ of Functions $numer, denom$
"

# ╔═╡ 176a02cb-a0aa-4ba3-bb6a-628ae7c55459
md"
---
$numer_{1st\ method} : NamedTuple{(:car, :cdr)} \rightarrow Signed$

$\;$

"

# ╔═╡ 193ae321-0f26-44cc-a48f-1a1b9bc71af8
numer(x::NamedTuple{(:car, :cdr)})::Signed = x.car

# ╔═╡ 71ba8f42-ca4f-4c6c-b129-3a1cff08ea63
md"
---
$numer_{2nd\ method} : Pair \rightarrow Signed$

$\;$

"

# ╔═╡ 7f5b9164-07c2-4ae1-888d-f601fa9d286c
numer(x::Pair)::Signed = 
	x.first::Signed

# ╔═╡ 370414ed-eeb1-483d-8aca-561a97e32658
md"
$numer_{3rd\ method} : Rational \rightarrow Signed$

$\;$

"

# ╔═╡ 0a935144-2c44-480b-9c6e-53408b972e89
numer(x::Rational)::Signed = 
	numerator(x::Rational)::Signed

# ╔═╡ 76f2a684-7f4b-4367-8db5-60ec983afba4
md"
---
$denom_{1st\ method} : NamedTuple{(:car, :cdr)} \rightarrow Signed$

$\;$

"

# ╔═╡ d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
denom(x::NamedTuple{(:car, :cdr)})::Signed = x.cdr

# ╔═╡ 0f6cd42e-1ca3-4b54-8db5-82a2d1356a68
md"
---
$denom_{2nd\ method} : Pair \rightarrow Signed$

$\;$

"

# ╔═╡ 3ca05b52-413f-46aa-9fd7-659227dccbd7
denom(x::Pair)::Signed = 
	x.second::Signed

# ╔═╡ 688db011-603f-47b3-899e-706e0089441b
md"
$denom_{3rd\ method} : Rational \rightarrow Signed$

$\;$

"

# ╔═╡ 7c2af484-eea8-4c8c-8891-4aa4923298ae
denom(x::Rational)::Signed = 
	denominator(x::Rational)::Signed

# ╔═╡ 172db576-f756-4d62-94c3-128c6ac4f847
# idiomatic Julia-code with string interpolation "$(.....)"
printRat(x::NamedTuple{(:car, :cdr)}) = "$(numer(x))/$(denom(x))"

# ╔═╡ 0c40b6a6-9f60-4590-a7c5-517495230bf7
printRat(x::Pair) = "$(numer(x))/$(denom(x))"

# ╔═╡ 6d096e3e-3313-4889-aa5b-387e75912d5e
printRat(x::Rational)::String = "$(numer(x))/$(denom(x))"

# ╔═╡ ca75c0f7-2e85-4436-8544-9b19aa0f57a8
function addRat(x::NamedTuple{(:car, :cdr)},             # 1 - 1
				y::NamedTuple{(:car, :cdr)})::NamedTuple{(:car, :cdr)}
	makeRat1( 
		+(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method addRat

# ╔═╡ eb072b24-168a-4904-8ed3-03aa1c01065d
function addRat(x::NamedTuple{(:car, :cdr)},             # 1 - 2
				y::Pair)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		+(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method addRat

# ╔═╡ a7170ca7-9ec7-4287-8106-5c43b7de6cfc
function addRat(x::NamedTuple{(:car, :cdr)},             # 1 - 3
				y::Rational)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		+(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method addRat

# ╔═╡ 98224b21-d99c-4b74-8504-4b5e90ff31fe
function addRat(x::Pair,                                 # 2 - 1
				y::NamedTuple{(:car, :cdr)})::Pair
	makeRat2(
		numer(x) * denom(y) + numer(y) * denom(x), 
		denom(x) * denom(y))
end # method addRat

# ╔═╡ 76e3a4bc-fde2-4440-96c1-c492cc120db0
function addRat(x::Pair,                                 # 2 - 2
				y::Pair)::Pair
	makeRat2(
		numer(x) * denom(y) + numer(y) * denom(x), 
		denom(x) * denom(y))
end # method addRat

# ╔═╡ 62564d67-cbef-4e27-b14a-83104cc0768b
function addRat(x::Pair,                                 # 2 -3
				y::Rational)::Pair
	makeRat2(
		numer(x) * denom(y) + numer(y) * denom(x), 
		denom(x) * denom(y))
end # method addRat

# ╔═╡ 26593de4-f70d-4aa5-86dd-d09bb6544407
function addRat(x::Rational,                             # 3 - 1
				y::NamedTuple{(:car, :cdr)})::Rational
	makeRat3(
		numer(x) * denom(y) + numer(y) * denom(x), 
		denom(x) * denom(y)) 
end # method addRat

# ╔═╡ 6b56f16c-9408-4d94-a0f8-828cfa784290
function addRat(x::Rational,                             # 3 - 2
				y::Pair)::Rational
	makeRat3(
		numer(x) * denom(y) + numer(y) * denom(x), 
		denom(x) * denom(y)) 
end # method addRat

# ╔═╡ a181310f-1f46-43b2-8702-a8a60308ccfe
function subRat(x::NamedTuple{(:car, :cdr)},            # 1 - 1
				y::NamedTuple{(:car, :cdr)})::NamedTuple{(:car, :cdr)}
	makeRat1( 
		-(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method subRat

# ╔═╡ 54896d9b-bb75-4fbf-992f-6657230f0fdf
function subRat(x::NamedTuple{(:car, :cdr)},            # 1 - 2
				y::Pair)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		-(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method subRat

# ╔═╡ 0fd74237-7874-415e-a43d-8fb12b6fd7f2
function subRat(x::NamedTuple{(:car, :cdr)},            # 1 - 3
				y::Rational)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		-(*(numer(x), denom(y)), *(numer(y), denom(x))), 
		*(denom(x), denom(y)))
end # method subRat

# ╔═╡ 492177d6-fec9-49c2-bb26-2b42f916d912
function subRat(x::Pair,                                 # 2 - 1
				y::NamedTuple{(:car, :cdr)})::Pair
	makeRat2(
		numer(x) * denom(y) - numer(y) * denom(x), 
		denom(x) * denom(y))
end # method subRat

# ╔═╡ 402d8963-26bc-4db2-b94b-ba4334e1d8fd
function subRat(x::Pair, y::Pair)::Pair                 # 2 - 2
	makeRat2(
		numer(x) * denom(y) - numer(y) * denom(x), 
		denom(x) * denom(y))
end # method subRat

# ╔═╡ 68289adf-f3f9-4160-b618-cbcfc88f6ab1
function subRat(x::Pair,                                 # 2 -3
				y::Rational)::Pair
	makeRat2(
		numer(x) * denom(y) - numer(y) * denom(x), 
		denom(x) * denom(y))
end # method subRat

# ╔═╡ 7609f497-9ab3-4fe0-b5e3-c1c02a55ee52
function subRat(x::Rational,                             # 3 - 1
				y::NamedTuple{(:car, :cdr)})::Rational
	makeRat3(
		numer(x) * denom(y) - numer(y) * denom(x), 
		denom(x) * denom(y)) 
end # method subRat

# ╔═╡ 4d9ea031-9f81-47cc-acbb-79768f307fda
function subRat(x::Rational,                             # 3 - 2
				y::Pair)::Rational
	makeRat3(
		numer(x) * denom(y) - numer(y) * denom(x), 
		denom(x) * denom(y)) 
end # method subRat

# ╔═╡ 778e12ad-bfe7-4f02-a946-894249fe2375
function mulRat(x::NamedTuple{(:car, :cdr)},             # 1 - 1
				y::NamedTuple{(:car, :cdr)})::NamedTuple{(:car, :cdr)}
	makeRat1(
		*(numer(x), numer(y)), 
		*(denom(x), denom(y)))
end # method mulRat

# ╔═╡ 57cc9fa7-9547-4c52-b8fb-db10e3aa6bae
function mulRat(x::NamedTuple{(:car, :cdr)},             # 1 - 2
				y::Pair)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		*(numer(x), numer(y)), 
		*(denom(x), denom(y)))
end # method mulRat

# ╔═╡ 56bce8c4-25be-4c4f-a79b-d2834121c9dd
function mulRat(x::NamedTuple{(:car, :cdr)},             # 1 - 3
				y::Rational)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		*(numer(x), numer(y)), 
		*(denom(x), denom(y)))
end # method mulRat

# ╔═╡ e8982f26-04ac-4061-8089-a5966a39a85f
function mulRat(x::Pair,                                 # 2 - 1
				y::NamedTuple{(:car, :cdr)})::Pair 
	makeRat2(
		numer(x) * numer(y), 
		denom(x) * denom(y))
end # method mulRat

# ╔═╡ 09901068-bf38-4392-ab19-66a44d65344d
function mulRat(x::Pair, y::Pair)::Pair                  # 2 - 2
	makeRat2(
		numer(x) * numer(y), 
		denom(x) * denom(y))
end # method mulRat

# ╔═╡ 297ed8b1-85a9-4fb1-9d26-83e647c1dcaa
function mulRat(x::Pair, y::Rational)::Pair              # 2 - 3
	makeRat2(
		numer(x) * numer(y), 
		denom(x) * denom(y))
end # method mulRat

# ╔═╡ 3db2bda6-5edf-4126-99b6-483f36a4fc22
function mulRat(x::Rational, 
				y::NamedTuple{(:car, :cdr)})::Rational   # 3 - 1
	makeRat3(
		numer(x) * numer(y), 
		denom(x) * denom(y)) 
end # method mulRat

# ╔═╡ 916ed2b6-36ac-45a3-a4a3-fd9295f4d678
function mulRat(x::Rational, 
				y::Pair)::Rational                       # 3 - 2
	makeRat3(
		numer(x) * numer(y), 
		denom(x) * denom(y)) 
end # method mulRat

# ╔═╡ 8fc62f98-9a2e-4fae-83b7-a78118b656d3
function mulRat(x::Rational, y::Rational)::Rational      # 3 - 3
	makeRat3(
		numer(x) * numer(y), 
		denom(x) * denom(y)) 
end # method mulRat

# ╔═╡ fbb683ca-d4e2-4d0c-b622-45ea6c7af7e7
function divRat(x::NamedTuple{(:car, :cdr)},             # 1 - 1
				y::NamedTuple{(:car, :cdr)})::NamedTuple{(:car, :cdr)}
	makeRat1(
		*(numer(x), denom(y)), 
		*(denom(x), numer(y)))
end # method divRat

# ╔═╡ bb1f5e65-9d08-4b81-8ae6-6178241518de
function divRat(x::NamedTuple{(:car, :cdr)},             # 1 - 2
				y::Pair)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		*(numer(x), denom(y)), 
		*(denom(x), numer(y)))
end # method divRat

# ╔═╡ abee7262-c11c-4c26-ba5f-14631dcd9b67
function divRat(x::NamedTuple{(:car, :cdr)},             # 1 - 3
				y::Rational)::NamedTuple{(:car, :cdr)}
	makeRat1( 
		*(numer(x), denom(y)), 
		*(denom(x), numer(y)))
end # method divRat

# ╔═╡ 022a1471-1b99-4ac1-a038-fec0ad5bd7c0
function divRat(x::Pair,                                 # 2 - 1
				y::NamedTuple{(:car, :cdr)})::Pair 
	makeRat2(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ 34413a78-f6b7-44d0-b280-d99ba4b99e20
function divRat(x::Pair, y::Pair)::Pair                  # 2 - 2
	makeRat2(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ ed895a47-6196-4812-bc2f-0eb244c17ef4
function divRat(x::Pair, y::Rational)::Pair              # 2 - 3
	makeRat2(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ 8a963537-d72e-411d-9084-64649cb878e1
function divRat(x::Rational, 
				y::NamedTuple{(:car, :cdr)})::Rational   # 3 - 1
	makeRat3(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ 5b4036bd-d88d-42ef-b705-d915b553880c
function divRat(x::Rational, 
				y::Pair)::Rational                       # 3 - 2
	makeRat3(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ dca9d7a4-c84e-4dc6-9bdd-e043fdd2f936
function divRat(x::Rational,                             # 3 - 3
				y::Rational)::Rational      
	makeRat3(
		numer(x) * denom(y), 
		denom(x) * numer(y))
end # method divRat

# ╔═╡ bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
function equalRat(x::NamedTuple{(:car, :cdr)},                  # 1 - 1
				  y::NamedTuple{(:car, :cdr)})::Bool
	*(numer(x), denom(y)) == *(numer(y), denom(x))
end # method equalRat

# ╔═╡ 165cbcb1-6457-4762-8864-7f9e3fe429e5
function equalRat(x::NamedTuple{(:car, :cdr)},                  # 1 - 2
				  y::Pair)::Bool
	*(numer(x), denom(y)) == *(numer(y), denom(x))
end # method equalRat

# ╔═╡ 899afab4-67a4-4c7b-b436-85e79f6b2930
function equalRat(x::NamedTuple{(:car, :cdr)},                  # 1 - 3
				  y::Rational)::Bool
	*(numer(x), denom(y)) == *(numer(y), denom(x))
end # method equalRat

# ╔═╡ 34c8fdfe-9e05-4236-bd26-b6ea12823ba0
function equalRat(x::Pair,                                      # 2 - 1
				  y::NamedTuple{(:car, :cdr)})::Bool
	*(numer(x), denom(y)) == *(numer(y), denom(x))
end # method equalRat

# ╔═╡ afe55885-aba6-4cbc-af2c-23d15bbbf6f5
function equalRat(x::Pair, y::Pair)::Bool                       # 2 - 2
	numer(x) * denom(y) == denom(x) * numer(y)
end # method equalRat

# ╔═╡ 0bee0a3a-8375-41fd-b149-5220c843406f
function equalRat(x::Pair, y::Rational)::Bool                   # 2 - 3
	numer(x) * denom(y) == denom(x) * numer(y)
end # method equalRat

# ╔═╡ b01171e9-43b8-40cf-aac9-ae4e1b684834
function equalRat(x::Rational,                                  # 3 - 1
				  y::NamedTuple{(:car, :cdr)})::Bool
	*(numer(x), denom(y)) == *(numer(y), denom(x))
end # method equalRat

# ╔═╡ e901290e-1307-44cc-8ca9-2952c48e2c96
function equalRat(x::Rational, y::Pair)::Bool                   # 3 - 2
	numer(x) * denom(y) == denom(x) * numer(y)
end # method equalRat

# ╔═╡ dc59fed0-e8fd-4918-9dfa-8882e1ab2edc
function equalRat(x::Rational, y::Rational)::Bool               # 3 - 3
	numer(x) * denom(y) == denom(x) * numer(y)
end # method equalRat

# ╔═╡ a9341f5b-8b06-4994-ba6b-58070485c336
md"
---
##### 3.3 Applications
---
###### 3.3.1 Applications with $NamedTuple{(:car, :cdr)}$
"

# ╔═╡ 8c3bff44-929d-4891-a3c7-53b9be36054e
one_half_1 = makeRat1(1, 2)                  # ==> 1/2

# ╔═╡ 50b8cf20-537b-45b7-a5cb-02f2f3e669cd
typeof(one_half_1)

# ╔═╡ fdafce07-ec12-46be-9d33-16623e962af4
printRat(one_half_1)

# ╔═╡ 5e343050-8037-4ce7-abd6-eb2f0bc9fdff
one_third_1 = makeRat1(1, 3)                 # ==> 1/3

# ╔═╡ 904ad2a6-aa36-4469-85bd-3bf0264ae3a6
printRat(one_third_1)

# ╔═╡ b8594f35-dbcc-402d-ae51-ec56d278016f
two_twelves_1 = makeRat1(2, 12)              # == 1/6 --> with (!) application of gcd

# ╔═╡ fbe308f1-c0d9-4f40-b79f-fa325923f07e
printRat(two_twelves_1)                      # == 1/6 -->with (!) application of gcd

# ╔═╡ 2e089c95-467d-40f6-babd-979011013ed0
printRat(makeRat1(120,90))  # ==> 120/90 = 12/9 = 4/3 -->with (!) application of gcd

# ╔═╡ ae066a31-138e-4f9e-8d30-aea918850db6
addRat(one_half_1, one_third_1)               # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 18b6a504-1e46-4b32-b336-197fc639e7f3
printRat(addRat(one_half_1, one_third_1))     # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 6889469f-57ca-44b4-91a1-6cba355647ef
printRat(subRat(one_half_1, one_third_1))     # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 632f4826-8d33-4047-a265-0bf81a7cb77d
printRat(mulRat(one_half_1, one_third_1))     # 1/2 * 1/3 = 1/6

# ╔═╡ a1a3bb76-9ba0-425d-b10b-01b958461ab9
printRat(divRat(one_half_1, one_third_1))     # (1/2)/(1/3) = (1*3)/(2*1) = 3/2

# ╔═╡ 6d8e4372-a1e3-4d8e-93f7-1b0e987a4800
equalRat(makeRat2(2, 3), makeRat2(6, 9))      # 2/3 == 6/9 ==> true -->  :)

# ╔═╡ 59ec0583-db14-4e4c-8b6b-0a2035bc89d1
equalRat(makeRat2(1, 2), makeRat2(3, 6))  # 1/2 = 3/6 => 1/2 == 1/2 ==> true -->  :)

# ╔═╡ 0585b0dd-18e4-47bd-9bc3-2da0ba9528e2
equalRat(makeRat2(4, 3), makeRat2(120, 90))   # 4/3 == 120/90 ==> true -->  :)

# ╔═╡ 81767db0-ca16-4872-9d91-b0f55baf77a8
md"
---
###### nonSICP: [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) 
accurate to seven digits
"

# ╔═╡ 813f7f22-da40-4ea6-bb56-58765ed2f7f8
printRat(makeRat1(355, 113))

# ╔═╡ 43736c04-45b9-4722-a943-4adaf5f166b7
π                       # May  I  have  a  large  container  of  coffee,  quick ...
                        #|May||I||have||a||large||container||of||coffee|,|quick|...
                        #  3   1    4   1     5       9       2     6       5   ...

# ╔═╡ dea3812a-2da7-462d-949f-e4db34153568
355/113                         

# ╔═╡ cd10aae3-074c-44c5-a4ba-5ddf2e030c88
abs(355/113 - π)                # deviation from Julia's π (accurate to seven digits)

# ╔═╡ ec878031-9e74-4a7c-a402-16641f34f0e9
md"
---
###### 3.3.2 Applications with $Pair$
"

# ╔═╡ 4a188ea0-f4ed-413e-bd4f-40137c37a6df
one_half_2 = makeRat2(1, 2)                # ==> 1/2

# ╔═╡ 79e81a4b-8d60-46c1-81f2-397a670f9534
typeof(one_half_2)                         # ==> Pair{Int64, Int64}

# ╔═╡ 9f6f2dbd-43ab-4331-97d1-4194cf7b4296
printRat(one_half_2)

# ╔═╡ c1798a2b-d9e4-4037-8234-0979f45d616c
one_third_2 = makeRat2(1, 3)               # ==> 1/3

# ╔═╡ d05c5ec8-664e-4f4d-ba59-4eeed6e3ecef
printRat(one_third_2)

# ╔═╡ 55379ada-b823-49ef-a197-8dd215d80398
two_twelves_2 = makeRat2(2, 12)            # == 1/6 --> with (!) application of gcd

# ╔═╡ 60943d51-d452-4e8f-9dcc-f32582d5d329
printRat(two_twelves_2)                    # == 1/6 -->with (!) application of gcd

# ╔═╡ d09fc57f-d7e8-4a68-b936-2ea20f789e80
printRat(makeRat2(120,90))  # ==> 120/90 = 12/9 = 4/3 -->with (!) application of gcd

# ╔═╡ fbf8a9e3-a20d-4561-b6a0-843ecd35c176
addRat(one_half_2, one_third_2)            # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ dca4a1e9-d1a7-439b-a7cd-a73b14464a0e
printRat(addRat(one_half_2, one_third_2))  # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ fb7727cd-9fde-440f-b8ba-6fa2f52c174b
printRat(subRat(one_half_2, one_third_2))  # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 3d3ee875-5d76-4edd-a945-2c6477795ae4
printRat(mulRat(one_half_2, one_third_2))  # 1/2 * 1/3 = 1/6

# ╔═╡ c0071c32-c45c-44a8-80a4-0189b6833f51
printRat(divRat(one_half_2, one_third_2))  # (1/2)/(1/3) = (1*3)/(2*1) = 3/2

# ╔═╡ 8a2b87ff-e78f-44b2-b4df-cf57db3d46d8
equalRat(makeRat2(2, 3), makeRat2(6, 9))   # 2/3 == 6/9 ==> true -->  :)

# ╔═╡ 052d3986-6bf3-4619-8d41-5e9c91f9ed21
equalRat(makeRat2(1, 2), makeRat2(3, 6))   # 1/2 = 3/6 => 1/2 == 1/2 ==> true -->  :)

# ╔═╡ cf19df94-0dca-4f03-8c97-9df84b21cf67
equalRat(makeRat2(4, 3), makeRat2(120, 90))   # 4/3 == 120/90 ==> true -->  :)

# ╔═╡ 001b974e-9ac4-48d9-9fc2-e76b4570cd10
md"
---
###### nonSICP: [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) 
accurate to seven digits
"

# ╔═╡ 6c5b6102-9323-480d-bcdb-88f795615fa4
printRat(makeRat2(355, 113))

# ╔═╡ 0c152ce9-cb4a-4d80-958c-34147777470b
π                       # May  I  have  a  large  container  of  coffee,  quick ...
                        #|May||I||have||a||large||container||of||coffee|,|quick|...
                        #  3   1    4   1     5       9       2     6       5   ...

# ╔═╡ 3e75d1a8-e5da-47a0-aaa3-7e3d831f78e9
355/113

# ╔═╡ 145688ab-55e3-4fe6-8e47-77470bc74cd8
abs(355/113 - π)                # deviation from Julia's π (accurate to seven digits)

# ╔═╡ 4768fea6-bff8-4e91-984e-be3a3d6cb2dc
md"
---
###### 3.3.3 Applications with $Rational$
"

# ╔═╡ 9672253e-c0be-4da5-9c1b-6882ce5f65c3
one_half_3 = makeRat3(1, 2)

# ╔═╡ ed140d1c-110e-4fcb-ba43-807b59ac30ef
printRat(one_half_3)

# ╔═╡ ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
one_third_3 = makeRat3(1, 3)

# ╔═╡ ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
printRat(one_third_3)

# ╔═╡ dc14d933-62ac-4cf7-8563-71fda97afc9a
printRat(addRat(one_half_3, one_third_3))

# ╔═╡ 47771613-e613-497b-a020-f825a51b012d
printRat(subRat(one_half_3, one_third_3))

# ╔═╡ 1a32f5c0-e644-44bc-9b0a-f47905e98f1d
printRat(mulRat(one_half_3, one_third_3))

# ╔═╡ 43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
printRat(divRat(one_half_3, one_third_3))

# ╔═╡ 1349941f-f280-47f2-814b-32b3b8ac4e4c
equalRat(makeRat3(1, 3), makeRat3(2, 6))

# ╔═╡ 7242424b-c8da-4452-b104-b3a2411fc0df
equalRat(makeRat3(1, 2), makeRat3(3, 6))

# ╔═╡ b202fbe1-f987-4e62-8f6f-3af4d3ca1048
equalRat(makeRat3(1, 3), makeRat3(3, 6))

# ╔═╡ b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
printRat(addRat(one_third_3, one_third_3))

# ╔═╡ f38f0544-6113-4ed9-af22-d5d205078492
printRat(makeRat3(120, 90))

# ╔═╡ dbbb5dda-708d-44df-b04f-a793b0ec9e83
md"
---
##### Type *Agnostic* Applications
Here we demonstrate that *domain-specific* arithmetic operators are complete *agnostic* of the type of its arguments.
"

# ╔═╡ 6cbab1cd-396e-4bba-a593-838bc32e2a29
md"
---
###### $addRat$
"

# ╔═╡ 0abc4683-5b12-4a82-91ee-36844e0e302f
addRat(one_half_1, one_third_1)            # 1-2: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 06c5af9c-1dd9-4924-83d8-1beba749cd22
printRat(addRat(one_half_1, one_third_1))

# ╔═╡ fa18366a-5704-47b9-a745-810c7798f449
addRat(one_half_1, one_third_2)            # 1-2: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 3f9cb20a-e12e-4acd-ae75-63f621e671f2
printRat(addRat(one_half_1, one_third_2))

# ╔═╡ 92e0d133-1f3f-431d-aaca-639d18b9f61e
addRat(one_half_1, one_third_3)            # 1-3: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ a9d5b451-caeb-4a33-a4c9-b72f2a9c4fac
printRat(addRat(one_half_1, one_third_3))

# ╔═╡ 5b57fb8e-64a1-4f68-90d0-5b7d9dc5618d
addRat(one_half_2, one_third_1)            # 2-1: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 7ec61c23-d28e-4235-9196-12ccff5dc21f
printRat(addRat(one_half_2, one_third_1))

# ╔═╡ 61536501-69ab-4e47-94c9-c5afc0d7edd7
addRat(one_half_2, one_third_2)            # 2-1: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ cb59a26c-3eeb-4361-ba0f-c43e21e507d5
printRat(addRat(one_half_2, one_third_2))

# ╔═╡ 4624578a-7579-426b-8d94-a3525ac708e6
addRat(one_half_2, one_third_3)            # 2-3: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 89e1d980-3a33-46d3-9694-1444ddb2f12f
printRat(addRat(one_half_2, one_third_3))

# ╔═╡ f688cdeb-ffec-41bf-844b-2674616ceb48
addRat(one_half_3, one_third_1)            # 3-1: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 2a4d64f4-04fe-41af-9dbe-d1d8753478e1
printRat(addRat(one_half_3, one_third_1))

# ╔═╡ 0d05af2e-77af-4e05-a942-775fee3d7d95
addRat(one_half_3, one_third_2)            # 3-2: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ d4f33142-611d-41fa-9af8-0b42b87c2663
printRat(addRat(one_half_3, one_third_2))

# ╔═╡ f980a5a1-309e-490b-b519-b5fdd142030e
addRat(one_half_3, one_third_3)            # 3-1: 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ f5ad1126-2c6c-4937-8e95-142ce6e9b670
printRat(addRat(one_half_3, one_third_3))

# ╔═╡ 1ca2e34a-b318-42bf-aad5-59f6a16d994b
md"
---
###### $subRat$
"

# ╔═╡ bbe24a13-97e3-4f43-8b42-43d020e4843d
subRat(one_half_1, one_third_1)            # 1-1: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 2d2c7b49-9cb3-4ed5-882e-b988f7aca16c
printRat(subRat(one_half_1, one_third_1))

# ╔═╡ 6b87c99c-ceab-4d22-a3b8-e58115a2c125
subRat(one_half_1, one_third_2)            # 1-2: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 621b51fb-636c-4b27-bdba-3960e8c0fc1f
printRat(subRat(one_half_1, one_third_2))

# ╔═╡ cb7fcc8f-f96a-4786-9e49-b0053ed8da0c
subRat(one_half_1, one_third_3)            # 1-3: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 54d5063c-7020-42c0-b2ee-81ae47ddf3db
printRat(subRat(one_half_1, one_third_3))

# ╔═╡ ce424610-773b-4406-b5ec-6e70c3bdcce4
subRat(one_half_2, one_third_1)            # 2-1: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 1700a82e-eecb-45f2-bd4e-e25d0c577f7b
printRat(subRat(one_half_2, one_third_1))

# ╔═╡ b61afb92-ce5f-45f7-9032-361ef90a96fe
subRat(one_half_2, one_third_2)            # 2-2: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 044f71a2-4202-4e68-889b-ea594ee364c9
printRat(subRat(one_half_2, one_third_2))

# ╔═╡ aabc7068-cf5e-4824-81a8-0bb11de88033
subRat(one_half_2, one_third_3)            # 2-3: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 71cf5c5d-61a5-467a-b227-b4aa255a8a7f
printRat(subRat(one_half_2, one_third_3))

# ╔═╡ 93fb8250-9ed7-4b4d-a960-1b42f750aa90
subRat(one_half_3, one_third_1)            # 3-1: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 60f681af-ac61-4775-8d39-5cc0eb41566e
printRat(subRat(one_half_3, one_third_1))

# ╔═╡ d4753a17-740a-444f-bbde-824bd5126e2c
subRat(one_half_3, one_third_2)            # 3-2: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 68e96428-31d8-4e8f-9c63-4aee9aba2470
printRat(subRat(one_half_3, one_third_2))

# ╔═╡ 63416d10-96e6-4fad-8295-6212949e9e3e
subRat(one_half_3, one_third_3)            # 3-3: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 13d6e5e9-66a8-43c9-87e8-7ef3751c668a
printRat(subRat(one_half_3, one_third_3))

# ╔═╡ 7caf15d5-2af8-4a76-868e-494766022f97
md"
---
###### $mulRat$
"

# ╔═╡ 0533dbc0-dd8f-4d49-af95-be6e2f684aa8
mulRat(one_half_1, one_third_1)            # 1-1: 1/2 * 1/3 = 1/6

# ╔═╡ 0ec3ba72-5d99-484a-bf6f-c0999eb0d10e
printRat(mulRat(one_half_1, one_third_1))  # 1-1: 1/2 * 1/3 = 1/6

# ╔═╡ 6455f2e3-cfc2-4ca5-b71e-969e9146211c
mulRat(one_half_1, one_third_2)            # 1-2: 1/2 * 1/3 = 1/6

# ╔═╡ 9f46bbd3-dae7-4dbb-b14f-6e7da348a576
printRat(mulRat(one_half_1, one_third_2))  # 1-2: 1/2 * 1/3 = 1/6

# ╔═╡ 7eb35118-58d3-4c90-877d-8d2a2acfa5e2
mulRat(one_half_1, one_third_3)            # 1-3: 1/2 * 1/3 = 1/6

# ╔═╡ 6ff1a9be-cbfc-421d-a452-3af4aa6c5a4d
printRat(mulRat(one_half_1, one_third_3))  # 1-3: 1/2 * 1/3 = 1/6

# ╔═╡ 99c79e60-9ab4-4d3b-9edf-4f543574c7be
mulRat(one_half_2, one_third_1)            # 2-1: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 8096d062-27dd-44fc-befb-e78cde0d3947
printRat(mulRat(one_half_2, one_third_1))

# ╔═╡ ecfaaae4-5f5e-4cfb-894a-e5d772dddce4
mulRat(one_half_2, one_third_2)            # 2-2: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 8d188c57-c33c-444a-87bb-1a1f8dc88f77
printRat(mulRat(one_half_2, one_third_2))

# ╔═╡ ada84124-62c1-4f80-aebb-f6cd0ca70785
mulRat(one_half_2, one_third_3)            # 2-3: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 92ef3720-550e-4f15-90ff-78115a43b6ed
printRat(mulRat(one_half_2, one_third_3))

# ╔═╡ 8db72342-45c5-4f76-9f99-acd32d03ac1e
mulRat(one_half_3, one_third_1)            # 3-1: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 58ed03fd-d00e-4bdc-8c82-1b04f7fcc677
printRat(mulRat(one_half_3, one_third_1))

# ╔═╡ 176e5216-f03b-4ce2-bb22-2ad9c709275f
mulRat(one_half_3, one_third_2)            # 3-2: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 645a40cd-4f3a-4491-a127-5152721326ac
printRat(mulRat(one_half_3, one_third_2))

# ╔═╡ b8d5b0c1-c45e-42fc-84b2-267c445273cf
mulRat(one_half_3, one_third_3)            # 3-3: 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ 3ddf1552-d846-43f2-a8ea-ffe7f0e1b9db
printRat(mulRat(one_half_3, one_third_3))

# ╔═╡ 5cb02bc2-0731-45e5-b4be-3af24e19cae6
md"
---
###### $divRat$
"

# ╔═╡ aa6e7fea-62a2-48f5-a901-75c12c28dc7b
divRat(one_half_1, one_third_1)            # 1-1: 1/2 / 1/3 = 3/2

# ╔═╡ d752b609-e506-42dc-a2b5-8724ab898d11
printRat(divRat(one_half_1, one_third_1))  # 1-1: 1/2 / 1/3 = 3/2

# ╔═╡ 15b21998-15a8-4fce-92d6-873a3fe98950
divRat(one_half_1, one_third_2)            # 1-2: 1/2 / 1/3 = 3/2

# ╔═╡ e1eadaac-ec6c-452f-9b47-9349614f7af8
printRat(divRat(one_half_1, one_third_2))  # 1-2: 1/2 / 1/3 = 3/2

# ╔═╡ 8920dbea-0f91-40f9-b4ad-dfc4474ed8f8
divRat(one_half_1, one_third_3)            # 1-3: 1/2 / 1/3 = 3/2

# ╔═╡ d1cfa96b-ca82-4e2c-9a4c-33d33bf900bb
printRat(divRat(one_half_1, one_third_3))  # 1-3: 1/2 / 1/3 = 3/2

# ╔═╡ 865da2b5-263a-4396-b4ca-07caccd44f68
divRat(one_half_2, one_third_1)            # 2-1: 1/2 / 1/3 = 3/2

# ╔═╡ d2180445-e669-4fca-b375-06889e68fa1f
printRat(divRat(one_half_2, one_third_1))  # 2-1: 1/2 / 1/3 = 3/2

# ╔═╡ 5ae81274-d7f8-49d9-bbd6-f4b0a6e61e54
divRat(one_half_2, one_third_2)            # 2-2: 1/2 / 1/3 = 3/2

# ╔═╡ 3346242d-8f73-4a3e-984d-8bb96e53dbb7
printRat(divRat(one_half_2, one_third_2))  # 2-2: 1/2 / 1/3 = 3/2

# ╔═╡ 0dca1b97-eae8-4c6c-bd0a-b3f3e9addf31
divRat(one_half_2, one_third_3)            # 2-3: 1/2 / 1/3 = 3/2

# ╔═╡ 2d88ad8c-cf0a-405b-85fd-6be56f10b87c
printRat(divRat(one_half_2, one_third_3))  # 2-3: 1/2 / 1/3 = 3/2

# ╔═╡ 3514bb74-a490-4e5e-8202-2c16bf00dfee
divRat(one_half_3, one_third_1)            # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ 5ac0f286-c292-4ecf-8f84-10a4f3a6fccb
printRat(divRat(one_half_3, one_third_1))  # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ 4e083679-1f4c-48fa-a171-54503bb26ddd
divRat(one_half_3, one_third_2)            # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ 71700b1e-7016-49f9-9b20-ff34c5d9a7df
printRat(divRat(one_half_3, one_third_2))  # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ c1bde8cb-1009-4456-b31a-4aa4488e329c
divRat(one_half_3, one_third_3)            # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ aa64e9a8-80e2-41d2-a886-f8a30d6c53eb
printRat(divRat(one_half_3, one_third_3))  # 3-1: 1/2 / 1/3 = 3/2

# ╔═╡ a194be2e-3906-433e-83e3-6ab3a1e83ba7
md"
---
###### $equalRat$
"

# ╔═╡ 91236ce5-a48d-4ea8-ab43-afa37f4ce89f
equalRat(one_half_1, one_half_1)           # 1 - 1: ==> true

# ╔═╡ f06a7b43-1452-436f-9502-8e6e29316bc9
equalRat(one_half_1, one_third_1)          # 1 - 1: ==> false

# ╔═╡ 55cfaee3-8520-4556-9076-fee288ba33c3
equalRat(one_half_1, one_half_2)           # 1 - 2: ==> true

# ╔═╡ 12acb5c5-810d-40f7-b410-3de8ef77fdf9
equalRat(one_half_1, one_third_2)          # 1 - 2: ==> false

# ╔═╡ 207b1e00-1af2-43ae-9d78-6aba2c17d019
equalRat(one_half_1, one_half_3)           # 1 - 3: ==> true

# ╔═╡ 535a87aa-519a-4df5-b13a-1d203ef54fbd
equalRat(one_half_1, one_third_3)          # 1 - 3: ==> false

# ╔═╡ 035dfcc6-fc74-44af-8f6f-47a771e46a1e
equalRat(one_half_2, one_half_1)           # 2 - 1: ==> true

# ╔═╡ 3dcaeaea-1206-42b4-a541-cd1036b35c11
equalRat(one_half_2, one_third_1)          # 2 - 1: ==> false

# ╔═╡ bdf04bb6-8e48-4df0-b45f-4065b6251f89
equalRat(one_half_2, one_half_2)           # 2 - 2: ==> true

# ╔═╡ 822cf837-97d0-405b-be7e-6420703badbf
equalRat(one_half_2, one_third_2)          # 2 - 2: ==> false

# ╔═╡ b8bb2ac3-39f9-46b1-b9e9-eba941534fe8
equalRat(one_half_2, one_half_3)           # 2 - 3: ==> true

# ╔═╡ 209cdbae-6e63-458e-801b-450155f506ed
equalRat(one_half_2, one_third_3)          # 2 - 3: ==> false

# ╔═╡ 9693a82e-6afd-4a38-9a83-8efc6035076c
equalRat(one_half_3, one_half_1)           # 3 - 1: ==> true

# ╔═╡ 42c7d920-94f5-430e-856b-4c62a3c7d06d
equalRat(one_half_3, one_third_1)          # 3 - 1: ==> false

# ╔═╡ dd73709c-ecdb-40c7-8b7d-f6f9fd77370b
equalRat(one_half_3, one_half_2)           # 3 - 2: ==> true

# ╔═╡ ff6b0f9a-9410-443b-b5c3-5a002e5d8ff0
equalRat(one_half_3, one_third_2)          # 3 - 2: ==> false

# ╔═╡ ee7dee30-4a02-4494-9e17-d63c91f59b84
equalRat(one_half_3, one_half_3)           # 3 - 3: ==> true

# ╔═╡ 59764719-bf40-4608-9b6f-10c60f756635
equalRat(one_half_3, one_third_3)          # 3 - 3: ==> false

# ╔═╡ bcf4044f-f932-4a90-87bb-12963a67fc99
md"
---
##### 4. Idiomatic Julia with Type $Rational$
Here we demonstrate that the *built-in* datatype $Rational$ can be used  for *rational arithmetic*. It is sufficient to construct *rationals* by the construtor *//*. The aritmetic operations are done by the *normal* arithmetic operators $+,-,*,/,==$. This is possible because they are *overloaden*.

"

# ╔═╡ f1608855-54ca-464f-a48c-43046afa3dc0
md"
---

    ------------------------------------------------------------------------------
      Abstract                                                            level 2
     Operators           +         -        *        /        ==           Domain
    ------------------------------------------------------------------------------
     Constructor /           dataObject = //(numerator, denominator)       level -1
     Selectors                    numerator           denominator           Julia
    ------------------------------------------------------------------------------

    Fig. 2.1.2.3: Julia's Built-In Abstraction Hierarchy for Rational Number Algebra
"

# ╔═╡ 6b36e481-d44c-468b-b020-ff7219eb6625
md"
###### 4.1 Applications of *Built-In* Rational Arithmetic Operators
"

# ╔═╡ 20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
one_half_4 = //(1, 2)            # prefix use of '//'

# ╔═╡ 6f657710-f45d-46d5-8f92-48c9855a6ec7
one_half_4 == 1 // 2             # prefix == infix 

# ╔═╡ 522016b4-5f42-4cf9-acd7-67afd8116d90
one_third_4 = //(1, 3)           # prefix

# ╔═╡ f899358a-dbd0-4282-a743-56df2580b341
one_third_4 == 1 // 3            # prefix == infix 

# ╔═╡ 4c25c782-decc-4d3b-bc01-31577218c6a7
one_half_4 + one_third_4         # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ a6a879a4-01b4-4369-9939-0583adef57b7
one_half_4 + one_third_4 == //(5, 6) == 5 // 6 # prefix == infix and chaining '=='

# ╔═╡ da84aea9-d17e-4156-979d-8894066d3e38
one_half_4 - one_third_4         # 1/2 - 1/3 = 3/6 + 2/6 = 1/6

# ╔═╡ f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
one_half_4 * one_third_4         # 1/2 * 1/3 = 1/6

# ╔═╡ 8cc968c6-5364-4430-9449-aeafd876d567
one_half_4 / one_third_4         # 1/2 / 1/3 = 1/2 * 3/1 = 3/2

# ╔═╡ d88f2af4-e182-4c90-ab88-694834485bb7
1 // 3 == 2 // 6

# ╔═╡ dc47a501-9c50-4e5d-bcea-d2fe9609a76c
1 // 3 == 3 // 6

# ╔═╡ 8bd0c86b-fe82-4221-9d4a-66cb192b5649
one_third_4 + one_third_4         # 1/3 + 1/3 = 2/3

# ╔═╡ 03a8961e-031e-4671-9bd5-c35c6c603c19
120 // 90

# ╔═╡ a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
md"
###### 4.2 [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ d44cb419-7a01-4236-b561-a03892cfcead
pi_approximation =
let pi_rat = 355//113
	numerator(pi_rat)/denominator(pi_rat)
end

# ╔═╡ 118ba1f9-8643-43c8-b5a0-18b71a61547d
error = abs(pi_approximation - π)

# ╔═╡ c410d926-7447-417a-a601-1b1de36a38fd
md"
---
##### 5. Summary
We demonstrated tha we can [*overloaden*](https://en.wikipedia.org/wiki/Function_overloading) *self-defined* *domain-specific* operators und use *built-in* [*overloaden*](https://en.wikipedia.org/wiki/Function_overloading) operators. For the latter it is sufficient to use the relevant constructors. In this case it is the *constructor* *//*.
"

# ╔═╡ cffadb80-3e20-4600-8419-8d6a59646471
md"
---
##### 6. References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/27
- **Wikipedia**; [*Function Overloading*](https://en.wikipedia.org/wiki/Function_overloading); last visit 2025/05/01
- **Wikipedia**; Rational approximation to π, [https://en.wikipedia.org/wiki/Approximations_of_%CF%80](https://en.wikipedia.org/wiki/Approximations_of_%CF%80), last visit 2022/08/27
"

# ╔═╡ 965557ac-81b4-4cf7-a2e5-3b6efff094be
md"
---
##### end of ch. 2.1.2
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
# ╟─e8c1f880-0278-11ec-2538-13bb2f14d606
# ╟─55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
# ╟─ac6e9c0b-74bc-4678-88c7-e0324fb08c74
# ╟─e97e2c65-766d-4e02-987a-99ddece88f85
# ╠═38627173-e982-4047-bd77-6fe4c654f249
# ╟─54d411b7-abc4-46e0-9a80-edb6be2943b3
# ╟─61340177-3808-4a2b-906f-51b801178c6f
# ╠═172db576-f756-4d62-94c3-128c6ac4f847
# ╠═0c40b6a6-9f60-4590-a7c5-517495230bf7
# ╠═6d096e3e-3313-4889-aa5b-387e75912d5e
# ╟─2b87595b-9491-4ebe-acb9-1ab7d43c4678
# ╟─a27e5207-ffb7-4f91-ba46-2006be39fd81
# ╟─d1ce04e2-d2df-4654-83be-1c037993ea2c
# ╟─e9bddc5e-4ba7-47f3-9d04-bb1f7755c186
# ╟─d4e48294-c66c-4fa3-9586-89fb825a4ee8
# ╟─dc723ee4-97ce-41a3-88b0-49ccb31c289e
# ╟─152b7e64-4ea3-45c8-980f-20fabd582f99
# ╠═ca75c0f7-2e85-4436-8544-9b19aa0f57a8
# ╟─a924f831-9f00-48c4-b426-952f949afc00
# ╠═eb072b24-168a-4904-8ed3-03aa1c01065d
# ╟─44a76d47-e90f-4eff-b10e-2e4a919d6758
# ╠═a7170ca7-9ec7-4287-8106-5c43b7de6cfc
# ╟─196b5747-9cb3-43ac-9adf-8915cf22e521
# ╠═98224b21-d99c-4b74-8504-4b5e90ff31fe
# ╟─f540c73a-5727-414e-a1d2-554a408d1bb7
# ╠═76e3a4bc-fde2-4440-96c1-c492cc120db0
# ╟─7e7feddd-31f8-46c4-b377-4affdec7c42a
# ╠═62564d67-cbef-4e27-b14a-83104cc0768b
# ╟─81244844-d8ab-498b-afee-84cf663a5af3
# ╠═26593de4-f70d-4aa5-86dd-d09bb6544407
# ╟─e679c12d-f4d9-4c1d-aade-6802c8b01234
# ╠═6b56f16c-9408-4d94-a0f8-828cfa784290
# ╟─a1d2079d-e8ec-4dba-9bab-666436b725bc
# ╠═b901e798-6587-4452-bfc1-fe7895a13996
# ╟─68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
# ╟─1b95ab13-e2e7-4ea7-83c0-bc8c4ca1d2e7
# ╠═a181310f-1f46-43b2-8702-a8a60308ccfe
# ╟─d1b30696-2026-4393-adb2-efeb10cc09ab
# ╠═54896d9b-bb75-4fbf-992f-6657230f0fdf
# ╟─014c61cd-7da6-487d-b122-0f44b65fc037
# ╠═0fd74237-7874-415e-a43d-8fb12b6fd7f2
# ╟─94673bca-56d7-41f7-9d04-22048435e648
# ╠═492177d6-fec9-49c2-bb26-2b42f916d912
# ╟─d5517035-6410-4c48-abf7-c128e519530b
# ╠═402d8963-26bc-4db2-b94b-ba4334e1d8fd
# ╟─9488a987-9987-49cc-869c-5f399e7c41b3
# ╠═68289adf-f3f9-4160-b618-cbcfc88f6ab1
# ╟─7ceb6a3c-7a58-4e8c-adad-5d4568437661
# ╠═7609f497-9ab3-4fe0-b5e3-c1c02a55ee52
# ╟─3a03e2a7-bfd6-4825-885f-e394ee4a801e
# ╠═4d9ea031-9f81-47cc-acbb-79768f307fda
# ╟─0159462b-70f1-43d9-8e8f-80552fd47c26
# ╠═6662d041-af9c-472d-b9fe-efe2c4846267
# ╟─bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
# ╟─15159a4f-cf52-411c-95b7-f969fa869483
# ╠═778e12ad-bfe7-4f02-a946-894249fe2375
# ╟─c7d6c275-1ce0-4d77-b09f-7a99fba7d27b
# ╠═57cc9fa7-9547-4c52-b8fb-db10e3aa6bae
# ╟─76abe333-f050-4775-afc0-f89917297688
# ╠═56bce8c4-25be-4c4f-a79b-d2834121c9dd
# ╟─919bc317-66b5-4b7d-b739-3353f4f86ba6
# ╠═e8982f26-04ac-4061-8089-a5966a39a85f
# ╟─be113fde-c15d-4def-b050-ccb13250ae0e
# ╠═09901068-bf38-4392-ab19-66a44d65344d
# ╟─15b509c9-b182-4713-8a23-dc5cb5e68161
# ╠═297ed8b1-85a9-4fb1-9d26-83e647c1dcaa
# ╟─4e327188-17e3-41dd-8e7f-d7daf3c0a653
# ╠═3db2bda6-5edf-4126-99b6-483f36a4fc22
# ╟─5d564bd2-0244-468f-a9d8-05628f02206e
# ╠═916ed2b6-36ac-45a3-a4a3-fd9295f4d678
# ╟─1c27cf65-3c75-4307-85b9-7afebfdcc833
# ╠═8fc62f98-9a2e-4fae-83b7-a78118b656d3
# ╟─0875ee4d-e127-4140-a863-04c3a02c38a5
# ╟─cd626c5d-e52c-47a6-8e5d-017d6cd1e190
# ╠═fbb683ca-d4e2-4d0c-b622-45ea6c7af7e7
# ╟─85c353d5-0ad0-4ec6-b38e-55b259fe2085
# ╠═bb1f5e65-9d08-4b81-8ae6-6178241518de
# ╟─bf888421-1ee0-4f91-b818-69328d3738ab
# ╠═abee7262-c11c-4c26-ba5f-14631dcd9b67
# ╟─fe73efa5-77f5-4a9c-84df-b1b37c606e8c
# ╠═022a1471-1b99-4ac1-a038-fec0ad5bd7c0
# ╟─f5f6c90a-9d81-4918-aa0d-346d9bc05dab
# ╠═34413a78-f6b7-44d0-b280-d99ba4b99e20
# ╟─b97c8f4c-a09b-4710-9800-9b136d2a4c65
# ╠═ed895a47-6196-4812-bc2f-0eb244c17ef4
# ╟─937201dd-05f3-4d5b-ba80-667c54837b02
# ╠═8a963537-d72e-411d-9084-64649cb878e1
# ╟─23a7dbfe-a7eb-4591-8743-a36d144a0d5f
# ╠═5b4036bd-d88d-42ef-b705-d915b553880c
# ╟─79e70b98-ce00-4fd5-b03e-df17af794d09
# ╠═dca9d7a4-c84e-4dc6-9bdd-e043fdd2f936
# ╟─f74ced3c-487c-4428-bcfc-cc69e5416227
# ╟─b8712d12-1412-4a8e-a7ab-362bfdeccd81
# ╠═bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
# ╟─4013c24f-39fc-4b51-aeeb-c87b96360e7e
# ╠═165cbcb1-6457-4762-8864-7f9e3fe429e5
# ╟─8c0d74df-a4ae-482f-87ce-ad2e4a574005
# ╠═899afab4-67a4-4c7b-b436-85e79f6b2930
# ╟─d79f0229-d42a-4293-abb6-467746a3c1e5
# ╠═34c8fdfe-9e05-4236-bd26-b6ea12823ba0
# ╟─ed8d4587-371a-47e6-84d0-b9775a48eb02
# ╠═afe55885-aba6-4cbc-af2c-23d15bbbf6f5
# ╟─808660d6-5eb1-4546-90fb-e1a4b328fbe6
# ╠═0bee0a3a-8375-41fd-b149-5220c843406f
# ╟─3a1e2fc6-64fe-4b3f-8beb-83aa1d987dfe
# ╠═b01171e9-43b8-40cf-aac9-ae4e1b684834
# ╟─88faf1ad-b0c2-4fbf-bde9-53eb44c7bc54
# ╠═e901290e-1307-44cc-8ca9-2952c48e2c96
# ╟─c0a4730c-7132-47e9-932e-27e7060e9fb6
# ╠═dc59fed0-e8fd-4918-9dfa-8882e1ab2edc
# ╟─647ac904-63b2-422d-9f7f-9cd971125bd9
# ╟─934515c1-5328-4ef8-9e8a-36d46e1130e7
# ╟─680c5ec0-6cf2-4b0c-a005-751ef8a7e568
# ╠═7ff3b4a0-e00b-424f-8118-897019d0fc20
# ╟─810b1eca-eac7-49cb-a34f-8328ea432824
# ╠═df37be85-589a-46aa-a14c-8ab67c461ae9
# ╟─40745707-b542-43b1-9be3-e8b62f03f594
# ╟─0fd6dfda-7893-43e6-a97f-6e5fc237ddfe
# ╠═3498e844-931f-4d46-a9aa-b9a2d3b892e7
# ╟─f5ecccb7-0a95-4417-8125-0688af9eed3e
# ╟─a4aae618-e5d7-4805-aa9a-eba90339f046
# ╠═6858b169-b9dc-4a23-8dd3-8951033bd311
# ╟─c593932a-c212-4675-b756-ec643fec86e5
# ╟─176a02cb-a0aa-4ba3-bb6a-628ae7c55459
# ╠═193ae321-0f26-44cc-a48f-1a1b9bc71af8
# ╟─71ba8f42-ca4f-4c6c-b129-3a1cff08ea63
# ╠═7f5b9164-07c2-4ae1-888d-f601fa9d286c
# ╟─370414ed-eeb1-483d-8aca-561a97e32658
# ╠═0a935144-2c44-480b-9c6e-53408b972e89
# ╟─76f2a684-7f4b-4367-8db5-60ec983afba4
# ╠═d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
# ╟─0f6cd42e-1ca3-4b54-8db5-82a2d1356a68
# ╠═3ca05b52-413f-46aa-9fd7-659227dccbd7
# ╟─688db011-603f-47b3-899e-706e0089441b
# ╠═7c2af484-eea8-4c8c-8891-4aa4923298ae
# ╟─a9341f5b-8b06-4994-ba6b-58070485c336
# ╠═8c3bff44-929d-4891-a3c7-53b9be36054e
# ╠═50b8cf20-537b-45b7-a5cb-02f2f3e669cd
# ╠═fdafce07-ec12-46be-9d33-16623e962af4
# ╠═5e343050-8037-4ce7-abd6-eb2f0bc9fdff
# ╠═904ad2a6-aa36-4469-85bd-3bf0264ae3a6
# ╠═b8594f35-dbcc-402d-ae51-ec56d278016f
# ╠═fbe308f1-c0d9-4f40-b79f-fa325923f07e
# ╠═2e089c95-467d-40f6-babd-979011013ed0
# ╠═ae066a31-138e-4f9e-8d30-aea918850db6
# ╠═18b6a504-1e46-4b32-b336-197fc639e7f3
# ╠═6889469f-57ca-44b4-91a1-6cba355647ef
# ╠═632f4826-8d33-4047-a265-0bf81a7cb77d
# ╠═a1a3bb76-9ba0-425d-b10b-01b958461ab9
# ╠═6d8e4372-a1e3-4d8e-93f7-1b0e987a4800
# ╠═59ec0583-db14-4e4c-8b6b-0a2035bc89d1
# ╠═0585b0dd-18e4-47bd-9bc3-2da0ba9528e2
# ╟─81767db0-ca16-4872-9d91-b0f55baf77a8
# ╠═813f7f22-da40-4ea6-bb56-58765ed2f7f8
# ╠═43736c04-45b9-4722-a943-4adaf5f166b7
# ╠═dea3812a-2da7-462d-949f-e4db34153568
# ╠═cd10aae3-074c-44c5-a4ba-5ddf2e030c88
# ╟─ec878031-9e74-4a7c-a402-16641f34f0e9
# ╠═4a188ea0-f4ed-413e-bd4f-40137c37a6df
# ╠═79e81a4b-8d60-46c1-81f2-397a670f9534
# ╠═9f6f2dbd-43ab-4331-97d1-4194cf7b4296
# ╠═c1798a2b-d9e4-4037-8234-0979f45d616c
# ╠═d05c5ec8-664e-4f4d-ba59-4eeed6e3ecef
# ╠═55379ada-b823-49ef-a197-8dd215d80398
# ╠═60943d51-d452-4e8f-9dcc-f32582d5d329
# ╠═d09fc57f-d7e8-4a68-b936-2ea20f789e80
# ╠═fbf8a9e3-a20d-4561-b6a0-843ecd35c176
# ╠═dca4a1e9-d1a7-439b-a7cd-a73b14464a0e
# ╠═fb7727cd-9fde-440f-b8ba-6fa2f52c174b
# ╠═3d3ee875-5d76-4edd-a945-2c6477795ae4
# ╠═c0071c32-c45c-44a8-80a4-0189b6833f51
# ╠═8a2b87ff-e78f-44b2-b4df-cf57db3d46d8
# ╠═052d3986-6bf3-4619-8d41-5e9c91f9ed21
# ╠═cf19df94-0dca-4f03-8c97-9df84b21cf67
# ╟─001b974e-9ac4-48d9-9fc2-e76b4570cd10
# ╠═6c5b6102-9323-480d-bcdb-88f795615fa4
# ╠═0c152ce9-cb4a-4d80-958c-34147777470b
# ╠═3e75d1a8-e5da-47a0-aaa3-7e3d831f78e9
# ╠═145688ab-55e3-4fe6-8e47-77470bc74cd8
# ╟─4768fea6-bff8-4e91-984e-be3a3d6cb2dc
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
# ╟─dbbb5dda-708d-44df-b04f-a793b0ec9e83
# ╟─6cbab1cd-396e-4bba-a593-838bc32e2a29
# ╠═0abc4683-5b12-4a82-91ee-36844e0e302f
# ╠═06c5af9c-1dd9-4924-83d8-1beba749cd22
# ╠═fa18366a-5704-47b9-a745-810c7798f449
# ╠═3f9cb20a-e12e-4acd-ae75-63f621e671f2
# ╠═92e0d133-1f3f-431d-aaca-639d18b9f61e
# ╠═a9d5b451-caeb-4a33-a4c9-b72f2a9c4fac
# ╠═5b57fb8e-64a1-4f68-90d0-5b7d9dc5618d
# ╠═7ec61c23-d28e-4235-9196-12ccff5dc21f
# ╠═61536501-69ab-4e47-94c9-c5afc0d7edd7
# ╠═cb59a26c-3eeb-4361-ba0f-c43e21e507d5
# ╠═4624578a-7579-426b-8d94-a3525ac708e6
# ╠═89e1d980-3a33-46d3-9694-1444ddb2f12f
# ╠═f688cdeb-ffec-41bf-844b-2674616ceb48
# ╠═2a4d64f4-04fe-41af-9dbe-d1d8753478e1
# ╠═0d05af2e-77af-4e05-a942-775fee3d7d95
# ╠═d4f33142-611d-41fa-9af8-0b42b87c2663
# ╠═f980a5a1-309e-490b-b519-b5fdd142030e
# ╠═f5ad1126-2c6c-4937-8e95-142ce6e9b670
# ╟─1ca2e34a-b318-42bf-aad5-59f6a16d994b
# ╠═bbe24a13-97e3-4f43-8b42-43d020e4843d
# ╠═2d2c7b49-9cb3-4ed5-882e-b988f7aca16c
# ╠═6b87c99c-ceab-4d22-a3b8-e58115a2c125
# ╠═621b51fb-636c-4b27-bdba-3960e8c0fc1f
# ╠═cb7fcc8f-f96a-4786-9e49-b0053ed8da0c
# ╠═54d5063c-7020-42c0-b2ee-81ae47ddf3db
# ╠═ce424610-773b-4406-b5ec-6e70c3bdcce4
# ╠═1700a82e-eecb-45f2-bd4e-e25d0c577f7b
# ╠═b61afb92-ce5f-45f7-9032-361ef90a96fe
# ╠═044f71a2-4202-4e68-889b-ea594ee364c9
# ╠═aabc7068-cf5e-4824-81a8-0bb11de88033
# ╠═71cf5c5d-61a5-467a-b227-b4aa255a8a7f
# ╠═93fb8250-9ed7-4b4d-a960-1b42f750aa90
# ╠═60f681af-ac61-4775-8d39-5cc0eb41566e
# ╠═d4753a17-740a-444f-bbde-824bd5126e2c
# ╠═68e96428-31d8-4e8f-9c63-4aee9aba2470
# ╠═63416d10-96e6-4fad-8295-6212949e9e3e
# ╠═13d6e5e9-66a8-43c9-87e8-7ef3751c668a
# ╟─7caf15d5-2af8-4a76-868e-494766022f97
# ╠═0533dbc0-dd8f-4d49-af95-be6e2f684aa8
# ╠═0ec3ba72-5d99-484a-bf6f-c0999eb0d10e
# ╠═6455f2e3-cfc2-4ca5-b71e-969e9146211c
# ╠═9f46bbd3-dae7-4dbb-b14f-6e7da348a576
# ╠═7eb35118-58d3-4c90-877d-8d2a2acfa5e2
# ╠═6ff1a9be-cbfc-421d-a452-3af4aa6c5a4d
# ╠═99c79e60-9ab4-4d3b-9edf-4f543574c7be
# ╠═8096d062-27dd-44fc-befb-e78cde0d3947
# ╠═ecfaaae4-5f5e-4cfb-894a-e5d772dddce4
# ╠═8d188c57-c33c-444a-87bb-1a1f8dc88f77
# ╠═ada84124-62c1-4f80-aebb-f6cd0ca70785
# ╠═92ef3720-550e-4f15-90ff-78115a43b6ed
# ╠═8db72342-45c5-4f76-9f99-acd32d03ac1e
# ╠═58ed03fd-d00e-4bdc-8c82-1b04f7fcc677
# ╠═176e5216-f03b-4ce2-bb22-2ad9c709275f
# ╠═645a40cd-4f3a-4491-a127-5152721326ac
# ╠═b8d5b0c1-c45e-42fc-84b2-267c445273cf
# ╠═3ddf1552-d846-43f2-a8ea-ffe7f0e1b9db
# ╟─5cb02bc2-0731-45e5-b4be-3af24e19cae6
# ╠═aa6e7fea-62a2-48f5-a901-75c12c28dc7b
# ╠═d752b609-e506-42dc-a2b5-8724ab898d11
# ╠═15b21998-15a8-4fce-92d6-873a3fe98950
# ╠═e1eadaac-ec6c-452f-9b47-9349614f7af8
# ╠═8920dbea-0f91-40f9-b4ad-dfc4474ed8f8
# ╠═d1cfa96b-ca82-4e2c-9a4c-33d33bf900bb
# ╠═865da2b5-263a-4396-b4ca-07caccd44f68
# ╠═d2180445-e669-4fca-b375-06889e68fa1f
# ╠═5ae81274-d7f8-49d9-bbd6-f4b0a6e61e54
# ╠═3346242d-8f73-4a3e-984d-8bb96e53dbb7
# ╠═0dca1b97-eae8-4c6c-bd0a-b3f3e9addf31
# ╠═2d88ad8c-cf0a-405b-85fd-6be56f10b87c
# ╠═3514bb74-a490-4e5e-8202-2c16bf00dfee
# ╠═5ac0f286-c292-4ecf-8f84-10a4f3a6fccb
# ╠═4e083679-1f4c-48fa-a171-54503bb26ddd
# ╠═71700b1e-7016-49f9-9b20-ff34c5d9a7df
# ╠═c1bde8cb-1009-4456-b31a-4aa4488e329c
# ╠═aa64e9a8-80e2-41d2-a886-f8a30d6c53eb
# ╟─a194be2e-3906-433e-83e3-6ab3a1e83ba7
# ╠═91236ce5-a48d-4ea8-ab43-afa37f4ce89f
# ╠═f06a7b43-1452-436f-9502-8e6e29316bc9
# ╠═55cfaee3-8520-4556-9076-fee288ba33c3
# ╠═12acb5c5-810d-40f7-b410-3de8ef77fdf9
# ╠═207b1e00-1af2-43ae-9d78-6aba2c17d019
# ╠═535a87aa-519a-4df5-b13a-1d203ef54fbd
# ╠═035dfcc6-fc74-44af-8f6f-47a771e46a1e
# ╠═3dcaeaea-1206-42b4-a541-cd1036b35c11
# ╠═bdf04bb6-8e48-4df0-b45f-4065b6251f89
# ╠═822cf837-97d0-405b-be7e-6420703badbf
# ╠═b8bb2ac3-39f9-46b1-b9e9-eba941534fe8
# ╠═209cdbae-6e63-458e-801b-450155f506ed
# ╠═9693a82e-6afd-4a38-9a83-8efc6035076c
# ╠═42c7d920-94f5-430e-856b-4c62a3c7d06d
# ╠═dd73709c-ecdb-40c7-8b7d-f6f9fd77370b
# ╠═ff6b0f9a-9410-443b-b5c3-5a002e5d8ff0
# ╠═ee7dee30-4a02-4494-9e17-d63c91f59b84
# ╠═59764719-bf40-4608-9b6f-10c60f756635
# ╟─bcf4044f-f932-4a90-87bb-12963a67fc99
# ╟─f1608855-54ca-464f-a48c-43046afa3dc0
# ╟─6b36e481-d44c-468b-b020-ff7219eb6625
# ╠═20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
# ╠═6f657710-f45d-46d5-8f92-48c9855a6ec7
# ╠═522016b4-5f42-4cf9-acd7-67afd8116d90
# ╠═f899358a-dbd0-4282-a743-56df2580b341
# ╠═4c25c782-decc-4d3b-bc01-31577218c6a7
# ╠═a6a879a4-01b4-4369-9939-0583adef57b7
# ╠═da84aea9-d17e-4156-979d-8894066d3e38
# ╠═f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
# ╠═8cc968c6-5364-4430-9449-aeafd876d567
# ╠═d88f2af4-e182-4c90-ab88-694834485bb7
# ╠═dc47a501-9c50-4e5d-bcea-d2fe9609a76c
# ╠═8bd0c86b-fe82-4221-9d4a-66cb192b5649
# ╠═03a8961e-031e-4671-9bd5-c35c6c603c19
# ╟─a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
# ╠═d44cb419-7a01-4236-b561-a03892cfcead
# ╠═118ba1f9-8643-43c8-b5a0-18b71a61547d
# ╟─c410d926-7447-417a-a601-1b1de36a38fd
# ╟─cffadb80-3e20-4600-8419-8d6a59646471
# ╟─965557ac-81b4-4cf7-a2e5-3b6efff094be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
