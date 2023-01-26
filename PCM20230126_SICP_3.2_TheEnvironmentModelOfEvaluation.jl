### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ cc403960-9d7c-11ed-06dd-058f697877fc
md"
====================================================================================
#### SICP: [3.2 The Environment Model of Evaluation](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2)
##### file: PCM20230126\_SICP\_3.2\_TheEnvironmentModelOfEvaluation.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/26 ***

====================================================================================
"

# ╔═╡ a61478a2-bce7-4135-8e08-b1dc802022ca
md"
**Fig. 3.2.1** A simple environment structure (cf. SICP, 1996, Fig. 3.1, p.237)
"

# ╔═╡ 73b5eb76-0d36-4628-8bf3-e152da638714
md"
---
##### Modelling *Environments* by $$let$$-expressions
"

# ╔═╡ ab00cf98-2df9-4fa9-a547-91d8f44b65aa
md"
###### *Pointers* to Environments as *assignments*  $$\;\;=\;\;$$
###### Link A and Frame E_II
"

# ╔═╡ ad951795-efe6-4f0e-94cd-691cc1947c8f
md"
###### Evaluation chain $$A \rightarrow z, x$$
"

# ╔═╡ ff27b1ce-f1f2-45d1-98fb-fb79655265c2
md"
---
###### Link B and Frame E_III
"

# ╔═╡ 3a59b1e4-9e11-4435-b579-de0c0d8b7a56
md"
###### Evaluation chain $$B \rightarrow m, y$$
"

# ╔═╡ 62aac05a-38fb-4b39-acc0-904fda07e4cf
md"
---
###### Link C and Frame E_I
"

# ╔═╡ 98fed87d-cac3-49e2-991b-e7f83738a5e3
C = let x = 3            #  E_I
	   	y = 5
		(x=x, y=y)
end # let                   E_I

# ╔═╡ 131380ab-60df-4ac3-aaec-e3794ef09c3b
A = let z = 6            #  E_II
	   	x = 7
		C = C
		(z=z, x=x, C=C)
end # let                   E_II

# ╔═╡ f4121729-cef0-476c-8a9d-b3da2eddc91f
A.z

# ╔═╡ 1345a561-6c3a-4e3c-8066-08e292d4ae1e
A.x

# ╔═╡ 2eb4cb3e-e385-4ccb-9cf0-313ac34f486d
md"
###### Evaluation chain $$C \rightarrow x, y$$
"

# ╔═╡ 088bc34d-ea94-4705-b085-ecb31a706be8
C.x

# ╔═╡ 1d94302d-bfa8-4b49-9a03-01f5405ee998
C.y

# ╔═╡ 898ca369-0d85-4dc3-b2cb-a49afc10f50d
md"
---
###### Link D and Frame E_I
"

# ╔═╡ f759c0a3-56db-4c10-a107-955cd049d19e
D = C

# ╔═╡ 5aeaddc9-77e3-4706-8b2c-6bc00acf37c6
B = let m = 1            #  E_III
	   	y = 2
		D = D
		(m=m, y=y, D=D)
end # let                   E_III

# ╔═╡ 69620a5f-1141-49a6-80f1-b001fdb86fcd
B.m

# ╔═╡ b8a7697a-e8e1-4750-9684-f495556afc52
B.y

# ╔═╡ 29d0fe95-3c4d-4411-a158-b0564b95440e
md"
###### Evaluation chain $$D \rightarrow x, y$$
"

# ╔═╡ ab9c6f6f-3952-4b48-9bc3-ae0ef0a6c5ee
D.x

# ╔═╡ 8ceb5d3b-fc65-48bc-9354-b5adca273af5
D.y

# ╔═╡ 6118dc50-5dd3-48cd-b591-9c79d1a78724
md"
---
###### Evaluation chain $$A \rightarrow C \rightarrow x, y$$
"

# ╔═╡ 8e8ce1d7-63d6-44d0-8e0a-c106a33f1c51
A.C.x

# ╔═╡ d9566d53-ab89-45e9-aba7-d43acbbdbcc6
A.C.y

# ╔═╡ daa28246-cf14-4b4b-83fd-f11996f72572
md"
---
###### Evaluation chain $$B \rightarrow D \rightarrow x, y$$
"

# ╔═╡ dad8ff2c-0d65-4f11-a69c-f97f102c3085
B.D.x

# ╔═╡ ac203c4e-ae22-4994-8442-28ed05db1b8e
B.D.y

# ╔═╡ fe463628-c203-4e57-be5b-6a60f2b7b24a
md"
---
##### end of ch. 3.2
"

# ╔═╡ 40867b4f-ebac-4556-a71c-59ef34881146
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

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─cc403960-9d7c-11ed-06dd-058f697877fc
# ╟─a61478a2-bce7-4135-8e08-b1dc802022ca
# ╟─73b5eb76-0d36-4628-8bf3-e152da638714
# ╟─ab00cf98-2df9-4fa9-a547-91d8f44b65aa
# ╠═131380ab-60df-4ac3-aaec-e3794ef09c3b
# ╟─ad951795-efe6-4f0e-94cd-691cc1947c8f
# ╠═f4121729-cef0-476c-8a9d-b3da2eddc91f
# ╠═1345a561-6c3a-4e3c-8066-08e292d4ae1e
# ╟─ff27b1ce-f1f2-45d1-98fb-fb79655265c2
# ╠═5aeaddc9-77e3-4706-8b2c-6bc00acf37c6
# ╟─3a59b1e4-9e11-4435-b579-de0c0d8b7a56
# ╠═69620a5f-1141-49a6-80f1-b001fdb86fcd
# ╠═b8a7697a-e8e1-4750-9684-f495556afc52
# ╟─62aac05a-38fb-4b39-acc0-904fda07e4cf
# ╠═98fed87d-cac3-49e2-991b-e7f83738a5e3
# ╟─2eb4cb3e-e385-4ccb-9cf0-313ac34f486d
# ╠═088bc34d-ea94-4705-b085-ecb31a706be8
# ╠═1d94302d-bfa8-4b49-9a03-01f5405ee998
# ╟─898ca369-0d85-4dc3-b2cb-a49afc10f50d
# ╠═f759c0a3-56db-4c10-a107-955cd049d19e
# ╟─29d0fe95-3c4d-4411-a158-b0564b95440e
# ╠═ab9c6f6f-3952-4b48-9bc3-ae0ef0a6c5ee
# ╠═8ceb5d3b-fc65-48bc-9354-b5adca273af5
# ╟─6118dc50-5dd3-48cd-b591-9c79d1a78724
# ╠═8e8ce1d7-63d6-44d0-8e0a-c106a33f1c51
# ╠═d9566d53-ab89-45e9-aba7-d43acbbdbcc6
# ╟─daa28246-cf14-4b4b-83fd-f11996f72572
# ╠═dad8ff2c-0d65-4f11-a69c-f97f102c3085
# ╠═ac203c4e-ae22-4994-8442-28ed05db1b8e
# ╟─fe463628-c203-4e57-be5b-6a60f2b7b24a
# ╟─40867b4f-ebac-4556-a71c-59ef34881146
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
