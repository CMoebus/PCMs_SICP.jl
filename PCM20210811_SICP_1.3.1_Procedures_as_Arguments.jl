### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 9f3abf80-5f73-417c-a6a5-c787f4519eb6
using Plots

# ╔═╡ 015f86b0-fa99-11eb-0a32-5bee9e7368fb
md"
===================================================================================
#### SICP: [1.3.1 Procedures as Arguments](https://sarabander.github.io/sicp/html/1_002e3.xhtml#g_t1_002e3_002e1)
##### file: PCM20210811\_SICP\_1.3.1\_Procedures\_as\_Arguments.jl

##### Julia/Pluto.jl-code (1.9.3/19.27) by PCM *** 2023/08/31 ***
===================================================================================
"

# ╔═╡ acd01166-5258-4012-a6f4-e4f05b49dce3
md"
##### 1.3.1.1 SICP-Scheme-like *functional* Julia
"

# ╔═╡ e3414514-9956-416e-ad41-503795d32556
md"""
---
$cube: \mathbb N \cup \mathbb R \times \mathbb N \cup \mathbb R \rightarrow \mathbb N \cup \mathbb R$
$\;$

$x \mapsto cube(x)$

$\;$

$cube(x) := x^3$

$\;$

"""

# ╔═╡ f63fda47-0ee7-4fac-b90c-b4bd893daa7d
cube(x) = *(x, x, x)              # '*' is prefix operator   (SICP, p.57)

# ╔═╡ 7fcc1606-a914-458a-82ab-a3fa4f1b0b49
cube(3)                           # result is Integer

# ╔═╡ 590b9e77-9983-4e54-9914-4d6bb5ce8336
cube(3.)                          # result is Float

# ╔═╡ 6414c834-cfe4-4208-a4b1-7fbf3ced47df
md"
---
$sumIntegers : \mathbb N \cup \mathbb R \times \mathbb N \cup \mathbb R \rightarrow \mathbb N \cup \mathbb R$

$\;$

$(a, b) \mapsto sumIntegers(a, b)$

$\;$

$sumIntegers(a, b) := \sum_{i=a}^{b}i$

$\;$
$\;$
$\;$

"

# ╔═╡ df6d6fdc-20f1-4ead-8e3e-07340ddb521a
sumIntegers1(a, b) =                         # (SICP, p.57)
	>(a, b) ? 
		0 : 
		+(a, sumIntegers1(+(a, 1), b))

# ╔═╡ 5e22d368-1433-4ea1-b094-0188cb755c89
sumIntegers1(0, 0)                           # result is Integer

# ╔═╡ 27d6dbc2-349d-4848-a915-031f42b72d91
sumIntegers1(0., 0)                          # result is Float

# ╔═╡ 99bc5602-46d7-401e-a625-2efa10806042
sumIntegers1(0, 0.)                          # result is Integer

# ╔═╡ 3a7dc73f-9435-40ec-a58c-09600dcb834d
sumIntegers1(0., 0.)                         # result is Float

# ╔═╡ 0b466d51-d50d-45bf-8290-31414a36c3c5
sumIntegers1(2, 5)                           # result is Integer

# ╔═╡ 4e086e86-51c8-47ec-8810-55c253f3c92c
sumIntegers1(2., 5)                          # result is Float

# ╔═╡ dbaa23c2-accd-478e-83da-cb9383a2557b
sumIntegers1(2, 5.)                          # result is Integer

# ╔═╡ 381b81f0-7f5f-4312-b63a-fb654e1668e6
sumIntegers1(2., 5.)                         # result is Float

# ╔═╡ 0f94752d-afc7-4c19-96b8-f0e40edd8f6f
md"
---
$sumCubes : \mathbb N \cup \mathbb R \times \mathbb N \cup \mathbb R \rightarrow \mathbb N \cup \mathbb R$
$\;$
$(a, b) \mapsto sumCubes(a, b)$
$\;$
$sumCubes(a, b) := \sum_{i=a}^{b}i^3$
$\;$
$\;$
$\;$
"

# ╔═╡ a92d3b32-fc1c-4bd9-ba16-d650ffc805eb
sumCubes1(a, b) =                            # (SICP, p.57)
	>(a, b) ? 
		0 : 
		+(cube(a), sumCubes1(+(a, 1), b))

# ╔═╡ a8fbd1f3-9994-4e68-83e1-5272aa85f52f
sumCubes1(0, 1)

# ╔═╡ ce73399c-aa70-4116-beb2-4f861fc01031
sumCubes1(0, 3)       #  0 + 1 + 2*2*2 + 3*3*3 = 1 + 8 + 27 = 36

# ╔═╡ a890a15b-e0ac-4336-b666-17389f7bae8a
sumCubes1(1, 4)       #  36 + 4*4*4 = 36 + 64 = 100

# ╔═╡ 43ca7083-657d-499e-b273-0da40720342a
sumCubes1(1., 4)

# ╔═╡ fe6b263c-a804-4e64-9f19-78fe146abc5b
sumCubes1(1, 4.)

# ╔═╡ f33b6724-4bad-4b46-aff7-2763f51fb1a8
sumCubes1(1., 4.)

# ╔═╡ ac7668db-45f4-456c-a55b-b9106555fca4
md"
---
$\pi_{Sum}: \mathbb N \cup \mathbb R \times \mathbb N \cup \mathbb R \rightarrow \mathbb N \cup \mathbb R$
$\;$
$\pi_{Sum}: (a, b) \mapsto \pi_{Sum}(a, b)$
$\;$
$\pi_{Sum}(a, b) := \frac{1}{1\cdot3}+\frac{1}{5\cdot7}+\frac{1}{9\cdot11}+... \approx \frac{\pi}{8}$
$\;$
$\;$
see [here](https://en.wikipedia.org/wiki/List_of_formulae_involving_%CF%80) the list of formulae  involving π.
$\;$

"

# ╔═╡ fb0e59f2-a9c5-44c3-9d41-7cb8c0347bfb
piSum1(a, b) = 
	>(a, b) ? 
		0 : 
		+(/(1.0, *(a, +(a, 2))), piSum1(+(a, 4), b))

# ╔═╡ 2b2937e1-dba3-462c-a769-60804d676bf5
*(8, piSum1(1, 1))

# ╔═╡ e25a03e0-886c-4862-badb-bcb5be6f477a
myError(approxPi) = abs(pi - approxPi)

# ╔═╡ 31ea7745-7d46-4ade-97d1-41ce15f970f7
myError(*(8, piSum1(1, 1)))                                 # error

# ╔═╡ eb647d89-bbc8-42db-9265-5cfc9ad8a03c
*(8, piSum1(1, 10))

# ╔═╡ ba2a843a-a31a-4232-8c94-3893ec0ec760
myError(*(8, piSum1(1, 10)))                                # error

# ╔═╡ b6caf296-0dea-4572-9043-d515f71d6f93
myError(*(8, piSum1(1, 10^2)))                              # error

# ╔═╡ d6144688-4c14-4db3-8c49-65c9eaf7c30b
myError(*(8, piSum1(1, 10^3)))                              # error

# ╔═╡ 54b81d43-1219-45e9-abaa-805311268810
myError(*(8, piSum1(1, 10^4)))                              # error

# ╔═╡ 1745d75d-dcc8-4a32-b9a8-607f5da744d9
*(8, piSum1(1, ^(10, 5)))

# ╔═╡ ddae764c-b5c0-4eda-8c80-4f57fbeac486
myError(*(8, piSum1(1, ^(10, 5))))                          # error

# ╔═╡ e3c095b9-fc89-4b15-92e5-eb536d612e10
myError(*(8, piSum1(1, ^(10, 6))))   # StackOverflowError due to recursion !

# ╔═╡ fdcd0ad9-a81c-48c8-ab7d-8f8b70e38c4d
md"
---
$\sum_{i=a}^b f(i) = f(a) + ... + f(b)$

$\;$
$\;$
$\;$
"

# ╔═╡ da24559b-1937-4258-847d-e0f7b7a7c293
function sum1(term, a, next, b)                             # SICP, p.58
	if >(a, b)
		0
	else
		+(term(a), sum1(term, next(a), next, b))
	end # if
end # function sum1

# ╔═╡ b9c17500-0301-4a9f-8707-c18fda55261c
inc(n) = +(n, 1)                                            # SICP, p.58

# ╔═╡ 76174121-4f07-4e04-9bde-f98344fc1a1e
sumCubes2(a, b) = sum1(cube, a, inc, b)                     # SICP, p.59

# ╔═╡ 792c2312-2469-4844-b7b8-4acd42333a82
sumCubes2(0, 1) 

# ╔═╡ 39a8a3f7-391d-4adf-a217-9ce1db164099
sumCubes2(0, 3)                        #  0 + 1 + 2*2*2 + 3*3*3 = 1 + 8 + 27 = 36

# ╔═╡ eb294e7b-3eb4-4038-bf10-3870819dd2ae
sumCubes1(1, 10)                                            # SICP, p.59

# ╔═╡ 0779063c-bb2c-4060-84d7-e6268f9255a2
identity(x) = x                                             # SICP, p.59

# ╔═╡ d14308c5-374a-495d-8865-1f52e198fb5e
sum_integers2(a, b) = sum1(identity, a, inc, b)             # SICP, p.59

# ╔═╡ d195654c-302f-4c80-9d4b-0d95978b6a7c
sum_integers2(0, 6)

# ╔═╡ 33ea2359-475f-42ca-8de4-5f4e91148529
sum_integers2(1, 10)                                         # SICP, p.59

# ╔═╡ ae961cd1-bab0-41e2-9bc5-918d7346f82d
md"
---
##### 1.3.1.2 idiomatic *imperative* Julia ...
###### ... with *abstract* types 'Real', 'Integer', *self-defined*, 'while', '+='
" 

# ╔═╡ cb1cbf7f-98e0-49d4-b12e-ee8b8808d316
pi                                                           # Julia constant π

# ╔═╡ d0ea0cc2-fdc3-4055-a651-946a66cb7db0
typeof(pi)                                                   # Irrational !

# ╔═╡ 9fde9515-3848-44c1-b33b-de9bae9c77c6
subtypes(Real)

# ╔═╡ 890ab8e8-12df-4975-90a4-fda312d60ba2
# idiomatic Julia-code with 'Real', 'while', '+='
function sumIntegers2(a::Real, b::Real)::Real
	sum = 0
	while !(a > b)
		sum += a
		a += 1
	end # while
	sum
end # function sumIntegers2

# ╔═╡ 20c6c63f-6f04-4aa2-987a-e6789a916383
sumIntegers2(1, 10)

# ╔═╡ 38295b22-5dfb-4e3a-bdd7-e7b91c65d342
sumIntegers2(2, 10)                      # ==> Integer

# ╔═╡ 46466ddf-7b65-49f0-b8d0-d0039f1165e0
sumIntegers2(2., 10)                     # ==> Float

# ╔═╡ 76cbceaa-ff7b-4e49-8935-6eda98b68729
sumIntegers2(2, 10.)                     # ==> Integer

# ╔═╡ 8a4adbdc-2553-4f6a-8cb2-e0c3d35cca08
sumIntegers2(2., 10.) 

# ╔═╡ 81c0cc23-68f9-4d91-af01-38898e6d50af
# idiomatic Julia-code with 'Real, 'while', '+='
function sumCubes3(a::Real, b::Real)::Real
	#-------------------------------------------
	cube(x) = x^3
	#-------------------------------------------
	sum = 0
	while !(a > b)
		sum += cube(a)
		a += 1
	end # while
	sum
end # function sumCubes3

# ╔═╡ 732458d7-1938-4be1-9de2-8071d1ad644d
sumCubes3(0, 1)

# ╔═╡ 39c2206d-8a4d-49d0-a8d5-c7a744443000
sumCubes3(0, 3)       #  0 + 1 + 2*2*2 + 3*3*3 = 1 + 8 + 27 = 36

# ╔═╡ 4d0c6403-7588-4971-8046-1f99e3a421a6
sumCubes3(0, 4)       #  sumCubes3(0, 3) + 4^3 = 36 + 64 = 100

# ╔═╡ 1e034229-e2a0-420e-97e7-8a02a577fe5a
sumCubes1(1, 4)       #  36 + 4^3 = 36 + 64 = 100

# ╔═╡ 69618ff5-44f5-4d60-8297-cc15457a2ed8
# idiomatic Julia-code with 'Real','while', '+='
function piSum2(a::Real, b::Real)::Real
	sum = 0
	while !(a > b)
		sum += 1.0 / (a * (a + 2))  
		a += 4
	end # while
	sum
end # function piSum2

# ╔═╡ 3127686e-0c30-48e2-8c73-e7563ee60124
8 * piSum2(1, 10^5)

# ╔═╡ 5a847c91-d008-434c-98de-90a74335012c
myError(8 * piSum2(1, 10^5))

# ╔═╡ 9fbc3781-1cf3-4b94-bc93-b5d8c7e0ad24
myError(8 * piSum2(1, 10^8))

# ╔═╡ 23cf565a-21a1-407d-981d-1ddc433327a8
8 * piSum2(1, 10^10)

# ╔═╡ 5b4e0581-36b1-47d3-be06-a84cfee8788f
myError(8 * piSum2(1, 10^10))

# ╔═╡ 3a72d464-a12c-4de5-8c8c-7768c60bec3c
typeof(Function)

# ╔═╡ 28aab614-3469-43d8-ab48-6feb0d30be92
typeof(DataType)

# ╔═╡ 82a083c1-2637-49cc-ada1-2c006c26b39f
supertype(Function)

# ╔═╡ a9f09569-210d-4bbd-8b81-556f628d9220
subtypes(Function)

# ╔═╡ d4290924-cbe3-4f51-88f7-3aaacdfd6b4f
# idiomatic Julia-code with 'Function', 'Real', 'while', '+='
function sum2(term::Function, a::Real, next::Function, b::Real)::Real
	sum = 0
	while !(a > b)
		sum += term(a)
		a = next(a)
	end # while
	sum
end # function sum2

# ╔═╡ 7dc42461-ba3a-4837-ba37-e91920c8dc66
function piSum3(a::Real, b::Real)::Real
	#----------------------------------------------------------------
	piTerm(x) = 1.0 / (x * (x + 2))
	piNext(x) = x + 4
	#----------------------------------------------------------------
	sum2(piTerm::Function, a::Real, piNext::Function, b::Real)
end

# ╔═╡ 5967b1d1-0990-4ebc-ae8b-6e6ec00b4f5d
8 * piSum3(1, 10^6)

# ╔═╡ ba73b5bb-e803-4e5a-91d9-9c93da299930
8 * piSum3(1.0, 10.0^6)

# ╔═╡ 2a14bebd-8b53-442a-965f-983f040eeea3
md"
---
###### Integration by the [Trapezoidal Method](https://en.wikipedia.org/wiki/Trapezoidal_rule) 
$\;$

$\int_a^b f := \left[f\left(a+\frac{dx}{2}\right)+f\left(a+dx+\frac{dx}{2}\right)+f\left(a+2dx+\frac{dx}{2}\right)...\right]dx$
$\;$
$\;$
$\;$
$=\left[\sum_{i=0}^{b/dx}f\left(a + i \cdot dx + \frac{dx}{2}\right)\right]dx$

$\;$
$\;$
$\;$

"

# ╔═╡ d0c513b0-e921-45b2-a12b-1ad41a1e902e
function integral1(f, a, b, dx)
	add_dx(x) = x + dx
	sum1(f, a + dx/2.0, add_dx, b) * dx
end

# ╔═╡ cd4ad65b-6fa0-4eda-8dd5-0bb3d04eeeb2
md"
---
$$\int_0^1 x^3 dx= \left.\frac{x^4}{4}\right|_0^1=\frac{1^4}{4}-\frac{0^4}{4}=\frac{1}{4}$$
$\;$
$\;$
$\;$
$\;$
"

# ╔═╡ 02bf20ff-0e44-40bc-bd6a-1e55e2086571
plot(cube, 0.0, 1.0, size=(700, 300), xlims=(0.0, 1.1), ylims=(0, 1.2), line=:darkblue, fill=(0, :lightblue), title="x->x^3", framestyle=:semi)

# ╔═╡ bf281edd-d933-446b-8b54-903e52c4505b
integral1(cube, 0, 1, 0.01)

# ╔═╡ dc5ec344-9513-4cda-b97f-511a7449cb6d
integral1(cube, 0, 1, 0.001)

# ╔═╡ 927400e1-d3a9-4acd-b061-a7fbe765f8d4
integral1(cube, 0, 1, 1.0E-3)

# ╔═╡ 71319af0-3051-41c8-8c12-20c142901c11
integral1(cube, 0, 1, 1.0E-4)

# ╔═╡ 0ad7a6d9-1d24-41dc-a573-a8856dfef417
sum_cubes4(a, b) = sum2(cube, a, inc, b)

# ╔═╡ f2d4ee8f-a71e-4370-845f-ac3d37cb4a51
sum_cubes4(1, 1)

# ╔═╡ fd9dadfb-e205-4016-9bad-ceb7fcc1f417
sum_cubes4(1, 2)

# ╔═╡ 9636b204-dc6b-4e9c-88b4-7f4f3a0ff353
sum_cubes4(1, 10)

# ╔═╡ 13f1da45-78ce-4ee9-86ed-0bdb4e592f1c
function integral2(f::Function, a::Real, b::Real, dx::Real)::Real
	add_dx(x) = x + dx
	sum2(f::Function, (a + dx/2.0), add_dx, b) * dx
end

# ╔═╡ 43b2d09b-8822-46bc-9372-6ee4b9f1141a
integral2(cube, 0, 1, 0.01)

# ╔═╡ fba935d4-ee66-44b8-8e5b-bf14a8c08810
integral2(cube, 0.0, 1.0, 1.0E-4)

# ╔═╡ 7dffb4c0-1820-46c4-8676-f327de55048e
md"""
---
###### Example 6-1 in: Stark, P.A., Introduction to Numerical Methods, 1970, ch. 6.2-6.3, p. 196
$\;$

$\int_0^1\left(6-6x^5\right)dx = \left.\left(6x-6\frac{x^6}{6}\right)\right|_0^1=(6-1)=5$
$\;$
$\;$
$\;$
$\;$

"""

# ╔═╡ 08e42781-ef22-483c-baa4-6bbf6e4b110a
# Plots.PlotlyBackend()

# ╔═╡ 76170408-797d-451b-bcf6-b69fec927085
halfParabola(x) =  -6x^5 + 6 # Stark, P.A., Intro to Num. Methods, 1970, p.196f.

# ╔═╡ b2db2a4a-8a5e-43b1-bb99-d37828dbec0c
plot(halfParabola, 0.0, 1.0, size=(300, 400), xlim=(0.0, 1.1), ylim=(0, 6.5), line=:darkblue, fill=(0, :lightblue), framestyle=:semi, title="x->-6x^5 + 6")

# ╔═╡ 73a0deb5-6dc3-41d8-b810-5553c74455ed
integral1(halfParabola, 0.0, 1.0, 0.1)          # should be 5.0

# ╔═╡ 08f1b671-dc0a-4b7a-92ce-4568c24589f1
integral1(halfParabola, 0.0, 1.0, 0.01)         # should be 5.0

# ╔═╡ 7174bf72-b914-4944-95ac-a47cc7ddbfef
integral2(halfParabola, 0, 1, 0.01)             # should be 5.0

# ╔═╡ 90d3e292-ecdf-459f-b451-a5fabc6fe755
integral2(halfParabola, 0, 1, 1.0E-3)           # should be 5.0

# ╔═╡ b94bf716-f77f-4127-aaa8-2b2f52fab923
integral2(halfParabola, 0, 1, 1.0E-4)           # should be 5.0

# ╔═╡ df78019b-24be-48d2-b675-d656447a1c0d
5.0 - integral2(halfParabola, 0.0, 1.0, 1.0E-5) # should be 5.0

# ╔═╡ 9cf19259-52ce-46a7-8a27-89e26c7d5ca4
5.0 -integral2(halfParabola, 0.0, 1.0, 1.0E-6)  # should be 5.0

# ╔═╡ bc194820-97b7-4836-bc48-340e637e7f0d
5.0 -integral2(halfParabola, 0.0, 1.0, 1.0E-7)  # should be 5.0

# ╔═╡ 2cf94a78-f3ea-4e02-b417-aaa6510ff328
md"
---
###### [Standard Normal (= Gaussian) Distribution](https://en.wikipedia.org/wiki/Normal_distribution)
"

# ╔═╡ b2e9582d-bf46-486b-b7fb-1e3a68e77efe
gaussianDensity(x, μ=0.0, σ=1.0) = 1/(σ*sqrt(2π))*exp(-(1/2)*((x-μ)/σ)^2)

# ╔═╡ bd63330c-e1f8-4f4e-836f-b1285539a0c1
let xs1 = [x=1 for x in 0:0.01:gaussianDensity(1.0)]
	ys1 = [y for y in 0:0.01:gaussianDensity(1.0)]
	xs2 = [x=-1 for x in 0:0.01:gaussianDensity(1.0)]
	ys2 = [y for y in 0:0.01:gaussianDensity(1.0)]
	plot(gaussianDensity, -3.0, 3.0, size=(700, 500), xlim=(-3.0, 3.0), ylim=(0, 0.45), line=:darkblue, fill=(0, :lightblue), framestyle=:semi, title="p(-1.0 < X < +1.0) for X ~ N(X|μ=0.0, σ=1.0)", xlabel="X", ylabel="f(X)", label="f(X)")
	plot!(xs1, ys1, color=:red, label="σ=+1.0")
	plot!(xs2, ys2, color=:red, label="σ=-1.0")
end # let

# ╔═╡ 12e0fa05-135d-48b6-b6c2-c28ce006b2d9
integral1(gaussianDensity, -1.0, 1.0, 0.1)         # ==> p = 0.682

# ╔═╡ 23824efd-d3d8-4e02-8ddd-5e20da7e99a4
integral1(gaussianDensity, -1.0, 1.0, 0.01)        # ==> p = 0.682

# ╔═╡ 40e24f4d-9966-4984-b255-34c6cd3e0d7e
integral2(gaussianDensity, -1.0, 1.0, 1.0E-3)      # ==> p = 0.682

# ╔═╡ 63991eb0-ef07-471e-89df-97b9e5b95b19
integral2(gaussianDensity, -1.0, 1.0, 1.0E-5)      # ==> p = 0.682

# ╔═╡ 84667282-7410-4c19-b227-1a2bc8bf88ee
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**, Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/25
- **Wikipedia**; *Normal Distribution*; [https://en.wikipedia.org/wiki/Normal_distribution](https://en.wikipedia.org/wiki/Normal_distribution); last visit: 2023/08/31
"

# ╔═╡ 9c61b414-134f-4924-87b8-8e761e5816ed
md"
---
###### end of ch. 1.3.1

====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
Plots = "~1.39.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "bacb5e85b3a6ee88193a36efc3b98cb30f016166"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1596bab77f4f073a14c62424283e7ebff3072eca"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "a03c77519ab45eb9a34d3cfe2ca223d79c064323"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.1"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "bbb5c2115d63c2f1451cb70e5ef75e8fe4707019"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.22+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─015f86b0-fa99-11eb-0a32-5bee9e7368fb
# ╟─acd01166-5258-4012-a6f4-e4f05b49dce3
# ╟─e3414514-9956-416e-ad41-503795d32556
# ╠═f63fda47-0ee7-4fac-b90c-b4bd893daa7d
# ╠═7fcc1606-a914-458a-82ab-a3fa4f1b0b49
# ╠═590b9e77-9983-4e54-9914-4d6bb5ce8336
# ╟─6414c834-cfe4-4208-a4b1-7fbf3ced47df
# ╠═df6d6fdc-20f1-4ead-8e3e-07340ddb521a
# ╠═5e22d368-1433-4ea1-b094-0188cb755c89
# ╠═27d6dbc2-349d-4848-a915-031f42b72d91
# ╠═99bc5602-46d7-401e-a625-2efa10806042
# ╠═3a7dc73f-9435-40ec-a58c-09600dcb834d
# ╠═0b466d51-d50d-45bf-8290-31414a36c3c5
# ╠═4e086e86-51c8-47ec-8810-55c253f3c92c
# ╠═dbaa23c2-accd-478e-83da-cb9383a2557b
# ╠═381b81f0-7f5f-4312-b63a-fb654e1668e6
# ╟─0f94752d-afc7-4c19-96b8-f0e40edd8f6f
# ╠═a92d3b32-fc1c-4bd9-ba16-d650ffc805eb
# ╠═a8fbd1f3-9994-4e68-83e1-5272aa85f52f
# ╠═ce73399c-aa70-4116-beb2-4f861fc01031
# ╠═a890a15b-e0ac-4336-b666-17389f7bae8a
# ╠═43ca7083-657d-499e-b273-0da40720342a
# ╠═fe6b263c-a804-4e64-9f19-78fe146abc5b
# ╠═f33b6724-4bad-4b46-aff7-2763f51fb1a8
# ╟─ac7668db-45f4-456c-a55b-b9106555fca4
# ╠═fb0e59f2-a9c5-44c3-9d41-7cb8c0347bfb
# ╠═2b2937e1-dba3-462c-a769-60804d676bf5
# ╠═e25a03e0-886c-4862-badb-bcb5be6f477a
# ╠═31ea7745-7d46-4ade-97d1-41ce15f970f7
# ╠═eb647d89-bbc8-42db-9265-5cfc9ad8a03c
# ╠═ba2a843a-a31a-4232-8c94-3893ec0ec760
# ╠═b6caf296-0dea-4572-9043-d515f71d6f93
# ╠═d6144688-4c14-4db3-8c49-65c9eaf7c30b
# ╠═54b81d43-1219-45e9-abaa-805311268810
# ╠═1745d75d-dcc8-4a32-b9a8-607f5da744d9
# ╠═ddae764c-b5c0-4eda-8c80-4f57fbeac486
# ╠═e3c095b9-fc89-4b15-92e5-eb536d612e10
# ╟─fdcd0ad9-a81c-48c8-ab7d-8f8b70e38c4d
# ╠═da24559b-1937-4258-847d-e0f7b7a7c293
# ╠═b9c17500-0301-4a9f-8707-c18fda55261c
# ╠═76174121-4f07-4e04-9bde-f98344fc1a1e
# ╠═792c2312-2469-4844-b7b8-4acd42333a82
# ╠═39a8a3f7-391d-4adf-a217-9ce1db164099
# ╠═eb294e7b-3eb4-4038-bf10-3870819dd2ae
# ╠═0779063c-bb2c-4060-84d7-e6268f9255a2
# ╠═d14308c5-374a-495d-8865-1f52e198fb5e
# ╠═d195654c-302f-4c80-9d4b-0d95978b6a7c
# ╠═33ea2359-475f-42ca-8de4-5f4e91148529
# ╟─ae961cd1-bab0-41e2-9bc5-918d7346f82d
# ╠═cb1cbf7f-98e0-49d4-b12e-ee8b8808d316
# ╠═d0ea0cc2-fdc3-4055-a651-946a66cb7db0
# ╠═9fde9515-3848-44c1-b33b-de9bae9c77c6
# ╠═890ab8e8-12df-4975-90a4-fda312d60ba2
# ╠═20c6c63f-6f04-4aa2-987a-e6789a916383
# ╠═38295b22-5dfb-4e3a-bdd7-e7b91c65d342
# ╠═46466ddf-7b65-49f0-b8d0-d0039f1165e0
# ╠═76cbceaa-ff7b-4e49-8935-6eda98b68729
# ╠═8a4adbdc-2553-4f6a-8cb2-e0c3d35cca08
# ╠═81c0cc23-68f9-4d91-af01-38898e6d50af
# ╠═732458d7-1938-4be1-9de2-8071d1ad644d
# ╠═39c2206d-8a4d-49d0-a8d5-c7a744443000
# ╠═4d0c6403-7588-4971-8046-1f99e3a421a6
# ╠═1e034229-e2a0-420e-97e7-8a02a577fe5a
# ╠═69618ff5-44f5-4d60-8297-cc15457a2ed8
# ╠═3127686e-0c30-48e2-8c73-e7563ee60124
# ╠═5a847c91-d008-434c-98de-90a74335012c
# ╠═9fbc3781-1cf3-4b94-bc93-b5d8c7e0ad24
# ╠═23cf565a-21a1-407d-981d-1ddc433327a8
# ╠═5b4e0581-36b1-47d3-be06-a84cfee8788f
# ╠═3a72d464-a12c-4de5-8c8c-7768c60bec3c
# ╠═28aab614-3469-43d8-ab48-6feb0d30be92
# ╠═82a083c1-2637-49cc-ada1-2c006c26b39f
# ╠═a9f09569-210d-4bbd-8b81-556f628d9220
# ╠═d4290924-cbe3-4f51-88f7-3aaacdfd6b4f
# ╠═7dc42461-ba3a-4837-ba37-e91920c8dc66
# ╠═5967b1d1-0990-4ebc-ae8b-6e6ec00b4f5d
# ╠═ba73b5bb-e803-4e5a-91d9-9c93da299930
# ╟─2a14bebd-8b53-442a-965f-983f040eeea3
# ╠═d0c513b0-e921-45b2-a12b-1ad41a1e902e
# ╟─cd4ad65b-6fa0-4eda-8dd5-0bb3d04eeeb2
# ╠═02bf20ff-0e44-40bc-bd6a-1e55e2086571
# ╠═bf281edd-d933-446b-8b54-903e52c4505b
# ╠═dc5ec344-9513-4cda-b97f-511a7449cb6d
# ╠═927400e1-d3a9-4acd-b061-a7fbe765f8d4
# ╠═71319af0-3051-41c8-8c12-20c142901c11
# ╠═0ad7a6d9-1d24-41dc-a573-a8856dfef417
# ╠═f2d4ee8f-a71e-4370-845f-ac3d37cb4a51
# ╠═fd9dadfb-e205-4016-9bad-ceb7fcc1f417
# ╠═9636b204-dc6b-4e9c-88b4-7f4f3a0ff353
# ╠═13f1da45-78ce-4ee9-86ed-0bdb4e592f1c
# ╠═43b2d09b-8822-46bc-9372-6ee4b9f1141a
# ╠═fba935d4-ee66-44b8-8e5b-bf14a8c08810
# ╟─7dffb4c0-1820-46c4-8676-f327de55048e
# ╠═9f3abf80-5f73-417c-a6a5-c787f4519eb6
# ╠═08e42781-ef22-483c-baa4-6bbf6e4b110a
# ╠═76170408-797d-451b-bcf6-b69fec927085
# ╠═b2db2a4a-8a5e-43b1-bb99-d37828dbec0c
# ╠═73a0deb5-6dc3-41d8-b810-5553c74455ed
# ╠═08f1b671-dc0a-4b7a-92ce-4568c24589f1
# ╠═7174bf72-b914-4944-95ac-a47cc7ddbfef
# ╠═90d3e292-ecdf-459f-b451-a5fabc6fe755
# ╠═b94bf716-f77f-4127-aaa8-2b2f52fab923
# ╠═df78019b-24be-48d2-b675-d656447a1c0d
# ╠═9cf19259-52ce-46a7-8a27-89e26c7d5ca4
# ╠═bc194820-97b7-4836-bc48-340e637e7f0d
# ╟─2cf94a78-f3ea-4e02-b417-aaa6510ff328
# ╠═b2e9582d-bf46-486b-b7fb-1e3a68e77efe
# ╠═bd63330c-e1f8-4f4e-836f-b1285539a0c1
# ╠═12e0fa05-135d-48b6-b6c2-c28ce006b2d9
# ╠═23824efd-d3d8-4e02-8ddd-5e20da7e99a4
# ╠═40e24f4d-9966-4984-b255-34c6cd3e0d7e
# ╠═63991eb0-ef07-471e-89df-97b9e5b95b19
# ╟─84667282-7410-4c19-b227-1a2bc8bf88ee
# ╟─9c61b414-134f-4924-87b8-8e761e5816ed
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
