### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 119d79a0-1615-11ec-321e-43ce3ce01690
md"
======================================================================================
##### SICP: [2.1.4 Exercise Interval Arithmetic](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e4)

###### file: PCM20210915\_SICP\_2.1.4\_Exercise\_Interval\_Arithmetic.jl

###### code: Julia/Pluto.jl-code (1.8.0/19.11) by PCM *** 2021/08/31 ***

======================================================================================

"

# ╔═╡ b60545c5-c9e7-465c-bdfb-43571296e8e4
md"
#### 2.1.4.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ b1a78493-b08b-4e47-bd6b-101bf40f3fac
md"
##### 2.1.4.1.1 [Intervals](https://en.wikipedia.org/wiki/Interval_arithmetic) ...
... are quantities like

$$[x] \equiv [a, b] = \{x \in \mathbb R \;|\; a \ge x \ge b\}$$

where $$a = -\infty$$ and $$b = \infty$$ are allowed. 
"

# ╔═╡ 140c8504-a3c1-4ebd-99ad-03a25a73cc3a
md"
##### 2.1.4.1.2 [Operations](https://en.wikipedia.org/wiki/Interval_arithmetic)
"

# ╔═╡ a1dda7be-f8f1-4c61-9cf5-f2520e8b8012
md"
---
    -------------------------------------------------------------------------------
     Abstract                                                              level 2
     Operators     add_interval  sub_interval  mul_interval  div_interval   Domain
    ------------------------------------------------------------------------------ 
     Constructor /                      make_interval                      level 1  
     Selectors              lower_bound            upperbound  
    -------------------------------------------------------------------------------
     Constructor /                              cons                       level 0
     Selectors                            car            cdr          Scheme-level
    -------------------------------------------------------------------------------
     Constructor /              consCell = (car = ... , cdr = ...)        level -1
     Selectors                     consCell.car    consCell.cdr        Julia-level
    -------------------------------------------------------------------------------

     Fig. 2.1.4.1: Abstraction Hierarchy for Implementing Interval Arithmetic
---
"

# ╔═╡ c71a180d-e757-4067-8f46-13c457eb32e5
md"
---
###### addition of two intervals:
$$[x] + [y] \equiv [x_1,x_2]+[y_1,y_2] = [x_1+y_1, x_2+y_2]$$
"

# ╔═╡ 512d2fa1-8997-4644-916f-32f7e75528b9
md"
---
###### subtraction of two intervals:
$$[x] - [y] \equiv [x_1,x_2]-[y_1,y_2] = [x_1-y_1, x_2-y_2]$$
"

# ╔═╡ 9c7807ab-8e20-4976-9c58-b49d94ba9eeb
md"
---
###### product of two intervals:
$$p1 = x_1 \cdot y_1$$
$$p2 = x_1 \cdot y_2$$
$$p3 = x_2 \cdot y_1$$
$$p4 = x_2 \cdot y_2$$
$$[x] \times [y] \equiv [x_1, x_2] \times [y_1, y_2]$$
$$= [min(p1, p2, p3, p4), max(p1, p2, p3, p4)]$$
"

# ╔═╡ 26b8868c-6284-4992-89b8-31418ce68eee
md"
---
###### division of two intervals:
$$[x] / [y] \equiv [x_1, x_2] \times \frac{1}{[y_1,y_2]} = [x_1, x_2] \times \left[\frac{1}{y_2}, \frac{1}{y_1}\right]$$
"

# ╔═╡ fc9a0039-56a4-4543-b679-47a685b2900b
md"
---
##### 2.1.4.1.3 Constructors $$make\_interval$$ and $$cons$$
###### make_interval:
$$make\_interval: \mathbb R, \mathbb R \rightarrow [\mathbb R, \mathbb R]$$
$$x, y \mapsto [x, y]$$
$$[x, y] \mapsto cons(x, y)$$
"

# ╔═╡ 1554e00b-0529-4db0-a4ff-e51a31a4fe8f
md"
###### cons as NamedTuple
"

# ╔═╡ a20f1e07-81b8-44cf-b36e-496c6020ed04
cons(x, y)::NamedTuple = (car=x, cdr=y)

# ╔═╡ e80710bd-7cfd-4d59-8b5d-b24b18619ac1
function make_interval(a, b)
	cons(a, b)
end # function make_interval

# ╔═╡ 3930b9a1-4c48-4f15-a6d1-4414679b33b9
x, y = :a, :b

# ╔═╡ 18a92faa-cece-496f-bd09-3533ffc46de7
z = cons(x, y)

# ╔═╡ 0f94e444-19c6-4bed-bc9d-4b4a3e43b7d5
typeof(z)

# ╔═╡ da7125bb-fce0-4758-898c-b15b22033d50
md"
---
##### 2.1.4.1.4 Selectors $$lower\_bound, upper\_bound, car$$ and $$cdr$$
$$car(cons(x, y)) \mapsto x$$
$$cdr(cons(x, y)) \mapsto y$$
"

# ╔═╡ e5664b57-2e7a-46cc-99cc-1a2a10ad7c95
car(cons::NamedTuple) = cons.car

# ╔═╡ e2a99e6d-15b3-484b-b08b-c99675a21b08
lower_bound(cons::NamedTuple) = car(cons)

# ╔═╡ 262468f2-0a6f-49f6-a242-fe1a9ed51e60
cdr(cons::NamedTuple) = cons.cdr

# ╔═╡ 24605725-f9cc-4962-833b-86c035f9774a
upper_bound(cons::NamedTuple) = cdr(cons)

# ╔═╡ d7e41439-209c-478a-99d4-c53416fd6053
function add_interval(x, y)
	make_interval(
		+(lower_bound(x), lower_bound(y)), 
		+(upper_bound(x), upper_bound(y)))
end # function add_interval

# ╔═╡ b74d46f9-017d-446e-b2b8-a76fc788c1c7
function sub_interval(x, y)
	make_interval(
		-(lower_bound(x), lower_bound(y)), 
		-(upper_bound(x), upper_bound(y)))
end # function sub_interval

# ╔═╡ ee15d5a7-b8a0-4087-b188-30f39ef8fe67
function mul_interval(x, y)
	let p1 = *(lower_bound(x), lower_bound(y))
		p2 = *(lower_bound(x), upper_bound(y))
		p3 = *(upper_bound(x), lower_bound(y))
		p4 = *(upper_bound(x), upper_bound(y))
		make_interval(min(p1, p2, p3, p4), max(p1, p2, p3, p4))
	end # let
end # function mul_interval

# ╔═╡ e5b4c935-4536-4c2e-8533-c3ce4ed65d8c
function div_interval(x, y)
	mul_interval(x, make_interval(/(1.0, upper_bound(y)), /(1.0, lower_bound(y))))
end # function div_interval

# ╔═╡ 05ab4088-d2cf-4aa3-b278-8363957ebfc2
car(cons(x, y))

# ╔═╡ e023da46-2a57-4f7f-a0b2-1b5794ae3351
cdr(cons(x, y))

# ╔═╡ a98c8337-fd2a-4994-910f-fac53a747ca3
md"
---
##### 2.1.4.1.5 [Electricity Laws](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance)
###### [Ohms Law](https://en.wikipedia.org/wiki/Ohm%27s_law):
$$I = \frac{V}{R}$$
###### [Resistance](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance)
$$R = \frac{V}{I}=\frac{1}{G}$$
###### [Conductance](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance)
$$G = \frac{I}{V}$$
$$G = \frac{1}{R}$$
"

# ╔═╡ b94c8f0b-3913-4df1-8b95-3686c046cb08
md"
---
##### 2.1.4.1.6 Applications
"

# ╔═╡ 97791387-5729-4db9-9c78-472254505f89
resistor1 = make_interval(-(6.8, *(6.8, 0.1)), +(6.8, *(6.8, 0.1)))

# ╔═╡ 64a475b6-fec7-446a-a622-896a6ee7812b
resistor2 = make_interval(-(4.7, *(4.7, 0.05)), +(4.7, *(4.7, 0.05)))

# ╔═╡ b70aa26c-fe43-49bf-9805-5ccf35298bcd
one = make_interval(1.0, 1.0)

# ╔═╡ c7973a49-d335-43ca-8e78-ef1af595717b
# conductance = 1/resistance
conductor1 = div_interval(one, resistor1) # 1/R_1

# ╔═╡ 17e4dabe-5c07-464a-a691-17a65988ceeb
# conductance = 1/resistance
conductor2 = div_interval(one, resistor2) # 1/R_1

# ╔═╡ 111a692d-8e0f-47b8-8691-761302d1d9cc
# addition of conductivities
conductorP = add_interval(conductor1, conductor2)

# ╔═╡ c21e5469-3249-496d-8621-562b5be13c3f
md"

                            +-----------------------------------+
                            |                                   |
                            |         +---------------+         |
                            |         |               |         |  
                            |     +===+      R1       +===+     |
                            |     |   |               |   |     |
		     	     		|     |   +---------------+   |     |
                            |     |                       |     |
                 ===========+=====+          Rp           +=====+============
                            |     |                       |     |
                            |     |   +---------------+   |     |
                            |     |   |               |   |     |
                            |     +===+      R2       +===+     |
                            |         |               |         |
				 	        |	      +---------------+         |
                            |                                   |
                            +-----------------------------------+
  "

# ╔═╡ 7fb1c3e4-5509-4f11-b11b-3af456277329
md"
###### parallel equivalent resistance $R_p$ of two resistors $R_1$ and $R_2$:

$$R_p =\frac{1}{G_1+G_2} = \frac{1}{\frac{1}{R_1}+\frac{1}{R_2}}$$
"

# ╔═╡ d2af71ed-2a78-4c37-9ee0-a583b17d320f
# resistance = 1/conductance
resistorP = div_interval(one, conductorP) # R_p = 1/(1/R_1 + 1/R_2)

# ╔═╡ 541b2a27-1d20-47cd-9e57-c3872704c2ae
md"
##### 2.1.4.2 Idiomatic *imperative* or *typed* Julia
"

# ╔═╡ 40bc63f2-9779-4e04-88ed-b1f2df579703
md"
##### 2.1.4.3 Interval arithmetic with Julia packages
has to be developed
"

# ╔═╡ a311aed8-f993-4243-b1fd-345d74cd9418
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/31
- **Wikipedia**; Electrical resistance and conductance; [https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance); last visit: 2022/08/31
- **Wikipedia**; Interval arithmetic; [https://en.wikipedia.org/wiki/Interval_arithmetic](https://en.wikipedia.org/wiki/Interval_arithmetic); last visit: 2022/08/31
- **Wikipedia**; Ohm's Law; [https://en.wikipedia.org/wiki/Ohm%27s_law](https://en.wikipedia.org/wiki/Ohm%27s_law); last visit: 2022/08/31
"

# ╔═╡ 7a34a63c-8efb-40aa-9bab-b4a72b5a51e5
md"
---
##### end of ch. 2.1.4
====================================================================================

This is a **draft**. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus@uol.de**

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
# ╟─119d79a0-1615-11ec-321e-43ce3ce01690
# ╟─b60545c5-c9e7-465c-bdfb-43571296e8e4
# ╟─b1a78493-b08b-4e47-bd6b-101bf40f3fac
# ╟─140c8504-a3c1-4ebd-99ad-03a25a73cc3a
# ╟─a1dda7be-f8f1-4c61-9cf5-f2520e8b8012
# ╟─c71a180d-e757-4067-8f46-13c457eb32e5
# ╠═d7e41439-209c-478a-99d4-c53416fd6053
# ╟─512d2fa1-8997-4644-916f-32f7e75528b9
# ╠═b74d46f9-017d-446e-b2b8-a76fc788c1c7
# ╟─9c7807ab-8e20-4976-9c58-b49d94ba9eeb
# ╠═ee15d5a7-b8a0-4087-b188-30f39ef8fe67
# ╟─26b8868c-6284-4992-89b8-31418ce68eee
# ╠═e5b4c935-4536-4c2e-8533-c3ce4ed65d8c
# ╟─fc9a0039-56a4-4543-b679-47a685b2900b
# ╠═e80710bd-7cfd-4d59-8b5d-b24b18619ac1
# ╟─1554e00b-0529-4db0-a4ff-e51a31a4fe8f
# ╠═a20f1e07-81b8-44cf-b36e-496c6020ed04
# ╠═3930b9a1-4c48-4f15-a6d1-4414679b33b9
# ╠═18a92faa-cece-496f-bd09-3533ffc46de7
# ╠═0f94e444-19c6-4bed-bc9d-4b4a3e43b7d5
# ╟─da7125bb-fce0-4758-898c-b15b22033d50
# ╠═e2a99e6d-15b3-484b-b08b-c99675a21b08
# ╠═24605725-f9cc-4962-833b-86c035f9774a
# ╠═e5664b57-2e7a-46cc-99cc-1a2a10ad7c95
# ╠═262468f2-0a6f-49f6-a242-fe1a9ed51e60
# ╠═05ab4088-d2cf-4aa3-b278-8363957ebfc2
# ╠═e023da46-2a57-4f7f-a0b2-1b5794ae3351
# ╟─a98c8337-fd2a-4994-910f-fac53a747ca3
# ╟─b94c8f0b-3913-4df1-8b95-3686c046cb08
# ╠═97791387-5729-4db9-9c78-472254505f89
# ╠═64a475b6-fec7-446a-a622-896a6ee7812b
# ╠═b70aa26c-fe43-49bf-9805-5ccf35298bcd
# ╠═c7973a49-d335-43ca-8e78-ef1af595717b
# ╠═17e4dabe-5c07-464a-a691-17a65988ceeb
# ╠═111a692d-8e0f-47b8-8691-761302d1d9cc
# ╟─c21e5469-3249-496d-8621-562b5be13c3f
# ╟─7fb1c3e4-5509-4f11-b11b-3af456277329
# ╠═d2af71ed-2a78-4c37-9ee0-a583b17d320f
# ╟─541b2a27-1d20-47cd-9e57-c3872704c2ae
# ╟─40bc63f2-9779-4e04-88ed-b1f2df579703
# ╟─a311aed8-f993-4243-b1fd-345d74cd9418
# ╠═7a34a63c-8efb-40aa-9bab-b4a72b5a51e5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
