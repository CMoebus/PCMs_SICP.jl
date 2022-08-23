### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 247b3f72-f140-11eb-1cc0-65305255e94d
md"
====================================================================================
 ### SICP: [1.1.8 Procedures as BlackBox Abstractions](https://sarabander.github.io/sicp/html/1_002e1.xhtml#g_t1_002e1_002e8)

 ###### file: PCM20210730\_SICP\_1.1.8\_Procedures\_as\_BlackBox\_Abstractions

 ###### code by PCM *** 2022/08/23 ***
====================================================================================
"

# ╔═╡ 63de4724-4ea2-4f4a-9466-9f6cccfcc41b
md"
#### 1.1.8.1 SICP-Scheme like *functional* Julia
"

# ╔═╡ 4dc5d5d4-2b79-4a03-a99c-253a75bf92dd
square2(x) = *(x, x)

# ╔═╡ a6aafcd5-fca2-40b8-999d-e58284d34930
double(x) = +(x, x)

# ╔═╡ 8db19333-ba11-4591-a9f0-30da76591df7
square3(x) = exp10( double( log(10, x)))

# ╔═╡ 9b827f29-0a1b-45be-b4e9-d2b5217353b4
square2(3)

# ╔═╡ 7028b168-50df-4a93-a4f6-ef2796f24904
square3(3)

# ╔═╡ f66c8a81-d659-4c25-a548-b34ec9cd6bf4
md"
---
                                   sqrt
                                     |
                                     |
                                 sqrt_iter
                                     |
                      +--------------+--------------+
                      |                             |             
                  good_enough                    improve
                      |                             |
               +------+------+                      |
               |             |                      |
            square          abs                  average


Fig. 1.1.8.1 Procedural decomposition of sqrt script (inspired by Fig.1.2, p.27, SICP, 1996, 2/e)

---
"

# ╔═╡ bc6c7b05-15ad-4bfd-8f73-58301ec900c4
md"
###### 1st (default) *untyped* method of function 'sqrt'
"

# ╔═╡ a07e17ab-c15c-4928-a359-cc8fe507b49e
square(x) = *(x, x)

# ╔═╡ cb4b3323-c734-4ac5-9279-df1c501c31eb
good_enough(guess, x) =
	<( abs( -( square( guess), x)), 0.001)

# ╔═╡ 646d8856-b315-444b-a014-26da6eee1115
average(x, y) = /(+(x, y), 2)

# ╔═╡ 483f6b61-1d25-4a53-a2d1-640ea0165e7e
improve(guess, x) =
	average(guess, /(x, guess))

# ╔═╡ 64b11119-0b26-403c-9d03-70f1e17f13ae
function sqrt_iter(guess, x)
	if good_enough(guess, x)
		guess
	else sqrt_iter(improve(guess, x), x)
	end # if
end # function

# ╔═╡ 1789e69a-0688-4eb5-b316-0d1377c7a1f3
sqrt(x) = sqrt_iter(1.0, x)

# ╔═╡ 0fab7f8c-c6c9-41cd-9c1c-e671375c03d8
md"
###### Internal definitions and block structure
"

# ╔═╡ cf1b0ca4-b67d-40da-8cec-64678193cf19
function sqrt2(x)
	#-----------------------------------------------------
	square(x) = *(x, x)
	#-----------------------------------------------------
	good_enough(guess, x) = 
		<(abs(-(square(guess), x)), 0.001)
	#-----------------------------------------------------
	improve(guess, x) = average(guess, /(x, guess))
	#-----------------------------------------------------
	average(x, y) = /(+(x, y), 2)
	#-----------------------------------------------------
	sqrt_iter(guess, x) =
		if good_enough(guess, x)
			guess
		else
			sqrt_iter(improve(guess, x), x)
		end # if
	#-----------------------------------------------------
	sqrt_iter(1.0, x)
end

# ╔═╡ 65bd3a2d-31a9-448e-8253-7f235dabe1e1
sqrt2(9)               # input Integer but output Float

# ╔═╡ 4ccea492-30cb-440b-b82b-ef11205dfa93
sqrt2(9.0)

# ╔═╡ 016d9b55-3195-4ade-8489-a0729c544ccf
sqrt2(+(100, 37))        # input Integer but output Float

# ╔═╡ 027fb073-d175-4ffd-8321-c0750bf2c3df
sqrt2(+(sqrt2(2), sqrt2(3)))

# ╔═╡ f019a661-ef78-4a27-a731-07f8113371ef
square(sqrt2(1000.0))

# ╔═╡ 8f2a4ee9-da69-4edd-bf8a-0b2c79d62b52
md"
###### lexical scoping: suppression of parameter x
"

# ╔═╡ 7bb2c6d0-bf3c-4b8c-b6c1-8e1cf1d558a1
function sqrt3(x)
	#-----------------------------------------------------
	square(x) = *(x, x)
	#-----------------------------------------------------
	good_enough(guess) = 
		<(abs(-(square(guess), x)), 0.001)
	#-----------------------------------------------------
	improve(guess) = average(guess, /(x, guess))
	#-----------------------------------------------------
	average(x, y) = /(+(x, y), 2)
	#-----------------------------------------------------
	sqrt_iter(guess) =
		if good_enough(guess)
			guess
		else
			sqrt_iter(improve(guess))
		end # if
	#-----------------------------------------------------
	sqrt_iter(1.0)
end

# ╔═╡ 163e39ce-db7d-4687-9e99-678e83feef91
sqrt3(9)

# ╔═╡ ea19039c-a0ea-45f6-bd37-ddfaec8a39d7
sqrt3(+(100, 37))

# ╔═╡ b06503ac-ae1e-455c-93d2-1304cff81720
sqrt3(+(sqrt3(2), sqrt3(3)))

# ╔═╡ 0f5e87c1-3aa9-404a-b3e9-16104a64748c
square(sqrt3(1000.0))

# ╔═╡ e19e7261-4b1f-468f-b1b8-630fe9705b50
md"
#### 1.1.8.2 idiomatic *imperative* Julia ...
###### ... with *infix* operators, abstract type AbstractFloat, *self-defined* type FloatOrInteger, 'while' instead of *tail-recursive* sqrt_iter
"

# ╔═╡ 7b691f02-7735-4ed9-a703-50fdb753cc5a
md"
                         Number
			                |
      +---------------------+---------------------+
      |                                           |
    Complex                                      Real
                                                  |
		      +-------------------------+---------+---------+----------------+
	          |                         |                   |                |
         AbstractFloat               Integer            Rational    AbstractIrrational
		      |                         |                                    |
      +-------+-------+          +------+------+                        Irrational
      |       |       |          |      |      |
    Float64 Float32 Float16   Signed  Bool  Unsigned
                                 |
					      +------+------+
	                      |      |      |
			            Int64  Int32  Int16

 Fig. 1.1.8.1 Excerpt from **Julia's type hierarchy** (a more complete excerpt can be found  in Nazarathy & Klok, 2021, p.11)
"

# ╔═╡ c92b65b4-2fbe-4b50-8fa5-e91f4dc2ec40
FloatOrInteger = Union{AbstractFloat, Integer}

# ╔═╡ 81990868-f302-426d-8822-d38e052db1ca
md"
###### 2nd (specialized) *typed* method of function 'sqrt'
"

# ╔═╡ 139c478d-cc8a-4042-bfca-764ed2b5a436
# idiomatic JULIA with 'while' instead of tail-recursive sqrt_iter
# Supressing local variable *x* from *good_enough*, *improve*, and *sqrt_iter*
#-----------------------------------------------------------------
function sqrt(x::FloatOrInteger)::FloatOrInteger
	#-----------------------------------------------------
	good_enough(guess) = abs(guess^2 - x) < 0.001
	#-----------------------------------------------------
	average(x, y) = (x + y) / 2
	#-----------------------------------------------------
	improve(guess) = average(guess, x / guess)
	#-----------------------------------------------------
	guess = 1.0
	while !good_enough(guess)
		guess = improve(guess)
	end
	guess
	#-----------------------------------------------------
end

# ╔═╡ 6dc9e10f-7fab-4c46-97b9-e8ad754a5793
md"
###### 3rd (more specialized) *typed* method of function 'sqrt'
"

# ╔═╡ 93907e76-f350-4871-a199-bfed96d6a96f
# supression of good_enough
function sqrt(x::AbstractFloat)::AbstractFloat       
	#-----------------------------------------------------
	improve(guess, x) = average(guess, x / guess)
	#-----------------------------------------------------
	average(x, y) = (x + y) / 2
	#-----------------------------------------------------
	guess = 1.0
	while !(abs(guess^2 - x) < 0.001)
		guess = improve(guess, x)
	end
	guess
end

# ╔═╡ b9888441-37ee-4ea1-b3e8-ad37aaceee3b
md"
###### 3rd (even more specialized) *typed* method of function 'sqrt'
###### ... with 'while', *optional* argument 'epsilon', and *default* value 
"

# ╔═╡ 5d147aa7-f2cc-4adf-9cce-3c90c27a7aad
#-------------------------------------------------------------------------------
# idiomatic JULIA with:
#   - optional argument 'epsilon'
#   - default value '0.001'
#   - 'while'
#-------------------------------------------------------------------------------
function sqrt(x::FloatOrInteger, epsilon::AbstractFloat = 0.001)::AbstractFloat 
	#-----------------------------------------------------
	good_enough(guess) = abs(guess^2 - x) < 0.001
	#-----------------------------------------------------
	average(x, y) = (x + y) / 2
	#-----------------------------------------------------
	improve(guess) = average(guess, x / guess)
	#-----------------------------------------------------
	guess = 1.0
	while !good_enough(guess)
		guess = improve(guess)
	end
	guess
	#-----------------------------------------------------
end
#-------------------------------------------------------------------------------

# ╔═╡ aabe51ab-64b3-4bb3-8a56-da10740ea003
sqrt(9)  

# ╔═╡ ab9f5330-b100-4e1d-944c-2ffb99172547
sqrt(9.0)  

# ╔═╡ c919014f-85e2-4bc4-9aab-19f161a8fdcb
sqrt(100 + 37) 

# ╔═╡ bb5cd0ec-3ed3-4b87-a8d7-7bd07eb90e37
sqrt(+(sqrt(2), sqrt(3)))

# ╔═╡ 002f1323-bb24-42b6-9f84-ccc5998883d6
square(sqrt(1000.0))

# ╔═╡ e97c95c3-2547-423c-9b9b-1bed7e4020df
sqrt(9)

# ╔═╡ 7c9fe810-e149-4036-aa1f-94ec6a5ea0df
sqrt(9.0)

# ╔═╡ 4fe6de90-878b-4cd8-8ad9-22c6af5f66ca
sqrt(100 + 37)

# ╔═╡ 0f6bea73-b02f-426d-8a71-341d7d5e88b1
sqrt(sqrt(2) + sqrt(3))

# ╔═╡ a5a49f2b-2316-40b1-adcf-ab0e375b41ab
sqrt(1000.0)^2

# ╔═╡ f4cb0890-f2e0-4253-a15f-ad0faa95fc4a
sqrt(9, 1E-6)                    # overriding the default epsilon

# ╔═╡ a31fc3c8-15ff-47ce-be26-e2ee52b33695
sqrt(9.0, 1.0E-6)                # overriding the default epsilon

# ╔═╡ 8b631b5f-8024-480e-9898-69d1024c34bc
sqrt(100 + 37, 1.0E-7)           # overriding the default epsilon

# ╔═╡ 7d6a9cf8-b6f9-45d6-9318-c833f1088e93
sqrt(100.0 + 37.0, 1.0E-7)       # overriding the default epsilon

# ╔═╡ 8a97c3a8-fe9c-4275-ad8f-af4069182e7c
sqrt(sqrt(2) + sqrt(3), 1.0E-8)  # overriding the default epsilon

# ╔═╡ 7f65d209-5eeb-4169-9ec3-ba821fdc54e7
sqrt(sqrt(2., 1.0E-6) + sqrt(3., 1.0E-6), 1.0E-6) # overriding the default epsilon

# ╔═╡ c7949084-7bec-48dc-9d07-16443655ec90
sqrt(1000, 1.0E-9)^2             # overriding the default epsilon

# ╔═╡ cae2b68c-f149-430f-bb87-9cc440e744b8
sqrt(1000.0, 1.0E-9)^2           # overriding the default epsilon

# ╔═╡ 71382b83-641c-4767-9823-0c2d8d64aec4
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/23

- **Nazarathy, Y. & Klok, H.**, Statistics with Julia, Springer, 2022, [https://link.springer.com/book/10.1007/978-3-030-70901-3](https://link.springer.com/book/10.1007/978-3-030-70901-3)

"

# ╔═╡ 2eae5547-9f09-43ac-a406-81740f900efc
md"
---
#### end of ch. 1.1.8
===================================================================================

This is a **draft**. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─247b3f72-f140-11eb-1cc0-65305255e94d
# ╟─63de4724-4ea2-4f4a-9466-9f6cccfcc41b
# ╠═4dc5d5d4-2b79-4a03-a99c-253a75bf92dd
# ╠═8db19333-ba11-4591-a9f0-30da76591df7
# ╠═a6aafcd5-fca2-40b8-999d-e58284d34930
# ╠═9b827f29-0a1b-45be-b4e9-d2b5217353b4
# ╠═7028b168-50df-4a93-a4f6-ef2796f24904
# ╟─f66c8a81-d659-4c25-a548-b34ec9cd6bf4
# ╟─bc6c7b05-15ad-4bfd-8f73-58301ec900c4
# ╠═1789e69a-0688-4eb5-b316-0d1377c7a1f3
# ╠═64b11119-0b26-403c-9d03-70f1e17f13ae
# ╠═a07e17ab-c15c-4928-a359-cc8fe507b49e
# ╠═cb4b3323-c734-4ac5-9279-df1c501c31eb
# ╠═646d8856-b315-444b-a014-26da6eee1115
# ╠═483f6b61-1d25-4a53-a2d1-640ea0165e7e
# ╠═aabe51ab-64b3-4bb3-8a56-da10740ea003
# ╠═ab9f5330-b100-4e1d-944c-2ffb99172547
# ╠═c919014f-85e2-4bc4-9aab-19f161a8fdcb
# ╠═bb5cd0ec-3ed3-4b87-a8d7-7bd07eb90e37
# ╠═002f1323-bb24-42b6-9f84-ccc5998883d6
# ╟─0fab7f8c-c6c9-41cd-9c1c-e671375c03d8
# ╠═cf1b0ca4-b67d-40da-8cec-64678193cf19
# ╠═65bd3a2d-31a9-448e-8253-7f235dabe1e1
# ╠═4ccea492-30cb-440b-b82b-ef11205dfa93
# ╠═016d9b55-3195-4ade-8489-a0729c544ccf
# ╠═027fb073-d175-4ffd-8321-c0750bf2c3df
# ╠═f019a661-ef78-4a27-a731-07f8113371ef
# ╟─8f2a4ee9-da69-4edd-bf8a-0b2c79d62b52
# ╠═7bb2c6d0-bf3c-4b8c-b6c1-8e1cf1d558a1
# ╠═163e39ce-db7d-4687-9e99-678e83feef91
# ╠═ea19039c-a0ea-45f6-bd37-ddfaec8a39d7
# ╠═b06503ac-ae1e-455c-93d2-1304cff81720
# ╠═0f5e87c1-3aa9-404a-b3e9-16104a64748c
# ╟─e19e7261-4b1f-468f-b1b8-630fe9705b50
# ╟─7b691f02-7735-4ed9-a703-50fdb753cc5a
# ╠═c92b65b4-2fbe-4b50-8fa5-e91f4dc2ec40
# ╟─81990868-f302-426d-8822-d38e052db1ca
# ╠═139c478d-cc8a-4042-bfca-764ed2b5a436
# ╟─6dc9e10f-7fab-4c46-97b9-e8ad754a5793
# ╠═93907e76-f350-4871-a199-bfed96d6a96f
# ╠═e97c95c3-2547-423c-9b9b-1bed7e4020df
# ╠═7c9fe810-e149-4036-aa1f-94ec6a5ea0df
# ╠═4fe6de90-878b-4cd8-8ad9-22c6af5f66ca
# ╠═0f6bea73-b02f-426d-8a71-341d7d5e88b1
# ╠═a5a49f2b-2316-40b1-adcf-ab0e375b41ab
# ╟─b9888441-37ee-4ea1-b3e8-ad37aaceee3b
# ╠═5d147aa7-f2cc-4adf-9cce-3c90c27a7aad
# ╠═f4cb0890-f2e0-4253-a15f-ad0faa95fc4a
# ╠═a31fc3c8-15ff-47ce-be26-e2ee52b33695
# ╠═8b631b5f-8024-480e-9898-69d1024c34bc
# ╠═7d6a9cf8-b6f9-45d6-9318-c833f1088e93
# ╠═8a97c3a8-fe9c-4275-ad8f-af4069182e7c
# ╠═7f65d209-5eeb-4169-9ec3-ba821fdc54e7
# ╠═c7949084-7bec-48dc-9d07-16443655ec90
# ╠═cae2b68c-f149-430f-bb87-9cc440e744b8
# ╟─71382b83-641c-4767-9823-0c2d8d64aec4
# ╟─2eae5547-9f09-43ac-a406-81740f900efc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
