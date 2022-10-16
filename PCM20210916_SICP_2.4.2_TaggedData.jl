### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ ddedeb70-3b21-11ed-1278-37ba3d55e512
md"
=====================================================================================
#### [SICP\_2.4.2\_TaggedData.jl](https://sarabander.github.io/sicp/html/2_002e4.xhtml#g_t2_002e4_002e2)
##### file: PCM20210916\_SICP\_2.4.2\_TaggedData.jl
##### code: Julia/Pluto.jl (1.8.2/0.19.12) by PCM *** 2022/10/16 ***
=====================================================================================
"

# ╔═╡ 9142ce4d-01f9-4ea9-a94c-9d857ebdabe0
md"
###### Definition of a [complex number](https://en.wikipedia.org/wiki/Complex_number) $$z$$ :
$$z:=x+y\,i = r\cdot cos\,\phi + r\cdot i\, sin\,\phi = r(cos\,\phi + i\, sin\,\phi) = re^{i \phi}$$

where :

$$x = Re(z) = r\cdot cos \,\phi$$
$$y = Im(z) = r\cdot sin \,\phi$$
$$\phi = \arctan(y/x)$$
$$r = \sqrt{(x^2 + y^2)}.$$

The last expression uses Euler's formula for complex analysis.
"

# ╔═╡ e895bc63-c837-4512-baac-a9a48cae50cb
md"
###### [Euler's formula](https://en.wikipedia.org/wiki/Euler%27s_formula) for complex analysis is:

$$e^{i \phi} = cos\,\phi + i \,sin\,\phi,$$

Several different [proofs](https://en.wikipedia.org/wiki/Euler%27s_formula#Proofs) are known. One of the first was using the *power series expansion* of all terms in the formula.

"

# ╔═╡ 386610be-98ca-4ee0-8f24-038eb06c44f7
md"
###### [Euler's identity](https://en.wikipedia.org/wiki/Euler%27s_identity) :
If we substitute $$\phi := \pi$$ in [Euler's formula](https://en.wikipedia.org/wiki/Euler%27s_formula):

$$e^{i \phi} = cos\,\phi + i\, sin\,\phi$$

we fix $$\phi$$ by $$\pi= \frac{2\pi r}{2r}=\frac{circumference}{diameter}$$ then the result is called *Euler's identity* :
###### 

$$e^{i \pi} = cos\,\pi + i \, sin\,\pi = -1 + 0\,i = -1$$

and rearranging terms

$$e^{i \pi} = -1$$

$$e^{i \pi} + 1 = 0.$$

This is known as *'our jewel' and 'the most remarkable formula in mathematics'* [(https://en.wikipedia.org/wiki/Mathematical_beauty)](https://en.wikipedia.org/wiki/Mathematical_beauty) because it connects several fundamental concepts in **one** formula.

"

# ╔═╡ 0e560e33-cce5-40c0-baef-74d64379d677
md"
$$x = Re(z)$$
"

# ╔═╡ 33128853-39be-4e75-a92e-f5281fa72fdb
md"
$$y = Im(z)$$
"

# ╔═╡ d2449192-fafe-4023-8b97-30f7b946827c
md"
$$r = \sqrt{Re(z)^2+Im(z)^2}$$
"

# ╔═╡ eba524fb-4b5f-497e-9b97-7c82b04849e6
md"
$$\phi = arctan(Im(z)/Re(z))$$
"

# ╔═╡ 61502c97-46c9-43d0-a48b-f0d40a985ffd
md"
$$z = r e^{i \phi}$$
"

# ╔═╡ 2713a735-3542-45d6-9ed3-a3aa1863902c
md"
---
##### 2.4.1.1 *Scheme-like* Julia
"

# ╔═╡ cede8129-9358-4dc4-a32e-6390af700376
md"$$
\begin{array}{|c|c|}
\hline
layer     & \text{Operations or Functions}                \\
\hline
          &                                               \\
top       & \text{Representation-independent}             \\
          & \text{domain operations}                      \\ 
          &                                               \\
domain    & \begin{array}{c} 
          & \hline                                        \\
          & addComplex                                    \\ 
          & subComplex                                    \\
          & mulComplex                                    \\
          & divComplex                                    \\ 
          &                                               \\
          & \hline                                        \\
          & realPartOfZ                                   \\
          & imagPartOfZ                                   \\
          & magnitudeOfZ                                  \\          
          & angleOfZ                                      \\
          &                                               \\      
          & \hline                                        \\
          & makeZFromRealImag                             \\
          & makeZFromMagAng                               \\
          & \end{array}                                   \\
          & \hline                                        \\
middle    & \text{Representation-dependent}               \\
          & \text{constructors}                           \\
          &                                               \\
interface & \begin{array}{cc} 
          & \text{Rectangular} & \text{Polar}             \\
          & \hline                                        \\
          & makeZFromRealImagRect & makeZFromRealImagRect \\ 
          & makeZFromMagAngRect   & makeZFromMagAngPolar  \\
          &                                               \\
          & \hline                                        \\
          & \end{array}                                   \\
          & \text{Representation-dependent}               \\
          & \text{predicates and selectors}               \\
          &                                               \\
          & \begin{array}{cc} 
          & \text{Rectangular}    & \text{Polar}          \\
          & \hline                                        \\
          & isRectangular         & isPolar               \\
          &                       &                       \\
          & realPartRectOfZ       & realPartPolarOfZ      \\ 
          & imagPartRectOfZ       & imagPartPolarOfZ      \\
          & magnitudeRectOfZ      & magnitudePolarOfZ     \\
          & angleRectOfZ          & anglePolarOfZ         \\
          &                                               \\
          & \hline                                        \\
          & \end{array}                                   \\
          & \begin{array}{c}  
          & \text{Representation-independent}             \\
          & \text{interface functions}                    \\
          &                                               \\
          & \hline                                        \\
          & attachTag                                     \\
          & typeTag                                       \\
          & contents                                      \\
          & \end{array}                                   \\ 
\hline
          &                                               \\
ground    & cons                                          \\
(Scheme)  & car                                           \\
          & cdr                                           \\
          &                                               \\
\hline
basement  & \\
(Julia)   & \\
\hline
\end{array}$$
"

# ╔═╡ b5ef04bc-2de1-47d3-b5d7-6591f6f6b6b5
md"
---
##### Ground *Scheme*-like functions
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

# ╔═╡ 655656e1-82b9-49b3-b7d4-b12fdd7a63bf
car(cell::Cons) = cell.car

# ╔═╡ a0724486-e498-4fe6-a383-88c100e9bdbd
car(x::Vector) = x[1]

# ╔═╡ 39e8ccf2-ec2d-4b78-a272-808f0e35c20b
cdr(cell::Cons)::Any = cell.cdr

# ╔═╡ 880c3d95-67df-4ac0-a9b0-0339d2d2d461
cdr(x::Vector) = x[2:end]

# ╔═╡ 441e7db6-be23-4911-a5b7-c131c04fa0ad
md"
---
##### Representation *in*dependent interface functions
"

# ╔═╡ 97772419-99eb-4b55-b286-30e0a8141f85
md"
###### type tags $$attach\_tag, type\_tag$$
"

# ╔═╡ 64b7bbd9-bdfd-40af-a37a-b5c5d9269f68
function attachTag(typeTag, contents) 
	cons(typeTag, contents) 
end # attachTag

# ╔═╡ b38d31b7-070c-4248-8eb4-c03735c6f683
function typeTag(datum) 
	car(datum)
end # typeTag

# ╔═╡ cff122f5-c22e-4615-b7fd-93f8c11880e3
md"
###### domain selector $$contents$$
"

# ╔═╡ 3a59f924-cbad-4238-b840-13632ecf294b
function contents(datum) 
	cdr(datum)
end # function contents

# ╔═╡ c4d952f6-f92c-4662-ba8c-6b32ab5ff54b
md"
###### predicates $$is\_rectangular, is\_polar$$
"

# ╔═╡ ada8b1db-7e7b-42f3-92bb-c1825c37cece
isRectangular(z) = typeTag(z) == :rectangular

# ╔═╡ 8d8e2bfe-16d6-4431-ac4a-cd5beefa2ad3
isPolar(z) = typeTag(z) == :polar

# ╔═╡ 1796f8d3-9faa-426d-8d22-f79269e9077f
md"
---
##### Representation-dependent functions 
(Ben's revised rectangular representation from SICP 2.4.1)

###### Selectors
$$realPartRectOfZ, imagPartRectOfZ, magnitudeRectOfZ, angleRectOfZ$$

###### Constructors
$$makeZFromRealImagRect, makeZFromMagAngRect$$
"

# ╔═╡ f44475f7-c036-46fc-8c21-94b383ee90cb
md"
---
###### Selector $$realPartRectOfZ$$ of complex numbers in *rectangular* form
$$realPartRectOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Re(z)$$

"

# ╔═╡ 919cbd2a-4e66-43bb-9ff3-70e4b9694011
function realPartRectOfZ(z)
	car(z)
end # function realPartRectOfZ

# ╔═╡ a676d3d6-8b01-4938-a72e-770e040e2d47
md"
---
###### Selector $$imagPartRectOfZ$$ of complex numbers in *rectangular* form
$$imagPartRectOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Im(z)$$

"

# ╔═╡ a2993ced-5bd1-42c8-8642-3cd9bb32ed2c
function imagPartRectOfZ(z)
	cdr(z)
end # function imagPartRectOfZ

# ╔═╡ 5c72a1ab-8c0b-474e-8046-cce9041ac5dd
md"
---
###### Selector $$magnitudeRectOfZ$$ of complex numbers in *rectangular* form
$$magnitudeRectOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \rho(z)$$

"

# ╔═╡ 686de811-e42c-4c16-b609-11863c5747bb
function magnitudeRectOfZ(z) 
	√(realPartRectOfZ(z)^2 + imagPartRectOfZ(z)^2)
end # function magnitudeRectOfZ

# ╔═╡ 20d54d11-dacd-49a5-a99d-634a813efaf5
md"
---
###### Selector $$angleRectOfZ$$ of complex numbers in *rectangular* form
$$angleRectOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \theta(z)$$

"

# ╔═╡ 542f980c-9e82-4066-9dfc-a6827da9bc1b
function angleRectOfZ(z) 
	atan(imagPartRectOfZ(z), realPartRectOfZ(z))
end # function angleRectOfZ

# ╔═╡ 14e71a34-fd8b-4a5f-a0b6-0fb8a91b5bb3
md"
###### Constructor $$makeZFromRealImagRect$$ of complex numbers in *rectangular* form

$$makeZFromRealImagRect : \mathbb R \times \mathbb R \rightarrow \{:rectangular\} \times \mathbb C$$

$$(Re(z), Im(z)) \mapsto (:rectangular, (Re(z), Im(z))) = (:rectangular, z)$$
"

# ╔═╡ b2a335da-c022-456b-815e-378b4057a4f7
function makeZFromRealImagRect(x, y)
	attachTag(:rectangular, cons(x, y))
end # function makeZFromRealImagRect

# ╔═╡ 6607d299-8d5a-4318-9aa0-d219f37d630a
md"
###### Constructor $$makeZFromMagAngRect$$ of complex numbers in *rectangular* form

$$makeZFromMagAngRect : \mathbb R \times \mathbb R \rightarrow \mathbb C$$

$$(\rho(z), \theta(z)) \mapsto (:rectangular, (\rho(z), \theta(z))) = (:rectangular, z)$$
"

# ╔═╡ 898e3dda-e58e-4e8a-9d90-63b28550e62b
function makeZFromMagAngRect(r, a) 
	attachTag(:rectangular, cons(r * cos(a), r * sin(a)))
end # function makeZFromMagAngRect

# ╔═╡ 461311fe-13ac-48a2-b3e5-96dd2e0de5fe
md"
---
##### Representation-dependent functions 
(Alyssa's revised *polar* representation from SICP 2.4.1)

###### Selectors
$$realPartPolarOfZ, imagPartPolarOfZ, magnitudePolarOfZ, anglePolarOfZ$$

###### Constructors
$$makeZFromRealImagPolar, makeZFromMagAngPolar$$
"

# ╔═╡ 8647d682-d829-4058-b068-76a6a43df6cc
md"
---
###### Selector $$realPartPolarOfZ$$ of complex numbers in *polar* form
$$realPartPolarOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Re(z)$$

"

# ╔═╡ 3d162bbe-1181-4584-bca5-0712ddb24af5
md"
---
###### Selector $$imagPartPolarOfZ$$ of complex numbers in *polar* form
$$imagPartPolarOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto Im(z)$$

"

# ╔═╡ 3fae51ff-bdc1-4450-9e31-10f6ccb12a44
md"
---
###### Selector $$magnitudePolarOfZ$$ of complex numbers in *polar* form
$$magnitudePolarOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \rho(z)$$

"

# ╔═╡ db989f84-cc75-475a-81de-ce65e10f7816
magnitudePolarOfZ = car

# ╔═╡ 6f24b778-7aee-411c-8eb0-656e96f1750a
md"
---
###### Selector $$anglePolarOfZ$$ of complex numbers in *polar* form
$$anglePolarOfZ: \mathbb C \rightarrow \mathbb R$$

$$z \mapsto \theta(z)$$

"

# ╔═╡ cf404921-549a-4790-ab1a-a7fde59a8b13
anglePolarOfZ = cdr

# ╔═╡ 3cfc17b0-631a-4926-9932-d491ba6aa8fd
function realPartPolarOfZ(z) 
	magnitudePolarOfZ(z) * cos(anglePolarOfZ(z))
end # function realPartPolarOfZ

# ╔═╡ 8ed80416-83ac-4bf5-935e-6c066c01b2d1
function imagPartPolarOfZ(z) 
	magnitudePolarOfZ(z) * sin(anglePolarOfZ(z))
end # function imagPartPolarOfZ

# ╔═╡ d3ca8879-6f95-4e87-a51e-e0dbcd749442
md"
---
###### Constructor $$makeZFromRealImagPolar$$ of complex number in *polar* form
$$makeZFromRealImagPolar: (\mathbb R \times \mathbb R ) \rightarrow \{:polar\} \times \mathbb C$$

$$(Re(z), Im(z))) \mapsto (:polar, (Re(z), Im(z))) = (:polar, z) \in \mathbb \{:polar\} \times C$$

"

# ╔═╡ ba048fdf-6ee9-4749-8110-30926ad7657f
function makeZFromRealImagPolar(x, y) 
	attachTag(:polar, cons(√(x^2 + y^2)), atan(y, x))
end # function makeZFromRealImagPolar

# ╔═╡ e9e74b2a-0e30-41d6-93c1-a7de8e6bba64
md"
###### Constructor $$makeZFromMagAngPolar$$ of complex number in *polar* form
$$makeZFromMagAngPolar: (\mathbb R \times \mathbb R ) \rightarrow \{:polar\} \times \mathbb C$$

$$(\rho(z), \phi(z)) \mapsto (:polar, (\rho(z), \phi(z))) = (:polar, z) \in \mathbb \{:polar\} \times C$$

" 

# ╔═╡ 268a42ba-ed7a-4103-9254-efcf8c90f854
function makeZFromMagAngPolar(r, a) 
	attachTag(:polar, cons(r, a))
end # function makeZFromMagAngPolar

# ╔═╡ a48f278f-0fd8-4d1c-8482-454a515ac212
md"
---
##### Domain (representation *in*dependent) 

###### selectors  
$$realPartOfZ, imagPartOfZ, magnitudeOfZ, angleOfZ$$

###### constructors
$$makeZFromRealImag, makezFromMagAng$$
"

# ╔═╡ 6d70c01d-fac1-497a-837f-f3d45f60b274
function realPartOfZ(z)
	if isRectangular(z)
		realPartRectOfZ(contents(z))
	elseif isPolar(z)
		realPartPolarOfZ(contents(z))
	else
		"error realPartOfZ(z), because unknown $z"
	end
end

# ╔═╡ 2b706d93-6e07-42df-9c9b-fb2dfb89a3b1
function imagPartOfZ(z)
	if isRectangular(z)
		imagPartRectOfZ(contents(z))
	elseif isPolar(z)
		imagPartPolarOfZ(contents(z))
	else
		"error imagPartOfZ(z), because unknown $z"
	end
end

# ╔═╡ d43b2cb7-e355-42be-a13a-ce27ea385557
function magnitudeOfZ(z)
	if isRectangular(z)
		magnitudeRectOfZ(contents(z))
	elseif isPolar(z)
		magnitudePolarOfZ(contents(z))
	else
		"error magnitudeOfZ(z), because unknown $z"
	end
end

# ╔═╡ 69b04bd2-0640-4b3c-9d4e-8075c4298956
function angleOfZ(z)
	if isRectangular(z)
		angleRectOfZ(contents(z))
	elseif isPolar(z)
		anglePolarOfZ(contents(z))
	else
		"error angleOfZ(z), because unknown $z"
	end
end

# ╔═╡ 5c08fef4-c2be-459a-85bf-b1ec617c3e0f
function makeZFromRealImag(x, y)
	makeZFromRealImagRect(x, y)
end # function makeZFromRealImag

# ╔═╡ 910c5cce-4343-4763-b83d-2cddd82847cc
function makeZFromMagAng(r, a)
	makeZFromMagAngPolar(r, a)
end # function makeZFromMagAng

# ╔═╡ 556d8fb0-da21-48c6-99aa-6932995a3ff6
md"
---
##### Domain (representation *in*dependent) operations (taken from SICP 2.4.1) 
$$addComplex, subComplex, mulComplex, divComplex$$
"

# ╔═╡ f594966f-2e7c-42ab-81d0-b5360f19bf6f
md"
---
###### Addition $$addComplex$$
"

# ╔═╡ 0f5eae24-727c-4ef9-8e38-18ee64d97229
function addComplex(z1, z2) 
	makeZFromRealImag(
		realPartOfZ(z1) + realPartOfZ(z2), 
		imagPartOfZ(z1) + imagPartOfZ(z2))
end # function addComplex

# ╔═╡ 879967a3-bc78-417a-8cc0-aaf53343d3e2
md"
---
###### Subtraction $$SubComplex$$
"

# ╔═╡ 8f80e51f-b813-4846-967c-1e101511aaef
function subComplex(z1, z2)
	makeZFromRealImag(
		realPartOfZ(z1) - realPartOfZ(z2), 
		imagPartOfZ(z1) - imagPartOfZ(z2))
end # function subComplex

# ╔═╡ e05f131b-5c68-4974-b0cb-ec6d46871fd5
md"
---
###### Multiplication $$MulComplex$$
"

# ╔═╡ b9dc12c1-6e1b-4d1a-8629-f937e9174e61
function mulComplex(z1, z2)
	makeZFromMagAng(
		magnitudeOfZ(z1) * magnitudeOfZ(z2), 
		angleOfZ(z1) + angleOfZ(z2))
end # function mulComplex

# ╔═╡ ce2e5a5b-38fc-4be6-bf5f-435ac2d90ec4
md"
---
###### Division $$divComplex$$
"

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
$$addComplex: (:rectangular, (z_1,z_2)) \mapsto (2 + 3i) + (2 − 3i) = 4 + 0i = 4$$
"

# ╔═╡ b79d7d75-5dc5-4591-a26e-dc91c17be92e
addComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ e3fdcf8c-e210-4a4f-a4c8-b0a2e2315a6d
realPartOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 38cb4d6d-f209-4650-82c2-1b33b0e829e1
imagPartOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ cd469198-e316-484f-9b2e-d8050d8115d7
magnitudeOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ eacab5ef-6f4f-4e2e-89a8-832fa362aa2d
angleOfZ(addComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 8c2cf831-4b01-4ec8-a06c-7f050cb917df
md"
###### [*Subtraction*](https://www.hackmath.net/en/calculator/complex-number) based on *rectangular* coordinates
$$subComplex: (:rectangular, (z_1,z_2)) \mapsto (2 + 3i) - (2 − 3i) = 0 + 6i = 6i$$
"

# ╔═╡ 1ae2d086-2170-4c33-a3f3-38fd5d330dd6
subComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ c0cc5ec5-e576-4300-804d-fb5f8a0770be
realPartOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 46d3b162-7339-42df-86d7-0ee5d6ba9ebf
imagPartOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 52c0ff20-4441-4b20-bab6-530c984676d7
magnitudeOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 09cecdd2-6385-4a26-b17a-67a6f670f5d5
angleOfZ(subComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ a3c6ffd7-7bcf-4681-812c-cd2d5dbb0fed
md"
###### [*Multiplication*](https://www.hackmath.net/en/calculator/complex-number) based on *rectangular* coordinates
$$mulComplex: (:rectangular, (z_1, z_2)) \mapsto (x_1+y_1i)\cdot(x_2+y_2i) =$$
$$=x_1x_2+x_1y_2i+y_1ix_2+y_1iy_2i = x_1x_2+x_1y_2i+y_1ix_2-y_1y_2 =$$
$$=(x_1x_2-y_1y_2)+(x_1y_2+y_1x_2)i$$
"

# ╔═╡ b937d6de-4b48-450e-9258-d95e14a66210
zTwoPlusThreeI

# ╔═╡ 8f23b852-8845-4181-adca-e8dd6e365433
zTwoMinusThreeI

# ╔═╡ 2a83b31b-ac3b-436f-83c7-8794bc9a72bc
md"
$$mulComplex: (:rectangular, (z_1, z_2)) \mapsto (x_1x_2-y_1y_2)+(x_1y_2+y_1x_2)i=$$
$$=(2 + 3i)\cdot(2-3i)=(2 \cdot 2 - 3 \cdot -3) + (2 \cdot -3 + 3 \cdot 2)i = 13 + 0i = 13$$
"

# ╔═╡ 9b533033-3043-4947-a855-13b88edf1206
mulComplex(zTwoPlusThreeI, zTwoMinusThreeI)

# ╔═╡ e117ff3f-8301-41ad-8cdd-d785e60e5e00
realPartOfZ(mulComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 6835e814-42fb-4fae-b519-646a68471ca5
imagPartOfZ(mulComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ 24004315-4ea0-4bb1-9454-965ba9cf74e0
magnitudeOfZ(mulComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ ea5b65a7-cabb-407f-be36-3a9c0e4a94b0
angleOfZ(mulComplex(zTwoPlusThreeI, zTwoMinusThreeI))

# ╔═╡ c7cba9cf-f29f-4902-861b-26768ad6c0b7
md"
$$mulComplex: (:rectangular, (z_1, z_2)) \mapsto (x_1x_2-y_1y_2)+(x_1y_2+y_1x_2)i=$$
$$=(2 + 1i)\cdot(3 + 1i)=(2 \cdot 3 - 1 \cdot 1) + (2 \cdot 1 + 1 \cdot 3)i = 5 + 5i$$

"

# ╔═╡ 11d78621-74b0-4914-a5d6-c4eb3f671795
mulComplex(zTwoPlusOneI, zThreePlusOneI)

# ╔═╡ d0cdcf36-41a5-4bdd-afe4-e98e6dfad8eb
realPartOfZ(mulComplex(zTwoPlusOneI, zThreePlusOneI))

# ╔═╡ 44e56ca0-5bc3-46e2-b88a-b32614b28062
imagPartOfZ(mulComplex(zTwoPlusOneI, zThreePlusOneI))

# ╔═╡ 5e28243b-3813-471b-83ee-924d289f7000
md"
---
##### Test calculations of complex numbers in *polar* form
"

# ╔═╡ 2139e116-17cf-446c-a946-e76a2e8b8ecc
zTwoPlusThreeI

# ╔═╡ 41d85591-ab58-44f8-86d0-ffac76c9f47c
√(2^2 + 3^2)

# ╔═╡ 8e22e739-80f9-4fde-abb1-b45cf63978f7
magOfTwoPlusThreeI = magnitudeOfZ(zTwoPlusThreeI)

# ╔═╡ b5221646-2f1a-4078-a184-7598dd05823d
angOfTwoPlusThreeI = angleOfZ(zTwoPlusThreeI)

# ╔═╡ bc69a5db-c07d-498d-8619-910d2a16ca80
zTwoMinusThreeI

# ╔═╡ ac15ffc7-49e7-4f42-8cb8-f8e6be76ddbf
magOfTwoMinusThreeI = magnitudeOfZ(zTwoMinusThreeI)

# ╔═╡ 853b9609-120c-483e-a5ec-60d051f1b760
angOfTwoMinusThreeI = angleOfZ(zTwoMinusThreeI)

# ╔═╡ cb9d3c4d-8a0c-4a44-ba1e-f6a827eac3a5
zPolarTwoPlusThreeI = makeZFromMagAng(magOfTwoPlusThreeI, angOfTwoPlusThreeI)

# ╔═╡ 15028a35-6d23-44f9-92fd-97676251e9c8
zPolarTwoMinusThreeI = makeZFromMagAng(magOfTwoMinusThreeI, angOfTwoMinusThreeI)

# ╔═╡ 36f74713-f523-467c-984c-56e228aa1497
md"
---
###### *Addition* based on *polar* coordinates
$$addComplex: (z_1,z_2) \mapsto = 4 + 0i = 4$$
"

# ╔═╡ 50b680e7-42c5-4f82-8cce-f8eb5dfd027d
addComplex(zPolarTwoPlusThreeI, zPolarTwoMinusThreeI)

# ╔═╡ 27fde344-ba19-44e1-8678-ecceb71a5168
md"
###### *Subtraction* based on *polar* coordinates
$$subComplex: (z_1,z_2) \mapsto = 0 + 6i = 6i$$
"

# ╔═╡ 7c38fa4d-587d-4c2a-b51d-8fb481f8a7e3
subComplex(zPolarTwoPlusThreeI, zPolarTwoMinusThreeI)

# ╔═╡ 0299a002-aeaf-4f79-95fb-829ca15d1915
md"
###### *Multiplication* based on *polar* coordinates
$$mulComplex: (z_1,z_2) \mapsto ((\rho(z_1)*\rho(z_2)),(\theta(z_1)+\theta(z_2))$$
$$mulComplex: (2 + 3i, 2 - 3i) \mapsto (ρ: 13.00, θ: 0.0) = 13.0 + 0i = 13$$
"

# ╔═╡ 082bf239-666f-42ad-8170-31ebcd25ecde
mulComplex(zPolarTwoPlusThreeI, zPolarTwoMinusThreeI)

# ╔═╡ b784ab03-b513-4378-8295-b376006f285d
realPartOfZ(mulComplex(zPolarTwoPlusThreeI, zPolarTwoMinusThreeI))

# ╔═╡ 4d54a4da-7904-4423-9474-8b52723eb1c3
imagPartOfZ(mulComplex(zPolarTwoPlusThreeI, zPolarTwoMinusThreeI))

# ╔═╡ 3682db7b-c98d-4d7f-98c7-b512a7633336
md"
###### [*Multiplication*](https://www.hackmath.net/en/calculator/complex-number) based on *polar* coordinates
$$mulComplex: (z_1,z_2) \mapsto ((\rho(z_1)*\rho(z_2)),(\theta(z_1)+\theta(z_2))$$
$$= (2.236 * 3.162) + (0.464 + 0.322)i = (ρ:7.072, θ:0.785i) = 5 + 5i$$
"

# ╔═╡ fc42c0df-d97b-43f8-b649-751804e2206e
zTwoPlusOneI

# ╔═╡ 1e847b1a-37d1-46a2-bfa2-a123da7ef50f
√(2^2+1^1)

# ╔═╡ c7a38f1d-976d-4ddd-9b71-3aacb91e1d94
magOfTwoPlusOneI = magnitudeOfZ(zTwoPlusOneI)

# ╔═╡ c4a6a303-22cb-46c5-8350-22fd332de586
atan(1/2)

# ╔═╡ dac17662-9aba-448e-b844-a8cc757cea56
angOfTwoPlusOneI = angleOfZ(zTwoPlusOneI)

# ╔═╡ 19e2c932-5b98-4d40-a11e-ae78072f4ed3
magOfThreePlusOneI = magnitudeOfZ(zThreePlusOneI)

# ╔═╡ 743f0b5c-3d93-431c-9277-048b573e7751
angOfThreePlusOne = angleOfZ(zThreePlusOneI)

# ╔═╡ c8e8ef3c-6ad1-4561-93a0-c81a256ad43c
zPolarThreePlusOneI = makeZFromMagAng(magOfThreePlusOneI, angOfThreePlusOne)

# ╔═╡ b5ba38b3-e5fd-4e6b-90e0-859b0edc7cfe
magnitudeOfZ(zTwoPlusOneI) * magnitudeOfZ(zThreePlusOneI)

# ╔═╡ 70b1305a-7d07-423f-ba59-ddf96e9f5087
angleOfZ(zTwoPlusOneI) + angleOfZ(zThreePlusOneI)

# ╔═╡ 31c7bace-a48a-4915-a23d-eb17a004cc4b
zPolarTwoPlusOneI = makeZFromMagAng(magOfTwoPlusOneI, angOfTwoPlusOneI)

# ╔═╡ 0db89983-49d2-41e2-9b94-a171f6b0d8ca
mulComplex(zPolarThreePlusOneI, zPolarTwoPlusOneI)

# ╔═╡ a61378d4-8111-4712-af5f-64e2472cfaf5
realPartOfZ(mulComplex(zPolarThreePlusOneI, zPolarTwoPlusOneI))

# ╔═╡ d00f2410-9a17-4cb9-8bbb-f744c028e1ba
imagPartOfZ(mulComplex(zPolarThreePlusOneI, zPolarTwoPlusOneI))

# ╔═╡ 2be9faee-f977-4278-9b10-4321abf6cb26
md"
###### [*Division*](https://www.hackmath.net/en/calculator/complex-number?input=10L60) based on *polar* coordinates
$$divComplex: (z_1,z_2) \mapsto ((\rho(z_1)/ \rho(z_2)),(\theta(z_1)-\theta(z_2))$$
$$divComplex: (2+1i, 3+1i) \mapsto (ρ:0.7071, θ:0.14189) = 0.7 + 0.1i$$
"

# ╔═╡ 3ea58403-8feb-4897-9759-90ed548d6419
divComplex(zPolarTwoPlusOneI, zPolarThreePlusOneI)

# ╔═╡ d096696f-3c1a-4364-aae7-1b0fcc3c4a10
realPartOfZ(divComplex(zPolarTwoPlusOneI, zPolarThreePlusOneI))

# ╔═╡ 8632f61e-a4ac-4d8e-a10c-bdfba59dc66c
imagPartOfZ(divComplex(zPolarTwoPlusOneI, zPolarThreePlusOneI))

# ╔═╡ 1d7edfae-9400-4911-b364-372da3b2ad25
md"
---
##### 2.4.1.2 *idiographic* Julia
"

# ╔═╡ d2344a32-eb70-4b67-b245-2d699531c5ad
2 + 3im

# ╔═╡ eb6dfeab-eb5e-42e5-80f7-f9b25d5baf57
2 -3im

# ╔═╡ b8f4babf-4226-4517-91cf-4c26d8d14659
complex(2, 3) + complex(2, -3)

# ╔═╡ 50d8b88b-7623-42c1-b2d0-a54c0a7cb06a
complex(2, 3) - complex(2, -3)

# ╔═╡ 4b049265-c15c-4db9-8a18-44016a218685
complex(2, 3) * complex(2, -3)

# ╔═╡ ebd82750-b684-47e5-bcd5-5891af7ed437
complex(2, 3) / complex(2, -3)

# ╔═╡ 9350dfcf-e973-447f-abb1-92b47c647edc
complex(2, 1) * complex(3, 1)

# ╔═╡ 8c4135aa-7869-4acf-9119-df0f67c19832
complex(2, 1) / complex(3, 1)

# ╔═╡ 3e6a4672-edf0-421e-a2c7-14eb99a85097
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/09/23
- **Feynman, R.P.**; The Feynman Lectures on Physics. Vol. I. Addison-Wesley, 1977.
- **Wikipedia**, Euler's formula, [https://en.wikipedia.org/wiki/Euler%27s_formula](https://en.wikipedia.org/wiki/Euler%27s_formula), last visit 2022/10/09
- **Wikipedia**, Euler's identity, [https://en.wikipedia.org/wiki/Euler%27s_identity](https://en.wikipedia.org/wiki/Euler%27s_identity), last visit 2022/10/06
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
# ╟─9142ce4d-01f9-4ea9-a94c-9d857ebdabe0
# ╟─e895bc63-c837-4512-baac-a9a48cae50cb
# ╟─386610be-98ca-4ee0-8f24-038eb06c44f7
# ╟─0e560e33-cce5-40c0-baef-74d64379d677
# ╟─33128853-39be-4e75-a92e-f5281fa72fdb
# ╟─d2449192-fafe-4023-8b97-30f7b946827c
# ╟─eba524fb-4b5f-497e-9b97-7c82b04849e6
# ╟─61502c97-46c9-43d0-a48b-f0d40a985ffd
# ╟─2713a735-3542-45d6-9ed3-a3aa1863902c
# ╟─cede8129-9358-4dc4-a32e-6390af700376
# ╟─b5ef04bc-2de1-47d3-b5d7-6591f6f6b6b5
# ╟─1c736e19-1dde-496c-9d8f-991384d8d803
# ╠═92e2404e-5606-41d9-a46c-61b76f6737b3
# ╠═7d42ab0f-b4e4-4cf3-81d7-652990d049b0
# ╠═bdfa88e0-e190-4e4f-bf0e-1ba1f2f895ea
# ╠═f29a5d9e-66af-4f3d-b9f6-ad91f0ea735a
# ╟─b6f35feb-67b9-42be-b172-e1a41682fd6f
# ╠═655656e1-82b9-49b3-b7d4-b12fdd7a63bf
# ╠═a0724486-e498-4fe6-a383-88c100e9bdbd
# ╠═39e8ccf2-ec2d-4b78-a272-808f0e35c20b
# ╠═880c3d95-67df-4ac0-a9b0-0339d2d2d461
# ╟─441e7db6-be23-4911-a5b7-c131c04fa0ad
# ╟─97772419-99eb-4b55-b286-30e0a8141f85
# ╠═64b7bbd9-bdfd-40af-a37a-b5c5d9269f68
# ╠═b38d31b7-070c-4248-8eb4-c03735c6f683
# ╟─cff122f5-c22e-4615-b7fd-93f8c11880e3
# ╠═3a59f924-cbad-4238-b840-13632ecf294b
# ╟─c4d952f6-f92c-4662-ba8c-6b32ab5ff54b
# ╠═ada8b1db-7e7b-42f3-92bb-c1825c37cece
# ╠═8d8e2bfe-16d6-4431-ac4a-cd5beefa2ad3
# ╟─1796f8d3-9faa-426d-8d22-f79269e9077f
# ╟─f44475f7-c036-46fc-8c21-94b383ee90cb
# ╠═919cbd2a-4e66-43bb-9ff3-70e4b9694011
# ╟─a676d3d6-8b01-4938-a72e-770e040e2d47
# ╠═a2993ced-5bd1-42c8-8642-3cd9bb32ed2c
# ╟─5c72a1ab-8c0b-474e-8046-cce9041ac5dd
# ╠═686de811-e42c-4c16-b609-11863c5747bb
# ╟─20d54d11-dacd-49a5-a99d-634a813efaf5
# ╠═542f980c-9e82-4066-9dfc-a6827da9bc1b
# ╟─14e71a34-fd8b-4a5f-a0b6-0fb8a91b5bb3
# ╠═b2a335da-c022-456b-815e-378b4057a4f7
# ╟─6607d299-8d5a-4318-9aa0-d219f37d630a
# ╠═898e3dda-e58e-4e8a-9d90-63b28550e62b
# ╟─461311fe-13ac-48a2-b3e5-96dd2e0de5fe
# ╟─8647d682-d829-4058-b068-76a6a43df6cc
# ╠═3cfc17b0-631a-4926-9932-d491ba6aa8fd
# ╟─3d162bbe-1181-4584-bca5-0712ddb24af5
# ╠═8ed80416-83ac-4bf5-935e-6c066c01b2d1
# ╟─3fae51ff-bdc1-4450-9e31-10f6ccb12a44
# ╠═db989f84-cc75-475a-81de-ce65e10f7816
# ╟─6f24b778-7aee-411c-8eb0-656e96f1750a
# ╠═cf404921-549a-4790-ab1a-a7fde59a8b13
# ╟─d3ca8879-6f95-4e87-a51e-e0dbcd749442
# ╠═ba048fdf-6ee9-4749-8110-30926ad7657f
# ╟─e9e74b2a-0e30-41d6-93c1-a7de8e6bba64
# ╠═268a42ba-ed7a-4103-9254-efcf8c90f854
# ╟─a48f278f-0fd8-4d1c-8482-454a515ac212
# ╠═6d70c01d-fac1-497a-837f-f3d45f60b274
# ╠═2b706d93-6e07-42df-9c9b-fb2dfb89a3b1
# ╠═d43b2cb7-e355-42be-a13a-ce27ea385557
# ╠═69b04bd2-0640-4b3c-9d4e-8075c4298956
# ╠═5c08fef4-c2be-459a-85bf-b1ec617c3e0f
# ╠═910c5cce-4343-4763-b83d-2cddd82847cc
# ╟─556d8fb0-da21-48c6-99aa-6932995a3ff6
# ╟─f594966f-2e7c-42ab-81d0-b5360f19bf6f
# ╠═0f5eae24-727c-4ef9-8e38-18ee64d97229
# ╟─879967a3-bc78-417a-8cc0-aaf53343d3e2
# ╠═8f80e51f-b813-4846-967c-1e101511aaef
# ╟─e05f131b-5c68-4974-b0cb-ec6d46871fd5
# ╠═b9dc12c1-6e1b-4d1a-8629-f937e9174e61
# ╟─ce2e5a5b-38fc-4be6-bf5f-435ac2d90ec4
# ╠═d4d1ae65-9b38-4600-a33c-a3668f822c77
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
# ╠═cd469198-e316-484f-9b2e-d8050d8115d7
# ╠═eacab5ef-6f4f-4e2e-89a8-832fa362aa2d
# ╟─8c2cf831-4b01-4ec8-a06c-7f050cb917df
# ╠═1ae2d086-2170-4c33-a3f3-38fd5d330dd6
# ╠═c0cc5ec5-e576-4300-804d-fb5f8a0770be
# ╠═46d3b162-7339-42df-86d7-0ee5d6ba9ebf
# ╠═52c0ff20-4441-4b20-bab6-530c984676d7
# ╠═09cecdd2-6385-4a26-b17a-67a6f670f5d5
# ╟─a3c6ffd7-7bcf-4681-812c-cd2d5dbb0fed
# ╠═b937d6de-4b48-450e-9258-d95e14a66210
# ╠═8f23b852-8845-4181-adca-e8dd6e365433
# ╟─2a83b31b-ac3b-436f-83c7-8794bc9a72bc
# ╠═9b533033-3043-4947-a855-13b88edf1206
# ╠═e117ff3f-8301-41ad-8cdd-d785e60e5e00
# ╠═6835e814-42fb-4fae-b519-646a68471ca5
# ╠═24004315-4ea0-4bb1-9454-965ba9cf74e0
# ╠═ea5b65a7-cabb-407f-be36-3a9c0e4a94b0
# ╟─c7cba9cf-f29f-4902-861b-26768ad6c0b7
# ╠═11d78621-74b0-4914-a5d6-c4eb3f671795
# ╠═d0cdcf36-41a5-4bdd-afe4-e98e6dfad8eb
# ╠═44e56ca0-5bc3-46e2-b88a-b32614b28062
# ╟─5e28243b-3813-471b-83ee-924d289f7000
# ╠═2139e116-17cf-446c-a946-e76a2e8b8ecc
# ╠═41d85591-ab58-44f8-86d0-ffac76c9f47c
# ╠═8e22e739-80f9-4fde-abb1-b45cf63978f7
# ╠═b5221646-2f1a-4078-a184-7598dd05823d
# ╠═bc69a5db-c07d-498d-8619-910d2a16ca80
# ╠═ac15ffc7-49e7-4f42-8cb8-f8e6be76ddbf
# ╠═853b9609-120c-483e-a5ec-60d051f1b760
# ╠═cb9d3c4d-8a0c-4a44-ba1e-f6a827eac3a5
# ╠═15028a35-6d23-44f9-92fd-97676251e9c8
# ╟─36f74713-f523-467c-984c-56e228aa1497
# ╠═50b680e7-42c5-4f82-8cce-f8eb5dfd027d
# ╟─27fde344-ba19-44e1-8678-ecceb71a5168
# ╠═7c38fa4d-587d-4c2a-b51d-8fb481f8a7e3
# ╟─0299a002-aeaf-4f79-95fb-829ca15d1915
# ╠═082bf239-666f-42ad-8170-31ebcd25ecde
# ╠═b784ab03-b513-4378-8295-b376006f285d
# ╠═4d54a4da-7904-4423-9474-8b52723eb1c3
# ╟─3682db7b-c98d-4d7f-98c7-b512a7633336
# ╠═fc42c0df-d97b-43f8-b649-751804e2206e
# ╠═1e847b1a-37d1-46a2-bfa2-a123da7ef50f
# ╠═c7a38f1d-976d-4ddd-9b71-3aacb91e1d94
# ╠═c4a6a303-22cb-46c5-8350-22fd332de586
# ╠═dac17662-9aba-448e-b844-a8cc757cea56
# ╠═19e2c932-5b98-4d40-a11e-ae78072f4ed3
# ╠═743f0b5c-3d93-431c-9277-048b573e7751
# ╠═c8e8ef3c-6ad1-4561-93a0-c81a256ad43c
# ╠═b5ba38b3-e5fd-4e6b-90e0-859b0edc7cfe
# ╠═70b1305a-7d07-423f-ba59-ddf96e9f5087
# ╠═31c7bace-a48a-4915-a23d-eb17a004cc4b
# ╠═0db89983-49d2-41e2-9b94-a171f6b0d8ca
# ╠═a61378d4-8111-4712-af5f-64e2472cfaf5
# ╠═d00f2410-9a17-4cb9-8bbb-f744c028e1ba
# ╟─2be9faee-f977-4278-9b10-4321abf6cb26
# ╠═3ea58403-8feb-4897-9759-90ed548d6419
# ╠═d096696f-3c1a-4364-aae7-1b0fcc3c4a10
# ╠═8632f61e-a4ac-4d8e-a10c-bdfba59dc66c
# ╟─1d7edfae-9400-4911-b364-372da3b2ad25
# ╠═d2344a32-eb70-4b67-b245-2d699531c5ad
# ╠═eb6dfeab-eb5e-42e5-80f7-f9b25d5baf57
# ╠═b8f4babf-4226-4517-91cf-4c26d8d14659
# ╠═50d8b88b-7623-42c1-b2d0-a54c0a7cb06a
# ╠═4b049265-c15c-4db9-8a18-44016a218685
# ╠═ebd82750-b684-47e5-bcd5-5891af7ed437
# ╠═9350dfcf-e973-447f-abb1-92b47c647edc
# ╠═8c4135aa-7869-4acf-9119-df0f67c19832
# ╟─3e6a4672-edf0-421e-a2c7-14eb99a85097
# ╟─3b0945de-e1bb-4435-a07e-c647619e6c2f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
