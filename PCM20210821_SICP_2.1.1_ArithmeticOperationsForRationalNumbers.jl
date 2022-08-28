### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ e8c1f880-0278-11ec-2538-13bb2f14d606
md"
======================================================================================
#### SICP: [2.1.1 Arithmetic Operations For Rational Numbers](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e1)

###### file: PCM20210821\_SICP\_2.1.1\_ArithmeticOperationsForRationalNumbers.jl

###### Julia/Pluto.jl-code (1.8.0/19.11) by PCM *** 2022/08/28 ***
======================================================================================
"

# ╔═╡ 6011e641-b628-4642-8c55-549b05efbb89
md"
##### More on *rational numbers* can be found [here](https://en.wikipedia.org/wiki/Rational_number)
"

# ╔═╡ 2b87595b-9491-4ebe-acb9-1ab7d43c4678
md"
#### 2.1.1.1 SICP-Scheme-like *functional*, mostly *un*typed Julia
###### ... with *imperative* construct $$while$$
"

# ╔═╡ 55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
md"
We represent rational numbers as *pairs* of numerator and denominators in four alternative ways:
- the *first* is the *default* way, very *Scheme-like* by an *un*typed *named tuple* with two fields $$car$$ and $$cdr$$; the construction is deferred into the body of a constructor function $$cons$$. 
- the *second* is the first *specialized* way by using Julia's *built-in* type $$Pair$$. The construction of pairs is deferred to the body of a constructor function $$cons2$$. The two fields can accessed by $$first$$ and $$second$$. They are hidden in the *Scheme*-like selector functions $$car2$$ and $$cdr2$$.
- the *third* is the second *specialized* way by using Julia's *built-in* type $$Rational$$. The construction of pairs is deferred to the body of a *Scheme*-like constructor function $$cons$$. The two fields can accessed by the functions $$numerator$$ and $$denominator$$. They are hidden in the *Scheme*-like selector functions $$car3$$ and $$cdr3$$.
- the *fourth* is the most easy and third *specialized* way by using Julia's *built-in* type $$Rational$$ and its *built-in* operators $$+, -, *, /$$, and $$==$$. The construction of rationals is done by using Julia's *built-in* constructon operator $$//$$. The two fields can accessed by $$numerator$$ and $$denominator$$. 
"

# ╔═╡ d4e48294-c66c-4fa3-9586-89fb825a4ee8
md"
##### 2.1.1.1.1 Arithmetic Operations for Rational Numbers 
###### *1st* methods (*default*, *un*typed) of functions $$add\_rat$$, $$sub\_rat$$, $$mul\_rat$$, $$div\_rat$$, $$equal\_rat$$ 
"

# ╔═╡ dc723ee4-97ce-41a3-88b0-49ccb31c289e
md"
---
###### Addition
$$+\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x+y = \frac{n_x}{d_x}+\frac{n_y}{d_y}= \frac{n_x d_y + n_y d_x}{d_x d_y}$$

---
"

# ╔═╡ 68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
md"
---
###### Subtraction
$$-\;\; : \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x-y = \frac{n_x}{d_x}-\frac{n_y}{d_y}= \frac{n_x d_y - n_y d_x}{d_x d_y}$$

---
"

# ╔═╡ bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
md"
---
###### Multiplication
$$\cdot\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$x \cdot y = \frac{n_x}{d_x} \cdot \frac{n_y}{d_y}= \frac{n_x n_y}{d_x d_y}$

---
"

# ╔═╡ 0875ee4d-e127-4140-a863-04c3a02c38a5
md"
---
###### Division
$$/\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x/y = \left(\frac{n_x}{d_x}\right)/\left(\frac{n_y}{d_y}\right) = \frac{n_x d_y}{d_x n_y}$$

---
"

# ╔═╡ f74ced3c-487c-4428-bcfc-cc69e5416227
md"
---
###### Equality test
$$=\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb B$$
$$(x=y) \equiv \left(\frac{n_x}{d_x} = \frac{n_y}{d_y}\right) \equiv (n_x d_y = d_x n_y)$$

---
"

# ╔═╡ 08ede030-fb83-4337-8c37-f346b1b7ebc0
md"
---
##### 2.1.1.1.2 Pairs (... as *Named* Tuples)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ are implemented here as Julia-*tuples* with *named* fields
"

# ╔═╡ a27e5207-ffb7-4f91-ba46-2006be39fd81
md"
---
     ---------------------------------------------------------------------------
     Operators       add_rat   sub_rat   mul_rat   div_rat   _equal_rat
     --------------------------------------------------------------------------- 
     Constructor /                           make_rat                   

     Selectors                         numer          denom  
     ---------------------------------------------------------------------------
     Constructor /                             cons            

     Selectors                           car            cdr
     ---------------------------------------------------------------------------
     Constructor /             consCell = (car = ... , cdr = ...)

     Selctors                      consCell.car    consCell.cdr
     ---------------------------------------------------------------------------

    Fig. 2.1.1.1: First Default Abstraction Hierarchy for Rational Number Algebra
---
"

# ╔═╡ 1c6a666d-c388-4ac9-b65f-dcebf9fc082f
md"
###### *1st* method (*default*, *un*typed) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with named fields $$car$$ and $$cdr$$
"

# ╔═╡ 3b7faab0-b8e0-4bea-894f-16fd35e5727f
cons(car, cdr) = (car=car, cdr=cdr) # cons(<par1>, <par2>) = (car=<par1>, cdr=<par2>)

# ╔═╡ 80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
car(cons) = cons.car                # definition of selector 'car'

# ╔═╡ 1c695d3b-c88e-4227-8aa1-e88149a4f9f4
cdr(cons) = cons.cdr                # definition of selector 'cdr'

# ╔═╡ fff492e2-429a-40ca-bfb9-8b915020ed26
md"
---
                     consCell --------------->.
						                	 / \         
		                                    1   2

Fig. 2.1.1.2:  consCell := (1 . 2)

---	
"

# ╔═╡ 3fba0329-19ac-485a-a56d-ee64ae0e3573
consCell = cons(1, 2)            # construction of 2-tuple consCell

# ╔═╡ 44d3380a-b2ab-43e1-8f03-a14a9599fac0
typeof(consCell)

# ╔═╡ 44017d8b-476e-4e9c-abac-229e9a2e85d1
car(consCell)                    # selection of field 'car' of 2-tuple consCell

# ╔═╡ 51732672-ee53-46e7-85bf-217f531867cc
cdr(consCell)                    # selection of field 'cdr' of 2-tuple consCell

# ╔═╡ e4aafaae-560c-4b4f-8ac0-10c159db1d6a
md"
---
                                              .<---------------y
						                	 / \         
		                                    3   4

Fig. 2.1.1.3: cons-cell y := (3 . 4)

---	
"

# ╔═╡ a1587038-c11d-4b4b-8436-b098b61f1077
y = cons(3, 4)               # construction of 2-tuple (= cons-cell) y

# ╔═╡ 118b16a3-093f-4b39-823b-ac167da69615
car(y)

# ╔═╡ fb4ecf01-1361-43c5-854d-8c83969a2e60
cdr(y)

# ╔═╡ cdd8bf06-1f89-4a5a-aeb8-60fde3143bec
md"
---
                        z---------------->.
                                         / \
                                        /   \
                                       /     \
                        x------------>.       .<-----------y
					        		 / \     / \         
		                            1   2   3   4

Fig. 2.1.1.4: cons-cell z := cons(x . y) = ((1 . 2) . (3 . 4))

---
"

# ╔═╡ f0c42132-4b04-4b48-aa45-b45b4f585466
x = cons(1, 2)

# ╔═╡ 132232a8-495f-4f2c-a08a-da4b898f606b
z = cons(x, y)               # construction of 2-tuple z

# ╔═╡ 768b4543-6d34-4af7-9ee1-6120a33a169d
car(z)

# ╔═╡ 8b990c96-d5e2-4e77-ae73-eae3bc399f9d
cdr(z)

# ╔═╡ 4e7da88e-e73e-4d15-bd5f-b1eed925322d
car(car(z))

# ╔═╡ 9b7d9d52-77c6-4328-8018-3b1e40fb9558
car(cdr(z))

# ╔═╡ 7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
md"
---
##### 2.1.1.1.3 Representing Rational Numbers (... with *Named* Tuples)

"

# ╔═╡ 8b2fb52c-7519-410f-a872-610cdb911b72
md"
##### 2.1.1.1.3.1 Abstract *Untyped* Constructor $$make\_rat$$ based on $$cons$$
"

# ╔═╡ 680c5ec0-6cf2-4b0c-a005-751ef8a7e568
md"
###### *1st* method (default, *un*typed, *without* gcd) of function *make_rat*
"

# ╔═╡ 7ff3b4a0-e00b-424f-8118-897019d0fc20
make_rat(n, d) = cons(n, d)  

# ╔═╡ 810b1eca-eac7-49cb-a34f-8328ea432824
md"
###### *2nd* method (*specialized*, *typed*, *with* gcd) of function *make_rat*
###### ... with type $$Signed$$ and imperative *looping* construct $$while$$
"

# ╔═╡ df37be85-589a-46aa-a14c-8ab67c461ae9
function make_rat(n::Signed, d::Signed)
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
		cons(n ÷ g, d ÷ g)
	end # let
	#----------------------------------------=-----------------
end # function make_rat

# ╔═╡ 764ec0e3-66c3-4a67-9473-95380e11250b
md"
##### 2.1.1.1.3.2 Abstract *Un*typed Selectors $$numer, denom$$ based on $$car, cdr$$
"

# ╔═╡ 193ae321-0f26-44cc-a48f-1a1b9bc71af8
numer(x) = car(x)            # definition of abstract selector 'numer'

# ╔═╡ d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
denom(x) = cdr(x)            # definition of abstract selector 'denom'

# ╔═╡ ca75c0f7-2e85-4436-8544-9b19aa0f57a8
function add_rat(x, y)
	make_rat(+(*(numer(x), denom(y)), *(numer(y), denom(x))), *(denom(x), denom(y)))
end # function add_rat

# ╔═╡ a181310f-1f46-43b2-8702-a8a60308ccfe
function sub_rat(x, y)
	make_rat(-(*(numer(x), denom(y)), *(numer(y), denom(x))), *(denom(x), denom(y)))
end

# ╔═╡ 778e12ad-bfe7-4f02-a946-894249fe2375
function mul_rat(x, y)
	make_rat(*(numer(x), numer(y)), *(denom(x), denom(y)))
end

# ╔═╡ dce13d9a-7ffd-475a-84de-7826a1198f38
function div_rat(x, y)
	make_rat(*(numer(x), denom(y)), *(denom(x), numer(y)))
end

# ╔═╡ bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
function equal_rat(x, y)
	*(numer(x), denom(y)) == *(denom(x), numer(y))
end

# ╔═╡ 61340177-3808-4a2b-906f-51b801178c6f
md"
##### 2.1.1.1.3.3 Output function $$print_rat$$
(= Transformation of *internal* into *external* form)

"

# ╔═╡ 172db576-f756-4d62-94c3-128c6ac4f847
# idiomatic Julia-code with string interpolation "$(.....)"
print_rat(x) = "$(numer(x))/$(denom(x))"

# ╔═╡ a9341f5b-8b06-4994-ba6b-58070485c336
md"
##### 2.1.1.1.4 Applications
"

# ╔═╡ 9b1a0332-0170-424b-be4d-abba0c042ff6
one_half = make_rat(1, 2)

# ╔═╡ 5e19e77d-ccea-4825-807d-5a278d762978
typeof(one_half)

# ╔═╡ cafada61-82c1-4231-bcd8-9887df2be87c
one_third = make_rat(1, 3)

# ╔═╡ e20d52b3-204c-4105-a362-2b9e66fe22f9
two_twelves = make_rat(2, 12)             # with (!) application of gcd

# ╔═╡ 63d09ac2-193d-49dc-9eff-d5c14f973627
add_rat(one_half, one_third)              # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 69facaff-5c1f-4c8e-a436-81e8f9cd73b9
equal_rat(make_rat(2, 3), make_rat(6, 9)) # 2/3 = 6/9

# ╔═╡ 45772e1e-aa83-46cd-add7-4f977f58dff0
equal_rat(make_rat(1, 2), make_rat(3, 6)) # 1/2 = 3/6 => 1/2 = 1/2

# ╔═╡ d3d1980c-00f3-4d04-abe5-8705f61b3459
equal_rat(make_rat(4, 3), make_rat(120, 90))  # 4/3 = 120/90 => 4/3 = 4/3

# ╔═╡ a861fc71-5a96-43b4-9a8f-94a603d2cb3b
md"
###### new: [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ aa7ea22e-f330-427e-9d89-408003e6b8f2
355/113

# ╔═╡ bf4034ad-07ff-4400-8aba-3b855fc43a5c
355/113 - π                   # deviation from Julia π

# ╔═╡ c70c4a99-32b9-4c70-8b36-064d313e753c
md"
---
#### 2.1.1.2 idiomatic *imperative*, *typed* Julia ...
###### ... with types $$Signed$$, $$Pair$$, $$Rational$$, *multiple* methods, '%', and 'while'
"

# ╔═╡ 285428ce-c13e-43ca-add3-672b1e454e18
md"
##### 2.1.1.2.1 Arithmetic Operations for Rational Numbers 
###### *2nd* methods (*specialized*, *typed* ($$Pair$$)) of functions $$add\_rat$$, $$sub\_rat$$, $$mul\_rat$$, $$div\_rat$$, $$equal\_rat$$
"

# ╔═╡ cc592f32-8785-4735-badd-de3903c20f05
md"
---
##### 2.1.1.2.2 Pairs (... as Julia's $$Pair$$)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ are implemented here as Julia's $$Pair$$
"

# ╔═╡ d4c053d6-ba2c-4d88-beef-19873926df88
md"
###### *2nd* method (*specialized*, *typed*) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with constructor $$Pair(<par1>, <par2>)$$ and fields $$first$$ and $$second$$. These selectors are deferred and hided into the *Scheme*-like selctors $$car, cdr$$.

"

# ╔═╡ 28c75fb7-1c58-46d0-90bc-534791c4693b
md"
---
     ---------------------------------------------------------------------------
                 add_rat   sub_rat   mul_rat   div_rat   _equal_rat
     --------------------------------------------------------------------------- 
                      make_rat         numer          denom
     ---------------------------------------------------------------------------
                        cons            car            cdr
     ---------------------------------------------------------------------------
     Constructor /         consCell = Pair(first: ... , second: ...)

     Selectors                consCell.first     consCell.second
     ---------------------------------------------------------------------------

    Fig. 2.1.1.5: Second Abstraction Hierarchy for Rational Number Algebra
---
"

# ╔═╡ 0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# idiomatic Julia-code by built-in types 'Signed' and constructor 'Pair'
cons2(car::Signed, cdr::Signed)::Pair = Pair(car::Signed, cdr::Signed)::Pair

# ╔═╡ 1fddd3ae-5da7-4a32-a53e-077b8f37509c
car2(cons::Pair)::Signed = cons.first::Signed   # Pair-selector 'first'

# ╔═╡ b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
cdr2(cons::Pair)::Signed = cons.second::Signed  # Pair-selector 'second'

# ╔═╡ d84101ea-7172-4e1f-9929-1a23acd7a7c7
md"
---
##### 2.1.1.2.3 Representing Rational Numbers (... with type $$Pair$$)

"

# ╔═╡ b4c9a74b-5a49-452e-bbf0-44826cd92e46
md"
###### 2.1.1.2.3.1 Abstract *Typed* Constructor $$make\_rat$$
"

# ╔═╡ 3498e844-931f-4d46-a9aa-b9a2d3b892e7
# idiomatic Julia-code by '÷'
function make_rat2(n::Signed, d::Signed)::Pair
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
end # function make_rat2

# ╔═╡ 4e179b9f-021e-4891-8e27-7fa36b827fcf
md"
###### 2.1.1.2.3.2 Abstract *Typed* Selectors $$numer, denom$$
"

# ╔═╡ 7f5b9164-07c2-4ae1-888d-f601fa9d286c
numer2(x::Pair)::Signed = car2(x::Pair)::Signed

# ╔═╡ 3ca05b52-413f-46aa-9fd7-659227dccbd7
denom2(x::Pair)::Signed = cdr2(x::Pair)::Signed

# ╔═╡ 76e3a4bc-fde2-4440-96c1-c492cc120db0
function add_rat2(x::Pair, y::Pair)::Pair
	make_rat2(numer2(x) * denom2(y) + numer2(y) * denom2(x), denom2(x) * denom2(y))
end

# ╔═╡ 402d8963-26bc-4db2-b94b-ba4334e1d8fd
function sub_rat2(x::Pair, y::Pair)::Pair
	make_rat2(numer2(x) * denom2(y) - numer2(y) * denom2(x), denom2(x) * denom2(y))
end

# ╔═╡ 09901068-bf38-4392-ab19-66a44d65344d
function mul_rat2(x::Pair, y::Pair)::Pair
	make_rat2(numer2(x) * numer2(y), denom2(x) * denom2(y))
end

# ╔═╡ 555e6212-22bd-4d0e-b221-edfe32f043f5
function div_rat2(x::Pair, y::Pair)::Pair
	make_rat2(numer2(x) * denom2(y), denom2(x) * numer2(y))
end

# ╔═╡ afe55885-aba6-4cbc-af2c-23d15bbbf6f5
function equal_rat2(x::Pair, y::Pair)::Bool
	numer2(x) * denom2(y) == denom2(x) * numer2(y)
end

# ╔═╡ bbccaeb3-48cf-4f65-9aa2-d0de9940e311
md"
###### 2.1.1.2.3.3 Output (= Transformation of *internal* into *external* form)
"

# ╔═╡ 1248e659-dcdb-442c-859c-3289d5561c6f
print_rat(x::Pair)::String = "$(numer2(x))/$(denom2(x))"

# ╔═╡ edd94612-1772-4c7a-b8d5-cf5b4a540487
md"
###### 2.1.1.2.4 Applications
"

# ╔═╡ 0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
a2 = cons2(2, 3)

# ╔═╡ 32e3fc67-3872-4a28-bd6b-9cf06bc094ac
car2(a2)

# ╔═╡ e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
cdr2(a2)

# ╔═╡ cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
typeof(1.2)

# ╔═╡ 4bed1729-8c79-4cf1-95e3-3285010a5622
b2 = cons2(1.2, 3) # first argument is 'Float' but should be 'Signed'

# ╔═╡ 4ee29c75-f689-4332-99b9-d7b0951d4487
one_half2 = make_rat2(1, 2)

# ╔═╡ 86b40359-a87d-477e-9615-6b4803fe4fd7
one_third2 = make_rat2(1, 3)

# ╔═╡ d650d480-08ed-478a-8a9f-92cce23ba072
equal_rat2(make_rat2(1, 3), make_rat2(2, 6))

# ╔═╡ 999406e8-787a-4f2b-9805-eed631fc6f54
equal_rat2(make_rat2(1, 2), make_rat2(3, 6))

# ╔═╡ 4bbd2664-5846-4487-b91c-be7ff75a4e81
equal_rat2(make_rat2(1, 3), make_rat2(3, 6))

# ╔═╡ 5be39e55-32ba-4809-9456-431e118b9195
md"
---
#### 2.1.1.3 idiomatic *imperative*, *typed* Julia ...
###### ... with type $$Rational$$
"

# ╔═╡ bb838586-2f8a-44f9-9672-aced83e8cf76
md"
##### 2.1.1.3.1 Arithmetic Operations for Rational Numbers 
###### *3rd* methods (*specialized*, *typed* ($$Rational$$)) of functions $$add\_rat$$, $$sub\_rat$$, $$mul\_rat$$, $$div\_rat$$, $$equal\_rat$$
"

# ╔═╡ 26593de4-f70d-4aa5-86dd-d09bb6544407
function add_rat3(x::Rational, y::Rational)::Rational
	x + y
end

# ╔═╡ 6662d041-af9c-472d-b9fe-efe2c4846267
function sub_rat3(x::Rational, y::Rational)::Rational
	x - y
end

# ╔═╡ 8fc62f98-9a2e-4fae-83b7-a78118b656d3
function mul_rat3(x::Rational, y::Rational)::Rational
	x * y
end

# ╔═╡ f7bd0981-1534-4c80-9697-e019f29c4a3c
function div_rat3(x::Rational, y::Rational)::Rational
	x // y
end

# ╔═╡ b25d2465-7452-43e8-b709-06009642076a
function equal_rat3(x::Rational, y::Rational)::Bool
	x == y
end

# ╔═╡ 32927d21-4f21-41ff-b90c-21a9c15a7a26
md"
---
##### 2.1.1.3.2 Pairs (... as Julia's $$Rational$$)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ are implemented here as Julia's $$Rational$$
"

# ╔═╡ 5f1971c7-f3bb-4dbf-aa42-4218055e1fd0
md"
###### *3rd* method (*specialized*, *typed*) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with constructor $$//$$ and fields $$numerator$$ and $$denominator$$
"

# ╔═╡ c47d0173-9fd4-4926-b426-42ff0f854c16
md"
---
     ---------------------------------------------------------------------------
                   add_rat   sub_rat   mul_rat   div_rat   _equal_rat
     --------------------------------------------------------------------------- 
                         make_rat         numer          denom
     ---------------------------------------------------------------------------
                           cons            car            cdr
     ---------------------------------------------------------------------------
      Constructor /               consCell = car // cdr

      Selectors           numerator(consCell)   denominator(consCell)
     ---------------------------------------------------------------------------

    Fig. 2.1.1.6: Third Abstraction Hierarchy for Rational Number Algebra
---
"

# ╔═╡ 47d605b7-ec32-4b72-a329-bf47e7273972
cons3(car::Signed, cdr::Signed)::Rational = car // cdr

# ╔═╡ e6e6754c-d86e-449f-a82e-03e0ab2a91cb
car3(cons::Rational)::Signed = numerator(cons)::Signed

# ╔═╡ c356aab4-4717-46a7-b041-aa14800a0253
cdr3(cons::Rational)::Signed = denominator(cons)::Signed

# ╔═╡ abf821d6-3f8a-404d-903d-0a4b49ed9d9b
md"
---
##### 2.1.1.3.3 Representing Rational Numbers (... with type $$Rational$$)

"

# ╔═╡ ce97fbfe-0a85-43c6-980f-18da5e795a98
md"
###### 2.1.1.3.3.1 Abstract *Typed* Constructor $$make\_rat3$$
"

# ╔═╡ 6858b169-b9dc-4a23-8dd3-8951033bd311
# idiomatic Julia-code by '÷'
function make_rat3(n::Int, d::Int)::Rational
	n//d
end

# ╔═╡ 8d014b03-6124-4937-aa35-599c01301efd
md"
###### 2.1.1.3.3.2 Abstract *Typed* Selectors for Type $$Rational$$
"

# ╔═╡ 0a935144-2c44-480b-9c6e-53408b972e89
numer3(x::Rational)::Signed = numerator(x::Rational)::Signed

# ╔═╡ 7c2af484-eea8-4c8c-8891-4aa4923298ae
denom3(x::Rational)::Signed = denominator(x::Rational)::Signed

# ╔═╡ 846b7522-8088-49b4-8848-9f0031e1004e
md"
##### 2.1.1.3.4 Applications
"

# ╔═╡ bb81d86d-63f6-4e9b-83ba-f10a6fc386b0
cons3(1, 3)

# ╔═╡ 96d4be2d-fab7-484e-8a1e-837df8e71574
car3(cons3(1, 3))

# ╔═╡ d07fe6c8-8577-4ece-94d9-c61d44bc502c
cdr3(cons3(1, 3))

# ╔═╡ 6d096e3e-3313-4889-aa5b-387e75912d5e
print_rat(x::Rational)::String = "$(numer3(x))/$(denom3(x))"

# ╔═╡ 6931655c-b8bc-4efb-bad1-5061a5b63548
print_rat(one_half)

# ╔═╡ 1d2a90d7-cf23-4cef-b525-f0e0cb77586f
print_rat(one_third)

# ╔═╡ c85ab30f-22b4-452d-adb0-401dd0609d79
print_rat(two_twelves)                    # with (!) application of gcd

# ╔═╡ 64d8fdee-f7b2-453d-b595-f3d27c69ed20
print_rat(make_rat(120,90))               # 120/90 = 12/9 = 4/3

# ╔═╡ 60367294-bac2-4c34-bddd-fc8c8c3a2f34
print_rat(add_rat(one_half, one_third))   # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 6009d1d7-f87d-440e-bfd5-389f7a6189fe
print_rat(sub_rat(one_half, one_third))   # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ d2c09e98-d6b6-43e0-a493-a5c00700b022
print_rat(mul_rat(one_half, one_third))   # 1/2 * 1/3 = 1/6

# ╔═╡ e8dade6c-874e-4926-bdca-0875509f35ff
print_rat(div_rat(one_half, one_third))   # (1/2)/(1/3) = (1*3)/(2*1) = 3/2

# ╔═╡ ab78e9ac-762d-4824-a17a-b61695010615
print_rat(add_rat(one_third, one_third))  # 6/9 = 2/3 

# ╔═╡ 5e3ce89e-16cf-41ab-b65b-0693f152d2e6
print_rat(make_rat(355,113))

# ╔═╡ 451f4fcd-3cb6-400b-b7eb-b80cb6a5a712
print_rat(one_half2)

# ╔═╡ db489898-bef8-4562-adf7-fab1f56e566e
print_rat(one_third2)

# ╔═╡ 02fe4860-7fd6-453a-8eb2-a4654d7dd77b
print_rat(add_rat2(one_half2, one_third2))

# ╔═╡ 04a336e5-b3d0-4c0c-9275-1ad23a1f19e2
print_rat(sub_rat2(one_half2, one_third2))

# ╔═╡ ed2ac17e-497e-4b96-ba9b-ae7d4433c731
print_rat(mul_rat2(one_half2, one_third2))

# ╔═╡ 55360263-ea18-4987-98c6-396a88afc60e
print_rat(div_rat2(one_half2, one_third2))

# ╔═╡ 6598342e-f99c-486f-b486-69ee6d488f75
print_rat(add_rat2(one_third2, one_third2))

# ╔═╡ 985720fb-c4a2-45cd-9094-6d9363deeca1
print_rat(make_rat2(120,90))

# ╔═╡ 9672253e-c0be-4da5-9c1b-6882ce5f65c3
one_half3 = make_rat3(1, 2)

# ╔═╡ ed140d1c-110e-4fcb-ba43-807b59ac30ef
print_rat(one_half3)

# ╔═╡ ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
one_third3 = make_rat3(1, 3)

# ╔═╡ ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
print_rat(one_third3)

# ╔═╡ dc14d933-62ac-4cf7-8563-71fda97afc9a
print_rat(add_rat3(one_half3, one_third3))

# ╔═╡ 47771613-e613-497b-a020-f825a51b012d
print_rat(sub_rat3(one_half3, one_third3))

# ╔═╡ 1a32f5c0-e644-44bc-9b0a-f47905e98f1d
print_rat(mul_rat3(one_half3, one_third3))

# ╔═╡ 43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
print_rat(div_rat3(one_half3, one_third3))

# ╔═╡ 1349941f-f280-47f2-814b-32b3b8ac4e4c
equal_rat3(make_rat3(1, 3), make_rat3(2, 6))

# ╔═╡ 7242424b-c8da-4452-b104-b3a2411fc0df
equal_rat3(make_rat3(1, 2), make_rat3(3, 6))

# ╔═╡ b202fbe1-f987-4e62-8f6f-3af4d3ca1048
equal_rat3(make_rat3(1, 3), make_rat3(3, 6))

# ╔═╡ b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
print_rat(add_rat3(one_third3, one_third3))

# ╔═╡ f38f0544-6113-4ed9-af22-d5d205078492
print_rat(make_rat3(120, 90))

# ╔═╡ bcf4044f-f932-4a90-87bb-12963a67fc99
md"
---
#### 2.1.1.4 idiomatic *typed* Julia ...
###### ... with type $$Rational$$
"

# ╔═╡ 6b36e481-d44c-468b-b020-ff7219eb6625
md"
##### 2.1.1.4.4 Applications (pure Julia-Rational-Operators)
"

# ╔═╡ 20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
one_half4 = 1 // 2

# ╔═╡ 522016b4-5f42-4cf9-acd7-67afd8116d90
one_third4 = 1 // 3

# ╔═╡ 4c25c782-decc-4d3b-bc01-31577218c6a7
one_half4 + one_third4

# ╔═╡ da84aea9-d17e-4156-979d-8894066d3e38
one_half4 - one_third4

# ╔═╡ f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
one_half4 * one_third4

# ╔═╡ 8cc968c6-5364-4430-9449-aeafd876d567
one_half4 / one_third4

# ╔═╡ d88f2af4-e182-4c90-ab88-694834485bb7
1 // 3 == 2 // 6

# ╔═╡ dc47a501-9c50-4e5d-bcea-d2fe9609a76c
1 // 3 == 3 // 6

# ╔═╡ 8bd0c86b-fe82-4221-9d4a-66cb192b5649
one_third4 + one_third4

# ╔═╡ 03a8961e-031e-4671-9bd5-c35c6c603c19
120 // 90

# ╔═╡ a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
md"
###### [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ d44cb419-7a01-4236-b561-a03892cfcead
pi_approximation =
let pi_rat = 355//113
	numerator(pi_rat)/denominator(pi_rat)
end

# ╔═╡ 118ba1f9-8643-43c8-b5a0-18b71a61547d
error = abs(pi_approximation - π)

# ╔═╡ cffadb80-3e20-4600-8419-8d6a59646471
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/27
- **Wikipedia**; Rational approximation to π, [https://en.wikipedia.org/wiki/Approximations_of_%CF%80](https://en.wikipedia.org/wiki/Approximations_of_%CF%80), last visit 2022/08/27
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
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─e8c1f880-0278-11ec-2538-13bb2f14d606
# ╟─6011e641-b628-4642-8c55-549b05efbb89
# ╟─2b87595b-9491-4ebe-acb9-1ab7d43c4678
# ╟─55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
# ╟─d4e48294-c66c-4fa3-9586-89fb825a4ee8
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
# ╟─08ede030-fb83-4337-8c37-f346b1b7ebc0
# ╟─a27e5207-ffb7-4f91-ba46-2006be39fd81
# ╟─1c6a666d-c388-4ac9-b65f-dcebf9fc082f
# ╠═3b7faab0-b8e0-4bea-894f-16fd35e5727f
# ╠═80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
# ╠═1c695d3b-c88e-4227-8aa1-e88149a4f9f4
# ╟─fff492e2-429a-40ca-bfb9-8b915020ed26
# ╠═3fba0329-19ac-485a-a56d-ee64ae0e3573
# ╠═44d3380a-b2ab-43e1-8f03-a14a9599fac0
# ╠═44017d8b-476e-4e9c-abac-229e9a2e85d1
# ╠═51732672-ee53-46e7-85bf-217f531867cc
# ╟─e4aafaae-560c-4b4f-8ac0-10c159db1d6a
# ╠═a1587038-c11d-4b4b-8436-b098b61f1077
# ╠═118b16a3-093f-4b39-823b-ac167da69615
# ╠═fb4ecf01-1361-43c5-854d-8c83969a2e60
# ╟─cdd8bf06-1f89-4a5a-aeb8-60fde3143bec
# ╠═f0c42132-4b04-4b48-aa45-b45b4f585466
# ╠═132232a8-495f-4f2c-a08a-da4b898f606b
# ╠═768b4543-6d34-4af7-9ee1-6120a33a169d
# ╠═8b990c96-d5e2-4e77-ae73-eae3bc399f9d
# ╠═4e7da88e-e73e-4d15-bd5f-b1eed925322d
# ╠═9b7d9d52-77c6-4328-8018-3b1e40fb9558
# ╟─7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
# ╟─8b2fb52c-7519-410f-a872-610cdb911b72
# ╟─680c5ec0-6cf2-4b0c-a005-751ef8a7e568
# ╠═7ff3b4a0-e00b-424f-8118-897019d0fc20
# ╟─810b1eca-eac7-49cb-a34f-8328ea432824
# ╠═df37be85-589a-46aa-a14c-8ab67c461ae9
# ╟─764ec0e3-66c3-4a67-9473-95380e11250b
# ╠═193ae321-0f26-44cc-a48f-1a1b9bc71af8
# ╠═d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
# ╟─61340177-3808-4a2b-906f-51b801178c6f
# ╠═172db576-f756-4d62-94c3-128c6ac4f847
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
# ╠═ab78e9ac-762d-4824-a17a-b61695010615
# ╠═69facaff-5c1f-4c8e-a436-81e8f9cd73b9
# ╠═45772e1e-aa83-46cd-add7-4f977f58dff0
# ╠═d3d1980c-00f3-4d04-abe5-8705f61b3459
# ╟─a861fc71-5a96-43b4-9a8f-94a603d2cb3b
# ╠═5e3ce89e-16cf-41ab-b65b-0693f152d2e6
# ╠═aa7ea22e-f330-427e-9d89-408003e6b8f2
# ╠═bf4034ad-07ff-4400-8aba-3b855fc43a5c
# ╟─c70c4a99-32b9-4c70-8b36-064d313e753c
# ╟─285428ce-c13e-43ca-add3-672b1e454e18
# ╠═76e3a4bc-fde2-4440-96c1-c492cc120db0
# ╠═402d8963-26bc-4db2-b94b-ba4334e1d8fd
# ╠═09901068-bf38-4392-ab19-66a44d65344d
# ╠═555e6212-22bd-4d0e-b221-edfe32f043f5
# ╠═afe55885-aba6-4cbc-af2c-23d15bbbf6f5
# ╟─cc592f32-8785-4735-badd-de3903c20f05
# ╟─d4c053d6-ba2c-4d88-beef-19873926df88
# ╟─28c75fb7-1c58-46d0-90bc-534791c4693b
# ╠═0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# ╠═1fddd3ae-5da7-4a32-a53e-077b8f37509c
# ╠═b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
# ╟─d84101ea-7172-4e1f-9929-1a23acd7a7c7
# ╟─b4c9a74b-5a49-452e-bbf0-44826cd92e46
# ╠═3498e844-931f-4d46-a9aa-b9a2d3b892e7
# ╟─4e179b9f-021e-4891-8e27-7fa36b827fcf
# ╠═7f5b9164-07c2-4ae1-888d-f601fa9d286c
# ╠═3ca05b52-413f-46aa-9fd7-659227dccbd7
# ╟─bbccaeb3-48cf-4f65-9aa2-d0de9940e311
# ╠═1248e659-dcdb-442c-859c-3289d5561c6f
# ╟─edd94612-1772-4c7a-b8d5-cf5b4a540487
# ╠═0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
# ╠═32e3fc67-3872-4a28-bd6b-9cf06bc094ac
# ╠═e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
# ╠═cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
# ╠═4bed1729-8c79-4cf1-95e3-3285010a5622
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
# ╠═6598342e-f99c-486f-b486-69ee6d488f75
# ╠═985720fb-c4a2-45cd-9094-6d9363deeca1
# ╟─5be39e55-32ba-4809-9456-431e118b9195
# ╟─bb838586-2f8a-44f9-9672-aced83e8cf76
# ╠═26593de4-f70d-4aa5-86dd-d09bb6544407
# ╠═6662d041-af9c-472d-b9fe-efe2c4846267
# ╠═8fc62f98-9a2e-4fae-83b7-a78118b656d3
# ╠═f7bd0981-1534-4c80-9697-e019f29c4a3c
# ╠═b25d2465-7452-43e8-b709-06009642076a
# ╟─32927d21-4f21-41ff-b90c-21a9c15a7a26
# ╟─5f1971c7-f3bb-4dbf-aa42-4218055e1fd0
# ╠═c47d0173-9fd4-4926-b426-42ff0f854c16
# ╠═47d605b7-ec32-4b72-a329-bf47e7273972
# ╠═e6e6754c-d86e-449f-a82e-03e0ab2a91cb
# ╠═c356aab4-4717-46a7-b041-aa14800a0253
# ╟─abf821d6-3f8a-404d-903d-0a4b49ed9d9b
# ╟─ce97fbfe-0a85-43c6-980f-18da5e795a98
# ╠═6858b169-b9dc-4a23-8dd3-8951033bd311
# ╟─8d014b03-6124-4937-aa35-599c01301efd
# ╠═0a935144-2c44-480b-9c6e-53408b972e89
# ╠═7c2af484-eea8-4c8c-8891-4aa4923298ae
# ╟─846b7522-8088-49b4-8848-9f0031e1004e
# ╠═bb81d86d-63f6-4e9b-83ba-f10a6fc386b0
# ╠═96d4be2d-fab7-484e-8a1e-837df8e71574
# ╠═d07fe6c8-8577-4ece-94d9-c61d44bc502c
# ╠═6d096e3e-3313-4889-aa5b-387e75912d5e
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
# ╟─bcf4044f-f932-4a90-87bb-12963a67fc99
# ╟─6b36e481-d44c-468b-b020-ff7219eb6625
# ╠═20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
# ╠═522016b4-5f42-4cf9-acd7-67afd8116d90
# ╠═4c25c782-decc-4d3b-bc01-31577218c6a7
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
# ╟─cffadb80-3e20-4600-8419-8d6a59646471
# ╟─965557ac-81b4-4cf7-a2e5-3b6efff094be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
