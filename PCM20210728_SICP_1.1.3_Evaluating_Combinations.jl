### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 749c8c80-f126-11eb-33a6-b72ce370f20f
md"
===================================================================================

### SICP: [1.1.3 Evaluating Combinations](https://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e3)

###### file: PCM20210728\_SICP\_1.1.3\_Evaluating\_Combinations

###### Julia/Pluto.jl-code (1.8.0/19.11) by PCM *** 2022/08/26 ****
 
===================================================================================
"

# ╔═╡ 510c321f-a963-47ba-bf00-693b2275a4a3
md"
#### 1.1.3.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ 17bcdc6b-48f5-4fb9-b260-dd6a93998520
*( +( 2, *( 4, 6)), 
   +( 3, 5, 7))

# ╔═╡ aef5c84c-c764-4489-a927-12538ae5181c
*( +( 2, *( 4, 6)), +( 3, 5, 7))

# ╔═╡ a9586909-e952-4cdf-99a7-c79a388e5cd9
md"
---
                                      390
			                           |        
		                 +-------------+-----------------+
			             |             |                 |
			             *            26                15
			                           |                 |
			                       +---+---+       +---+---+---+
		                           |   |   |       |   |   |   |
                                   +   2  24       +   3   5   7
                                           |
                                       +---+---+
                                       |   |   |                         
                                       *   4   6
								 
**Fig 1.1.a** Tree of (sub-)expression values (modified SICP, 1966, Figure 1.1, p.10)

---
"

# ╔═╡ 04603fd1-80b6-4486-bf22-ce6d521c3b4e
md"
---
                                 4           6
								 |           |
		                         +-----+-----+
									   |
						   2           *        3     5     7
						   |           |        |     |     |    
				           +-----+-----+        +-----+-----+
						         |                    |
					             +                    +
						         |                    |
						         +---------+----------+
						                   |  
						                   *

**Fig 1.1.b** (new) *Kantorovic tree* (Bauer & Wösnner, 1982, p.21)

---
"

# ╔═╡ db698f35-cd91-469b-92ad-f6c86b55b16b
md"
---
#### 1.1.3.2 idiomatic *imperative* Julia ...
###### ... with *infix* operators
"

# ╔═╡ e2443252-7c22-4385-87a4-caf4eec72d60
(2 + (4 * 6)) * (3 + 5 + 7) 

# ╔═╡ fec0b277-1847-4552-96d3-c05f11a43fbd
(2 + 4 * 6) * (3 + 5 + 7)

# ╔═╡ d42c001d-a772-430e-a4b8-19f5e09acee4
md"
---
#### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/23

- **Bauer, F.L. & Wössner, H.**; Algorithmic Language and Program Development; Heidelberg: Springer, 1982
"

# ╔═╡ c0e324a0-da15-424a-935f-e62b8ca990be
md"
---
##### end of ch. 1.1.3 
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─749c8c80-f126-11eb-33a6-b72ce370f20f
# ╟─510c321f-a963-47ba-bf00-693b2275a4a3
# ╠═17bcdc6b-48f5-4fb9-b260-dd6a93998520
# ╠═aef5c84c-c764-4489-a927-12538ae5181c
# ╟─a9586909-e952-4cdf-99a7-c79a388e5cd9
# ╟─04603fd1-80b6-4486-bf22-ce6d521c3b4e
# ╟─db698f35-cd91-469b-92ad-f6c86b55b16b
# ╠═e2443252-7c22-4385-87a4-caf4eec72d60
# ╠═fec0b277-1847-4552-96d3-c05f11a43fbd
# ╟─d42c001d-a772-430e-a4b8-19f5e09acee4
# ╟─c0e324a0-da15-424a-935f-e62b8ca990be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
