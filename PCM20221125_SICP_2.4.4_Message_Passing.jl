### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 52675be0-6cd6-11ed-2a19-dbb4acf40dc0
md"
=====================================================================================
#### SICP: 2.4.4 [Message_Passing](https://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4_002e3)
##### file: PCM20221125\_SICP\_2.4.4\_Message\_Passing.jl
##### code: Julia/Pluto.jl (1.8.2/0.19.14) by PCM *** 2022/11/27 ***

=====================================================================================
"

# ╔═╡ e2015d29-af47-402f-9a31-2d35b1342d1f
md"
$$\begin{array}{|l|c|cc|}
\hline                                                           
              & \text{Dispatch} &               &                 \\
              & \text{on}     & \;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\text{Types}   \\
           &\text{operations} & (:rectangular)  & (:polar)        \\ 
\hline                                                                        
              &               &                 &                 \\
              & realPart      & realPartOfZ     & realPartOfZ     \\
\text{Opera-} & imagPart      & imagPartOfZ     & imagPartOfZ     \\
\text{ tions} & magnitude     & magnitudeOfZ    & magnitudeOfZ    \\
              & angle         & angleOfZ        & angleOfZ        \\
              &               &                 &                 \\
\hline                                                           
              & \text{Dispatch} &               &                 \\
              & \text{on}     & \;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\text{Types}   \\             
           &\text{operations} & (:rectangular, :rectangular) & (:polar, :polar) \\ 
\hline
               &              &                 &                 \\
               & addComplex   & addComplexZs    & addComplexZs    \\
\text{Opera-}  & subComplex   & subComplexZs    & subComplexZs    \\
\text{ tions}               & mulComplex   & mulComplexZs    & mulComplexZs    \\
               & divComplex   & divComplexZs    & divComplexZs    \\
               &              &                 &                 \\
\hline

\end{array}$$

**Fig. 2.4.4.1** *Table* of operations for the complex-number system (cf. SICP, 1996, Fig. 2.22 or [here](https://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002 e4_002e3)): '...each type takes care of its own dispatching on operations...'(SICP, 1996, p186)

---
"

# ╔═╡ 9ab97503-e7f9-45a1-9e54-3c82240cee63
md"
###### *constructor* of complex number *object* with *rectangular type*
"

# ╔═╡ dc3be1ec-fe69-44e5-81e6-f1e495cc7e7f
function makeZRectFromRealImag(x, y)       # SICP, 1996, p.186
	#---------------------------------------------------------
	# local methods
	realPartOfZ(x, y)    = x
	imagPartOfZ(x, y)    = y
	magnitudeOfZ(x, y)   = √(x^2 + y^2)
	angleOfZ(x, y)       = atan(y/x)
	addComplexZs(x1, y1) = 
		(x2, y2) -> (x1 + x2, y1 + y2)
	subComplexZs(x1, y1) = 
		(x2, y2) -> (x1 - x2, y1 - y2)
	mulComplexZs(x1, y1) = 
		(x2, y2) -> (x1*x2 - y1*y2, x1*y2 + x2*y1)
	divComplexZs(x1, y1) = 
		(x2, y2) -> 
		let magSquare = magnitudeOfZ(x2, y2)^2
			((x1*x2 + y1*y2)/magSquare, (x2*y1 - x1*y2)/magSquare)
		end # let
	error(message)       = message
	#---------------------------------------------------------
	# dispatch on opMessages
	function dispatch(opMessage)
		(opMessage == :realPartOfZ)  ? realPartOfZ(x, y)  :
		(opMessage == :imagPartOfZ)  ? imagPartOfZ(x, y)  :
		(opMessage == :magnitudeOfZ) ? magnitudeOfZ(x, y) :
		(opMessage == :angleOfZ)     ? angleOfZ(x, y)     :
		(opMessage == :addComplexZs) ? addComplexZs(x, y) :
		(opMessage == :subComplexZs) ? subComplexZs(x, y) :
		(opMessage == :mulComplexZs) ? mulComplexZs(x, y) :
		(opMessage == :divComplexZs) ? divComplexZs(x, y) :
		"error 'unknown opMessage -- MAKE_Z_RECT_FROM_REAL_IMAG', $opMessage"
	end # function dispatch
	#---------------------------------------------------------
	dispatch
end # function makeZRectFromRealImag

# ╔═╡ 8d1ce517-11cc-41bb-a6da-94d2a9edab42
function applyGeneric(opMessage, arg)
	arg(opMessage)
end # function applyGeneric

# ╔═╡ c97d985d-e934-4961-90d5-585a955e21e8
md"
---
###### *make* object of *type rectangular*
"

# ╔═╡ 2086925f-2220-44a5-9c59-49ba5dbea5cf
z1 = makeZRectFromRealImag(2, 1)

# ╔═╡ 765dc0e0-9ded-435f-a219-fd2f6124d953
z1

# ╔═╡ 07984268-2457-4762-bcab-3b8ae16892d4
md"
---
###### *send* operation messages $$opMessage$$
"

# ╔═╡ 50125707-ea30-48ac-b017-3533de89d8de
md"
###### message $$:realPartOfZ$$
"

# ╔═╡ 1e014a5d-a2e0-4d08-a34d-17085bbc9a37
z1(:realPartOfZ)

# ╔═╡ f4d9f434-e7c5-44e7-a890-ff4dd64ebd9b
 realPart(z) = applyGeneric(:realPartOfZ, z)  # function definition realPart(z)

# ╔═╡ 51fa6167-5e71-487e-9acc-880b4989ed54
realPart(z1)

# ╔═╡ 526f23af-5ef8-49bb-bf49-1ade9dd33d61
md"
###### message $$:imagPartOfZ$$
"

# ╔═╡ 4a207478-cd34-4854-8314-b774b45301fc
z1(:imagPartOfZ)

# ╔═╡ 5a896179-0722-4836-9b3b-f01a00589094
 imagPart(z) = applyGeneric(:imagPartOfZ, z)  # function definition imagPart(z)

# ╔═╡ f4b97f49-2016-40a0-86a3-89eda45ba2c7
md"
###### message $$:magnitudeOfZ$$
"

# ╔═╡ 4a3715d1-ffdd-43e5-a5f0-31690f592c76
z1(:magnitudeOfZ)

# ╔═╡ 78ed23da-5b80-43e3-b1e8-1aac7c23cb1a
magnitude(z) = applyGeneric(:magnitudeOfZ, z) # function definition magnitude(z)

# ╔═╡ edb3b5c1-8e43-4301-b5d8-08cb79049aa7
magnitude(z1)

# ╔═╡ 84c960e5-f07e-4ad7-8c08-c1983ef3fbda
z1(:magnitudeOfZ)^2

# ╔═╡ d0a3ae1e-06a6-4023-8f66-bde5f84bbf0c
applyGeneric(:magnitudeOfZ, z1)^2

# ╔═╡ f90f87ef-92d0-4594-84ba-c031a5103387
magnitude(z1)^2

# ╔═╡ 598030df-3703-4032-a09a-16a80359637c
md"
###### message $$:angleOfZ$$
"

# ╔═╡ 40c6a19a-de99-4fb2-a555-85de8071133f
z1(:angleOfZ)

# ╔═╡ a2bacbd1-b832-4c91-b497-7e1a11690f14
angle(z) = applyGeneric(:angleOfZ, z)    # function definition angle(z)

# ╔═╡ 6b8c2207-f583-4bbe-8daa-1ec9ad735b9a
angle(z1)

# ╔═╡ 097b99fc-b9df-459d-ad20-a64d50dd9a18
md"
###### message $$:addComplexZs$$
"

# ╔═╡ f144d793-77f4-4ca7-8af7-5d5420ef7382
z1(:addComplexZs)(3, 2)      # (2 + 1i) + (3 + 2i) ==> (5 + 3i)

# ╔═╡ c82a6c28-f18a-45a7-9fd1-b57ae643e8f3
addComplex(z) = applyGeneric(:addComplexZs, z) # function definition addComplex(z)

# ╔═╡ adf6e315-b518-45a2-9632-6cd2c5c5c0ab
addComplex(z1)(3, 2)

# ╔═╡ 5295ac94-371a-4138-be30-3fafd2143d70
md"
###### message $$:subComplexZs$$
"

# ╔═╡ 8f79f46b-ced9-4b3b-bba4-d92a2d46b1b0
z1(:subComplexZs)(3, 2)     # (2 + 1i) - (3 + 2i) ==> (-1 - 1i)

# ╔═╡ 226fbbd4-770c-4536-ad73-61141b626981
subComplex(z) = applyGeneric(:subComplexZs, z) # function definition subComplex(z)

# ╔═╡ 37018723-f326-47e9-b071-74f91abaa0f0
subComplex(z1)(3, 2)

# ╔═╡ 2148a618-e6fc-4a1b-b9a4-a04becf37d65
md"
###### message $$:mulComplexZs$$
"

# ╔═╡ e18b47bd-7eb3-4fa7-975e-80a2cfe0103d
mulComplex(z) = applyGeneric(:mulComplexZs, z) # function definition mulComplex(z)

# ╔═╡ d0507eee-6317-41d9-9549-acc7c9d20798
let z2 = makeZRectFromRealImag(2, -1)
	z2(:mulComplexZs)(2, 2) # (2 -1i)(2 + 2i) = (4 + 2)+(4i - 2i) = 6 + 2i
end # let

# ╔═╡ 6ab63855-87a5-4630-a164-a45d1ee98cea
let z2 = makeZRectFromRealImag(2, -1)
	mulComplex(z2)(2, 2)
end # let

# ╔═╡ f6d919f1-4dfe-4eaf-a91a-f3979126d367
md"
###### message $$:divComplexZs$$
"

# ╔═╡ b501d8c7-df6b-41ad-b56f-5e64d7289fba
divComplex(z) = applyGeneric(:divComplexZs, z) # function definition divComplex(z)

# ╔═╡ f9fc84bd-a62d-48ff-94f1-f181aafdb831
let
	z3 = makeZRectFromRealImag(3, -1)
	# (3 -1i)/(1 + 2i) = (3-1i)(1-2i)/(1+2i)(1-2i) = ((3-2)+(-1i-6i))/5 = 1/5 - 7/5i
	z3(:divComplexZs)(1, 2)          # = 1/5 - 7/5i = 0.2 - 1.4
end # let

# ╔═╡ c795a817-84b6-4e09-979c-aecf0b23dd9c
let
	z3 = makeZRectFromRealImag(3, -1)
	# (3 -1i)/(1 + 2i) = (3-1i)(1-2i)/(1+2i)(1-2i) = ((3-2)+(-1i-6i))/5 = 1/5 - 7/5i
	divComplex(z3)(1, 2)           # = 1/5 - 7/5i = 0.2 - 1.4
end # let

# ╔═╡ 989a4b2f-1c88-420b-9a94-ff232f383a92
md"
---

##### end of ch. 1.1.1

---

"

# ╔═╡ 7486616c-bf26-44cb-8a1a-3fa3ea521809
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

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─52675be0-6cd6-11ed-2a19-dbb4acf40dc0
# ╟─e2015d29-af47-402f-9a31-2d35b1342d1f
# ╟─9ab97503-e7f9-45a1-9e54-3c82240cee63
# ╠═dc3be1ec-fe69-44e5-81e6-f1e495cc7e7f
# ╠═8d1ce517-11cc-41bb-a6da-94d2a9edab42
# ╟─c97d985d-e934-4961-90d5-585a955e21e8
# ╠═2086925f-2220-44a5-9c59-49ba5dbea5cf
# ╠═765dc0e0-9ded-435f-a219-fd2f6124d953
# ╟─07984268-2457-4762-bcab-3b8ae16892d4
# ╟─50125707-ea30-48ac-b017-3533de89d8de
# ╠═1e014a5d-a2e0-4d08-a34d-17085bbc9a37
# ╠═f4d9f434-e7c5-44e7-a890-ff4dd64ebd9b
# ╠═51fa6167-5e71-487e-9acc-880b4989ed54
# ╟─526f23af-5ef8-49bb-bf49-1ade9dd33d61
# ╠═4a207478-cd34-4854-8314-b774b45301fc
# ╠═5a896179-0722-4836-9b3b-f01a00589094
# ╟─f4b97f49-2016-40a0-86a3-89eda45ba2c7
# ╠═4a3715d1-ffdd-43e5-a5f0-31690f592c76
# ╠═78ed23da-5b80-43e3-b1e8-1aac7c23cb1a
# ╠═edb3b5c1-8e43-4301-b5d8-08cb79049aa7
# ╠═84c960e5-f07e-4ad7-8c08-c1983ef3fbda
# ╠═d0a3ae1e-06a6-4023-8f66-bde5f84bbf0c
# ╠═f90f87ef-92d0-4594-84ba-c031a5103387
# ╟─598030df-3703-4032-a09a-16a80359637c
# ╠═40c6a19a-de99-4fb2-a555-85de8071133f
# ╠═a2bacbd1-b832-4c91-b497-7e1a11690f14
# ╠═6b8c2207-f583-4bbe-8daa-1ec9ad735b9a
# ╟─097b99fc-b9df-459d-ad20-a64d50dd9a18
# ╠═f144d793-77f4-4ca7-8af7-5d5420ef7382
# ╠═c82a6c28-f18a-45a7-9fd1-b57ae643e8f3
# ╠═adf6e315-b518-45a2-9632-6cd2c5c5c0ab
# ╟─5295ac94-371a-4138-be30-3fafd2143d70
# ╠═8f79f46b-ced9-4b3b-bba4-d92a2d46b1b0
# ╠═226fbbd4-770c-4536-ad73-61141b626981
# ╠═37018723-f326-47e9-b071-74f91abaa0f0
# ╟─2148a618-e6fc-4a1b-b9a4-a04becf37d65
# ╠═e18b47bd-7eb3-4fa7-975e-80a2cfe0103d
# ╠═d0507eee-6317-41d9-9549-acc7c9d20798
# ╠═6ab63855-87a5-4630-a164-a45d1ee98cea
# ╟─f6d919f1-4dfe-4eaf-a91a-f3979126d367
# ╠═b501d8c7-df6b-41ad-b56f-5e64d7289fba
# ╠═f9fc84bd-a62d-48ff-94f1-f181aafdb831
# ╠═c795a817-84b6-4e09-979c-aecf0b23dd9c
# ╟─989a4b2f-1c88-420b-9a94-ff232f383a92
# ╟─7486616c-bf26-44cb-8a1a-3fa3ea521809
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
