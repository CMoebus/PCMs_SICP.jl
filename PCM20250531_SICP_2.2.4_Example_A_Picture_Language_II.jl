### A Pluto.jl notebook ###
# v0.20.6

using Markdown
using InteractiveUtils

# ╔═╡ 7c6225d7-3fb1-4336-93c9-55078bb85575
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

# ╔═╡ ed783030-3e09-11f0-08b1-8fa252c7593d
md"
=====================================================================================
#### SICP: 2.2.4 [Example: A Picture Language II](https://sarabander.github.io/sicp/html/2_002e2.xhtml#g_t2_002e2_002e4)
###### file: PCM20250531\_SICP\_2.2.4\_Example\_A\_Picture\_Language\_II.jl
###### Julia/Pluto.jl-code (1.11.5/0.20.6) by PCM *** 2025/06/09 ***
=====================================================================================
"


# ╔═╡ 8d6bd71f-23b1-4932-b7d2-085b232fd59b
md"
---
##### 0. Introduction
The code in file *PCM20250531\_SICP\_2.2.4\_Example\_A\_Picture\_Language\_I.jl* was a first try to implement as much as possible of SICP's chapter 2.2.4. We stopped that enterprise because we realized that we could *not* succeed in SICP's goal:

*This section presents a simple language for drawing pictures that illustrates the power of data abstraction and closure, and also exploits higher-order procedures in an essential way. The language is designed to make it easy to experiment with patterns such as the ones in (SICP, 1996, p.127, Figure 2.9) which are composed of repeated elements that are shifted and scaled. In this language, the data objects being combined are represented as procedures rather than as list structure. Just as cons, which satisfies the closure property, allowed us to easily build arbitrarily complicated list structure, the operations in this language, which also satisfy the closure property, allow us to easily build arbitrarily complicated patterns.* (SICP, 1996, p.126; 2016, p.172f)

Here in *PCM20250531\_SICP\_2.2.4\_Example\_A\_Picture\_Language\_II.jl* we try a second time to be as close as possible to SICP-Scheme and succeed. 

We think that we have to follow this sequence of design steps:

- *construct* a *painter* that paints a *figure of interest (FIGOI)* in the *unit frame* by a *recursive functional* script in the *picture language* 

- embed this *(FIGOI)* in a *frame of interest (FROI)*

- plot the *FROI* with $Plot.jl$ or another *plot library*

The *last* step has to be delayed as much as possible. But beware ! There are as many '$()$' as in Scheme ! We only have to place them in slightly different places:
"

# ╔═╡ e50dfb4b-c5d4-4da9-89e7-ae80ef5fa69c
md"
---
##### 1. Topics
- the *mathematical* concept of *closure*
- the *computer-science* concept of *closure*
- function $list$
- *self*-defined types $Vect, Frame, Segment$
"

# ╔═╡ f2a66794-0b71-4ce9-8d9f-230b60a13292
md"
---
##### 2. Libraries, Types, Aliases, and Service Functions
###### 2.1 Libraries
"

# ╔═╡ 681dc23a-4032-4da7-b525-bbe51d334cd3
md"
---
###### 2.2 *Self-defined* Types
"

# ╔═╡ cc8147a3-55ae-4943-81b6-2fbea94bf23b
md"
###### *Constructor* of type $Vect$
(SICP, 1996, p.136, Exercise 2.46)
"

# ╔═╡ c6bdf830-1dce-48ab-92e9-baae5a3ea8b7
struct Vect 
	x::Real
	y::Real
end

# ╔═╡ 0c3317b9-46c2-401d-90c5-d389cd4e5a46
md"
###### *Constructor* of type $Frame$
(SICP, 1996, p.134; p.136, Exercise 2.47)
"

# ╔═╡ f2ee31b9-0814-41d0-a4c5-1a68c8f2e42c
struct Frame
	origin::Vect
	edge1::Vect
	edge2::Vect
end

# ╔═╡ 2b25dd82-6c60-4082-861d-a608de4315dc
md"
###### *Constructor* of type $Segment$
(SICP, 1996, p.137, Exercise 2.48)
"

# ╔═╡ 8072600c-8148-443f-9648-091e3a388a90
struct Segment
	originPoint::Vect
	startPoint::Vect
	endPoint::Vect
end

# ╔═╡ 1f4786b4-d11a-49fe-ab72-1d83055c0e33
md"
---
###### 2.3 *Abbreviations* (*alias* names)

The purpose of *aliases* is to bind *short* SICP-like function names to *long, informative* Julian counterparts.
"

# ╔═╡ 8e1e84aa-d1ee-49e3-83da-ad23a2cfddd4
md"
---
###### 2.4 *Service* Functions
"

# ╔═╡ 52d4a383-885f-473f-9939-52989b8b9c0d
list(xs::Any...)::Vector = 
	[xs::Any...]::Vector

# ╔═╡ 1b5e20c0-c83e-400f-9925-31054cdf7dd4
md"
---
###### 2.4.1 Constructors $makeVect, makeVects$
(SICP, 1996, p.136, Exercise 2.46)
"

# ╔═╡ 1f838420-e724-4445-8318-77d2e981d93d
makeVect(x::Real, y::Real) = Vect(x, y)::Vect

# ╔═╡ b1fb0a44-e12c-4670-b666-b8bf9f9ec4e7
function makeVect(xs::Vector, ys::Vector)::Vector
	map((x, y) -> [x, y], xs, ys)
end # function makeVect

# ╔═╡ cc1e91ae-4390-4a4f-89b5-0ddd800ef35b
md"
###### Selectors $xCorVect, yCorVect$
"

# ╔═╡ f969dbd4-dbf6-4a09-bc2b-3a2d90c9d981
xCoordVect(v::Vect)::Real = 
	v.x::Real

# ╔═╡ 5b226945-1442-4d34-8a0d-05d51e1465d8
xCoordVect(v::Vector)::Real = 
	v[1]::Real

# ╔═╡ 2f9e94d2-4c63-4cc6-b8cd-105685e74a0a
xsCoordVect(vs::Vector{Vector})::Vector = 
	map(v -> v[1], vs)

# ╔═╡ 5492a690-ce5f-43a3-9aee-5f4b92c0909d
yCoordVect(v::Vect)::Real = v.y::Real

# ╔═╡ a78c070d-7745-4488-895a-dbc70aa3c9c9
yCoordVect(v::Vector)::Real = 
	v[2]::Real

# ╔═╡ f26ccbfb-c657-400c-9426-d7f3b1f7448f
ysCoordVect(vs::Vector{Vector})::Vector = 
	map(v -> v[2], vs)

# ╔═╡ 4d6ce9f8-c266-4b06-9637-54dc8f2b985b
md"
---
###### Vector Operations $addVect, subVect, scaleVect$
"

# ╔═╡ 2c73a3ae-98c0-4759-b1ce-98c8da98d7c7
addVect(v1::Vect, v2::Vect)::Vect = 
	makeVect(v1.x + v2.x, v1.y + v2.y)::Vect

# ╔═╡ a43a659f-2338-4a6a-a055-988a4a22cbac
addVect(v1s::Vector, v2s::Vector)::Vector = 
	v1s + v2s

# ╔═╡ 259e8a18-5c1f-4dbd-be01-a10194bf18c1
subVect(v1::Vect, v2::Vect)::Vect = 
	makeVect(v1.x - v2.x, v1.y - v2.y)::Vect

# ╔═╡ 1f9ba27e-0ced-4f71-8f35-c3c2aa4b5aaf
subVect(v1s::Vector, v2s::Vector)::Vector = 
	v1s - v2s

# ╔═╡ 1d427fe1-21a3-4151-be29-54ef7d531c1e
scaleVect(s::Real, v::Vect)::Vect = 
	makeVect(s * v.x, s * v.y)::Vect

# ╔═╡ 582a778b-47f4-4963-9125-3e9dd419312a
scaleVect(s::Real, v::Vector)::Vector = 
	s .* v

# ╔═╡ 1f117119-228b-43de-a743-4818add6cd3f


# ╔═╡ 3b4a452e-4896-4a2f-9d94-1d12dea0e8d4
md"
---
###### *Test* Applications
"

# ╔═╡ c3686863-a0ea-4c0f-868b-a3d913258039
z = makeVect(1, 2)

# ╔═╡ 529727b7-e6ea-4d8f-82be-a995bed3a72f
xCoordVect(z)

# ╔═╡ ca86f7c6-dbd4-4d20-8543-062fa07b6b63
yCoordVect(z)

# ╔═╡ aa59c336-00fe-4d42-a851-2131d5fe9e94
xs = [1, 2, 3]

# ╔═╡ 34db0743-60b0-4aa5-ae96-c19e557513a1
ys = [4, 5, 6]

# ╔═╡ f881e434-0961-484d-a90e-cc10c4b3c710
zs = makeVect(xs, ys)

# ╔═╡ 5acd24ae-ded2-421f-b7b3-bfcdafca42fa
addVect(xs, ys)

# ╔═╡ 351d3ef3-82ff-4aba-9fc2-9917c2b6572a
scaleVect(2.5, xs)

# ╔═╡ 390ba005-e578-436c-8675-493953883368
md"
---
###### 2.4.2 Plot $plotFrame$
"

# ╔═╡ 9d18dc06-47cc-49bd-a0d4-3be1a2f729c3
md"
---
##### 3. *SICP-Scheme-like* Functional Julia
---
##### 3.1 The Picture Language

"

# ╔═╡ ed5149ef-0166-40d7-9696-43e9d2695425
md"
---
##### 3.2 Higher-order Operations
"

# ╔═╡ 9b6a2129-947d-4c3a-9b18-365df5d8e0f8
md"
---
##### 3.3 Frames
---
###### 3.3.1 Constructor $makeFrame$
(SICP, 1996, p.136, Exercise 2.47)

"

# ╔═╡ 6f8cf580-e928-488a-ac34-0a8136cb624a
function makeFrame(;origin::Vect, edge1::Vect, edge2::Vect)::Frame
	Frame(origin, edge1, edge2)
end # function makeFrame

# ╔═╡ 61225dbf-1cd9-4287-bd80-d04bc100e2d2
md"
---
###### Selectors $originFrame, edge1Frame, edge2Frame$
(SICP, 1996, p.134; p.136, Exercise 2.47)
"

# ╔═╡ 66ec9e8c-6596-47f0-845d-e27c576d3c68
originFrame(frame::Frame)::Vect = 
	frame.origin

# ╔═╡ 9468816b-5cac-468b-b1db-c73cd995cf80
edge1Frame(frame::Frame)::Vect = 
	frame.edge1

# ╔═╡ 71372e78-5364-4cd5-ac13-ba9f50fdf482
edge2Frame(frame::Frame)::Vect = 
	frame.edge2

# ╔═╡ 593200c8-8a4a-4e66-a4aa-6e54df2b0eb1
function plotFrame(frame::Frame; title="", lw=1.5, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), size=(900, 600), annotations=:false)
	plot(size=size, xlims=xlims, ylims=ylims, aspect_ratio=1, title=title)
	#--------------------------------------------------------------------------------
	# vector from (0, 0) to origin of frame
	plot!([(0,0), (originFrame(frame).x, originFrame(frame).y)], ls=:dash, lw=0.5*lw, color=:green, arrow=true, label=L"(0,0)\rightarrow origin")
	#
	scatter!((originFrame(frame).x, originFrame(frame).y), label=L"origin\ of\ frame")
	if annotations == :true
		annotate!(1.4, 1.0, "origin", 8)
	end # if
	#---------------------------------------------------------------------------
	# edge1
	edge1EndPoint = addVect(originFrame(frame), edge1Frame(frame))
	#
	plot!([(originFrame(frame).x, originFrame(frame).y), (edge1EndPoint.x, edge1EndPoint.y)], lw=lw, color=:red, arrow=true, label=L"edge\ 1")
	if annotations == :true
		annotate!(4.0, 2.3, "edge1", 8)
	end # if
	#---------------------------------------------------------------------------
	# edge2
	edge2EndPoint = addVect(originFrame(frame), edge2Frame(frame))
	#
	plot!([(originFrame(frame).x, originFrame(frame).y), (edge2EndPoint.x, edge2EndPoint.y)], lw=lw, color=:red, arrow=true, label=L"edge\ 2")
	if annotations == :true
		annotate!(1.4, 2.0, "edge2", 8)
	end # if
	#---------------------------------------------------------------------------
	# edge1Shifted      
	edge1ShiftedEndPoint = addVect(edge2EndPoint, edge1Frame(frame))
	#
	plot!([(edge2EndPoint.x, edge2EndPoint.y), (edge1ShiftedEndPoint.x, edge1ShiftedEndPoint.y)], lw=0.5*lw, color=:cornflowerblue, arrow=true, label=L"edge1Shifted")
	#---------------------------------------------------------------------------
	# edge2Shifted
	edge2ShiftedEndPoint = addVect(edge1EndPoint, edge2Frame(frame))
	#
	plot!([(edge1EndPoint.x, edge1EndPoint.y), (edge2ShiftedEndPoint.x, edge2ShiftedEndPoint.y)], lw=0.5*lw, color=:cornflowerblue, arrow=true, label=L"edge2Shifted")
	#---------------------------------------------------------------------------
end # function plotFrame

# ╔═╡ bed5357a-f5b8-4b07-a089-ee9f92774b6b
md"
---
###### 3.3.2 Example: Construction and Plot of $frame1, frame2$
"

# ╔═╡ 8ae3267a-ea9d-4ea6-a8f6-bbaeba7bc2ed
md"
---
###### 3.3.2.1 *Unit* Frame $frame1$
"

# ╔═╡ ef12e6f3-1b68-4ae2-aba8-224bbfa8a9bf
frame1 = 
	makeFrame(origin=Vect(0, 0),  edge1=Vect(1, 0), edge2=Vect(0, 1))

# ╔═╡ 48a3a3f6-39d9-4c04-9515-96146e718595
plotFrame(frame1, title=L"Frame1", xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), annotations=:false, lw=2, size=(600, 400))

# ╔═╡ 12c50526-d453-4f92-91cb-837725c9c20f
md"
---
###### 3.3.2.2 *Oblique, Scaled* Frame $frame2$
"

# ╔═╡ d2774d4f-20cf-4154-9646-28ed5cdeef67
frame2 = 
	makeFrame(origin=Vect(2, 1), edge1=Vect(4, 4), edge2=Vect(0, 2))

# ╔═╡ dccd7558-4fcd-453d-84ed-7f3f3c79f44d
plotFrame(frame2, title=L"Frame2 (cf. SICP, Fig. 2.15)", xlims=(0, 8), ylims=(0, 8), lw=2, annotations=:true, size=(600, 400))

# ╔═╡ 8ba1bbf4-2764-4b95-a284-7caa9339766b
md"
---
###### 3.3.3 Function $frameCoordMap$
(SICP, 1996, p.135)
"

# ╔═╡ ce242cf2-9aaa-4afd-b22e-55c925409e9f
function frameCoordMap(frame)::Function
	function (vect::Vect) # vect is vector to be mapped into the frame basis
		addVect(
			originFrame(frame),
			addVect(scaleVect(xCoordVect(vect), edge1Frame(frame)),
					scaleVect(yCoordVect(vect), edge2Frame(frame))))
	end # function (vect)
end # function frameCoordMap

# ╔═╡ d4fd558a-fa53-4a6b-b916-15d80872c397
frameCoordMap(frame1)(makeVect(0, 0))     # map (0, 0) into frame1's origin (2, 1)

# ╔═╡ 6e2dc313-2d15-4ab3-8ca2-906e2d548dca
frameCoordMap(frame1)(makeVect(1, 1))     # map (1, 1) into frame1's top-left (6, 7)

# ╔═╡ 696cda7c-6aca-4c90-9b3a-da0717ab1b8c
# map (1/2, 1/2) into frame1's center (4, 4)
frameCoordMap(frame1)(makeVect(1/2, 1/2)) 

# ╔═╡ 9e337b84-7e62-40c4-ac8d-40013a599cf2
frameCoordMap(frame1)(makeVect(0, 0)) == originFrame(frame1)    # SICP, 1996, p.136

# ╔═╡ 5a8b5990-a82c-4637-8d1c-530f89d39464
md"
---
##### 3.4 Painters
*A painter is represented as a procedure that, given a frame as argument, draws a particular image shifted and scaled to fit the frame. That is to say, if p is a painter and f is a frame, then we produce p's image in f by calling p with f as argument.*

*The details of how primitive painters are implemented depend on the particular characteristics of the graphics system and the type of image to be drawn. For instance, suppose we have a procedure draw-line that draws a line on the screen between two specified points.* (SICP, 1996, p.136)
"

# ╔═╡ f92996ce-ee7c-417f-aa3e-8befedb56ed6
md"
---
###### 3.4.1 Constructors $makeSegment, makeSegments$
(SICP, 1996, p.137, Exercise 2.48)
"

# ╔═╡ 4bc78c6d-2e39-41c9-af6e-4c9f238eea6e
function makeSegment(
			startPoint::Vect, endPoint::Vect; 
			originPoint::Vect = makeVect(0, 0))
	Segment(originPoint, startPoint, endPoint)
end # function makeSegment

# ╔═╡ d3880771-94b9-43b8-b55e-e7e8f98937bc
function makeSegments(xs::Vector, ys::Vector)
	[makeSegment(
		makeVect(xs[i], ys[i]), 
		makeVect(xs[i+1], ys[i+1])) 
	 for i in 1:length(xs)-1]
end # function makeSegments

# ╔═╡ b6a7ff2f-2de8-4e30-96b0-b93cdaad64c1
md"
---
###### Selectors $originPoint, startPoint, endPoint$
"

# ╔═╡ 2c815fb3-c0c1-42df-a4a8-e58e19936890
function getOriginPoint(segment::Segment)::Vect
	segment.originPoint
end # function originPoint

# ╔═╡ 2e8a64e8-fa45-4902-be7f-6a6a8b719290
function getStartPoint(segment::Segment)::Vect
	segment.startPoint
end # function startPoint

# ╔═╡ 90392b88-5834-4807-b1c3-7b0ec10c46a0
function getEndPoint(segment::Segment)::Vect
	segment.endPoint
end # function endPoint

# ╔═╡ d3e11e59-936c-420c-8bc6-57f47d89298a
md"
---
###### 3.4.2 Constructor $makeSegmentList$
"

# ╔═╡ 67d40de1-5c23-4759-abe2-6a5a991c06d5
makeSegmentList(segments...) =
	list(segments...)

# ╔═╡ 0c6b418d-b888-4b40-925f-00829e0fed72
md"
---
###### 3.4.3 Methods of Function $shapeSegment (= drawLine)$
(SICP, 1996, p.136)
"

# ╔═╡ aa2abc32-91ea-46d1-b75d-46fccd52444b
function shapeSegment(segment::Segment)::Shape
	let startP = getStartPoint(segment)
		endP   = getEndPoint(segment)
		#----------------------------------
		xs = [startP.x, endP.x]
	    ys = [startP.y, endP.y]
		#----------------------------------
		Shape(xs, ys)
	end # let
end # function shapeSegment

# ╔═╡ e6730566-d799-4e6c-ab0d-4d9a91a960f7
drawLine(segment::Segment)::Shape = 
	shapeSegment(segment::Segment)::Shape

# ╔═╡ 5f2fa967-3798-4afd-8c4a-f96919c3b4d8
function shapeSegments(segmentList::Vector)::Vector{Shape}
	map(segment -> shapeSegment(segment), segmentList)
end # function shapeSegments

# ╔═╡ 655a5024-53f8-4b89-a2cb-4b2321931243
drawLine(segmentList::Vector)::Vector{Shape} =
	shapeSegments(segmentList::Vector)::Vector{Shape}

# ╔═╡ 39fca6a6-4081-427d-9ae5-4f9084c3fd73
md"
---
###### 3.4.4 Function $fromSegmentsToPainter$

*For instance, suppose we have a procedure draw-line that draws a line on the screen between two specified points. Then we can create painters for line drawings, such as the wave painter in figure 2.10 (SICP, 1996, p.129), from lists of line segments as follows* (SICP, 1996, p.136f):
"

# ╔═╡ cf8835df-8f66-401f-97f8-d519a3112693
function fromSegmentsToPainter(segmentList::Vector)::Function
	frame -> 
		map(segment -> 
			shapeSegment(
				makeSegment(
					frameCoordMap(frame)(getStartPoint(segment)), 
					frameCoordMap(frame)(getEndPoint(segment)))),
			segmentList)
end # function fromSegmentsToPainter

# ╔═╡ 17ae3fd2-a96b-43d5-970e-8cddfd9c90e5
function fromCoordinatesToPainter(segmentList::Vector)::Function
	frame -> 
		map(segment -> 
			shapeSegment(
					frameCoordMap(frame)(getStartPoint(segment)), 
					frameCoordMap(frame)(getEndPoint(segment))),
			segmentList)
end # function fromCoordinatesToPainter

# ╔═╡ 50351a14-de0b-4be7-97ee-736ddb401d45
md"
*The segments are given using coordinates with respect to the unit square. For each segment in the list, the painter transforms the segment endpoints with the frame coordinate map and draws a line between the transformed points.* (SICP, 1996, p.137)
"

# ╔═╡ 85cb061e-4074-4ec4-bc81-6f8ceffe6c6f
md"
---
###### 3.4.5 Test Applications
"

# ╔═╡ e3af35a2-0d4e-441e-9d28-9609b8537485
md" 
---
###### 3.4.5.1 Draw $shapeSegment(segment1)(=drawLine(segment1))$
"

# ╔═╡ 49dd66f1-d30c-4946-85f6-4986231841a6
segment1 = makeSegment(makeVect(2, 1), makeVect(5, 3))

# ╔═╡ 906b2fd4-0eca-4b24-9212-6f30e4a19e85
drawLine(segment1), shapeSegment(segment1)

# ╔═╡ 91127892-395f-4f66-ad94-99ad6a89a997
getStartPoint(segment1), getEndPoint(segment1)

# ╔═╡ 19fdaecd-8614-4761-bbd7-164b808d3fdb
plot(drawLine(segment1); xlims=(0.0, 7.0), ylims=(0.0, 7.0), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(600, 300), linecolour=:cornflowerblue, lw=4, opacity=0.5, title=L"segment1")

# ╔═╡ 11f4b71f-716d-41b4-b384-81cd206b170b
md" 
---
###### 3.4.5.2 Draw $fromSegmentsToPainter(makeSegmentList(segment1))(frame1)$
"

# ╔═╡ 8c42f876-9623-4974-9fec-8ae728bc5f78
makeSegmentList(segment1)

# ╔═╡ d327d008-cf25-456a-9893-eea733bc83c0
plot(fromSegmentsToPainter(makeSegmentList(segment1))(frame1); 
	xlims=(0.0, 7.0), ylims=(0.0, 7.0), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(600, 300), linecolour=:cornflowerblue, lw=4, opacity=0.5, title=L"fromSegmentsToPainter(makeSegmentList(segment1))(frame1)", titlefontsize=10)

# ╔═╡ d62d8161-de05-42cd-ab5f-ef03842166cd
segmentList1 =
	let
		segment1    = makeSegment(makeVect(2, 1), makeVect(5, 3))
		segment2    = makeSegment(makeVect(5, 3), makeVect(5, 6))
		segment3    = makeSegment(makeVect(5, 6), makeVect(2, 4))
		segment4    = makeSegment(makeVect(2, 4), makeVect(2, 1))
		segmentList = makeSegmentList(segment1, segment2, segment3, segment4)
	end # let

# ╔═╡ c404616e-aa80-4a1c-8426-4d1e7917749c
segmentList1

# ╔═╡ 5d0071d4-7d45-41a3-85b1-4db95ccf6336
plot(drawLine(segmentList1::Vector); xlims=(0.0, 7.0), ylims=(0.0, 7.0), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(500, 300), linecolour=:cornflowerblue, lw=4, opacity=0.5, title=L"segmentList")

# ╔═╡ 01995ab8-1eba-40c4-97b7-c6a4b5bbf447
typeof(drawLine(segmentList1))

# ╔═╡ 8badc4d8-20ac-404a-8baf-ef683ec664b6
md" 
---
###### 3.4.5.3 Draw $segmentList2$
"

# ╔═╡ 77f3cb62-35fa-4fd3-aabb-7b0cb2f218a5
segmentList2 =
	let
		segment1 = makeSegment(makeVect(.2, .1), makeVect(.5, .3))
		segment2 = makeSegment(makeVect(.5, .3), makeVect(.5, .6))
		segment3 = makeSegment(makeVect(.5, .6), makeVect(.2, .4))
		segment4 = makeSegment(makeVect(.2, .4), makeVect(.2, .1))
		segmentList = makeSegmentList(segment1, segment2, segment3, segment4)
	end # let

# ╔═╡ af3d1b82-9e58-4f79-a257-1c033d10ed54
segmentList2

# ╔═╡ 962a9be5-3ef6-46b2-b65e-f79779d97d3b
fromSegmentsToPainter(segmentList2)(frame1)

# ╔═╡ e75e526a-69d3-4420-a763-6c43597fe2df
plot(fromSegmentsToPainter(segmentList2)(frame1); xlims=(0.0, 1.0), ylims=(0.0, 1.0), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(500, 300), linecolour=:cornflowerblue, lw=4, opacity=0.5, title=L"segmentList2\ in\ frame1")

# ╔═╡ 1134f274-92d4-4dd4-9740-a22c88b75752
plot(fromSegmentsToPainter(segmentList2)(frame2);
	 xlims=(0.0, 6.0), ylims=(0.0, 6.0), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(500, 300), linecolour=:cornflowerblue, lw=4, opacity=0.5, title=L"segmentList2\ in\ frame2")

# ╔═╡ 248cf3e6-9b96-4c0a-9fd4-b5985044c329
md"
---
###### 3.4.5.3 Draw Contour of $waveMan$

"

# ╔═╡ 6b1fc47b-2206-4a3d-98fd-964808630d18
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
	xsBody = x0 .+ [4, 7, 8.5, 10.5, 13.5, 10.5, 18, 18, 13.5, 10.5, 11.5, 10.5, 7, 5.5, 6.5, 4.5, 2, -1, -1, 2, 4.5, 5.5, 4]          # x-coordinates of body
	ysBody = y0 .+ [.5, .5, 6, .5, .5, 9, 3.5, 7.5, 13, 13, 17, 20, 20, 17, 13, 13, 12, 17, 13, 8, 12, 10, .5]                         # y-coordinates of body
	xsMouth    = x0 .+ [ 7.5,  8.0,  9.0,  9.5,  7.5]  # x-coordinates of mouth
	ysMouth    = (y0 - 0.5) .+ [16.0, 15.5, 15.5, 16.0, 16.0] # y-coordinates of mouth
	xsNose     = x0 .+ [ 8.0,  9.0,  8.5, 8.0]         # x-coordinates of nose
	ysNose     = (y0 -  0.8) .+ [17., 17., 18., 17.]   # y-coordinates of nose
	xsLeftEye  = (x0 +  7.0) .+ shapeOfEye()[1]        # x-coordinates of left eye
	ysLeftEye  = (y0 + 17.2) .+ shapeOfEye()[2]        # y-coordinates of left eye
	xsRightEye = (x0 + 10.0) .+ shapeOfEye()[1]        # x-coordinates of right eye
	ysRightEye = (y0 + 17.2) .+ shapeOfEye()[2]        # y-coordinates of right eye
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

# ╔═╡ 6d7788cf-c3e4-4832-8e22-a52ccbb010ba
function waveManCoords(waveMan)
	waveManBodyXs     = waveMan.body.x      # xs = vector of x-coordinates of body
	waveManBodyYs     = waveMan.body.y      # ys = vector of y-coordinates of body 
	waveManMouthXs    = waveMan.mouth.x
	waveManMouthYs    = waveMan.mouth.y
	waveManNoseXs     = waveMan.nose.x
	waveManNoseYs     = waveMan.nose.y
	waveManLeftEyeXs  = waveMan.leftEye.x
	waveManLeftEyeYs  = waveMan.leftEye.y
	waveManRightEyeXs = waveMan.rightEye.x
	waveManRightEyeYs = waveMan.rightEye.y
	(waveManBodyXs=waveManBodyXs, waveManBodyYs=waveManBodyYs, waveManMouthXs=waveManMouthXs, waveManMouthYs=waveManMouthYs, waveManNoseXs=waveManNoseXs, waveManNoseYs=waveManNoseYs, waveManLeftEyeXs=waveManLeftEyeXs, waveManLeftEyeYs=waveManLeftEyeYs, waveManRightEyeXs=waveManRightEyeXs, waveManRightEyeYs=waveManRightEyeYs)
end # function waveManCoords

# ╔═╡ 3b40e793-93d1-4ca8-ab78-788449f613e2
waveManCoordinates = 
	waveManCoords(makeWaveMan(0, 0, normalize=true))

# ╔═╡ d3c8cc22-f34f-46af-8d4f-10a07b9f499c
waveManCoordinates.waveManBodyXs

# ╔═╡ 774e52f3-fc50-4350-8b75-8f92ae3f2dd0
waveManCoordinates.waveManBodyYs

# ╔═╡ 4c6f262f-909e-48a1-a566-4319c240d492
waveManVects = 
	makeVect(waveManCoordinates.waveManBodyXs, waveManCoordinates.waveManBodyYs)

# ╔═╡ 20a7d01b-afaf-4500-966e-446819d5b6f1
typeof(waveManVects)

# ╔═╡ 53184b92-eefd-4c14-8b59-671f7fee0074
waveManVects[2]

# ╔═╡ 374eaa45-1e6b-4d19-9ce9-3b3e4510c56c
xCoordVect(waveManVects[2]), yCoordVect(waveManVects[2])

# ╔═╡ 77e84104-debb-435e-9184-7b79e6f730f4
function makeWaveManSegments(waveManCoordinates)
	waveManBodySegments = 
		makeSegments(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)
	waveManMouthSegments = 
		makeSegments(
			waveManCoordinates.waveManMouthXs, 
			waveManCoordinates.waveManMouthYs)
	waveManNoseSegments = 
		makeSegments(
			waveManCoordinates.waveManNoseXs, 
			waveManCoordinates.waveManNoseYs)
	waveManLeftEyeSegments = 
		makeSegments(
			waveManCoordinates.waveManLeftEyeXs, 
			waveManCoordinates.waveManLeftEyeYs)
	waveManRightEyeSegments = 
		makeSegments(
			waveManCoordinates.waveManRightEyeXs, waveManCoordinates.waveManRightEyeYs)
	waveManSegments = 
		makeSegmentList(
			waveManBodySegments..., waveManMouthSegments..., waveManNoseSegments..., waveManLeftEyeSegments..., waveManRightEyeSegments...)
	(waveManBodySegments=waveManBodySegments, waveManMouthSegments=waveManMouthSegments, waveManNoseSegments=waveManNoseSegments, waveManLeftEyeSegments=waveManLeftEyeSegments, waveManRightEyeSegments=waveManRightEyeSegments,
	waveManSegments=waveManSegments)
end # function makeWaveManSegments

# ╔═╡ 1c50caf6-14b2-49e1-8eca-79986462092e
makeWaveManSegments(waveManCoordinates).waveManSegments

# ╔═╡ fa48c228-10ce-4681-927d-2a4cb3af199b
function plotWaveManSilhouette(segmentList::Vector)
	plot(shapeSegments(segmentList::Vector), label=false)
end # function plotWaveManSilhouette

# ╔═╡ 4b1c5204-cf96-44fe-8d01-0559de944028
typeof(makeWaveManSegments(waveManCoordinates).waveManSegments) <: Vector

# ╔═╡ 416144cd-1d87-452e-aa38-3d64516b80bf
plotWaveManSilhouette(makeWaveManSegments(waveManCoordinates).waveManSegments)

# ╔═╡ bc903351-bc95-41e3-8763-965d62cfd6b4
# ╠═╡ skip_as_script = true
#=╠═╡
function waveManShape() 
	vcat(
		Shape(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs),
		Shape(
			waveManCoordinates.waveManMouthXs, 
			waveManCoordinates.waveManMouthYs),
		Shape(
			waveManCoordinates.waveManNoseXs, 
			waveManCoordinates.waveManNoseYs),
		Shape(
			waveManCoordinates.waveManLeftEyeXs, waveManCoordinates.waveManLeftEyeYs),
		Shape(
			waveManCoordinates.waveManRightEyeXs, 			waveManCoordinates.waveManRightEyeYs))
end # function plotWaveManShape
  ╠═╡ =#

# ╔═╡ 25136ed2-540b-43d5-9087-adfb10bd5401
#=╠═╡
plot(waveManShape(), label=false)
  ╠═╡ =#

# ╔═╡ 19af462d-9c54-4ed1-b999-3eebc6e8e3e3
#=╠═╡
function plot4WaveMans(;title=L"Unit\ WaveMan")
	plot1 = scatter(
		drawLine(makeWaveManSegments(waveManCoordinates).waveManBodySegments), label=false, colour=:cornflowerblue, title=title)
	plot2 = plot(
		drawLine(makeWaveManSegments(waveManCoordinates).waveManBodySegments), label=false, axis=false, lw=2, linecolour=:cornflowerblue, title=title)
    plot3 = plot(
		drawLine(makeWaveManSegments(waveManCoordinates).waveManSegments), label=false, axis=false, )
	plot4 = plot(waveManShape(), label=false, axis=false) 
    plot(plot1, plot2, plot3, plot4)
end # function plot4WaveMans
  ╠═╡ =#

# ╔═╡ da30b5f0-6144-4503-866c-b42ed704b249
#=╠═╡
plot4WaveMans()
  ╠═╡ =#

# ╔═╡ 0458f5e5-0e00-4f17-8aac-fa7de3b7b958
segmentList3 =
	let
		segment1 = makeSegment(makeVect(0, 0), makeVect(1, 0))
		segment2 = makeSegment(makeVect(1, 0), makeVect(1, 1))
		segment3 = makeSegment(makeVect(1, 1), makeVect(0, 1))
		segment4 = makeSegment(makeVect(0, 1), makeVect(0, 0))
		segmentList = makeSegmentList(segment1, segment2, segment3, segment4)
	end # let

# ╔═╡ 4b382506-cc1e-4895-ac0a-9c82fd8df848
plot(fromSegmentsToPainter(segmentList3)(frame1); xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(600, 500), linecolour=:cornflowerblue, lw=1, opacity=0.5, title=L"segmentList3\ in\ frame1")

# ╔═╡ e12b2116-d310-4475-8898-cf8eadbb7b62
plot(
	fromSegmentsToPainter(
		makeWaveManSegments(waveManCoordinates).waveManSegments)(frame1), 
	size=(600, 500), label=false, xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), linecolour=:cornflowerblue, lw=2, title=L"Body\ of\ WaveMan\ in\ Unit\ Frame1", titlefontsize=10)

# ╔═╡ b083310b-4de3-4b3d-967c-0af4ea0b06d5
plot(
	vcat(
		fromSegmentsToPainter(
			segmentList3)(frame1),
		fromSegmentsToPainter(
			makeWaveManSegments(
				waveManCoordinates).waveManSegments)(frame1)), 
			size=(600, 500), label=false, ratio=:equal, aspect_ratio=1, 
			xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), linecolour=:cornflowerblue, lw=1.5, title=L"Body\ of\ WaveMan\ in\ Unit\ Frame1", titlefontsize=10)

# ╔═╡ 7d54ba1f-e86f-4cb8-b415-36bbc674fdbb
plot(
	fromSegmentsToPainter(
			makeWaveManSegments(
				waveManCoordinates).waveManSegments)(frame2), 
			size=(600, 500), label=false, ratio=:equal, aspect_ratio=1, 
			xlims=(1.0, 7.1), ylims=(0.0, 8.1), linecolour=:cornflowerblue, lw=1.5, title=L"Body\ of\ WaveMan\ in\ Unit\ Frame1", titlefontsize=10)

# ╔═╡ 921c1f16-a5e7-459c-aa85-1af2c7447f31
plot(
	vcat(
		fromSegmentsToPainter(
			segmentList3)(frame2),
		fromSegmentsToPainter(
			makeWaveManSegments(
				waveManCoordinates).waveManSegments)(frame2)), 
			size=(600, 500), label=false, ratio=:equal, aspect_ratio=1, 
			xlims=(1.0, 7.1), ylims=(0.0, 8.1), linecolour=:cornflowerblue, lw=1.5, title=L"Body\ of\ WaveMan\ in\ Unit\ Frame1", titlefontsize=10)

# ╔═╡ 985b867e-ea4f-4212-99c3-fb59293bc330
md"
---
##### 3.4.5.4 Definition of *Painters*
(SICP, 1996, p.137, Exercise 2.49)

*Use segmentsPainter to define the following primitive painters* (SICP, 1996, p.137):

"


# ╔═╡ be85f063-52d1-4a90-9fea-c7ea533579db
md"
---
###### The *Frame* Painter
(SICP, 1996, p.137, Exercise 2.49)
"

# ╔═╡ 93d9b8a7-49c3-4063-9398-db6ec0bb86cc
function framePainter(frame)
	fromSegmentsToPainter(segmentList3)(frame)
end # function framePainter

# ╔═╡ 40bb49a1-91f6-4408-af1e-b247267d2fd4
framePainter(frame1)

# ╔═╡ c0d6d720-04eb-4776-9fd3-046baa729c9e
typeof(framePainter(frame1))

# ╔═╡ 18f2a8b4-209c-4de4-b681-71482e7c4eff
	plot(
		framePainter(frame1); 
		xlims=(-0.1, 1.1), ylims=(-0.1, 1.1), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(600, 500), linecolour=:cornflowerblue, lw=1.5, opacity=0.5, title=L"frame1", titlefontsize=12)

# ╔═╡ ef7db86c-49e0-4acc-87e1-6e49f4b80663
framePainter(frame2)

# ╔═╡ f2158a99-7b82-4023-879b-a829d03cbd4a
	plot(
		framePainter(frame2); 
		xlims=(-0.1, 7.1), ylims=(-0.1, 7.1), legend=false, ratio=:equal, aspect_ratio=1, showaxis=true, size=(600, 500), linecolour=:cornflowerblue, lw=1.5, opacity=0.5, title=L"frame2", titlefontsize=12)

# ╔═╡ 3bea9896-fbf9-4933-abb4-babdf8988b01
md"
---
###### Painter $waveManSilhouettePainter$ 
(SICP, 1996, p.137, Exercise 2.49)

This is the SICP painter $wave$ mentioned in (SICP, 1996, p.137, Exercise 2.49).
We *add* a second painter $waveManShapePainter$ *not* mentioned in SICP.
"

# ╔═╡ 9de2a15b-81f4-4211-95bf-884b0612f8a6
function waveManSilhouettePainter()
	#--------------------------------------------------------------------
	function (frame)
		let
			waveManBody     =
				fromSegmentsToPainter(
					makeWaveManSegments(
						waveManCoordinates).waveManBodySegments)(frame)
			waveManMouth    =
				fromSegmentsToPainter(
					makeWaveManSegments(
						waveManCoordinates).waveManMouthSegments)(frame)
			waveManNose     =
				fromSegmentsToPainter(
					makeWaveManSegments(
						waveManCoordinates).waveManNoseSegments)(frame)
			waveManLeftEye  =
				fromSegmentsToPainter(
					makeWaveManSegments(
						waveManCoordinates).waveManLeftEyeSegments)(frame)
			waveManRightEye =
				fromSegmentsToPainter(
					makeWaveManSegments(
						waveManCoordinates).waveManRightEyeSegments)(frame)
			waveMan = 
				vcat(waveManBody, waveManMouth, waveManNose, waveManLeftEye, waveManRightEye)
			#----------------------------------------------------------------
			(waveManBody=waveManBody, waveManMouth=waveManMouth, waveManNose=waveManNose, waveManLeftEye=waveManLeftEye, waveManRightEye=waveManRightEye, waveMan=waveMan)
		end # let
	end # function
	#--------------------------------------------------------------------------------
end # function waveManSilhouettePainter

# ╔═╡ a93f41a9-2589-48c0-91ef-4a42109f20c2
waveManSilhouettePainter()(frame1)

# ╔═╡ 9149333b-3f51-4ab1-9a21-fa784048c4c4
waveManSilhouettePainter()(frame1).waveMan

# ╔═╡ 9709f125-11cd-40ea-87e3-f35ed6f7ef59
plot(waveManSilhouettePainter()(frame1).waveMan, label=false, linecolor=:cornflowerblue, lw=2, showaxis=false)

# ╔═╡ eadd41b4-e398-453b-bdc2-f75b02ff625f
plot(waveManSilhouettePainter()(frame2).waveMan, label=false, linecolor=:cornflowerblue, lw=2, showaxis=false)

# ╔═╡ b771d539-95bb-4fe7-b69f-a88837237580
waveManBody =
		fromSegmentsToPainter(
			makeWaveManSegments(
				waveManCoordinates).waveManBodySegments)(frame1)

# ╔═╡ a8a2ba5f-cc83-46aa-a2bb-bcda2d69c37d
Shape(
	waveManCoordinates.waveManBodyXs, 
	waveManCoordinates.waveManBodyYs)

# ╔═╡ d1f5e0d9-087a-492a-874c-11b2650e8fac
plot(
	Shape(
		waveManCoordinates.waveManBodyXs, 
		waveManCoordinates.waveManBodyYs), 
	color=:cornflowerblue, opacity=0.4)

# ╔═╡ 9a2810e6-390b-4ae2-8d3e-ea348f738ab8
function fromVectorComponentsToFrameCoordMap(frame)::Function
	# 2D-vector components to be mapped into the frame basis
	function (xss::Vector, yss::Vector)
		map((xs, ys) -> 
			[originFrame(frame).x, originFrame(frame).y]  + 
				xs .* [edge1Frame(frame).x, edge1Frame(frame).y]  + 
			    ys .* [edge2Frame(frame).x, edge2Frame(frame).y], xss, yss)
	end # function (xss, yss)
end # function fromVectorsComponentsToFrameCoordMap

# ╔═╡ b04f6d46-53de-4134-bd81-efa4624b9f06
edge1Frame(frame1)

# ╔═╡ dd0566a6-5fa7-4dc7-88e8-e6fe7a0cea7b
waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs

# ╔═╡ e2426d9a-f97c-4484-acdb-c957edc950bd
fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)

# ╔═╡ fd4d8b24-0c1f-4fd8-8829-a54f1ece9794
fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)

# ╔═╡ 07454f7f-5af6-43bf-aa5e-8906c7e58e6f
plot(
	map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)),
	map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)), 
	label=false)

# ╔═╡ cab0c9ca-d5e1-4716-b70e-f56389af9558
plot(
	map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame2)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)),
	map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame2)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)),
	label=false)

# ╔═╡ 00ead5c8-fb00-4a76-8956-86cb3bc15496
plot(Shape(
	map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs)),
	map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame1)(
			waveManCoordinates.waveManBodyXs, 
			waveManCoordinates.waveManBodyYs))),
	color=:cornflowerblue, opacity=0.4, label=false)

# ╔═╡ 755be4e7-b1cd-44b1-8c6c-e496d208eb97
md"
---
###### Painter $waveManShapePainter$
"

# ╔═╡ 6f1daf2d-8753-48b5-85fe-0d0b2d72ae4b
function waveManShapePainter()
	function (frame)
		waveManBodyInFrameXs =
			map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame)(
					waveManCoordinates.waveManBodyXs, 
					waveManCoordinates.waveManBodyYs))
		waveManBodyInFrameYs =
			map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame)(
				waveManCoordinates.waveManBodyXs, 
				waveManCoordinates.waveManBodyYs))
		#------------------------------------------------------------------------
		waveManMouthInFrameXs =
			map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame)(
					waveManCoordinates.waveManMouthXs, 
					waveManCoordinates.waveManMouthYs))
		waveManMouthInFrameYs =
			map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame)(
				waveManCoordinates.waveManMouthXs, 
				waveManCoordinates.waveManMouthYs))
		#------------------------------------------------------------------------
		waveManNoseInFrameXs =
			map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame)(
					waveManCoordinates.waveManNoseXs, 
					waveManCoordinates.waveManNoseYs))
		waveManNoseInFrameYs =
			map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame)(
				waveManCoordinates.waveManNoseXs, 
				waveManCoordinates.waveManNoseYs))
		#------------------------------------------------------------------------
		waveManLeftEyeInFrameXs =
			map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame)(
					waveManCoordinates.waveManLeftEyeXs, 
					waveManCoordinates.waveManLeftEyeYs))
		waveManLeftEyeInFrameYs =
			map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame)(
				waveManCoordinates.waveManLeftEyeXs, 
				waveManCoordinates.waveManLeftEyeYs))
		#------------------------------------------------------------------------
		waveManRightEyeInFrameXs =
			map(vector -> vector[1], fromVectorComponentsToFrameCoordMap(frame)(
					waveManCoordinates.waveManRightEyeXs, 
					waveManCoordinates.waveManRightEyeYs))
		waveManRightEyeInFrameYs =
			map(vector -> vector[2], fromVectorComponentsToFrameCoordMap(frame)(
				waveManCoordinates.waveManRightEyeXs, 
				waveManCoordinates.waveManRightEyeYs))
		#------------------------------------------------------------------------
		[Shape(waveManBodyInFrameXs, waveManBodyInFrameYs), Shape(waveManMouthInFrameXs, waveManMouthInFrameYs), Shape(waveManNoseInFrameXs, waveManNoseInFrameYs),
		Shape(waveManLeftEyeInFrameXs, waveManLeftEyeInFrameYs), Shape(waveManRightEyeInFrameXs, waveManRightEyeInFrameYs)]
	end  # function
end # function waveManShapePainter

# ╔═╡ 5dcd93b7-5d24-47c5-b62e-476d0d4ac97e
plot(waveManShapePainter()(frame1), color=:cornflowerblue, opacity=0.4, label=false)

# ╔═╡ 86d3c1e9-2ed0-46e6-a601-d7495886a3ab
plot(waveManShapePainter()(frame2), color=:cornflowerblue, opacity=0.4, label=false)

# ╔═╡ bae80b14-3e77-4114-8b04-76a34776926f
md"
---
##### 3.5 Transforming and Combining Painters
"

# ╔═╡ 2c1dbfb6-2366-4d81-84d9-7aec3572cd67
md"
---
##### 4. Summary

For our two painters $waveManSilhouettePainter, waveManShapePainter$ we followed this sequence of design steps:

- *construct* a *painter* that paints a *figure of interest (FIGOI)* in the *unit frame* by a *recursive functional* script in the *picture language* 

- embed this *(FIGOI)* in a *frame of interest (FROI)*

- plot the *FROI* with $Plot.jl$ or another *plot library*

The *last* step has to be *delayed* as much as possible.

"

# ╔═╡ b11f4238-6d8b-4ef4-9b2e-274af4d83409
md"
---
##### 5. References

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 1996; last visit 2025/06/03
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://web.mit.edu/6.001/6.037/sicp.pdf), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2025/06/03
- **Deisenroth, M.P.; Faisal, A.A. & Ong, Ch.S.**; Mathematics For Machine Learning; Cambridge: Cambridge University Press, [https://mml-book.github.io/book/mml-book.pdf](https://mml-book.github.io/book/mml-book.pdf); visited 2022/09/07
- **Strang, G.**; Linear Algebra and Learning From Data; Wellesley, MA: Wellesley - Cambridge Press, 2019
- **Wikipedia**; Closure (Computer Programming); [https://en.wikipedia.org/wiki/Closure_(computer_programming)](https://en.wikipedia.org/wiki/Closure_(computer_programming)); visited 2022/09/07
- **Wikipedia**; Closure (Mathematics); [https://en.wikipedia.org/wiki/Closure_(mathematics)](https://en.wikipedia.org/wiki/Closure_(mathematics)); visited 2022/09/07
"

# ╔═╡ 59138adc-440a-41d3-a297-01abdc1db532
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
# ╟─ed783030-3e09-11f0-08b1-8fa252c7593d
# ╟─8d6bd71f-23b1-4932-b7d2-085b232fd59b
# ╟─e50dfb4b-c5d4-4da9-89e7-ae80ef5fa69c
# ╟─f2a66794-0b71-4ce9-8d9f-230b60a13292
# ╠═7c6225d7-3fb1-4336-93c9-55078bb85575
# ╟─681dc23a-4032-4da7-b525-bbe51d334cd3
# ╟─cc8147a3-55ae-4943-81b6-2fbea94bf23b
# ╠═c6bdf830-1dce-48ab-92e9-baae5a3ea8b7
# ╟─0c3317b9-46c2-401d-90c5-d389cd4e5a46
# ╠═f2ee31b9-0814-41d0-a4c5-1a68c8f2e42c
# ╟─2b25dd82-6c60-4082-861d-a608de4315dc
# ╠═8072600c-8148-443f-9648-091e3a388a90
# ╟─1f4786b4-d11a-49fe-ab72-1d83055c0e33
# ╠═e6730566-d799-4e6c-ab0d-4d9a91a960f7
# ╠═655a5024-53f8-4b89-a2cb-4b2321931243
# ╟─8e1e84aa-d1ee-49e3-83da-ad23a2cfddd4
# ╠═52d4a383-885f-473f-9939-52989b8b9c0d
# ╟─1b5e20c0-c83e-400f-9925-31054cdf7dd4
# ╠═1f838420-e724-4445-8318-77d2e981d93d
# ╠═b1fb0a44-e12c-4670-b666-b8bf9f9ec4e7
# ╟─cc1e91ae-4390-4a4f-89b5-0ddd800ef35b
# ╠═f969dbd4-dbf6-4a09-bc2b-3a2d90c9d981
# ╠═5b226945-1442-4d34-8a0d-05d51e1465d8
# ╠═2f9e94d2-4c63-4cc6-b8cd-105685e74a0a
# ╠═5492a690-ce5f-43a3-9aee-5f4b92c0909d
# ╠═a78c070d-7745-4488-895a-dbc70aa3c9c9
# ╠═f26ccbfb-c657-400c-9426-d7f3b1f7448f
# ╟─4d6ce9f8-c266-4b06-9637-54dc8f2b985b
# ╠═2c73a3ae-98c0-4759-b1ce-98c8da98d7c7
# ╠═a43a659f-2338-4a6a-a055-988a4a22cbac
# ╠═259e8a18-5c1f-4dbd-be01-a10194bf18c1
# ╠═1f9ba27e-0ced-4f71-8f35-c3c2aa4b5aaf
# ╠═1d427fe1-21a3-4151-be29-54ef7d531c1e
# ╠═582a778b-47f4-4963-9125-3e9dd419312a
# ╟─1f117119-228b-43de-a743-4818add6cd3f
# ╟─3b4a452e-4896-4a2f-9d94-1d12dea0e8d4
# ╠═c3686863-a0ea-4c0f-868b-a3d913258039
# ╠═529727b7-e6ea-4d8f-82be-a995bed3a72f
# ╠═ca86f7c6-dbd4-4d20-8543-062fa07b6b63
# ╠═aa59c336-00fe-4d42-a851-2131d5fe9e94
# ╠═34db0743-60b0-4aa5-ae96-c19e557513a1
# ╠═f881e434-0961-484d-a90e-cc10c4b3c710
# ╠═5acd24ae-ded2-421f-b7b3-bfcdafca42fa
# ╠═351d3ef3-82ff-4aba-9fc2-9917c2b6572a
# ╟─390ba005-e578-436c-8675-493953883368
# ╠═593200c8-8a4a-4e66-a4aa-6e54df2b0eb1
# ╟─9d18dc06-47cc-49bd-a0d4-3be1a2f729c3
# ╟─ed5149ef-0166-40d7-9696-43e9d2695425
# ╟─9b6a2129-947d-4c3a-9b18-365df5d8e0f8
# ╠═6f8cf580-e928-488a-ac34-0a8136cb624a
# ╟─61225dbf-1cd9-4287-bd80-d04bc100e2d2
# ╠═66ec9e8c-6596-47f0-845d-e27c576d3c68
# ╠═9468816b-5cac-468b-b1db-c73cd995cf80
# ╠═71372e78-5364-4cd5-ac13-ba9f50fdf482
# ╟─bed5357a-f5b8-4b07-a089-ee9f92774b6b
# ╟─8ae3267a-ea9d-4ea6-a8f6-bbaeba7bc2ed
# ╠═ef12e6f3-1b68-4ae2-aba8-224bbfa8a9bf
# ╠═48a3a3f6-39d9-4c04-9515-96146e718595
# ╟─12c50526-d453-4f92-91cb-837725c9c20f
# ╠═d2774d4f-20cf-4154-9646-28ed5cdeef67
# ╠═dccd7558-4fcd-453d-84ed-7f3f3c79f44d
# ╟─8ba1bbf4-2764-4b95-a284-7caa9339766b
# ╠═ce242cf2-9aaa-4afd-b22e-55c925409e9f
# ╠═d4fd558a-fa53-4a6b-b916-15d80872c397
# ╠═6e2dc313-2d15-4ab3-8ca2-906e2d548dca
# ╠═696cda7c-6aca-4c90-9b3a-da0717ab1b8c
# ╠═9e337b84-7e62-40c4-ac8d-40013a599cf2
# ╟─5a8b5990-a82c-4637-8d1c-530f89d39464
# ╟─f92996ce-ee7c-417f-aa3e-8befedb56ed6
# ╠═4bc78c6d-2e39-41c9-af6e-4c9f238eea6e
# ╠═d3880771-94b9-43b8-b55e-e7e8f98937bc
# ╟─b6a7ff2f-2de8-4e30-96b0-b93cdaad64c1
# ╠═2c815fb3-c0c1-42df-a4a8-e58e19936890
# ╠═2e8a64e8-fa45-4902-be7f-6a6a8b719290
# ╠═90392b88-5834-4807-b1c3-7b0ec10c46a0
# ╟─d3e11e59-936c-420c-8bc6-57f47d89298a
# ╠═67d40de1-5c23-4759-abe2-6a5a991c06d5
# ╟─0c6b418d-b888-4b40-925f-00829e0fed72
# ╠═aa2abc32-91ea-46d1-b75d-46fccd52444b
# ╠═5f2fa967-3798-4afd-8c4a-f96919c3b4d8
# ╟─39fca6a6-4081-427d-9ae5-4f9084c3fd73
# ╠═cf8835df-8f66-401f-97f8-d519a3112693
# ╠═17ae3fd2-a96b-43d5-970e-8cddfd9c90e5
# ╟─50351a14-de0b-4be7-97ee-736ddb401d45
# ╟─85cb061e-4074-4ec4-bc81-6f8ceffe6c6f
# ╟─e3af35a2-0d4e-441e-9d28-9609b8537485
# ╠═49dd66f1-d30c-4946-85f6-4986231841a6
# ╠═906b2fd4-0eca-4b24-9212-6f30e4a19e85
# ╠═91127892-395f-4f66-ad94-99ad6a89a997
# ╠═19fdaecd-8614-4761-bbd7-164b808d3fdb
# ╟─11f4b71f-716d-41b4-b384-81cd206b170b
# ╠═8c42f876-9623-4974-9fec-8ae728bc5f78
# ╠═d327d008-cf25-456a-9893-eea733bc83c0
# ╠═d62d8161-de05-42cd-ab5f-ef03842166cd
# ╠═c404616e-aa80-4a1c-8426-4d1e7917749c
# ╠═5d0071d4-7d45-41a3-85b1-4db95ccf6336
# ╠═01995ab8-1eba-40c4-97b7-c6a4b5bbf447
# ╟─8badc4d8-20ac-404a-8baf-ef683ec664b6
# ╠═77f3cb62-35fa-4fd3-aabb-7b0cb2f218a5
# ╠═af3d1b82-9e58-4f79-a257-1c033d10ed54
# ╠═962a9be5-3ef6-46b2-b65e-f79779d97d3b
# ╠═e75e526a-69d3-4420-a763-6c43597fe2df
# ╠═1134f274-92d4-4dd4-9740-a22c88b75752
# ╟─248cf3e6-9b96-4c0a-9fd4-b5985044c329
# ╠═6b1fc47b-2206-4a3d-98fd-964808630d18
# ╠═6d7788cf-c3e4-4832-8e22-a52ccbb010ba
# ╠═3b40e793-93d1-4ca8-ab78-788449f613e2
# ╠═d3c8cc22-f34f-46af-8d4f-10a07b9f499c
# ╠═774e52f3-fc50-4350-8b75-8f92ae3f2dd0
# ╠═4c6f262f-909e-48a1-a566-4319c240d492
# ╠═20a7d01b-afaf-4500-966e-446819d5b6f1
# ╠═53184b92-eefd-4c14-8b59-671f7fee0074
# ╠═374eaa45-1e6b-4d19-9ce9-3b3e4510c56c
# ╠═77e84104-debb-435e-9184-7b79e6f730f4
# ╠═1c50caf6-14b2-49e1-8eca-79986462092e
# ╠═fa48c228-10ce-4681-927d-2a4cb3af199b
# ╠═4b1c5204-cf96-44fe-8d01-0559de944028
# ╠═416144cd-1d87-452e-aa38-3d64516b80bf
# ╠═bc903351-bc95-41e3-8763-965d62cfd6b4
# ╠═25136ed2-540b-43d5-9087-adfb10bd5401
# ╠═19af462d-9c54-4ed1-b999-3eebc6e8e3e3
# ╠═da30b5f0-6144-4503-866c-b42ed704b249
# ╠═0458f5e5-0e00-4f17-8aac-fa7de3b7b958
# ╠═4b382506-cc1e-4895-ac0a-9c82fd8df848
# ╠═e12b2116-d310-4475-8898-cf8eadbb7b62
# ╠═b083310b-4de3-4b3d-967c-0af4ea0b06d5
# ╠═7d54ba1f-e86f-4cb8-b415-36bbc674fdbb
# ╠═921c1f16-a5e7-459c-aa85-1af2c7447f31
# ╟─985b867e-ea4f-4212-99c3-fb59293bc330
# ╟─be85f063-52d1-4a90-9fea-c7ea533579db
# ╠═93d9b8a7-49c3-4063-9398-db6ec0bb86cc
# ╠═40bb49a1-91f6-4408-af1e-b247267d2fd4
# ╠═c0d6d720-04eb-4776-9fd3-046baa729c9e
# ╠═18f2a8b4-209c-4de4-b681-71482e7c4eff
# ╠═ef7db86c-49e0-4acc-87e1-6e49f4b80663
# ╠═f2158a99-7b82-4023-879b-a829d03cbd4a
# ╟─3bea9896-fbf9-4933-abb4-babdf8988b01
# ╠═9de2a15b-81f4-4211-95bf-884b0612f8a6
# ╠═a93f41a9-2589-48c0-91ef-4a42109f20c2
# ╠═9149333b-3f51-4ab1-9a21-fa784048c4c4
# ╠═9709f125-11cd-40ea-87e3-f35ed6f7ef59
# ╠═eadd41b4-e398-453b-bdc2-f75b02ff625f
# ╠═b771d539-95bb-4fe7-b69f-a88837237580
# ╠═a8a2ba5f-cc83-46aa-a2bb-bcda2d69c37d
# ╠═d1f5e0d9-087a-492a-874c-11b2650e8fac
# ╠═9a2810e6-390b-4ae2-8d3e-ea348f738ab8
# ╠═b04f6d46-53de-4134-bd81-efa4624b9f06
# ╠═dd0566a6-5fa7-4dc7-88e8-e6fe7a0cea7b
# ╠═e2426d9a-f97c-4484-acdb-c957edc950bd
# ╠═fd4d8b24-0c1f-4fd8-8829-a54f1ece9794
# ╠═07454f7f-5af6-43bf-aa5e-8906c7e58e6f
# ╠═cab0c9ca-d5e1-4716-b70e-f56389af9558
# ╠═00ead5c8-fb00-4a76-8956-86cb3bc15496
# ╟─755be4e7-b1cd-44b1-8c6c-e496d208eb97
# ╠═6f1daf2d-8753-48b5-85fe-0d0b2d72ae4b
# ╠═5dcd93b7-5d24-47c5-b62e-476d0d4ac97e
# ╠═86d3c1e9-2ed0-46e6-a601-d7495886a3ab
# ╟─bae80b14-3e77-4114-8b04-76a34776926f
# ╟─2c1dbfb6-2366-4d81-84d9-7aec3572cd67
# ╟─b11f4238-6d8b-4ef4-9b2e-274af4d83409
# ╟─59138adc-440a-41d3-a297-01abdc1db532
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
