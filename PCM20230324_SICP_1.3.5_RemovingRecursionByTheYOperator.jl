### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 53d771f2-ca31-11ed-298b-c19af536a151
md"
=====================================================================================
#### NonSICP: 1.3.5 Removing Recursion by *fixed-point* Operator Y
##### file: PCM20230324\_NonSICP\_1.3.5\_RemovingRecursionByYOperator.jl
##### Julia/Pluto.jl-code (1.8.5/19.11) by PCM *** 2023/03/25 ***

=====================================================================================
"

# ╔═╡ 837261b3-5ce7-49f1-9e8a-1367e6de98ac
md"
##### $\lambda$-expression *without* normal form

$(\lambda x. x x) (\lambda x. x x)$ 

is *without* normal form. There is no *redex* and its evaluation is nonterminating in either *applicative-order* or *normal-order* evalution (Peyton-Jones, 1987, p.24; Wagenknecht, 20116 2/e, p.84).
"

# ╔═╡ 26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
try
	(x -> x(x))(x -> x(x))
catch
	error("stackoverflow: application is nonterminating !")
end

# ╔═╡ c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
md"
---
##### Recursive Functions
"

# ╔═╡ e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
md"
###### Example: linear recursive factorial
"

# ╔═╡ d1eae7ec-c742-4c5b-99d6-f8ff85c068e8
let # verbose style with 'function fac(n) ...'
	#-----------------------------------------
	function fac(n) 
		if n == 0 
			1 
		else 
			n * fac(n-1)
		end # if
	end # fac
	#-----------------------------------------
	fac(5)
end # let

# ╔═╡ 91877ecb-693f-4ea5-b57c-75ca9b89cb00
let # less verbose style with 'fac(n) = ...'
	#-----------------------------------------
	fac(n) =
		if n == 0 
			1 
		else 
			n * fac(n-1)
		end # if
	#-----------------------------------------
	fac(5)
end # let

# ╔═╡ 71257404-7412-46cd-b886-00810ebca438
let # less verbose style with 'fac = n -> ...'
	#-----------------------------------------
	fac =
		n -> 
			if n == 0 
				1 
			else 
				n * fac(n-1)
			end # if
	#-----------------------------------------
	fac(5)
end # let

# ╔═╡ c87e55c5-5f31-4187-97c8-7fb34e796e88
md"
###### Recursive definition of the factorial with a *named* $\lambda$-abstraction
- *naming* is not allowed in the *pure* $\lambda$ calculus. So in pure $\lambda$-calculus only the *non*-recursive body 

$(n \rightarrow (n == 0)\; ?\; 1 : n * fac(n-1)).$is a correct expresssion.

- *free* occurance of $fac$ in the $\lambda$-body. This is a direct consequence of the former aspect. 


"

# ╔═╡ 9ba2dc2c-d165-4a58-81c6-dba38bfc401c
let # 
	#-----------------------------------------
	fac = (n -> (n == 0) ? 1 : n * fac(n-1))
	#-----------------------------------------
	fac(5)
end # let

# ╔═╡ bac33f19-712f-46bc-a7e9-27474c9bc762
md"
---
###### Performing a $\beta$-abstraction

$h = (\lambda fac \rightarrow (\lambda n \rightarrow if\; n == 0\; then\; 1\; else\; n\cdot fac(n-1)))$
h is *non*recursive because $fac$ is *bound* by its local parameter. *h* is implemented in Julia (below) similar to Peyton-Jones' definition (2.1) (Peyton-Jones, 1987, p.26).
"

# ╔═╡ ad0ab3db-8990-48ed-9656-13f3c10c7fc0
md"
---
###### fac is a *fixed point*
It is an *unknown* $\lambda$-expression which has to be applied by $h$ so that the result is the *same* $\lambda$-expression:

$fac = h(fac)$

"

# ╔═╡ 6a4af4ee-77d5-48d0-82e5-0e0fe67690e7
let
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  # Peyton-Jones' (2.1)
	fac = h(fac)                                     # fac is an unknown fixed point
end # let

# ╔═╡ 2fa1d71c-e9ce-4e7e-bd8f-842992db9b5c
md"
---
###### An attempt: Is there a *fixed-point combinator* $fac$ ?
We are looking for a $\lambda$-expression that 
- can be *bound to* the parameter $fac$ and
- *substitutes* in the body $(\lambda n \rightarrow if\; n == 0\; then\; 1\; else\; n\cdot fac(n-1))$ the identfier $fac$, and
- *accepts* the evaluated argument $(n-1)$
"

# ╔═╡ e4bfe930-6445-4ae0-88a8-ddd3bbacff78
let
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  # Peyton-Jones' (2.1)
	lambdaFac = (n -> (n == 0) ? 1 : n * fac(n-1))
	h(lambdaFac)(0)        # ==> 1  
	h(lambdaFac)(1)        # ==> 1 
end # let

# ╔═╡ 21e44539-0351-4e51-af68-4b337cc5fe86
let
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  # Peyton-Jones' (2.1)
	lambdaFac = (n -> (n == 0) ? 1 : n * fac(n-1))
	h(lambdaFac)(0)        # ==> 1  
	h(lambdaFac)(1)        # ==> 1 
	h(lambdaFac)(2)        # error: fac not defined !
end # let

# ╔═╡ 4748ebe2-c1af-4218-8554-27ed63267e75
let
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  # Peyton-Jones' (2.1)
	lambdaFac = (n -> (n == 0) ? 1 : n * fac(n-1)) 
	hFac = h(lambdaFac)
	hFac(0)                   # ==> 1
	hFac(1)                   # ==> 1
	# hFac(2)                 # ==> error: fac not defined
end # let

# ╔═╡ 5dffc33f-c4f5-4722-87de-9980da79de65
md"
---
###### *Normal-order* vs. *applicative* vs  order fixed-point combinator $Y$

The *normal-order* fixed-point combinator is (Peyton-Jones, 1987, p.28):

$Y_{normal} = (\lambda h. (\lambda x. h(x x))(\lambda x. h(x x)))$

and the *applicative-order* combinator (Wagenknecht, 2016, p.88) is:

$Y_{applicative} = (\lambda h. (\lambda x. h(\lambda z. ((x\;x)\; z)))(\lambda x. h(\lambda z. ((x\;x)\; z))))$

"

# ╔═╡ 6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
let
	h = (fac -> (n -> (n == 0) ? 1 : n * fac(n-1)))  # Peyton-Jones' (2.1)
	Y = (h -> (x -> h(z -> x(x)(z)))(x -> h(z -> x(x)(z))))
	Y(h)(0)                                 # ==>   1
	Y(h)(1)                                 # ==>   1
	Y(h)(2)                                 # ==>   2
	Y(h)(5)                                 # ==> 120
	Y(h)(6)                                 # ==> 720
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
	isFixedPoint(f, n) = f(n) == n ? n : nothing     # definition of fixed points
	resultArray = [isFixedPoint(f, n) for n = -5:5]  # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false   # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ bfbf3220-e25d-4067-b4af-671323ebc8bf
md"
###### here, *with* the *applicative-order* $Y$-*operator*
$Y = (h \rightarrow (x \rightarrow h(z \rightarrow x(x)(z)))(x \rightarrow h(z \rightarrow x(x)(z))))$

and $h$; whereby $h$ has to be abstracted from $f$ by introducing a *dummy* parameter $g$

$h = (\lambda g. f)$

$f := \lambda x . x^2-2$

or more rolled-out in Julia

$h = (g \rightarrow (x \rightarrow x*x - 2))$
"

# ╔═╡ 96940320-d80d-4e5a-ab3c-1386ca39aea6
let
	h = (g -> (x -> x*x - 2))
	Y = (h -> (x -> h(z -> x(x)(z)))(x -> h(z -> x(x)(z))))
	isFixedPoint(h, n) = Y(h)(n) == n ? n : nothing     # Y(h)(n) is curryfied !
	resultArray = [isFixedPoint(h, n) for n = -5:5]     # fixed points are !== nothing
	isFixedPoint(n) = n !== nothing ? true : false      # 2nd method 'isFixedPoint'
	filter(isFixedPoint, resultArray)
end # let

# ╔═╡ 11dd007d-d463-405a-976c-b4c235333643
md"
---
##### References

- **Peyton-Jones, S.L.**; *The Implementation of Functional Programming Languages*, Hemel-Hempsteadt, Prentice-Hall, 1987
- **Wagenknecht, Ch.**; Programmierparadigmen: Eine Einführung auf der Grundlage von Racket, Wiesbaden: Springer Vieweg, 2016, 
"

# ╔═╡ aec03652-4ce4-45c4-8b80-4ba1c330e37d
md"
---
##### end of ch. 1.3.2
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
# ╟─837261b3-5ce7-49f1-9e8a-1367e6de98ac
# ╠═26b21ef1-556f-447a-9b9c-6f0bfa5bbbfd
# ╟─c3fd003a-2937-4e1a-ba7a-6b4148a64cb3
# ╟─e3c28635-fe2a-4c12-85d2-ab3bda1ad6fe
# ╠═d1eae7ec-c742-4c5b-99d6-f8ff85c068e8
# ╠═91877ecb-693f-4ea5-b57c-75ca9b89cb00
# ╠═71257404-7412-46cd-b886-00810ebca438
# ╟─c87e55c5-5f31-4187-97c8-7fb34e796e88
# ╠═9ba2dc2c-d165-4a58-81c6-dba38bfc401c
# ╟─bac33f19-712f-46bc-a7e9-27474c9bc762
# ╟─ad0ab3db-8990-48ed-9656-13f3c10c7fc0
# ╠═6a4af4ee-77d5-48d0-82e5-0e0fe67690e7
# ╟─2fa1d71c-e9ce-4e7e-bd8f-842992db9b5c
# ╠═e4bfe930-6445-4ae0-88a8-ddd3bbacff78
# ╠═21e44539-0351-4e51-af68-4b337cc5fe86
# ╠═4748ebe2-c1af-4218-8554-27ed63267e75
# ╟─5dffc33f-c4f5-4722-87de-9980da79de65
# ╠═6d8b8692-44dc-4ec2-aa4d-f4fcf250a07e
# ╟─f3a06797-8b04-4bd1-8cff-671212efd9a1
# ╟─3b1f3a8a-d63a-44ca-a60d-7e901a31ab20
# ╠═884a9377-9d98-4642-b13d-e18f39ef0ecc
# ╟─bfbf3220-e25d-4067-b4af-671323ebc8bf
# ╠═96940320-d80d-4e5a-ab3c-1386ca39aea6
# ╟─11dd007d-d463-405a-976c-b4c235333643
# ╟─aec03652-4ce4-45c4-8b80-4ba1c330e37d
# ╟─50ab8a25-767f-4715-94a4-861f43f3d097
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
