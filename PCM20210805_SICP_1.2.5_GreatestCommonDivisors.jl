### A Pluto.jl notebook ###
# v0.20.4

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
#### SICP: [1.2.5 Greatest Common Divisors](https://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2_002e5)

##### file: PCM20210805\_SICP\_1.2.5\_GreatestCommonDivisors

##### Julia/Pluto.jl (1.11.3/0.20.4) code by PCM *** 2025/01/25 ***
===================================================================================
"

# ╔═╡ 42c23ec6-f975-4e6a-bb57-b241df46bf43
md"
##### 0. Introduction
*... the Euclidean algorithm, ... or Euclid's algorithm, is an efficient method for computing the greatest common divisor (GCD) of two integers, the largest number that divides them both without a remainder. It is named after the ancient Greek mathematician Euclid, who first described it in his Elements (c. 300 BC). It is an example of an algorithm, a step-by-step procedure for performing a calculation according to well-defined rules, and is one of the oldest algorithms in common use. It can be used to reduce fractions to their simplest form, and is a part of many other number-theoretic and cryptographic calculations.*([*Wikipedia*](https://en.wikipedia.org/wiki/Euclidean_algorithm))
"

# ╔═╡ 491a8572-cfa8-4bbb-89f6-c5fa6de0e633
md"
---
##### 1. Topics
- *Renaming* of functions
- *functions* $mod, rem, remainder$
- *type* $Rational$
- *parametrized* type $Rational\{Int64\}$
- *transformation* of *Boolean* expressions
- *Lamé's theorem*
- *big*-$O$ of $gcd(n, m)$
- case analysis $if ... else ... end$
- *output* $println$
- string *interpolation* with $
"

# ╔═╡ 86fe0183-5901-4199-a33e-ad7919fbbadb
md"
---
##### 2. Libraries
"

# ╔═╡ 6e72fc42-e689-46b6-9028-f28dfc9d6eaf
md"
##### 3. SICP-Scheme-like *functional* Julia
###### 3.1 Definitions 
Here we provide definitions with increasing complexity:

- *The greatest common divisor (GCD) of two integers a and b is defined to be the largest integer that divides both a and b with no remainder.*(SICP, 196, 2016)

This *informal* definition in SICP postulates that $a, b$ are two *integers*. This in contrast to the Scheme-script provided by SICP which expects two *nonnegative* integers. For other arguments the script may fail.

Another definition includes *negative* integers:

- *...the greatest common divisor (GCD), ..., of two or more integers, which are not all zero, is the largest positive integer that divides each of the integers.* ([*Wikipedia*](https://en.wikipedia.org/wiki/Greatest_common_divisor))

This definition does not cover the cases where inputs are *zero*. So we quote a further definition. This includes the specification of a *divisor* or *factor* $d$:

- *The greatest common divisor (GCD) of integers a and b, at least one of which is nonzero, is the greatest positive integer d such that d is a divisor of both a and b; that is, there are integers e and f such that a = de and b = df, and d is the largest such integer.*
- *When one of a and b is zero, the GCD is the absolute value of the nonzero integer: $gcd(a, 0) = gcd(0, a) = |a|$. This case is important as the terminating step of the Euclidean algorithm.*([Wikipedia](https://en.wikipedia.org/wiki/Greatest_common_divisor))

This definition leaves out the case where $gcd(0, 0)$:

- *The above definition is unsuitable for defining $gcd(0, 0)$, since there is no greatest integer $n$ such that $0 × n = 0$. However, zero is its own greatest divisor if greatest is understood in the context of the divisibility relation, so $gcd(0, 0)$ is commonly defined as $0$.*([Wikipedia](https://en.wikipedia.org/wiki/Greatest_common_divisor))

Now we can combine all cases for $a, b, d, e, f \in \mathbb N$:

$gcd(a, b) =
\begin{cases}
0    & \text{if } a = b = 0 \\
b  & \text{if } a = 0     \\
a  & \text{if } b = 0     \\
arg\underset{d}max \left(a = d\cdot e, b = d \cdot f \right)
\end{cases}$

"

# ╔═╡ 401f5a11-12b2-4733-8c10-109f0d9abacc
md"
---
###### 3.2 Euclid's Algorithm
The above case analysis leads directly to a correct but not very efficient algorithm. We are looking for the *greatest common divisor* $d$:

$arg\underset{d}max \left(a = d\cdot e, b = d \cdot f \right).$

This *gcd* $d$ remains the same when we reduce the greater argument by subtraction $a - b$ if $a > b$:

$a - b = d \cdot e - d \cdot f = d(e - f).$

Now we are looking for partial *reduced* arguments:

$arg\underset{d}max \left(a - b = d(e - f), b = d f \right).$

This leads directly to a *tail recursive* algorithm with *subtraction* as a main *decreasing* operation.

This function is correct for $a, b \in \mathbb N \text{ with } a \ge b > 0$. It *will keep subtracting the smaller argument from the larger until hitting a boundary* (Rawlins, 1992, p.363)

$gcd_{Euclid}(a, b) :=
\begin{cases}
0  & \text{if } a = b = 0 \\
b  & \text{if } a = 0     \\
a  & \text{if } b = 0     \\
1  & \text{if } (a = 1) \lor (b = 1) \\
gcd_{Euclid}(-(a, b), b) & \text{if } a \ge b > 1 \\
gcd_{Euclid}(a, -(b, a)) & \text{if } b \ge a > 1 \\
\end{cases}$

Using *subtraction* is not very efficient in languages without [*tco*](https://en.wikipedia.org/wiki/Tail_call) because the danger of *stack overflow*.

The implementation is:

"

# ╔═╡ bba620c5-3ec8-4c1c-be62-3ee5d4610555
function myEuklidsGCD(a, b)                       # a ≥ b ≥ 0
	#--------------------------------------------------------------------------
	==(a, 0) && ==(b, 0) ? 0 : 
	==(a, 0) ? b :
	==(b, 0) ? a :
	==(a, 1) || ==(b, 1) ? 1 :
	≥(a, b) && >(b, 1) ? myEuklidsGCD(-(a, b), b) :
    ≥(b, a) && >(a, 1) ? myEuklidsGCD(a, -(b, abs(a))) : 
		error("condition a ≥ b ≥ 0 ignored")
	#--------------------------------------------------------------------------
end # function EuklidsGCD

# ╔═╡ 15e862ef-8cc7-4bc9-add5-9f9856c2c17e
myEuklidsGCD(0, 0), myEuklidsGCD(1, 1)                # ==> (0, 1) --> :)

# ╔═╡ 9db61e2e-69c7-49b5-b499-8e19ca0e73da
myEuklidsGCD(6, 0), myEuklidsGCD(0, 6)                # ==> (6, 6) --> :)

# ╔═╡ fbf4a874-f02c-4b44-8181-7e0625ac31e2
myEuklidsGCD(6, 9), myEuklidsGCD(9, 6)                # ==> (3, 3) --> :)

# ╔═╡ 7f5ecaab-4160-4475-a91d-a1881351e8f6
myEuklidsGCD(206, 40)                                 # ==> 2 --> :)  SICP's example

# ╔═╡ 07ffa78d-50f3-4910-aaf4-6f98112865d0
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 825c2a1f-885b-4fe5-bcc5-c8ae5a14a7c5
myEuklidsGCD(269, 271)                                # ==> 1 --> :)

# ╔═╡ 6edf7ce7-3a8a-4af2-964a-8dfa5ed282e9
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 4a5746da-d4be-486f-b955-8b226ee264ac
myEuklidsGCD(7907, 7919)                              # ==> 1 --> :)

# ╔═╡ 761b3197-1d94-447f-8e9a-965e6d650854
md"
###### *difficult* problems lead to *stack overflow*
"

# ╔═╡ 570bd207-d64a-4bb6-b1e9-7010e6928202
# euklidsGCD(987654321, 123456789),euklidsGCD(-987654321, 123456789) # stack overflow

# ╔═╡ eec014b2-522f-4f54-aa4f-2912dcbd3e24
# euklidsGCD(987654321, -123456789), euklidsGCD(-987654321, -123456789) # overflow

# ╔═╡ 23b966a5-54ac-4175-a6fe-cac6185bbb7a
md"
---
###### 3.3 [*SICP's gcd*-Algorithm](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-11.html#%_sec_1.2.5) as a *Generic* (*Polymorphic*) *Tail-Recursive* Algorithm
The algorithm presented in SICP substitutes *subtraction* by computing the *remainder* $rem = a\ mod\ b.$

This function is correct for $a, b \in \mathbb Z$ and even $a, b \in \mathbb Q$ if we replace $a \text{ by } abs(a)$ !

$gcd_{SICP}(a, b) :=
\begin{cases}
|a|  & \text{if } b = 0 \\
gcd_{SICP}(b, r(a, b)) & \text{where } r = remainder(a, b) = a \mod b \\
\end{cases}$

In cases where $a, b \not\in \mathbb N$ the program fails. This happens e.g. when $(b < 0) \lor (a < 0) \land (b = 0)$.

"

# ╔═╡ 22ff69e2-4a1e-4422-ba08-60b4a2f1c3aa
function sicpGCD(a, b)   # fails, e.g. when b is negative or (a < 0) and (b = 0)
	#-----------------------------------------------------------------------------
	remainder = rem                     # local renaming
	#-----------------------------------------------------------------------------
	==(b, 0) ? 
		abs(a) :                        # nonSICP: replacement of a by abs(a)
		sicpGCD(b, remainder(a, b))
	#-----------------------------------------------------------------------------
end # function SICPsGCD

# ╔═╡ b2fd82ec-d1be-43d8-ad9a-702c8052d8d8
sicpGCD(0, 0)

# ╔═╡ 28f7b82d-780d-43c9-83aa-ceb9e579817d
sicpGCD(6, 0), sicpGCD(-6, 0)                   # ==> (6, 6) --> :)

# ╔═╡ 9383d9cf-3ef4-4696-a0df-273d6b1372bb
sicpGCD(0, 6), sicpGCD(0, -6)                   # ==> (6, 6) --> :)

# ╔═╡ 84067cf7-71c5-4183-ac1c-37bf761f33ce
sicpGCD(6, 9), sicpGCD(-6, 9)                   # ==> (3, 3) --> :)

# ╔═╡ ba182453-1e0a-4ddb-8347-21528a9cf4e0
sicpGCD(6, -9), sicpGCD(-6, 9), sicpGCD(-6, -9) # ==> (3, 3, 3) --> :)

# ╔═╡ 82c3d9ae-8614-4ade-a461-af3cbfe19463
sicpGCD(9, 6), sicpGCD(-9, 6)                   # ==> (3, 3) --> :)

# ╔═╡ 23c81845-b61c-4cc6-881b-fc37a4793dbf
sicpGCD(9, -6), sicpGCD(-9, 6), sicpGCD(-9, -6) # ==> (3, 3, 3) --> :)

# ╔═╡ 316cca38-a8e4-4a30-9635-0b3c0c19808d
sicpGCD(21, 13)

# ╔═╡ 8ee624a2-2069-42ba-8591-f69ae9e885c9
sicpGCD(206, 40)                                # ==> 2 --> :)  SICP's example

# ╔═╡ d1cc56d5-3fec-4cd5-a4d0-788c8a2e56db
sicpGCD(40, 206)                                # ==> 2 --> :)  SICP's example

# ╔═╡ 10448f52-1fc8-409b-b4bc-9ef231155b8c
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 1fbfa230-9209-4506-9bae-88cd25820bae
sicpGCD(269, 271), sicpGCD(-269, 271), sicpGCD(269, -271), sicpGCD(-269, -271) 

# ╔═╡ 6ebf2de0-13f2-46f3-b713-fbf01af53080
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ f7ad98ed-87dd-4a44-ae07-51267eb7abaa
sicpGCD(7907, 7919), sicpGCD(-7907, 7919), sicpGCD(7907, -7919), sicpGCD(-7907, -7919)

# ╔═╡ 83782367-d27d-4aa9-8e6b-4ec8ff6aead9
md"
###### Difficult Problems
"

# ╔═╡ 8d4b0b84-b5e5-412f-92be-57471fb27a96
sicpGCD(987654321, 123456789),  sicpGCD(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ fcaf8363-d5bd-465c-8045-c08655fd5313
sicpGCD(987654321, -123456789), sicpGCD(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ f17491ba-332e-47ff-a550-0f3e9d0f5b4a
md"
###### Rational Input: $a, b \in \mathbb Q$
"

# ╔═╡ e1163af9-2c3f-4361-964d-1febb18c0b10
sicpGCD(2//3, 2), sicpGCD(2//3, -2)         # ==> (2//3, 2//3) --> :)

# ╔═╡ 51ef4341-3263-4c89-b8e7-78a8fb8ec6c1
sicpGCD(-2//3, 2), sicpGCD(-2//3, -2)       # ==> (2//3, 2//3) --> :)

# ╔═╡ c1b1f764-02da-487b-be8a-1e4582643806
sicpGCD(72//120, 42//70)                  # ==> 3//5

# ╔═╡ f9f7dfe7-c3db-47be-b079-62fa873f8f4b
md"
###### 3.4 *Generic* (*Polymorphic*) *Tail-recursive* $gcd$ for *Integer* and *Rational* Inputs (Definition 3.2)

This specification is an extension of the specification in *3.1*. It is correct for *integers* $a, b \in \mathbb Z$ and even for *rational* numbers $a, b \in \mathbb Q$. We transform the *negation* of the four *stop* conditions into the *run* condition of the the iterative $while$ loop in *4,1, 4.2*.

$gcd(a, b) =
\begin{cases}
0    & \text{if } a = b = 0 \\
|b|  & \text{if } a = 0     \\
|a|  & \text{if } b = 0     \\
1    & \text{if } (a = 1) \lor (b = 1) \\
arg\underset{d}max \left(a = d\cdot e, b = d \cdot f \right)
\end{cases}$

where: $d \in \mathbb N \text{ and } a, b \in \mathbb Q$

"

# ╔═╡ b7bb02fa-22ad-46f5-9e1b-30fe6e37b157
function myGCD(a, b)           # gcd is the Julia function
	#------------------------------------------------------
	remainder = mod            # local renaming 
	#------------------------------------------------------
	==(a, 0) && ==(b, 0) ? 0 : 
	==(a, 0) ? abs(b) :
	==(b, 0) ? abs(a) :
	==(a, 1) || ==(b, 1) ? 1 :
		myGCD(b, remainder(a, b))
end # function myGCD

# ╔═╡ 82564968-efcf-4656-a81b-dd30e365bcc1
myGCD(0, 0)

# ╔═╡ 961ed92e-669e-42e0-9c80-77a04c2f5f03
myGCD(6, 0), myGCD(-6, 0)               # ==> (6, 6) --> :)

# ╔═╡ 78426838-2478-4fc0-8d1b-bdff3b78c02b
myGCD(0, 6), myGCD(0, -6)               # ==> (6, 6) --> :)

# ╔═╡ b1635893-2d53-4dd6-879b-ce6fe2d79b29
myGCD(6, 9), myGCD(-6, 9)               # ==> (3, 3) --> :)

# ╔═╡ 8a42c258-4e28-44c9-aae5-c6a9e933e9bd
myGCD(6, 9), myGCD(6, -9)               # ==> (3, 3) --> :)

# ╔═╡ b379a394-dbb8-4e9b-8546-a82d52cbb94d
myGCD(-6, -9)                           # ==> 3 --> :)

# ╔═╡ baed6744-f6e3-4862-898d-9d1c8f84ec65
myGCD(206, 40)                          # ==> 2 --> :)  SICP's example

# ╔═╡ f5f1726e-be92-4e6a-bc03-573401d8457b
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 3be00d9d-a76c-46a9-99cc-f57f1e1ae285
myGCD(269, 271), myGCD(-269, 271), myGCD(269, -271), myGCD(-269, -271)      

# ╔═╡ 15522f43-48ad-4067-b0c2-1cf82e177ac2
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 5ec142a1-4148-490f-851a-e9c1211057ff
myGCD(7907, 7919), myGCD(-7907, 7919), myGCD(7907, -7919), myGCD(-7907, -7919)

# ╔═╡ 6c25b150-f081-4c86-8815-238e71bfefe6
md"
###### *difficult* problems
"

# ╔═╡ fd2b06f5-520d-45f0-b46c-de0f1da99aca
myGCD(987654321, 123456789),  myGCD(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ 22eb7d2d-6eaf-4406-a2af-fce6734e04cc
myGCD(987654321, -123456789), myGCD(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ d98f169d-2155-4b5f-b6bb-1b1902ee3d70
md"
###### Rational Input: $a, b \in \mathbb Q$
"

# ╔═╡ e10235c1-b81b-474c-a6ee-17162611fdc1
myGCD(2//3, 2), myGCD(2//3, -2)         # ==> (2//3, 2//3) --> :)

# ╔═╡ db38373d-790a-4ca9-8a2e-972c28950ee2
myGCD(-2//3, 2), myGCD(-2//3, -2)       # ==> (2//3, 2//3) --> :)

# ╔═╡ 0e41dd63-022e-491d-9934-cf6d9a99f1db
myGCD(72//120, 42//70)                  # ==> 3//5

# ╔═╡ fcb61a42-36eb-4b1a-8e8d-79f57e536864
md"
---
##### 4. Idiomatic *Imperative* Julia 
###### 4.1 Iterative Algorithm $myGCD2$
... with $while$ and parallel assignment

To get the *iterative* transformation of the *tail-recursive* function $myGCD$ in *3.4* we have to transform the *stop-conditions* of $myGCD$ into the *run-condition* of the $while$-loop here. The *run*-condition is the negation of the *stop*-condition:

The *stop*-condition of $myGCD$ is a *disjunction*:

$((a = 0) \land (b = 0)) \lor (a = 0) \lor (b = 0) \lor \left((a =1) \lor (b = 1)\right).$

The *run*-condition of the $while$-loop is the *negation* of the *stop*-condition:

$\neg[((a = 0) \land (b = 0) \lor (a = 0) \lor (b = 0) \lor \left((a =1) \lor (b = 1)\right)] =$

$= \neg((a = 0) \land (b = 0)) \neg \land (a = 0) \neg\land (b = 0) \neg\land \left((a =1) \lor (b = 1)\right)=$

$= (\neg(a = 0) \neg\lor (b = 0)) \neg \land (a = 0) \neg\land (b = 0) \land\neg(a =1) \land \neg (b = 1)=$

$= ((a \neq 0) \lor (b \neq 0)) \land (a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1)=$

$= (a \neq 0) \land (a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1) \lor ...$
$...\lor (b \neq 0) \land (a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1)=$

$=(a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1) \lor ...$
$...\lor (a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1)=$

$=(a \neq 0) \land (b \neq 0) \land(a \neq 1) \land (b \neq 1)\;\; \square$

"

# ╔═╡ 3faf3840-71d0-4b37-893f-99cca1c0f3eb
function myGCD2(a, b)
	#--------------------------------------------------------
	# while run condition is negated stop condition of myGCD
	while !=(a, 0) && !=(b, 0) && !=(a, 1) && !=(b, 1) 
		a, b = b, rem(a, b) # parallel assignment
	end # while
	#--------------------------------------------------------
	==(a, 0) && ==(b, 0) ? 0 : 
	==(a, 0) ? abs(b) :
	==(b, 0) ? abs(a) :
	==(a, 1) || ==(b, 1) ? 1 : error("missing case")
end # function myGCD2

# ╔═╡ 7f6a7544-b5a7-47d6-8b4e-4b6e2ad8c9c6
myGCD2(0, 0), myGCD2(-0, -0)

# ╔═╡ 11b064cb-73c0-449c-939c-918f87d8719d
myGCD2(6, 0), myGCD2(-6, 0)                        # ==> (6, 6) --> :)

# ╔═╡ bbc0be78-e798-4c4e-ab62-6bbe66feff50
myGCD2(0, 6), myGCD2(0, -6)                        # ==> (6, 6) --> :)

# ╔═╡ 51a6e03d-54aa-4e40-b49e-3d18f25dcc56
myGCD2(9, 3), myGCD2(-9, 3), myGCD2(9, -3), myGCD2(-9, -3) # ==> (3, 3, 3, 3) --> :)

# ╔═╡ cf46b648-8c3d-4f27-8613-867bc1f98f1a
myGCD2(3, 9), myGCD2(3, -9), myGCD2(-3, 9), myGCD2(-3, -9) # ==> (3, 3, 3, 3) --> :)

# ╔═╡ 5f3dfe93-b54d-431b-8d71-8c9319962a97
myGCD2(206, 40)                                     # ==> 2 --> :)  SICP's example

# ╔═╡ be1224ce-25ea-4cc5-9f93-d20dbf530fa4
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ d614584b-a54c-4fa5-8276-19961301c7c8
myGCD2(269, 271), myGCD2(-269, 271), myGCD2(269, -271), myGCD2(-269, -271)    

# ╔═╡ fc72cd2b-abb9-4d12-a0ff-c3b1f8fd706f
myGCD2(271, 269), myGCD2(271, -269), myGCD2(-271, 269), myGCD2(-271, -269)  

# ╔═╡ 158f96db-81d1-4ff9-98d4-b3dea1a0a0c9
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 837b66a7-0fd6-4775-90c1-5f7ee26694c5
myGCD2(7907, 7919), myGCD2(-7907, 7919), myGCD2(7907, -7919), myGCD2(-7907, -7919)

# ╔═╡ f6285029-bdd9-4147-b373-30ba9c71d99f
myGCD2(7919, 7907), myGCD2(7919, -7907), myGCD2(-7919, 7907), myGCD2(-7919, -7907)

# ╔═╡ 235a2931-fad7-4b77-aa73-1d1bc6c76554
md"
###### *difficult* problems
"

# ╔═╡ f6cd510f-90b1-46a0-969b-dc577b47c951
myGCD2(987654321, 123456789),  myGCD2(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ e2c8c871-ae11-42ac-9ac7-f03ace653353
myGCD2(987654321, -123456789), myGCD2(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ 993f7649-5936-4045-9355-d56d80c11252
md"
###### Rational Input: $a, b \in \mathbb Q$
"

# ╔═╡ f5cd25aa-baf9-42b7-a2ae-0e95a009420a
myGCD2(2//3, 2), myGCD2(2//3, -2)             # ==> (2//3, 2//3) --> :)

# ╔═╡ 34b2dc9a-981a-422c-ae89-c7d86c5869c7
myGCD2(-2//3, 2), myGCD2(-2//3, -2)           # ==> (2//3, 2//3) --> :)

# ╔═╡ 258af27c-b40d-47ef-9194-e84d9b13db3a
myGCD2(72//120, 42//70)                       # ==> 3//5

# ╔═╡ 15bc2039-0a35-4071-bfce-54932b75959a
md"
---
###### 4.3 Iterative Algorithm $myGCD3$
... with $isone, iszero$ and parallel assignment
"

# ╔═╡ 06312cce-0bea-490a-ae59-8d94548c2e7e
function myGCD3(a, b)
	#-------------------------------------------------------
	while !(iszero(a) || iszero(b) || isone(a) || isone(b))
		a, b = b, rem(a, b) # parallel assignment
	end # while
	#-------------------------------------------------------
	iszero(a) && iszero(b) ? 0 : 
	iszero(a) ? abs(b) :
	iszero(b) ? abs(a) :
	isone(a) || isone(b) ? 1 : error("missing case")
end # function myGCD3

# ╔═╡ ec4712f8-8348-45af-949d-a7555ec35cd9
myGCD3(0, 0), myGCD3(-0, -0)                       # ==> (0, 0) --> :)

# ╔═╡ 7a0b869e-8f8b-4b04-8b23-902f3025b9eb
myGCD3(6, 0), myGCD3(-6, 0)                        # ==> (6, 6) --> :)

# ╔═╡ 11c8eb97-363a-47e7-8363-8bde4da89d89
myGCD3(0, 6), myGCD3(0, -6)                        # ==> (6, 6) --> :)

# ╔═╡ 7dd27471-7201-45d2-adbd-653061a02fef
myGCD3(9, 3), myGCD3(-9, 3), myGCD3(9, -3), myGCD3(-9, -3) # ==> (3, 3, 3, 3) --> :)

# ╔═╡ a7bb1b00-ac1e-48b5-b529-3d7efcd6f273
myGCD3(3, 9), myGCD3(3, -9), myGCD3(-3, 9), myGCD3(-3, -9) # ==> (3, 3, 3, 3) --> :)

# ╔═╡ 4852ac5e-9163-4fe5-a83f-4d23283674f6
myGCD3(206, 40)                                     # ==> 2 --> :)  SICP's example

# ╔═╡ 57a1dac8-94fd-4f4b-8664-1230320e4790
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 0123f711-b3af-4404-997c-e07866826451
myGCD3(269, 271), myGCD3(-269, 271), myGCD3(269, -271), myGCD3(-269, -271) 

# ╔═╡ 6540922f-698b-4dba-a26d-ba594e8d0c51
myGCD3(271, 269), myGCD3(271, -269), myGCD3(-271, 269), myGCD3(-271, -269)

# ╔═╡ 71a43de5-b947-4acb-bac3-b6d76c1a5256
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 1d080491-d6d7-46be-864d-e922005ce7c8
myGCD3(7907, 7919), myGCD3(-7907, 7919), myGCD3(7907, -7919), myGCD3(-7907, -7919)

# ╔═╡ c472a1c8-3f78-4153-b0f2-a0ac36d31845
myGCD3(7919, 7907), myGCD3(7919, -7907), myGCD3(-7919, 7907), myGCD3(-7919, -7907)

# ╔═╡ fb59f402-ccd9-4b11-955e-b20b69ed0180
md"
###### *difficult* problems
"

# ╔═╡ 6ddc8b71-329f-4d4d-a6a9-bba549bf51eb
myGCD3(987654321, 123456789),  myGCD3(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ f41268e0-032a-4082-b456-d782a99c4dc2
myGCD3(987654321, -123456789), myGCD3(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ 37179d18-d6d3-463c-9af2-8d04568e186f
md"
###### Rational Input: $a, b \in \mathbb Q$
"

# ╔═╡ f7939ab8-66dc-45fe-9c5e-2f5f5fab11c7
myGCD3(2//3, 2), myGCD3(2//3, -2)             # ==> (2//3, 2//3) --> :)

# ╔═╡ 0fd881e7-2148-4c0f-a002-8c4a937eab71
myGCD3(-2//3, 2), myGCD3(-2//3, -2)           # ==> (2//3, 2//3) --> :)

# ╔═╡ 574e38b6-9c59-4d4c-af42-007670155c60
myGCD3(72//120, 42//70)                       # ==> 3//5

# ╔═╡ 736211ef-956b-4168-83a4-57bbc444d7e6
md"
---
###### 4.4 Julia's Builtin [*Base.gcd*](https://docs.julialang.org/en/v1/base/math/#Base.gcd)
"

# ╔═╡ 35b018b5-fadd-4f42-abe3-1c0d2d206017
gcd(0, 0)                                     # ==> 0 --> :)

# ╔═╡ e4e78771-abf1-4116-9a64-f1a483914f9e
gcd(6, 0), gcd(-6, 0)                         # ==> (6, 6) --> :)

# ╔═╡ 758904df-59f0-4d6c-83de-e41dba2c0702
gcd(0, 6), gcd(0, -6)                         # ==> (6, 6) --> :)

# ╔═╡ 219b1495-2f60-4f6c-aa65-a57433d57218
gcd(6, 9), gcd(6, -9)                         # ==> (3, 3) --> :)

# ╔═╡ 105ab626-3b06-4e19-b112-630caa7546cf
gcd(206, 40)                                  # ==> 2 --> :)  SICP's example

# ╔═╡ 46f83d7a-4690-43a3-9737-66ddf5de6b2b
md"
**269, 271** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 402c9d2f-480a-43f6-8b28-a39a286d2359
gcd(7907, 7919), gcd(-7907, 7919), gcd(7907, -7919), gcd(-7907, -7919)

# ╔═╡ 66151e66-3136-48b6-81f4-e1e5ff7ffc2b
md"
**7907 	7919** ; both are *adjacent* [prime numbers](https://en.wikipedia.org/wiki/List_of_prime_numbers)
"

# ╔═╡ 8bf38756-d278-4f71-ad07-1a5905e3b488
gcd(7919, 7907), gcd(7919, -7907), gcd(-7919, 7907), gcd(-7919, -7907)

# ╔═╡ f4655616-a0a7-470f-8688-43098165d802
md"
###### *difficult* problems
"

# ╔═╡ 1fbfb94a-3167-41f3-a4c5-b5df441e02eb
gcd(987654321, 123456789),  gcd(-987654321, 123456789)   # ==> (9, 9) --> :)

# ╔═╡ 7eb9b02f-deb0-48bb-b309-1969754095fb
gcd(987654321, -123456789), gcd(-987654321, -123456789)  # ==> (9, 9) --> :)

# ╔═╡ 04e0dd59-266e-419d-a663-a1d1e69587bb
md"
###### Rational Input: $a, b \in \mathbb Q$
"

# ╔═╡ 0e3ec5a5-a107-4a29-a7dc-c8dee05aafe2
gcd(1//3, 2//3), gcd(1//3, -2//3)             # ==> (1//3, 1//3) --> :)

# ╔═╡ a071d0e3-f252-401c-b16b-1f56f581c313
gcd(2//3, 2), gcd(2//3, -2)                   # ==> (2//3, 2//3) --> :)

# ╔═╡ 44554b30-90e5-45dd-93ee-8490dc0cb450
gcd(-2//3, 2), gcd(-2//3, -2)                 # ==> (2//3, 2//3) --> :)

# ╔═╡ db327c24-5443-481d-b2c9-ba7c01b2e46e
typeof(gcd(2//3, 2))                          # parametrized type

# ╔═╡ 46897383-0c6c-4c18-b1d7-5e1c6a63dbe0
md"
---
##### 5. *big*-$O$ *complexity* of recursive $gcd$ with $remainder$-*reduction*
###### 5.1 Derivation
By use of [*Lamé*](https://en.wikipedia.org/wiki/Gabriel_Lam%C3%A9)'s theorem (c.f. SICP, 1996, 2016) we can determine an *upper limit* for the number of steps $k = \#steps(gcd(n, m)) \;;\; n>m$ the tail-recursive gcd(n, m) needs computing the *greatest common divisor* of $n, m\;;\; n>m$.
From this *upper limit* for any $k$ we can determine *big*-$O(\#steps(gcd(n, m)))= O(\log_\phi m) = O(\log m)$.
"

# ╔═╡ cc0d5940-5a9b-4515-bdb0-a01e15a975d4
md"
*Lamé*'s theorem states (SICP, 1996, 2016):

$\text{ If } \#steps(gcd(n, m)) = k$
$\text{ then } min(n, m) \ge fib(k).$

As we have seen before we can approximate $fib(k)$ by a *closed* expression:

$min(n, m) \ge fib(k) \approx \left\lceil \frac{\phi^k}{\sqrt 5} \right\rfloor.$

Taking *logarithms* is:

$\log min(n, m) \ge \left\lceil k \log \phi - \log \sqrt 5 \right\rfloor$

and

$\log min(n, m) + \log \sqrt 5 \ge \left\lceil k \log \phi \right\rfloor$

which is:

$\frac{\log min(n, m)}{\log \phi} + \frac{\log \sqrt 5}{\log \phi} \ge \left\lceil k \right\rfloor$

Changing the basis of *logarithms*:

$\log_\phi min(n, m) + \log_\phi \sqrt 5\ge \left\lceil k \right\rfloor$

So 

$O(\log_\phi min(n,m) = O(\log min(n,m)) \ge \#steps(gcd(n,m)) = k.$

"

# ╔═╡ 10766977-40bd-4d71-856e-fa22f4b97b44
md"
###### 5.2 Example

For $gcd(21, 13)$ the number of *reduction* steps is $\#steps(gcd, 13) = k = 6$.
And $min(21, 13) = 13 \ge fib(6) = 8$.

Now, we compute the reduction steps with $sicpGCD2:$

"


# ╔═╡ 2eb0ec22-3e4a-4f8f-a38a-042817d13c8b
function sicpGCD2(n, m, reduct_nr)
	#-----------------------------------------------------------------------------
	remainder = rem                         # local renaming
	#-----------------------------------------------------------------------------
	if iszero(m)
		abs(n)                              # nonSICP: replacement of a by abs(a)
	else
		reduct_nr += 1
		r = remainder(n, m)
		println("reduct_nr = $reduct_nr ; n = $n, m = $m, r = $r ;") # interpolation 
		sicpGCD2(m, r, reduct_nr)
	end # if
	#-----------------------------------------------------------------------------
end # function SICPsGCD

# ╔═╡ f5fbb73e-7f2f-4d9a-810e-8b9d1f236207
sicpGCD2(21, 13, 0)

# ╔═╡ 2d4206e3-6231-48e9-96fa-89d7a8aaeebd
md"
---
##### 6. Summary
We presented different simple $gcd$-algorithms for *natural*, *integer* and even *rational* numbers. Furthermore we demonstrated how to compute the complexity of *Euclid's algorithm* which is $O(\log min(n, m))$.

"

# ╔═╡ 5cd5cdec-238c-47ae-b079-c25804c6c42e
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996; last visit 2025/01/21

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://web.mit.edu/6.001/6.037/sicp.pdf); Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2025/01/21

- **Rawlins, G.J.E.**; *Compared To What ?*, NY.: Computer Science Press, 1992

- **Wikipedia**; [*Euclidean Algorithm*](https://en.wikipedia.org/wiki/Euclidean_algorithm); last visit 2025/01/21

- **Wikipedia**; [*Greatest Common Divisor*](https://en.wikipedia.org/wiki/Greatest_common_divisor); last visit 2025/01/21

- **Wikipedia**; [*Lamé, Gabriel*](https://en.wikipedia.org/wiki/Gabriel_Lam%C3%A9); last visit 2025/01/25

- **Wikipedia**; [*List of Prime Numbers*](https://en.wikipedia.org/wiki/List_of_prime_numbers); last visit 2025/01/21

- **Wikipedia**; [*Tail Call Optimization*](https://en.wikipedia.org/wiki/Tail_call); last visit 2025/01/22
"

# ╔═╡ 96313012-0e76-42e5-8f76-548c0da1535a
md"
---
###### end of ch. 1.2.5

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
Pluto = "~0.20.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "2361d1a808db1daa1baaa2da4ba0784d61fe348d"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "50c3c56a52972d78e8be9fd135bfb91c9574c140"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.1.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "8873e196c2eb87962a2048b3b8e08946535864a1"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+4"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

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
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "c785dfb1b3bfddd1da557e861b919819b82bbe5b"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.27.1"

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
git-tree-sha1 = "f36e5e8fdffcb5646ea5da81495a5a7566005127"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.3"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "4358750bb58a3caefd5f37a4a0c5bfdbbf075252"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.6"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

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
git-tree-sha1 = "fc173b380865f70627d7dd1190dc2fce6cc105af"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.14.10+0"

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
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

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
git-tree-sha1 = "e51db81749b0777b2147fbe7b783ee79045b8e99"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.4+3"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "7005f1493c18afb2fa3bdf06e02b16a9fde5d16d"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.0"

[[deps.ExproniconLite]]
git-tree-sha1 = "4c9ed87a6b3cd90acf24c556f2119533435ded38"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.13"

[[deps.Extents]]
git-tree-sha1 = "81023caa0021a41712685887db1fc03db26f41f5"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.4"

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
git-tree-sha1 = "21fac3c77d7b5a9fc03b0ec503aa1a6392c34d2b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.15.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "786e968a8d2fb167f2e4880baba62e0e26bd8e4e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.3+1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "846f7026a9decf3679419122b49f8a1fdb48d2d5"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.16+0"

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
git-tree-sha1 = "424c8f76017e39fdfcdbb5935a8e6742244959e8"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "b90934c8cb33920a8dc66736471dc3961b42ec9f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.10+0"

[[deps.GeoFormatTypes]]
git-tree-sha1 = "59107c179a586f0fe667024c5eb7033e81333271"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.2"

[[deps.GeoInterface]]
deps = ["DataAPI", "Extents", "GeoFormatTypes"]
git-tree-sha1 = "f4ee66b6b1872a4ca53303fbb51d158af1bf88d4"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.4.0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "b62f2b2d76cee0d61a2ef2b3118cd2a3215d3134"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.11"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "01979f9b37367603e2848ea225918a3b3861b606"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+1"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1dc470db8b1131cfc7fb4c115de89fe391b9e780"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "c67b33b085f6e2faf8bf79a61962e7339a81129c"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.15"

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
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "71b48d857e86bf7a1838c4736545699974ce79a2"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.9"

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
git-tree-sha1 = "78e0f4b5270c4ae09c7c5f78e77b904199038945"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.0+2"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "854a9c268c43b77b0a27f22d7fab8d33cdb3a731"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

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

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "8be878062e0ffa2c3f67bb58a595375eda5de80b"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.11.0+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "ff3b4b9d35de638936a525ecd36e86a8bb919d11"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "df37206100d39f79b3376afb6b9cee4970041c61"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.51.1+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "61dfdba58e585066d8bce214c5a51eaa0539f269"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "84eef7acd508ee5b3e956a2ae51b05024181dee0"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.2+2"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "b404131d06f7886402758c9ce2214b636eb4d54a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "edbf5309f9ddf1cab25afc344b1e8150b7c832f9"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.2+2"

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
git-tree-sha1 = "1833212fd6f580c20d4291da9c1b4e8a655b128e"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.0.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

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
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "StaticArrays"]
git-tree-sha1 = "0c51e19351dc1eecc61bc23caaf2262e7ba71973"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.7"
weakdeps = ["Graphs"]

    [deps.NetworkLayout.extensions]
    NetworkLayoutGraphsExt = "Graphs"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "5e1897147d1ff8d98883cda2be2187dcf57d8f0c"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.15.0"
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
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+3"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "12f1439c4f986bb868acda6ea33ebc78e19b95ad"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.7.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ed6834e95bd326c52d5675b4181386dfbe885afb"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.55.5+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

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
git-tree-sha1 = "dae01f8c2e069a683d3a6e17bbae5070ab94786f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.9"

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
deps = ["Base64", "Configurations", "Dates", "Downloads", "ExpressionExplorer", "FileWatching", "FuzzyCompletions", "HTTP", "HypertextLiteral", "InteractiveUtils", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PlutoDependencyExplorer", "PrecompileSignatures", "PrecompileTools", "REPL", "RegistryInstances", "RelocatableFolders", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "b5509a2e4d4c189da505b780e3f447d1e38a0350"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.20.4"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "e0864c15334d2c4bac8137ce3359f1174565e719"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.2.0"

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
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

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
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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
git-tree-sha1 = "47091a0340a675c738b1304b58161f3b0839d454"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.10"
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

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "9537ef82c42cdd8c5d443cbc359110cbb36bae10"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.21"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = ["GPUArraysCore", "KernelAbstractions"]
    StructArraysLinearAlgebraExt = "LinearAlgebra"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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
git-tree-sha1 = "01915bfcd62be15329c9a07235447a89d588327c"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.1"

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
git-tree-sha1 = "a2fccc6559132927d4c5dc183e3e01048c6dcbd6"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "7d1671acbe47ac88e981868a078bd6b4e27c5191"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.42+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "15e637a697345f6743674f1322beefbc5dcd5cfc"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.3+2"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "9dafcee1d24c4f024e7edc92603cedba72118283"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+3"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "2b0e27d52ec9d8d483e2ca0b72b3cb1a8df5c27a"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+3"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "807c226eaf3651e7b2c468f687ac788291f9a89b"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.3+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "02054ee01980c90297412e4c809c8694d7323af3"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+3"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d7155fea91a4123ef59f42c4afb5ab3b4ca95058"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+3"

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
git-tree-sha1 = "a490c6212a0e90d2d55111ac956f7c4fa9c277a6"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+1"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee57a273563e273f0f53275101cd41a8153517a"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "1a74296303b6524a0472a8cb12d3d87a78eb3612"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "dbc53e4cf7701c6c7047c51e17d6e64df55dca94"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+1"

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
git-tree-sha1 = "b9ead2d2bdb27330545eb14234a2e300da61232e"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "622cf78670d067c738667aaa96c553430b65e269"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6e50f145003024df4f5cb96c7fce79466741d601"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.56.3+0"

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
git-tree-sha1 = "b7bfd3ab9d2c58c3829684142f5804e4c6499abc"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.45+0"

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
# ╟─cea33580-f5f4-11eb-292b-3d35bf7a4518
# ╟─42c23ec6-f975-4e6a-bb57-b241df46bf43
# ╟─491a8572-cfa8-4bbb-89f6-c5fa6de0e633
# ╟─86fe0183-5901-4199-a33e-ad7919fbbadb
# ╠═d3577a0d-ec2b-4bec-b330-eebab7c35f1e
# ╟─6e72fc42-e689-46b6-9028-f28dfc9d6eaf
# ╟─401f5a11-12b2-4733-8c10-109f0d9abacc
# ╠═bba620c5-3ec8-4c1c-be62-3ee5d4610555
# ╠═15e862ef-8cc7-4bc9-add5-9f9856c2c17e
# ╠═9db61e2e-69c7-49b5-b499-8e19ca0e73da
# ╠═fbf4a874-f02c-4b44-8181-7e0625ac31e2
# ╠═7f5ecaab-4160-4475-a91d-a1881351e8f6
# ╟─07ffa78d-50f3-4910-aaf4-6f98112865d0
# ╠═825c2a1f-885b-4fe5-bcc5-c8ae5a14a7c5
# ╟─6edf7ce7-3a8a-4af2-964a-8dfa5ed282e9
# ╠═4a5746da-d4be-486f-b955-8b226ee264ac
# ╟─761b3197-1d94-447f-8e9a-965e6d650854
# ╠═570bd207-d64a-4bb6-b1e9-7010e6928202
# ╠═eec014b2-522f-4f54-aa4f-2912dcbd3e24
# ╟─23b966a5-54ac-4175-a6fe-cac6185bbb7a
# ╠═22ff69e2-4a1e-4422-ba08-60b4a2f1c3aa
# ╠═b2fd82ec-d1be-43d8-ad9a-702c8052d8d8
# ╠═28f7b82d-780d-43c9-83aa-ceb9e579817d
# ╠═9383d9cf-3ef4-4696-a0df-273d6b1372bb
# ╠═84067cf7-71c5-4183-ac1c-37bf761f33ce
# ╠═ba182453-1e0a-4ddb-8347-21528a9cf4e0
# ╠═82c3d9ae-8614-4ade-a461-af3cbfe19463
# ╠═23c81845-b61c-4cc6-881b-fc37a4793dbf
# ╠═316cca38-a8e4-4a30-9635-0b3c0c19808d
# ╠═8ee624a2-2069-42ba-8591-f69ae9e885c9
# ╠═d1cc56d5-3fec-4cd5-a4d0-788c8a2e56db
# ╟─10448f52-1fc8-409b-b4bc-9ef231155b8c
# ╠═1fbfa230-9209-4506-9bae-88cd25820bae
# ╟─6ebf2de0-13f2-46f3-b713-fbf01af53080
# ╠═f7ad98ed-87dd-4a44-ae07-51267eb7abaa
# ╟─83782367-d27d-4aa9-8e6b-4ec8ff6aead9
# ╠═8d4b0b84-b5e5-412f-92be-57471fb27a96
# ╠═fcaf8363-d5bd-465c-8045-c08655fd5313
# ╟─f17491ba-332e-47ff-a550-0f3e9d0f5b4a
# ╠═e1163af9-2c3f-4361-964d-1febb18c0b10
# ╠═51ef4341-3263-4c89-b8e7-78a8fb8ec6c1
# ╠═c1b1f764-02da-487b-be8a-1e4582643806
# ╟─f9f7dfe7-c3db-47be-b079-62fa873f8f4b
# ╠═b7bb02fa-22ad-46f5-9e1b-30fe6e37b157
# ╠═82564968-efcf-4656-a81b-dd30e365bcc1
# ╠═961ed92e-669e-42e0-9c80-77a04c2f5f03
# ╠═78426838-2478-4fc0-8d1b-bdff3b78c02b
# ╠═b1635893-2d53-4dd6-879b-ce6fe2d79b29
# ╠═8a42c258-4e28-44c9-aae5-c6a9e933e9bd
# ╠═b379a394-dbb8-4e9b-8546-a82d52cbb94d
# ╠═baed6744-f6e3-4862-898d-9d1c8f84ec65
# ╟─f5f1726e-be92-4e6a-bc03-573401d8457b
# ╠═3be00d9d-a76c-46a9-99cc-f57f1e1ae285
# ╟─15522f43-48ad-4067-b0c2-1cf82e177ac2
# ╠═5ec142a1-4148-490f-851a-e9c1211057ff
# ╟─6c25b150-f081-4c86-8815-238e71bfefe6
# ╠═fd2b06f5-520d-45f0-b46c-de0f1da99aca
# ╠═22eb7d2d-6eaf-4406-a2af-fce6734e04cc
# ╟─d98f169d-2155-4b5f-b6bb-1b1902ee3d70
# ╠═e10235c1-b81b-474c-a6ee-17162611fdc1
# ╠═db38373d-790a-4ca9-8a2e-972c28950ee2
# ╠═0e41dd63-022e-491d-9934-cf6d9a99f1db
# ╟─fcb61a42-36eb-4b1a-8e8d-79f57e536864
# ╠═3faf3840-71d0-4b37-893f-99cca1c0f3eb
# ╠═7f6a7544-b5a7-47d6-8b4e-4b6e2ad8c9c6
# ╠═11b064cb-73c0-449c-939c-918f87d8719d
# ╠═bbc0be78-e798-4c4e-ab62-6bbe66feff50
# ╠═51a6e03d-54aa-4e40-b49e-3d18f25dcc56
# ╠═cf46b648-8c3d-4f27-8613-867bc1f98f1a
# ╠═5f3dfe93-b54d-431b-8d71-8c9319962a97
# ╟─be1224ce-25ea-4cc5-9f93-d20dbf530fa4
# ╠═d614584b-a54c-4fa5-8276-19961301c7c8
# ╠═fc72cd2b-abb9-4d12-a0ff-c3b1f8fd706f
# ╟─158f96db-81d1-4ff9-98d4-b3dea1a0a0c9
# ╠═837b66a7-0fd6-4775-90c1-5f7ee26694c5
# ╠═f6285029-bdd9-4147-b373-30ba9c71d99f
# ╟─235a2931-fad7-4b77-aa73-1d1bc6c76554
# ╠═f6cd510f-90b1-46a0-969b-dc577b47c951
# ╠═e2c8c871-ae11-42ac-9ac7-f03ace653353
# ╟─993f7649-5936-4045-9355-d56d80c11252
# ╠═f5cd25aa-baf9-42b7-a2ae-0e95a009420a
# ╠═34b2dc9a-981a-422c-ae89-c7d86c5869c7
# ╠═258af27c-b40d-47ef-9194-e84d9b13db3a
# ╟─15bc2039-0a35-4071-bfce-54932b75959a
# ╠═06312cce-0bea-490a-ae59-8d94548c2e7e
# ╠═ec4712f8-8348-45af-949d-a7555ec35cd9
# ╠═7a0b869e-8f8b-4b04-8b23-902f3025b9eb
# ╠═11c8eb97-363a-47e7-8363-8bde4da89d89
# ╠═7dd27471-7201-45d2-adbd-653061a02fef
# ╠═a7bb1b00-ac1e-48b5-b529-3d7efcd6f273
# ╠═4852ac5e-9163-4fe5-a83f-4d23283674f6
# ╟─57a1dac8-94fd-4f4b-8664-1230320e4790
# ╠═0123f711-b3af-4404-997c-e07866826451
# ╠═6540922f-698b-4dba-a26d-ba594e8d0c51
# ╟─71a43de5-b947-4acb-bac3-b6d76c1a5256
# ╠═1d080491-d6d7-46be-864d-e922005ce7c8
# ╠═c472a1c8-3f78-4153-b0f2-a0ac36d31845
# ╟─fb59f402-ccd9-4b11-955e-b20b69ed0180
# ╠═6ddc8b71-329f-4d4d-a6a9-bba549bf51eb
# ╠═f41268e0-032a-4082-b456-d782a99c4dc2
# ╟─37179d18-d6d3-463c-9af2-8d04568e186f
# ╠═f7939ab8-66dc-45fe-9c5e-2f5f5fab11c7
# ╠═0fd881e7-2148-4c0f-a002-8c4a937eab71
# ╠═574e38b6-9c59-4d4c-af42-007670155c60
# ╟─736211ef-956b-4168-83a4-57bbc444d7e6
# ╠═35b018b5-fadd-4f42-abe3-1c0d2d206017
# ╠═e4e78771-abf1-4116-9a64-f1a483914f9e
# ╠═758904df-59f0-4d6c-83de-e41dba2c0702
# ╠═219b1495-2f60-4f6c-aa65-a57433d57218
# ╠═105ab626-3b06-4e19-b112-630caa7546cf
# ╟─46f83d7a-4690-43a3-9737-66ddf5de6b2b
# ╠═402c9d2f-480a-43f6-8b28-a39a286d2359
# ╟─66151e66-3136-48b6-81f4-e1e5ff7ffc2b
# ╠═8bf38756-d278-4f71-ad07-1a5905e3b488
# ╟─f4655616-a0a7-470f-8688-43098165d802
# ╠═1fbfb94a-3167-41f3-a4c5-b5df441e02eb
# ╠═7eb9b02f-deb0-48bb-b309-1969754095fb
# ╟─04e0dd59-266e-419d-a663-a1d1e69587bb
# ╠═0e3ec5a5-a107-4a29-a7dc-c8dee05aafe2
# ╠═a071d0e3-f252-401c-b16b-1f56f581c313
# ╠═44554b30-90e5-45dd-93ee-8490dc0cb450
# ╠═db327c24-5443-481d-b2c9-ba7c01b2e46e
# ╟─46897383-0c6c-4c18-b1d7-5e1c6a63dbe0
# ╟─cc0d5940-5a9b-4515-bdb0-a01e15a975d4
# ╟─10766977-40bd-4d71-856e-fa22f4b97b44
# ╠═2eb0ec22-3e4a-4f8f-a38a-042817d13c8b
# ╠═f5fbb73e-7f2f-4d9a-810e-8b9d1f236207
# ╟─2d4206e3-6231-48e9-96fa-89d7a8aaeebd
# ╟─5cd5cdec-238c-47ae-b079-c25804c6c42e
# ╟─96313012-0e76-42e5-8f76-548c0da1535a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
