### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ af99e7d4-97bc-4d19-ad26-ef517284a750
begin 
	#----------------------------------------------------------------------------
	using Pluto
	using PlutoUI
	using Plots	
	using LaTeXStrings, Latexify
	using GraphRecipes
	using Primes
	#----------------------------------------------------------------------------
	println("pkgversion(Pluto)              = ", pkgversion(Pluto))
	println("pkgversion(PlutoUI)            = ", pkgversion(PlutoUI))
	println("pkgversion(Plots)              = ", pkgversion(Plots))
	println("pkgversion(Latexify)           = ", pkgversion(Latexify))
	println("pkgversion(GraphRecipes)       = ", pkgversion(GraphRecipes))
	println("pkgversion(Primes)             = ", pkgversion(Primes))
	#----------------------------------------------------------------------------
end # begin

# ╔═╡ 0e89b190-af42-11ec-0b2f-9d505e202de3
md"
=====================================================================================
#### SICP: 2.2.4 [Example: A Picture Language](https://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e4)
###### file: PCM20220329\_SICP\_2.2.4\_Example\_A\_Picture\_Language.jl
###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/05/31 ***
=====================================================================================
"


# ╔═╡ 0e31932e-4091-4864-ae99-03b19aa2672d
md"
---
##### 0. Introduction
	
SICP presents *a simple language for drawing pictures that illustrates the power of data abstraction and closure, and also exploits higher-order procedures in an essential way. The language is designed to make it easy to experiment with patterns ... which are composed of repeated elements that are shifted and scaled.*

*In this language, the data objects being combined are represented as procedures rather than as list structure. Just as cons, which satisfies the closure property, allowed us to easily build arbitrarily complicated list structure, the operations in this language, which also satisfy the closure property, allow us to easily build arbitrarily complicated patterns.* (SICP, 1996, p.126)

Under *closure* SICP means the *mathematical* [concept of closure](https://en.wikipedia.org/wiki/Closure_(mathematics)) but not the *computer science* [concept of closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)). The problem here is to obtain a set of simple functions within Julia that meet the special requirements of SICP, especially the *closure* property. 
"

# ╔═╡ 387bf705-81f7-4a88-b409-161d48d46139
md"
---
##### 1. Topics
- the *mathematical* concept of *closure*
- the *computer-science* concept of *closure*
"

# ╔═╡ a4563990-bf5f-4903-acbf-d16d50f00de3
md"
---
##### 2. Libraries, Types, Aliases, and Service Functions
###### 2.1 Libraries
"

# ╔═╡ 7c616496-8aa0-48dc-a80a-2322c63ed10b
md"
---
###### 2.2 *Self-defined* Types
"

# ╔═╡ 5997f326-5df3-40c0-b6e3-9e01ab1dbc50
md"
---
###### 2.3 *Abbreviations* (*alias* names)

The purpose of *aliases* is to bind *short* SICP-like function names to *long, informative* Julian counterparts.
"

# ╔═╡ 3163ae96-b718-4de7-b337-f1f7dfac3dd0
md"
---
###### 2.4 *Service* Functions
"

# ╔═╡ 4c2d7571-b6f2-4e1e-80da-3e10790d6e83
md"
---
##### 3. *SICP-Scheme-like* Functional Julia
"

# ╔═╡ 5b4e53e5-4260-4f14-bdc8-d10cf4263316
md"
---
##### 3.1 *Picture* Vector in *Old* and *New* Frames

###### *old* Frame $I$:

- column vector $u_1$; written here as row vector $i_1' = [1, 0]$, 

- column vector $u_2$; written here as row vector $i_2' = [0, 1]$, 

###### *picture* vector $x$ in *old* frame $I$

- column vector $x$; written here as row vector $x' = \left[\frac{1}{2}, \frac{1}{2}\right]$, 

###### *new* Frame $A$:

- column vector $a_1$; written here as row vector $a_1' = \left[1, \frac{1}{2}\right]$, 
- column vector $a_2$; written here as row vector $a_2' = \left[\frac{1}{2}, 1\right]$, 

###### *picture* vector $y$ in *new* frame $A$

- column vector $y$, written here as row vector $y' = \left[\frac{1}{3}, \frac{1}{3}\right]$, 

"

# ╔═╡ 54e00170-2a57-4ba0-80a8-f35d1ab0a804
I = [1 0; 0 1]        # [i1, i2]   *old* frame $I$ with column vectors $i1, i2$

# ╔═╡ 0f1b30d5-c313-48ca-8f54-9eaee0ab8c77
A = [1  1/2;          # [a1, a2]   *new* frame $A$ with column vectors $a1, a2$
     1/2  1]

# ╔═╡ 9657345f-956b-4068-a421-e24b28dde74d
y = [1/3; 1/3]        # y = coordinates in new frame A

# ╔═╡ 8363136c-79ac-42e7-8127-b99c745bb7f2
x = A*y # = I*x       # x = coordinates in old frame I

# ╔═╡ fd5ec178-acc6-4380-9efc-fb71ee38963e
inv(A)*x              # inv(A)*x = y = coordinates in new frame A

# ╔═╡ b8e7d727-d814-494e-b048-aecb166259f9
function plotPictureVector()
	pictureVector = [(0,0), (1/2, 1/2)]  # in old frame I
	a1T = [(0, 0), (1, 1/2)]       # transpose a1T of column vector a1 of new frame A
	a2T = [(0, 0), (1/2, 1)]       # transpose a2T of column vector a2 of new frame A
	a1Tcoord = [(1/3*1/2, 1/3*1),   (1-1/2, 1/2)] 
	a2Tcoord = [(1/3*1,   1/3*1/2), (1/2, 1-1/2)]
	plot(pictureVector, xlims=(0, 1), ylims=(0, 1), arrow=true, lw=2, aspect_ratio=1, color=:red)
	scatter!((1/2, 1/2))
	plot!(a1T, arrow=true, lw=1, ls=:dot, color=:blue)
	plot!(a2T, arrow=true, lw=1, ls=:dot, color=:blue)
	plot!(a1Tcoord, arrow=true, lw=1/2, ls=:dash, color=:blue)
	plot!(a2Tcoord, arrow=true, lw=1/2, ls=:dash, color=:blue)
	scatter!((1/3*1/2, 1/3*1),   color=:blue)
	scatter!((1/3*1,   1/3*1/2), color=:blue)
	annotate!((1/2 + 0.21, 1/2), "(1/2, 1/2)=(x1, x2)", 10)
	annotate!((1/3*1 + 0.09,   1/3*1/2), "y1=1/3", 10)
	annotate!((1/3*1/2 - 0.09, 1/3*1), "y2=1/3", 10)
end # function plotPictureVector

# ╔═╡ 3df07686-b031-4d5f-8d19-f43e4eeb29a8
plotPictureVector()

# ╔═╡ 028a5028-eb2d-4144-8858-fa07636a9cc2
md"
---
##### 3.2 Painter $wave$ Implementation without Frames
"

# ╔═╡ 3f427b62-013f-4482-8adc-c77e9bbe3a40
wavemanURL = "https:/mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/ch2-Z-G-26.gif"

# ╔═╡ c2da7a1f-ed98-440c-b0e0-00c763e540a5
md"
$(PlutoUI.Resource(wavemanURL))

**Fig. 2.2.4.1**: Simple Wave Man (c.f.: SICP, 1996; 2016, p.174, p.Fig. 2.10, top left): 

"

# ╔═╡ 4b322095-81e2-437c-aab7-30091a308729
md"
##### 'WaveMan' (ako 'Wave')
"

# ╔═╡ ba3519f0-e8f0-40d3-9cb9-e365310359ee
md"
###### 1st *method* of function 'makeWaveMan' (specialized with *two* arguments)
"

# ╔═╡ 04761c70-e9ea-4ba8-a24b-18db11578ca9
function makeWaveMan(x0, y0; normalize=false)
	#--------------------------------------------------------------------------------
	function polarToCartesianCoordinates(r, d) 
			(x, y) = (r * cosd(d), r * sind(d))
	end
	#--------------------------------------------------------------------------------
	function shapeOfEye(;r=0.4)
		shapeOfUnitCircle = [polarToCartesianCoordinates(r, degree) for degree in 0:15:360]
		xsOfCircle = [shapeOfUnitCircle[i][1] for i in 1:25]
		ysOfCircle = [shapeOfUnitCircle[i][2] for i in 1:25]
		(xsOfCircle, ysOfCircle)
	end
	#--------------------------------------------------------------------------------
	function normalizeZ(minX, lengthX, xs)
		[(x - minX) / lengthX for x in xs]
	end
	#--------------------------------------------------------------------------------
	xsBody = x0 .+ [4, 7, 8.5, 10.5, 13.5, 10.5, 18, 18, 13.5, 10.5, 11.5, 10.5, 7, 5.5, 6.5, 4.5, 2, -1, -1, 2, 4.5, 5.5, 4]         # x-coordinates of body
	ysBody = y0 .+ [.5, .5, 6, .5, .5, 9, 3.5, 7.5, 13, 13, 17, 20, 20, 17, 13, 13, 12, 17, 13, 8, 12, 10, .5]                        # y-coordinates of body
	xsMouth    = x0 .+ [ 7.5,  8.0,  9.0,  9.5,  7.5] # x-coordinates of mouth
	ysMouth    = (y0 - 0.5) .+ [16.0, 15.5, 15.5, 16.0, 16.0] # y-coordinates of mouth
	xsNose     = x0 .+ [ 8.0,  9.0,  8.5]             # x-coordinates of nose
	ysNose     = (y0 -  0.8) .+ [17.0, 17.0, 18.0]    # y-coordinates of nose
	xsLeftEye  = (x0 +  7.0) .+ shapeOfEye()[1]       # x-coordinates of left eye
	ysLeftEye  = (y0 + 17.2) .+ shapeOfEye()[2]       # y-coordinates of left eye
	xsRightEye = (x0 + 10.0) .+ shapeOfEye()[1]       # x-coordinates of right eye
	ysRightEye = (y0 + 17.2) .+ shapeOfEye()[2]       # y-coordinates of right eye
	#--------------------------------------------------------------------------------
	if normalize !== false
		# normalize data points so that all points of figure lay inside a unit square
		minX = minimum(xsBody); maxX = maximum(xsBody)
		minY = minimum(ysBody); maxY = maximum(ysBody)
		lengthX = maxX - minX
		lengthY = maxY - minY
		normalizedXsBody     = normalizeZ(minX, lengthX, xsBody)
		normalizedYsBody     = normalizeZ(minY, lengthY, ysBody)
		normalizedXsMouth    = normalizeZ(minX, lengthX, xsMouth)
		normalizedYsMouth    = normalizeZ(minY, lengthY, ysMouth)
		normalizedXsNose     = normalizeZ(minX, lengthX, xsNose)
		normalizedYsNose     = normalizeZ(minY, lengthY, ysNose)
		normalizedXsLeftEye  = normalizeZ(minX, lengthX, xsLeftEye)
		normalizedYsLeftEye  = normalizeZ(minY, lengthY, ysLeftEye)
		normalizedXsRightEye = normalizeZ(minX, lengthX, xsRightEye)
		normalizedYsRightEye = normalizeZ(minY, lengthY, ysRightEye)
	else
		normalizedXsBody     = xsBody
		normalizedYsBody     = ysBody
		normalizedXsMouth    = xsMouth
		normalizedYsMouth    = ysMouth
		normalizedXsNose     = xsNose
		normalizedYsNose     = ysNose
		normalizedXsLeftEye  = xsLeftEye
		normalizedYsLeftEye  = ysLeftEye
		normalizedXsRightEye = xsRightEye
		normalizedYsRightEye = ysRightEye
	end # if
	#--------------------------------------------------------------------------------
	# application of constructor 'Shape'   
	(body=Shape(normalizedXsBody, normalizedYsBody), mouth=Shape(normalizedXsMouth, normalizedYsMouth), nose=Shape(normalizedXsNose, normalizedYsNose), leftEye=Shape(normalizedXsLeftEye, normalizedYsLeftEye), rightEye=Shape(normalizedXsRightEye, normalizedYsRightEye),layout=1)  
end

# ╔═╡ ac03c7c1-9130-41f7-b5c0-5e10feac5171
md"
###### *unnormalized* 'waveMan'
"

# ╔═╡ bfa1b271-ae58-42c3-97f7-7fac72aae1f1
md"
###### *normalized* 'waveMan' (fits into [0, 1] x [0, 1] *unit* square)
"

# ╔═╡ 86a0b38a-fe3b-4520-9800-099f714b90e9
md"
###### 2nd (default) *method* of function 'makeWaveMan' (*without* arguments)
"

# ╔═╡ 5a1268af-abe6-4ac2-b350-0a8253864ba8
function makeWaveMan(;normalize=false)
	#-----------------------------------------------------------------------------
	function makeBody(x0, y0; normalize=normalize)::Shape{Float64, Float64}
   		makeWaveMan(x0, y0, normalize=normalize).body  
	end
	function makeMouth(x0, y0; normalize=normalize)::Shape{Float64, Float64}
   		makeWaveMan(x0, y0, normalize=normalize).mouth
	end
	function makeNose(x0, y0; normalize=normalize)::Shape{Float64, Float64}
   		makeWaveMan(x0, y0, normalize=normalize).nose
	end
	function makeLeftEye(x0, y0; normalize=normalize)::Shape{Float64, Float64}
   		makeWaveMan(x0, y0, normalize=normalize).leftEye
	end
	function makeRightEye(x0, y0; normalize=normalize)::Shape{Float64, Float64}
   		makeWaveMan(x0, y0, normalize=normalize).rightEye
	end
	#-----------------------------------------------------------------------------	
		body = makeBody(0, 0, normalize=normalize)
	   mouth = makeMouth(0, 0, normalize=normalize)
	    nose = makeNose(0, 0, normalize=normalize)
	 leftEye = makeLeftEye(0, 0, normalize=normalize)
	rightEye = makeRightEye(0, 0, normalize=normalize)
	 waveMan = hcat(body, mouth, nose, leftEye, rightEye)
	#-----------------------------------------------------------------------------	
	(body=waveMan, layout=1)
end

# ╔═╡ fe4cd255-99db-43f6-8586-9bed87a55437
makeWaveMan(0, 0)

# ╔═╡ fadc4de4-128f-4717-b10e-478650a89eb0
typeof(makeWaveMan(0, 0))

# ╔═╡ 852d557c-bd92-4408-8b6c-2e18cec1ff3e
plot(makeWaveMan(0, 0).body, layout=makeWaveMan(0, 0).layout, colour=:cornflowerblue, opacity=0.4, xlims=(-2,19), ylims=(0, 23), ratio=:equal, xlabel="X", ylabel="Y", label=false, title="makeWaveMan(0, 0).image")

# ╔═╡ aa5c9420-c0b2-407f-a2da-595e78503800
plot(makeWaveMan(0, 0, normalize=true).body, layout=makeWaveMan(0, 0, normalize=true).layout, colour=:cornflowerblue, label=false, legend=false, opacity=0.4, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), ratio=:equal, xlabel="X", ylabel="Y", title="makeWaveMan(0, 0, normalize=true).body")

# ╔═╡ 46027a5b-36e2-4538-8b24-f3bdafc2f625
makeWaveMan()

# ╔═╡ 7ddfcf3f-ee06-40ad-b87f-b8aab427327e
plot(makeWaveMan().body, layout=makeWaveMan().layout, xlims=(-1, 18),  ylims=(0,22), colour=:cornflowerblue, opacity=0.4, linecolour=:cornflowerblue, ratio=:equal, legend=false, xlabel="x", ylabel="y", title="makeWaveMan().body")

# ╔═╡ b8c56544-77ee-4a9b-9c10-e696c0440c89
plot(makeWaveMan(normalize=true).body, layout=makeWaveMan().layout, xlims=(-0.1, 1.2),  ylims=(-0.1, 1.2), colour=:cornflowerblue, opacity=0.4, linecolour=:cornflowerblue, ratio=:equal, legend=false, xlabel="x", ylabel="y", title="makeWaveMan(normalize=true).body")

# ╔═╡ acc2e14a-67d8-45a3-a585-09085fed2e2d
makeWaveMan()

# ╔═╡ bf095bf1-bf59-4aee-86cc-15e6505377f3
md"
---
#### 3.3 *transpilation* of SICP-chapter 2.2.4 with *idiomatic typed* Julia functions
"

# ╔═╡ 920ca7c2-c761-4bcd-ab8e-9dd9897c575b
md"
---
##### 3.3.1 Basics
"

# ╔═╡ fc243a78-4679-4a34-a7b3-50daff85fe30
list(xs::Any...)::Array = [xs::Any...]::Array

# ╔═╡ 1a4784b2-9699-4145-a990-3b6f8ee18d42
FloatOrSigned = Union{AbstractFloat, Signed}

# ╔═╡ fa6a303a-4929-4536-83ea-8d0df9a92320
md"
###### Exercise 2.46: *constructor* and *selectors* for vectors of type '*Vect*'
"

# ╔═╡ 47425a32-bee9-4067-8a83-6232c9a78e19
struct Vect
	x::FloatOrSigned
	y::FloatOrSigned
end

# ╔═╡ 2afa5704-34aa-4ef7-b922-a4361526e81f
makeVect(x::FloatOrSigned, y::FloatOrSigned) = Vect(x, y)

# ╔═╡ 31d6aba9-2f4f-4562-8344-15cb1f6d1176
xcorVect(v::Vect)::FloatOrSigned = v.x

# ╔═╡ ede8e63c-8063-49d7-8a2d-d71cf943b7ac
ycorVect(v::Vect)::FloatOrSigned = v.y

# ╔═╡ 1559f2dd-90c5-49ba-b8e7-9c1f5aadb667
addVect(v1::Vect, v2::Vect) = makeVect(v1.x + v2.x, v1.y + v2.y)

# ╔═╡ 41d9b94b-d3c8-42d5-ae34-de447726054a
subVect(v1::Vect, v2::Vect) = makeVect(v1.x - v2.x, v1.y - v2.y)

# ╔═╡ b9b5bc3f-a3f8-4d6f-ae1f-364cc33b9583
scaleVect(s::FloatOrSigned, v::Vect) = makeVect(s * v.x, s * v.y)

# ╔═╡ f8e414a2-105c-4865-b25b-57ded04d2468
makeVect(0, 0)

# ╔═╡ 498e7c79-dfef-4448-8cc0-e6022b145110
makeVect(0, 0).x

# ╔═╡ d55945d3-2dc2-478a-b639-09b5fdd35d24
makeVect(0, 0).y

# ╔═╡ bab0efeb-5bda-48b0-bc65-5db529d71753
md"
---
##### 3.3.2 Frames
"

# ╔═╡ 08b351c8-0205-4ad7-a1d9-4092f4b419e2
md"
###### Exercise 2.47: *constructor* and *selectors* for frames of type '*Frame*'
"

# ╔═╡ 58340172-ccac-4c38-bbac-3de63e2898f8
struct Frame
	origin::Vect
	edge1::Vect
	edge2::Vect
end

# ╔═╡ 0e88e7e2-7dda-4b0e-9496-1cf6e1511595
function makeFrame(;origin::Vect, edge1::Vect, edge2::Vect)::Frame
	Frame(origin, edge1, edge2)
end

# ╔═╡ 8ce3b43f-1d8c-4b4b-8a50-e5c99aa27b9a
origin(frame::Frame)::Vect = frame.origin

# ╔═╡ b2f33856-939e-4830-aabe-33853036957c
edge1(frame::Frame)::Vect = frame.edge1

# ╔═╡ f1b6240d-8212-4e19-be8f-78148266c181
edge2(frame::Frame)::Vect = frame.edge2

# ╔═╡ 49192d52-b3bb-46e0-b88e-2b6047998b00
function frameCoordMap(frame)
	function (vect)   # 'vect' is vector to be mapped into the frame basis
		addVect(
			origin(frame),
			addVect(scaleVect(xcorVect(vect), edge1(frame)),
					scaleVect(ycorVect(vect), edge2(frame))))
	end
end

# ╔═╡ 88026c63-bc23-46eb-8b34-ed5b41a990c2
frame1 = makeFrame(origin=Vect(2, 1), edge1=Vect(4, 4), edge2=Vect(0, 2))

# ╔═╡ d161baef-a8e4-4055-b80b-5d14daf040a1
origin(frame1)

# ╔═╡ 0aaf6909-38fc-4e1a-bfe4-c1739b55648d
edge1(frame1)

# ╔═╡ 600f7c1d-4f43-40b7-8b55-eef40de023a2
edge2(frame1)

# ╔═╡ 9bbe1659-18e8-4821-a2d6-73b25ccb31e6
frameCoordMap(frame1)(makeVect(0, 0))

# ╔═╡ 008b1e20-0dd0-49e7-953c-0aba79871488
frameCoordMap(frame1)(makeVect(1, 1))

# ╔═╡ e707b99b-2331-47ef-98f6-15d9f28c4ce7
frameCoordMap(frame1)(makeVect(0, 0)) == origin(frame1)

# ╔═╡ aaa0c0a9-0830-447a-af24-757c6e6186b1
md"
###### unit square $$P_{F_I}$$ *mapped* into *frame* '*makeFrame(origin=Vect(2, 1), edge1=Vect(3, 2), edge2=Vect(0, 3))*' and ...
###### ... red picture point $$p'_{F_I} = [1/2, 1/2]'$$ *mapped* into the above generated 'frame' as $$p_I$$.
"

# ╔═╡ 4669fb6f-3df2-445d-beb6-07695d2cc335
begin
	plot([frameCoordMap(frame1)(makeVect(0, 0)).x, frameCoordMap(frame1)(makeVect(0, 1)).x, frameCoordMap(frame1)(makeVect(1, 1)).x, frameCoordMap(frame1)(makeVect(1, 0)).x, frameCoordMap(frame1)(makeVect(0, 0)).x],
	[frameCoordMap(frame1)(makeVect(0, 0)).y, frameCoordMap(frame1)(makeVect(0, 1)).y, frameCoordMap(frame1)(makeVect(1, 1)).y, frameCoordMap(frame1)(makeVect(1, 0)).y, frameCoordMap(frame1)(makeVect(0, 0)).y], legend=false, xlims=(0, 7), ylims=(0, 7), ratio=:equal)
	#--------------------------------------------------------------------------------
	plot!([frameCoordMap(frame1)(makeVect(0.5, 0.5)).x], [frameCoordMap(frame1)(makeVect(0.5, 0.5)).y], markershape=:circle, markersize=3,markercolor=:red) 
	#--------------------------------------------------------------------------------
	annotate!([(3.5, 3.6, ("p_C", 10, :bottom, :blue))])
	plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.8, 2, :red)) # origin vector
	plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.8, 2, :red)) # vect1
	plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.8, 2, :red)) # vect2
	annotate!([(1.0, 0.4, ("frame origing vector", 10, :bottom, :blue))])
	annotate!([(4.2, 2.5, ("frame edge vector v1", 10, :bottom, :blue))])
	annotate!([(0.3, 1.8, ("frame edge vector v2", 10, :bottom, :blue))])
end

# ╔═╡ 7d81de72-094c-4c56-a7e1-80970050405b
function showFrame(frame::Frame)
	let origin = frame.origin,
		 edge1 = frame.edge1,
		 edge2 = frame.edge2,
		 edge3 = addVect(edge1, edge2)
		#------------------------------------------------------------------------
		xs = vcat(origin.x, origin.x+edge1.x, origin.x+edge3.x, origin.x+edge2.x, origin.x)
		ys = vcat(origin.y, origin.y+edge1.y, origin.y+edge3.y, origin.y+edge2.y, origin.y)
		#------------------------------------------------------------------------
		Shape(xs, ys)
	end
end

# ╔═╡ 6ee6d67b-0d3e-4e0e-977c-0069531627ee
showFrame(frame1)

# ╔═╡ 6bfb76c4-5a50-4844-9cdd-f39e3c118ded
md"
###### *shape* of frame '*makeFrame(origin=Vect(2, 1), edge1=Vect(3, 2), edge2=Vect(0, 3))*'
"

# ╔═╡ 8d0c08c9-4635-4750-9675-b84ba0727859
begin
	plot(showFrame(frame1), xlims=(0, 7), ylims=(0, 7), opacity=0.3, colour=:cornflowerblue, legend=false, ratio=:equal)
	#--------------------------------------------------------------------------------
	plot!([frameCoordMap(frame1)(makeVect(0.5, 0.5)).x], [frameCoordMap(frame1)(makeVect(0.5, 0.5)).y], markershape=:circle, markersize=3,markercolor=:red) 
	#--------------------------------------------------------------------------------
	annotate!([(3.5, 3.6, ("p_C", 10, :bottom, :blue))])
	plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.8, 2, :red)) # origin vector
	plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.8, 2, :red)) # vect1
	plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.8, 2, :red)) # vect2
	annotate!([(1.0, 0.4, ("frame origing vector", 10, :bottom, :blue))])
	annotate!([(4.2, 2.5, ("frame edge vector v1", 10, :bottom, :blue))])
	annotate!([(0.3, 1.8, ("frame edge vector v2", 10, :bottom, :blue))])
end

# ╔═╡ 96101227-2364-402d-bc15-4b74757df595
md"
###### *shape* of unit frame *projected* into frame '*makeFrame(origin=Vect(2, 1), edge1=Vect(3, 2), edge2=Vect(0, 3))*'
"

# ╔═╡ e29fea38-4a22-4b30-ab51-9e6bac1aae8d
begin
	plot(Shape([frameCoordMap(frame1)(makeVect(0, 0)).x, frameCoordMap(frame1)(makeVect(0, 1)).x, frameCoordMap(frame1)(makeVect(1, 1)).x, frameCoordMap(frame1)(makeVect(1, 0)).x, frameCoordMap(frame1)(makeVect(0, 0)).x],
	[frameCoordMap(frame1)(makeVect(0, 0)).y, frameCoordMap(frame1)(makeVect(0, 1)).y, frameCoordMap(frame1)(makeVect(1, 1)).y, frameCoordMap(frame1)(makeVect(1, 0)).y, frameCoordMap(frame1)(makeVect(0, 0)).y]), opacity=0.3, colour=:cornflowerblue, legend=false, xlims=(0, 7), ylims=(0, 7), ratio=:equal)
	#--------------------------------------------------------------------------------
	plot!([frameCoordMap(frame1)(makeVect(0.5, 0.5)).x], [frameCoordMap(frame1)(makeVect(0.5, 0.5)).y], markershape=:circle, markersize=3,markercolor=:red) 
	#--------------------------------------------------------------------------------
	annotate!([(3.5, 3.6, ("p_C", 10, :bottom, :blue))])
	plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.8, 2, :red)) # origin vector
	plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.8, 2, :red)) # vect1
	plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.8, 2, :red)) # vect2
	annotate!([(1.0, 0.4, ("frame origing vector", 10, :bottom, :blue))])
	annotate!([(4.2, 2.5, ("frame edge vector v1", 10, :bottom, :blue))])
	annotate!([(0.3, 1.8, ("frame edge vector v2", 10, :bottom, :blue))])
end

# ╔═╡ 8bcefd49-ab7b-4dc1-bfef-d7349a91bc46
md"
---
##### 3.3.3 Painters
"

# ╔═╡ a70ff6fe-0b70-4661-91b0-509ebeb43756
md"
###### Exercise 2.48: *constructor* and *selectors* of segments of type 'Segment'
"

# ╔═╡ 04e0f2fd-29b0-427c-bcb9-597c32feb44d
struct Segment
	startPoint::Vect
	endPoint::Vect
end

# ╔═╡ e845c43d-7bc9-40f4-836e-d00f37ee1f3d
function makeSegment(startP::Vect, endP::Vect)::Segment
	Segment(startP, endP)
end

# ╔═╡ e52e9f54-5e8c-4d58-869d-23c126e07d21
function startSegment(segment::Segment)::Vect
	segment.startPoint
end

# ╔═╡ 30f40e44-0017-47cd-bc86-904207ab13c1
function endSegment(segment::Segment)::Vect
	segment.endPoint
end

# ╔═╡ 4b277624-ee34-4c53-8c45-6a9d3a0520b4
function showSegment(segment::Segment)
	let startP = segment.startPoint,
	      endP = segment.endPoint
		#-------------------------------------------------------
		xs = vcat(startP.x, endP.x)
	    ys = vcat(startP.y, endP.y)
		#-------------------------------------------------------
		Shape(xs, ys)
	end
end

# ╔═╡ f599491e-d319-4fd4-93fc-13260ef1994b
md"
###### example: 4 segments
"

# ╔═╡ 5c155953-505d-4aa8-b0b5-f5d6df47104d
begin
	segment1 = makeSegment(makeVect(2, 1), makeVect(5, 3))
	segment2 = makeSegment(makeVect(5, 3), makeVect(5, 6))
	segment3 = makeSegment(makeVect(5, 6), makeVect(2, 4))
	segment4 = makeSegment(makeVect(2, 4), makeVect(2, 1))
	segmentList = list(segment1, segment2, segment3, segment4)
end

# ╔═╡ bba021f1-caf8-48ef-967c-1c7dde6464cf
plot([showSegment(segment) for segment in segmentList], legend=false, xlims=(0, 7), ylims=(0, 7), ratio=:equal, linewidth=4, opacity=0.4, linecolour=:cornflowerblue)

# ╔═╡ db55e00e-9056-442e-876f-1e39f014b0c7
md"
###### Two *methods* of function 'drawline' ...
###### ... the *first* for only *one* segment
"

# ╔═╡ 8d94c9ef-8821-4054-9a0b-0cb72abb50e2
function drawLine(segment::Segment; axis=false, xlims=(0.0, 1.0), ylims=(0.0, 1.0), legend=false, showaxis=false)
	#------------------------------------------------------------------------------
	plot()
	#------------------------------------------------------------------------------
	plot!(showSegment(segment), axis=axis, xlims=xlims, ylims=ylims, linewidth=4, opacity=0.4, linecolour=:cornflowerblue, legend=legend, ratio=:equal, showaxis=showaxis)
end

# ╔═╡ 0066351b-a86b-4be0-8ff9-f479a26ff699
md"
###### ... the *second* for a *list* (= array) of segments
"

# ╔═╡ b7aa0a8f-2c8b-4ff2-8efe-5b88b0009700
	#=
	===== this simple sketch with *foreach(....)* does not display an image - for whatever reason -
	
	function drawLine(segmentList::Array; xlims=(0.0, 1.0), ylims=(0.0, 1.0), legend=false, axis=false)
	#------------------------------------------------------------------------------
	plot()
	#------------------------------------------------------------------------------
	foreach(segment -> plot!(segment, xlims=xlims, ylims=ylims, linewidth=4, opacity=0.4, linecolour=:cornflowerblue, legend=legend, ratio=:equal, axis=axis), segmentList)
	=#

# ╔═╡ 24a99293-215f-4b10-bdde-dd3765679704
function drawLine(segmentList::Array; axis=false, legend=false,ratio=:equal, showaxis=false, xlims=(0.0, 1.0), ylims=(0.0, 1.0))
	#------------------------------------------------------------------------------
	function showSegments(segmentList)
		map(segment -> showSegment(segment), segmentList)
	end
	#------------------------------------------------------------------------------
	plot()
	#------------------------------------------------------------------------------
	plot!(showSegments(segmentList), axis=axis, xlims=xlims, ylims=ylims, linewidth=4, opacity=0.4, linecolour=:cornflowerblue, legend=legend, ratio=ratio)
end

# ╔═╡ c789fabd-076e-4c87-9e00-061247e41e76
drawLine(segmentList, axis=true, xlims=(0, 7), ylims=(0, 7))

# ╔═╡ 90aa8c1e-1eae-42d9-b71e-3c58a1c1169c
drawLine(segmentList, xlims=(0, 7), ylims=(0, 7), axis=true)

# ╔═╡ 029f90e8-cbd1-482c-b553-9f068bf13a48
md"
###### Vectors of 'wave' *coordinates*
"

# ╔═╡ fa14cfef-1dac-4f6f-9176-a48bfd1096ee
waveX = makeWaveMan(0, 0, normalize=true).body.x

# ╔═╡ f02ec249-22ef-4134-bf29-e7c109e2e28b
waveY = makeWaveMan(0, 0, normalize=true).body.y

# ╔═╡ b07f1822-0fe9-4e93-b16f-79e42eb602b2
scatter(waveX, waveY, ratio=:equal, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1))

# ╔═╡ a827e2b0-94dc-4474-87c6-809097827fe5
plot(waveX, waveY, colour=:cornflowerblue, legend=false, ratio=:equal, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1))

# ╔═╡ 760980ad-84e0-4b08-851a-2fa717197d1e
function makeVects(xs, ys)
	map((x, y) -> makeVect(x, y),xs, ys)
end

# ╔═╡ 5afab965-e8d4-41d1-865c-a864533ac4f6
md"
###### Sequence of 'wave' *points*
"

# ╔═╡ 983cab48-d122-4b72-a187-c0226ea7171a
waveVects = makeVects(makeWaveMan(0, 0, normalize=true).body.x, makeWaveMan(0, 0, normalize=true).body.y)

# ╔═╡ 3f03377b-9869-4f89-9b47-2fa011ca9133
md"
###### Make *segmentList* of an array of 2-dim *vectors* (= points)
"

# ╔═╡ cd7a669c-bd12-4d91-8ea0-f52001d93b2b
function makeSegments(vectXsYsSeq; normalize=false)
	if normalize !== false
		# normalize all segments so that the segemntList (= figure) lays inside a unit square
		maxX = maximum(vect -> vect.x, vectXsYsSeq)
		minX = minimum(vect -> vect.x, vectXsYsSeq)
		maxY = maximum(vect -> vect.y, vectXsYsSeq)
		minY = minimum(vect -> vect.y, vectXsYsSeq)
		lengthX = maxX - minX
		lengthY = maxY - minY
		vectXsYsSeq2X = [(vect.x - minX) / lengthX for vect in vectXsYsSeq]
		vectXsYsSeq2Y = [(vect.y - minY) / lengthY for vect in vectXsYsSeq]
		vectXsYsSeq3 = map((x, y) -> makeVect(x, y), vectXsYsSeq2X, vectXsYsSeq2Y)
		#-------------------------------------------------------------------------
	else
		vectXsYsSeq3 = vectXsYsSeq
	end # if
		segmentList = [makeSegment(vectXsYsSeq3[i], vectXsYsSeq3[i+1]) for i in 1:length(vectXsYsSeq3)-1]
		segmentList
end

# ╔═╡ 4fa6484f-c5d9-4008-abb1-e52a3d86fa7f
md"
###### *normalized* original figure 'wave' (= image) lays in the *unit* square
"

# ╔═╡ 8db80004-fe6a-4011-b382-cb5e5b2d6522
md"
###### *normalized* figure 'wave' (= image) lays in the *unit* square
"

# ╔═╡ a1cc0260-eb3f-4963-a39a-e9f77b5e5ffe
drawLine(makeSegments(waveVects, normalize=true), axis=true, xlims=(-0.05, 1.05), ylims=(-0.05, 1.05))

# ╔═╡ bec7ad15-e052-4112-a06d-0fff4760118f
plot(Shape(waveX, waveY), colour=:cornflowerblue, legend=false, opacity=0.4, ratio=:equal, xlims=(-0.01, 1.01), ylims=(-0.01, 1.01))

# ╔═╡ d261a419-5d4f-4f83-9132-e13ad706ca94
md"
###### 'waveMan' mapped (= projected) into basis (= frame)
"

# ╔═╡ d1e95027-c3b1-4590-be8b-a7a0f3252abb
md"
###### higher order *method* (= *handler*) 'segmentsToPainter' of SICP-function 'segments->painter'
"

# ╔═╡ a0928969-8fa1-42b3-ace5-ae2a9fd9685f
function segmentsToPainter(segmentList; axis=false, legend=false, xlims=(0, 1), ylims=(0, 1), ratio=:equal, showaxis=false, ticks=false)
	function(frame)                # anonymous (lambda) function
		segmentsToPlot = 
			map(segment -> 
				makeSegment(
					frameCoordMap(frame)(startSegment(segment)),
					frameCoordMap(frame)(endSegment(segment))), segmentList)
	end # anonymous (lambda) function with argument 'frame'
end

# ╔═╡ 79cfbc47-86b1-4250-a05c-d21d8c50532c
segmentsToPainter(segmentList, axis=true, xlims=(0, 40), ylims=(0, 40), showaxis=true, ticks=true)(frame1)

# ╔═╡ 1b9183ea-f236-4a50-a35d-d47e6e7c1249
begin
drawLine(segmentsToPainter(makeSegments(waveVects, normalize=true))(frame1), axis=true, xlims=(0, 7), ylims=(0, 6))
#--------------------------------------------------------------------------------
plot!([frameCoordMap(frame1)(makeVect(0.5, 0.5)).x], [frameCoordMap(frame1)(makeVect(0.5, 0.5)).y], markershape=:circle, markersize=2, markercolor=:red) 
#--------------------------------------------------------------------------------
plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.4, 2, :red)) # origin vector
plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.4, 1, :red)) # vect1
plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.4, 1, :red)) # vect2
end

# ╔═╡ 2fd64aea-95fb-431b-935e-527f5aaba8d8
md"
###### *variation* 'shapeToPainter' of higher order *method* (= *handler*) of SICP-function 'segments->painter'
"

# ╔═╡ f827ca99-414c-4e94-ae3d-6fbf3de57c4b
function shapeToPainter(shapeList::Shape; axis=false, legend=false, xlims=(0, 1), ylims=(0, 1), ratio=:equal, showaxis=false, ticks=false)
	function(frame)               # anonymous (lambda) function
		shapeToPlot =
			map((x, y) -> frameCoordMap(frame)(makeVect(x, y)), shapeList.x, shapeList.y)
		xs = map(vect -> vect.x, shapeToPlot)
		ys = map(vect -> vect.y, shapeToPlot)
		Shape(xs, ys)
	end # anonymous (lambda) function with argument 'frame'
end # function

# ╔═╡ 08fc8b77-4635-4f44-b8ae-5fc0e0171237
makeWaveMan(0, 0, normalize=true).body

# ╔═╡ 341567d3-7025-4cda-8385-72dea3d292bb
plot(makeWaveMan(0, 0, normalize=true).body, colour=:cornflowerblue, legend=false, opacity=0.4, ratio=:equal, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1))

# ╔═╡ e787150f-f7eb-4b9e-8a16-67b93d4ac446
shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1)

# ╔═╡ 61793d34-cac1-4661-9d47-459b31525eba
shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).x

# ╔═╡ 70d70ded-1514-443d-9215-7da991172c8e
shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).y

# ╔═╡ ca5e45e9-63c9-4747-bcab-f325a2e2f4a8
# shapeToPainter works with *lines* and with *shapes*. *here* with *lines*
begin
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).x, shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).y, colour=:cornflowerblue, legend=false, xlims=(0, 7), ylims=(0, 7), ratio=:equal)
#-----------------------------------------------------------------------------
plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.4, 2, :red)) # origin vector
plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.4, 1, :red)) # vect1
plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.4, 1, :red)) # vect2
end

# ╔═╡ 01377420-6d54-4856-b6b6-e919b1ce55a3
begin
# shapeToPainter works with *lines* and with *shapes*. *here* with *shape*
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(0, 7), ylims=(0, 7), ratio=:equal)
#-----------------------------------------------------------------------------
plot!([(0, 0), (2, 1)], line = (:solid, :arrow, 0.4, 2, :red)) # origin vector
plot!([(2, 1), (2+4, 1+4)], line = (:solid, :arrow, 0.4, 1, :red)) # vect1
plot!([(2, 1), (2+0, 1+2)], line = (:solid, :arrow, 0.4, 1, :red)) # vect2
end

# ╔═╡ ed6942c0-7334-4932-9eb7-72ef41d5c2ac
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).x, shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).y, colour=:cornflowerblue, legend=false, xlims=(2, 6), ylims=(2, 6), ratio=:equal)

# ╔═╡ 083e2d1c-754f-416a-84e5-d0ab6be6fb1e
begin
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).x, shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1).y, colour=:cornflowerblue, legend=false, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).mouth)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).nose)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).leftEye)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).rightEye)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
end

# ╔═╡ ac1abf65-71a3-4c61-9966-c0586209913f
# shapeToPainter works with *lines* and with *shapes*. *here* with *shape*
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)

# ╔═╡ 0c33236a-8988-4056-b591-e1df74b8a5cc
begin
# shapeToPainter works with *lines* and with *shapes*. *here* with *shape*
plot(shapeToPainter(makeWaveMan(0, 0, normalize=true).body)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).mouth)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).nose)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).leftEye)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
plot!(shapeToPainter(makeWaveMan(0, 0, normalize=true).rightEye)(frame1), colour=:cornflowerblue, legend=false, opacity=0.4, xlims=(2, 6), ylims=(2, 6), ratio=:equal)
end

# ╔═╡ 66554a9f-e380-4835-8ee4-8affc094aa6d
md"
---
#### 3.4 SICP-chapter 2.2.4 with *linear algebra* Julia functions
"

# ╔═╡ fbd4007c-d25d-4257-abee-779fa40ba3b5
md"
###### [Matrix Representation](https://mml-book.github.io/book/mml-book.pdf) of the *Higher-order* Function '*frameCoordMap*'

Function '*frameCoordMap*' expects as the *only* arguments a *frame* (= *basis*) $$\mathbf F_C$$ and an additive *origin* $$\mathbf O_C$$. The space of the *frame* is generated by the *column space* (Strang, 2019) of $$\mathbf F_C$$ and the *origin* $$\mathbf O_C$$. 

As a result '*frameCoordMap*' generates an *anonymous* function which expects as argument a *column vector* $$\mathbf g_{F_C} \in \mathbf G_{F_C}$$ representing a *graphics point* which was generated by a graphics function and which has to be mapped to a *plot point* $$\mathbf p_I$$. $$\mathbf p_I$$ is the output of the anonymous function. 

The *graphics pont* $$\mathbf g_{F_C}$$ is expected to stem from the a *unit square* graphics board: $$\mathbf g_{F_C} \in [0, 1] \times [0, 1]$$. Only then it is guaranteed that its map the *plot point* $$\mathbf p_C$$ lays within certain boundaries of the *plot area* generated by the column space of $$\mathbf P_C$$. 

The coordinates of $$\mathbf G_{F_C}$$'s column vectors are *relative* to the *frame* basis $$\mathbf F_C$$. The output of '*frameCoordMap*' is a transformed or mapped vector $$\mathbf p_C \in \mathbf P_C$$. Its coordinates are *relative* to the *cartesian* basis $$\mathbf I_C$$. The *mapped* vector $$\mathbf p_C$$ lays within the *mapped* unit square *relative* to the basis $$\mathbf I_C$$. The mapping can be denoted by a simple *matrix equation*:
"

# ╔═╡ d7254951-2d3e-4c29-a0c3-e91478bde859
md"

$$\mathbf F_C \cdot \mathbf G_{F_C} + \mathbf O_C = \mathbf I_C \cdot \mathbf G_C + \mathbf O_C = \mathbf G_C + \mathbf O_C = \mathbf P_C.$$

where:

$$\mathbf F_C \text{ = matrix with column space establishing the nonorthogonal and nonshifted ...}$$
$$\text{... basis of 'frame' with coordinates relative to the classical cartesian basis } \mathbf I_C.$$
$$\mathbf G_{F_C} \text{ = matrix with column vectors representing normalized graphics points ...}$$
$$\text{... with coordinates relative to the 'frame' basis } \mathbf F_C.$$
$$\mathbf O_C \text{ = matrix with column vectors representing the origin of the 'frame' ...}$$
$$\text{ ... with coordinates relative to the classical cartesian basis }\mathbf I_C.$$
$$\mathbf I_C \text{ = matrix with unit column vectors establishing ...}$$
$$\text{... the orthogonal nonshifted classical cartesian basis } \mathbf C.$$
$$\mathbf G_C \text{ = matrix with column vectors representing unnormalized nonshifted mapped ...}$$
$$\text{... graphic points with coordinates relative to the cartesian basis } \mathbf I_C.$$
$$\mathbf P_C \text{ = matrix with column vectors representing shifted mapped graphic points ...}$$
$$\text{... ready to be plotted with coordinates relative to the cartesian basis } \mathbf I_C.$$
"

# ╔═╡ 056e907d-47a8-4c61-8151-562d6c923802
md"
Here we present a numerical example:

$% outer vertical array of arrays
\begin{array}{ccc} % outer array
\\
% inner array of basis F_C values relative to cartesian basis I_C
\begin{array}{c|cc}
\mathbf F_C & v1 & v2 \\
\hline
x & 4 & 0 \\
y & 4 & 2 \\
\hline
\end{array}% end of F_C
&
\cdot
&
% inner array of unit square values relative to basis F_C
\begin{array}{c|cccc}
\mathbf G_{F_C} & g1_{F_C} & g2_{F_C} & g3_{F_C} & g4_{F_C} \\
\hline
v1 & 0 & 1 & 1 & 0\\
v2 & 0 & 0 & 1 & 1\\
\hline
\end{array}% end of G_{F_C}
&
+
&
% inner array of origin values relative to basis I_C
\begin{array}{c|cccc}
\mathbf O_C & g1_{F_C} & g2_{F_C} & g3_{F_C} & g4_{F_C} \\
\hline
x & 2 & 2 & 2 & 2 \\
y & 1 & 1 & 1 & 1 \\
\hline
\end{array}% end of O_C
&
=
\\
\\
% inner array of basis I_C values
\begin{array}{c|cc}
\mathbf I_C & v1 & v2 \\
\hline
x & 1 & 0 \\
y & 0 & 1 \\
\hline
\end{array}% end of I_C
&
\cdot
&
% inner array of mapped unit square values relative to basis I_C 
\begin{array}{c|cccc}
\mathbf G_C & g1_C & g2_C & g3_C & g4_C \\
\hline
v1 & 0 & 4 & 4 & 0 \\
v2 & 0 & 4 & 6 & 2 \\
\hline
\end{array}% end of G_C
&
+
&
% inner array of origin values relative to basis I_C
\begin{array}{c|cccc}
\mathbf O_C & g1_C & g2_C & g3_C & g4_C \\
\hline
x & 2 & 2 & 2 & 2 \\
y & 1 & 1 & 1 & 1 \\
\hline
\end{array}% end of O_C
&
=
\\
\\
&
&
% inner array of plot points values relative to basis I
\begin{array}{c|cccc}
\mathbf P_C & p1_C & p2_C & p3_C & p4_C \\
\hline
x & 2 & 6 & 6 & 2 \\
y & 1 & 5 & 7 & 3 \\
\hline
\end{array}% end of P_C
\\
\\
\end{array} % outer array$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

The last matrix $\mathbf P_C$ can be plotted by e.g. Julia's Plot backend. The components of all column vectors are relative to the classical cartesian basis $\mathbf C$.

$\;$
$\;$

"

# ╔═╡ 1bd58db9-bfde-4486-8525-91c6708cadea
F_C = # frame matrix (= basis)
	[edge1(frame1).x edge2(frame1).x; 
	 edge1(frame1).y edge2(frame1).y]

# ╔═╡ 84e519f4-f10c-4625-a816-72650b3f47db
G_F_C = [0 1 1 0; 0 0 1 1]

# ╔═╡ c2cb7097-c076-4749-962b-a2625704ffd1
O_C = 
	[origin(frame1).x origin(frame1).x origin(frame1).x origin(frame1).x; 
	 origin(frame1).y origin(frame1).y origin(frame1).y origin(frame1).y]

# ╔═╡ 2f2eb3e9-21ee-45cb-96ff-1530e4386ec0
G_C = F_C * G_F_C

# ╔═╡ 3204f3c0-657f-4fb0-88e3-59daf5c5a6f5
left = F_C * G_F_C + O_C

# ╔═╡ 10673915-519e-4e99-b933-5221bdcd04e3
I_C = [1 0; 0 1]

# ╔═╡ 276c7428-6920-4c55-8ca4-b0cea410e11f
P_C = I_C * G_C + O_C

# ╔═╡ e4b79b33-fbfb-4d31-b560-8cd4c71b520a
left == P_C

# ╔═╡ 06f46732-5984-40fe-8651-8139e5c97be2
md"
$\mathbf F_C \cdot \mathbf G_{F_C} + \mathbf O_C = \mathbf I_C \cdot \mathbf G_C + \mathbf O_C = \mathbf G_C + \mathbf O_C = \mathbf P_C.$

$\;$
$\;$
$\;$
$\;$

Now, we want to map *one* graphic point $\mathbf g_{F_C}=[0.5, 0.5] \mapsto \mathbf p_C=[4.0, 4.0]$

$\;$
$\;$
$\;$
$\;$

$% outer vertical array of arrays
\begin{array}{ccccccc} % outer array
&
% inner array of basis B_C values relative to cartesian Basis I_C
\begin{array}{c|cc}
\mathbf F_C & v1 & v2 \\
\hline
x & 4 & 0 \\
y & 4 & 2 \\
\hline
\end{array}% end of F_C
&
\cdot
&
% inner array of graphic point values relative to basis F_C
\begin{array}{c|c}
\mathbf g_{F_C} & g1_{F_C}\\
\hline
v1 & 0.5\\
v2 & 0.5\\
\hline
\end{array}% end of g_{F_C}
&
+
&
% inner array of origin point values relative to basis I
\begin{array}{c|c}
\mathbf o_C & g1_{F_C}\\
\hline
x & 2\\
y & 1\\
\hline
\end{array}% end of o_C
&
=
\\
\\
&
% inner array of basis I values
\begin{array}{c|cc}
\mathbf I_C & v1 & v2\\
\hline
x & 1 & 0\\
y & 0 & 1\\
\hline
\end{array}% end of I_C
&
\cdot
&
% inner array of mapped graphic point values relative to basis I 
\begin{array}{c|c}
\mathbf g_C & g1_C \\
\hline
v1 & 2.0 \\
v2 & 3.0 \\
\hline
\end{array}% end of g_C
&
+
&
% inner array of origin point values relative to basis I
\begin{array}{c|c}
\mathbf o_C & g1_C \\
\hline
x & 2\\
y & 1\\
\hline
\end{array}% end of o_C
&
=
\\
\\
&
&
&
% inner array of mapped plot point values relative to basis I 
\begin{array}{c|c}
\mathbf p_C& p1_C\\
\hline
x & 4.0 \\
y & 4.0 \\
\hline
\end{array}% end of p_C
\\
\end{array} % outer array$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

The plot point $\mathbf p1_C$ is the *red* point in the above plots.

$\;$
$\;$

"

# ╔═╡ 4508ef9d-2849-46f9-95bd-35b33f9009fb
g_F_C = [0.5; 0.5]

# ╔═╡ 9851e418-5a90-46b0-94ba-0af50f25ee44
g_C = F_C * g_F_C

# ╔═╡ 36b0caf5-6f89-4721-8df9-2cc9136088c5
o_C = [origin(frame1).x; origin(frame1).y]

# ╔═╡ 0d8a83d8-94f9-4bb6-92c3-6b8b2ee6773e
leftVect = F_C * g_F_C + o_C

# ╔═╡ 31c42c5b-f4a9-4a9e-8952-eca377b8f7c9
rightVect = I_C * g_C + o_C

# ╔═╡ 1c7e9ea4-fb38-4efb-834c-a7fded474490
F_C * g_F_C + o_C == I_C * g_C + o_C

# ╔═╡ 93f74238-dd20-416d-8c5f-b698a9c154aa
md"
The point $$\mathbf p_I = [4.0, 4.0]$$ is mapped as the *red* point in the above plots.
"

# ╔═╡ 1c341b70-17f3-437c-8199-8dc579bb415d
md"
---
##### References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; Structure and Interpretation of Computer Programs, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/09/07
- **Deisenroth, M.P.; Faisal, A.A. & Ong, Ch.S.**; Mathematics For Machine Learning; Cambridge: Cambridge University Press, [https://mml-book.github.io/book/mml-book.pdf](https://mml-book.github.io/book/mml-book.pdf); visited 2022/09/07
- **Plotly**; [https://plotly.com/julia/getting-started/](https://plotly.com/julia/getting-started/); visited 2022/09/07
- **Strang, G.**; Linear Algebra and Learning From Data; Wellesley, MA: Wellesley - Cambridge Press, 2019
- **Wikipedia**; Closure (Computer Programming); [https://en.wikipedia.org/wiki/Closure_(computer_programming)](https://en.wikipedia.org/wiki/Closure_(computer_programming)); visited 2022/09/07
- **Wikipedia**; Closure (Mathematics); [https://en.wikipedia.org/wiki/Closure_(mathematics)](https://en.wikipedia.org/wiki/Closure_(mathematics)); visited 2022/09/07
"

# ╔═╡ c7a2fad9-36b4-4b0d-950b-0c01e3fa6bbb
md"
---
##### end of ch. 2.2.4
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

===================================================================================

"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
GraphRecipes = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"

[compat]
GraphRecipes = "~0.5.13"
LaTeXStrings = "~1.4.0"
Latexify = "~0.16.7"
Plots = "~1.40.13"
Pluto = "~0.20.6"
PlutoUI = "~0.7.61"
Primes = "~0.5.6"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "6f5383fcbb24cc6e66b462f59be018a550e4d00d"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "f7817e2e585aa6d924fd714df1e2a84be7896c60"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.3.0"
weakdeps = ["SparseArrays", "StaticArrays"]

    [deps.Adapt.extensions]
    AdaptSparseArraysExt = "SparseArrays"
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "2ac646d71d0d24b44f3f8c84da8c9f4d70fb67df"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.4+0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1713c74e00545bfe14605d2a2be1712de8fbcb58"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

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
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "4358750bb58a3caefd5f37a4a0c5bfdbbf075252"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.6"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.ExpressionExplorer]]
git-tree-sha1 = "4a8c0a9eebf807ac42f0f6de758e60a20be25ffb"
uuid = "21656369-7473-754a-2065-74616d696c43"
version = "1.1.3"

[[deps.ExproniconLite]]
git-tree-sha1 = "c13f0b150373771b0fdc1713c97860f8df12e6c2"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.10.14"

[[deps.Extents]]
git-tree-sha1 = "063512a13dbe9c40d999c439268539aa552d1ae6"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.5"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "301b5d5d731a0654825f1f2e906990f7141a106b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.16.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "be713866335f48cfb1285bff2d0cbb8304c1701c"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.5.5"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "7ffa4049937aeba2e5e1242274dc052b0362157a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.14"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "98fc192b4e4b938775ecd276ce88f539bcec358e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.14+0"

[[deps.GeoFormatTypes]]
git-tree-sha1 = "8e233d5167e63d708d41f87597433f59a0f213fe"
uuid = "68eda718-8dee-11e9-39e7-89f7f65f511f"
version = "0.4.4"

[[deps.GeoInterface]]
deps = ["DataAPI", "Extents", "GeoFormatTypes"]
git-tree-sha1 = "294e99f19869d0b0cb71aef92f19d03649d028d5"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.4.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "PrecompileTools", "Random", "StaticArrays"]
git-tree-sha1 = "65e3f5c519c3ec6a4c59f4c3ba21b6ff3add95b0"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.5.7"

[[deps.GeometryTypes]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "d796f7be0383b5416cd403420ce0af083b0f9b28"
uuid = "4d00f742-c7ba-57c2-abde-4428a4b178cb"
version = "0.8.5"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.GraphRecipes]]
deps = ["AbstractTrees", "GeometryTypes", "Graphs", "InteractiveUtils", "Interpolations", "LinearAlgebra", "NaNMath", "NetworkLayout", "PlotUtils", "RecipesBase", "SparseArrays", "Statistics"]
git-tree-sha1 = "10920601dc51d2231bb3d2111122045efed8def0"
uuid = "bd48cda9-67a9-57be-86fa-5b3c104eda73"
version = "0.5.13"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "3169fd3440a02f35e549728b0890904cfd4ae58a"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.1"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LRUCache]]
git-tree-sha1 = "5519b95a490ff5fe629c4a7aa3b3dfc9160498b3"
uuid = "8ac3fa9e-de4c-5943-b1dc-09c6b5f20637"
version = "1.6.2"
weakdeps = ["Serialization"]

    [deps.LRUCache.extensions]
    SerializationExt = ["Serialization"]

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd10d2cc78d34c0e2a3a36420ab607b611debfbb"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.7"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazilyInitializedFields]]
git-tree-sha1 = "0f2da712350b020bc3957f269c9caad516383ee0"
uuid = "0e77f7df-68c5-4e49-93ce-4cd80f5598bf"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a31572773ac1b745e0343fe5e2c8ddda7a37e997"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "321ccef73a96ba828cd51f2ab5b9f917fa73945a"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

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
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Malt]]
deps = ["Distributed", "Logging", "RelocatableFolders", "Serialization", "Sockets"]
git-tree-sha1 = "02a728ada9d6caae583a0f87c1dd3844f99ec3fd"
uuid = "36869731-bdee-424d-aa32-cab38c994e3b"
version = "1.1.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "f5db02ae992c260e4826fe78c942954b48e1d9c2"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkLayout]]
deps = ["GeometryBasics", "LinearAlgebra", "Random", "Requires", "StaticArrays"]
git-tree-sha1 = "f7466c23a7c5029dc99e8358e7ce5d81a117c364"
uuid = "46757867-2c16-5918-afeb-47bfcb05e46a"
version = "0.4.10"
weakdeps = ["Graphs"]

    [deps.NetworkLayout.extensions]
    NetworkLayoutGraphsExt = "Graphs"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "117432e406b5c023f665fa73dc26e79ec3630151"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.17.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.5+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "809ba625a00c605f8d00cd2a9ae19ce34fc24d68"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.13"

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

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "Downloads", "ExpressionExplorer", "FileWatching", "FuzzyCompletions", "HTTP", "HypertextLiteral", "InteractiveUtils", "LRUCache", "Logging", "LoggingExtras", "MIMEs", "Malt", "Markdown", "MsgPack", "Pkg", "PlutoDependencyExplorer", "PrecompileSignatures", "PrecompileTools", "REPL", "RegistryInstances", "RelocatableFolders", "Scratch", "Sockets", "TOML", "Tables", "URIs", "UUIDs"]
git-tree-sha1 = "6f31e71063d158b69c1b84c7c3a1a7d4db153143"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.20.6"

[[deps.PlutoDependencyExplorer]]
deps = ["ExpressionExplorer", "InteractiveUtils", "Markdown"]
git-tree-sha1 = "9071bfe6d1c3c51f62918513e8dfa0705fbdef7e"
uuid = "72656b73-756c-7461-726b-72656b6b696b"
version = "1.2.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "7e71a55b87222942f0f9337be62e26b1f103d3e4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.61"

[[deps.PrecompileSignatures]]
git-tree-sha1 = "18ef344185f25ee9d51d80e179f8dad33dc48eb1"
uuid = "91cefc8d-f054-46dc-8f8c-26e11d7c5411"
version = "3.0.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

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

[[deps.RegistryInstances]]
deps = ["LazilyInitializedFields", "Pkg", "TOML", "Tar"]
git-tree-sha1 = "ffd19052caf598b8653b99404058fce14828be51"
uuid = "2792f1a3-b283-48e8-9a74-f99dce5104f3"
version = "0.1.0"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

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
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "9caba99d38404b285db8801d5c45ef4f4f425a6d"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.1+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a5bc75478d323358a90dc36766f3c99ba7feb024"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.6+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "aff463c82a773cb86061bce8d53a0d976854923e"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.5+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "e3150c7400c41e207012b41659591f083f3ef795"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.3+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0ba42241cb6809f1a278d0bcb976e0483c3f1f2d"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+1"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "068dfe202b0a05b8332f1e8e6b4080684b9c7700"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.47+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

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
git-tree-sha1 = "63406453ed9b33a0df95d570816d5366c92b7809"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+2"
"""

# ╔═╡ Cell order:
# ╟─0e89b190-af42-11ec-0b2f-9d505e202de3
# ╟─0e31932e-4091-4864-ae99-03b19aa2672d
# ╟─387bf705-81f7-4a88-b409-161d48d46139
# ╟─a4563990-bf5f-4903-acbf-d16d50f00de3
# ╟─af99e7d4-97bc-4d19-ad26-ef517284a750
# ╟─7c616496-8aa0-48dc-a80a-2322c63ed10b
# ╟─5997f326-5df3-40c0-b6e3-9e01ab1dbc50
# ╟─3163ae96-b718-4de7-b337-f1f7dfac3dd0
# ╟─4c2d7571-b6f2-4e1e-80da-3e10790d6e83
# ╟─5b4e53e5-4260-4f14-bdc8-d10cf4263316
# ╠═54e00170-2a57-4ba0-80a8-f35d1ab0a804
# ╠═0f1b30d5-c313-48ca-8f54-9eaee0ab8c77
# ╠═9657345f-956b-4068-a421-e24b28dde74d
# ╠═8363136c-79ac-42e7-8127-b99c745bb7f2
# ╠═fd5ec178-acc6-4380-9efc-fb71ee38963e
# ╟─b8e7d727-d814-494e-b048-aecb166259f9
# ╠═3df07686-b031-4d5f-8d19-f43e4eeb29a8
# ╟─028a5028-eb2d-4144-8858-fa07636a9cc2
# ╠═3f427b62-013f-4482-8adc-c77e9bbe3a40
# ╟─c2da7a1f-ed98-440c-b0e0-00c763e540a5
# ╟─4b322095-81e2-437c-aab7-30091a308729
# ╟─ba3519f0-e8f0-40d3-9cb9-e365310359ee
# ╠═04761c70-e9ea-4ba8-a24b-18db11578ca9
# ╠═fe4cd255-99db-43f6-8586-9bed87a55437
# ╠═fadc4de4-128f-4717-b10e-478650a89eb0
# ╟─ac03c7c1-9130-41f7-b5c0-5e10feac5171
# ╠═852d557c-bd92-4408-8b6c-2e18cec1ff3e
# ╟─bfa1b271-ae58-42c3-97f7-7fac72aae1f1
# ╠═aa5c9420-c0b2-407f-a2da-595e78503800
# ╟─86a0b38a-fe3b-4520-9800-099f714b90e9
# ╠═5a1268af-abe6-4ac2-b350-0a8253864ba8
# ╠═46027a5b-36e2-4538-8b24-f3bdafc2f625
# ╠═7ddfcf3f-ee06-40ad-b87f-b8aab427327e
# ╠═b8c56544-77ee-4a9b-9c10-e696c0440c89
# ╠═acc2e14a-67d8-45a3-a585-09085fed2e2d
# ╟─bf095bf1-bf59-4aee-86cc-15e6505377f3
# ╟─920ca7c2-c761-4bcd-ab8e-9dd9897c575b
# ╠═fc243a78-4679-4a34-a7b3-50daff85fe30
# ╠═1a4784b2-9699-4145-a990-3b6f8ee18d42
# ╟─fa6a303a-4929-4536-83ea-8d0df9a92320
# ╠═47425a32-bee9-4067-8a83-6232c9a78e19
# ╠═2afa5704-34aa-4ef7-b922-a4361526e81f
# ╠═31d6aba9-2f4f-4562-8344-15cb1f6d1176
# ╠═ede8e63c-8063-49d7-8a2d-d71cf943b7ac
# ╠═1559f2dd-90c5-49ba-b8e7-9c1f5aadb667
# ╠═41d9b94b-d3c8-42d5-ae34-de447726054a
# ╠═b9b5bc3f-a3f8-4d6f-ae1f-364cc33b9583
# ╠═f8e414a2-105c-4865-b25b-57ded04d2468
# ╠═498e7c79-dfef-4448-8cc0-e6022b145110
# ╠═d55945d3-2dc2-478a-b639-09b5fdd35d24
# ╟─bab0efeb-5bda-48b0-bc65-5db529d71753
# ╟─08b351c8-0205-4ad7-a1d9-4092f4b419e2
# ╠═58340172-ccac-4c38-bbac-3de63e2898f8
# ╠═0e88e7e2-7dda-4b0e-9496-1cf6e1511595
# ╠═8ce3b43f-1d8c-4b4b-8a50-e5c99aa27b9a
# ╠═b2f33856-939e-4830-aabe-33853036957c
# ╠═f1b6240d-8212-4e19-be8f-78148266c181
# ╠═d161baef-a8e4-4055-b80b-5d14daf040a1
# ╠═0aaf6909-38fc-4e1a-bfe4-c1739b55648d
# ╠═600f7c1d-4f43-40b7-8b55-eef40de023a2
# ╠═49192d52-b3bb-46e0-b88e-2b6047998b00
# ╠═88026c63-bc23-46eb-8b34-ed5b41a990c2
# ╠═9bbe1659-18e8-4821-a2d6-73b25ccb31e6
# ╠═008b1e20-0dd0-49e7-953c-0aba79871488
# ╠═e707b99b-2331-47ef-98f6-15d9f28c4ce7
# ╟─aaa0c0a9-0830-447a-af24-757c6e6186b1
# ╠═4669fb6f-3df2-445d-beb6-07695d2cc335
# ╠═7d81de72-094c-4c56-a7e1-80970050405b
# ╠═6ee6d67b-0d3e-4e0e-977c-0069531627ee
# ╟─6bfb76c4-5a50-4844-9cdd-f39e3c118ded
# ╠═8d0c08c9-4635-4750-9675-b84ba0727859
# ╟─96101227-2364-402d-bc15-4b74757df595
# ╠═e29fea38-4a22-4b30-ab51-9e6bac1aae8d
# ╟─8bcefd49-ab7b-4dc1-bfef-d7349a91bc46
# ╟─a70ff6fe-0b70-4661-91b0-509ebeb43756
# ╠═04e0f2fd-29b0-427c-bcb9-597c32feb44d
# ╠═e845c43d-7bc9-40f4-836e-d00f37ee1f3d
# ╠═e52e9f54-5e8c-4d58-869d-23c126e07d21
# ╠═30f40e44-0017-47cd-bc86-904207ab13c1
# ╠═4b277624-ee34-4c53-8c45-6a9d3a0520b4
# ╟─f599491e-d319-4fd4-93fc-13260ef1994b
# ╠═5c155953-505d-4aa8-b0b5-f5d6df47104d
# ╠═bba021f1-caf8-48ef-967c-1c7dde6464cf
# ╠═c789fabd-076e-4c87-9e00-061247e41e76
# ╠═79cfbc47-86b1-4250-a05c-d21d8c50532c
# ╟─db55e00e-9056-442e-876f-1e39f014b0c7
# ╠═8d94c9ef-8821-4054-9a0b-0cb72abb50e2
# ╟─0066351b-a86b-4be0-8ff9-f479a26ff699
# ╠═b7aa0a8f-2c8b-4ff2-8efe-5b88b0009700
# ╠═24a99293-215f-4b10-bdde-dd3765679704
# ╠═90aa8c1e-1eae-42d9-b71e-3c58a1c1169c
# ╟─029f90e8-cbd1-482c-b553-9f068bf13a48
# ╠═fa14cfef-1dac-4f6f-9176-a48bfd1096ee
# ╠═f02ec249-22ef-4134-bf29-e7c109e2e28b
# ╠═b07f1822-0fe9-4e93-b16f-79e42eb602b2
# ╠═a827e2b0-94dc-4474-87c6-809097827fe5
# ╠═760980ad-84e0-4b08-851a-2fa717197d1e
# ╟─5afab965-e8d4-41d1-865c-a864533ac4f6
# ╠═983cab48-d122-4b72-a187-c0226ea7171a
# ╟─3f03377b-9869-4f89-9b47-2fa011ca9133
# ╠═cd7a669c-bd12-4d91-8ea0-f52001d93b2b
# ╟─4fa6484f-c5d9-4008-abb1-e52a3d86fa7f
# ╟─8db80004-fe6a-4011-b382-cb5e5b2d6522
# ╠═a1cc0260-eb3f-4963-a39a-e9f77b5e5ffe
# ╠═bec7ad15-e052-4112-a06d-0fff4760118f
# ╟─d261a419-5d4f-4f83-9132-e13ad706ca94
# ╠═1b9183ea-f236-4a50-a35d-d47e6e7c1249
# ╟─d1e95027-c3b1-4590-be8b-a7a0f3252abb
# ╠═a0928969-8fa1-42b3-ace5-ae2a9fd9685f
# ╟─2fd64aea-95fb-431b-935e-527f5aaba8d8
# ╠═f827ca99-414c-4e94-ae3d-6fbf3de57c4b
# ╠═08fc8b77-4635-4f44-b8ae-5fc0e0171237
# ╠═341567d3-7025-4cda-8385-72dea3d292bb
# ╠═e787150f-f7eb-4b9e-8a16-67b93d4ac446
# ╠═61793d34-cac1-4661-9d47-459b31525eba
# ╠═70d70ded-1514-443d-9215-7da991172c8e
# ╠═ca5e45e9-63c9-4747-bcab-f325a2e2f4a8
# ╠═01377420-6d54-4856-b6b6-e919b1ce55a3
# ╠═ed6942c0-7334-4932-9eb7-72ef41d5c2ac
# ╠═083e2d1c-754f-416a-84e5-d0ab6be6fb1e
# ╠═ac1abf65-71a3-4c61-9966-c0586209913f
# ╠═0c33236a-8988-4056-b591-e1df74b8a5cc
# ╟─66554a9f-e380-4835-8ee4-8affc094aa6d
# ╟─fbd4007c-d25d-4257-abee-779fa40ba3b5
# ╟─d7254951-2d3e-4c29-a0c3-e91478bde859
# ╟─056e907d-47a8-4c61-8151-562d6c923802
# ╠═1bd58db9-bfde-4486-8525-91c6708cadea
# ╠═84e519f4-f10c-4625-a816-72650b3f47db
# ╠═c2cb7097-c076-4749-962b-a2625704ffd1
# ╠═2f2eb3e9-21ee-45cb-96ff-1530e4386ec0
# ╠═3204f3c0-657f-4fb0-88e3-59daf5c5a6f5
# ╠═10673915-519e-4e99-b933-5221bdcd04e3
# ╠═276c7428-6920-4c55-8ca4-b0cea410e11f
# ╠═e4b79b33-fbfb-4d31-b560-8cd4c71b520a
# ╟─06f46732-5984-40fe-8651-8139e5c97be2
# ╠═4508ef9d-2849-46f9-95bd-35b33f9009fb
# ╠═9851e418-5a90-46b0-94ba-0af50f25ee44
# ╠═36b0caf5-6f89-4721-8df9-2cc9136088c5
# ╠═0d8a83d8-94f9-4bb6-92c3-6b8b2ee6773e
# ╠═31c42c5b-f4a9-4a9e-8952-eca377b8f7c9
# ╠═1c7e9ea4-fb38-4efb-834c-a7fded474490
# ╟─93f74238-dd20-416d-8c5f-b698a9c154aa
# ╟─1c341b70-17f3-437c-8199-8dc579bb415d
# ╟─c7a2fad9-36b4-4b0d-950b-0c01e3fa6bbb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
