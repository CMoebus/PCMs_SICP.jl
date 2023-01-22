### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ aba250e9-7189-4daf-8e50-0266f74f7c96
using Random

# ╔═╡ 10c2df10-99aa-11ed-2a51-69f641cea4fb
md"
====================================================================================
#### SICP: [3.1.2.1 Monte Carlo I](https://sarabander.github.io/sicp/html/3_002e1.xhtml#g_t3_002e1_002e2)
##### file: PCM20230121\_SICP\_3.1.2.1\_MonteCarlo\_I.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/22 ***

====================================================================================


"

# ╔═╡ a45bb0f2-3ef4-44c2-927c-dd626a577fd6
md"
##### Estimating $$\pi$$ by Monte-Carlo 

Dirichlet (1849) stated *If u and v are integers chosen at random, the probability that* $$gcd(u,v) = 1$$ *is* $$\frac{6}{\pi^2} \approx 0.60793$$ (Knuth, 1998, ch.4.5.2, p.342; p.354, ex.10).
"

# ╔═╡ c5cf1712-bb28-4a90-bdde-b5920384d80e
crit = 6/π^2

# ╔═╡ c5e79d67-8266-4ec6-951c-9f43e277370d
Random.seed!(1234)

# ╔═╡ cc5711d6-cd67-47c9-abca-da01b2d10991
rand(Int)

# ╔═╡ 9924e9d3-bcdb-4743-a530-f2f1d80b9eb2
rand(Int)

# ╔═╡ 4d4035d0-c234-4643-a03f-1867450991aa
function piError(nTrials) 
	let experiment() = gcd(rand(Int), rand(Int)) == 1
		expOutcomes  = [experiment() for i in 1:nTrials]
		successes    = filter(boolval -> boolval == true, expOutcomes)
		abs(crit - length(successes) / nTrials)
	end # let
end # function piError

# ╔═╡ cf308e67-c82b-4036-b00b-95d4b097a8cb
piError(1E3)

# ╔═╡ e4b12c43-752e-4476-b4f5-35d8bb24fc39
piError(1E7)

# ╔═╡ 7e9b5455-d069-4212-9de6-1d48fb886b2f
md"
##### 3.1.2.1.1 *Scheme*-like Julia
"

# ╔═╡ 4ebdd843-ea90-4248-afb4-0a5f525f2cdb
function cesaroTest()
	==( gcd( rand(Int), rand(Int)), 1)
end # function cesaroTest

# ╔═╡ 18f1701e-b0e4-4be1-885b-ea5cbbfbf8ae
cesaroTest

# ╔═╡ 2b9a680f-b77e-4818-9013-e1ff5a360440
cesaroTest()

# ╔═╡ add99d5e-d88d-4fd1-9070-1309ebacd5c5
# not very useful because Julia is contrary to Scheme not tco
# this leads to stack overflow
function monteCarlo(nTrials, experiment)
	function iter(nTrialsRemaining, nTrialsPassed)
		==(nTrialsRemaining, 0) ? /(nTrialsPassed, nTrials) :
		experiment() ? iter( -(nTrialsRemaining, 1), +(nTrialsPassed, 1)) :
		iter( -(nTrialsRemaining, 1), nTrialsPassed)
	end # function iter
	iter(nTrials, 0)
end # function monteCarlo

# ╔═╡ 5fa95eab-19ad-4a6e-91c9-294106c2b515
function estimatePi(nTrials)
	sqrt( /(6, monteCarlo(nTrials, cesaroTest)))
end # function estimatePi

# ╔═╡ f230cdec-0f6e-4fb0-bd74-d8cd8723b92b
1E1

# ╔═╡ a02adfd8-669a-49dc-a545-308ba581788a
estimatePi(1E1)

# ╔═╡ 37097866-0f3d-4e52-8568-58f888343e93
estimatePi(1E2)

# ╔═╡ 38e3d2df-88d0-4065-be0b-c674f3374c4f
estimatePi(1E3)

# ╔═╡ d2578b2d-c68e-40b9-8ab6-5ad8599fe126
estimatePi(1E4)

# ╔═╡ 8c9a4c8a-885d-4b0a-9ee8-e83607b69471
isapprox(estimatePi(1E4), π; atol= 1E-2)   # ==> true 

# ╔═╡ 4e94ba50-384a-4b3f-b9b8-ba19d30fe25d
isapprox(estimatePi(1E4), π; atol= 1E-3)   # ==> false

# ╔═╡ e26f4676-4d79-4bd2-86ae-fc9d7c37ba0f
estimatePi(1E5)

# ╔═╡ 8490eca3-22b5-4fc8-8260-8f133f32494f
md"
---
##### 3.1.2.1.2 *Idiomatic* Julia
"

# ╔═╡ a30c1632-0465-4c6b-ba0b-5d54939bb71c
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

# ╔═╡ 4f58bcf8-989c-45e8-a38c-91e55c2b9d61
function estimatePi2(nTrials)
	sqrt( /(6, monteCarlo2(nTrials, cesaroTest)))
end # function estimatePi2

# ╔═╡ bc93c4ce-59c9-44a9-b73f-ed40eba9a9ee
estimatePi2(1E1)

# ╔═╡ bc57fdd1-925a-4efc-9b12-39ee034597e1
isapprox(estimatePi2(1E1), π; atol= 1E-1)

# ╔═╡ 34333c9b-08f5-41ed-98f7-8c8b197a4c19
estimatePi2(1E2)

# ╔═╡ 4af65a33-383d-49df-b48f-02b34d860678
isapprox(estimatePi2(1E2), π; atol= 1E-2)

# ╔═╡ f4084511-f570-48fb-bb7b-4d13329991a4
estimatePi2(1E3)

# ╔═╡ 30009358-cec0-48cc-b6d6-9ba357ce95ae
isapprox(estimatePi2(1E3), π; atol= 1E-2)

# ╔═╡ 8777d7d9-79eb-4496-9252-3f0292563e34
estimatePi2(1E4)

# ╔═╡ 759debd7-a516-46c8-9920-022b33708dfd
isapprox(estimatePi2(1E4), π; atol= 1E-2)

# ╔═╡ 2b8f9242-f758-4756-a43c-1cdcb0569646
estimatePi2(1E5)

# ╔═╡ d0b0ca2d-8ec4-4b26-82fe-a584fe01d97c
1E-2

# ╔═╡ fded31d8-5755-4ba2-8877-3ca7dff1e1af
isapprox(estimatePi2(1E5), π; atol= 1E-2)

# ╔═╡ 6254d92f-d6db-4c28-bf73-98d28361fb10
estimatePi2(1E6)

# ╔═╡ 1f99c5f4-c143-4a8f-b87d-d0a3c0bcdb12
isapprox(estimatePi2(1E6), π; atol= 1E-3)

# ╔═╡ 04def250-24a7-455c-941d-fc275702756b
estimatePi2(1E7)

# ╔═╡ 9aaffbcd-afa2-46bc-b6d4-a85c9d10b0a1
isapprox(estimatePi2(1E7), π; atol= 1E-3)

# ╔═╡ ce6d7e0c-8316-4908-abb3-99c998ddf72d
isapprox(estimatePi2(1E8), π; atol= 1E-3)

# ╔═╡ 4984e96a-192b-46c6-8150-8664ae56fdb2
md"
---
"

# ╔═╡ cbfe40ec-f4b5-47ae-91e9-83d488f51fed
function monteCarlo3(nTrials, experiment) 
	let expOutcomes = [experiment() for i in 1:nTrials]
		nTrialsPassed = filter(boolval -> boolval == true, expOutcomes)
		length(nTrialsPassed) / nTrials
	end # let
end # function monteCarlo3

# ╔═╡ dcede2f0-5772-4e9f-bd94-bfc01f728e92
function estimatePi3(nTrials)
	sqrt( /(6, monteCarlo3(nTrials, cesaroTest)))
end # function estimatePi2

# ╔═╡ f8ff8be0-9165-4fd4-a4d0-530b305a2b95
estimatePi3(1E1)

# ╔═╡ bf84dd08-f8fa-49e6-9e39-60181d293b40
estimatePi3(1E2)

# ╔═╡ f1d124a5-3354-4119-b4c6-36c92fbcb3f5
estimatePi3(1E3)

# ╔═╡ 6576a966-619d-42da-9dc9-c460a1d49ebb
estimatePi3(1E4)

# ╔═╡ ab83e287-2474-4c9b-b08d-6895bb6b7658
estimatePi3(1E5)

# ╔═╡ 22ce62fa-5146-40bb-a4e2-dad2db8e3f7a
estimatePi3(1E6)

# ╔═╡ 1efd45fe-6507-462b-acb7-e5f42740e70f
estimatePi3(1E7)

# ╔═╡ 8c63f788-484f-4111-844c-de43704704b9
md"
---
##### References
- **Dirichlet, G.L.**, *Theorem D*, Abhandlungen Koniglich PreuB. Akad. Wiss.,1849, 69-83
- **Knuth, D.E.**, *Seminumerical Algorithms*. Vol. 2 of *The Art of Computer Programming*. 1998, 3rd edition, Reading, MA: Addison-Wesley.
"

# ╔═╡ fb056a2d-d82c-41e9-9c00-be83ff532771
md"
---
##### end of ch. 3.1.2.1
"

# ╔═╡ 85b8779f-b647-4454-8b9e-2c9059a3eb85


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
# ╟─10c2df10-99aa-11ed-2a51-69f641cea4fb
# ╟─a45bb0f2-3ef4-44c2-927c-dd626a577fd6
# ╠═c5cf1712-bb28-4a90-bdde-b5920384d80e
# ╠═aba250e9-7189-4daf-8e50-0266f74f7c96
# ╠═c5e79d67-8266-4ec6-951c-9f43e277370d
# ╠═cc5711d6-cd67-47c9-abca-da01b2d10991
# ╠═9924e9d3-bcdb-4743-a530-f2f1d80b9eb2
# ╠═4d4035d0-c234-4643-a03f-1867450991aa
# ╠═cf308e67-c82b-4036-b00b-95d4b097a8cb
# ╠═e4b12c43-752e-4476-b4f5-35d8bb24fc39
# ╟─7e9b5455-d069-4212-9de6-1d48fb886b2f
# ╠═5fa95eab-19ad-4a6e-91c9-294106c2b515
# ╠═4ebdd843-ea90-4248-afb4-0a5f525f2cdb
# ╠═18f1701e-b0e4-4be1-885b-ea5cbbfbf8ae
# ╠═2b9a680f-b77e-4818-9013-e1ff5a360440
# ╠═add99d5e-d88d-4fd1-9070-1309ebacd5c5
# ╠═f230cdec-0f6e-4fb0-bd74-d8cd8723b92b
# ╠═a02adfd8-669a-49dc-a545-308ba581788a
# ╠═37097866-0f3d-4e52-8568-58f888343e93
# ╠═38e3d2df-88d0-4065-be0b-c674f3374c4f
# ╠═d2578b2d-c68e-40b9-8ab6-5ad8599fe126
# ╠═8c9a4c8a-885d-4b0a-9ee8-e83607b69471
# ╠═4e94ba50-384a-4b3f-b9b8-ba19d30fe25d
# ╠═e26f4676-4d79-4bd2-86ae-fc9d7c37ba0f
# ╟─8490eca3-22b5-4fc8-8260-8f133f32494f
# ╠═4f58bcf8-989c-45e8-a38c-91e55c2b9d61
# ╠═a30c1632-0465-4c6b-ba0b-5d54939bb71c
# ╠═bc93c4ce-59c9-44a9-b73f-ed40eba9a9ee
# ╠═bc57fdd1-925a-4efc-9b12-39ee034597e1
# ╠═34333c9b-08f5-41ed-98f7-8c8b197a4c19
# ╠═4af65a33-383d-49df-b48f-02b34d860678
# ╠═f4084511-f570-48fb-bb7b-4d13329991a4
# ╠═30009358-cec0-48cc-b6d6-9ba357ce95ae
# ╠═8777d7d9-79eb-4496-9252-3f0292563e34
# ╠═759debd7-a516-46c8-9920-022b33708dfd
# ╠═2b8f9242-f758-4756-a43c-1cdcb0569646
# ╠═d0b0ca2d-8ec4-4b26-82fe-a584fe01d97c
# ╠═fded31d8-5755-4ba2-8877-3ca7dff1e1af
# ╠═6254d92f-d6db-4c28-bf73-98d28361fb10
# ╠═1f99c5f4-c143-4a8f-b87d-d0a3c0bcdb12
# ╠═04def250-24a7-455c-941d-fc275702756b
# ╠═9aaffbcd-afa2-46bc-b6d4-a85c9d10b0a1
# ╠═ce6d7e0c-8316-4908-abb3-99c998ddf72d
# ╟─4984e96a-192b-46c6-8150-8664ae56fdb2
# ╠═dcede2f0-5772-4e9f-bd94-bfc01f728e92
# ╠═cbfe40ec-f4b5-47ae-91e9-83d488f51fed
# ╠═f8ff8be0-9165-4fd4-a4d0-530b305a2b95
# ╠═bf84dd08-f8fa-49e6-9e39-60181d293b40
# ╠═f1d124a5-3354-4119-b4c6-36c92fbcb3f5
# ╠═6576a966-619d-42da-9dc9-c460a1d49ebb
# ╠═ab83e287-2474-4c9b-b08d-6895bb6b7658
# ╠═22ce62fa-5146-40bb-a4e2-dad2db8e3f7a
# ╠═1efd45fe-6507-462b-acb7-e5f42740e70f
# ╟─8c63f788-484f-4111-844c-de43704704b9
# ╟─fb056a2d-d82c-41e9-9c00-be83ff532771
# ╟─85b8779f-b647-4454-8b9e-2c9059a3eb85
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
