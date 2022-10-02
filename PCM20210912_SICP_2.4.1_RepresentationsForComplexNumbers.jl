### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ ddedeb70-3b21-11ed-1278-37ba3d55e512
md"
=====================================================================================
#### [SICP\_2.4.1\_RepresentationsForComplexNumbers.jl](https://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4_002e1)
##### file: PCM20210912\_SICP\_2.4.1\_RepresentationsForComplexNumbers.jl
##### code: Julia/Pluto.jl (1.8.2/19.12) by PCM *** 2022/10/02 ***

=====================================================================================
"

# ╔═╡ 35d21e0f-4703-4e9b-8534-c2cba685b198
md"
![](https://sarabander.github.io/sicp/html/fig/chap2/Fig2.20.std.svg)

Fig. 2.4.1.1 Complex numbers as points in the plane. 
(Fig. 2.20, [https://sarabander.github.io/sicp/html/fig/chap2/Fig2.20.std.svg](https://sarabander.github.io/sicp/html/fig/chap2/Fig2.20.std.svg))
"

# ╔═╡ cede8129-9358-4dc4-a32e-6390af700376
md"$$
\begin{array}{|c|c|}
\hline
layer     & \text{Operations or Functions} \\
\hline
top       & \text{Representation-independent Operations} \\
domain    & \begin{array}{c} 
          & \hline                              \\
          & addComplex                          \\ 
          & subComplex                          \\
          & mulComplex                          \\
          & divComplex                          \\   
          & \end{array}                         \\
          & \hline                              \\
middle    & \text{Representation-dependent Constructors} \\
interface & \begin{array}{cc} 
          & \text{Rectangular} & \text{Polar}    \\
          & \hline                               \\
          & makeZFromRealImag  &                 \\ 
          &                    & makeZFromMagAng \\
          & \hline                              \\
          & \end{array}                         \\
          & \text{Representation-dependent Selectors} \\
          & \begin{array}{cc} 
          & \text{Rectangular} & \text{Polar}   \\
          & \hline                              \\
          & realPartOfZ        &                \\ 
          & imagPartOfZ        &                \\
          &                    & magnitudeOfZ   \\
          &                    & angleOfZ       \\
          & \hline                              \\
          & \end{array}                         \\
\hline
ground   & cons \\
(Scheme) & car  \\
         & cdr  \\
\hline
basement & \\
(Julia)  & \\
\hline
\end{array}$$
"

# ╔═╡ 2713a735-3542-45d6-9ed3-a3aa1863902c
md"
---
##### 2.4.1.1 *Scheme-like* Julia
"

# ╔═╡ 1c736e19-1dde-496c-9d8f-991384d8d803
md"
###### methods of *constructor* $$cons$$
"

# ╔═╡ 92e2404e-5606-41d9-a46c-61b76f6737b3
struct Cons
	car
	cdr
end

# ╔═╡ 7d42ab0f-b4e4-4cf3-81d7-652990d049b0
cons(car::Any, cdr::Any)::Cons = Cons(car, cdr)::Cons  

# ╔═╡ bdfa88e0-e190-4e4f-bf0e-1ba1f2f895ea
function cons(car::Any, list2::Vector)::Vector
	conslist = list2
	pushfirst!(conslist, car)
	conslist
end

# ╔═╡ f29a5d9e-66af-4f3d-b9f6-ad91f0ea735a
function cons(list1::Vector, list2::Vector)::Vector
	conslist = push!([], list1)
	for xi in list2
		push!(conslist, xi)
	end
	conslist
end

# ╔═╡ b6f35feb-67b9-42be-b172-e1a41682fd6f
md"
###### methods of *selectors* $$car, cdr$$
"

# ╔═╡ 03c9e321-0a5f-452e-a83c-09edd321df46
car(cell::Cons) = cell.car

# ╔═╡ a0724486-e498-4fe6-a383-88c100e9bdbd
car(x::Vector) = x[1]

# ╔═╡ 33e437c6-125c-443c-b697-3e9b29f34dd1
cdr(cell::Cons)::Any = cell.cdr

# ╔═╡ 880c3d95-67df-4ac0-a9b0-0339d2d2d461
cdr(x::Vector) = x[2:end]

# ╔═╡ 1977b1f7-03ee-4c91-a01a-c26a75e85fa2
md"
---
##### Operations on complex numbers based on *rectangular* form
"

# ╔═╡ f594966f-2e7c-42ab-81d0-b5360f19bf6f
md"
###### [Addition](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction)
$$addComplex: \mathbb{C} \times \mathbb{C} \rightarrow \mathbb{C}$$
$$(z_1, z_2):= ((x_1+x_1i),(x_2+y_2i)) \mapsto ((x_1+x_2),(y_1+y_2)i)$$
"

# ╔═╡ 879967a3-bc78-417a-8cc0-aaf53343d3e2
md"
###### [Subtraction](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction)
$$SubComplex: \mathbb{C} \times \mathbb{C} \rightarrow \mathbb{C}$$
$$(z_1, z_2):=((x_1+y_1i),(x_2+y_2i)) \mapsto ((x_1-x_2),(y_1-y_2)i)$$
"

# ╔═╡ e05f131b-5c68-4974-b0cb-ec6d46871fd5
md"
###### [Multiplication](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction)
$$MulRectComplexZ: \mathbb{C} \times \mathbb{C} \rightarrow \mathbb{C}$$
$$(z_1, z_2):=((x_1+y_1i),(x_2+y_2i)) \mapsto (x_1+y_1i)*(x_2+y_2i)$$
$$=x_1*x_2 + x_1*y_2i + y_1i*x_2 + y_1i*y_2i$$
$$=(x_1*x_2 - y_1*y_2) + (x_1*y_2i + y_1i*x_2)$$
$$=(x_1*x_2 - y_1*y_2) + (x_1*y_2 + x_2*y_1)i$$
"

# ╔═╡ 9d750d83-4142-4be6-add2-a869e2299f89
md"
---
##### Operations on complex numbers based on *polar* form
"

# ╔═╡ cb398a68-cef5-4398-ae9d-65a7e380f2a2
md"
###### [Multiplication](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction)
$$mulComplex: \mathbb{C} \times \mathbb{C} \rightarrow \mathbb{C}$$
$$(z_1, z_2):=((\rho(z_1)+\theta(z_1)),(\rho(z_2)+\theta(z_2)))  \mapsto ((\rho(z_1)*\rho(z_2)),(\theta(z_1)+\theta(z_2))$$
"

# ╔═╡ ce2e5a5b-38fc-4be6-bf5f-435ac2d90ec4
md"
###### [Division](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction)
$$divComplex: \mathbb{C} \times \mathbb{C} \rightarrow \mathbb{C}$$
$$(z_1, z_2):=((\rho(z_1)+\theta(z_1)),(\rho(z_2)+\theta(z_2)))  \mapsto ((\rho(z_1) / \rho(z_2)),(\theta(z_1)-\theta(z_2))$$
"

# ╔═╡ 184c048f-4b67-4b90-af2c-f520becb393f

md"
---
###### Constructors of complex numbers in *rectangular* form
$$makeZFromRealImag: \mathbb R \times \mathbb R \rightarrow \mathbb C$$

$$(Re(z), Im(z)) \mapsto z \in \mathbb C$$

"

# ╔═╡ 39cf6016-62e6-4c2b-9e3b-a51491bf5922
makeZFromRealImag = cons

# ╔═╡ f44475f7-c036-46fc-8c21-94b383ee90cb
md"
---
###### Selector $$realPartOfZ$$ of complex numbers in *rectangular* form
$$realPartOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Re(z)$$

"

# ╔═╡ 919cbd2a-4e66-43bb-9ff3-70e4b9694011
realPartOfZ = car

# ╔═╡ a676d3d6-8b01-4938-a72e-770e040e2d47
md"
---
###### Selector $$imagPartOfZ$$ of complex numbers in *rectangular* form
$$imagPartOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Im(z)$$

"

# ╔═╡ a2993ced-5bd1-42c8-8642-3cd9bb32ed2c
imagPartOfZ = cdr

# ╔═╡ 0f5eae24-727c-4ef9-8e38-18ee64d97229
function addComplex(z1, z2) 
	makeZFromRealImag(
		realPartOfZ(z1) + realPartOfZ(z2), 
		imagPartOfZ(z1) + imagPartOfZ(z2))
end # function addComplex

# ╔═╡ 8f80e51f-b813-4846-967c-1e101511aaef
function subComplex(z1, z2)
	makeZFromRealImag(
		realPartOfZ(z1) - realPartOfZ(z2), 
		imagPartOfZ(z1) - imagPartOfZ(z2))
end # function subComplex

# ╔═╡ a779ca0b-dbad-4fc2-be75-4b7f45d31636
function mulRectComplex(z1, z2)
	makeZFromRealImag(
		realPartOfZ(z1) * realPartOfZ(z2) - imagPartOfZ(z1) * imagPartOfZ(z2), 
		realPartOfZ(z1) * imagPartOfZ(z2) + realPartOfZ(z2) * imagPartOfZ(z1))
end # function mulRectComplex

# ╔═╡ 11a5bf4b-b5ac-4ac0-9f09-87594b9d0c6d
md"
---
###### Constructors of complex numbers in *polar* form
$$makeZFromMagAng: \mathbb R \times \mathbb R \rightarrow \mathbb C$$

$$(\rho(z), \theta(z)) \mapsto z \in \mathbb C$$

"

# ╔═╡ c8d24446-9cd4-4339-9187-ed7e540a3557
makeZFromMagAng(r, a) = cons(r * cos(a), r * sin(a))

# ╔═╡ 5c72a1ab-8c0b-474e-8046-cce9041ac5dd
md"
---
###### Selector $$magnitudeOfZ$$ of complex numbers in *polar* form
$$magnitudetOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \rho(z)$$

"

# ╔═╡ 686de811-e42c-4c16-b609-11863c5747bb
magnitudeOfZ(z) = √(realPartOfZ(z)^2 + imagPartOfZ(z)^2)

# ╔═╡ 20d54d11-dacd-49a5-a99d-634a813efaf5
md"
---
###### Selector $$angleOfZ$$ of complex numbers in *polar* form
$$angleOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \theta(z)$$

"

# ╔═╡ 542f980c-9e82-4066-9dfc-a6827da9bc1b
angleOfZ(z) = atan(imagPartOfZ(z), realPartOfZ(z))

# ╔═╡ b9dc12c1-6e1b-4d1a-8629-f937e9174e61
function mulComplex(z1, z2)
	makeZFromMagAng(
		magnitudeOfZ(z1) * magnitudeOfZ(z2), 
		angleOfZ(z1) + angleOfZ(z2))
end # function mulComplex

# ╔═╡ d4d1ae65-9b38-4600-a33c-a3668f822c77
function divComplex(z1, z2)
	makeZFromMagAng(
		magnitudeOfZ(z1) / magnitudeOfZ(z2), 
		angleOfZ(z1) - angleOfZ(z2))
end # function divComplex

# ╔═╡ 94dbc794-5913-4cca-b4f8-796e7287ad45
md"
---
##### Test calculations of complex numbers in *rectangular* form
"

# ╔═╡ ce04c2f4-a5f5-4b91-b4ce-af23fbc1c1d8
md"
###### *construction* of complex numbers in *rectangular* form
"

# ╔═╡ 460dfdbd-b713-4e6d-843c-d1e1ae1e63a8
zTwoPlusThreeI = makeZFromRealImag(2, 3)

# ╔═╡ 4d2e2768-0ba1-462d-815b-cd169015aa5c
realPartOfZ(zTwoPlusThreeI)

# ╔═╡ b32981b9-e7c9-467d-b22e-43ecaa5ce3c6
imagPartOfZ(zTwoPlusThreeI)

# ╔═╡ d68b3f96-a19e-4098-a233-35f3192fb726
zTwoMinusThreeI = makeZFromRealImag(2, -3)

# ╔═╡ 646c41c8-2d9f-4057-ad4b-6d8695bb1aa2
zTwoPlusOneI = makeZFromRealImag(2, 1)

# ╔═╡ 0716e984-eeee-4714-86c4-dfc8b5313c30
zThreePlusOneI = makeZFromRealImag(3, 1)

# ╔═╡ 794915a9-2d08-4e36-8e0f-f44682d2d1dc
md"
###### [*Addition*](https://www.hackmath.net/en/calculator/complex-number) based on *rectangular* coordinates
$$addComplex: (z_1,z_2) \mapsto (2 + 3i) + (2 − 3i) = 4 + 0i = 4$$
"

# ╔═╡ b79d7d75-5dc5-4591-a26e-dc91c17be92e
addComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ e3fdcf8c-e210-4a4f-a4c8-b0a2e2315a6d
realPartOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 38cb4d6d-f209-4650-82c2-1b33b0e829e1
imagPartOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 8c2cf831-4b01-4ec8-a06c-7f050cb917df
md"
###### [*Subtraction*](https://www.hackmath.net/en/calculator/complex-number) based on *rectangular* coordinates
$$subComplex: (z_1,z_2) \mapsto (2 + 3i) - (2 − 3i) = 0 + 6i$$
"

# ╔═╡ 1ae2d086-2170-4c33-a3f3-38fd5d330dd6
subComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ c0cc5ec5-e576-4300-804d-fb5f8a0770be
realPartOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 46d3b162-7339-42df-86d7-0ee5d6ba9ebf
imagPartOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 01fe1b54-5090-4faa-a711-c86ef9d159f4
md"
###### [*Multiplication*](https://www.hackmath.net/en/calculator/complex-number) based on *rectangular* coordinates
$$mulRectComplexZ: (z_1,z_2) \mapsto (2 + 1i) * (3 + 1i) = (6 - 1) + (2 + 3)= 5+5i$$
"

# ╔═╡ 8e43aa6c-ba87-4e99-ac78-7a4f09207ef2
mulRectComplex(zTwoPlusOneI, zThreePlusOneI)

# ╔═╡ 5e28243b-3813-471b-83ee-924d289f7000
md"
---
##### Test calculations of complex numbers in *polar* form
"

# ╔═╡ 0299a002-aeaf-4f79-95fb-829ca15d1915
md"
###### [*Multiplication*](https://www.hackmath.net/en/calculator/complex-number) based on *polar* coordinates
$$mulComplex: (z_1,z_2) \mapsto ((\rho(z_1)*\rho(z_2)),(\theta(z_1)+\theta(z_2))=13$$
"

# ╔═╡ 082bf239-666f-42ad-8170-31ebcd25ecde
mulComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ d50fb13a-f424-42c2-b501-97a986bf182e
md"
[multiplication in polar form](https://upload.wikimedia.org/wikipedia/commons/9/91/Complex_multi.svg)
"

# ╔═╡ 0db89983-49d2-41e2-9b94-a171f6b0d8ca
mulComplex(zTwoPlusOneI, zThreePlusOneI)

# ╔═╡ 2be9faee-f977-4278-9b10-4321abf6cb26
md"
###### [*Division*](https://www.hackmath.net/en/calculator/complex-number) based on *polar* coordinates
$$divComplex: (z_1,z_2) \mapsto ((\rho(z_1)/ \rho(z_2)),(\theta(z_1)-\theta(z_2))= -0.3846154+0.9230769i$$
"

# ╔═╡ 3ea58403-8feb-4897-9759-90ed548d6419
divComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ 1d7edfae-9400-4911-b364-372da3b2ad25
md"
---
##### 2.4.1.2 *idiographic* Julia
"

# ╔═╡ d2344a32-eb70-4b67-b245-2d699531c5ad
complex(2, 3)

# ╔═╡ eb6dfeab-eb5e-42e5-80f7-f9b25d5baf57
complex(2, -3)

# ╔═╡ b8f4babf-4226-4517-91cf-4c26d8d14659
complex(2, 3) + complex(2, -3)

# ╔═╡ 50d8b88b-7623-42c1-b2d0-a54c0a7cb06a
complex(2, 3) - complex(2, -3)

# ╔═╡ 4b049265-c15c-4db9-8a18-44016a218685
complex(2, 3) * complex(2, -3)

# ╔═╡ ebd82750-b684-47e5-bcd5-5891af7ed437
complex(2, 3) / complex(2, -3)

# ╔═╡ 3e6a4672-edf0-421e-a2c7-14eb99a85097
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/09/23
"

# ╔═╡ 3b0945de-e1bb-4435-a07e-c647619e6c2f
md"
---
###### end of ch 2.3.4

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

---

"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─ddedeb70-3b21-11ed-1278-37ba3d55e512
# ╟─35d21e0f-4703-4e9b-8534-c2cba685b198
# ╟─2713a735-3542-45d6-9ed3-a3aa1863902c
# ╟─cede8129-9358-4dc4-a32e-6390af700376
# ╟─1c736e19-1dde-496c-9d8f-991384d8d803
# ╠═92e2404e-5606-41d9-a46c-61b76f6737b3
# ╠═7d42ab0f-b4e4-4cf3-81d7-652990d049b0
# ╠═bdfa88e0-e190-4e4f-bf0e-1ba1f2f895ea
# ╠═f29a5d9e-66af-4f3d-b9f6-ad91f0ea735a
# ╟─b6f35feb-67b9-42be-b172-e1a41682fd6f
# ╠═03c9e321-0a5f-452e-a83c-09edd321df46
# ╠═a0724486-e498-4fe6-a383-88c100e9bdbd
# ╠═33e437c6-125c-443c-b697-3e9b29f34dd1
# ╠═880c3d95-67df-4ac0-a9b0-0339d2d2d461
# ╟─1977b1f7-03ee-4c91-a01a-c26a75e85fa2
# ╟─f594966f-2e7c-42ab-81d0-b5360f19bf6f
# ╠═0f5eae24-727c-4ef9-8e38-18ee64d97229
# ╟─879967a3-bc78-417a-8cc0-aaf53343d3e2
# ╠═8f80e51f-b813-4846-967c-1e101511aaef
# ╟─e05f131b-5c68-4974-b0cb-ec6d46871fd5
# ╠═a779ca0b-dbad-4fc2-be75-4b7f45d31636
# ╟─9d750d83-4142-4be6-add2-a869e2299f89
# ╟─cb398a68-cef5-4398-ae9d-65a7e380f2a2
# ╠═b9dc12c1-6e1b-4d1a-8629-f937e9174e61
# ╟─ce2e5a5b-38fc-4be6-bf5f-435ac2d90ec4
# ╠═d4d1ae65-9b38-4600-a33c-a3668f822c77
# ╟─184c048f-4b67-4b90-af2c-f520becb393f
# ╠═39cf6016-62e6-4c2b-9e3b-a51491bf5922
# ╟─f44475f7-c036-46fc-8c21-94b383ee90cb
# ╠═919cbd2a-4e66-43bb-9ff3-70e4b9694011
# ╟─a676d3d6-8b01-4938-a72e-770e040e2d47
# ╠═a2993ced-5bd1-42c8-8642-3cd9bb32ed2c
# ╟─11a5bf4b-b5ac-4ac0-9f09-87594b9d0c6d
# ╠═c8d24446-9cd4-4339-9187-ed7e540a3557
# ╟─5c72a1ab-8c0b-474e-8046-cce9041ac5dd
# ╠═686de811-e42c-4c16-b609-11863c5747bb
# ╟─20d54d11-dacd-49a5-a99d-634a813efaf5
# ╠═542f980c-9e82-4066-9dfc-a6827da9bc1b
# ╟─94dbc794-5913-4cca-b4f8-796e7287ad45
# ╟─ce04c2f4-a5f5-4b91-b4ce-af23fbc1c1d8
# ╠═460dfdbd-b713-4e6d-843c-d1e1ae1e63a8
# ╠═4d2e2768-0ba1-462d-815b-cd169015aa5c
# ╠═b32981b9-e7c9-467d-b22e-43ecaa5ce3c6
# ╠═d68b3f96-a19e-4098-a233-35f3192fb726
# ╠═646c41c8-2d9f-4057-ad4b-6d8695bb1aa2
# ╠═0716e984-eeee-4714-86c4-dfc8b5313c30
# ╟─794915a9-2d08-4e36-8e0f-f44682d2d1dc
# ╠═b79d7d75-5dc5-4591-a26e-dc91c17be92e
# ╠═e3fdcf8c-e210-4a4f-a4c8-b0a2e2315a6d
# ╠═38cb4d6d-f209-4650-82c2-1b33b0e829e1
# ╟─8c2cf831-4b01-4ec8-a06c-7f050cb917df
# ╠═1ae2d086-2170-4c33-a3f3-38fd5d330dd6
# ╠═c0cc5ec5-e576-4300-804d-fb5f8a0770be
# ╠═46d3b162-7339-42df-86d7-0ee5d6ba9ebf
# ╟─01fe1b54-5090-4faa-a711-c86ef9d159f4
# ╠═8e43aa6c-ba87-4e99-ac78-7a4f09207ef2
# ╟─5e28243b-3813-471b-83ee-924d289f7000
# ╟─0299a002-aeaf-4f79-95fb-829ca15d1915
# ╠═082bf239-666f-42ad-8170-31ebcd25ecde
# ╟─d50fb13a-f424-42c2-b501-97a986bf182e
# ╠═0db89983-49d2-41e2-9b94-a171f6b0d8ca
# ╟─2be9faee-f977-4278-9b10-4321abf6cb26
# ╠═3ea58403-8feb-4897-9759-90ed548d6419
# ╟─1d7edfae-9400-4911-b364-372da3b2ad25
# ╠═d2344a32-eb70-4b67-b245-2d699531c5ad
# ╠═eb6dfeab-eb5e-42e5-80f7-f9b25d5baf57
# ╠═b8f4babf-4226-4517-91cf-4c26d8d14659
# ╠═50d8b88b-7623-42c1-b2d0-a54c0a7cb06a
# ╠═4b049265-c15c-4db9-8a18-44016a218685
# ╠═ebd82750-b684-47e5-bcd5-5891af7ed437
# ╟─3e6a4672-edf0-421e-a2c7-14eb99a85097
# ╟─3b0945de-e1bb-4435-a07e-c647619e6c2f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
