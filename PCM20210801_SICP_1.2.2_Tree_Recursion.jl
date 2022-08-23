### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 278e5870-f2d8-11eb-2a98-778e66257fe8
md"
==================================================================================
### SICP: [1.2.2 Tree Recursion](https://sarabander.github.io/sicp/html/1_002e2.xhtml#g_t1_002e2_002e2)

###### file: PCM20210801_SICP_1.2.2_Tree_Recursion.jl

###### Julia/Pluto.jl-code by PCM *** 2022/08/23 ***
==================================================================================
"

# ╔═╡ 0590f521-7f8b-44e8-9be5-47ae38eca638
md"
#### 1.2.2.1 Fibonacci Numbers
"

# ╔═╡ 50673baf-a7e9-4ea0-88b0-9754b904bf9f
md"
##### 1.2.2.1.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ 841f21aa-f09a-4fff-8128-49fe9890f4f7
md" 
$$fib(n) := \cases{ 
0 \;\;\;\;\; \text{ if } n = 0 \cr
1 \;\;\;\;\; \text{ if } n = 1 \cr
fib(n-1) + fib(n-2) \cr
}$$
" 

# ╔═╡ cb14ed53-f150-467c-b4df-9d4270c8896e
md"
###### 1st *untyped* (default) method of function fib
"

# ╔═╡ b8bc83b5-a720-4f33-a32a-8284129b5fd9
function fib(n) 
	n == 0 ? 0 :
    n == 1 ? 
		1 : 
		+(fib(n-1), fib(n-2))
end # function fib

# ╔═╡ 739f010a-7623-411b-9376-9222b3183039
fib(0)

# ╔═╡ 16dc2f1b-99f4-4a67-894a-523666117feb
fib(1)

# ╔═╡ 90de1d05-0121-4e85-8674-00f18b4a0a9e
fib(4)

# ╔═╡ 36b39dd5-076c-4d36-a8f7-ed6a47a5b870
fib(5)

# ╔═╡ 9ffb96a7-0ae0-4eb0-a964-af1c4c507493
fib(8)

# ╔═╡ e1171307-9f2d-4157-b030-dbf4c60d4ee2
md" 
---
                                            fib(5)
                                               |
                              +-------------------+--------------------+
                              |                                        |
                           fib(4)                                   fib(3)
                              |                                        |
                   +----------+----------+                   +---------+---------+
                   |                     |                   |                   |
                fib(3)                fib(2)              fib(2)              fib(1)
                   |                     |                   |                   |
             +-----+-----+         +-----+-----+       +-----+-----+             1
             |           |         |           |       |           |       
          fib(2)      fib(1)    fib(1)      fib(0)  fib(1)      fib(0)     
	         |           |         |           |       |           |
	   +-----+-----+     1         1           0       1           0
       |           |      
    fib(1)      fib(0)    
       |           |
       1           0

Fig. 1.2.2.1 (SICP Fig. 1.5, modified): The *tree-recursive* process generated in computing *fib(5)*

---
"

# ╔═╡ 9592052b-6af8-45bb-94a3-57a43cacd085
fib(8)

# ╔═╡ 9d2d9e38-a34d-4df9-9b98-8bae8a251052
md"
$$\psi := \frac{1-\sqrt{5}}{2}$$
$$f : \mathbb N \rightarrow \mathbb N$$
$$f : n \mapsto f_n$$
$$f_n := \left(\frac{\psi^n}{\sqrt{5}}\right) \text{ for } n \ge 0$$
more info can be found [here](https://en.wikipedia.org/wiki/Fibonacci_number)
"

# ╔═╡ 59f4bd16-f5fd-43a0-9130-733b318bb850
function fib2(n)
	ψ = /(+(1.0, √5.0), 2.0)    # a Float number is generated
	return round(/(ψ^n, √5))
end

# ╔═╡ 45e8c4f6-c97a-4253-9913-5bdcb51ab6c9
fib2(0)

# ╔═╡ d1ad1750-aeb2-4bb8-8b2e-0be44987e3a4
typeof(fib2(0))

# ╔═╡ 7270c38a-d48b-46ae-a3cd-b713c45e57fb
fib2(1)

# ╔═╡ d5bff174-f4df-4478-9c3f-a4c387c1ae04
fib2(5)

# ╔═╡ 0ad1f4c3-a4aa-4c1b-ac1c-fe18b42f6cdb
fib2(5.0)

# ╔═╡ f3d63b59-55b7-48a6-94c4-8386c64d835a
fib2(6)

# ╔═╡ dc37aeff-16df-4ae4-8c45-5fdba118dc7c
fib2(7)

# ╔═╡ 6a868b75-10be-44ae-b617-acb0befa24e2
fib2(8)

# ╔═╡ 584371d1-31bc-474b-b2bd-8bdfadecf398
#---------------------------------------------------------------------------
# two definitions in one cell blocked by 'begin ... end'
#---------------------------------------------------------------------------
begin
	#-----------------------------------------------------
	fib3(n) = fib_iter(1, 0, n)
	#-----------------------------------------------------
	fib_iter(a, b, count) = 
		count == 0 ? b : fib_iter(+(a, b), a, -(count, 1))
	#-----------------------------------------------------
end

# ╔═╡ b3bf7014-b05b-4bb4-8201-338763dccb77
fib3(0)

# ╔═╡ 61adc0e2-5c49-40bb-b64d-01072208c229
fib3(1)

# ╔═╡ ee6c42f5-39ae-4c1e-a07b-ef344329d33e
fib3(5)

# ╔═╡ ec4a7ae0-7a9b-476a-bcaf-24bda07b34c8
fib3(8)

# ╔═╡ 757d1174-00d3-46c4-aa46-8a853360259a
function fib4(n::Signed)::Signed
  #----------------------------------------------------
  fib_iter(a, b, count) = 
  	count == 0 ? b : fib_iter(+(a, b), a, -(count, 1))
  #----------------------------------------------------
  fib_iter(1, 0, n)
end # function fib4

# ╔═╡ 28d79756-1250-4980-a191-b4ffc587992f
fib4(0)

# ╔═╡ c2187fd6-0883-4e38-b6a9-deae30031b33
fib4(1)

# ╔═╡ da71e085-d3b1-403b-9ab3-05b376d88b6a
fib4(5)

# ╔═╡ 381d538b-43a5-443e-91b8-805c7789bf41
fib4(8)

# ╔═╡ 81aa817d-683e-4d13-bad6-2a9a5cb1959a
md"
##### 1.2.2.1.2 idiomatic *imperative* Julia 
###### ... with *abstract* types 'Signed', 'AbstractFloat', *self-defined* abstract type 'FloatOrSigned', while' and parallel assignment
"

# ╔═╡ d55f4dd8-c5c5-4fab-8cbc-a56f6f6628ea
md"
###### 2nd *typed* (specialized) method of function fib
"

# ╔═╡ 7efd9e26-7ede-49fe-8d06-0f30a3c76d56
#-------------------------------------------------------------------------
function fib5(n::Signed)::Signed
#-------------------------------------------------------------------------
  # fib_iter(a, b, count) = count == 0 ? b : fib_iter(a + b, a, count - 1)
#-------------------------------------------------------------------------
  # fib_iter(1, 0, n)
#-------------------------------------------------------------------------
	a     = 1
	b     = 0
	count = n
	while !(count == 0)
		a, b, count = a + b, a, count - 1
	end
	# in the case 'count == 0'
	b
end

# ╔═╡ 5cb9879c-1b3a-401b-8df6-ddb969b47e7e
fib5(0)

# ╔═╡ 81aad473-3889-4965-8ccd-9679ab73c5a1
typeof(fib5(0))

# ╔═╡ 62636351-2d00-4abe-ae75-8fba9d53a68f
Int64 <: Signed

# ╔═╡ 31c99f8f-ed87-4ce8-a185-6a867e730390
fib5(1)

# ╔═╡ 3f0ed8a8-c55a-4b25-9be3-0c937a82f2c7
fib5(5)

# ╔═╡ ec9121dd-b356-4abf-bb66-cb5a3d2135a8
fib5(8)

# ╔═╡ 6e202d14-83e8-4c54-8f60-b768234cd44c
fib5(8.)               # Float is blocked !

# ╔═╡ 25b5b92f-1133-4d6a-a7fb-46e3bd7ac743
md"
###### ... with 'for' and parallel assignment
"

# ╔═╡ d86a5807-c5a9-4013-b9b2-34ff55cdbdb3
md"
###### 3rd *typed* (even more specialized) method of function fib
"

# ╔═╡ cca61987-5ff2-43d5-a13d-850786905127
#---------------------------------------------------------------------------
# idiomatic Julia: 'for' and parallel assignment
#---------------------------------------------------------------------------
function fib6(n::Signed)::Signed
	a     = 1
	b     = 0
	for count = n:-1:1
		a, b = a + b, a
	end
	b
end

# ╔═╡ 38913d58-3f78-4039-bb93-ab64b4e5e1c4
fib6(0)

# ╔═╡ aca4a8a1-bc10-4abb-af38-941f3de29769
fib6(1)

# ╔═╡ c0786dd7-c833-4218-9fc1-3c05ee85df0e
fib6(5)

# ╔═╡ 39f932a8-6d42-4c25-9f30-e19e0b262a6c
fib6(8)

# ╔═╡ 5c44c7be-fd22-4859-8a03-434eb6564942
md"
###### 4th *typed* (*less* specialized) method of function fib
"

# ╔═╡ a863f97c-18b0-4e89-b2d8-e3e83eab9c0b
FloatOrSigned = Union{AbstractFloat, Signed}

# ╔═╡ e333e3b5-66cf-4d59-b031-5e0676d4fbad
function fib7(n::FloatOrSigned)::AbstractFloat
	ψ = (1.0 + √5.0) / 2.0    # a Float number is generated
	return round(ψ^n/√5)
end

# ╔═╡ 7fe95fc6-8704-432c-b101-55dcb0bd8777
fib7(5)

# ╔═╡ 7b75e150-69a0-4754-b47c-55f20396c2a1
fib7(5.0)

# ╔═╡ 3d3f7a93-dfa9-4424-8032-e4eeb792fece
fib7(8)

# ╔═╡ ae8463f2-09d6-442d-bbc7-cd4faf310fd9
fib7(8.0)

# ╔═╡ 3725f0ec-af0c-4c09-b124-0370d4bd8735
md"
---
#### 1.2.2.2 Example: Counting Change
##### 1.2.2.2.1 SICP-Scheme- *functional* Julia
"

# ╔═╡ e57f1017-ce3c-4f87-bc53-32466fd6f42b
md"
###### 1st *untyped* (default) method of function 'count_change'
"

# ╔═╡ b72f34e9-9106-4288-a5de-7488e83b6f16
first_denomination(kinds_of_coins) =
  kinds_of_coins == 1 ?  1 : # penny
  kinds_of_coins == 2 ?  5 : # nickel
  kinds_of_coins == 3 ? 10 : # dime
  kinds_of_coins == 4 ? 25 : # quarter
  kinds_of_coins == 5 ? 50 : # half_dollar
               "arg too big"
 

# ╔═╡ a60f0256-414b-4242-937f-b27b2d4bc18d
function cc(amount::Signed, kinds_of_coins::Signed)::Signed
	if amount == 0 
		1 
	elseif <(amount, 0) || ==(kinds_of_coins, 0) 
		0 
	else 
		cc(amount, -(kinds_of_coins, 1)) + 
		cc(-(amount, first_denomination(kinds_of_coins)), kinds_of_coins)
	end # if
end

# ╔═╡ 045cbbbc-161b-4460-8712-86b43d354418
count_change(amount) = cc(amount, 5)

# ╔═╡ 18f680ee-1bcf-4160-b0c4-543e40746d06
count_change(100)

# ╔═╡ 14028c89-9ca8-4d80-b84f-e3008b1e5dd3
md"
##### my alternative *recursive* solution
"

# ╔═╡ 26eb2d1c-1973-4ac8-9668-bbb13b4a3a36
md"
###### 1st *untyped* (default) method of function 'my_count_change' ...
###### ... with default parameter value
"

# ╔═╡ a76d6928-2136-4ac7-a1c4-dc50926005af
function my_count_change(amount, coin=50) # default parameter value 50
	#-------------------------
	next_smaller_coin(coin) =
	  coin == 50 ? 25 :
      coin == 25 ? 10 :
      coin == 10 ?  5 : 
      coin ==  5 ?  1 : 0
	#-------------------------
  amount == 0 ? 1 :
  coin   == 0 ? 0 :
  <(amount, coin) ? my_count_change(amount, next_smaller_coin(coin)) :
  ≥(amount, coin) ? 
  	+(my_count_change(-(amount, coin), coin),
	  my_count_change(amount, next_smaller_coin(coin))) : 
  	"error"
end # function

# ╔═╡ 5b73c7a1-2fd0-46cd-90d0-b7a3878b8656
my_count_change(4)

# ╔═╡ f6712d01-4c61-47e7-8061-2fac2584c7ef
my_count_change(5)

# ╔═╡ 5884909d-f49c-45e2-80e3-fb99521db0e4
my_count_change(10)

# ╔═╡ d0eb27b8-8903-4e42-ab91-8627e289e759
my_count_change(100)

# ╔═╡ 207dc946-a64a-4b2d-83e7-9fbec8aabacd
md"
##### 1.2.2.2.2 idiomatic *imperative* Julia

... this is missing and has to follow ...
"

# ╔═╡ 01193090-2008-4ebf-a72a-9bb6a13b4c00
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/23
- **Wikipedia**, Fibonacci Numbers, [https://en.wikipedia.org/wiki/Fibonacci_number](https://en.wikipedia.org/wiki/Fibonacci_number), last visit, 2022/08/23
"

# ╔═╡ 641439d6-9442-4e2a-9696-3153d1fd27f7
md"
---
###### end of ch. 1.2.2
===================================================================================

This is a **draft**. Comments, suggestions and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─278e5870-f2d8-11eb-2a98-778e66257fe8
# ╟─0590f521-7f8b-44e8-9be5-47ae38eca638
# ╟─50673baf-a7e9-4ea0-88b0-9754b904bf9f
# ╟─841f21aa-f09a-4fff-8128-49fe9890f4f7
# ╟─cb14ed53-f150-467c-b4df-9d4270c8896e
# ╠═b8bc83b5-a720-4f33-a32a-8284129b5fd9
# ╠═739f010a-7623-411b-9376-9222b3183039
# ╠═16dc2f1b-99f4-4a67-894a-523666117feb
# ╠═90de1d05-0121-4e85-8674-00f18b4a0a9e
# ╠═36b39dd5-076c-4d36-a8f7-ed6a47a5b870
# ╠═9ffb96a7-0ae0-4eb0-a964-af1c4c507493
# ╟─e1171307-9f2d-4157-b030-dbf4c60d4ee2
# ╠═9592052b-6af8-45bb-94a3-57a43cacd085
# ╟─9d2d9e38-a34d-4df9-9b98-8bae8a251052
# ╠═59f4bd16-f5fd-43a0-9130-733b318bb850
# ╠═45e8c4f6-c97a-4253-9913-5bdcb51ab6c9
# ╠═d1ad1750-aeb2-4bb8-8b2e-0be44987e3a4
# ╠═7270c38a-d48b-46ae-a3cd-b713c45e57fb
# ╠═d5bff174-f4df-4478-9c3f-a4c387c1ae04
# ╠═0ad1f4c3-a4aa-4c1b-ac1c-fe18b42f6cdb
# ╠═f3d63b59-55b7-48a6-94c4-8386c64d835a
# ╠═dc37aeff-16df-4ae4-8c45-5fdba118dc7c
# ╠═6a868b75-10be-44ae-b617-acb0befa24e2
# ╠═584371d1-31bc-474b-b2bd-8bdfadecf398
# ╠═b3bf7014-b05b-4bb4-8201-338763dccb77
# ╠═61adc0e2-5c49-40bb-b64d-01072208c229
# ╠═ee6c42f5-39ae-4c1e-a07b-ef344329d33e
# ╠═ec4a7ae0-7a9b-476a-bcaf-24bda07b34c8
# ╠═757d1174-00d3-46c4-aa46-8a853360259a
# ╠═28d79756-1250-4980-a191-b4ffc587992f
# ╠═c2187fd6-0883-4e38-b6a9-deae30031b33
# ╠═da71e085-d3b1-403b-9ab3-05b376d88b6a
# ╠═381d538b-43a5-443e-91b8-805c7789bf41
# ╟─81aa817d-683e-4d13-bad6-2a9a5cb1959a
# ╟─d55f4dd8-c5c5-4fab-8cbc-a56f6f6628ea
# ╠═7efd9e26-7ede-49fe-8d06-0f30a3c76d56
# ╠═5cb9879c-1b3a-401b-8df6-ddb969b47e7e
# ╠═81aad473-3889-4965-8ccd-9679ab73c5a1
# ╠═62636351-2d00-4abe-ae75-8fba9d53a68f
# ╠═31c99f8f-ed87-4ce8-a185-6a867e730390
# ╠═3f0ed8a8-c55a-4b25-9be3-0c937a82f2c7
# ╠═ec9121dd-b356-4abf-bb66-cb5a3d2135a8
# ╠═6e202d14-83e8-4c54-8f60-b768234cd44c
# ╟─25b5b92f-1133-4d6a-a7fb-46e3bd7ac743
# ╟─d86a5807-c5a9-4013-b9b2-34ff55cdbdb3
# ╠═cca61987-5ff2-43d5-a13d-850786905127
# ╠═38913d58-3f78-4039-bb93-ab64b4e5e1c4
# ╠═aca4a8a1-bc10-4abb-af38-941f3de29769
# ╠═c0786dd7-c833-4218-9fc1-3c05ee85df0e
# ╠═39f932a8-6d42-4c25-9f30-e19e0b262a6c
# ╠═5c44c7be-fd22-4859-8a03-434eb6564942
# ╠═a863f97c-18b0-4e89-b2d8-e3e83eab9c0b
# ╠═e333e3b5-66cf-4d59-b031-5e0676d4fbad
# ╠═7fe95fc6-8704-432c-b101-55dcb0bd8777
# ╠═7b75e150-69a0-4754-b47c-55f20396c2a1
# ╠═3d3f7a93-dfa9-4424-8032-e4eeb792fece
# ╠═ae8463f2-09d6-442d-bbc7-cd4faf310fd9
# ╟─3725f0ec-af0c-4c09-b124-0370d4bd8735
# ╟─e57f1017-ce3c-4f87-bc53-32466fd6f42b
# ╠═045cbbbc-161b-4460-8712-86b43d354418
# ╠═a60f0256-414b-4242-937f-b27b2d4bc18d
# ╠═b72f34e9-9106-4288-a5de-7488e83b6f16
# ╠═18f680ee-1bcf-4160-b0c4-543e40746d06
# ╟─14028c89-9ca8-4d80-b84f-e3008b1e5dd3
# ╟─26eb2d1c-1973-4ac8-9668-bbb13b4a3a36
# ╠═a76d6928-2136-4ac7-a1c4-dc50926005af
# ╠═5b73c7a1-2fd0-46cd-90d0-b7a3878b8656
# ╠═f6712d01-4c61-47e7-8061-2fac2584c7ef
# ╠═5884909d-f49c-45e2-80e3-fb99521db0e4
# ╠═d0eb27b8-8903-4e42-ab91-8627e289e759
# ╟─207dc946-a64a-4b2d-83e7-9fbec8aabacd
# ╟─01193090-2008-4ebf-a72a-9bb6a13b4c00
# ╟─641439d6-9442-4e2a-9696-3153d1fd27f7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
