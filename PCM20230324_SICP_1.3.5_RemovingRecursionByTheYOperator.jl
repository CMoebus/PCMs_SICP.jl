### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 53d771f2-ca31-11ed-298b-c19af536a151
md"
=====================================================================================
#### NonSICP: 1.3.5 Recursion by the *fixed-point* Operator Y
##### file: PCM20230324\_NonSICP\_1.3.5\_RemovingRecursionByYOperator.jl
##### Julia/Pluto.jl-code (1.8.5/19.11) by PCM *** 2023/04/09 ***

=====================================================================================
"

# ╔═╡ c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
md"
---
##### Recursive Functions and the Fixed Point Combinator $Y$

*Recursion* in programming languages is usually implemented by *side-effects*. The name of the function is deposited in the environment of the definition, where it can be referenced on demand. The question is, whether the *non*recursive side-effect-*free* $\lambda$-calculus is sufficient powerful to enable recursion.

It has been demonstrated by Alonzo Church, Haskell Curry and others. that this is possible using the so-called *fixed-point-combinator* or *fixed-point-operator* $Y$.

First, we present some *recursive* style variants of the well known *factorial* $n!$. Then we demonstrate how that and other functions can be approximated or computed side-effect-free and *nonrecursive*ly.
"

# ╔═╡ e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
md"
---
##### 1. Style variants of the linear recursive *factorial* function $fact$
"

# ╔═╡ d1eae7ec-c742-4c5b-99d6-f8ff85c068e8
let # verbose style with 'function fact(n) ...'
	#--------------------------------------------
	function fact(n) 
		if n == 0 
			1 
		else 
			n * fact(n-1)
		end # if
	end # fac
	#--------------------------------------------
	fact(5)
	#--------------------------------------------
end # let

# ╔═╡ 91877ecb-693f-4ea5-b57c-75ca9b89cb00
let # less verbose equation style 'fact(n) = ...'
	#--------------------------------------------
	fact(n) =
		if n == 0 
			1 
		else 
			n * fact(n-1)
		end # if
	#--------------------------------------------
	fact(5)
	#--------------------------------------------
end # let

# ╔═╡ a9be9e9f-678c-4ab8-a35e-8f3fa9568924
	begin 
		zerop(n) = n == 0
		pred(n)  = n -1
	end

# ╔═╡ 122a0654-c03e-4007-810d-460f548488a8
md"
---
##### 2. Approximating the *true* function *FAC* by *non*recursive *one*-steps
###### 2.1 Transpilation of Pearce's proposals  from Scheme to Julia
(Pearce, 1998, Problem 4.28, p.167-169)


"

# ╔═╡ 5440ddeb-1e18-4e15-be74-a7944b5b6438
md"
---
*substitutions* made :

$fact\text{-}improver := oneStepFact$
$old\text{-}fact := prevStepFact$
"

# ╔═╡ 2ba3a68a-dbea-4761-9145-bfca31a6b8ec
function oneStepFact(prevStepFact)         # Pearce, 1998, p.167
	#------------------------------------------------------------
	n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	#------------------------------------------------------------
end # function oneStepFact

# ╔═╡ 11066847-facf-4548-b16b-66c364cb118d
md"
---
We start with a crude *non*recursive one-step approxmation to the *factorial* $n!$ and call it $fac\_0$ (Pearce, 1998, p.168):
" 

# ╔═╡ 69bd6810-fd1f-4ae1-91fa-f9142e35d82b
fact_0 = n -> zerop(n) ? 1 : 0

# ╔═╡ b4c8ff0e-0040-4169-90e8-90e37e71c6d2
md"
---
We can build incrementally better approximations (Pearce, 1998, p.168), so that 

$fact\_k(n) = \begin{cases} 1, & \text{ if }\; k = n = 0 \\
n\;!, & \text{ if }\; 0 \lt n \le k \\
0 , & \text{ if }\; k \lt n \end {cases}$

"

# ╔═╡ 3cbb6034-9d25-4ec8-9da5-22fe6160e8a3
begin
	fact_1 = oneStepFact(fact_0)
	fact_2 = oneStepFact(fact_1)
	fact_3 = oneStepFact(fact_2)
	fact_4 = oneStepFact(fact_3)
	fact_5 = oneStepFact(fact_4)
	fact_5(5)                           # ==> 120
	# fact_5(6)                         # ==>   0
end # begin

# ╔═╡ b976159c-7ab2-4df8-b877-fe88e0938324
md"
---
The *true* factorial function $FACT$ 

is the limit 

$FAC = n! = \lim_{i\to n} fac\_i(n).$

This can be achieved by a *recursive* iterator $multiStep$ (Pearce, 1998, p.168). 

We make several *substitutions*:

$iterate := multiStep$
$improver := oneStep$
$init := initialApprox$

"

# ╔═╡ bf982e02-a09a-4481-a5bb-e308e307eedb
function multiStep(n, oneStep, initialApprox)
	zerop(n) ? initialApprox : oneStep(multiStep(pred(n), oneStep, initialApprox))
end # function multiStep

# ╔═╡ 774d95f9-8d98-4c3b-bfdc-4303314a07ed
fact = (n -> multiStep(n, oneStepFact, fact_0)(n))

# ╔═╡ 71257404-7412-46cd-b886-00810ebca438
let # even less verbose equation style 'fact = n -> ...'
	#---------------------------------------------------
	fact =
		n -> 
			if n == 0 
				1 
			else 
				n * fact(n-1)
			end # if
	#---------------------------------------------------
	fact(5)
	#--------------------------------------------
end # let

# ╔═╡ 90559113-7195-4a2b-8885-9e6453beb207
let # most compact style with 'fact = n -> ...'
	#-------------------------------------------
	fact = n -> zerop(n) ? 1 : n * fact(pred(n))
	#-------------------------------------------
	fact(5)
	#--------------------------------------------
end # let

# ╔═╡ c298e567-93dd-4fbb-aa08-c48f53c84c0e
fact(0)

# ╔═╡ 20d8dccc-8965-414c-88a7-6510495c7162
fact(1)

# ╔═╡ 7d02f459-266a-4f82-84cb-d986e44120db
fact(5)                    # ==> 120  -->  :)

# ╔═╡ 7f5b98ae-0033-4324-b0eb-b70cbe7cc8b4
fact(6)                    # ==> 720  -->  :)

# ╔═╡ 6fdfcc9e-1dda-43d4-bade-6b63f5428889
md"
---
###### 2.2 Proof: $fact_{iterate}(n) =  FACT = n\;!$ for $0 \le n \le 1000$
(Pearce, 1998, p.168)
"

# ╔═╡ b4633d58-83ec-4afd-a4e8-ecae3cd6ee23
let
	nmax = 1000
	all([fact(i) == prod(1:i) ? true : false for i = 1:nmax]) ? "fact == to FACT == n! upto $nmax. So it's a fixed point (at least for this range) --> :) " : " discrepancy ! --> :("
end # let

# ╔═╡ 2a6d1f45-d564-4829-8d9b-817e1c82d8a7
md"
---
###### 2.3 Definition of Self-improving (*oneStep*) Improvers 
(Pearce, 1998, p.168f)

The goal is to construct a *script* that is either identical to one of the two alternative versions of a fixed point combinator $Y_{applicative}$ 

- 1st version found in Klaeren & Sperber(2007, p.251; Wagenknecht(2016, p.88) 

$Y_{applicative_1} := (\lambda f. (\lambda x. f(\lambda y. ((x\;x)\; y)))(\lambda x. f(\lambda y. ((x\;x)\; y))))$

or

- 2nd version found in Friedman & Felleisen(1987, p.156; 1996, 4/e, p. 172)

$Y_{applicative_2} := (\lambda f. ((\lambda x. (x\; x)) (\lambda x. (f\;(\lambda y. ((x\; x)\; y))))))$

or is a complete new one.

"

# ╔═╡ eb36eec8-45d3-4f67-93a8-745837bb6ab2
md"
---
We made this *substitution* in Pearce code (Pearce, 1998, p.168f) to achieve similarity with $Y_{applicative}$:

$fact\text{-}improver := oneStepFact$

"

# ╔═╡ 6219e8b5-240c-448e-aaea-98233975f323
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#-------------------------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFact
	#-------------------------------------------------------------------------
	function selfImprover(oldSelfImprover)
		#-------------------------------------------------------------
		betterFact(n) = self(oldSelfImprover)(n)
		#-------------------------------------------------------------
		oneStepFact(betterFact)
		#-------------------------------------------------------------
	end # function selfImprover
	#-------------------------------------------------------------------------
	self(f) = f(f)
	#-------------------------------------------------------------------------
	fact = self(selfImprover)
	#-------------------------------------------------------------------------
	fact(5)                                          # ==> 120 --> :)
	self(selfImprover)(n)                            # ==> 120 --> :)
	#-------------------------------------------------------------------------
end # let

# ╔═╡ b31bf8e4-0157-4e1f-93fb-1bb564a6feb3
md"
---
*substituions*:

$self(f) := self = (x \rightarrow x(x))$
"

# ╔═╡ 0d86808b-8126-4332-b03f-4a9a1f633945
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#-------------------------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFact
	#-------------------------------------------------------------------------
	function selfImprover(oldSelfImprover)
		#-------------------------------------------------------------
		betterFact(n) = (x -> x(x))(oldSelfImprover)(n)
		#-------------------------------------------------------------
		oneStepFact(betterFact)
		#-------------------------------------------------------------
	end # function selfImprover
	#-------------------------------------------------------------------------
	self = (x -> x(x))
	#-------------------------------------------------------------------------
	fact = self(selfImprover)
	#-------------------------------------------------------------------------
	fact(n)                                                 # ==> 120 --> :)
	self(selfImprover)(n)                                   # ==> 120 --> :)
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 65e1369c-e9e9-4f5f-b4c5-a93907eb0ac6
md"
---
###### 2.4 Pearce's Fixed Point Operator $fix$ 

Pearce claims that *no* recursion is used in $fact, oneStepFact,$ or $fix.$
and all *recursive* $foo$-definitions can be replaced by $fix(oneStepFoo)$ (Pearce, 1998, p.169).

The question is whether Pearce's $fix$ is identical to one of the two variants of $Y_{applicative_{i, i=1,2}}$ or is a *new* third alternative.
"

# ╔═╡ f5d26e47-f90f-4f02-a90c-1e93a10241e7
md"
###### Transpilation of Pearce's code from Scheme to Julia

*substitutions*:

$fact\text{-}improver := oneStepFact$
$improver := oneStep$

"

# ╔═╡ a535117c-33db-4875-b6b6-4580d8147ea1
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFact
	#------------------------------------------------------------------------
	function fix(oneStep)
		#--------------------------------------------------------------------
		function selfImprover(oldSelfImprover)
			#----------------------------------------------------------------
			better(n) = self(oldSelfImprover)(n)
			#----------------------------------------------------------------
			oneStep(better)
			#----------------------------------------------------------------
		end # function selfImprover
		#--------------------------------------------------------------------
		self = (x -> x(x))
		#--------------------------------------------------------------------
		self(selfImprover)                         
		#--------------------------------------------------------------------
	end # function fix(oneStep)
	#------------------------------------------------------------------------
    fact = fix(oneStepFact)
	fact(n)                                                  # ==> 120 --> :)
	fix(oneStepFact)(n)                                      # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ 8daac2e1-bad3-4ed9-8ab4-6a0faa2f6964
md"
---
*substitutions*:

$fix := Y$
$oneStep := f$
$oldSelfImprover := y$
$oneStepFact := h$
$prevStepFact := fact$
$h(fact) := h = (fact \rightarrow  ...)$

"

# ╔═╡ 62238323-6e62-4094-ae8d-6e2e4bb976a0
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	#------------------------------------------------------------------------
	function Y(f)
		#--------------------------------------------------------------------
		function selfImprover(y)
			#----------------------------------------------------------------
			better(n) = self(y)(n)
			#----------------------------------------------------------------
			f(better)
			#----------------------------------------------------------------
		end # function selfImprover
		#--------------------------------------------------------------------
		self = (x -> x(x))
		#--------------------------------------------------------------------
		self(selfImprover)                         
		#--------------------------------------------------------------------
	end # function fix(oneStep)
	#------------------------------------------------------------------------
    fact = Y(h)
	fact(n)                                                  # ==> 120 --> :)
	Y(h)(n)                                                  # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ 9e9dd556-405d-486f-88fe-456ca2415525
md"
*substitutions*:

$better(n) := better = (n \rightarrow ...)$
$better := (n \rightarrow (x \rightarrow x(x))(y)(n))$
$self := (x -> x(x))$
$selfImprover(y) := selfImprover = (y\rightarrow ...$
"

# ╔═╡ 2eb03ac0-7e0c-48dd-a002-2dd30653f306
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	#------------------------------------------------------------------------
	function Y(f)
		#--------------------------------------------------------------------
		selfImprover = (y -> f(n -> (x -> x(x))(y)(n)))
		#--------------------------------------------------------------------
		(x -> x(x))(selfImprover)                         
		#--------------------------------------------------------------------
	end # function Y(f)
	#------------------------------------------------------------------------
    fact = Y(h)
	fact(n)                                                  # ==> 120 --> :)
	Y(h)(n)                                                  # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ 5efb8093-8de3-4c45-80d1-ce4e82c36276
md"
---
*substitutions*:

$selfImprover := (y \rightarrow f(n \rightarrow (x \rightarrow x(x))(y)(n)))$
"

# ╔═╡ b7bc3e0e-eefc-4884-84f0-7b956565145f
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	#------------------------------------------------------------------------
	function Y(f)
		#--------------------------------------------------------------------
		# selfImprover = (y -> f(n -> (x -> x(x))(y)(n)))
		#--------------------------------------------------------------------
		(x -> x(x))((y -> f(n -> (x -> x(x))(y)(n))))                         
		#--------------------------------------------------------------------
	end # function Y(f)
	#------------------------------------------------------------------------
    fact = Y(h)
	fact(n)                                                  # ==> 120 --> :)
	Y(h)(n)                                                  # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ c1ff1eca-26ef-4983-960a-8a86fc1428d5
md"
---
*substitutions:

$Y(f) := Y = (f \rightarrow ...)$
$((...)) := (...)$
$y := x$
$n := y$
"

# ╔═╡ 1e34c4ef-9b28-44f3-bc59-138b79f36b5c
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	#------------------------------------------------------------------------
	# Y = (f -> (x -> x(x))((y -> f(n -> (x -> x(x))(y)(n))))) :=
	# Y = (f -> (x -> x(x))(y -> f(n -> (x -> x(x))(y)(n)))) :=
	# Y = (f -> (x -> x(x))(x -> f(n -> (x -> x(x))(x)(n)))) :=
	# Y = (f -> (x -> x(x))(x -> f(y -> (x -> x(x))(x)(y)))) :=
	# Y = (f -> (x -> x(x))(x -> f(y -> (x -> x(x))(x)(y)))) :=
	Y = (f -> (x -> x(x))(x -> f(y -> (x -> x(x))(x)(y))))
	#------------------------------------------------------------------------
    fact = Y(h)
	fact(n)                                                  # ==> 120 --> :)
	Y(h)(n)                                                  # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ f5891ca5-aa95-46f4-b316-450cdaecf1e8
md"
---
*substitution*:
$(x -> x(x))(x) := (x)((x))$
$((x)) := (x)$
$(x)(x) := x(x)$
"

# ╔═╡ b41fe5ca-a4a3-4e96-b040-aedac4fa65e2
let 
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))  # Klaeren ...
	Y2 = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))             # Friedman ...
	#------------------------------------------------------------------------
	h = (fact -> (n -> zerop(n) ? 1 : n * fact(pred(n)))) 
	#------------------------------------------------------------------------
	# Y = (f -> (x -> x(x))(x -> f(y -> (x -> x(x))(x)(y)))) :=
	# Y = (f -> (x -> x(x))(x -> f(y -> (x)((x))(y)))) :=
	# Y = (f -> (x -> x(x))(x -> f(y -> (x)(x)(y)))) :=
	Y = (f -> (x -> x(x))(x -> f(y -> x(x)(y))))  # proof: Y2 = Y
	#------------------------------------------------------------------------
    fact = Y(h)
	fact(n)                                                  # ==> 120 --> :)
	Y(h)(n)                                                  # ==> 120 --> :)
	#------------------------------------------------------------------------
end # let

# ╔═╡ 904e5b90-c1b5-493e-859c-daf39a00ad42
md"
###### This finishes the constructive proof: $Y = Y2 = Y_{applicative_2} \;\;\;\blacksquare$ 
"

# ╔═╡ 837261b3-5ce7-49f1-9e8a-1367e6de98ac
md"
---
##### 3. The Fixed-point Operator Y ($\lambda$-calculus inspired)
###### 3.1 A simple *Iteration Pattern (IP)* of the $\lambda$-Calculus

There are $\lambda$-expressions *without* [normal form](https://en.wikipedia.org/wiki/Lambda_calculus_definition). They have no *redex* (= *red*ucible *ex*pression). So their evaluation is *non*terminating in either *normal-order* or *applicative-order* evalution (Peyton-Jones, 1987, p.24; Klaeren & Sperber, 2007, p.242; Wagenknecht, 2016 2/e, p.84). 

The shortest possible example for such an $\lambda$-expression is presented here:

###### *Non*terminating $\lambda$-expression without *normal form* in $\lambda$-calculus:

In $\lambda$-calculus the evaluation strategy is *normal order* (= Leftmost, outermost).

$(\lambda x. x\; x) (\lambda x. x\; x)$ 

###### *Non*terminating $\lambda$-expression without *normal form* in *Julia*:

In Julia the evaluation strategy is *applicative order* (= rightmost, innermost).

$(x \rightarrow x(x))(x \rightarrow x(x))$

Due to the fact that Julia (in contrast to e.g. Scheme) has *no* tail-call optimization (*tco*) we get a *stack-overflow* error when evaluating this expression.
"

# ╔═╡ 26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
try
	(x -> x(x))(x -> x(x))
catch
	error("stackoverflow: application is nonterminating !")
end # try

# ╔═╡ adaeecd3-3e9a-4814-bfa1-4b123df1b506
md"
---
###### 3.1 Three steps of *one* *IP*'s evaluation cycle
*IP*'s infinite evaluation process is an iteration with *three* steps in *one* cycle:

- 1st, *evaluation* of the argument: In *normal-order* evaluation the *first* subterm $(x \rightarrow x(x))$ is evaluated first. In *applicative-order* evaluation it is the *second* subterm. Both are identical and are evaluated to the anonymous $\lambda$-expression $(x -> x(x))$.

- 2nd, *parameter-argument substitution*: the evaluated argument (= anonymous $\lambda$-expression $(x -> x(x))$ replaces the parameter $x$ of the *other* $\lambda$-expression in the body of that expression:

$(x\rightarrow x(x))[x := x\rightarrow x(x)] \Rightarrow (x\rightarrow x(x))((x\rightarrow x(x))).$

- 3rd, *reduction*: The superfluous outer parentheses $(...)$ of the argument are deleted:

$(x\rightarrow x(x))((x\rightarrow x(x)))[((x\rightarrow x(x))) := (x\rightarrow x(x))] \Rightarrow (x\rightarrow x(x))(x\rightarrow x(x))$

Now, the resulting $\lambda$-expression is identical to its origin. So the evaluation process starts again with the 1st step: the argument is evaluated ...

"

# ╔═╡ c182a627-4178-4cd9-ae0b-3ecac3d1a0dd
md"""
---
###### 3.2 The *Normal-order* fixed-Point Combinator $Y$

In *type-free* $\lambda$-calculus the *Fixedpoint Theorem* (Barendregt & Barendson, 2020, p.12) guarantees that "*forall $F \in \Lambda$ there is an $X \in \Lambda$ such that

$\mathbf{\lambda} \vdash FX = X$ 

$\forall F \; \exists X: FX=X$

and there is a fixed point combinator $Y_{normal}$

$Y_{normal} := (\lambda f. (\lambda x. f(x\; x))(\lambda x. f(x\; x)))$

such that

$\forall F: F(Y_{normal}F) = Y_{normal}F = X$

where

$\Lambda = \text{ set of } \lambda \text{-terms }$ (Barendregt & Barendson, 2020, p.9\)

and that that $FX = X$ is provable in the $\lambda$-calculus

$\mathbf{\lambda} \vdash FX = X$ (Barendregt & Barendson, 2020, p.11\).

"""

# ╔═╡ 5dffc33f-c4f5-4722-87de-9980da79de65
md"""
---
###### 3.3 The *Applicative-order* fixed-Point Combinator $Y$

###### *Normal-order* vs. *applicative* vs  order fixed-point combinator $Y$

- The *normal-order* fixed-point combinator in the $\lambda$-calculus (Peyton-Jones, 1987, p.28; Klaeren & Sperber, 2007, p.246f; Wagenknecht, 2016, p.87; Barendregt & Barendson, 2020, p.12) is:

$Y_{normal} := (\lambda f. (\lambda x. f(x\; x))(\lambda x. f(x\; x)))$

- and the *applicative-order* combinator in *Scheme* or *Racket* (Klaeren & Sperber, 2007, p.251; Wagenknecht, 2016, p.88) is (rewritten as a $\lambda$-expression)

$Y_{applicative_1} := (\lambda f. (\lambda x. f(\lambda y. ((x\;x)\; y)))(\lambda x. f(\lambda y. ((x\;x)\; y)))).$ with 18 $(...)$-parentheses

or the alternative version with rewritten identifiers (Friedman & Felleisen, 1987, p.156; 1996, 4/e, p. 172)

$Y_{applicative_2} := (\lambda f. ((\lambda x. (x\; x)) (\lambda x. (f\;(\lambda y. ((x\; x)\; y))))))$ with 18 $(...)$-parentheses.

"""

# ╔═╡ 51853225-dde0-4856-9944-ed8dea10162e
md"
---
###### 3.4 The *Applicative-order* fixed-Point Combinator $Y$ in Julia code

The first version of the *applicative-order* combinator in *Julia* is:

$Y_{applicative_1} := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))$

where $x(x)(y)$ is a *curryfied* function call
 of *function* $x$.

and the alternative version with rewritten identifiers (Friedman & Felleisen, 1987, p.156; 1996, 4/e, p. 172)

$Y_{applicative_2} := (\lambda f. ((\lambda x. (x\; x)) (\lambda x. (f\;(\lambda y. ((x\; x)\; y))))))$

"

# ╔═╡ 6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
let # a la Klaeren & Sperber and Wagenknecht
	#-------------------------------------------------------------------------
	# definitions
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# application
	Y1(h)(0)                                 # ==>   1
	Y1(h)(1)                                 # ==>   1
	Y1(h)(2)                                 # ==>   2
	Y1(h)(5)                                 # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 3097520c-cb3d-4833-9bc6-278b8af35dbb
let # Little Schemer, 1996, p.172: transpiled to Julia and rewritten identifiers
	#-------------------------------------------------------------------------
	# definitions
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	# Y = (le -> (f -> f(f))(f-> le(x -> f(f)(x)))) # Little Schemer, 1996, p.172
	Y2 = (f -> (x -> x(x))(x-> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# application
	Y2(h)(0)                                 # ==>   1
	Y2(h)(1)                                 # ==>   1
	Y2(h)(2)                                 # ==>   2
	Y2(h)(5)                                 # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ d138c3bc-eeeb-421f-8d4a-f9504637491f
md"
---
###### 3.5 Trace of $Y$'s application by Just-in-Time (*JIT*)-Substitutions
###### 1st Step: Replace $h$ in application $Y(h)(n)$ by its *argument* 
$n = 5$
$Y_1(h)(n)[h := (fac -> (n -> zerop(n)\; ?\; 1 : n * fac(pred(n))))] \Rightarrow 120$
"

# ╔═╡ d3f29b81-395b-4b6b-b15b-d65a14de0984
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y1(h)(n)                                                          # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y1((fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))))(n)            # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 8ab9de06-206c-436e-b121-082e194b1b74
md"
---
###### 2nd Step: Deletion of outer parentheses from first argument

$n=5$
$Y_1((fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n)))))(n)  \Rightarrow$
$Y_1(fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(n) \Rightarrow 120$

"

# ╔═╡ 0c260296-00ac-49e3-b095-62572697d14d
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y1((fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))))(n)            # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y1(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)              # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ ea1528d7-b63c-4cd1-b3fe-3c7402541875
md"
---
###### 3rd Step: replace 2nd argument $n$ by $5$

$Y(fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(n)[n := 5] \Rightarrow 120$

"

# ╔═╡ 5dce70cf-7970-4f82-97d9-84dfa338301e
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y1(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)              # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y1(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)              # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ f25e7aa5-3c43-424e-a00e-37cd46e3d60c
md"
---
###### 4th Step: Replace $Y$ in $Y(fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1\; : n * fac(pred(n))))(6)$ by its $\lambda$-definition

$Y(fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1\; : n * fac(pred(n))))(6)[Y := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))] \Rightarrow 720$

"

# ╔═╡ a6c2ddcf-79a5-400d-a9ee-58809f627042
let
	#---------------------------------------------------------------------------------
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of Y1
	Y1(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)                     # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of Y1
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)                                                      # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 201862b6-2398-4b01-9646-4f873ee2ebef
md"
---
###### 5th Step: Replace $f$ in $\lambda$-body of $Y_1$ by $h$ (= abstracted $\lambda$-body of $fac$) $\Rightarrow 120$

"

# ╔═╡ 7b9f1173-df77-41d3-9b3f-527595617279
let
	#---------------------------------------------------------------------------------
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of f  
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)                                                     # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of f 
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(n)               # ==> 120 #---------------------------------------------------------------------------------
end # let

# ╔═╡ 08f0705e-2e1b-44ee-8e8e-940d0be43b1f
md"
---
###### 6th *Replication* Step: Replace $x$ in $\lambda$-body of $Y_1$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 120$

"

# ╔═╡ 715efc3e-004f-495c-83d6-c9162c85611f
let
	#---------------------------------------------------------------------------------
    n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of x  
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(n)               # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* replacement of x 
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(n)                                   # ==> 120 
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ e8a97506-3ce0-42d1-8293-47fe7eefc1df
md"
###### Insertion: Key *Replication* (= iteration) concept

As can be seen from the 6thstep that it uses an iteration or *replication* pattern which is similar to the simple *infinite iteration pattern*

$(x \rightarrow x(x))(x \rightarrow x(x))$

The *output* of the 5th step is:

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\;?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\: ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$

or only *one* part of the complete $\lambda$-expression

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\: ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$

We see that we have an *immediate* replication and an *delayed* one. In the immediate replication the $\lambda$-argument substitutes $x$ in the body $x(x)[x:= \lambda...]$. 

After this substitution the *delayed* replication is ready to fire.

"

# ╔═╡ c7f74f82-f5ca-4575-9809-c246fa9af5c1
md"
---
###### 7th Step: Replacing $fac$ by 

$(y \rightarrow (x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))((x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y))))(y)) \Rightarrow 120$

"

# ╔═╡ 9bd8cdd0-13c0-479b-9501-3bd91f55bbcb
let
	#---------------------------------------------------------------------------------
	n =5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of fac  
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(n)                                    # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of fac
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(n)                          # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 8796fd3b-e46e-40f8-91d2-8ceda585a93f
md"
---
###### 8th Step: Replacing $n$ by $5 \Rightarrow 120$
"

# ╔═╡ 0e312e9a-bfcb-4ffc-907b-4f1a3573707f
let
	#---------------------------------------------------------------------------------
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of n  
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(n)                          # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of n
	zerop(5) ? 1 : 5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n))                                                            # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ f0678323-9281-4c4f-9d30-0a6a8c02adf4
md"
---
###### 9th Step: Evaluation of $zerop(5) \Rightarrow 120$
"

# ╔═╡ bad11f9c-239a-4991-bc33-29aa755c113f
let
	#---------------------------------------------------------------------------------
	n = 5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(5) 
	zerop(5) ? 1 : 5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(5))                                                            # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(5)
	5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(5))                                                                            # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ f26cdf93-1fa3-4489-b8e8-23031450290c
md"
---
###### 10th Step: Evaluation of argument $pred(5) \Rightarrow 4 \Rightarrow 120$
"

# ╔═╡ 5be3d921-a624-4de8-9464-5ac8313ec567
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of pred(5)  
	5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(5))                                                                            # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of pred(5) 
	5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(4)                                                                                  # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ f8fce82b-ddb9-49c0-a248-8526605d51e8
md"
---
###### 11th Step: Replacing parameter $y$ by argument $4 \Rightarrow 120$
"

# ╔═╡ a803ab81-76c6-4e04-be69-f587e798c312
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacing y by 4 
	5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(4)                                                                                 # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacing y by 4 
	5 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(4)      # ==> 120 #---------------------------------------------------------------------------------
end # let

# ╔═╡ 8bc77f55-7ae9-45cf-90c9-15b1c851e3e5
md"
---
###### 12th Step: Deleting outer $(...)$ from argument $\Rightarrow 120$
"

# ╔═╡ 085fd4f7-bbf2-41b7-b106-ae7300e26c05
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* deleting outer (...) of argument 
	5 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(4)      # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* deleting outer (...) of argument 
	5 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(4)      # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 22efe350-68aa-4a4b-a772-6f4f925a1fb9
md"
---
###### 13th = 6th *Replication* Step: Replace $x$ in $\lambda$-body of $Y$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 120$

"

# ╔═╡ 73ccf8ac-3aa8-4841-8739-47e0fca09793
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacing x by lambda  	
	5 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(4)        # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacing x by lambda
	5 * (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(4)                              # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 8942ba2c-5f27-4f9d-9946-6f8d44cfaecb
md"
---
###### 14th = 7th Step: Replacing $fac$ by 

$(y \rightarrow (x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))((x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y))))(y)) \Rightarrow 120$

"

# ╔═╡ d955ef9c-221f-43a4-acf8-cc73c0d5fd2b
md"
---
###### 15th = 8th Step: Replacing $n$ by $4 \Rightarrow 120$
"

# ╔═╡ 80c5c35c-78c7-4a07-8001-807ad3614ece
md"
---
###### 16th = 9th Step: Evaluation of $zerop(4) \Rightarrow 120$
"

# ╔═╡ 97395079-3060-473b-8b51-b8b1c79c4cc8
md"
---
###### 37th = ... = 16th = 9th Step: Evaluation of $zerop(.) \Rightarrow 120$
"

# ╔═╡ f7dd14de-315a-4433-a1f0-37fc3b07e066
md"
---
###### 38th = 10th Step: Evaluation of argument $pred(1) \Rightarrow 0 \Rightarrow 120$
"

# ╔═╡ 9570c677-0cfa-42fa-915b-48d8b0c48096
md"
---
###### 39th = 11th Step: Replacing parameter $y$ by argument $0 \Rightarrow 120$
"

# ╔═╡ adefb2ce-8c8d-4817-ac46-ab3f842d09cd
md"
---
###### 40th = 12th Step: Deleting outer $(...)$ from argument $\Rightarrow 120$
"

# ╔═╡ a01f2731-aa1a-44d2-94a0-ff6bc0d1c4bf
md"
---
###### 41th = 6th *Replication* Step: Replace $x$ in $\lambda$-body of $Y$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 120$

"

# ╔═╡ 27488f52-4bf9-4283-a50c-e587241c105d
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of x  
	5 * 4 * 3 * 2 * 1 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(0)                                                                           # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of x  
	5 * 4 * 3 * 2 * 1 * (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(0)             # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 9ad2a549-b142-4a03-a54f-11e4241dba26
md"
---
###### 42th = 7th Step: Replacing $fac$ by 

$(y \rightarrow (x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))((x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y))))(y)) \Rightarrow 120$

"

# ╔═╡ c3b58de3-72e2-4bb6-ace7-418d7b5cbf6d
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of fac 
	5 * 4 * 3 * 2 * 1 * (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(0)             # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of fac  
	5 * 4 * 3 * 2 * 1 * (n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(0)                         # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ fb751f0d-08a6-40d1-b3fa-344f0c5f293d
md"
---
###### 43th = 8th Step: Replacing $n$ by $0 \Rightarrow 120$
"

# ╔═╡ 2ca04116-b249-47be-8e8b-fb0abddb13ea
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of fac 
	5 * 4 * 3 * 2 * 1 * (n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(0)                         # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of fac  
	5 * 4 * 3 * 2 * 1 * (zerop(0) ? 1 : 0 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))                            # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ afa43125-5d1e-47a2-86c2-b763ab8ae89b
md"
---
###### 44th = 9th Step: Evaluation of $zerop(0) \Rightarrow 120$
"

# ╔═╡ f489292a-e154-48d3-ac6c-309ed0718f01
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(0) 
	5 * 4 * 3 * 2 * 1 * (zerop(0) ? 1 : 0 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))                            # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(0) 
	5 * 4 * 3 * 2 * 1 * 1                                                   # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 1c84a53e-b8bd-429b-846f-4bf9193dd273
md"
###### The computation has finished with the result $5! = 120\;\;\blacksquare$
---
"

# ╔═╡ ec3f1a02-0b6e-42b1-84fc-28c93f95c2f4
md"
###### 3.6 $\lambda$-Abstraction of $h$ out of a $Y1$-trace expression
"

# ╔═╡ 3ee6f37b-e2a7-4deb-9aa9-2696359d695f
md"
The *outer* parentheses of the argument 

$((x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y))))$ 

can be deleted to

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$ 

and the *body* of the function $h\; (= \lambda$-abstracted function $fact$) can be *abstracted* to

$(f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y))))(fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))$ 

or even further to

$(f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y))))(h)$ 

"

# ╔═╡ 596db420-79bf-43fd-9c23-53212c901ace
let
	#---------------------------------------------------------------------------------
	n =5
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* lambda-abstraction of (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))
	# and introduction of parameter f
	(zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))                                                          # ==> 120
	#---------------------------------------------------------------------------------
	# *after* lambda-abstraction (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))
	# and introduction of parameter f
	(f -> (zerop(n) ? 1 : n * (y -> (x -> f(y -> x(x)(y)))((x -> f(y -> x(x)(y))))(y))(pred(n))))(h)                                                      # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 24c6a125-fac6-4766-9b24-a47013207658
md"
---
##### 4 Examples: Applications of the *fix-point combinator* $Y1$
###### 4.1 to simple nonrecursive $cos$-function

In general $Y1$ computes values of the recursive function $f$ 

$Y1(h) = f$ 

and
 
$Y1(h)(x) = f(x)$  

where $h$ is the $\lambda$-abstraction of the body of function $f$. In $h$ for all recursive calls $f(x)$ $f$ is *not* looked up in an surrounding environment. Instead $f$ is *localized* by being bound to a new parameter $f$ of $h$. To make the distinction between $f$ as a function *symbol* in the environment and $f$ as a *parameter* of $h$ more clear we rename the parameter $f$ in $h$ as $g$

$h[f:=g]$

so that we start with the origininal recursive function $f$

$f = ...f(...).$

Then we make a $\lambda$-abstraction with replacement of $f$ by $g$

$h[f:=g]$

There is only a *fixed-point* iff

$Y1(h)(x) = f(x) = x$. 

E.g. ASS ([SICP, ch.1.2´3.3, 1996, p.69](https://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e3) demonstrate that 

$fixedPoint(cos, 1.0) = 0.7390822985224023.$

In contrast to that is

$Y1(h)(1.0) = f(1.0) = cos(1.0) = 0.5403023058681398.$ 

where

$h = (g \rightarrow f) \text{ and } f = cos.$

*h* is the $\lambda$-abstraction of $f:=cos$ with $g$ as a *dummy* parameter. $g$ is a dummy parameter, because $f$ is *non*recursive, so that in principle the application of $Y!$ is *not* necessary. It is made only for didactal purposes.

"

# ╔═╡ e46ae36e-d15d-4cb2-83bc-5eaca88b67b4
cos(1.0)

# ╔═╡ b7b741a2-d58a-45e3-baa7-57ab84e05743
let
	f = cos
	h = (g -> f)                                            # lamda-abstraction of f
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(h)(π/2)  # ==> 6.123234e-17
	Y1(h)(1.0)                                              # ==> 0.5403023058681398
	Y1(h)(0.7390822985224023)
end # let

# ╔═╡ 578ee2c9-cee4-4946-92d3-d2fbfd6f1e57
cos(0.7390822985224023)   # this is the *fixed-point* of cos(x) = x

# ╔═╡ 218c88cb-3246-46d6-b5ab-37dfbbb23549
let # our nonrecursive Y1
	f = cos
	h = (g -> f)
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	Y1(h)(0.5)                         # ==> 0.8775825618903728
	[(x, Y1(h)(x)) for x = 0:π/4:π]    # ==> cos(0) ... cos(π)
end # let

# ╔═╡ f3a06797-8b04-4bd1-8cff-671212efd9a1
md"
---
###### 4.2 to the simple *non*recursive $f := x = x^2 -2$
In princi

$f := \lambda x . x^2-2$

*fixed points* are 

$x_1 = -1 \text{ and } x_2 = 2.$

We are looking for the *fixed points* of

$f(n) = n$

"

# ╔═╡ 3b1f3a8a-d63a-44ca-a60d-7e901a31ab20
md"
###### first, *without* the $Y$-*operator*
"

# ╔═╡ 884a9377-9d98-4642-b13d-e18f39ef0ecc
let # we are looking for the fixed points of h
	f = n -> n*n-2
	isFixedPoint(f, n) = f(n) == n ? n : nothing       # definition of fixed points
	resultArray = [isFixedPoint(f, n) for n = -10:10]  # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false     # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ bfbf3220-e25d-4067-b4af-671323ebc8bf
md"
###### then, *with* the *applicative-order* $Y$-*operator*:

$Y_{applicative_1} := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))$

where the function $h$ to which $Y$ has to be applied has to be abstracted from $f$ by introducing a *dummy* parameter $g$

$f = x \rightarrow x^2-2$

$h = g \rightarrow f$

and plugged into Julia

$h = (g \rightarrow (x \rightarrow x^2 - 2))$
"

# ╔═╡ 96940320-d80d-4e5a-ab3c-1386ca39aea6
let
	h = (g -> (x -> x^2 - 2))              # g is a dummy parameter not reference in f
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	isFixedPoint(h, n) = Y1(h)(n) == n ? n : nothing    # Y(h)(n) is curryfied !
	resultArray = [isFixedPoint(h, n) for n = -10:10]   # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false      # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ d13998d7-db26-4177-aeb6-ee77e0468bb7
md"
---
###### 4.3 to the recursive computation of $sqrt$
"

# ╔═╡ d5fbf26f-66ab-4db0-9d01-16f6cbc11dc5
md"
###### 4.3.1 Initial guess 
$x0 = 1.0 < sqrt(2.0) \text{ with }\; eps=0.003\; \text{; so that: } Y1(h)(x0) = 1.4151976779972637$
"

# ╔═╡ a596ceb8-ade0-44b4-98b9-347648459712
let
	a   = 2.0       # sqrt(a) = x = 1.4142135623730951
	eps = 0.003
	x0  = 1.0       # initial guess x0 < a 
	#--------------------------------------------------------------------------------
	myTry(x) = (abs(a - x^2) < eps) ? x : myTry(x + 1/2(a - x^2))
	f = (x -> (abs(a - x^2) < eps) ? x : f(x + 1/2(a - x^2)))
    h = (f -> (x -> (abs(a - x^2) < eps) ? x : f(x + 1/2(a - x^2))))
	#--------------------------------------------------------------------------------
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#--------------------------------------------------------------------------------
	myTry(x0)        # ==> 1.4151976779972637 --> :)
	f(x0)            # ==> 1.4151976779972637 --> :)
    Y1(h)(x0)        # ==> 1.4151976779972637 --> :)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ bc7e008e-e7fa-495e-9cd5-dc6a18901139
md"
---
###### 4.3.2 Initial guess 
$x0 = 1.8 > sqrt(2.0) \text{ with }\; eps=0.025\;  \text{; so that: } Y1(h)(x0) = 1.4054316549232007$
"

# ╔═╡ 9a47c946-b326-4777-bbcd-21c0cb026806
let
	a   = 2.0       # sqrt(a) = x = 1.4142135623730951
	eps = 0.025
	x0  = 1.8       # initial guess x0 > a 
	#--------------------------------------------------------------------------------
	myTry(x) = (abs(a - x^2) < eps) ? x : myTry(x + 1/2(a - x^2))
	f = (x -> (abs(a - x^2) < eps) ? x : f(x + 1/2(a - x^2)))
    h = (f -> (x -> (abs(a - x^2) < eps) ? x : f(x + 1/2(a - x^2))))
	#--------------------------------------------------------------------------------
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#--------------------------------------------------------------------------------
	myTry(x0)       # ==> 1.4054316549232007 --> :)
    Y1(h)(x0)       # ==> 1.4054316549232007 --> :)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ 3500c231-151c-45fe-9258-8c89ee476b2c
md"
---
###### 4.4 to [Heron's sqrt-algorithm](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method) - derived from [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method).

The recursion formula of *Newton*'s root finding algorithm is

$x_{n+1} = x_n - \Delta_n = x_n - \frac{1}{f'(x_n)}f(x_n) = x_n - \frac{f(x_n)}{f'(x_n)}.$

where $\Delta_n$ is the *step-width* between approximating steps $x_n$

$\Delta_n = (x_n - x_{n+1}) = \frac{1}{f'(x_n)}f(x_n)$

so that

$\sqrt{a} = \lim_{n \to \infty} x_n.$

The step-width $\Delta_n$ depends *inversely* on the steepness $f'(x_n)$ of $f$ at the point $x_n$. If the steepness is high the stepwidth is small and vice versa. Furthermore $\Delta_n$ depends proportionally on the function value $f(x_n).$

To derive the special case of Heron's square root approximation method we have to define $f$ and $f'$ and substitute these definitions for the symbols $f$ and $f'$ into Newton's formula:

$f = x^2 - a$
$f' = 2x.$
$x_{n+1}= x_n - \frac{f(x_n)}{f'(x_n)}[f := (x^2 - a); f' := 2x]$

So *Heron*'s approximation formula becomes

$x_{n+1}= x_n - \frac{x^2_n-a}{2x_n} = \frac{2x^2_n - x^2_n +a}{2x_n}=\frac{x^2_n+a}{2x_n}= \frac{1}{2}\left(x_n+\frac{a}{x_n}\right).$
"

# ╔═╡ 25b8f677-bce4-4afe-9a81-a16f79abac51
md"
###### 4.4.1 Initial guess 
$x0 = 1.0 < sqrt(2.0) \text{ with }\; eps=0.003\; \text{; so that: } Y1(h)(x0) = 1.4142156862745097$
"

# ╔═╡ 6c4767cb-2d0b-4cff-b25a-0452df23c215
let
	a   = 2.0       # sqrt(a) = x = 1.4142135623730951
	eps = 0.003
	x0  = 1.0       # initial guess x0 < a 
	#--------------------------------------------------------------------------------
	myTry(x) = (abs(a - x^2) < eps) ? x : myTry((x + a/x)/2)
	f(x) = (abs(a - x^2) < eps) ? x : f((x + a/x)/2)
    # h = (f -> (x -> (abs(a - x^2) < eps) ? x : f((x + a/x)/2)))
	h = (myTry -> (x -> (abs(a - x^2) < eps) ? x : myTry((x + a/x)/2.0)))
	#--------------------------------------------------------------------------------
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#--------------------------------------------------------------------------------
	myTry(x0)       # ==> 1.4142156862745097 --> :)
	f(x0)           # ==> 1.4142156862745097 --> :)
    Y1(h)(x0)       # ==> 1.4142156862745097 --> :)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ acca444a-56cc-4d94-be41-07bfce0ffb13
md"
---
###### 4.4.2 Initial guess 
$x0 = 1.8 > sqrt(2.0) \text{ with }\; eps=0.0001\;  \text{; so that: } Y1(h)(x0) = 1.4142136841942816$
"

# ╔═╡ 2a262982-eb66-4ce4-8180-33915bebe3cb
let
	a   = 2.0       # sqrt(a) = x = 1.4142135623730951
	eps = 0.0001
	x0  = 1.8       # initial guess x0 > a 
	#--------------------------------------------------------------------------------
	myTry(x) = (abs(a - x^2) < eps) ? x : myTry((x + a/x)/2)
	f(x) = (abs(a - x^2) < eps) ? x : f((x + a/x)/2)
    # h = (f -> (x -> (abs(a - x^2) < eps) ? x : f((x + a/x)/2)))
	h = (myTry -> (x -> (abs(a - x^2) < eps) ? x : myTry((x + a/x)/2.0)))
	#--------------------------------------------------------------------------------
	Y1 = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#--------------------------------------------------------------------------------
	myTry(x0)       # ==> 1.4142136841942816 --> :)
	f(x0)           # ==> 1.4142136841942816 --> :)
    Y1(h)(x0)       # ==> 1.4142136841942816 --> :)
	#--------------------------------------------------------------------------------
end # let

# ╔═╡ 11dd007d-d463-405a-976c-b4c235333643
md"
---
##### References
- **Abelson, Sussman & Sussman** (**ASS**); *Structure and Interpretation of Computer Programs*, MIT Press, 1966, [https://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e3](https://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e3), last visit 2023/04/07
- **Barendregt, H. & Barendson, E.**; *Introduction to Lambda Calculus*, March, 2000, [https://repository.ubn.ru.nl/bitstream/handle/2066/17289/17289.pdf](https://repository.ubn.ru.nl/bitstream/handle/2066/17289/17289.pdf), last visit 2023/03/30
- **Friedman, D.P. & Felleisen, M.**; *The Little Lisper*; Cambridge, Mass.: MIT Press, 1987
- **Friedman, D.P. & Felleisen, M.**; *The Little Schemer*; Cambridge, Mass.: MIT Press, 1996, 4/e
- **Klaeren, H. & Sperber, M.**; *Die Macht der Abstraktion*, Wiesbaden: Teubner, 2007
- **Pearce, J.**; *Programming and Meta-Programming in Scheme*, Heidelberg: Springer, 1998
- **Peyton-Jones, S.L.**; *The Implementation of Functional Programming Languages*, Hemel-Hempsteadt, Prentice-Hall, 1987
- **Wagenknecht, Ch.**; Programmierparadigmen: Eine Einführung auf der Grundlage von Racket, Wiesbaden: Springer Vieweg, 2016, 
- **Wikipedia**; *Heron's Method*; [https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Heron's_method); last visit 2023/04/08
- **Wikipedia**; *Lambda calculus definition*, [https://en.wikipedia.org/wiki/Lambda_calculus_definition](https://en.wikipedia.org/wiki/Lambda_calculus_definition); last visit 2023/03/26
- **Wikioedia**; *Newton's method*; [https://en.wikipedia.org/wiki/Newton%27s_method](https://en.wikipedia.org/wiki/Newton%27s_method); last visit 2023/04/09

"

# ╔═╡ aec03652-4ce4-45c4-8b80-4ba1c330e37d
md"
---
##### end of ch. 1.3.5
"

# ╔═╡ 50ab8a25-767f-4715-94a4-861f43f3d097
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─53d771f2-ca31-11ed-298b-c19af536a151
# ╟─c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
# ╟─e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
# ╠═d1eae7ec-c742-4c5b-99d6-f8ff85c068e8
# ╠═91877ecb-693f-4ea5-b57c-75ca9b89cb00
# ╠═71257404-7412-46cd-b886-00810ebca438
# ╠═a9be9e9f-678c-4ab8-a35e-8f3fa9568924
# ╠═90559113-7195-4a2b-8885-9e6453beb207
# ╟─122a0654-c03e-4007-810d-460f548488a8
# ╟─5440ddeb-1e18-4e15-be74-a7944b5b6438
# ╠═2ba3a68a-dbea-4761-9145-bfca31a6b8ec
# ╟─11066847-facf-4548-b16b-66c364cb118d
# ╠═69bd6810-fd1f-4ae1-91fa-f9142e35d82b
# ╟─b4c8ff0e-0040-4169-90e8-90e37e71c6d2
# ╠═3cbb6034-9d25-4ec8-9da5-22fe6160e8a3
# ╟─b976159c-7ab2-4df8-b877-fe88e0938324
# ╠═bf982e02-a09a-4481-a5bb-e308e307eedb
# ╠═774d95f9-8d98-4c3b-bfdc-4303314a07ed
# ╠═c298e567-93dd-4fbb-aa08-c48f53c84c0e
# ╠═20d8dccc-8965-414c-88a7-6510495c7162
# ╠═7d02f459-266a-4f82-84cb-d986e44120db
# ╠═7f5b98ae-0033-4324-b0eb-b70cbe7cc8b4
# ╟─6fdfcc9e-1dda-43d4-bade-6b63f5428889
# ╠═b4633d58-83ec-4afd-a4e8-ecae3cd6ee23
# ╟─2a6d1f45-d564-4829-8d9b-817e1c82d8a7
# ╟─eb36eec8-45d3-4f67-93a8-745837bb6ab2
# ╠═6219e8b5-240c-448e-aaea-98233975f323
# ╟─b31bf8e4-0157-4e1f-93fb-1bb564a6feb3
# ╠═0d86808b-8126-4332-b03f-4a9a1f633945
# ╟─65e1369c-e9e9-4f5f-b4c5-a93907eb0ac6
# ╟─f5d26e47-f90f-4f02-a90c-1e93a10241e7
# ╠═a535117c-33db-4875-b6b6-4580d8147ea1
# ╟─8daac2e1-bad3-4ed9-8ab4-6a0faa2f6964
# ╠═62238323-6e62-4094-ae8d-6e2e4bb976a0
# ╟─9e9dd556-405d-486f-88fe-456ca2415525
# ╠═2eb03ac0-7e0c-48dd-a002-2dd30653f306
# ╟─5efb8093-8de3-4c45-80d1-ce4e82c36276
# ╠═b7bc3e0e-eefc-4884-84f0-7b956565145f
# ╟─c1ff1eca-26ef-4983-960a-8a86fc1428d5
# ╠═1e34c4ef-9b28-44f3-bc59-138b79f36b5c
# ╟─f5891ca5-aa95-46f4-b316-450cdaecf1e8
# ╠═b41fe5ca-a4a3-4e96-b040-aedac4fa65e2
# ╟─904e5b90-c1b5-493e-859c-daf39a00ad42
# ╟─837261b3-5ce7-49f1-9e8a-1367e6de98ac
# ╠═26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
# ╟─adaeecd3-3e9a-4814-bfa1-4b123df1b506
# ╟─c182a627-4178-4cd9-ae0b-3ecac3d1a0dd
# ╟─5dffc33f-c4f5-4722-87de-9980da79de65
# ╟─51853225-dde0-4856-9944-ed8dea10162e
# ╠═6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
# ╠═3097520c-cb3d-4833-9bc6-278b8af35dbb
# ╟─d138c3bc-eeeb-421f-8d4a-f9504637491f
# ╠═d3f29b81-395b-4b6b-b15b-d65a14de0984
# ╟─8ab9de06-206c-436e-b121-082e194b1b74
# ╠═0c260296-00ac-49e3-b095-62572697d14d
# ╟─ea1528d7-b63c-4cd1-b3fe-3c7402541875
# ╠═5dce70cf-7970-4f82-97d9-84dfa338301e
# ╟─f25e7aa5-3c43-424e-a00e-37cd46e3d60c
# ╠═a6c2ddcf-79a5-400d-a9ee-58809f627042
# ╟─201862b6-2398-4b01-9646-4f873ee2ebef
# ╠═7b9f1173-df77-41d3-9b3f-527595617279
# ╟─08f0705e-2e1b-44ee-8e8e-940d0be43b1f
# ╠═715efc3e-004f-495c-83d6-c9162c85611f
# ╟─e8a97506-3ce0-42d1-8293-47fe7eefc1df
# ╟─c7f74f82-f5ca-4575-9809-c246fa9af5c1
# ╠═9bd8cdd0-13c0-479b-9501-3bd91f55bbcb
# ╟─8796fd3b-e46e-40f8-91d2-8ceda585a93f
# ╠═0e312e9a-bfcb-4ffc-907b-4f1a3573707f
# ╟─f0678323-9281-4c4f-9d30-0a6a8c02adf4
# ╠═bad11f9c-239a-4991-bc33-29aa755c113f
# ╟─f26cdf93-1fa3-4489-b8e8-23031450290c
# ╠═5be3d921-a624-4de8-9464-5ac8313ec567
# ╟─f8fce82b-ddb9-49c0-a248-8526605d51e8
# ╠═a803ab81-76c6-4e04-be69-f587e798c312
# ╟─8bc77f55-7ae9-45cf-90c9-15b1c851e3e5
# ╠═085fd4f7-bbf2-41b7-b106-ae7300e26c05
# ╟─22efe350-68aa-4a4b-a772-6f4f925a1fb9
# ╠═73ccf8ac-3aa8-4841-8739-47e0fca09793
# ╟─8942ba2c-5f27-4f9d-9946-6f8d44cfaecb
# ╟─d955ef9c-221f-43a4-acf8-cc73c0d5fd2b
# ╟─80c5c35c-78c7-4a07-8001-807ad3614ece
# ╟─97395079-3060-473b-8b51-b8b1c79c4cc8
# ╟─f7dd14de-315a-4433-a1f0-37fc3b07e066
# ╟─9570c677-0cfa-42fa-915b-48d8b0c48096
# ╟─adefb2ce-8c8d-4817-ac46-ab3f842d09cd
# ╟─a01f2731-aa1a-44d2-94a0-ff6bc0d1c4bf
# ╠═27488f52-4bf9-4283-a50c-e587241c105d
# ╟─9ad2a549-b142-4a03-a54f-11e4241dba26
# ╠═c3b58de3-72e2-4bb6-ace7-418d7b5cbf6d
# ╟─fb751f0d-08a6-40d1-b3fa-344f0c5f293d
# ╠═2ca04116-b249-47be-8e8b-fb0abddb13ea
# ╟─afa43125-5d1e-47a2-86c2-b763ab8ae89b
# ╠═f489292a-e154-48d3-ac6c-309ed0718f01
# ╟─1c84a53e-b8bd-429b-846f-4bf9193dd273
# ╟─ec3f1a02-0b6e-42b1-84fc-28c93f95c2f4
# ╟─3ee6f37b-e2a7-4deb-9aa9-2696359d695f
# ╠═596db420-79bf-43fd-9c23-53212c901ace
# ╟─24c6a125-fac6-4766-9b24-a47013207658
# ╠═e46ae36e-d15d-4cb2-83bc-5eaca88b67b4
# ╠═b7b741a2-d58a-45e3-baa7-57ab84e05743
# ╠═578ee2c9-cee4-4946-92d3-d2fbfd6f1e57
# ╠═218c88cb-3246-46d6-b5ab-37dfbbb23549
# ╟─f3a06797-8b04-4bd1-8cff-671212efd9a1
# ╟─3b1f3a8a-d63a-44ca-a60d-7e901a31ab20
# ╠═884a9377-9d98-4642-b13d-e18f39ef0ecc
# ╟─bfbf3220-e25d-4067-b4af-671323ebc8bf
# ╠═96940320-d80d-4e5a-ab3c-1386ca39aea6
# ╟─d13998d7-db26-4177-aeb6-ee77e0468bb7
# ╟─d5fbf26f-66ab-4db0-9d01-16f6cbc11dc5
# ╠═a596ceb8-ade0-44b4-98b9-347648459712
# ╟─bc7e008e-e7fa-495e-9cd5-dc6a18901139
# ╠═9a47c946-b326-4777-bbcd-21c0cb026806
# ╟─3500c231-151c-45fe-9258-8c89ee476b2c
# ╟─25b8f677-bce4-4afe-9a81-a16f79abac51
# ╠═6c4767cb-2d0b-4cff-b25a-0452df23c215
# ╟─acca444a-56cc-4d94-be41-07bfce0ffb13
# ╠═2a262982-eb66-4ce4-8180-33915bebe3cb
# ╟─11dd007d-d463-405a-976c-b4c235333643
# ╟─aec03652-4ce4-45c4-8b80-4ba1c330e37d
# ╟─50ab8a25-767f-4715-94a4-861f43f3d097
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
