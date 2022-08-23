### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ e4ea9712-f127-11eb-1ce4-e9286638b6cf
md"
===================================================================================
 ### SICP: [1.1.4 Compound Procedures](https://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e4)

 ###### file: PCM20210730\_SICP\_1.1.4\_Compound\_Procedures.jl

 ###### Julia/Pluto.jl-code (1.8.0/19.11) by PCM *** 2022/08/23 ***
===================================================================================
"

# ╔═╡ 4e1efa4a-cb44-4913-a35f-0a779ee0ee2a
md"
#### 1.1.4.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ 73339eae-4754-49b1-938a-5ceae1c0f6a3
md"
---
$$square : \mathbb R \rightarrow \mathbb R$$
$$square : x \mapsto square(x)$$
$$square := x \mapsto x^2$$
"

# ╔═╡ b7025b0c-5010-47f7-9c73-789c9335987a
md"
###### 1st (default) *untyped* method of function 'square'
"

# ╔═╡ 150ad79c-42b4-4981-8711-1ef426725ca0
square(x) = *(x, x)           # 1st (default) untyped method of function 'square'

# ╔═╡ 7e97208a-d1b0-435e-8756-f0b468b1c795
md"
---
$$sumOfSquares : \mathbb R \times \mathbb R \rightarrow \mathbb R$$
$$sumOfSquares := (x, y) \mapsto x^2 + y^2$$
"

# ╔═╡ 97d5f945-f0fe-4e2e-8bc3-6a562caf31eb
md"
###### 1st (default) *untyped* method of function 'sumOfSquares'
"

# ╔═╡ b6fda0b6-2ea2-4f2f-961b-65936c050852
md"
---
$$f : \mathbb R \times \mathbb R \rightarrow \mathbb R$$
$$f : a \mapsto f(a)$$
$$f := a \mapsto sumOfSquares(a+1, 2a) = a \mapsto (a+1)^2 + (2a)^2$$
"

# ╔═╡ 1cf1668b-220e-4813-af3b-fef0f938e29b
md"
---
#### 1.1.4.2 idiomatic *functional* Julia ...
###### ... with *infix* operator, *abstract* types AbstractFloat, Integer and *self-defined* type FloatOrInteger
"

# ╔═╡ 0cd52b1c-6e27-4dcf-a7e6-441745238e3e
md"
###### unintended (!) use of untyped function; need for typing is obvious
"

# ╔═╡ 44b6cef9-6ea5-4540-aca3-61c2712e44fd
md"  
                         Number
				            |
	  +---------------------+---------------------+
      |                                           |
	Complex                                     Real
                                                  |
			  +-------------------------+---------+---------+----------------+
		      |                         |                   |                |
	    AbstractFloat                Integer            Rational    AbstractIrrational
			  |                         |                                    |
      +-------+-------+          +------+------+                        Irrational
      |       |       |          |      |      |
	Float64 Float32 Float16   Signed  Bool  Unsigned
                                 |
						  +------+------+
		                  |      |      |
				        Int64  Int32  Int16
 

**Fig. 1.1.4** Excerpt from *Julia's* type hierarchy (a more complete excerpt can be found in Nazarathy & Klok, 2021, p.11)
"

# ╔═╡ 3836b76c-5f05-487e-bcc1-e5261629c1fc
md"
###### we need a more *specialized* abstract type than Real because because we *don't* need Ration and AbstractIrrational
"

# ╔═╡ fe3227b9-b6e6-47ce-9dad-e817d1c5b171
FloatOrInteger = Union{AbstractFloat, Integer} 

# ╔═╡ 34014cf8-ad86-47c2-975d-8d4f88e67e91
FloatOrInteger <: Real

# ╔═╡ 7c8b7c1d-1e23-49c6-be97-32c9f2e38041
md"
---
###### 2nd (specialized) *typed* method of function 'square'
"

# ╔═╡ 9410ff1c-daf0-48de-be8a-f31c5a76dbed
square(x::FloatOrInteger)::FloatOrInteger = x * x  # 2nd method of function 'square'

# ╔═╡ 714e9893-f609-4a24-a020-0041f5361a2d
square

# ╔═╡ 8db7e80c-a877-44ff-aa15-48841c035aeb
square(21)

# ╔═╡ 95f00b9b-646c-4ac5-b6fd-16f84a89d7b9
square(+(2, 5))

# ╔═╡ 731aa7ca-d4af-4be8-8a40-2eec5522ad99
square(square(3))

# ╔═╡ 140e78ee-a3af-46c7-9ad3-dfac7cf56bc4
+(square(3), square(5))

# ╔═╡ 7254bd30-87b7-48e9-99f8-56159dc78ad4
sumOfSquares(x, y) = +(square(x), square(y))

# ╔═╡ a8ca27fa-bd58-4163-895f-bf44a4392476
square("oh ")   

# ╔═╡ 6bf0a86b-2d41-49e1-bea9-bf82cddcbc7a
square

# ╔═╡ c1bcd8d6-26c0-45af-98c2-c626384018e6
methods(square)

# ╔═╡ 4462e7ca-18f7-4f9d-8198-0196dac76c7d
typeof(square)

# ╔═╡ 06846d34-23ba-4916-872f-3bcf62f579fa
subtypes(FloatOrInteger)

# ╔═╡ bc018df0-02ea-4011-ad6e-2176e4a1b232
square(21)         # square2 : Integer --> Integer

# ╔═╡ 965efc63-8dac-4397-8052-312bccd4e736
square(21.0)       # square2 : Float --> Float

# ╔═╡ bd99f22b-51f2-48fe-8391-b1e37498e7ff
 # blocking of strings does *not* work 
 # because *untyped* 1st method of function square is triggered
 #         so untyped method has to be deleted
square("twenty")  

# ╔═╡ c44ce267-d9d7-46ea-a6f2-54170cda5409
md"
---
###### 2nd (specialized) *typed* method of function 'sumOfSquares'
"

# ╔═╡ abd380fc-5018-462c-8641-3fc269e0d2cb
sumOfSquares(x::FloatOrInteger, y::FloatOrInteger)::FloatOrInteger = square(x) + square(y)

# ╔═╡ e6a69b7f-dfb5-45db-a0fc-e4d24229f6c3
sumOfSquares(3, 4)

# ╔═╡ 706e727c-f29b-4cdb-ae08-cddd5725cdae
f1(a) = sumOfSquares(+(a, 1), *(a, 2))

# ╔═╡ 2b7d0b48-70de-40fd-bf43-660e70f2416e
f1(5)

# ╔═╡ 358250f0-94b7-48a8-acde-1c1f2734c967
# alternative function definition of f1 with 'function'
f2 = function(a)
	sumOfSquares((a + 1), 2a)  # infix '+' and iuxtapositioned '2a'
end

# ╔═╡ 538f4130-f6e1-43c2-8020-f7f2488e2442
f2(5)

# ╔═╡ 3766c9b6-0ff5-4b0d-bc85-2c9bfe0a1d50
# 2nd alternative function definition of f1 with anonymous function '->'
f3 = a -> sumOfSquares((a + 1), 2a)    

# ╔═╡ 84bb8887-9df3-4ff0-ab50-eb144cd2f118
f3(5)

# ╔═╡ 8a67cb77-a84f-4750-9099-56b5ef8ae038
sumOfSquares(3.0, 4.0)

# ╔═╡ d0fac6ee-0507-4a55-907c-a86136e48e65
f4(a::FloatOrInteger)::FloatOrInteger =
	sumOfSquares(a + 1::FloatOrInteger, 2a::FloatOrInteger)::FloatOrInteger

# ╔═╡ f29a4f6f-d090-4be8-9d0f-14369c35b6b3
f4(5)

# ╔═╡ 863f12ad-c33c-4888-ba69-2c69f55edd07
f4(5.0)

# ╔═╡ 20f492e1-1b1b-4852-8e40-37d4bd96c2a3

md"
---
#### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996
- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/21
- **Nazarathy, Y. & Klok, H.**, Statistics with Julia, Cham, Switzerland: Springer, 2021
"

# ╔═╡ 923f3c7d-9b17-4458-9ee3-8dd0e36f8452
md" 
---
#### end of ch. 1.1.4
===================================================================================

This is a **draft**. Comments, suggestions, and corrections are welcome: **claus.moebus(@)uol.de**

===================================================================================
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
# ╟─e4ea9712-f127-11eb-1ce4-e9286638b6cf
# ╟─4e1efa4a-cb44-4913-a35f-0a779ee0ee2a
# ╟─73339eae-4754-49b1-938a-5ceae1c0f6a3
# ╟─b7025b0c-5010-47f7-9c73-789c9335987a
# ╠═150ad79c-42b4-4981-8711-1ef426725ca0
# ╠═714e9893-f609-4a24-a020-0041f5361a2d
# ╠═8db7e80c-a877-44ff-aa15-48841c035aeb
# ╠═95f00b9b-646c-4ac5-b6fd-16f84a89d7b9
# ╠═731aa7ca-d4af-4be8-8a40-2eec5522ad99
# ╟─7e97208a-d1b0-435e-8756-f0b468b1c795
# ╠═140e78ee-a3af-46c7-9ad3-dfac7cf56bc4
# ╟─97d5f945-f0fe-4e2e-8bc3-6a562caf31eb
# ╠═7254bd30-87b7-48e9-99f8-56159dc78ad4
# ╠═e6a69b7f-dfb5-45db-a0fc-e4d24229f6c3
# ╟─b6fda0b6-2ea2-4f2f-961b-65936c050852
# ╠═706e727c-f29b-4cdb-ae08-cddd5725cdae
# ╠═2b7d0b48-70de-40fd-bf43-660e70f2416e
# ╟─1cf1668b-220e-4813-af3b-fef0f938e29b
# ╠═358250f0-94b7-48a8-acde-1c1f2734c967
# ╠═538f4130-f6e1-43c2-8020-f7f2488e2442
# ╠═3766c9b6-0ff5-4b0d-bc85-2c9bfe0a1d50
# ╠═84bb8887-9df3-4ff0-ab50-eb144cd2f118
# ╟─0cd52b1c-6e27-4dcf-a7e6-441745238e3e
# ╠═a8ca27fa-bd58-4163-895f-bf44a4392476
# ╟─44b6cef9-6ea5-4540-aca3-61c2712e44fd
# ╟─3836b76c-5f05-487e-bcc1-e5261629c1fc
# ╠═fe3227b9-b6e6-47ce-9dad-e817d1c5b171
# ╠═34014cf8-ad86-47c2-975d-8d4f88e67e91
# ╟─7c8b7c1d-1e23-49c6-be97-32c9f2e38041
# ╠═9410ff1c-daf0-48de-be8a-f31c5a76dbed
# ╠═6bf0a86b-2d41-49e1-bea9-bf82cddcbc7a
# ╠═c1bcd8d6-26c0-45af-98c2-c626384018e6
# ╠═4462e7ca-18f7-4f9d-8198-0196dac76c7d
# ╠═06846d34-23ba-4916-872f-3bcf62f579fa
# ╠═bc018df0-02ea-4011-ad6e-2176e4a1b232
# ╠═965efc63-8dac-4397-8052-312bccd4e736
# ╠═bd99f22b-51f2-48fe-8391-b1e37498e7ff
# ╟─c44ce267-d9d7-46ea-a6f2-54170cda5409
# ╠═abd380fc-5018-462c-8641-3fc269e0d2cb
# ╠═8a67cb77-a84f-4750-9099-56b5ef8ae038
# ╠═d0fac6ee-0507-4a55-907c-a86136e48e65
# ╠═f29a4f6f-d090-4be8-9d0f-14369c35b6b3
# ╠═863f12ad-c33c-4888-ba69-2c69f55edd07
# ╟─20f492e1-1b1b-4852-8e40-37d4bd96c2a3
# ╟─923f3c7d-9b17-4458-9ee3-8dd0e36f8452
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
