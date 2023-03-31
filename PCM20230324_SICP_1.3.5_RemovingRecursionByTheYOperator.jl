### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 53d771f2-ca31-11ed-298b-c19af536a151
md"
=====================================================================================
#### NonSICP: 1.3.5 Removing Recursion by *fixed-point* Operator Y
##### file: PCM20230324\_NonSICP\_1.3.5\_RemovingRecursionByYOperator.jl
##### Julia/Pluto.jl-code (1.8.5/19.11) by PCM *** 2023/03/31 ***

=====================================================================================
"

# ╔═╡ c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
md"

##### This is **work in progress**.
---
##### Recursive Functions and the Fixed Point Combinator $Y$

Recursion in programming languages is normally implemented by *side-effects*. The name of the function is deposited in the environment of the definition, where it can be referenced on demand. The question is, whether the *non*recursive side-effect-*free* $\lambda$-calculus is sufficient powerful to enable recursion.

It has been demonstrated by Alonzo Church, Haskell Curry and others. that this is possible in $\lambda$-calculus with the help of the so-called *fixed-point-combinator* or *fixed-point-operator* $Y$.

First we present some style variants of the well known recursive $factorial$. Then we demonstrate how the factorial function can be computed *side-effect-free* and *nonrecursive* with the $Y$-operator.
"

# ╔═╡ e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
md"
###### Example: linear recursive factorial
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

# ╔═╡ 837261b3-5ce7-49f1-9e8a-1367e6de98ac
md"
---
##### Iteration *within* $\lambda$-Calculus

There are $\lambda$-expressions *without* [normal form](https://en.wikipedia.org/wiki/Lambda_calculus_definition). They have no *redex* (= *red*ucible *ex*pression). So their evaluation is *non*terminating in either *normal-order* or *applicative-order* evalution (Peyton-Jones, 1987, p.24; Klaeren & Sperber, 2007, p.242; Wagenknecht, 2016 2/e, p.84).

###### $\lambda$-expression without *normal form* in $\lambda$-calculus

In $\lambda$-calculus the evaluation strategy is *normal order* (= Leftmost, outermost).

$(\lambda x. x\; x) (\lambda x. x\; x)$ 

###### $\lambda$-expression without *normal form* in *julia*:

In Julia the evaluation strategy is *applicative order* (= rightmost, innermost).

$(x \rightarrow x(x))(x \rightarrow x(x))$

Because in Julia the lambda expression (below) should *not* terminate we get a *stack-overflow* error. This happens because in Julia there is in contrast to e.g. *Scheme* *no* tail-call optimization (*tco*). 
"

# ╔═╡ 26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
try
	(x -> x(x))(x -> x(x))
catch
	error("stackoverflow: application is nonterminating !")
end

# ╔═╡ adaeecd3-3e9a-4814-bfa1-4b123df1b506
md"
The computation process can be partitioned in *three-step* subsequences:
- *evaluation* of the argument: In *normal-order* evaluation the first subterm $(x \rightarrow x(x))$ is evalauted first. In *applicative-order* evaluation it is the second subterm. Both are identical and are evaluated to an anonymous function.
- *argument-parameter binding*: the evaluated argument (= anonymous function $x\rightarrow x(x)$) is bound to the parameter $x$ of the *other* $\lambda$-expression
- *substitution*: in Julia's left subexpression $(x\rightarrow x(x))$ *x* is substituted by $(x\rightarrow x(x))$:

$(x\rightarrow x(x))[x := x\rightarrow x(x)]$

The result is a $\lambda$-expression is identical to its origin

$(x \rightarrow x(x))(x \rightarrow x(x)).$

"

# ╔═╡ 122a0654-c03e-4007-810d-460f548488a8
md"
---
##### The Fixed Point Combinator $Y$
The following is inspired by Pearce's *Scheme* implementation (Pearce, 1998, Problem 4.28, p.167-169).

"

# ╔═╡ b60a7bbe-b763-48d7-b8ff-d81deb31ae65
	zerop(n) = n == 0

# ╔═╡ c66979e1-e845-4065-a511-1328e7618e98
	pred(n)  = n - 1

# ╔═╡ 2ba3a68a-dbea-4761-9145-bfca31a6b8ec
function oneStepFact(prevStepFact)      # previous step factorial
	#-----------------------------------------------
	n -> zerop(n) ? 1 : n * prevStepFact(pred(n))
	#-----------------------------------------------
end # function oneStepFac

# ╔═╡ 11066847-facf-4548-b16b-66c364cb118d
md"
---
We start with a *crude* approxmation to the *factorial* $fact0$:
"

# ╔═╡ 69bd6810-fd1f-4ae1-91fa-f9142e35d82b
fact_0 = n -> zerop(n) ? 1 : nothing

# ╔═╡ b4c8ff0e-0040-4169-90e8-90e37e71c6d2
md"
---
We build incrementally better approximations, so that

$fact\_i(n) = \begin{cases} 1, & \text{ if }\; i = n = 0 \\
n!, & \text{ if }\; 0 \lt n \le i \end {cases}$

"

# ╔═╡ 3cbb6034-9d25-4ec8-9da5-22fe6160e8a3
begin
	fact_1 = oneStepFact(fact_0)
	fact_2 = oneStepFact(fact_1)
	fact_3 = oneStepFact(fact_2)
	fact_4 = oneStepFact(fact_3)
	fact_5 = oneStepFact(fact_4)
	fact_6 = oneStepFact(fact_5)
	fact_6(6)                        # ==> 720
end # begin

# ╔═╡ b976159c-7ab2-4df8-b877-fe88e0938324
md"
---
The *true* factorial function $FAC = n!$ is the limit 

$FAC = n! = \lim_{i\to n} fact\_i(n).$

This can be achieved by a recursive iterator $multiStep$:

"

# ╔═╡ bf982e02-a09a-4481-a5bb-e308e307eedb
function multiStep(n, oneStep, oldApprox)
	zerop(n) ? oldApprox : oneStep(multiStep(pred(n), oneStep, oldApprox))
end # function multiStep

# ╔═╡ 774d95f9-8d98-4c3b-bfdc-4303314a07ed
fact = n -> multiStep(n, oneStepFact, fact_0)(n)

# ╔═╡ c298e567-93dd-4fbb-aa08-c48f53c84c0e
fact(0)

# ╔═╡ 20d8dccc-8965-414c-88a7-6510495c7162
fact(1)

# ╔═╡ 7d02f459-266a-4f82-84cb-d986e44120db
fact(6)                    # ==> 720  -->  :)

# ╔═╡ 6fdfcc9e-1dda-43d4-bade-6b63f5428889
md"
---
###### Is the iterated $fact(n) = FAC = n!$ ?
"

# ╔═╡ b4633d58-83ec-4afd-a4e8-ecae3cd6ee23
let
	nmax = 1000
	all([fact(i) == prod(1:i) ? true : false for i = 1:nmax]) ? "fact is equal to FAC = n! upto $nmax. So it's a fixed point --> :) " : " discrepancy ! --> :("
end # let

# ╔═╡ 2a6d1f45-d564-4829-8d9b-817e1c82d8a7
md"
---
##### Self-improving (*oneStep*) Improvers 

The goal is a fixed point combinator $Y_{normal}$

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
	fact = selfAppl(selfImprover)
	#--------------------------------------------------------
	fact(6)                                       # ==> 720
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
	fact(6)                                       # ==> 720
	#--------------------------------------------------------
end # let

# ╔═╡ 65e1369c-e9e9-4f5f-b4c5-a93907eb0ac6
md"
---
##### Fixed Point Y (ala J. Pearce)
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
	fact = fix(oneStepFact)
	#------------------------------------------------------------
	fact(6)
	#------------------------------------------------------------
end # let

# ╔═╡ c87e55c5-5f31-4187-97c8-7fb34e796e88
md"
---
##### Simulating recursion by hand-coded *Just-in-time* (*jit*) substitutions
*External* bindings in environements are not allowed in the *pure* $\lambda$ calculus. So only the *non*-recursive body is a correct expresssion in $\lambda$-calculus:

$f := (n \rightarrow zerop(n) \; ?\; 1 : n * fac(pred(n)).$ 

The identifier $fac$ occurs *free* in the $\lambda$-body. This is a direct consequence of the former aspect. Evaluation results in an '*unknown fac*' error. So $f$ has to be $\lambda$-abstracted by introducing a parameter $fac$:

$h \Leftarrow_\lambda f \equiv h:= \lambda fac. f$

$h:=(fac \rightarrow (n \rightarrow zerop(n) \; ?\; 1 : n * fac(pred(n))).$

*h* is *non*recursive. To make evaluation possible the parameter $fac$ has to be bound *just-in-time* with $f$ so that evaluation can proceed.

"

# ╔═╡ bac33f19-712f-46bc-a7e9-27474c9bc762
md"
---
###### 1. Naive application $h(nothing)(n)$

$h:=(fac \rightarrow (n \rightarrow zerop(n) \; ?\; 1 : n * fac(pred(n))).$

h is *non*recursive because $fac$ is *bound* by its local parameter. *h* is implemented in Julia (below).
The application

$result = h(nothing)(n)$ 

gives a correct result for

$h(nothing)(0) \Rightarrow 1$

It generates *errors* for all arguments $n \ge 1$, because the identfier $fac$ in the body of $h$ is bound to $nothing$ whose meaning is unknown.
"

# ╔═╡ 6a4af4ee-77d5-48d0-82e5-0e0fe67690e7
let
	#-----------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  
	#-----------------------------------------------
	h(nothing)(0)                                  # ==> 1     -->  :) 
	h(nothing)(1)                                  # ==> error -->  :(
	#-----------------------------------------------
end # let

# ╔═╡ b440d239-d8e9-42a6-99a8-616ffd468e18
md"
---
###### 2. Trial applications $h(f), h_i(h)(n)$
"

# ╔═╡ 99ff1535-c190-4f21-8e7e-b4599f2faf29
let
	#-----------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1))) 
	f = (n -> (n == 0) ? 1 : n * fac(n-1))
	#-----------------------------------------------
	h(nothing)(0)                                    # ==> 1     -->  :)
	h(f)(0)                                          # ==> 1     -->  :) 
	h(f)(1)                                          # ==> 1     -->  :)
	# h(f)(2)                                        # ==> error -->  :(
	#-----------------------------------------------
end # let

# ╔═╡ e481af42-3836-4fd8-ac67-bfc8696ca166
let
	#--------------------------------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1))) 
	h1 = (fac -> (n -> (n == 0) ? 1 : 
		n * (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))(nothing)(n-1)))
	f = (n -> (n == 0) ? 1 : n * fac(n-1))
	#--------------------------------------------------------------------
	h(nothing)(0)                                    # ==> 1     -->  :)
	# h(nothing)(1)                                  # ==> error -->  :(
	h(h)(0)                                          # ==> 1     -->  :) 
	# h(h)(1)                                        # ==> error -->  :(
	h1(nothing)(1)                                   # ==> 1     -->  :)
	h1(h)(1)                                         # ==> 1     -->  :)
	#--------------------------------------------------------------------
end # let

# ╔═╡ 53faddd6-a97f-4d98-8729-913f63086b84
let
	#--------------------------------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1))) 
	h2 = (fac -> (n -> (n == 0) ? 1 : 
		n * (fac -> (n -> (n == 0) ? 1 : 
			n * (fac -> (n -> (n == 0) ? 1 : 
				n * fac(n-1)))(nothing)(n-1)))(nothing)(n-1)))
	f = (n -> (n == 0) ? 1 : n * fac(n-1))
	#--------------------------------------------------------------------
	h2(h)(0)                                          # ==> 1     -->  :)
	h2(h)(1)                                          # ==> 1     -->  :)
	h2(h)(2)                                          # ==> 2     -->  :)
	h2(nothing)(2)                                    # ==> 2     -->  :)
	# h2(h)(3)                                        # ==> error -->  :(
	#--------------------------------------------------------------------
end # let

# ╔═╡ 386c2ea8-13ed-467a-ab5f-a33840f14d97
let
	#-----------------------------------------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1))) 
	h3 = (fac -> (n -> (n == 0) ? 1 : 
		n * (fac -> (n -> (n == 0) ? 1 : 
			n * (fac -> (n -> (n == 0) ? 1 : 
				n * (fac -> (n -> (n == 0) ? 1 : 
					n * fac(n-1)))(nothing)(n-1)))(nothing)(n-1)))(nothing)(n-1)))
	f = (n -> (n == 0) ? 1 : n * fac(n-1))
	#-----------------------------------------------------------------------------
    h3(nothing)(0)                                    # ==> 1     -->  :)
	h3(nothing)(1)                                    # ==> 1     -->  :)
	h3(nothing)(2)                                    # ==> 2     -->  :)
	h3(nothing)(3)                                    # ==> 6     -->  :)
	# h3(nothing)(4)                                  # ==> error -->  :(
	#-------------------------------------------------------------------------------
end # let

# ╔═╡ 33036ceb-e5dc-4384-b20b-0f334cd06694
md"
###### 3. Pattern recognition: substitution of the *innermost* parameter $fac$
$h_{i+1} := h_i[fac := (fac \rightarrow (n \rightarrow (n == 0)\; ?\; 1 : n * fac(n-1)))(nothing)]$
or

$h_{i+1} := h_i[fac := (fac \rightarrow (n \rightarrow (n == 0)\; ?\; 1 : n * fac(n-1)))(h)]$
"

# ╔═╡ 3e66d149-aded-41f8-927a-a302712fea5e
let
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1))) 
	h4 = (fac -> (n -> (n == 0) ? 1 : 
		n * (fac -> (n -> (n == 0) ? 1 : 
			n * (fac -> (n -> (n == 0) ? 1 : 
				n * (fac -> (n -> (n == 0) ? 1 : 
					n * (fac -> (n -> (n == 0) ? 1 :
						n * fac(n-1)))(nothing)(n-1)))(nothing)(n-1)))(nothing)(n-1)))(nothing)(n-1)))
	f = (n -> (n == 0) ? 1 : n * fac(n-1))
	#---------------------------------------------------------------------------------
    h4(nothing)(0)                                    # ==>  1    -->  :)
	h4(nothing)(1)                                    # ==>  1    -->  :)
	h4(nothing)(2)                                    # ==>  2    -->  :)
	h4(nothing)(3)                                    # ==>  6    -->  :)
	h4(nothing)(4)                                    # ==> 24    -->  :)
	# h4(nothing)(5)                                    # ==> error -->  :(
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 5dffc33f-c4f5-4722-87de-9980da79de65
md"""
---
##### Simulating recursion by Y-guided *Just-in-time* (*jit*) substitutions

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


###### *Normal-order* vs. *applicative* vs  order fixed-point combinator $Y$

- The *normal-order* fixed-point combinator in the $\lambda$-calculus (Peyton-Jones, 1987, p.28; Barendregt & Barendson, 2020, p.12; Klaeren & Sperber, 2007, p.246f; Wagenknecht, 2016, p.87) is:

$Y_{normal} := (\lambda f. (\lambda x. f(x\; x))(\lambda x. f(x\; x)))$

- and the *applicative-order* combinator in *Scheme* or *Racket* (Klaeren & Sperber, 2007, p.251; Wagenknecht, 2016, p.88) si (rewritten as a $\lambda$-expression):

$Y_{applicative} := (\lambda f. (\lambda x. f(\lambda y. ((x\;x)\; y)))(\lambda x. f(\lambda y. ((x\;x)\; y)))).$

The *applicative-order* combinator in *Julia* code is:

$Y_{applicative} := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))$

where $x(x)(y)$ is a *curryfied* function call
 of *function* $x$.

"""

# ╔═╡ 6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
let
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
	Y(h)(6)                                 # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ d138c3bc-eeeb-421f-8d4a-f9504637491f
md"
---
###### 1st Step: Replace $n$ in application $Y(h)(n)$ by its *argument* $6$
$Y(h)(n)[n := 6] \Rightarrow 720$
"

# ╔═╡ d3f29b81-395b-4b6b-b15b-d65a14de0984
let
	#-------------------------------------------------------------------------
	# definitions
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	# definitions
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of n
	n = 6
	Y(h)(n)                                 # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of n
	Y(h)(6)                                 # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ f40da5a7-7694-4214-bac7-dcd61231a175
md"
---
###### 2nd Step: Replace $h$ in application $Y(h)(n)$ by its abstracted $\lambda$-definition
$Y(h)(6)[h := fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1\; : n * fac(pred(n)))] \Rightarrow 720$
"

# ╔═╡ 757e4bd9-7178-4b17-a832-4319c96d5801
let
	#-------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of h
	n = 6
	Y(h)(n)                                                # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of h
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(6)    # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ a08e8aee-2c74-4ed9-a366-e603fc897502
md"
---
###### 3rd Step: Replace $Y$ in $Y(fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1\; : n * fac(pred(n))))(6)$ by its $\lambda$-definition

$Y(fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1\; : n * fac(pred(n))))(6)[Y := (f \rightarrow (x \rightarrow f(y \rightarrow x(x)(y)))(x \rightarrow f(y \rightarrow x(x)(y))))] \Rightarrow 720$

"

# ╔═╡ 44ff95d1-8c6e-4144-a827-73685174a504
let
	#---------------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#---------------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#---------------------------------------------------------------------------------
	# *before* replacement of Y
	Y(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(6)    # ==> 720
	#---------------------------------------------------------------------------------
	# *after* replacement of Y
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(6)                                    # ==> 720
	#---------------------------------------------------------------------------------
end # let

# ╔═╡ 201862b6-2398-4b01-9646-4f873ee2ebef
md"
---
###### 4th Step: (Replace $f$ in $\lambda$-body of $Y$ by abstracted $\lambda$-body of $fac$) $\Rightarrow 720$

"

# ╔═╡ 7b9f1173-df77-41d3-9b3f-527595617279
let
	#-------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of f  
	(f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(6)                                          # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of f 
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(6)    # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 08f0705e-2e1b-44ee-8e8e-940d0be43b1f
md"
---
###### 5th Step: (Replace $x$ in $\lambda$-body of $Y$ by $\lambda$-expression 

$(x \rightarrow (fac \rightarrow (n \rightarrow zerop(n)\; ?\; 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))$) $\Rightarrow 720$

"

# ╔═╡ 715efc3e-004f-495c-83d6-c9162c85611f
let
	#-------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of x  
	(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))(6)       # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of x 
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(6)                           # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ c7f74f82-f5ca-4575-9809-c246fa9af5c1
md"
---
###### 6th Step: Replacing $fac$ by 

$(y \rightarrow (x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y)))((x \rightarrow (fac \rightarrow (n \rightarrow zerop(n) ? 1 : n * fac(pred(n))))(y \rightarrow x(x)(y))))(y))$

"

# ╔═╡ 9bd8cdd0-13c0-479b-9501-3bd91f55bbcb
let
	#-------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of x  
	(fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(6)                           # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of x 
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(6)                 # ==> 720
	#-------------------------------------------------------------------------
end # let

# ╔═╡ 8796fd3b-e46e-40f8-91d2-8ceda585a93f
md"
---
###### 7th Step: Replacing $n$ by $6$
"

# ╔═╡ 0e312e9a-bfcb-4ffc-907b-4f1a3573707f
let
	#-------------------------------------------------------------------------
	zerop(n) = n == 0
	pred(n)  = n - 1
	#-------------------------------------------------------------------------
	h = (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n)))) 
	Y = (f -> (x -> f(y -> x(x)(y)))(x -> f(y -> x(x)(y))))
	#-------------------------------------------------------------------------
	# *before* replacement of x  
	(n -> zerop(n) ? 1 : n * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(n)))(6)                 # ==> 720
	#-------------------------------------------------------------------------
	# *after* replacement of x 
	(zerop(6) ? 1 : 6 * (y -> (x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y)))((x -> (fac -> (n -> zerop(n) ? 1 : n * fac(pred(n))))(y -> x(x)(y))))(y))(pred(6)))                                                  # ==> 720
	#-------------------------------------------------------------------------
end # let

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
# ╟─c87e55c5-5f31-4187-97c8-7fb34e796e88
# ╟─bac33f19-712f-46bc-a7e9-27474c9bc762
# ╟─6a4af4ee-77d5-48d0-82e5-0e0fe67690e7
# ╟─b440d239-d8e9-42a6-99a8-616ffd468e18
# ╠═99ff1535-c190-4f21-8e7e-b4599f2faf29
# ╠═e481af42-3836-4fd8-ac67-bfc8696ca166
# ╠═53faddd6-a97f-4d98-8729-913f63086b84
# ╠═386c2ea8-13ed-467a-ab5f-a33840f14d97
# ╟─33036ceb-e5dc-4384-b20b-0f334cd06694
# ╠═3e66d149-aded-41f8-927a-a302712fea5e
# ╟─5dffc33f-c4f5-4722-87de-9980da79de65
# ╠═6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
# ╟─d138c3bc-eeeb-421f-8d4a-f9504637491f
# ╠═d3f29b81-395b-4b6b-b15b-d65a14de0984
# ╟─f40da5a7-7694-4214-bac7-dcd61231a175
# ╠═757e4bd9-7178-4b17-a832-4319c96d5801
# ╟─a08e8aee-2c74-4ed9-a366-e603fc897502
# ╠═44ff95d1-8c6e-4144-a827-73685174a504
# ╟─201862b6-2398-4b01-9646-4f873ee2ebef
# ╠═7b9f1173-df77-41d3-9b3f-527595617279
# ╟─08f0705e-2e1b-44ee-8e8e-940d0be43b1f
# ╠═715efc3e-004f-495c-83d6-c9162c85611f
# ╟─c7f74f82-f5ca-4575-9809-c246fa9af5c1
# ╠═9bd8cdd0-13c0-479b-9501-3bd91f55bbcb
# ╟─8796fd3b-e46e-40f8-91d2-8ceda585a93f
# ╠═0e312e9a-bfcb-4ffc-907b-4f1a3573707f
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
