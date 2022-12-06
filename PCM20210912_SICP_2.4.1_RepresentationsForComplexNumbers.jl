### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 90aa1e17-89f8-4884-9a3b-e58acf87bc7a
using Plots

# ╔═╡ e39aed1d-58a3-40e6-8a73-27204b742f42
md"
=====================================================================================
#### SICP\_2.4.1\_RepresentationsForComplexNumbers.jl
###### file: PCM20210912\_SICP\_2.4.1\_RepresentationsForComplexNumbers.jl
###### code: Julia/Pluto.jl (1.8.2/0.19.14) by PCM *** 2022/12/06 ***

=====================================================================================

"

# ╔═╡ d87312c3-36cc-4d5d-9d3f-fd9da02bdadb
md"
#### 2.4.1.1 Definition of complex numbers
"

# ╔═╡ b4ce58d8-c130-4c4f-904d-deccef8940cf

let
	title = "Representation of z = Re(z) + Im(z) = x + yi in C"
	xlim  = (-0.5, 2.5); ylim = (-0.5, 1.2)
	z = 2 + 1im
	ϕ = atan(imag(z)/real(z))
	radius = 0.8
	circleArray = Plots.partialcircle(0, ϕ, 30, radius)
	plot([(0, 0), (2, 1)], line=:arrow, linecolor=:red, linewidth=4, title=title, xlim=xlim, ylim=ylim, legend=false)
	plot!([(2, 0), (2, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(0, 0), (2, 0)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(0, 1), (2, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(0, 0), (0, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!(circleArray, linestyle=:dot, linecolor=:red, linewidth=1)
	annotate!(2.3,  1.04, ("z = x + yi", 12, :red))
	annotate!(2.25, 0.5,  ("y=Im(z)", 12))
	annotate!(1.0, -0.1,  ("x=Re(z)", 12))
	annotate!(1.15, 0.2,  ("ϕ=arctan(y/x)", 12, :red))
	annotate!(0.85, 0.6,  ("|z|=ρ=r", :red, 12))
end # let

# ╔═╡ 576d32a1-4aa4-414d-84a5-99a1f5bc3208
md"
**Fig. 2.4.1.1** Complex numbers as *points* (or *vectors*) in $$\mathbb C$$ (cf. Fig. 2.20 in SICP)

---
"

# ╔═╡ 24a94004-d2f6-40f2-9596-0d2467fe8f4b
md"

$$z = x + yi = r \cdot cos \, \phi + r \cdot i\, sin \, \phi = r \cdot (cos \, \phi + i\, sin \, \phi) = r \cdot e^{i \, \phi}$$

where:

$$x  = Re(z) = r \cdot cos \, \phi$$
$$yi = Im(z) = r \cdot i\, sin \, \phi$$
$$ϕ  = arctan(Im(z)/Re(z)) = arctan(y/x)$$
$$ρ  = r = |z| = \sqrt{x^2+y^2}$$
"

# ╔═╡ c2bfc649-b5b1-4e75-83f4-76d2aa57bc5b
md"
---
##### [Euler's formula](https://en.wikipedia.org/wiki/Euler%27s_formula) for complex analysis
The expression

$$e^{i \, \phi} = (cos \, \phi + i\, sin \, \phi)$$

is known as *Euler's formula*. Several different [proofs](https://en.wikipedia.org/wiki/Euler%27s_formula#Proofs) are known. One of the first was using the *power series expansion* of all terms in the formula.
"

# ╔═╡ eb2b46af-1eda-4b19-988d-ab8b2f7c3525
md"
##### [Euler's identity](https://en.wikipedia.org/wiki/Euler%27s_identity)

If we substitute $$\phi = \pi = \frac{2\pi}{2r} = \frac{circumference}{diameter}$$ *of circle* in Euler's formula:

$$e^{i \, \phi} = (cos \, \phi + i\, sin \, \phi)$$

the result is called *Euler's identity* :

$$e^{i \, \pi} = (cos \, \pi + i\, sin \, \pi) = -1 + 0i = -1$$

and rearranging terms

$$e^{i \, \pi} + 1 = 0.$$

This is known as '*our jewel*' and '*the most remarkable formula in mathematics*' [https://en.wikipedia.org/wiki/Mathematical_beauty](https://en.wikipedia.org/wiki/Mathematical_beauty) because it connects several fundamental concepts in *one* formula.

"

# ╔═╡ 46638e2b-704f-43df-9b61-a387762f78c9
let
	title = "Representation by Euler's formula in C"
	xlim  = (-1.5, 3.5); ylim = (-1.5, 1.5)
	ϕ = atan(1/2)
	radius = 1.0
	r = sqrt(2^2 + 1^2)
	z = r*exp(im*ϕ)
	circleArray = Plots.partialcircle(0, 2π, 240, radius)
	plot([(0, 0), (real(z), imag(z))], line=:arrow, linecolor=:red, linewidth=4, title=title, xlim=xlim, ylim=ylim, legend=false)
	plot!([(0, 0),   (real(z)/r, imag(z)/r)], line=:arrow, linecolor=:blue, linewidth=4)
	plot!([(2, 0),   (2, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(0,-1.3), (0, 1.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([(0, 0),   (2, 0)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(-1.3, 0),(3, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([(0, 1),   (2, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(0, 0),   (0, 1)], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!(circleArray, linestyle=:dot, linecolor=:blue, linewidth=1)
	annotate!(2.6, 1.05, ("z = r⋅exp(iϕ)", 12, :red))
	annotate!(1.3, 0.4, ("exp(iϕ)", 12, :blue))
	annotate!(2.14, 0.5, ("y", 12))
	annotate!(1.2,-0.1, ("x", 12))
	annotate!(0.6, 0.15, ("ϕ", 12, :blue))
	annotate!(1.2, 0.8, ("|z|", 12, :red))
end # let

# ╔═╡ 724ba211-8069-43b8-99b1-55d755ed3c68
md"
**Fig. 2.4.1.2** Complex numbers as *points* (or *vectors*) in $$\mathbb C$$ using *Euler's formula*

---
"

# ╔═╡ afd5a931-b8ad-46f8-b0f2-894d59d53959
let
	title = "Representation of Euler's identity in C"
	xlim  = (-2.5, 3.5); ylim = (-1.5, 1.5)
	ϕ = π
	radius = 1.0
	r = 1
	z = r*exp(im*π)
	circleArray = Plots.partialcircle(0, 2π, 240, radius)
	plot([(0, 0), (real(z), imag(z))], line=:arrow, linecolor=:red, linewidth=4, title=title, xlim=xlim, ylim=ylim, legend=false, aspect_ratio=:equal)
	plot!([(0,-1.3), (0, 1.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([(-1.3, 0),(3, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!(circleArray, linestyle=:dot, linecolor=:blue, linewidth=1)
	annotate!(-1.0, 0.15, ("z = exp(iπ)", 12, :red))
	annotate!(-1.0,-0.15, ("= -1+0i", 12, :red))
end # let

# ╔═╡ e791db57-a399-47fe-ac45-f4a61c493473
md"
**Fig. 2.4.1.3** Complex number as *point* (or *vector*) in $$\mathbb C$$ using *Euler's identity*
"

# ╔═╡ 262fb6be-d103-4407-b30b-ff5293ce2bea
md"
---
#### 2.4.1.2 Scheme-like Julia
"


# ╔═╡ 6d2eea9e-fd56-43c6-95a7-3d565dd0836a
md"
$$\begin{array}{|c|c|}                     
\hline                                                         \\
layer         & \text{Operations or Functions}                 \\
              &                                                \\
\hline                                                         \\
top           & \text{representation independent}              \\
              & \text{------------------------------------}    \\
(domain)      & addComplex                                     \\
              & subComplex                                     \\
              & mulComplex                                     \\
              & divComplex                                     \\
\hline                                                         \\
middle        & \text{representation dependent}                \\
(interface)   & \text{------------------------------------}    \\
              & \begin{array}{cc}                              \\
              & realPartOfZRect       & realPartOfZPolar       \\      
              & imagPartOfZRect       & imagPartOfZPolar       \\
              & magnitudeOfZRect      & magnitudeOfZPolar      \\
              & angleFromOfZRect      & angleOfZPolar          \\
              & makeZRectFromRealImag & makeZPolarFromRealImag \\
              & makeZRectFromMagAng   & makeZPolarFromMagAng   \\
              & \end{array}                                    \\
\hline                                                         \\
ground        & cons                                           \\
(Scheme-like) & car                                            \\            
              & cdr                                            \\
              &                                                \\
\hline                                                                              
\end{array}$$                                       
"

# ╔═╡ 1e2aa2f3-81a8-4252-be4f-aa575918a67b
md"
**Fig. 2.4.1.4** *Abstraction barriers* in the complex number system (cf. to SICP, Fig. 2.19)

---
"

# ╔═╡ 4dc1459c-070f-4970-9e67-c9facdc15cef
md"
---
##### *Methods* of Scheme-like *constructor* $$cons$$
"

# ╔═╡ 82578c79-a6f3-4374-8ee2-aa8a585f4b4a
struct Cons
	car
	cdr
end

# ╔═╡ 8a06336c-044c-4091-b7ae-f4ea60b97afa
cons(car::Any, cdr::Any)::Cons = Cons(car, cdr)::Cons  

# ╔═╡ ed5d2b26-d30a-4d13-8eef-6e1175699f57
function cons(car::Any, list2::Vector)::Vector
	conslist = list2
	pushfirst!(conslist, car)
	conslist
end

# ╔═╡ f1181c0f-0127-4761-a471-757f71dddb97
function cons(list1::Vector, list2::Vector)::Vector
	conslist = push!([], list1)
	for xi in list2
		push!(conslist, xi)
	end
	conslist
end

# ╔═╡ 2e5ccb79-6d54-4b84-9a78-633ed533c1dc
md"
##### *Methods* of Scheme-like *selectors* $$car, cdr$$
"

# ╔═╡ 43b5159b-40b1-41fb-8547-a889b8e9e729
car(cell::Cons) = cell.car

# ╔═╡ 5a5a7926-7733-40cd-8ab9-583a15e534ba
car(x::Vector) = x[1]

# ╔═╡ 04532459-8d67-4ea2-9b32-f010e3100932
cdr(cell::Cons)::Any = cell.cdr

# ╔═╡ 7cde6bad-2ff7-4fec-bed6-b5d00adfb0ba
cdr(x::Vector) = x[2:end]

# ╔═╡ c02043ce-730e-42e1-ae7d-96963bdb4a75
md"
---
##### *Rectangular*-dependent functions 
(Ben's representation)
"

# ╔═╡ ad27ac18-e0f8-4b63-942d-e5a24efbd168
md"
###### Selectors
$$realPartOfZRect, imagPartOfZRect$$
$$magnitudeOfZRect, angleOfZRect$$

###### Constructors
$$makeZRectFromRealImag, makeZRectFromMagAng$$

---
"

# ╔═╡ ace9faf1-33cf-4086-b6aa-9b1fad9ddd82
realPartOfZRect(z) = car(z)

# ╔═╡ 0bb28e73-6374-4b59-8070-d6964a53c20c
imagPartOfZRect(z) = cdr(z)

# ╔═╡ 6f3732d7-f9e6-4c6b-8a18-47e128337531
magnitudeOfZRect(z) = sqrt(realPartOfZRect(z)^2 + imagPartOfZRect(z)^2)

# ╔═╡ 4775c4b5-c6e0-45da-8a1c-33070e5348ed
angleOfZRect(z) = atan(imagPartOfZRect(z)/realPartOfZRect(z))

# ╔═╡ 9c4e42b6-a630-4263-95b0-40c072763410
makeZRectFromRealImag(x, y) = cons(x, y)

# ╔═╡ fe8c3cae-b495-4670-983f-fcef9d72e98f
makeZRectFromMagAng(r, a) = cons(r * cos(a), r * sin(a))

# ╔═╡ 420220d7-586f-4f26-b107-e68677d10b5b
md"
---
##### *Polar*-dependent functions
(Alyssa's representation) 

###### Selectors
$$realPartOfZPolar, imagPartOfZPolar$$
$$magnitudeOfZPolar, anglePartOfZPolar$$

###### Constructors
$$makeZPolarFromRealImag, makeZPolarFromMagAng$$

---
"

# ╔═╡ e48844ca-fa46-4c8f-9bb8-f2d33ad7fdad
magnitudeOfZPolar(z) = car(z)

# ╔═╡ 42b1742d-da96-4ea7-b5a8-288ea45d035c
angleOfZPolar(z) = cdr(z)

# ╔═╡ fd0dcca8-dd8a-416d-91d2-469f81dba264
realPartOfZPolar(z) = magnitudeOfZPolar(z) * cos(angleOfZPolar(z))

# ╔═╡ 55535d43-7c35-4ac1-9bf8-22881647651d
imagPartOfZPolar(z) = magnitudeOfZPolar(z) * sin(angleOfZPolar(z))

# ╔═╡ 60dead94-fe17-412a-8574-e7ba010090ca
makeZPolarFromRealImag(x, y) = cons(sqrt(x^2+y^2), atan(y/x))

# ╔═╡ 93dc4413-e5f8-4df8-9798-f1189962e4e7
makeZPolarFromMagAng(r, a) = cons(r, a)

# ╔═╡ 74fd815e-34fa-4f89-aa06-d19ed3ca382f
md"
---
##### Domain (representation *in*dependent) operations
$$addComplex, subComplex, mulComplex divComplex$$
"

# ╔═╡ 64035b6c-2596-4977-bafb-96b2a0a0d90b
md"
---
###### Complex addition
"

# ╔═╡ ff97e2e0-d581-470d-bdfb-92c4822e7970
md"
**Fig. 1.4.1.5** Complex *addition* as vector addition in $$\mathbb C$$

---
"

# ╔═╡ 27d313ff-84f8-44bb-ae90-9e71fed9d106
md"
###### [Addition](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction) in $$\mathbb C$$

$$addComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$addComplex: (z_1, z_2)=((x_1+y_1i), (x_2+y_2i) \mapsto ((x_1+x_2),(y_1+y_2)i)$$
"

# ╔═╡ 43a53b2a-0a0d-41a5-8e7c-b3106d999272
function addComplex(z1, z2)
	makeZRectFromRealImag(
		realPartOfZRect(z1) + realPartOfZRect(z2),
		imagPartOfZRect(z1) + imagPartOfZRect(z2))
end # function addComplex

# ╔═╡ 37766cb9-6453-47a5-b127-a87fb100f868
let
	z1 = makeZRectFromRealImag(2, 1)
	r1 = magnitudeOfZRect(z1)
	z2 = makeZRectFromRealImag(realPartOfZRect(z1)/r1, -2*imagPartOfZRect(z1)/r1)
	z3 = addComplex(z1, z2)
end # let

# ╔═╡ f4ee47dc-6059-4980-86a5-15b122b56751
md"
---
###### Complex subtraction
"

# ╔═╡ 4db3fda8-63e9-48ab-ba9d-431f2ac7e061
md"
**Fig. 1.4.1.6** Complex *subtraction* as vector subtraction in $$\mathbb C$$

---
"

# ╔═╡ c635a131-54c0-4530-9735-07fc558240fb
md"
###### [Subtraction](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction) in $$\mathbb C$$

$$subComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$subComplex: (z_1, z_2)=((x_1+y_1i), (x_2+y_2i) \mapsto ((x_1-x_2),(y_1-y_2)i)$$
"

# ╔═╡ 6c151933-886d-4774-a380-1ba185a1070d
function subComplex(z1, z2)
	makeZRectFromRealImag(
		realPartOfZRect(z1) - realPartOfZRect(z2),
		imagPartOfZRect(z1) - imagPartOfZRect(z2))
end # function subComplex

# ╔═╡ e3cb6006-4bf0-497c-8420-55637737a981
let
	z1 = makeZRectFromRealImag(2, 1)
	r1 = magnitudeOfZRect(z1)
	z2 = makeZRectFromRealImag(realPartOfZRect(z1)/r1, -2*imagPartOfZRect(z1)/r1)
	z3 = subComplex(z1, z2)
end # let

# ╔═╡ ceed4c01-d4ca-47a7-add3-b14c775d95d8
md"
---
###### Complex multiplication
"

# ╔═╡ 46f29c21-f7c6-416f-8915-a957abf74186
let
	xlim  = (-1.5, 8.5); ylim = (-1.5, 3.0)
	z1 = 2 - 1im
	ϕ1 = atan(imag(z1)/real(z1))
	r1 = abs(z1)
	z2 = 2 + 2im	
	r2 = abs(z2)
	ϕ2 = atan(imag(z2)/real(z2))
	z3 = z1 * z2
	r3 = r1 * r2
	ϕ3 = ϕ1 + ϕ2
	circleArray  = Plots.partialcircle(0, 2π, 240, 1)
	circleArray1 = Plots.partialcircle(0, ϕ1, 30, r1)	
	circleArray2 = Plots.partialcircle(0, ϕ2, 30, r2)	
	circleArray3 = Plots.partialcircle(0, ϕ3, 30, r3)	
	plot([(0, 0), (real(z1), imag(z1))], line=:arrow, linecolor=:green, linewidth=4, xlim=xlim, ylim=ylim, legend=false, aspect_ratio=:equal)
	plot!([(0, 0),  (real(z2), imag(z2))], line=:arrow, linecolor=:blue, linewidth=4)
	plot!([(0, 0),  (real(z3), imag(z3))], line=:arrow, linecolor=:red, linewidth=4)
	plot!([(0,-1.3), (0, 2.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([(-1.3, 0),(6.5, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!(circleArray,  linestyle=:dot, linecolor=:blue,  linewidth=1)
	plot!(circleArray1, linestyle=:dot, linecolor=:green, linewidth=1)
	plot!(circleArray2, linestyle=:dot, linecolor=:blue,  linewidth=1)
	plot!(circleArray3, linestyle=:dot, linecolor=:red,   linewidth=1)
	annotate!(2.3, -1.0, ("z1", 12, :green))
	annotate!(1.0, -0.8, ("|z1|", 12, :green))
	annotate!(2.3,  2.1, ("z2", 12, :blue))
	annotate!(1.0,  1.5, ("|z2|", 12, :blue))
	annotate!(7.0,  2.1, ("z3=z1*z2", 12, :red))
	annotate!(4.0,  2.15,("|z1|*|z2|", 12, :red))
	annotate!(4.0,  1.7, ("=|z3|", 12, :red))
	annotate!(1.9, -0.4, ("ϕ1", 12, :green) )
	annotate!(2.2,  1.2, ("ϕ2", 12, :blue))
	annotate!(5.2,  0.8, ("ϕ1+ϕ2=ϕ3", 12, :red))
end # let

# ╔═╡ 36cf2a48-6f57-4a78-a55d-cab8199eba97
md"
**Fig. 1.4.1.5** Complex *multiplication* as vector operation in $$\mathbb C$$

---
"

# ╔═╡ a064adda-624f-4dd6-9521-1dcfb2840189
md"
###### [Multiplication](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction) in $$\mathbb C$$
###### in *rectangular* coordinates

$$mulComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$mulComplex: (z_1, z_2) := ((x_1+y_1i), (x_2+y_2i) \mapsto (x_1x_2 + x_1y_2i + y_1ix_2 + y_1i\cdot y_2i)$$
$$=(x_1x_2 + x_1y_2i + y_1ix_2 - y_1y_2)=(x_1x_2 - y_1y_2)+(x_1y_2 + y_1x_2)i$$

###### and in *polar* coordinates

$$mulComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$mulComplex: (z_1, z_2) := ((\rho(z_1), \phi(z_1)), (\rho(z_2), \phi(z_2))) \mapsto (\rho(z_1) \cdot \rho(z_2), \phi(z_1) + \phi(z_2))$$
"



# ╔═╡ f179ef07-e391-4894-a5f2-6cef7659e592
function mulComplex(z1, z2)
	makeZRectFromMagAng(
		magnitudeOfZRect(z1) * magnitudeOfZRect(z2),
		angleOfZRect(z1) + angleOfZRect(z2))
end # function mulComplex

# ╔═╡ 25151974-8b0b-4e33-ac6c-927e695789d0
let
	z1 = makeZRectFromRealImag(2, -1)
	z2 = makeZRectFromRealImag(2,  2)
	z3 = mulComplex(z1, z2)
end # let

# ╔═╡ 1fb809a4-7218-41c3-a54d-b524ab8192f9
md"
---
###### Complex division
"

# ╔═╡ 72e9c6eb-6404-4fc8-bafa-996d335734fe
let
	xlim  = (-2.5, 4.5); ylim = (-2.5, 3.0)
	z1 = 3 - 1im
	ϕ1 = atan(imag(z1)/real(z1))
	r1 = abs(z1)
	z2 = 1.0 + 2im	
	r2 = abs(z2)
	ϕ2 = atan(imag(z2)/real(z2))
	z3 = z1 / z2
	r3 = r1 / r2
	ϕ3 = ϕ1 - ϕ2
	circleArray  = Plots.partialcircle(0, 2π, 240, 1)
	circleArray1 = Plots.partialcircle(0, ϕ1, 30, r1)	
	circleArray2 = Plots.partialcircle(0, ϕ2, 30, r2)	
	circleArray3 = Plots.partialcircle(0, ϕ3, 30, r3)	
	plot([(0, 0), (real(z1), imag(z1))], line=:arrow, linecolor=:green, linewidth=4, xlim=xlim, ylim=ylim, legend=false, aspect_ratio=:equal)
	plot!([(0, 0),  (real(z2), imag(z2))], line=:arrow, linecolor=:blue, linewidth=4)
	plot!([(0, 0),  (real(z3), imag(z3))], line=:arrow, linecolor=:red, linewidth=4)
	plot!([(0,-1.3), (0, 2.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([(-2.0, 0),(6.5, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!(circleArray,  linestyle=:dot, linecolor=:blue,  linewidth=1)
	plot!(circleArray1, linestyle=:dot, linecolor=:green, linewidth=1)
	plot!(circleArray2, linestyle=:dot, linecolor=:blue,  linewidth=1)
	plot!(circleArray3, linestyle=:dot, linecolor=:red,   linewidth=1)
	annotate!(3.2, -1.0, ("z1", 12, :green))
	annotate!(1.9, -0.4, ("|z1|", 12, :green))
	annotate!(1.0,  2.2, ("z2", 12, :blue))
	annotate!(0.4,  1.5, ("|z2|", 12, :blue))
	annotate!(-.4, -1.6, ("z1/z2=z3", 12, :red))
	annotate!(-1.0, -.7, ("|z1|/|z2|=|z3|", 12, :red))
	annotate!(2.9, -0.4, ("ϕ1", 12, :green))
	annotate!(1.7,  1.0, ("ϕ2", 12, :blue))
	annotate!(1.6, -1.1, ("ϕ3=ϕ1-ϕ2", 12, :red))
end # let

# ╔═╡ f799d74f-5629-4171-86f1-d1ef772a617b
md"
###### [Division](https://en.wikipedia.org/wiki/Complex_number#Addition_and_subtraction) in $$\mathbb C$$
###### in *rectangular* coordinates

$$divComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$divComplex: (z_1, z_2) := \frac{z_1}{z_2} = \frac{z_1}{z_2}\times\frac{\overline{z_2}}{\overline{z_2}}=\frac{z_1\overline{z_2}}{z_2\overline{z_2}}=\frac{Re(z_1\overline{z_2})}{|z_2|^2}+\frac{Im(z_1\overline{z_2})}{|z_2|^2}i$$

or more explicit:

$$\frac{x_1 + y_1i}{x_2 + y_2i} = \frac{x_1 + y_1i}{x_2 + y_2i} \times \frac{x_2 - y_2i}{x_2 - y_2i}=\frac{(x_1 + y_1i)(x_2 - y_2i)}{(x_2 + y_2i)(x_2 - y_2i)}$$

$$=\frac{(x_1 x_2 + y_1 y_2) + (x_2 y_1 - x_1 y_2)i}{x_2^2 + y_2^2}=\frac{x_1 x_2 + y_1 y_2}{x_2^2 + y_2^2} + \frac{x_2 y_1 - x_1 y_2}{x_2^2 + y_2^2}i.$$

###### and in *polar* coordinates

$$mulComplex: \mathbb C \times \mathbb C \rightarrow \mathbb C$$
$$mulComplex: (z_1, z_2) := ((\rho(z_1), \phi(z_1)), (\rho(z_2), \phi(z_2))) \mapsto (\rho(z_1) / \rho(z_2), \phi(z_1) - \phi(z_2))$$
"

# ╔═╡ 0c54eddf-4cd1-4428-9d01-77742cc46796
function divComplex(z1, z2)
	makeZRectFromMagAng(
		magnitudeOfZRect(z1) / magnitudeOfZRect(z2),
		angleOfZRect(z1) - angleOfZRect(z2))
end # function divComplex

# ╔═╡ e86b123d-5658-4caa-9826-f400beda75ef
let
	z1 = makeZRectFromRealImag(3, -1)
	z2 = makeZRectFromRealImag(1,  2)
	z3 = divComplex(z1, z2)
end # let

# ╔═╡ a4a8db4c-f63f-49f5-8ded-753d55a9d8ad
md"
---
###### Inverse of complex number
$$z^{-1} = \frac{1}{z} = \frac{1}{z}\times\frac{\overline{z}}{\overline{z}} = \frac{\overline{z}}{z\overline{z}} = \frac{Re(\overline{z})}{|z|^2} + \frac{Im(\overline{z})}{|z|^2}$$ 

or more explicit:

$$\frac{1}{x+yi}=\frac{1}{x+yi} \times \frac{x-yi}{x-yi}=\frac{x-yi}{x^2+y^2}$$
$$=\frac{x}{x^2+y^2}-\frac{y}{x^2+y^2}i.$$
"

# ╔═╡ 47de4dbc-7f48-42cd-a4ed-0ef524262fd8
let
	z1 = makeZRectFromRealImag(1,  0)  # 1 + 0i = 1
	z2 = makeZRectFromRealImag(1,  2)  # 1 + 2i
	z3 = divComplex(z1, z2)            # 1/(1 + 2i) = 1/5 + 2/5i = 0.2 + 0.4i
end # let      

# ╔═╡ 78c508b3-40e1-45fd-80b3-70174ea7b5b3
md"
---
#### 2.3.1.3 idiographic Julia
"

# ╔═╡ 8d659f59-ba30-4960-a755-866b08f270a0
md"
##### Example
"

# ╔═╡ 795ca456-6ca6-4d11-b2fc-8a9014a653ad
md"
###### Definition of $$z$$
"

# ╔═╡ ed0dd90d-253b-45ab-a6c1-3bc25c5aeac9
md"
$$z = x + yi = 2 + 1i$$
"

# ╔═╡ 2c6136a7-aaea-4f34-8cf0-e6c59051c669
z = 2 + 1im

# ╔═╡ b818345b-d79b-41a4-8b6c-1e88248a2089
let
	xlim  = (-1.5, 4.5); ylim = (-1.5, 1.5)
	ϕ = atan(1/2)
	radius = 1.0
	r = sqrt(2^2 + 1^2)
	z1 = r*exp(im*ϕ)
	z2 = real(z)/r + -2*imag(z)/r*im
	z3 = z1 + z2
	circleArray = Plots.partialcircle(0, 2π, 240, radius)
	plot([(0, 0), (real(z1), imag(z1))], line=:arrow, linecolor=:green, linewidth=4, xlim=xlim, ylim=ylim, legend=false, aspect_ratio=:equal)
	plot!([(0, 0),   (real(z2), imag(z2))], line=:arrow, linecolor=:blue, linewidth=4)
	plot!([(0, 0),   (real(z3), imag(z3))], line=:arrow, linecolor=:red, linewidth=4)
	plot!([(0,-1.3), (0, 1.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([z1, z3], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(-1.3, 0),(3, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([z2, z3], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!(circleArray, linestyle=:dot, linecolor=:blue, linewidth=1)
	annotate!(2.2, 1.05, ("z1", 12, :green))
	annotate!(1.0,-1.0,  ("z2", 12, :blue))
	annotate!(3.5, 0.12, ("z3=z1+z2", 12, :red))
end # let

# ╔═╡ d1666436-a476-4ef1-a0e9-b9ad44300a09
let
	xlim  = (-1.5, 4.5); ylim = (-1.5, 2.5)
	ϕ = atan(1/2)
	radius = 1.0
	r = sqrt(2^2 + 1^2)
	z1 = r*exp(im*ϕ)
	z2 = real(z)/r + -2*imag(z)/r*im
	z3 = z1 - z2
	circleArray = Plots.partialcircle(0, 2π, 240, radius)
	plot([(0, 0), (real(z1), imag(z1))], line=:arrow, linecolor=:green, linewidth=4, xlim=xlim, ylim=ylim, legend=false, aspect_ratio=:equal)
	plot!([(0, 0),  (real(z2), imag(z2))], line=:arrow, linecolor=:blue, linewidth=4)
	plot!([(0, 0),  (-real(z2), -imag(z2))], line=:arrow, linecolor=:lightblue, linewidth=4)
	plot!([(0, 0),   (real(z3), imag(z3))], line=:arrow, linecolor=:red, linewidth=4)
	plot!([(0,-1.3), (0, 1.5)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([z1, z3], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!([(-1.3, 0),(3, 0)], linestyle=:dash, linecolor=:black, linewidth=1)
	plot!([-z2, z3], linestyle=:dash, linecolor=:blue, linewidth=1)
	plot!(circleArray, linestyle=:dot, linecolor=:blue, linewidth=1)
	annotate!( 2.2, 1.05, ("z1", 12, :green))
	annotate!( 1.0, -1.0, ("z2", 12, :blue))
	annotate!(-1.0, 1.1,  ("-z2", 12, :blue))
	annotate!( 2.2, 2.0,  ("z3=z1-z2=z1+(-z2)", 12, :red))
end # let

# ╔═╡ 69628aaf-2678-45ea-a142-64dd22b8b378
md"
$$x = Re(z) = 2$$
"

# ╔═╡ 6c6004db-cbca-4a03-800d-15593556baff
x = real(z)

# ╔═╡ 97ada40a-2491-4351-a061-88f6393d6ebe
md"
$$y = Im(z) = 1$$
"

# ╔═╡ 74e65c0f-470d-4a7f-ac67-174f6489b8fb
y = imag(z)

# ╔═╡ 28d542a3-6a16-4c65-a0a1-02e5d8b48439
md"
$$|z| = r = \rho = \sqrt{Re(z)^2+Im(z)^2} = \sqrt{2^2+1^2}=\sqrt{5}$$
"

# ╔═╡ 35ccdb87-274f-40e3-a40e-28e441d85655
r = abs(z)

# ╔═╡ 84f33549-7f10-451b-843f-a877a4d6c6b7
md"
$$\overline{z} = Re(z) - Im(z)$$
"

# ╔═╡ eafa2a8d-b1f4-4775-97d4-9d8f028a5324
zConj = conj(z)

# ╔═╡ 79e50aad-169b-4f7f-99d9-22d612616c06
md"
*Magnitude* or *norm* of complex vector $$z$$ is :

$$r = \rho = |z| = <z, z>^{1/2}$$ 
$$<z, z> = z^T \overline{z} = (Re(z) + Im(z)) \cdot (Re(z) - Im(z)) = x^2 + y^2$$ 
"

# ╔═╡ 3e9f674f-eb16-4f07-9a0f-65fbd4c93e54
zzConj = z * zConj

# ╔═╡ 90455237-27dc-4a4e-bbd5-c6d9931c60be
sqrt(real(z * zConj))

# ╔═╡ c03a9225-e65e-4a5f-aa44-50220d4376fa
abs(z) == sqrt(2^2 + 1^2) == sqrt(5) == sqrt(real(z * zConj))

# ╔═╡ d1b38ce9-a820-4344-9aa5-41b627f8eeb3
md"
$$\angle{z} = \phi = arctan(Im(z)/Re(z)) = arctan(1/2)$$
"

# ╔═╡ 21df5a65-3128-42b5-9f00-09dd686ced91
ϕ = angle(z)

# ╔═╡ 1fd749ff-a089-4e07-8598-80e95b964842
angle(z) == atan(imag(z)/real(z)) == atan(1/2)

# ╔═╡ e6a8e690-ea92-4657-a69e-a8d58b63b661
md"
###### Euler's formula
$$r \cdot e^{i\cdot \phi}$$
"

# ╔═╡ a5e1439e-571d-4705-895d-8ca72cd0c82c
r*exp(im*ϕ)             # (red) point on circle with radius r <> 1

# ╔═╡ 34250530-f803-44db-8f84-9828acf99d77
md"
$$e^{i\cdot \phi}$$
"

# ╔═╡ c7500900-5f03-4187-b496-d680d943454d
exp(im*ϕ)               # (blue) point on circle with radius r == 1

# ╔═╡ b28ec3ec-3a21-4ac5-a934-1573f00f5ebf
md"
$$e^{i\cdot \phi} == e^{\phi \cdot i}$$
"

# ╔═╡ ae49dcc4-4648-41a4-9bed-ef200bb66588
exp(im*ϕ) == exp(ϕ*im)  # '*' should be placed between variable name and 'im' 

# ╔═╡ 0fb878b7-1e8d-4190-a0d7-96f9bceeb606
md"
###### Euler's identity
"

# ╔═╡ 8cc23ffa-6134-4e73-88da-5fefb6ff69b8
π

# ╔═╡ 5b432ada-6370-4ff0-ad6c-2879cbb351f6
π*im

# ╔═╡ e1cf1510-9c18-43fe-ba9e-e90e2cfc6c08
exp(π*im)

# ╔═╡ 35ab6cc8-651a-4f40-89a0-deef8670cb15
abs(exp(π*im) - (-1 + 0im)) < 10.0E-10

# ╔═╡ 75c52cf4-9308-42a4-a26d-2c878fbc42d3
abs(exp(π*im) + 1 - 0im) < 10.0E-10

# ╔═╡ a5464136-3ac2-4225-b838-ec070e24b7b1
md"
###### Addition in $$\mathbb C$$
"

# ╔═╡ 21e54832-cc62-4662-94f6-7ed5399ef609
let
	z1 = Complex(2, 1)
	r1 = abs(z1)
	z2 = Complex(real(z1)/r1, -2*imag(z1)/r1)
	z3 = z1 + z2
end # let

# ╔═╡ 611e4d99-9efd-41b2-8b9c-39c76c4e7255
md"
###### Subtraction in $$\mathbb C$$
"

# ╔═╡ 8ef6ff4c-d780-4909-93f3-9fb88f89aefb
let
	z1 = Complex(2, 1)
	r1 = abs(z1)
	z2 = Complex(real(z1)/r1, -2*imag(z1)/r1)
	z3 = z1 - z2
end # let

# ╔═╡ 13fba1b1-ff87-41fe-bf30-b11ae89c072c
md"
###### Multiplication in $$\mathbb C$$
"

# ╔═╡ 21b3eb3f-023d-465e-937c-712272b5ec56
let
	z1 = Complex(2, -1)
	z2 = Complex(2, 2)
	z3 = z1 * z2
end # let

# ╔═╡ 85a7d6ba-609c-4c72-83cf-652a74f358b2
md"
---
###### *Division* in $$\mathbb C$$
[Result](https://www.intmath.com/complex-numbers/convert-polar-rectangular-interactive.php) is a complex number in *rectangular* coordinates
The formula can be found [here](https://www.cuemath.com/numbers/division-of-complex-numbers/).

$$\frac{x_1 + y_1i}{x_2 + y_2i} = \frac{x_1 + y_1i}{x_2 + y_2i} \times \frac{x_2 - y_2i}{x_2 - y_2i}=\frac{(x_1 + y_1i)(x_2 - y_2i)}{(x_2 + y_2i)(x_2 - y_2i)}$$

$$=\frac{(x_1 x_2 + y_1 y_2) + (x_2 y_1 - x_1 y_2)i}{x_2^2 + y_2^2}.$$

Example:

$$\frac{3-1i}{1+2i}=\frac{3-1i}{1+2i}\times\frac{1-2i}{1-2i}=\frac{(3-1i)(1-2i)}{(1+2i)(1-2i)}$$

$$= \frac{(3\cdot1-1\cdot2)+(1\cdot-1-3\cdot2)i}{1^2+2^2}$$
$$=\frac{1-7i}{5}=\frac{1}{5}-\frac{7}{5}i=0.2-1.4i.$$
"

# ╔═╡ 6c3a4af2-841c-4318-a4ff-9d3118bb26fd
let
	z1 = Complex(3, -1)
	z2 = Complex(1, 2)
	z3 = z1 / z2
end # let

# ╔═╡ cd2c4c81-34fc-4402-a31f-500b944b6ee6
md"
---
###### Inverse of complex number
$$z^{-1} = \frac{1}{z} = \frac{1\overline{z}}{z\overline{z}} = \frac{\overline{z}}{|z|^2}.$$

or more explicit:

$$(x+yi)^{-1} = \frac{1}{x+yi}=\frac{1}{x+yi} \times \frac{x-yi}{x-yi}=\frac{x-yi}{x^2+y^2} = \frac{x}{x^2+y^2}-\frac{yi}{x^2+y^2}.$$

Example:

$$(1+2i)^{-1}=\frac{1}{1+2i}=\frac{1+0i}{1+2i}\times\frac{1-2i}{1-2i}=\frac{1-2i}{1^2+2^2}=\frac{1-2i}{5}$$
$$=\frac{1}{5}-\frac{2}{5}i = 0.2-0.4i.$$
"

# ╔═╡ a7d52bed-d5b0-4f74-b1df-3b7acb00f8e0
let
	z1 = Complex(1, 0)
	z2 = Complex(1, 2)
	z3 = z1 / z2
end # let

# ╔═╡ c898ef69-ff89-4846-88ed-c39245c62256
md"
---
"

# ╔═╡ b0270d5f-d6b0-4a05-80f7-0b8d86ecdf84
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, https://sarabander.github.io/sicp/, last visit 2022/09/23

- **Feynman, R.P.**; The Feynman Lectures on Physics. Vol. I. Addison-Wesley, 1977.

- **Wikipedia**, Euler's formula, https://en.wikipedia.org/wiki/Euler%27s_formula, last visit 2022/10/09

- **Wikipedia**, Euler's identity, https://en.wikipedia.org/wiki/Euler%27s_identity, last visit 2022/10/06
"


# ╔═╡ b9e5ea98-ce2d-4594-965e-e8003a5d86ef
md"
---
##### end of ch 2.3.4
"



# ╔═╡ 0f6da3d6-bcc7-49d8-a347-c7c68b2526e9
md"
---
This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

---
"


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
Plots = "~1.35.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "0534ab805c6602c4a71fb94d38bee348c94d5259"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

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
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

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
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "fb83fbe02fe57f2c068013aa94bcdf6760d3a7a7"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+1"

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
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "e8c58d5f03b9d9eb9ed7067a2f34c7c371ab130b"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.4.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

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
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

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
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "6872f9594ff273da6d13c7c1a1545d5a8c7d0c1c"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.6"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

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
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "ebe81469e9d7b471d7ddb611d9e147ea16de0add"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.2.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "6c01a9b494f6d2a9fc180a08b182fcb06f0958a0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "524d9ff1b2f4473fef59678c06f9f77160a204b1"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "612a4d76ad98e9722c8ba387614539155a59e30c"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.0"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "9b1c0c8e9188950e66fc28f40bfe0f8aac311fe0"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.7"

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
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

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

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

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
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

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

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

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
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

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
# ╟─e39aed1d-58a3-40e6-8a73-27204b742f42
# ╟─d87312c3-36cc-4d5d-9d3f-fd9da02bdadb
# ╠═90aa1e17-89f8-4884-9a3b-e58acf87bc7a
# ╟─b4ce58d8-c130-4c4f-904d-deccef8940cf
# ╟─576d32a1-4aa4-414d-84a5-99a1f5bc3208
# ╟─24a94004-d2f6-40f2-9596-0d2467fe8f4b
# ╟─c2bfc649-b5b1-4e75-83f4-76d2aa57bc5b
# ╟─eb2b46af-1eda-4b19-988d-ab8b2f7c3525
# ╟─46638e2b-704f-43df-9b61-a387762f78c9
# ╟─724ba211-8069-43b8-99b1-55d755ed3c68
# ╟─afd5a931-b8ad-46f8-b0f2-894d59d53959
# ╟─e791db57-a399-47fe-ac45-f4a61c493473
# ╟─262fb6be-d103-4407-b30b-ff5293ce2bea
# ╟─6d2eea9e-fd56-43c6-95a7-3d565dd0836a
# ╟─1e2aa2f3-81a8-4252-be4f-aa575918a67b
# ╟─4dc1459c-070f-4970-9e67-c9facdc15cef
# ╠═82578c79-a6f3-4374-8ee2-aa8a585f4b4a
# ╠═8a06336c-044c-4091-b7ae-f4ea60b97afa
# ╠═ed5d2b26-d30a-4d13-8eef-6e1175699f57
# ╠═f1181c0f-0127-4761-a471-757f71dddb97
# ╟─2e5ccb79-6d54-4b84-9a78-633ed533c1dc
# ╠═43b5159b-40b1-41fb-8547-a889b8e9e729
# ╠═5a5a7926-7733-40cd-8ab9-583a15e534ba
# ╠═04532459-8d67-4ea2-9b32-f010e3100932
# ╠═7cde6bad-2ff7-4fec-bed6-b5d00adfb0ba
# ╟─c02043ce-730e-42e1-ae7d-96963bdb4a75
# ╟─ad27ac18-e0f8-4b63-942d-e5a24efbd168
# ╠═ace9faf1-33cf-4086-b6aa-9b1fad9ddd82
# ╠═0bb28e73-6374-4b59-8070-d6964a53c20c
# ╠═6f3732d7-f9e6-4c6b-8a18-47e128337531
# ╠═4775c4b5-c6e0-45da-8a1c-33070e5348ed
# ╠═9c4e42b6-a630-4263-95b0-40c072763410
# ╠═fe8c3cae-b495-4670-983f-fcef9d72e98f
# ╟─420220d7-586f-4f26-b107-e68677d10b5b
# ╠═e48844ca-fa46-4c8f-9bb8-f2d33ad7fdad
# ╠═42b1742d-da96-4ea7-b5a8-288ea45d035c
# ╠═fd0dcca8-dd8a-416d-91d2-469f81dba264
# ╠═55535d43-7c35-4ac1-9bf8-22881647651d
# ╠═60dead94-fe17-412a-8574-e7ba010090ca
# ╠═93dc4413-e5f8-4df8-9798-f1189962e4e7
# ╟─74fd815e-34fa-4f89-aa06-d19ed3ca382f
# ╟─64035b6c-2596-4977-bafb-96b2a0a0d90b
# ╟─b818345b-d79b-41a4-8b6c-1e88248a2089
# ╟─ff97e2e0-d581-470d-bdfb-92c4822e7970
# ╟─27d313ff-84f8-44bb-ae90-9e71fed9d106
# ╠═43a53b2a-0a0d-41a5-8e7c-b3106d999272
# ╠═37766cb9-6453-47a5-b127-a87fb100f868
# ╟─f4ee47dc-6059-4980-86a5-15b122b56751
# ╟─d1666436-a476-4ef1-a0e9-b9ad44300a09
# ╟─4db3fda8-63e9-48ab-ba9d-431f2ac7e061
# ╟─c635a131-54c0-4530-9735-07fc558240fb
# ╠═6c151933-886d-4774-a380-1ba185a1070d
# ╠═e3cb6006-4bf0-497c-8420-55637737a981
# ╟─ceed4c01-d4ca-47a7-add3-b14c775d95d8
# ╟─46f29c21-f7c6-416f-8915-a957abf74186
# ╟─36cf2a48-6f57-4a78-a55d-cab8199eba97
# ╟─a064adda-624f-4dd6-9521-1dcfb2840189
# ╠═f179ef07-e391-4894-a5f2-6cef7659e592
# ╠═25151974-8b0b-4e33-ac6c-927e695789d0
# ╟─1fb809a4-7218-41c3-a54d-b524ab8192f9
# ╟─72e9c6eb-6404-4fc8-bafa-996d335734fe
# ╟─f799d74f-5629-4171-86f1-d1ef772a617b
# ╠═0c54eddf-4cd1-4428-9d01-77742cc46796
# ╠═e86b123d-5658-4caa-9826-f400beda75ef
# ╟─a4a8db4c-f63f-49f5-8ded-753d55a9d8ad
# ╠═47de4dbc-7f48-42cd-a4ed-0ef524262fd8
# ╟─78c508b3-40e1-45fd-80b3-70174ea7b5b3
# ╟─8d659f59-ba30-4960-a755-866b08f270a0
# ╟─795ca456-6ca6-4d11-b2fc-8a9014a653ad
# ╟─ed0dd90d-253b-45ab-a6c1-3bc25c5aeac9
# ╠═2c6136a7-aaea-4f34-8cf0-e6c59051c669
# ╟─69628aaf-2678-45ea-a142-64dd22b8b378
# ╠═6c6004db-cbca-4a03-800d-15593556baff
# ╟─97ada40a-2491-4351-a061-88f6393d6ebe
# ╠═74e65c0f-470d-4a7f-ac67-174f6489b8fb
# ╟─28d542a3-6a16-4c65-a0a1-02e5d8b48439
# ╠═35ccdb87-274f-40e3-a40e-28e441d85655
# ╟─84f33549-7f10-451b-843f-a877a4d6c6b7
# ╠═eafa2a8d-b1f4-4775-97d4-9d8f028a5324
# ╟─79e50aad-169b-4f7f-99d9-22d612616c06
# ╠═3e9f674f-eb16-4f07-9a0f-65fbd4c93e54
# ╠═90455237-27dc-4a4e-bbd5-c6d9931c60be
# ╠═c03a9225-e65e-4a5f-aa44-50220d4376fa
# ╟─d1b38ce9-a820-4344-9aa5-41b627f8eeb3
# ╠═21df5a65-3128-42b5-9f00-09dd686ced91
# ╠═1fd749ff-a089-4e07-8598-80e95b964842
# ╟─e6a8e690-ea92-4657-a69e-a8d58b63b661
# ╠═a5e1439e-571d-4705-895d-8ca72cd0c82c
# ╟─34250530-f803-44db-8f84-9828acf99d77
# ╠═c7500900-5f03-4187-b496-d680d943454d
# ╟─b28ec3ec-3a21-4ac5-a934-1573f00f5ebf
# ╠═ae49dcc4-4648-41a4-9bed-ef200bb66588
# ╟─0fb878b7-1e8d-4190-a0d7-96f9bceeb606
# ╠═8cc23ffa-6134-4e73-88da-5fefb6ff69b8
# ╠═5b432ada-6370-4ff0-ad6c-2879cbb351f6
# ╠═e1cf1510-9c18-43fe-ba9e-e90e2cfc6c08
# ╠═35ab6cc8-651a-4f40-89a0-deef8670cb15
# ╠═75c52cf4-9308-42a4-a26d-2c878fbc42d3
# ╟─a5464136-3ac2-4225-b838-ec070e24b7b1
# ╠═21e54832-cc62-4662-94f6-7ed5399ef609
# ╟─611e4d99-9efd-41b2-8b9c-39c76c4e7255
# ╠═8ef6ff4c-d780-4909-93f3-9fb88f89aefb
# ╟─13fba1b1-ff87-41fe-bf30-b11ae89c072c
# ╠═21b3eb3f-023d-465e-937c-712272b5ec56
# ╟─85a7d6ba-609c-4c72-83cf-652a74f358b2
# ╠═6c3a4af2-841c-4318-a4ff-9d3118bb26fd
# ╟─cd2c4c81-34fc-4402-a31f-500b944b6ee6
# ╠═a7d52bed-d5b0-4f74-b1df-3b7acb00f8e0
# ╟─c898ef69-ff89-4846-88ed-c39245c62256
# ╟─b0270d5f-d6b0-4a05-80f7-0b8d86ecdf84
# ╟─b9e5ea98-ce2d-4594-965e-e8003a5d86ef
# ╟─0f6da3d6-bcc7-49d8-a347-c7c68b2526e9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
