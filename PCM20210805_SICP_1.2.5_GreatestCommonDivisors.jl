### A Pluto.jl notebook ###
# v0.20.24

using Markdown
using InteractiveUtils

# ╔═╡ d3577a0d-ec2b-4bec-b330-eebab7c35f1e
begin 
	using Pluto
	using Plots	
	using LaTeXStrings
	using GraphRecipes
	#----------------------------------------------------------------
	println("pkgversion(Pluto)         = ", pkgversion(Pluto))
	println("pkgversion(Plots)         = ", pkgversion(Plots))
	println("pkgversion(LaTeXStrings)  = ", pkgversion(LaTeXStrings))
	println("pkgversion(GraphRecipes)  = ", pkgversion(GraphRecipes))
end # begin

# ╔═╡ cea33580-f5f4-11eb-292b-3d35bf7a4518
md"
===================================================================================
#### SICP: [1.2.5 Greatest Common Divisors](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-11.html#%_sec_1.2.5)

##### file: PCM20210805\_SICP\_1.2.5\_GreatestCommonDivisors

##### Julia/Pluto.jl (1.12.5/0.20.4) code by PCM *** 2026/03/27 ***
===================================================================================
"

# ╔═╡ 42c23ec6-f975-4e6a-bb57-b241df46bf43
md"
---
##### 0. Introduction
*The greatest common divisor (GCD) of two integers a and b is defined to be the largest integer that divides both a and b with no remainder.*(SICP)

*... the Euclidean algorithm, or Euclid's algorithm, is an efficient method for computing the greatest common divisor (GCD) of two integers, the largest number that divides them both without a remainder.* ([*Wikipedia*](https://en.wikipedia.org/wiki/Euclidean_algorithm))

*It is named after the ancient Greek mathematician Euclid, who first described it in his Elements (c. 300 BC). It is an example of an algorithm, and is one of the oldest algorithms in common use. It can be used to reduce fractions to their simplest form, and is a part of many other number-theoretic and cryptographic calculations. .*([*Wikipedia*](https://en.wikipedia.org/wiki/Euclidean_algorithm))
"

# ╔═╡ 491a8572-cfa8-4bbb-89f6-c5fa6de0e633
md"
---
##### 1. Topics
- *functions* $mod, rem$
- complexities $\Omega \log(n), \Theta \log(n)$ of $gcd(n, m)$
- case analysis $if ... else ... end$
- *output* $println$
- string *interpolation* with $
- *Lamé's theorem*
"

# ╔═╡ 86fe0183-5901-4199-a33e-ad7919fbbadb
md"
---
##### 2. Libraries
"

# ╔═╡ d469d705-50cd-4b76-857d-e3e20c9d3753
md"
---
##### 3. SICP-Scheme-like *functional* Julia
(1st pass)
"

# ╔═╡ 401f5a11-12b2-4733-8c10-109f0d9abacc
md"
---
###### 3.1 Euclid's Algorithm

Euclid's Algorithm is a correct but not very efficient algorithm. We are looking for the *greatest common divisor* $d$:

$arg\underset{d}max \left(a = d\cdot e, b = d \cdot f \right)$

where:

$a, b, d, e, f \in \mathbb N.$

This *greatest common divisor* $d$ remains the same when we reduce the greater argument by subtraction $a - b$ if $a > b$:

$a - b = d \cdot e - d \cdot f = d(e - f).$

Now we are looking for partial *reduced* arguments:

$arg\underset{d}max \left(a - b = d(e - f), b = d \cdot f \right).$

This leads directly to a *tail recursive* algorithm with *subtraction* as a main *decreasing* operation.

This function is correct for $a, b \in \mathbb N \text{ with } a \ge b > 0$. It *will keep subtracting the smaller argument from the larger until hitting a boundary* (Rawlins, 1992, p.363)

$gcd_{Euclid}(a, b) :=
\begin{cases}
b  & \text{if } a = 0             \\
a  & \text{if } b = 0             \\
1  & \text{if } a = 1 \lor b = 1  \\
gcd_{Euclid} (a - b, b) & \text{if } a \ge b > 1 \\
gcd_{Euclid} (a, b - a) & \text{if } b \ge a > 1 \\
\end{cases}$

"

# ╔═╡ 1080344d-9728-4491-93df-1d018047cf55
md"
---
###### Tail-recursive *Generic (= Polymorphic)* Method of *Euklid's* Algorithm
Euclid's Algorithm is a correct but not very efficient algorithm. We are looking for the *greatest common divisor* $d$:

$arg\underset{d}max \left(a = d\cdot e, b = d \cdot f \right)$

where:

$a, b, d, e, f \in \mathbb N.$

This is a restriction in contrast to some verbal specifications (above).
"

# ╔═╡ d54d2ef4-25dc-4b41-99aa-60099d10064d
function myGCD_Euklid(a::Int, b::Int)                         # a ≥ b ≥ 0
	a < 0 || b < 0 ? 
		error("a and b must not be negative !") : 
		println("a = $a, b = $b")
	a == 0 ? b :
	b == 0 ? a :
	a > b ? myGCD_Euklid(a - b, b) :
	a < b ? myGCD_Euklid(a, b - a) : a
end # function EuklidsGCD

# ╔═╡ 15e862ef-8cc7-4bc9-add5-9f9856c2c17e
myGCD_Euklid(0, 0)                                            # ==> 0 --> :)

# ╔═╡ 9aa66450-fd1a-4577-a652-477fd608a3e7
myGCD_Euklid(1, 0)                                            # ==> 1 --> :)

# ╔═╡ 915e0b4e-264f-4d43-8962-68a563dae335
myGCD_Euklid(0, 1)                                            # ==> 1 --> :)

# ╔═╡ 990b0079-8b9f-4d30-b043-a5be9c1ab3dd
myGCD_Euklid(0, 1)                                            # ==> 1 --> :)

# ╔═╡ 8951991a-ac01-40ac-b179-46658c32fc42
myGCD_Euklid(206, 40)                                # ==> 2 --> :)  SICP's example

# ╔═╡ c6ffe702-0191-4593-8368-100204968370
myGCD_Euklid(40, 206)                                # ==> 2 --> :)  SICP's example

# ╔═╡ 9f81f375-af65-4c63-ab13-5edab5fc087f
myGCD_Euklid(206, -40), myGCD_Euklid(-206, 40), myGCD_Euklid(-206, -40)

# ╔═╡ 58bb0060-330b-48d2-a4a5-0a064a5bd4f0
md"
---
###### Example: *The Extended Form of Euklid's Algorithm* 
(Cormen et al., 2022, ch.31.2, p.95)
"

# ╔═╡ 0f9aa034-6c3b-4cd4-abe8-3d00beaea524
myGCD_Euklid(99, 78)

# ╔═╡ 6e72fc42-e689-46b6-9028-f28dfc9d6eaf
md"
---
###### 3.2 SICP-Definition and Implementations in *Scheme* and *Julia*

The definition in *SICP* is:

- *The greatest common divisor (GCD) of two integers a and b is defined to be the largest integer that divides both a and b with no remainder.*(SICP, 1996, 2016)

This definition in *SICP* postulates only that $a, b$ have to be two *integers* $a, b \in \mathbb Z$. It provides *no* specification of the result. The *Scheme*-script found in SICP is:

          	(define (gcd a b)
                (if (= b 0) 
                    a
                    (gcd b (remainder a b))))

We implemented that in R5RS-Scheme in [*Racket*](https://racket-lang.org/). Function calls generate positive and *negative* results depending on the sign of the *first* argument $a$:

          	R5RS-Racket> (gcd 206 40) ==> 2
          	R5RS-Racket> (gcd 206 -40) ==> 2
          	R5RS-Racket> (gcd -206 40) ==> -2
          	R5RS-Racket> (gcd -206 -40) ==> -2

Clearly, the *negative* results are *not* correct.

"

# ╔═╡ 5f83cc1b-e685-4f68-92a5-a61fe1e2be8e
md"
---
###### The *Transpilation* of *SICP* $gcd$-version into *Julia* is $mySICP\_GCD$.
Of course it suffers from the same error (*negative* results):
"

# ╔═╡ 8fc55489-c5aa-46a4-aa56-c5214510528a
function mySICP_GCD(a, b)
	println("a = $a, b = $b")
	b == 0 ? 
		a : 
		mySICP_GCD(b, rem(a, b))
end # function mySICP_GCD

# ╔═╡ ef59ac2d-3b7d-4538-9b07-3f5cfbd00508
mySICP_GCD(0, 0)

# ╔═╡ b9f85e4c-cb4d-4697-92c1-63ead6465530
mySICP_GCD(0, 1), mySICP_GCD(1, 0), mySICP_GCD(1, 1)

# ╔═╡ b4affdd4-20ac-47cd-9bca-3caa64685f91
mySICP_GCD(206, 40)                               # ==> 2 --> :)  SICP's example

# ╔═╡ d180d606-73b2-493f-be5e-922d6e3233a2
mySICP_GCD(206, -40)                              # ==> 2 --> :)

# ╔═╡ 7ebcc9a8-0f73-4f66-a5bd-f04643e3e283
mySICP_GCD(-206, 40)                               # ==> -2 --> :(

# ╔═╡ 41b6c733-c690-4a0a-b0ec-29a16103b433
mySICP_GCD(-206, -40)                              # ==> -2 --> :(

# ╔═╡ 29b0cfb1-d04d-46e2-84e3-b7ede63cf64e
md"
---
###### 3.3 A Modified SICP-Definition and Implementations in *Scheme* and *Julia*

A second  definition restricts the *sign* of the output:

- *The greatest common divisor (GCD) of integers a and b, at least one of which is nonzero, is the greatest positive integer d such that d is a divisor of both a and b; that is, there are integers e and f such that a = de and b = df, and d is the largest such integer. The GCD of a and b is generally denoted gcd(a, b).*([*Wikipedia*](https://en.wikipedia.org/wiki/Greatest_common_divisor))

- *When one of a and b is zero, the GCD is the absolute value of the nonzero integer: $gcd(a, 0) = gcd(0, a) = |a|$. This case is important as the terminating step of the Euclidean algorithm.*([Wikipedia](https://en.wikipedia.org/wiki/Greatest_common_divisor))

"

# ╔═╡ 18327f1c-6b8b-4b95-973f-ce087c4891f5
function mySICP_GCD2(a, b)
	println("a = $a, b = $b")
	b == 0 ? 
		abs(a) : 
		mySICP_GCD2(b, rem(a, b))
end # function mySICP_GCD2

# ╔═╡ a68335d0-26ce-4038-8ef6-cf7b237bce60
mySICP_GCD2(0, 0) 

# ╔═╡ 4932a6bf-e352-4689-947d-01922a338c49
mySICP_GCD2(206, 40)                               # ==> 2 --> :)  SICP's example

# ╔═╡ 9bcb355f-ef58-4030-848f-8c51a5fcc171
mySICP_GCD2(206, -40)                              # ==> 2 --> :)

# ╔═╡ 6f6dc7e6-d4fd-4dbb-b9a1-57a0de8b516f
mySICP_GCD2(-206, 40)                              # ==> 2 --> :)

# ╔═╡ 2e0822ae-9bbc-4407-b0b3-826e1a348cc9
mySICP_GCD2(-206, -40)                              # ==> 2 --> :)

# ╔═╡ 07ffa78d-50f3-4910-aaf4-6f98112865d0
md"
---
###### *Adjacent* [Prime Numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $269, 271$
"

# ╔═╡ 825c2a1f-885b-4fe5-bcc5-c8ae5a14a7c5
mySICP_GCD2(269, 271)                                # ==> 1 --> :)

# ╔═╡ 59fd6d95-a256-440b-b901-52ae6393a407
mySICP_GCD2(271, 269)                                # ==> 1 --> :)

# ╔═╡ 6edf7ce7-3a8a-4af2-964a-8dfa5ed282e9
md"
---
###### *Adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $7907, 7919$
"

# ╔═╡ 4a5746da-d4be-486f-b955-8b226ee264ac
mySICP_GCD2(7907, 7919)                              # ==> 1 --> :)

# ╔═╡ 6fbb78a9-f8f4-43fe-8c19-9b4599ad6fa1
mySICP_GCD2(7919, 7907) 

# ╔═╡ 8742e0a5-cfd3-4ece-bd4d-1e2cefd3e143
mySICP_GCD2(987654321, 123456789)                    # ==> 9 --> :)

# ╔═╡ 4469ce5c-3c6f-436d-a4d3-c80610301c9c
mySICP_GCD2(123456789, 987654321) 

# ╔═╡ 5f7188a4-4e65-43d8-a82c-2670ab25e32f
mySICP_GCD2(-987654321, 123456789) 

# ╔═╡ 8bb1d21b-218d-4714-ac3c-d7662df1ccb8
mySICP_GCD2(987654321, -123456789) 

# ╔═╡ 8b408e3a-0b51-42d7-9ffc-b798c0bc4943
mySICP_GCD2(-987654321, -123456789) 

# ╔═╡ 46897383-0c6c-4c18-b1d7-5e1c6a63dbe0
md"
---
##### 3.4. $\Omega$-*Complexity* of *Tail-Recursive* $gcd$ with $remainder$-Reduction

By use of [*Lamé*'s theorem](https://en.wikipedia.org/wiki/Lam%C3%A9%27s_theorem) (c.f. SICP, 1996, 2016) we can determine an *upper limit* for the number of steps $k = \#steps(gcd(a, b))\ for\ $a > b = n$:

$n \ge fib(k) \approx \frac{\phi^k}{\sqrt 5}$

$n \sqrt 5 \ge \phi^k$

$\log(n \sqrt 5) \ge k \log(\phi)$

$\frac{\log(n \sqrt 5)}{\log(\phi)} \ge k \Rightarrow \Omega(\log n) \ge k.$

SICP provides for the *number of steps* $k$ a more narrow complexity $\Theta(\log n).$

"

# ╔═╡ 10766977-40bd-4d71-856e-fa22f4b97b44
md"
###### 5.2 Example

For $mySICP\_GCD2(21, 13)$ the number of *reduction* steps is

$k = \#steps(gcd(21, 13) = 6.$

The *upper* limit according Lamé's theorem is:

$\frac{\log(n\sqrt 5)}{\log \phi} =\frac{\log(13\sqrt 5)}{\log \left((1+\sqrt 5)/2\right)} \ge 6$

$= \frac{\log 29.068888}{\log 2.118033988} = \frac{3.36966831}{0.4812118} \ge 6$

$7.00246 \ge 6.$

"


# ╔═╡ f5fbb73e-7f2f-4d9a-810e-8b9d1f236207
mySICP_GCD2(21, 13)

# ╔═╡ fcb61a42-36eb-4b1a-8e8d-79f57e536864
md"
---
##### 4. Idiomatic *Imperative* Julia 
(2nd pass)

---
###### 4.1 Iterative Algorithm $myGCD\_Euklid2$
... with $while$ and parallel assignment

This is the *iterative* version of $myGCD\_Euklid$.

"

# ╔═╡ 26285995-870f-467c-ab00-e09fdb5e67db
subtypes(Signed)

# ╔═╡ e45b60ce-0c6e-4c61-8065-4f64ac8eeb7c
function myGCD_Euklid2(a::Signed, b::Signed)                       # a ≥ b ≥ 0
	a < 0 || b < 0 ? 
		error("a and b must not be negative !") : 
		println("a = $a, b = $b")
	#----------------------------------------------
	while !iszero(a) && !iszero(b) && a ≠ b
		if a > b 
			a, b = a - b, b
			println("a = $a, b = $b")
		elseif a < b 
			a, b = a, b - a
			println("a = $a, b = $b")
		end # if
	end # while !(iszero(a)) && !(iszero(b))
	#----------------------------------------------
	if iszero(a) 
		b 
	elseif iszero(b) 
		a 
	else
		a
	end # if
end # function EuklidsGCD2

# ╔═╡ a813b24f-e4c9-41f8-8902-0e0c0de169c9
myGCD_Euklid2(0, 0)                                            # ==> 0 --> :)

# ╔═╡ ec49a351-d0f6-43df-a267-71bbab498346
myGCD_Euklid2(1, 0)                                            # ==> 1 --> :)

# ╔═╡ cdbe94f2-6700-422c-98fe-77bd5f38e56a
myGCD_Euklid2(0, 1)                                            # ==> 1 --> :)

# ╔═╡ b345f60e-ac4e-4cf2-aa2b-76ec36b59e54
myGCD_Euklid2(1, 1)                                            # ==> 1 --> :)

# ╔═╡ a3da899b-c2b2-47df-b707-70f8436fe15c
myGCD_Euklid2(206, 40)

# ╔═╡ 89633dde-3440-4cd1-9eb7-0a337d3a7afe
myGCD_Euklid2(40, 206)

# ╔═╡ 8ffc0344-e744-4b78-8a96-963727c60853
myGCD_Euklid2(-40, 206), myGCD_Euklid2(40, -206), myGCD_Euklid2(-40, -206)

# ╔═╡ 7c766505-79e3-427b-bc38-27bf197f4393
md"
---
###### Example: *The Extended Form of Euklid's Algorithm* 
(Cormen et al., 2022, ch.31.2, p.95)
"

# ╔═╡ eb7ed8b5-5985-44fe-a10c-364d3b5a2a90
myGCD_Euklid2(99, 78)

# ╔═╡ deac3806-8393-4f1c-8049-0967d7fb6c28
md"
---
###### 4.2 An *Iterative* Version of Function $mySICP\_GCD2$

"

# ╔═╡ 3faf3840-71d0-4b37-893f-99cca1c0f3eb
function mySICP_GCD3(a::Signed, b::Signed)
	#--------------------------------------------------------
	while b ≠ 0
		a, b = b, rem(a, b)             # parallel assignment
	end # while
	abs(a)
end # function mySICP_GCD3

# ╔═╡ 060e14fd-d5c7-46f0-93c8-43f27cf81497
mySICP_GCD3(0, 0)                                            # ==> 0 --> :)

# ╔═╡ f8b43b6c-98c5-44e3-a392-2457343bee87
mySICP_GCD3(0, 1), mySICP_GCD3(1, 0), mySICP_GCD3(1, 1)      # ==> (1, 1, 1) --> :)

# ╔═╡ 3c04738f-7838-44c6-aeaa-9f50ef7d2e3f
mySICP_GCD3(206, 40)                                 # ==> 2 --> :)  SICP's example

# ╔═╡ 459f1db5-6b97-43cb-bb70-0c12e01652a6
# ==> (2, 2, 2) --> :)
mySICP_GCD3(206, -40), mySICP_GCD3(-206, 40), mySICP_GCD3(-206, -40)

# ╔═╡ 1da58c1b-532d-48de-90e2-152c221ba7c3
mySICP_GCD3(1071, 462), mySICP_GCD3(1071, -462), mySICP_GCD3(-1071, 462), mySICP_GCD3(-1071, -462)                             # ==> (21, 21, 21, 21) --> :)

# ╔═╡ be1224ce-25ea-4cc5-9f93-d20dbf530fa4
md"
---
###### *Adjacent* [Prime Numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $269, 271$ 
"

# ╔═╡ d614584b-a54c-4fa5-8276-19961301c7c8
mySICP_GCD3(269, 271), mySICP_GCD3(-269, 271), mySICP_GCD3(269, -271), mySICP_GCD3(-269, -271)                                     # ==> (1, 1, 1, 1) --> :)

# ╔═╡ fc72cd2b-abb9-4d12-a0ff-c3b1f8fd706f
mySICP_GCD3(271, 269), mySICP_GCD3(271, -269), mySICP_GCD3(-271, 269), mySICP_GCD3(-271, -269)                                     # ==> (1, 1, 1, 1) --> :)

# ╔═╡ 158f96db-81d1-4ff9-98d4-b3dea1a0a0c9
md"
---
*Adjacent* [Prime Numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $7907, 7919$
"

# ╔═╡ 837b66a7-0fd6-4775-90c1-5f7ee26694c5
mySICP_GCD3(7907, 7919), mySICP_GCD3(-7907, 7919), mySICP_GCD3(7907, -7919), mySICP_GCD3(-7907, -7919)                                   # ==> (1, 1, 1, 1) --> :)

# ╔═╡ f6285029-bdd9-4147-b373-30ba9c71d99f
mySICP_GCD3(7919, 7907), mySICP_GCD3(7919, -7907), mySICP_GCD3(-7919, 7907), mySICP_GCD3(-7919, -7907)                                   # ==> (1, 1, 1, 1) --> :)

# ╔═╡ 235a2931-fad7-4b77-aa73-1d1bc6c76554
md"
---
###### Apparently *Difficult* Problems
"

# ╔═╡ f6cd510f-90b1-46a0-969b-dc577b47c951
# ==> (9, 9) --> :)
mySICP_GCD3(987654321, 123456789),  mySICP_GCD3(-987654321, 123456789)   

# ╔═╡ e2c8c871-ae11-42ac-9ac7-f03ace653353
# ==> (9, 9) --> :)
mySICP_GCD3(987654321, -123456789), mySICP_GCD3(-987654321, -123456789)  

# ╔═╡ 736211ef-956b-4168-83a4-57bbc444d7e6
md"
---
###### 4.4 Julia's Builtin [*Base.gcd*](https://docs.julialang.org/en/v1/base/math/#Base.gcd)
"

# ╔═╡ ca2f3722-fe88-4cfa-95f3-caa5ab65abc2
gcd(206, 40)                                      # ==> 2 --> :)    SICP's example

# ╔═╡ 88bddb35-e342-4d47-88d9-711686b3b0a2
gcd(-206, 40), gcd(206, -40), gcd(-206, -40)      # ==> (2, 2, 2) --> :)

# ╔═╡ 35b018b5-fadd-4f42-abe3-1c0d2d206017
gcd(0, 0)                                         # ==> 0 --> :)

# ╔═╡ e4e78771-abf1-4116-9a64-f1a483914f9e
gcd(6, 0), gcd(-6, 0)                             # ==> (6, 6) --> :)

# ╔═╡ 758904df-59f0-4d6c-83de-e41dba2c0702
gcd(0, 6), gcd(0, -6)                             # ==> (6, 6) --> :)

# ╔═╡ 219b1495-2f60-4f6c-aa65-a57433d57218
gcd(6, 9), gcd(6, -9)                             # ==> (3, 3) --> :)

# ╔═╡ 46f83d7a-4690-43a3-9737-66ddf5de6b2b
md"
---
###### *Adjacent* [Prime Numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $269, 271$
"

# ╔═╡ f5638e5d-9a73-4694-bea9-6acffdcb0091
gcd(269, 271), gcd(271, 269)

# ╔═╡ 66151e66-3136-48b6-81f4-e1e5ff7ffc2b
md"
---
###### *Adjacent* [Prime Numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers) $7907, 7919$ 
"

# ╔═╡ 402c9d2f-480a-43f6-8b28-a39a286d2359
 # ==> (1, 1, 1, 1) --> :) 
gcd(7907, 7919), gcd(-7907, 7919), gcd(7907, -7919), gcd(-7907, -7919)

# ╔═╡ 8bf38756-d278-4f71-ad07-1a5905e3b488
 # ==> (1, 1, 1, 1) --> :)
gcd(7919, 7907), gcd(7919, -7907), gcd(-7919, 7907), gcd(-7919, -7907)

# ╔═╡ f4655616-a0a7-470f-8688-43098165d802
md"
---
###### Apparently *Difficult* Problems
"

# ╔═╡ 1fbfb94a-3167-41f3-a4c5-b5df441e02eb
gcd(987654321, 123456789),  gcd(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ 7eb9b02f-deb0-48bb-b309-1969754095fb
gcd(987654321, -123456789), gcd(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ 2d4206e3-6231-48e9-96fa-89d7a8aaeebd
md"
---
##### 6. Summary
We presented different simple $gcd$-algorithms for *natural* and *integer* numbers. Furthermore we demonstrated how to compute the complexity of *Euclid's algorithm* which is $\Omega(\log min(n, m))$ or $\Theta(\log min(n, m))$.

"

# ╔═╡ 5cd5cdec-238c-47ae-b079-c25804c6c42e
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*, html-version](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2025/01/09), Cambridge, Mass.: MIT Press, (2/e), 1996; last visit 2026/02/26

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*, pdf-version](https://web.mit.edu/6.001/6.037/sicp.pdf), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2026/02/26

- **Cormen, Th.H., Leiserson, Ch.E., Rivest, R.L. & Stein, C.**; *Introduction to Algorithms*, Cambridge, Mass.: MIT Press, 2022. 4/e

- **Racket**; [*Racket*](https://racket-lang.org/); last visit 2026/03/29

- **Rawlins, G.J.E.**; *Compared To What ?*, NY.: Computer Science Press, 1992

- **Wikipedia**; [*Euclidean Algorithm*](https://en.wikipedia.org/wiki/Euclidean_algorithm); last visit 2026/03/25

- **Wikipedia**; [*Greatest Common Divisor*](https://en.wikipedia.org/wiki/Greatest_common_divisor); last visit 2026/03/26

- **Wikipedia**; [*Lamé's Theorem*](https://en.wikipedia.org/wiki/Lam%C3%A9%27s_theorem); last visit 2026/03/26

- **Wikipedia**; [*Tail Call Optimization*](https://en.wikipedia.org/wiki/Tail_call); last visit 2025/01/22
"

# ╔═╡ 96313012-0e76-42e5-8f76-548c0da1535a
md"
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en) license; Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphRecipes = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"

[compat]
GraphRecipes = "~0.5.13"
LaTeXStrings = "~1.4.0"
Plots = "~1.40.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.5"
manifest_format = "2.0"
project_hash = "9e7aa008db610791072fd1961f877b1c81694cab"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "35ea197a51ce46fcd01c4a44befce0578a1aaeca"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.5.0"
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
git-tree-sha1 = "a21c5464519504e41e0cbc91f0188e8ca23d7440"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.5+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "e4c6a16e77171a5f5e25e9646617ab1c276c5607"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.26.0"
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
git-tree-sha1 = "b0fd3f56fa442f81e0a47815c92245acfaaa4e34"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.31.0"

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
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "9d8a54ce4b17aa5bdce0ea5c34bc5e7c340d16ad"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.18.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "21d088c496ea22914fe80906eb5bce65755e5ec8"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.1"

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
deps = ["OrderedCollections"]
git-tree-sha1 = "e357641bb3e0638d353c4b29ea0e40ea644066a6"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.19.3"

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
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.7.0"

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
git-tree-sha1 = "27af30de8b5445644e8ffe3bcb0d72049c089cf1"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.7.3+0"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "5f1c005ed214356bbe41d442cc1ccd416e510b7e"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.4"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.Extents]]
git-tree-sha1 = "b309b36a9e02fe7be71270dd8c0fd873625332b4"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.6"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "95ecf07c2eea562b5adbd0696af6db62c0f52560"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.5"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libva_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "66381d7059b5f3f6162f28831854008040a4e905"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "8.0.1+1"

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
git-tree-sha1 = "f85dac9a96a01087df6e3a749840015a0ca3817d"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.17.1+0"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "b7bfd56fa66616138dfe5237da4dc13bbd83c67f"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.1+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "44716a1a667cb867ee0e9ec8edc31c3e4aa5afdc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.24"

    [deps.GR.extensions]
    IJuliaExt = "IJulia"

    [deps.GR.weakdeps]
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "be8a1b8065959e24fdc1b51402f39f3b6f0f6653"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.24+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "1f5a80f4ed9f5a4aada88fc2db456e637676414b"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.10"

    [deps.GeometryBasics.extensions]
    GeometryBasicsGeoInterfaceExt = "GeoInterface"

    [deps.GeometryBasics.weakdeps]
    GeoInterface = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"

[[deps.GeometryTypes]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "d796f7be0383b5416cd403420ce0af083b0f9b28"
uuid = "4d00f742-c7ba-57c2-abde-4428a4b178cb"
version = "0.8.5"

[[deps.GettextRuntime_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll"]
git-tree-sha1 = "45288942190db7c5f760f59c04495064eedf9340"
uuid = "b0724c58-0f36-5564-988d-3bb0596ebc4a"
version = "0.22.4+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Zlib_jll"]
git-tree-sha1 = "38044a04637976140074d0b0621c1edf0eb531fd"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.1+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "GettextRuntime_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "24f6def62397474a297bfcec22384101609142ed"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.86.3+0"

[[deps.GracefulPkg]]
deps = ["Compat", "Pkg", "TOML"]
git-tree-sha1 = "a854d6c0e9fb561b88cd20b4ad64f518cb1bfb8d"
uuid = "828d9ff0-206c-6161-646e-6576656f7244"
version = "2.4.3"

[[deps.GraphRecipes]]
deps = ["AbstractTrees", "GeometryTypes", "Graphs", "InteractiveUtils", "Interpolations", "LinearAlgebra", "NaNMath", "NetworkLayout", "PlotUtils", "RecipesBase", "SparseArrays", "Statistics"]
git-tree-sha1 = "24c0a854c2f971b4915891a68ccfcd90ab3faea7"
uuid = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
version = "0.5.16"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Inflate", "LinearAlgebra", "Random", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "7eb45fe833a5b7c51cf6d89c5a841d5967e44be3"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.14.0"
weakdeps = ["Distributed", "SharedArrays"]

    [deps.Graphs.extensions]
    GraphsSharedArraysExt = "SharedArrays"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "51059d23c8bb67911a2e6fd5130229113735fc7e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.11.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "d1a86724f81bcd184a38fd284ce183ec067d71a0"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "65d505fa4c0d7072990d659ef3fc086eb6da8208"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.16.2"

    [deps.Interpolations.extensions]
    InterpolationsForwardDiffExt = "ForwardDiff"
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IrrationalConstants]]
git-tree-sha1 = "b2d91fe939cae05960e760110b328288867b5758"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.6"

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
git-tree-sha1 = "0533e564aae234aff59ab625543145446d8b6ec2"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.1"

[[deps.JSON]]
deps = ["Dates", "Logging", "Parsers", "PrecompileTools", "StructUtils", "UUIDs", "Unicode"]
git-tree-sha1 = "b3ad4a0255688dcb895a52fafbaae3023b588a90"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "1.4.0"

    [deps.JSON.extensions]
    JSONArrowExt = ["ArrowTypes"]

    [deps.JSON.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6893345fd6658c8e475d40155789f4860ac3b21"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.4+0"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "059aabebaa7c82ccb853dd4a0ee9d17796f7e1bc"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.3+0"

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
deps = ["Format", "Ghostscript_jll", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "44f93c47f9cd6c7e431f2f2091fcba8f01cd7e8f"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.10"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "0f2da712350b020bc3957f269c9caad516383ee0"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.15.0+0"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

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
git-tree-sha1 = "97bbca976196f2a1eb9607131cb108c69ec3f8a6"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.3+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "f04133fe05eff1667d2054c53d59f9122383fe05"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.2+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d0205286d9eceadc518742860bf23f703779a3d6"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.3+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

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
git-tree-sha1 = "f00544d95982ea270145636c181ceda21c4e2575"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.2.0"

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
git-tree-sha1 = "987fb06a33e6200c3e75133d180f5bfdda37f337"
uuid = "36869731-bdee-424d-aa32-cab38c994e3b"
version = "1.4.0"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "8785729fa736197687541f7053f6d8ab7fc44f92"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.10"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ff69a2b1330bcb730b9ac1ab7dd680176f5896b8"
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.1010+0"

[[deps.Measures]]
git-tree-sha1 = "b513cedd20d9c914783d8ad83d08120702bf2c77"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.3"

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
version = "2025.11.4"

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
version = "1.3.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6aa4566bb7ae78498a5e68943863fa8b5231b59"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.6+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.7+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "NetworkOptions", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "1d1aaa7d449b58415f97d2839c318b70ffb525a0"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.6.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.4+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e2bb57a313a74b8104064b7efd01406c0a50d2ff"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.6.1+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.44.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0662b083e11420952f2e62e17eddae7fc07d5997"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.57.0+0"

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
version = "1.12.1"
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
git-tree-sha1 = "26ca162858917496748aad52bb5d3be4d26a228a"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "bfe839e9668f0c58367fb62d8757315c0eac8777"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.20"

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
deps = ["Base64", "Configurations", "Dates", "Downloads", "ExpressionExplorer", "FileWatching", "GracefulPkg", "HTTP", "HypertextLiteral", "InteractiveUtils", "LRUCache", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PlutoDependencyExplorer", "PrecompileSignatures", "PrecompileTools", "REPL", "Random", "RegistryInstances", "RelocatableFolders", "SHA", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "bded9024db4a669d9d628adbe80d32a941617f16"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.20.24"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "c3e5073a977b1c58b2d55c1ec187c3737e64e6af"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.2.2"

[[deps.PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "4fbbafbc6251b883f4d2705356f3641f3652a7fe"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.4.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "d7a4bff94f42208ce3cf6bc8e4e7d1d663e7ee8b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.10.2+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll", "Qt6Svg_jll"]
git-tree-sha1 = "d5b7dd0e226774cbd87e2790e34def09245c7eab"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.10.2+1"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "4d85eedf69d875982c46643f6b4f66919d7e157b"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.10.2+1"

[[deps.Qt6Svg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "81587ff5ff25a4e1115ce191e36285ede0334c9d"
uuid = "6de9746b-f93d-5813-b365-ba18ad4a9cf3"
version = "6.10.2+0"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "672c938b4b4e3e0169a07a5f227029d4905456f2"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.10.2+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "JuliaSyntaxHighlighting", "Markdown", "Sockets", "StyledStrings", "Unicode"]
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
git-tree-sha1 = "9b81b8393e50b7d4e6d0a9f14e192294d3b7c109"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.3.0"

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
git-tree-sha1 = "be8eeac05ec97d379347584fa9fe2f5f76795bcb"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.5"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "64d974c2e6fdf07f8155b5b2ca2ffa9069b608d9"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.2"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.12.0"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "4f96c596b8c8258cc7d3b19797854d368f243ddc"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "246a8bb2e6667f832eea063c3a56aef96429a3db"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.18"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6ab403037779dae8c514bad259f32a447262455a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.4"

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
git-tree-sha1 = "178ed29fd5b2a2cfc3bd31c13375ae925623ff36"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.8.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "aceda6f4e598d331548e04cc6b2124a6148138e3"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.10"

[[deps.StructUtils]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "fa95b3b097bcef5845c142ea2e085f1b2591e92c"
uuid = "ec057cc2-7a8d-4b58-b3b3-92acb9f63b42"
version = "2.7.1"

    [deps.StructUtils.extensions]
    StructUtilsMeasurementsExt = ["Measurements"]
    StructUtilsStaticArraysCoreExt = ["StaticArraysCore"]
    StructUtilsTablesExt = ["Tables"]

    [deps.StructUtils.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tables = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.8.3+2"

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
git-tree-sha1 = "f2c1efbc8f3a609aadf318094f8fc5204bdaf344"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.1"

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
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

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
git-tree-sha1 = "6258d453843c466d84c17a58732dda5deeb8d3af"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.24.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    ForwardDiffExt = "ForwardDiff"
    InverseFunctionsUnitfulExt = "InverseFunctions"
    PrintfExt = "Printf"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"
    Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "af305cc62419f9bd61b6644d19170a4d258c7967"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.7.0"

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
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "96478df35bbc2f3e1e791bc7a3d0eeee559e60e9"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.24.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "248a7031b3da79a127f14e5dc5f417e26f9f6db7"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.1.0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9cce64c0fdd1960b597ba7ecda2950b5ed957438"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.2+0"

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
git-tree-sha1 = "808090ede1d41644447dd5cbafced4731c56bd2f"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.13+0"

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
git-tree-sha1 = "1a4a26870bf1e5d26cd585e38038d399d7e65706"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.8+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "75e00946e43621e09d431d9b95818ee751e6b2ef"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.2+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "0ba01bc7396896a4ace8aab67db31403c71628f4"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.7+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c174ef70c96c76f4c3f4d3cfbe09d018bcd1b53"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.6+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libpciaccess_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "4909eb8f1cbf6bd4b1c30dd18b2ead9019ef2fad"
uuid = "a65dc6b1-eb27-53a1-bb3e-dea574b5389e"
version = "0.18.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "ed756a03e95fff88d8f738ebc2849431bdd4fd1a"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.2.0+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "9750dc53819eba4e9a20be42349a6d3b86c7cdf8"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.6+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f4fc02e384b74418679983a97385644b67e1263b"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll"]
git-tree-sha1 = "68da27247e7d8d8dafd1fcf0c3654ad6506f5f97"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "44ec54b0e2acd408b0fb361e1e9244c60c9c3dd4"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.1+0"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "5b0263b6d080716a02544c55fdff2c8d7f9a16a0"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.10+0"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_jll"]
git-tree-sha1 = "f233c83cad1fa0e70b7771e0e21b061a116f2763"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.2+0"

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
version = "1.3.1+2"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c3b0e6196d50eab0c5ed34021aaa0bb463489510"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.14+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "371cc681c00a3ccc3fbc5c0fb91f58ba9bec1ecf"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.13.1+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "125eedcb0a4a0bba65b657251ce1d27c8714e9d6"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.17.4+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.15.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libdrm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libpciaccess_jll"]
git-tree-sha1 = "63aac0bcb0b582e11bad965cef4a689905456c03"
uuid = "8e53e030-5e6c-5a89-a30b-be5b7263a166"
version = "2.4.125+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56d643b57b188d30cccc25e331d416d3d358e557"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.13.4+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "646634dd19587a56ee2f1199563ec056c5f228df"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.4+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "91d05d7f4a9f67205bd6cf395e488009fe85b499"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.28.1+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e015f211ebb898c8180887012b938f3851e719ac"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.55+0"

[[deps.libva_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll", "Xorg_libXfixes_jll", "libdrm_jll"]
git-tree-sha1 = "7dbf96baae3310fe2fa0df0ccbb3c6288d5816c9"
uuid = "9a156e7d-b971-5f62-b2c9-67348b8fb97c"
version = "2.23.0+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll"]
git-tree-sha1 = "11e1772e7f3cc987e9d3de991dd4f6b2602663a5"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.8+0"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b4d631fd51f2e9cdd93724ae25b2efc198b059b1"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.7+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.7.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "14cc7083fc6dff3cc44f2bc435ee96d06ed79aa7"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "10164.0.1+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e7b67590c14d487e734dcb925924c5dc43ec85f3"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "4.1.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "a1fc6507a40bf504527d0d4067d718f8e179b2b8"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.13.0+0"
"""

# ╔═╡ Cell order:
# ╟─cea33580-f5f4-11eb-292b-3d35bf7a4518
# ╟─42c23ec6-f975-4e6a-bb57-b241df46bf43
# ╟─491a8572-cfa8-4bbb-89f6-c5fa6de0e633
# ╟─86fe0183-5901-4199-a33e-ad7919fbbadb
# ╠═d3577a0d-ec2b-4bec-b330-eebab7c35f1e
# ╟─d469d705-50cd-4b76-857d-e3e20c9d3753
# ╟─401f5a11-12b2-4733-8c10-109f0d9abacc
# ╟─1080344d-9728-4491-93df-1d018047cf55
# ╠═d54d2ef4-25dc-4b41-99aa-60099d10064d
# ╠═15e862ef-8cc7-4bc9-add5-9f9856c2c17e
# ╠═9aa66450-fd1a-4577-a652-477fd608a3e7
# ╠═915e0b4e-264f-4d43-8962-68a563dae335
# ╠═990b0079-8b9f-4d30-b043-a5be9c1ab3dd
# ╠═8951991a-ac01-40ac-b179-46658c32fc42
# ╠═c6ffe702-0191-4593-8368-100204968370
# ╠═9f81f375-af65-4c63-ab13-5edab5fc087f
# ╟─58bb0060-330b-48d2-a4a5-0a064a5bd4f0
# ╠═0f9aa034-6c3b-4cd4-abe8-3d00beaea524
# ╟─6e72fc42-e689-46b6-9028-f28dfc9d6eaf
# ╟─5f83cc1b-e685-4f68-92a5-a61fe1e2be8e
# ╠═8fc55489-c5aa-46a4-aa56-c5214510528a
# ╠═ef59ac2d-3b7d-4538-9b07-3f5cfbd00508
# ╠═b9f85e4c-cb4d-4697-92c1-63ead6465530
# ╠═b4affdd4-20ac-47cd-9bca-3caa64685f91
# ╠═d180d606-73b2-493f-be5e-922d6e3233a2
# ╠═7ebcc9a8-0f73-4f66-a5bd-f04643e3e283
# ╠═41b6c733-c690-4a0a-b0ec-29a16103b433
# ╟─29b0cfb1-d04d-46e2-84e3-b7ede63cf64e
# ╠═18327f1c-6b8b-4b95-973f-ce087c4891f5
# ╠═a68335d0-26ce-4038-8ef6-cf7b237bce60
# ╠═4932a6bf-e352-4689-947d-01922a338c49
# ╠═9bcb355f-ef58-4030-848f-8c51a5fcc171
# ╠═6f6dc7e6-d4fd-4dbb-b9a1-57a0de8b516f
# ╠═2e0822ae-9bbc-4407-b0b3-826e1a348cc9
# ╟─07ffa78d-50f3-4910-aaf4-6f98112865d0
# ╠═825c2a1f-885b-4fe5-bcc5-c8ae5a14a7c5
# ╠═59fd6d95-a256-440b-b901-52ae6393a407
# ╟─6edf7ce7-3a8a-4af2-964a-8dfa5ed282e9
# ╠═4a5746da-d4be-486f-b955-8b226ee264ac
# ╠═6fbb78a9-f8f4-43fe-8c19-9b4599ad6fa1
# ╠═8742e0a5-cfd3-4ece-bd4d-1e2cefd3e143
# ╠═4469ce5c-3c6f-436d-a4d3-c80610301c9c
# ╠═5f7188a4-4e65-43d8-a82c-2670ab25e32f
# ╠═8bb1d21b-218d-4714-ac3c-d7662df1ccb8
# ╠═8b408e3a-0b51-42d7-9ffc-b798c0bc4943
# ╟─46897383-0c6c-4c18-b1d7-5e1c6a63dbe0
# ╟─10766977-40bd-4d71-856e-fa22f4b97b44
# ╠═f5fbb73e-7f2f-4d9a-810e-8b9d1f236207
# ╟─fcb61a42-36eb-4b1a-8e8d-79f57e536864
# ╠═26285995-870f-467c-ab00-e09fdb5e67db
# ╠═e45b60ce-0c6e-4c61-8065-4f64ac8eeb7c
# ╠═a813b24f-e4c9-41f8-8902-0e0c0de169c9
# ╠═ec49a351-d0f6-43df-a267-71bbab498346
# ╠═cdbe94f2-6700-422c-98fe-77bd5f38e56a
# ╠═b345f60e-ac4e-4cf2-aa2b-76ec36b59e54
# ╠═a3da899b-c2b2-47df-b707-70f8436fe15c
# ╠═89633dde-3440-4cd1-9eb7-0a337d3a7afe
# ╠═8ffc0344-e744-4b78-8a96-963727c60853
# ╟─7c766505-79e3-427b-bc38-27bf197f4393
# ╠═eb7ed8b5-5985-44fe-a10c-364d3b5a2a90
# ╟─deac3806-8393-4f1c-8049-0967d7fb6c28
# ╠═3faf3840-71d0-4b37-893f-99cca1c0f3eb
# ╠═060e14fd-d5c7-46f0-93c8-43f27cf81497
# ╠═f8b43b6c-98c5-44e3-a392-2457343bee87
# ╠═3c04738f-7838-44c6-aeaa-9f50ef7d2e3f
# ╠═459f1db5-6b97-43cb-bb70-0c12e01652a6
# ╠═1da58c1b-532d-48de-90e2-152c221ba7c3
# ╟─be1224ce-25ea-4cc5-9f93-d20dbf530fa4
# ╠═d614584b-a54c-4fa5-8276-19961301c7c8
# ╠═fc72cd2b-abb9-4d12-a0ff-c3b1f8fd706f
# ╟─158f96db-81d1-4ff9-98d4-b3dea1a0a0c9
# ╠═837b66a7-0fd6-4775-90c1-5f7ee26694c5
# ╠═f6285029-bdd9-4147-b373-30ba9c71d99f
# ╟─235a2931-fad7-4b77-aa73-1d1bc6c76554
# ╠═f6cd510f-90b1-46a0-969b-dc577b47c951
# ╠═e2c8c871-ae11-42ac-9ac7-f03ace653353
# ╟─736211ef-956b-4168-83a4-57bbc444d7e6
# ╠═ca2f3722-fe88-4cfa-95f3-caa5ab65abc2
# ╠═88bddb35-e342-4d47-88d9-711686b3b0a2
# ╠═35b018b5-fadd-4f42-abe3-1c0d2d206017
# ╠═e4e78771-abf1-4116-9a64-f1a483914f9e
# ╠═758904df-59f0-4d6c-83de-e41dba2c0702
# ╠═219b1495-2f60-4f6c-aa65-a57433d57218
# ╟─46f83d7a-4690-43a3-9737-66ddf5de6b2b
# ╠═f5638e5d-9a73-4694-bea9-6acffdcb0091
# ╟─66151e66-3136-48b6-81f4-e1e5ff7ffc2b
# ╠═402c9d2f-480a-43f6-8b28-a39a286d2359
# ╠═8bf38756-d278-4f71-ad07-1a5905e3b488
# ╟─f4655616-a0a7-470f-8688-43098165d802
# ╠═1fbfb94a-3167-41f3-a4c5-b5df441e02eb
# ╠═7eb9b02f-deb0-48bb-b309-1969754095fb
# ╟─2d4206e3-6231-48e9-96fa-89d7a8aaeebd
# ╟─5cd5cdec-238c-47ae-b079-c25804c6c42e
# ╟─96313012-0e76-42e5-8f76-548c0da1535a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
