### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 99d40f7b-ab0d-45d4-b3f4-c441843dd6f5
using Polynomials

# ╔═╡ 6cf0f630-8f75-11ed-1020-ebc10159a4f3
md"
=====================================================================================
#### SICP: [2.5.5 Extended exercise: Rational functions](https://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5_002e3)
##### file: PCM20230108\_SICP\_2.5.5\_ExtendedExerciseRationalFunctions.jl
##### Julia/Pluto.jl-code: (1.8.3/0.19.14) by PCM *** 2023/01/09 ***
=====================================================================================
"

# ╔═╡ cd01bfc9-aceb-44f5-a4b2-5a01d9bd5896
md"
#####  Specification of example (SICP, 1996, ch. 2.5.3, p.212) :

$$\frac{x+1}{x^3-1}+\frac{x}{x^2-1}=\frac{x^3+2x^2+3x+1}{x^4+x^3-x-1}$$
"

# ╔═╡ 3cb658de-49a1-4ab8-91b6-4c3cf1bac385
md"
---
##### idiomatic Julia
"

# ╔═╡ b1abb738-c35c-49c4-b366-fe3dc08f6494
poly1Numerator = Polynomial([1, 1]) 

# ╔═╡ 3f0fc07b-1584-405f-b0a8-7e830598dc52
poly1Denominator = Polynomial([-1, 0, 0, 1]) 

# ╔═╡ 2a1dfaa7-7c7d-4387-8f52-135024606363
poly1Q = RationalFunction(poly1Numerator, poly1Denominator)

# ╔═╡ 38bc2daa-a053-409c-aa78-88f41c706c59
lowest_terms(poly1Q)

# ╔═╡ b8810cf5-53e1-42b1-a24d-ec5ef7e40a8d
poly1Q == lowest_terms(poly1Q)                          # true !

# ╔═╡ d904fef9-ff9f-4587-bf55-17a538aac0fa
poly2Numerator = Polynomial([0, 1]) 

# ╔═╡ c808f32b-8f84-4142-b29d-44a63f670998
poly2Denominator = Polynomial([-1, 0, 1]) 

# ╔═╡ e80fb7e0-c286-4911-8623-5d0148c1ae9c
poly2Q = RationalFunction(poly2Numerator, poly2Denominator)

# ╔═╡ 1688adb9-116e-44b1-9448-a1cd0a38e8f7
lowest_terms(poly2Q)

# ╔═╡ 0ebaa277-6885-454d-963a-cc8fb9acf3c9
poly2Q == lowest_terms(poly2Q)                          # true !

# ╔═╡ c69ee5ce-e1c9-4d48-857c-7afee0786d9d
sumPolyQ = poly1Q + poly2Q

# ╔═╡ 36896360-bb39-48fb-99a1-f49ca58cfaa5
lowest_terms(sumPolyQ) 

# ╔═╡ d968258a-802d-41ad-b139-246d42ce5812
md"
##### end of ch. 2.5.5
---
"

# ╔═╡ fa060de3-1197-4871-a1f7-fb473bb92084
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"

[compat]
Polynomials = "~3.2.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "60d0d725dc39794be1573bd448ee4da513d66bf9"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "6ea39b2399c92b83036ef26d8bab9cd017b9a8c4"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.1"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╟─6cf0f630-8f75-11ed-1020-ebc10159a4f3
# ╟─cd01bfc9-aceb-44f5-a4b2-5a01d9bd5896
# ╟─3cb658de-49a1-4ab8-91b6-4c3cf1bac385
# ╠═99d40f7b-ab0d-45d4-b3f4-c441843dd6f5
# ╠═b1abb738-c35c-49c4-b366-fe3dc08f6494
# ╠═3f0fc07b-1584-405f-b0a8-7e830598dc52
# ╠═2a1dfaa7-7c7d-4387-8f52-135024606363
# ╠═38bc2daa-a053-409c-aa78-88f41c706c59
# ╠═b8810cf5-53e1-42b1-a24d-ec5ef7e40a8d
# ╠═d904fef9-ff9f-4587-bf55-17a538aac0fa
# ╠═c808f32b-8f84-4142-b29d-44a63f670998
# ╠═e80fb7e0-c286-4911-8623-5d0148c1ae9c
# ╠═1688adb9-116e-44b1-9448-a1cd0a38e8f7
# ╠═0ebaa277-6885-454d-963a-cc8fb9acf3c9
# ╠═c69ee5ce-e1c9-4d48-857c-7afee0786d9d
# ╠═36896360-bb39-48fb-99a1-f49ca58cfaa5
# ╟─d968258a-802d-41ad-b139-246d42ce5812
# ╟─fa060de3-1197-4871-a1f7-fb473bb92084
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
