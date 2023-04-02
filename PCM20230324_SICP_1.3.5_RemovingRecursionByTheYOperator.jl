### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 53d771f2-ca31-11ed-298b-c19af536a151
md"
=====================================================================================
#### NonSICP: 1.3.5 Recursion by the *fixed-point* Operator Y
##### file: PCM20230324\_NonSICP\_1.3.5\_RemovingRecursionByYOperator.jl
##### Julia/Pluto.jl-code (1.8.5/19.11) by PCM *** 2023/04/02 ***

=====================================================================================
"

# ╔═╡ c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
md"
---
##### Recursive Functions and the Fixed Point Combinator $Y$

*Recursion* in programming languages is usually implemented by *side-effects*. The name of the function is deposited in the environment of the definition, where it can be referenced on demand. The question is, whether the *non*recursive side-effect-*free* $\lambda$-calculus is sufficient powerful to enable recursion.

It has been demonstrated by Alonzo Church, Haskell Curry and others. that this is possible using the so-called *fixed-point-combinator* or *fixed-point-operator* $Y$.

First we present some style variants of the well known recursive $factorial$. Then we demonstrate how e.g. the *factorial* function can be computed side-effect-free and *nonrecursive* with the $Y$-operator.
"

# ╔═╡ e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
md"
###### Example: linear recursive *factorial* function $fac$
"

# ╔═╡ d1eae7ec-c742-4c5b-99d6-f8ff85c068e8
let # verbose style with 'function fac(n) ...'
	#--------------------------------------------
	function fac(n) 
		if n == 0 
			1 
		else 
			n * fac(n-1)
		end # if
	end # fac
	#--------------------------------------------
	fac(5)
	#--------------------------------------------
end # let

# ╔═╡ 91877ecb-693f-4ea5-b57c-75ca9b89cb00
let # less verbose equation style 'fac(n) = ...'
	#--------------------------------------------
	fac(n) =
		if n == 0 
			1 
		else 
			n * fac(n-1)
		end # if
	#--------------------------------------------
	fac(5)
	#--------------------------------------------
end # let

# ╔═╡ 837261b3-5ce7-49f1-9e8a-1367e6de98ac
md"
---
##### A simple *Iteration Pattern* of the $\lambda$-Calculus

There are $\lambda$-expressions *without* [normal form](https://en.wikipedia.org/wiki/Lambda_calculus_definition). They have no *redex* (= *red*ucible *ex*pression). So their evaluation is *non*terminating in either *normal-order* or *applicative-order* evalution (Peyton-Jones, 1987, p.24; Klaeren & Sperber, 2007, p.242; Wagenknecht, 2016 2/e, p.84). 

The shortest possible example for such an $\lambda$-expression is presented here:

###### *Non*terminating $\lambda$-expression without *normal form* in $\lambda$-calculus

In $\lambda$-calculus the evaluation strategy is *normal order* (= Leftmost, outermost).

$(\lambda x. x\; x) (\lambda x. x\; x)$ 

###### *Non*terminating $\lambda$-expression without *normal form* in *julia*:

In Julia the evaluation strategy is *applicative order* (= rightmost, innermost).

$(x \rightarrow x(x))(x \rightarrow x(x))$

Due to the fact that Julia has in contrast to e.g. Scheme *no* tail-call optimization (*tco*) we get a *stack-overflow* error when evaluating this expression.
"

# ╔═╡ 26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
try
	(x -> x(x))(x -> x(x))
catch
	error("stackoverflow: application is nonterminating !")
end # try

# ╔═╡ adaeecd3-3e9a-4814-bfa1-4b123df1b506
md"
The infinite computation process is a sequence of *three* steps:

- 1st, *evaluation* of the argument: In *normal-order* evaluation the *first* subterm $(x \rightarrow x(x))$ is evaluated first. In *applicative-order* evaluation it is the *second* subterm. Both are identical and are evaluated to the anonymous $\lambda$-expression $(x -> x(x))$.

- 2nd, *parameter-argument substitution*: the evaluated argument (= anonymous $\lambda$-expression $(x -> x(x))$ replaces the parameter $x$ of the *other* $\lambda$-expression in the body of that expression:

$(x\rightarrow x(x))[x := x\rightarrow x(x)] \Rightarrow (x\rightarrow x(x))((x\rightarrow x(x)))$

- 3rd, *reduction*: The superfluous outer parentheses $(...)$ of the argument are deleted:

$(x\rightarrow x(x))((x\rightarrow x(x))) \Rightarrow (x\rightarrow x(x))(x\rightarrow x(x))$

Now, the resulting $\lambda$-expression is identical to its origin. So the evaluation process starts again with the 1st step: the argument is evaluated ...

"

# ╔═╡ e8d698cd-7cae-43b5-a392-dc3187197e3e
md"
---
Here is the proof that outer parentheses can be deleted $((...)) \Rightarrow ()$
"

# ╔═╡ d65fe088-f70f-4ce6-ab71-5c91365cdf76
(()) == ( )

# ╔═╡ 122a0654-c03e-4007-810d-460f548488a8
md"
---
##### Approximating the *true* function *FAC* by *non*recursive steps
The following is inspired by Pearce's *Scheme* implementation (Pearce, 1998, Problem 4.28, p.167-169).

"

# ╔═╡ b60a7bbe-b763-48d7-b8ff-d81deb31ae65
	zerop(n) = n == 0

# ╔═╡ c66979e1-e845-4065-a511-1328e7618e98
	pred(n)  = n - 1

# ╔═╡ 2ba3a68a-dbea-4761-9145-bfca31a6b8ec
function oneStepFac(prevStepFac)      # previous step factorial
	#-----------------------------------------------
	n -> zerop(n) ? 1 : n * prevStepFac(pred(n))
	#-----------------------------------------------
end # function oneStepFac

# ╔═╡ 11066847-facf-4548-b16b-66c364cb118d
md"
---
We start with a crude *non*recursive one-step approxmation to the *factorial* and call it $fact_0$ :
"

# ╔═╡ 69bd6810-fd1f-4ae1-91fa-f9142e35d82b
fac_0 = n -> zerop(n) ? 1 : nothing

# ╔═╡ b4c8ff0e-0040-4169-90e8-90e37e71c6d2
md"
---
We build incrementally better approximations, so that

$fac\_i(n) = \begin{cases} 1, & \text{ if }\; i = n = 0 \\
n\;!, & \text{ if }\; 0 \lt n \le i \\
error , & \text{ if }\; i \lt n \end {cases}$

"

# ╔═╡ 3cbb6034-9d25-4ec8-9da5-22fe6160e8a3
begin
	fac_1 = oneStepFac(fac_0)
	fac_2 = oneStepFac(fac_1)
	fac_3 = oneStepFac(fac_2)
	fac_4 = oneStepFac(fac_3)
	fac_5 = oneStepFac(fac_4)
	fac_5(5)                         # ==> 120
	# fac_5(6)                       # ==> "MethodError: no method matching"
end # begin

# ╔═╡ b976159c-7ab2-4df8-b877-fe88e0938324
md"
---
The *true* factorial function $FAC = n!$ is the limit 

$FAC = n! = \lim_{i\to n} fac\_i(n).$

This can be achieved by a recursive iterator $multiStep$:

"

# ╔═╡ bf982e02-a09a-4481-a5bb-e308e307eedb
function multiStep(n, oneStep, oldApprox)
	zerop(n) ? oldApprox : oneStep(multiStep(pred(n), oneStep, oldApprox))
end # function multiStep

# ╔═╡ 774d95f9-8d98-4c3b-bfdc-4303314a07ed
fac = n -> multiStep(n, oneStepFac, fac_0)(n)

# ╔═╡ 71257404-7412-46cd-b886-00810ebca438
let # even less verbose equation style 'fac = n -> ...'
	#---------------------------------------------------
	fac =
		n -> 
			if n == 0 
				1 
			else 
				n * fac(n-1)
			end # if
	#---------------------------------------------------
	fac(5)
	#--------------------------------------------
end # let

# ╔═╡ 90559113-7195-4a2b-8885-9e6453beb207
let # most compact style with 'fac = n -> ...'
	#--------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n -1
	#-------------------------------------------
	fac = n -> zerop(n) ? 1 : n * fac(pred(n))
	#-------------------------------------------
	fac(5)
	#--------------------------------------------
end # let

# ╔═╡ c298e567-93dd-4fbb-aa08-c48f53c84c0e
fac(0)

# ╔═╡ 20d8dccc-8965-414c-88a7-6510495c7162
fac(1)

# ╔═╡ 7d02f459-266a-4f82-84cb-d986e44120db
fac(5)                    # ==> 120  -->  :)

# ╔═╡ 6fdfcc9e-1dda-43d4-bade-6b63f5428889
md"
---
###### Is the iterated $fac(n)$ identical to $FAC = n\;!$  ?
"

# ╔═╡ b4633d58-83ec-4afd-a4e8-ecae3cd6ee23
let
	nmax = 1000
	all([fac(i) == prod(1:i) ? true : false for i = 1:nmax]) ? "fac is equal to FAC = n! upto $nmax. So it's a fixed point (at least for this range) --> :) " : " discrepancy ! --> :("
end # let

# ╔═╡ 2a6d1f45-d564-4829-8d9b-817e1c82d8a7
md"
---
##### Self-improving (*oneStep*) Improvers 

The following is inspired by Pearce's *Scheme* implementation (Pearce, 1998, Problem 4.28, p.167-169).

The goal is to achieve a fixed point combinator $Y_{normal}$

$Y_{normal} := (\lambda f. (\lambda x. f(x\; x))(\lambda x. f(x\; x)))$
"

# ╔═╡ 6219e8b5-240c-448e-aaea-98233975f323
let # similar to Jon Pearce, 1998
	#--------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFac
	#--------------------------------------------------------
	function selfImprover(oldSelfImprover)
		#----------------------------------------------------
		betterFact(n) = selfAppl(oldSelfImprover)(n)
		#----------------------------------------------------
		oneStepFact(betterFact)
		#----------------------------------------------------
	end # function selfImprover
	#--------------------------------------------------------
	selfAppl(f) = f(f)
	#--------------------------------------------------------
	fac = selfAppl(selfImprover)
	#--------------------------------------------------------
	fac(5)                                          # ==> 120
	#--------------------------------------------------------
end # let

# ╔═╡ ac9681c7-1fa4-4cc2-abb7-16d85efc7f3e
let # -> style
	#--------------------------------------------------------
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#--------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFact
	#--------------------------------------------------------
	function selfImprover(oldSelfImprover)
		#----------------------------------------------------
		betterFact = n -> selfAppl(oldSelfImprover)(n)
		#----------------------------------------------------
		oneStepFact(betterFact)
		#----------------------------------------------------
	end # function selfImprover
	#--------------------------------------------------------
	selfAppl = f -> f(f)
	#-------- ------------------------------------------------
	fact = selfAppl(selfImprover)
	#--------------------------------------------------------
	fact(5)                                       # ==> 120
	#--------------------------------------------------------
end # let

# ╔═╡ 65e1369c-e9e9-4f5f-b4c5-a93907eb0ac6
md"
---
##### Fixed Point Y 
The following is inspired by Pearce's *Scheme* implementation (Pearce, 1998, Problem 4.28, p.167-169).

Pearce claims that *no* recursion is used in $fact, oneStepFact,$ or $fix.$
and all *recursive* $foo$-definitions can be replaced by $fix(oneStepFoo)$ (Pearce, 1998, p.169).
"

# ╔═╡ a535117c-33db-4875-b6b6-4580d8147ea1
let
	#------------------------------------------------------------
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#------------------------------------------------------------
	function oneStepFact(prevStepFact)
		n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	end # function oneStepFact
	#------------------------------------------------------------
	function fix(oneStep)
		#--------------------------------------------------------
		function selfImprover(oldSelfImprover)
			#----------------------------------------------------
			better = n -> selfAppl(oldSelfImprover)(n)
			#----------------------------------------------------
			oneStepFact(better)
			#----------------------------------------------------
		end # function selfImprover
		#--------------------------------------------------------
		selfAppl = f -> f(f)
		#--------------------------------------------------------
		selfAppl(selfImprover)
		#--------------------------------------------------------
	end # function fix
	#------------------------------------------------------------
	fac = fix(oneStepFact)
	#------------------------------------------------------------
	fac(5)
	#------------------------------------------------------------
end # let

# ╔═╡ c182a627-4178-4cd9-ae0b-3ecac3d1a0dd
md"""
---
##### The *Normal-order* fixed-Point Combinator $Y$

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
##### The *Applicative-order* fixed-Point Combinator $Y$

###### *Normal-order* vs. *applicative* vs  order fixed-point combinator $Y$

- The *normal-order* fixed-point combinator in the $\lambda$-calculus (Peyton-Jones, 1987, p.28; Klaeren & Sperber, 2007, p.246f; Wagenknecht, 2016, p.87; Barendregt & Barendson, 2020, p.12) is:

$Y_{normal} := (\lambda f. (\lambda x. f(x\; x))(\lambda x. f(x\; x)))$

- and the *applicative-order* combinator in *Scheme* or *Racket* (Klaeren & Sperber, 2007, p.251; Wagenknecht, 2016, p.88) is (rewritten as a $\lambda$-expression)

$Y_{applicative} := (\lambda f. (\lambda x. f(\lambda y. ((x\;x)\; y)))(\lambda x. f(\lambda y. ((x\;x)\; y)))).$

or as a shorter alternative (Friedman & Felleisen, 1987, p.156; 1996, 4/e, p. 172)

$Y_{applicative} := (\lambda le ((\lambda f (f\; f)) (\lambda f (le(\lambda x ((f\; f) x))))))$

"""

# ╔═╡ 51853225-dde0-4856-9944-ed8dea10162e
md"
---
##### The *Applicative-order* fixed-Point Combinator $Y$ in Julia code

The longer version of the *applicative-order* combinator in *Julia* is:

$Y_{applicative} := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))$

where $x(x)(y)$ is a *curryfied* function call
 of *function* $x$.

or the shorter version in the spirit of Friedman & Felleisen (1998, p. 172)

$Y_{applicative} = (le \rightarrow (f \rightarrow f(f))(f\rightarrow le(x \rightarrow f(f)(x))))$

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
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# application
	Y(h)(0)                                 # ==>   1
	Y(h)(1)                                 # ==>   1
	Y(h)(2)                                 # ==>   2
	Y(h)(5)                                 # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 3097520c-cb3d-4833-9bc6-278b8af35dbb
let # Little Schemer, 1996, p.172
	#-------------------------------------------------------------------------
	# definitions
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (le -> (f -> f(f))(f-> le(x -> f(f)(x)))) # Little Schemer, 1996, p.172
	#-------------------------------------------------------------------------
	# application
	Y(h)(0)                                 # ==>   1
	Y(h)(1)                                 # ==>   1
	Y(h)(2)                                 # ==>   2
	Y(h)(5)                                 # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ d138c3bc-eeeb-421f-8d4a-f9504637491f
md"
---
##### Application of $Y$ by Just-in-Time (*JIT*)-Substitutions
###### 1st Step: Replace $h$ in application $Y(h)(n)$ by its *argument* 
$Y(h)(n)[h := (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))] \Rightarrow 720$
"

# ╔═╡ d3f29b81-395b-4b6b-b15b-d65a14de0984
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y(h)(n)                                                          # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y((fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))))(n)            # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 8ab9de06-206c-436e-b121-082e194b1b74
md"
---
###### 2nd Step: delete outer parentheses from first argument

$Y((fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))))(n)  \Rightarrow$
$Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n) \Rightarrow 720$

"

# ╔═╡ 0c260296-00ac-49e3-b095-62572697d14d
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y((fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))))(n)            # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)              # ==> 120
	#-------------------------------------------------------------------------
end # let

# ╔═╡ ea1528d7-b63c-4cd1-b3fe-3c7402541875
md"
---
###### 3rd Step: replace 2nd argument $n$ by $5$

$Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)[n := 6] \Rightarrow 720$

"

# ╔═╡ 5dce70cf-7970-4f82-97d9-84dfa338301e
let
	#-------------------------------------------------------------------------
	# definitions
	n = 5
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(n)              # ==> 120
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(5)              # ==> 120
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of Y
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(5)                      # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of Y
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(5)                                                      # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 201862b6-2398-4b01-9646-4f873ee2ebef
md"
---
###### 5th Step: Replace $f$ in $\lambda$-body of $Y$ by abstracted $\lambda$-body of $fac$ $\Rightarrow 120$

"

# ╔═╡ 7b9f1173-df77-41d3-9b3f-527595617279
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of f  
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(5)                                                     # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of f 
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(5)               # ==> 120 #---------------------------------------------------------------------------------
end # let

# ╔═╡ 08f0705e-2e1b-44ee-8e8e-940d0be43b1f
md"
---
###### 6th *Replication* Step: Replace $x$ in $\lambda$-body of $Y$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 120$

"

# ╔═╡ 715efc3e-004f-495c-83d6-c9162c85611f
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of x  
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(5)               # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* replacement of x 
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(5)                                   # ==> 120 
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ e8a97506-3ce0-42d1-8293-47fe7eefc1df
md"
###### Key *Replication* (= iteration) concept

As can be seen from the 6thstep that it uses an iteration or *replication* pattern which is similar to the simple *infinite iteration pattern*

$(x \rightarrow x(x))(x \rightarrow x(x))$

The *output* of the 5th step is:

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\;?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\: ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$

or only *one* part of the complete $\lambda$-expression

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\: ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$

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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of fac  
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(5)                                    # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of fac
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(5)                          # ==> 120
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of n  
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(5)                          # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacement of n
	zerop(5) ? 1 : 5 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(5))                                                            # ==> 120
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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

# ╔═╡ 8f92c6c2-adb0-4e11-81a8-9d9e4557ca59
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacing fac by lambda (y -> ...)
	5 * (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(4)                              # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacing fac by lambda (y -> ...)
	5 * (n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(4)                          # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ d955ef9c-221f-43a4-acf8-cc73c0d5fd2b
md"
---
###### 15th = 8th Step: Replacing $n$ by $4 \Rightarrow 120$
"

# ╔═╡ f49be294-a311-4ff5-b3e2-8e8e42b57bf0
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacing n by 4
	5 * (n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(4)                         # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* replacing n by 4 
	5 * (zerop(4) ? 1 : 4 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(4)))                            # ==> 120 
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 80c5c35c-78c7-4a07-8001-807ad3614ece
md"
---
###### 16th = 9th Step: Evaluation of $zerop(4) \Rightarrow 120$
"

# ╔═╡ 48cb9014-495d-472f-b2ee-f4466131784b
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(4)
	5 * (zerop(4) ? 1 : 4 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(4)))                            # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(4)
	5 * 4 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(4))                                                           # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 97395079-3060-473b-8b51-b8b1c79c4cc8
md"
---
###### 37th = ... = 16th = 9th Step: Evaluation of $zerop(.) \Rightarrow 120$
"

# ╔═╡ e2e770dc-4b41-4f79-b638-33e290af94f2
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(3)
	5 * 4 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(4))                                                           # ==> 120 
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(3)
	5 * 4 * 3 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(3))                                                           # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(2)
	5 * 4 * 3 * 2 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(2))                                                           # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(2)
	5 * 4 * 3 * 2 * 1 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(1))                                                           # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ f7dd14de-315a-4433-a1f0-37fc3b07e066
md"
---
###### 38th = 10th Step: Evaluation of argument $pred(1) \Rightarrow 0 \Rightarrow 120$
"

# ╔═╡ ffddf44d-de8b-489e-aba0-d6e6bf134b6d
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(3)
	5 * 4 * 3 * 2 * 1 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(1))                                                          # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(2)
	5 * 4 * 3 * 2 * 1 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(0)                                                                # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 9570c677-0cfa-42fa-915b-48d8b0c48096
md"
---
###### 39th = 11th Step: Replacing parameter $y$ by argument $0 \Rightarrow 120$
"

# ╔═╡ be05f62d-f045-4377-94a8-367351ef2e7a
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacing of y by 0
	5 * 4 * 3 * 2 * 1 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(0)                                                                 # ==> 120
	#---------------------------------------------------------------------------------
	# *after* replacing of y by 0
	5 * 4 * 3 * 2 * 1 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(0)                                                            # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ adefb2ce-8c8d-4817-ac46-ab3f842d09cd
md"
---
###### 40th = 12th Step: Deleting outer $(...)$ from argument $\Rightarrow 120$
"

# ╔═╡ 1fadc4ba-b17b-4a5a-98c2-c8982bdea82c
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* deleting outer (...) from argument
	5 * 4 * 3 * 2 * 1 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(0)                                                            # ==> 120
	#---------------------------------------------------------------------------------
	# *after* deleting outer (...) from argument
	5 * 4 * 3 * 2 * 1 * (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(0)                                                                           # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ a01f2731-aa1a-44d2-94a0-ff6bc0d1c4bf
md"
---
###### 41th = 6th *Replication* Step: Replace $x$ in $\lambda$-body of $Y$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 120$

"

# ╔═╡ 27488f52-4bf9-4283-a50c-e587241c105d
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
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
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* evaluation of zerop(0) 
	5 * 4 * 3 * 2 * 1 * (zerop(0) ? 1 : 0 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))                            # ==> 120
	#---------------------------------------------------------------------------------
	# *after* evaluation of zerop(0) 
	5 * 4 * 3 * 2 * 1 * 1                                                   # ==> 120
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 3ee6f37b-e2a7-4deb-9aa9-2696359d695f
md"
===============================================================================
"

# ╔═╡ 24c6a125-fac6-4766-9b24-a47013207658
md"
---
##### The *fix-point combinator* for the simple $cos$-function
*h* is the $\lambda$-abstraction of $f:=cos$ with $g$ as a *dummy* parameter.
"

# ╔═╡ b7b741a2-d58a-45e3-baa7-57ab84e05743
let
	f = cos
	h = (g -> f)        # lamda-abstraction of f
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(h)(0.5)   # ==>  0.87758....
end # let

# ╔═╡ 5e57bfe2-1e49-42cd-a1f3-4d454dbb5b3e
let # chatGPT's modified proposal 2023/03/28 (but this relies on recursive Y)
	Y = (f -> (x -> f(Y(f))(x)))
	f = cos
	h = g -> cos
	Y(h)(0.5)                        # ==> 0.8775825618903728
	[(x, Y(h)(x)) for x = 0:π/4:π]   # ==> cos(0) ... cos(π)
end # let

# ╔═╡ f3a06797-8b04-4bd1-8cff-671212efd9a1
md"
---
##### The *fixed-point combinator* $Y$ for the simple $f := x = x^2 -2$

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
###### here, *with* the *applicative-order* $Y$-*operator*:

$Y_{applicative} := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))$

where the function $h$ to which $Y$ has to be applied has to be abstracted from $f$ by introducing a *dummy* parameter $g$

$f := \lambda x . x^2-2$

$h = (\lambda g. f)$

and plugged into Julia

$h = (g \rightarrow (x \rightarrow x*x - 2))$
"

# ╔═╡ 96940320-d80d-4e5a-ab3c-1386ca39aea6
let
	h = (g -> (x -> x*x - 2))              # g is a dummy parameter not reference in f
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	isFixedPoint(h, n) = Y(h)(n) == n ? n : nothing     # Y(h)(n) is curryfied !
	resultArray = [isFixedPoint(h, n) for n = -10:10]   # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false      # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ 3bd31e72-f69a-41c6-bd1a-1040549d6e25
md"
---
###### $Y$ replaced by its $\lambda$-definition
"

# ╔═╡ a88f39e6-f4d5-49bb-be83-f15275eafd6c
let
	h = (g -> (x -> x*x - 2))              # g is a dummy parameter not reference in f
	# Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	isFixedPoint(h, n) = # Y(h)(n) is curryfied !
		(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(h)(n) == n ? n : nothing 
	resultArray = [isFixedPoint(h, n) for n = -10:10]   # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false      # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ 218c88cb-3246-46d6-b5ab-37dfbbb23549
let # our nonrecursive Y
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	f = cos
	h = g -> cos
	Y(h)(0.5)                        # ==> 0.8775825618903728
	[(x, Y(h)(x)) for x = 0:π/4:π]   # ==> cos(0) ... cos(π)
end # let

# ╔═╡ eb1ca968-12d4-4350-bf12-1175251e359d
let # our nonrecursive Y 
    # replaced by (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	f = cos
	h = g -> cos
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(h)(0.5)                        # ==> 0.8775825618903728
	[(x, (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(h)(x)) for x = 0:π/4:π]   # ==> cos(0) ... cos(π)
end # let

# ╔═╡ 11dd007d-d463-405a-976c-b4c235333643
md"
---
##### References
- **Barendregt, H. & Barendson, E.**; *Introduction to Lambda Calculus*, March, 2000, [https://repository.ubn.ru.nl/bitstream/handle/2066/17289/17289.pdf](https://repository.ubn.ru.nl/bitstream/handle/2066/17289/17289.pdf), last visit 2023/03/30
- **Friedman, D.P. & Felleisen, M.**; *The Little Lisper*; Cambridge, Mass.: MIT Press, 1987
- **Friedman, D.P. & Felleisen, M.**; *The Little Schemer*; Cambridge, Mass.: MIT Press, 1996, 4/e
- **Klaeren, H. & Sperber, M.**; *Die Macht der Abstraktion*, Wiesbaden: Teubner, 2007
- **Pearce, J.**; *Programming and Meta-Programming in Scheme*, Heidelberg: Springer, 1998
- **Peyton-Jones, S.L.**; *The Implementation of Functional Programming Languages*, Hemel-Hempsteadt, Prentice-Hall, 1987
- **Wagenknecht, Ch.**; Programmierparadigmen: Eine Einführung auf der Grundlage von Racket, Wiesbaden: Springer Vieweg, 2016, 
- **Wikipedia**; *Lambda calculus definition*, [https://en.wikipedia.org/wiki/Lambda_calculus_definition}(https://en.wikipedia.org/wiki/Lambda_calculus_definition), last visit 2023/03/26

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
# ╠═90559113-7195-4a2b-8885-9e6453beb207
# ╟─837261b3-5ce7-49f1-9e8a-1367e6de98ac
# ╠═26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
# ╟─adaeecd3-3e9a-4814-bfa1-4b123df1b506
# ╟─e8d698cd-7cae-43b5-a392-dc3187197e3e
# ╠═d65fe088-f70f-4ce6-ab71-5c91365cdf76
# ╟─122a0654-c03e-4007-810d-460f548488a8
# ╠═b60a7bbe-b763-48d7-b8ff-d81deb31ae65
# ╠═c66979e1-e845-4065-a511-1328e7618e98
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
# ╟─6fdfcc9e-1dda-43d4-bade-6b63f5428889
# ╠═b4633d58-83ec-4afd-a4e8-ecae3cd6ee23
# ╟─2a6d1f45-d564-4829-8d9b-817e1c82d8a7
# ╠═6219e8b5-240c-448e-aaea-98233975f323
# ╠═ac9681c7-1fa4-4cc2-abb7-16d85efc7f3e
# ╟─65e1369c-e9e9-4f5f-b4c5-a93907eb0ac6
# ╠═a535117c-33db-4875-b6b6-4580d8147ea1
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
# ╠═8f92c6c2-adb0-4e11-81a8-9d9e4557ca59
# ╟─d955ef9c-221f-43a4-acf8-cc73c0d5fd2b
# ╠═f49be294-a311-4ff5-b3e2-8e8e42b57bf0
# ╟─80c5c35c-78c7-4a07-8001-807ad3614ece
# ╠═48cb9014-495d-472f-b2ee-f4466131784b
# ╟─97395079-3060-473b-8b51-b8b1c79c4cc8
# ╠═e2e770dc-4b41-4f79-b638-33e290af94f2
# ╟─f7dd14de-315a-4433-a1f0-37fc3b07e066
# ╠═ffddf44d-de8b-489e-aba0-d6e6bf134b6d
# ╟─9570c677-0cfa-42fa-915b-48d8b0c48096
# ╠═be05f62d-f045-4377-94a8-367351ef2e7a
# ╟─adefb2ce-8c8d-4817-ac46-ab3f842d09cd
# ╠═1fadc4ba-b17b-4a5a-98c2-c8982bdea82c
# ╟─a01f2731-aa1a-44d2-94a0-ff6bc0d1c4bf
# ╠═27488f52-4bf9-4283-a50c-e587241c105d
# ╟─9ad2a549-b142-4a03-a54f-11e4241dba26
# ╠═c3b58de3-72e2-4bb6-ace7-418d7b5cbf6d
# ╟─fb751f0d-08a6-40d1-b3fa-344f0c5f293d
# ╠═2ca04116-b249-47be-8e8b-fb0abddb13ea
# ╟─afa43125-5d1e-47a2-86c2-b763ab8ae89b
# ╠═f489292a-e154-48d3-ac6c-309ed0718f01
# ╟─3ee6f37b-e2a7-4deb-9aa9-2696359d695f
# ╟─24c6a125-fac6-4766-9b24-a47013207658
# ╠═b7b741a2-d58a-45e3-baa7-57ab84e05743
# ╠═5e57bfe2-1e49-42cd-a1f3-4d454dbb5b3e
# ╟─f3a06797-8b04-4bd1-8cff-671212efd9a1
# ╟─3b1f3a8a-d63a-44ca-a60d-7e901a31ab20
# ╠═884a9377-9d98-4642-b13d-e18f39ef0ecc
# ╟─bfbf3220-e25d-4067-b4af-671323ebc8bf
# ╠═96940320-d80d-4e5a-ab3c-1386ca39aea6
# ╟─3bd31e72-f69a-41c6-bd1a-1040549d6e25
# ╠═a88f39e6-f4d5-49bb-be83-f15275eafd6c
# ╠═218c88cb-3246-46d6-b5ab-37dfbbb23549
# ╠═eb1ca968-12d4-4350-bf12-1175251e359d
# ╟─11dd007d-d463-405a-976c-b4c235333643
# ╟─aec03652-4ce4-45c4-8b80-4ba1c330e37d
# ╟─50ab8a25-767f-4715-94a4-861f43f3d097
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
