### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 748d5b90-b040-11ed-0d1b-f962ab37133b
md"
====================================================================================
#### SICP: 3.3.1 [Mutable List Structure](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1)
##### file: PCM20230219\_SICP\_3.3.1\_MutableListStructure.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/21 ***

====================================================================================
"

# ╔═╡ 1b26224f-e39b-4576-aef3-8c2ca50e3c2c
md"
###### Constructor
"

# ╔═╡ bd62ca5c-23d3-4a1f-844d-7280a79aadf8
mutable struct Cons
	car
	cdr
end # struct Cons

# ╔═╡ 73db0581-5f6a-41de-9740-4f143fc5826c
cons(car, cdr) = Cons(car, cdr)

# ╔═╡ 16a5a470-3cb4-4a86-947d-2bb82ebd1f2d
md"
###### Selectors
"

# ╔═╡ 8ba44863-2554-4e62-916d-0a4f1691d67b
car(cons::Cons) = cons.car

# ╔═╡ 7178c3ce-411a-44d4-9d19-948fa0f87c84
cdr(cons::Cons) = cons.cdr

# ╔═╡ 64a572cf-a84c-4730-b1e3-96a592df7db0
md"
###### Modifier
"

# ╔═╡ 017e8090-9c40-4dba-a851-1cc939f79b85
function setCar!(cons::Cons, car) 
	cons.car = car
	cons
end # setCar!

# ╔═╡ 571a9137-1eeb-4c01-af51-27d11ca4c503
function setCdr!(cons::Cons, cdr) 
	cons.cdr = cdr
	cons
end # setCdr!

# ╔═╡ 963528f4-2b12-4a92-9a0f-f80d0679265c
md"
---
###### Equivalent to Scheme-list $x:= ((a\;b)\;c\;d)$
(cf. [**Fig. 3.12**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ c8c8e0c8-3885-4e1e-b36d-4c586ce25156
x0 = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))

# ╔═╡ 87e67458-9389-4309-9237-03531362decf
md"
---
###### Equivalent to Scheme-list $y:= (e\;f)$
(cf. [**Fig. 3.12**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ ec9733b7-4d40-4377-b93e-7678cd94db83
y0 = cons(:e, cons(:f, :nil))

# ╔═╡ b03a3591-63d9-44e2-a3c8-38fa8eb164d3
md"
---
###### Equivalent to effect of Scheme-application $xMod := (set\text{-}car! \; x \; y)$ 

Scheme-list: $xMod := ((e\;f)\;(c\;d))\text{ and } y := (e\;f)$

equivalent to Julia's structure: $xMod := cons(cons(e,cons(f,:nil)), cons(c,cons(d,:nil))$

The Scheme-list fragment $(a\;b)$ equivalent to Julia's $cons(:a, cons(:b, :nil))$ is now garbage.
(cf. [**Fig. 3.13**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ d408189b-3825-4964-8b67-565d3d50da35
let 
	x1 = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y1 = cons(:e, cons(:f, :nil))
	xMod = setCar!(x1, y1)
end # let

# ╔═╡ 8f5ff5b0-350b-4c91-b4c4-f6d6193f4698
x0   #  is not modified 

# ╔═╡ 0c83ec3f-84b4-46f5-97f6-e381fc6092af
y0   # is not modified 

# ╔═╡ c7f5e87b-7363-4ecf-b7fe-874d1eec7fda
md"
---
###### Effect of $z = cons(y, cdr(x))$:

Scheme-list 

$z := ((e\;f)\;(c\;d))$

equivalent Julia-'list'

$z = cons(cons(e,cons(f,:nil)), cons(cons(c,cons(d,:nil))))$

(cf. [**Fig. 3.14**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ c2a6b312-c578-4dc2-8493-549a1b364646
x0

# ╔═╡ 43ef4a5d-bf04-450b-9a18-9eeffdb142ad
y0

# ╔═╡ 9046e78e-645c-4f78-9a8d-6b736316193b
z = cons(y0, cdr(x0))

# ╔═╡ 5b03f41b-7833-4001-ba61-7f26b0b10bc3
md"
---
###### Effect of $xMod2 = setCdr!(x, y)$:

Scheme-list 

$xMod2 := ((a\;b)\;(e\;f))$

equivalent Julia-'list'

$z = cons(cons(e,cons(f,:nil)), cons(cons(c,cons(d,:nil))))$

(cf. [**Fig. 3.15**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ 9f41e621-ab36-47aa-8da9-8a61a43f158e
let
	x2 = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y2 = cons(:e, cons(:f, :nil))
	xMod2 = setCdr!(x2, y2), y2
end # let

# ╔═╡ c8d27bd2-fe57-44f5-89b8-1df77ccad610
md"
---
##### Identity and Sharing
"

# ╔═╡ 3f94dfb1-7898-4b43-9a63-24c8e3aefdde
# taken from ch. 2.2.1
list(elements...) = 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], list(elements[2:end]...))
	end #if

# ╔═╡ e5bb0a44-3cba-401e-a43d-5de6b7495369
md"
---
###### *Sharing* of individual pairs among *different* data objects
(cf. [**Fig. 3.16**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ 5c6aea1f-1102-403e-9b2f-ed3c6581abfe
x3 = list(:a, :b)

# ╔═╡ 254a626b-dcc0-4d55-870a-be8b25f1d642
md"
###### Scheme-list $z1 := ((a\;b)\;a\;b)$
"

# ╔═╡ 1366b525-b6d6-48ca-ae29-7967bf41e85b
z1 = cons(x3, x3)

# ╔═╡ cc213f56-5a0b-414d-8e39-de0b1085e254
z1.car == z1.cdr   # ==> true             # shared !

# ╔═╡ 42d35aa7-8958-43b1-b70e-80a388ac5e62
md"
---
###### *Sharing* of individual symbols among *different* pairs
(cf. [**Fig. 3.17**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ 68759b9d-e392-40f6-b5b8-eccba62d7331
md"
###### Scheme-list $z2 := ((a\;b)\;a\;b)$
"

# ╔═╡ 96450d2f-1e96-4ad8-b86b-d8e251a7cdbe
z2 = cons(list(:a, :b), list(:a, :b))

# ╔═╡ d3f91061-107e-4577-8183-5a4aa4821516
z2.car == z2.cdr                   # ==> false     # different pairs

# ╔═╡ 9b807199-c72a-41e2-a75e-0e919f2fb4bf
z2.car.car     == z2.cdr.car       # ==> true      # identical symbol ':a'

# ╔═╡ e46490ac-3c85-4f46-82a1-dbdb856b56a4
z2.car.cdr.car == z2.cdr.cdr.car   # ==> true      # identical symbol ':b'

# ╔═╡ f49f88ff-b434-479e-ad0a-0b1009c09d7f
md"
---
###### $setToWow!$
"

# ╔═╡ 7d08280b-db84-480f-9a22-99724d08e66a
function setToWow!(x)
	setCar!(car(x), :wow)
	x
end # function setToWow!

# ╔═╡ 7dae5653-87f3-4961-aa15-14608dde8eea
md"
###### Scheme-list $z3 := ((wow\;b)\;wow\;b)$
*after* applying $setToWow!$ to $z1 := ((a\;b)\;a\;b)$
"

# ╔═╡ 4be523be-d512-4ee9-abf8-1b764bf7aba5
z3 = setToWow!(z1)

# ╔═╡ 998883e7-6f83-47f2-a91f-4678ec2dd950
md"
###### Scheme-list $z4 := ((wow\;b)\;a\;b)$
*after* applying $setToWow!$ to $z2 := ((a\;b)\;a\;b)$
"

# ╔═╡ 095473d1-c4db-44c0-8159-f5cc04bcf801
z4 = setToWow!(z2)

# ╔═╡ f24a3af4-a34e-4d44-96c8-13654e5c2db8
md"
---
##### end of ch. 3.3.1
"

# ╔═╡ 56d08cbd-8a11-4c07-98c3-6c5f83704c3b
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─748d5b90-b040-11ed-0d1b-f962ab37133b
# ╟─1b26224f-e39b-4576-aef3-8c2ca50e3c2c
# ╠═bd62ca5c-23d3-4a1f-844d-7280a79aadf8
# ╠═73db0581-5f6a-41de-9740-4f143fc5826c
# ╟─16a5a470-3cb4-4a86-947d-2bb82ebd1f2d
# ╠═8ba44863-2554-4e62-916d-0a4f1691d67b
# ╠═7178c3ce-411a-44d4-9d19-948fa0f87c84
# ╟─64a572cf-a84c-4730-b1e3-96a592df7db0
# ╠═017e8090-9c40-4dba-a851-1cc939f79b85
# ╠═571a9137-1eeb-4c01-af51-27d11ca4c503
# ╟─963528f4-2b12-4a92-9a0f-f80d0679265c
# ╠═c8c8e0c8-3885-4e1e-b36d-4c586ce25156
# ╟─87e67458-9389-4309-9237-03531362decf
# ╠═ec9733b7-4d40-4377-b93e-7678cd94db83
# ╟─b03a3591-63d9-44e2-a3c8-38fa8eb164d3
# ╠═d408189b-3825-4964-8b67-565d3d50da35
# ╠═8f5ff5b0-350b-4c91-b4c4-f6d6193f4698
# ╠═0c83ec3f-84b4-46f5-97f6-e381fc6092af
# ╟─c7f5e87b-7363-4ecf-b7fe-874d1eec7fda
# ╠═c2a6b312-c578-4dc2-8493-549a1b364646
# ╠═43ef4a5d-bf04-450b-9a18-9eeffdb142ad
# ╠═9046e78e-645c-4f78-9a8d-6b736316193b
# ╟─5b03f41b-7833-4001-ba61-7f26b0b10bc3
# ╠═9f41e621-ab36-47aa-8da9-8a61a43f158e
# ╟─c8d27bd2-fe57-44f5-89b8-1df77ccad610
# ╠═3f94dfb1-7898-4b43-9a63-24c8e3aefdde
# ╟─e5bb0a44-3cba-401e-a43d-5de6b7495369
# ╠═5c6aea1f-1102-403e-9b2f-ed3c6581abfe
# ╟─254a626b-dcc0-4d55-870a-be8b25f1d642
# ╠═1366b525-b6d6-48ca-ae29-7967bf41e85b
# ╠═cc213f56-5a0b-414d-8e39-de0b1085e254
# ╟─42d35aa7-8958-43b1-b70e-80a388ac5e62
# ╟─68759b9d-e392-40f6-b5b8-eccba62d7331
# ╠═96450d2f-1e96-4ad8-b86b-d8e251a7cdbe
# ╠═d3f91061-107e-4577-8183-5a4aa4821516
# ╠═9b807199-c72a-41e2-a75e-0e919f2fb4bf
# ╠═e46490ac-3c85-4f46-82a1-dbdb856b56a4
# ╟─f49f88ff-b434-479e-ad0a-0b1009c09d7f
# ╠═7d08280b-db84-480f-9a22-99724d08e66a
# ╟─7dae5653-87f3-4961-aa15-14608dde8eea
# ╠═4be523be-d512-4ee9-abf8-1b764bf7aba5
# ╟─998883e7-6f83-47f2-a91f-4678ec2dd950
# ╠═095473d1-c4db-44c0-8159-f5cc04bcf801
# ╟─f24a3af4-a34e-4d44-96c8-13654e5c2db8
# ╟─56d08cbd-8a11-4c07-98c3-6c5f83704c3b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
