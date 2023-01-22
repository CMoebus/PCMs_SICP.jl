### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 88823b36-0880-436d-9b89-627cc8a444b2
using Random

# ╔═╡ 01038920-9a55-11ed-3235-5f0b343b83be
md"
====================================================================================
#### SICP: [3.1.2.2 Monte Carlo II](https://uol.de/en/lcs/probabilistic-programming/webchurch-and-openbugs/pi-by-monte-carlo-simulation)
##### file: PCM20230122\_SICP\_3.1.2.2\_MonteCarlo\_II.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/22 ***

====================================================================================
"


# ╔═╡ a7d207c2-ae5d-44a8-95f4-44803c352c03
Random.seed!(1234)

# ╔═╡ e7030dce-9ea2-4a8a-b905-90050951e013
rand()

# ╔═╡ 34ae0113-daef-44fc-980f-b090733a89e5
rand()

# ╔═╡ 245d424c-7eaf-40f5-9563-bde745840d51
md"
###### Area of circle is $$A = r^2 \pi$$ and of *unit* circle $$A = \pi$$
"

# ╔═╡ c04dea82-58e1-497c-a69b-ca3b9877ca38
function insideQuarterOfUnitCircle()
	let x = rand()
		y = rand()
		sqrt(x^2 + y^2) <= 1.0
	end # let
end # function insideQuarterOfUnitCircle

# ╔═╡ cd738883-199d-4dad-94c7-308755691575
[insideQuarterOfUnitCircle() for _ in 1:10]

# ╔═╡ 42bf84d5-1a34-42e7-98b8-6c49995c8bda
function monteCarlo2(nTrials, experiment) 
	let nTrialsPassed = 0
		for j in 1:nTrials
			if experiment()
				nTrialsPassed += 1
			end # 
		end # for
		nTrialsPassed / nTrials
	end # let
end # function monteCarlo2

# ╔═╡ c24f1e16-5b1b-44c0-bb34-0854f5ee313f
function estimatePi(nTrials)
	monteCarlo2(nTrials, insideQuarterOfUnitCircle) * 4
end # function estimatePi

# ╔═╡ 190dbf14-d6a7-48f1-8a59-de11d08d8a23
estimatePi(1E1)

# ╔═╡ 1af85fe5-8e56-4c9b-8bae-2095635ebe1b
estimatePi(1E2)

# ╔═╡ fac4f109-179e-4c07-a9cc-13c1b95811b8
estimatePi(1E3)

# ╔═╡ 20c3cd6b-430a-4a14-9bac-89608accb0ac
estimatePi(1E7)

# ╔═╡ 63ad5e75-82b6-4f80-a57f-f9d2ddaa0abf
isapprox(estimatePi(1E7), π; atol=1E-3)

# ╔═╡ 10826b8e-98a1-4333-83c8-7541f96c25fc
isapprox(estimatePi(1E8), π; atol=1E-4)

# ╔═╡ 3fcd61d7-f75e-40e2-9bdb-117ae66c75a3
estimatePi(1E9)

# ╔═╡ 29283b05-d43b-4d96-bf91-02600d174fc6
isapprox(estimatePi(1E9), π; atol=1E-4)

# ╔═╡ 9c4b9459-7a08-4f86-8694-7944d9e10f48
isapprox(estimatePi(1E9), π; atol=1E-5)

# ╔═╡ 902f5f0a-8246-4d33-9a46-349caf007e19
md"
---
##### end of ch. 3.1.2.2
"

# ╔═╡ 24b8ac07-f499-4895-95f7-a0dd9ed77b83
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "fa3e19418881bf344f5796e1504923a7c80ab1ed"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
"""

# ╔═╡ Cell order:
# ╟─01038920-9a55-11ed-3235-5f0b343b83be
# ╠═88823b36-0880-436d-9b89-627cc8a444b2
# ╠═a7d207c2-ae5d-44a8-95f4-44803c352c03
# ╠═e7030dce-9ea2-4a8a-b905-90050951e013
# ╠═34ae0113-daef-44fc-980f-b090733a89e5
# ╟─245d424c-7eaf-40f5-9563-bde745840d51
# ╠═c04dea82-58e1-497c-a69b-ca3b9877ca38
# ╠═cd738883-199d-4dad-94c7-308755691575
# ╠═c24f1e16-5b1b-44c0-bb34-0854f5ee313f
# ╠═42bf84d5-1a34-42e7-98b8-6c49995c8bda
# ╠═190dbf14-d6a7-48f1-8a59-de11d08d8a23
# ╠═1af85fe5-8e56-4c9b-8bae-2095635ebe1b
# ╠═fac4f109-179e-4c07-a9cc-13c1b95811b8
# ╠═20c3cd6b-430a-4a14-9bac-89608accb0ac
# ╠═63ad5e75-82b6-4f80-a57f-f9d2ddaa0abf
# ╠═10826b8e-98a1-4333-83c8-7541f96c25fc
# ╠═3fcd61d7-f75e-40e2-9bdb-117ae66c75a3
# ╠═29283b05-d43b-4d96-bf91-02600d174fc6
# ╠═9c4b9459-7a08-4f86-8694-7944d9e10f48
# ╟─902f5f0a-8246-4d33-9a46-349caf007e19
# ╟─24b8ac07-f499-4895-95f7-a0dd9ed77b83
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
