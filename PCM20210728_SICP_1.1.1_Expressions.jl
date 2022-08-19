### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ cb910be0-81bf-11ec-1c30-f1787f914442
md"
====================================================================================

### SICP: [1.1.1 Expressions](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-10.html#%_sec_1.1.1)

###### file: PCM20210728\_SICP\_1.1.1_Expressions.jl

###### Julia-Pluto.jl-code by PCM *** 2022/08/19 ***

====================================================================================
"

# ╔═╡ 9563db78-bd76-4be1-8e8e-4b1b5c817be5
md"
#### 1.1.1.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ 38c68f4c-861f-46be-a74d-35cf2326d419
md"
###### numbers
"

# ╔═╡ 6621095d-9b0a-4882-8b8e-ea429a6fa78f
486

# ╔═╡ bd03d096-9ecf-4ac3-b38f-d444496fa7d2
md"
###### SICP-Scheme-like *prefix* expressions
"

# ╔═╡ 2ff8dae2-8ea6-490e-a57e-f7ac817b0606
+(137, 349)      # same as SICP-Scheme: (+ 137 349)  ==> 486

# ╔═╡ 7ec7b812-2511-4b05-b694-e68a77078a6d
-(1000, 334)     # same as SICP-Scheme: (- 1000 334) ==> 666

# ╔═╡ bcb3b9e9-9675-4b13-aa11-11d366f62a26
-(1000, 300, 34) # contrary to multiary Scheme's '-' Julia's prefix '-' is only binary

# ╔═╡ dbb2358c-e29c-480b-9eae-02e2590db445
-(-(1000, 300), 34) # ... so we have to dissolve -(a,b,c) into -(-(a, b), c)

# ╔═╡ 83215ffd-9ea0-441f-8be7-fa2035fe4bb7
*(5, 99)         # same as SICP-Scheme: (* 5 99) ==> 495

# ╔═╡ c8978448-04c6-4645-986a-f3990b335a47
/(10, 5)         # Integer X Integer --> Float !

# ╔═╡ 9f55f189-d5f1-4a8b-b02c-e417d2e3be02
div(10, 5)       # Integer division same as # SICP-Scheme: (/ 10 5) ==> 2 

# ╔═╡ 1716ad24-8aed-4a73-909b-94010bffabfb
÷(10, 5)         # Integer division same as # SICP-Scheme: (/ 10 5) ==> 2 

# ╔═╡ 2fcd4777-457c-467e-b2a2-1f3d8e7751ce
÷

# ╔═╡ 5518ab1d-51d0-442f-812c-48fdbe3845b2
+(2.7, 10)       # same as SICP-Scheme: (+ 2.7 10) ==> 12.7

# ╔═╡ a0df5d6b-d29f-429b-8076-1e11495baa14
+(21, 35, 12, 7) # same as SICP-Scheme: (+ 21 35 12 7) ==> 75

# ╔═╡ b85f2c4e-aa4b-41f3-ad4f-ef8c2b6c667c
*(25, 4, 12)     # same as SICP-Scheme: (* 25 4 12) ==> 1200

# ╔═╡ 1f6d7c29-e0dc-4622-9b51-d080bc68b9ae
+( *(3, 5), -(10, 6)) # same as SICP-Scheme: (+ (* 3 5)(- 10 6)) ==> 19

# ╔═╡ d8ebde94-0215-4470-afc5-2c30f85baa75
# same as SICP-Scheme: (+ (* 3 (+ (* 2 4) (+ 3 5))) (+ (- 10 7) 6)) ==> 57
+( *(3, +( *( 2, 4), +(3, 5))), +( -(10, 7), 6))

# ╔═╡ 28c845bc-97e8-4914-837a-3cd1788d57b9
md"
###### nested combination with *prefix* operators as a data flow (*Kantorovich*) tree 
(Bauer & Wössner, 1981, p.21)
"

# ╔═╡ 6493f14f-3e8a-46e4-b693-1209dde05d1a
+( *(3, 
		+( *( 2, 4), 
		   +(3, 5))), 
	+( -(10, 7), 
		6))

# ╔═╡ b48be123-30b4-4bbf-94f6-1c5dc5602a77
md"
               2         4     3         5    
               |         |     |         |
			   +----+----+     +----+----+
                    |               |      
                    *               +      10             7
		            |               |       |             |
		            +-------+-------+       +------+------+
		                    |                      |
		    3               +                      -             6
		    |               |                      |             |
            +-------+-------+                      +------+------+
			        |                                     |
		            *                                     +
	                |                                     |
		            +------------------+------------------+
			                           |
					                   +
					             
				  

###### Fig. 1.1.1.1: Kantorovic tree
		         
"

# ╔═╡ 94c2b564-232c-4bc6-8c8f-d6d114d8b34c
md"
---
#### 1.1.1.2 idiomatic Julia ...
###### ... with *infix* operators, functions, methods, *infix* expressions
"

# ╔═╡ 6f670e03-3644-4ab8-8aeb-3ada7ccb6584
137 + 349

# ╔═╡ d5c21378-2789-42eb-aaaf-c09ddaee9862
+                # + ==> (generic function with 208 methods)

# ╔═╡ 44db39bb-c602-4df5-b850-f0c789ee1995
1000 - 334

# ╔═╡ b435cc5a-ec42-43f5-991f-1950830aac17
-

# ╔═╡ fe5b2f13-7d89-4625-85ba-412d2dee236f
5 * 99

# ╔═╡ c3362f92-e090-454d-a71d-575d7cba9b53
*

# ╔═╡ 0a22fb58-b2d0-469b-86c8-004512a43c63
10 / 5           # Float64 !

# ╔═╡ 818b29a8-37c3-43a1-9887-92ce11ba0b01
/                # 111 (!) methods of function symbol '/'

# ╔═╡ 9df1e24a-de6b-4893-8bc3-1283d56e1ef1
typeof(/(10, 5)) # Float64 !  # SICP-Scheme: (/ 10 5) ==> 2 which is Int64 !

# ╔═╡ cc0a6e4f-772a-45f0-a1e4-00ce17dd01a4
div

# ╔═╡ 3791ba91-5873-435d-a006-3bcb13c3c9de
10 ÷ 5           # Integer division

# ╔═╡ 965dfe73-415a-48a8-9a00-2f09489222ab
2.7 + 10         # Float64 !

# ╔═╡ 0ee89eec-cfb5-4e8e-9a70-85e4c5b7822d
21 + 35 + 12 + 7

# ╔═╡ 3334749b-1303-412b-a7d3-06907128d0aa
25 * 4 * 12

# ╔═╡ 91db14ac-5ebb-4556-a87d-67cb5d93b258
(3 * 5) + (10 - 6)

# ╔═╡ 04859d11-ea78-45b6-b793-3bb4d43804b3
3 * 5 + (10 - 6)

# ╔═╡ f853ba10-8752-4e46-98c5-63132c8f4728
 (3 * ((2 * 4) + (3 + 5)) + ((10 - 7) + 6))

# ╔═╡ 3148fbed-afb9-4314-8c60-2607c5c122ca
3 * (2 * 4 + 3 + 5) + 10 - 7 + 6

# ╔═╡ 58edd056-6ddb-48bd-b079-1bfa3055cb7a
md"
---
#### References

- Bauer, F.L. & Wössner, H.; Algorithmic Language and Program Development, Heidelberg: Springer, 1981
"

# ╔═╡ e831a5f5-fa0e-4214-a7b7-83a8fe9b989d
md"
---
#### end of ch. 1.1.1

====================================================================================

This is a **draft**. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─cb910be0-81bf-11ec-1c30-f1787f914442
# ╟─9563db78-bd76-4be1-8e8e-4b1b5c817be5
# ╟─38c68f4c-861f-46be-a74d-35cf2326d419
# ╠═6621095d-9b0a-4882-8b8e-ea429a6fa78f
# ╟─bd03d096-9ecf-4ac3-b38f-d444496fa7d2
# ╠═2ff8dae2-8ea6-490e-a57e-f7ac817b0606
# ╠═7ec7b812-2511-4b05-b694-e68a77078a6d
# ╠═bcb3b9e9-9675-4b13-aa11-11d366f62a26
# ╠═dbb2358c-e29c-480b-9eae-02e2590db445
# ╠═83215ffd-9ea0-441f-8be7-fa2035fe4bb7
# ╠═c8978448-04c6-4645-986a-f3990b335a47
# ╠═9f55f189-d5f1-4a8b-b02c-e417d2e3be02
# ╠═1716ad24-8aed-4a73-909b-94010bffabfb
# ╠═2fcd4777-457c-467e-b2a2-1f3d8e7751ce
# ╠═5518ab1d-51d0-442f-812c-48fdbe3845b2
# ╠═a0df5d6b-d29f-429b-8076-1e11495baa14
# ╠═b85f2c4e-aa4b-41f3-ad4f-ef8c2b6c667c
# ╠═1f6d7c29-e0dc-4622-9b51-d080bc68b9ae
# ╠═d8ebde94-0215-4470-afc5-2c30f85baa75
# ╟─28c845bc-97e8-4914-837a-3cd1788d57b9
# ╠═6493f14f-3e8a-46e4-b693-1209dde05d1a
# ╟─b48be123-30b4-4bbf-94f6-1c5dc5602a77
# ╟─94c2b564-232c-4bc6-8c8f-d6d114d8b34c
# ╠═6f670e03-3644-4ab8-8aeb-3ada7ccb6584
# ╠═d5c21378-2789-42eb-aaaf-c09ddaee9862
# ╠═44db39bb-c602-4df5-b850-f0c789ee1995
# ╠═b435cc5a-ec42-43f5-991f-1950830aac17
# ╠═fe5b2f13-7d89-4625-85ba-412d2dee236f
# ╠═c3362f92-e090-454d-a71d-575d7cba9b53
# ╠═0a22fb58-b2d0-469b-86c8-004512a43c63
# ╠═818b29a8-37c3-43a1-9887-92ce11ba0b01
# ╠═9df1e24a-de6b-4893-8bc3-1283d56e1ef1
# ╠═cc0a6e4f-772a-45f0-a1e4-00ce17dd01a4
# ╠═3791ba91-5873-435d-a006-3bcb13c3c9de
# ╠═965dfe73-415a-48a8-9a00-2f09489222ab
# ╠═0ee89eec-cfb5-4e8e-9a70-85e4c5b7822d
# ╠═3334749b-1303-412b-a7d3-06907128d0aa
# ╠═91db14ac-5ebb-4556-a87d-67cb5d93b258
# ╠═04859d11-ea78-45b6-b793-3bb4d43804b3
# ╠═f853ba10-8752-4e46-98c5-63132c8f4728
# ╠═3148fbed-afb9-4314-8c60-2607c5c122ca
# ╟─58edd056-6ddb-48bd-b079-1bfa3055cb7a
# ╟─e831a5f5-fa0e-4214-a7b7-83a8fe9b989d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
