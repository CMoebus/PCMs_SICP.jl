### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 80081220-795f-11ed-23a9-7d079b42320f
md"
====================================================================================
#### SICP\_2.5.2.2\_[Coercion](https://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5_002e2)
###### file: PCM20221211_SICP_2.5.2.2_Coercion.jl
###### Julia/Pluto.jl-code (1.8.2/0.19.14) by PCM *** 2022/12/14 ***
====================================================================================
"

# ╔═╡ 2c0e0e4b-f3c0-45bb-8fb3-d508775d71f3
md"
#### 2.5.2.2.1 SICP-Scheme-like functions and operators
"

# ╔═╡ ee92fdf3-7d85-4c69-8290-83d8f98dbf4e
md"
---
##### *Ground*-level SICP-*Scheme*-like functions and operators
"

# ╔═╡ 065789f1-c472-40fc-a25b-a432ea49f2d8
struct Cons
	car
	cdr
end

# ╔═╡ 047b139a-1080-4a7a-b712-8df06fe723a1
begin
	cons(car::Any, cdr::Any)::Cons = Cons(car, cdr)::Cons  
	car(cell::Cons) = cell.car
	cdr(cell::Cons)::Any = cell.cdr
end # begin

# ╔═╡ 87eed4e2-cf2f-480c-8c05-7c0fa2f78894
md"
---
##### Representation *in*dependent interface functions
"

# ╔═╡ 005205f6-cdc8-4012-b4f5-4c284db68c6e
function attachTag(contents, typeTag) 
	cons(typeTag, contents) 
end # attachTag

# ╔═╡ 44f345ab-5d90-4d56-8832-5f200eb5e3e2
function typeTag(datum) 
	car(datum)
end # typeTag

# ╔═╡ 7b009e05-cb78-48b4-8032-4ecc5d4eb96a
function contents(datum) 
	cdr(datum)
end # function contents

# ╔═╡ f9751afb-1b57-4cac-be65-e6670e8f101a
md"
---
##### Procedures for the manipulation of the *operation*$$\times$$*type* tables
"

# ╔═╡ d5852ce5-01a3-4b26-ad74-3cd8037a90d8
md"
##### Table *constructors*
"

# ╔═╡ e7c18e36-193b-478b-9b32-76f075e98da0
Dict{Tuple, Function}                 # types of dictionary

# ╔═╡ a21bb3b9-c703-44eb-8f01-714af95b69bb
md"
###### *Operation*$$\times$$*Type*-Table
"

# ╔═╡ 04589673-c555-40c7-95f1-ccf1d4a4fd57
# construction of empty table as a dictionary
myTableOfOpsAndTypes = Dict()

# ╔═╡ c075be7b-0e07-485c-912a-3f3a311d8910
md"
###### *Coercion*-Table
"

# ╔═╡ cc4cf31a-a8d7-43da-9939-e7af65909256
coerceTable = Dict()                 # NEW: Coercion Table

# ╔═╡ 19f07f26-c0a1-4328-9510-ab3d853cdcd0
function myPut!(op::Symbol, opTypes::Tuple, lambdaExpression::Function) 
	# Dict((op::Symbol, opType::Symbol) <= lambdaExpression::Function)
	myTableOfOpsAndTypes[op::Symbol, opTypes::Tuple] = lambdaExpression
end # function put

# ╔═╡ 734dbaaf-aded-4f52-9144-c8781ce80c06
# NEW: Coercion Table
#--------------------------------------------------------------------------------
function putCoercion!(op::Symbol, opTypes::Tuple, lambdaExpression::Function) 
	coerceTable[op::Symbol, opTypes::Tuple] = lambdaExpression
end # function putCoercion!

# ╔═╡ 25e78a09-6feb-4224-a91d-ef3a077136dd
md"
---
###### Table *selectors*
"

# ╔═╡ a2417bb8-abe8-4387-ba35-ffa6094ecade
# is a variation of SICP's get
function getFromTable(op::Symbol, opType::Tuple; table::Dict = myTableOfOpsAndTypes) 
	table[op::Symbol, opType::Tuple]
end # function myGet

# ╔═╡ bb6ea0f2-3482-4360-a5b3-d797dfbaf588
# NEW: Coercion Table
#--------------------------------------------------------------------------------
function getCoercion(op::Symbol, opType::Tuple) # instead of SICP's get-coercion
	# Dict((op::Symbol, opType::Symbol) => item::Function)
	coerceTable[op::Symbol, opType::Tuple]
end # function myGet

# ╔═╡ e38a9de1-db53-408c-adaf-eb7ae6edbefc
function getOpsOfType(table, argType)
	filter(pairOpOpType -> 
		let
			(op, opType) = pairOpOpType
			opType == argType ? true : false
		end, # let
		keys(table))
end # function getOpsOfType

# ╔═╡ bc3f117f-ae8c-4fab-a4fa-ebd5a7bbbf88
md"
---
##### *Generic* arithmetic procedures
"

# ╔═╡ 94297eb4-401f-40c4-8648-3d2b8a017e74
md"
this version of $$applyGeneric(opSymbol, xs...; table=...)$$ deviates from
the more complicated version in SICP, 1996, p.196 or [here](https://sarabander.github.io/sicp/html/2_002e5.xhtml#g_t2_002e5_002e2)
"


# ╔═╡ c784a7ef-6441-4daf-a342-ee52ccd0b525
function applyGeneric(opSymbol, args...; table = myTableOfOpsAndTypes)
	let
		typeTags = map(typeTag, args)
		proc     = getFromTable(opSymbol, typeTags; table)  # splatting of typeTags
		content  = map(contents, args)  
		if applicable(proc, content...) # is proc, applicable to content ?
			proc(content...)            # application of proc to splatted content
		else
			error("proc is not applicable")
		end # if
	end # let
end # function applyGeneric

# ╔═╡ 6c8e2f42-39b5-466a-a4dd-41841638b0fe
md"
---
##### *Generic* arithmetic selectors or *coerce* operators
"

# ╔═╡ 4f593b9f-4fbe-4f2e-9591-2da88ffe1a25
begin
	#-------------------------------------------------------------------------------
	numerator(x)   = applyGeneric(:numer, x)        # generic selector numerator
	denominator(x) = applyGeneric(:denom, x)        # generic selector denominator
	realPart(z)    = applyGeneric(:realPart, z)     # generic selector realPart
	imagPart(z)    = applyGeneric(:imagPart, z)     # generic selector imagPart
	magnitude(z)   = applyGeneric(:magnitude, z)    # generic selector norm
	angle(z)       = applyGeneric(:angle, z)        # generic selector angle
	#-------------------------------------------------------------------------------
	# NEW: generic coerce operator
	coerce(x)      = applyGeneric(:coerce, x; table = coerceTable) 
	#-------------------------------------------------------------------------------
end

# ╔═╡ 11c75ea2-154f-499b-b7f0-3c795f318cd8
md"
---
##### *Generic* arithmetic operators
"

# ╔═╡ 17860a11-7ae0-470f-8a1a-995933aac5db
begin
	#------------------------------------------------------------------------
	add(x, y)  = applyGeneric(:add, x, y)  # generic addition function
	sub(x, y)  = applyGeneric(:sub, x, y)  # generic subtraction function
	mul(x, y)  = applyGeneric(:mul, x, y)  # generic multiplication function
	div(x, y)  = applyGeneric(:div, x, y)  # generic division function
	#------------------------------------------------------------------------
end # begin

# ╔═╡ 1654d72c-ba2f-4db7-aa97-b80572faeac9
md"
---
##### *Coerce* package
"

# ╔═╡ 401b05ba-dba9-4517-9209-d836d9f95b44
function installCoercePackage()
	#======================================================================#
	# local procedures
	tag!(x; typeTag=:rectangular) = attachTag(x, typeTag,)
	#------------------------------------------------------
	makeZFromRealImag(x, y)       = cons(x, y)
	fromSicpNumberToComplex(x)    = makeZFromRealImag(x, 0)
	#======================================================================#
	# interface to rest of system
	putCoercion!(:coerce, (:sicpNumber,), # fromSicpNumberToComplex)
		x -> tag!(fromSicpNumberToComplex(x))) 
	#----------------------------------------------------------------
	putCoercion!(:coerce2, (:sicpNumber,), # fromSicpNumberToComplex)
		x -> tag!(fromSicpNumberToComplex(x))) 
	#======================================================================#
end # function installCoercePackage

# ╔═╡ 3d9c1d77-ead8-4b26-aa66-cab47a199fa0
installCoercePackage()

# ╔═╡ ba344a65-8eef-4212-8cca-7db1efbe2dd3
getOpsOfType(coerceTable, (:sicpNumber,))

# ╔═╡ 30964238-b1df-4ca3-8aec-28d91ed3576d
md"
---
#### 2.5.2.2.2 *idiomatic* Julia functions and operators
"

# ╔═╡ 63e820f8-4d17-4c97-9c7b-cc28b36a1fe1
md"
---
##### *Ordinary* (SICP-*Scheme*-like) number package
"


# ╔═╡ ca61a55d-b635-4b3b-b278-8f3320452dbc
function installSICPNumberPackage()
	#======================================================================#
	# local procedures
	tag!(x; typeTag=:sicpNumber) = attachTag(x, typeTag)
	#----------------------------------------
	printSicpNumber(sicpNumber) = sicpNumber
	#======================================================================#
	# interface to rest of system
	myPut!(:print,(:sicpNumber,),                       printSicpNumber)
	#-----------------------------------------------------------------------
	myPut!(:make, (:sicpNumber,),                  x -> tag!(x))
	#-----------------------------------------------------------------------
	myPut!(:add,  (:sicpNumber, :sicpNumber), (x, y) -> tag!(x + y))
	myPut!(:sub,  (:sicpNumber, :sicpNumber), (x, y) -> tag!(x - y))
	myPut!(:mul,  (:sicpNumber, :sicpNumber), (x, y) -> tag!(x * y))
	myPut!(:div,  (:sicpNumber, :sicpNumber), (x, y) -> tag!(x / y))
	#-----------------------------------------------------------------------
	"package sicpNumber done" 
	#======================================================================#
end # function installJuliaNumberPackage

# ╔═╡ 1886efa5-ccf6-4a7a-9382-1499ae6dd634
installSICPNumberPackage()

# ╔═╡ 620da71b-1cb0-4b85-b0bc-e4a516c3d241
getOpsOfType(myTableOfOpsAndTypes, (:sicpNumber,))

# ╔═╡ 2b42a557-c62e-497f-bee1-c06805cebcdb
getOpsOfType(myTableOfOpsAndTypes, (:sicpNumber, :sicpNumber))

# ╔═╡ 0813383d-bf96-4ebd-8bb2-475f07b57bca
md"
---
###### *Constructor* of ordinary (*Scheme*-like) numbers
"

# ╔═╡ d61cdd76-5011-472b-ab00-aad245c465d2
function makeSicpNumber(n) 
	getFromTable(:make, (:sicpNumber,))(n)
end # function makeSicpNumber

# ╔═╡ 3d65aa2f-7110-4f6f-b861-c92366795bfe
coerce(makeSicpNumber(3))

# ╔═╡ 96c31367-6bc8-44e5-b7f2-68516c5dfad5
md"
---
##### *Complex* number package based on *rectangular* coordinates
"

# ╔═╡ 7fb19a44-1ca5-437f-9ea1-b1eaedad80bf
function installRectangularPackage() # Ben's rectangular package
	#================================================================================#
	# internal procedures
	tag!(x; typeTag=:rectangular) = attachTag(x, typeTag)
	#----------------------------------------------------------
	makeZFromRealImag(x, y) = cons(x, y)
	makeZFromMagAng(r, a)   = cons(r * cos(a), r * sin(a))
	#----------------------------------------------------------
	realPartRect(z)  = car(z)
	imagPartRect(z)  = cdr(z)
	magnitudeRect(z) = √(realPartRect(z)^2 + imagPartRect(z)^2)
	angleRect(z)     = atan(imagPartRect(z), realPartRect(z))
	#----------------------------------------------------------
	addComplexRect(z1, z2) = 
		makeZFromRealImag(
			realPartRect(z1) + realPartRect(z2), 
			imagPartRect(z1) + imagPartRect(z2))
	#--------------------------------------------
	subComplexRect(z1, z2) = 
		makeZFromRealImag(
			realPartRect(z1) - realPartRect(z2), 
			imagPartRect(z1) - imagPartRect(z2))
	#--------------------------------------------
	mulComplexRect(z1, z2) = 
		let
			x1 = realPartRect(z1)
			x2 = realPartRect(z2)
			y1 = imagPartRect(z1)
			y2 = imagPartRect(z2)
			makeZFromRealImag(
				(x1 * x2 - y1 * y2), 
				(x1 * y2 + y1 * x2))
		end # let
	#--------------------------------------------
	divComplexRect(z1, z2) = 
		let
			x1 = realPartRect(z1)
			x2 = realPartRect(z2)
			y1 = imagPartRect(z1)
			y2 = imagPartRect(z2)
			denominator = (x2^2 + y2^2)
			makeZFromRealImag(
				(x1 * x2 + y1 * y2) / denominator, 
				(x2 * y1 - x1 * y2) / denominator)
		end # let
	#---------------------------------------------------------------------------------# NEW: cross-type operation	
	addComplexToSicpNumber(z, x) = 
		makeZFromRealImag(realPartRect(z) + x, imagPartRect(z) + 0)
	#================================================================================#
	# interface to rest of system
	myPut!(:makeZFromRealImag, (:rectangular,), 
		(x,y) -> tag!(makeZFromRealImag(x, y)))
	myPut!(:makeZFromMagAng,   (:rectangular,), 
		(r,a) -> tag!(makeZFromMagAng(r, a)))
	#---------------------------------------------------------------------------------
	myPut!(:realPart,  (:rectangular,),                  realPartRect)
	myPut!(:imagPart,  (:rectangular,),                  imagPartRect)
	myPut!(:magnitude, (:rectangular,),                  magnitudeRect)
	myPut!(:angle,     (:rectangular,),                  angleRect)
	#---------------------------------------------------------------------------------
	myPut!(:add, (:rectangular, :rectangular), (z1, z2)->tag!(addComplexRect(z1, z2)))
	myPut!(:sub, (:rectangular, :rectangular), (z1, z2)->tag!(subComplexRect(z1, z2)))
	myPut!(:mul, (:rectangular, :rectangular), (z1, z2)->tag!(mulComplexRect(z1, z2)))
	myPut!(:div, (:rectangular, :rectangular), (z1, z2)->tag!(divComplexRect(z1, z2)))
	#---------------------------------------------------------------------------------# NEW: cross-type operation	
	myPut!(:add, (:rectangular, :sicpNumber),  
		(z, x)->tag!(addComplexToSicpNumber(z, x)))
	#---------------------------------------------------------------------------------
	"Ben's rectangular package installed"
	#================================================================================#
end # function installRectangularPackage

# ╔═╡ cfed0369-e64d-4ece-9026-4e93f42fcf2a
installRectangularPackage()

# ╔═╡ bb9bd7c0-11ec-4156-885a-33eebc4074b6
getOpsOfType(myTableOfOpsAndTypes, (:rectangular,))

# ╔═╡ df61d165-a20a-4042-adb6-4374f761c53c
getOpsOfType(myTableOfOpsAndTypes, (:rectangular, :rectangular))

# ╔═╡ d3c0631a-1479-4b7a-94f9-04ea5fb42387
getOpsOfType(myTableOfOpsAndTypes, (:rectangular, :sicpNumber))  # NEW: cross-type operation	

# ╔═╡ 25f60485-ae54-4e36-860f-1b8b37558f90
getOpsOfType(coerceTable, (:sicpNumber, :rectangular))  # NEW: coerce operation	

# ╔═╡ 80c7d4ce-c1cf-4996-9526-9a707135aef2
md"
---
##### *Constructor* for *rectangular* complex numbers *external* to Ben's package
"

# ╔═╡ d46cdc38-db14-416b-ad34-10e6c63b4062
function makeZRectFromRealImag(x, y)                            # SICP, 1996, p.184
	getFromTable(:makeZFromRealImag, (:rectangular,))(x, y)
end # function makeZRectFromRealImag

# ╔═╡ c85fbdb9-5dc1-441b-8adc-f73ed790c566
md"
---
##### *Coercian* constructions with *coerce* package
"

# ╔═╡ d6b7687a-b0fe-4808-bf21-a8911892883f
coerceTable

# ╔═╡ 65987e45-dc6f-4f86-ba09-e731f9ba7438
coerceTable[:coerce, (:sicpNumber,)](3)

# ╔═╡ 6d6bbce6-72b0-4c68-9b59-d9fcf804fa64
getCoercion(:coerce, (:sicpNumber,))

# ╔═╡ d05e736f-5c10-4744-88dd-46dd275e4fc8
getCoercion(:coerce, (:sicpNumber,))(3)

# ╔═╡ bf885c19-fcac-4cbc-ad3c-f9ee936a4276
applyGeneric(:coerce, makeSicpNumber(3); table = coerceTable)

# ╔═╡ 78d3e9c2-5585-435e-a039-7f675b6517ab
coerce(makeSicpNumber(3))

# ╔═╡ 9e34ff9a-727a-4d98-8348-6e4308fc33b7
let # NEW: concercion
	z1 = coerce(makeSicpNumber(3)) # NEW: z1 ==> Cons(:rectangular, Cons(3, 0))
	z2 = makeZRectFromRealImag(2, 1)  #   z2 ==> Cons(:rectangular, Cons(2, 1))
	add(z1, z2)                       #      ==> Cons(:rectangular, Cons(5, 1)) 
end # let

# ╔═╡ 68032f90-adde-41a2-b105-2d7df9e8a083
let # NEW: concercion
	z1 = coerce(makeSicpNumber(3.0)) # NEW: z1 ==> Cons(:rectangular, Cons(3,  0))
	z2 = makeZRectFromRealImag(2, 1)    #   z2 ==> Cons(:rectangular, Cons(2,  1))
	sub(z1, z2)                         #      ==> Cons(:rectangular, Cons(1.0, -1)) 
end # let

# ╔═╡ edee136c-1abd-408d-84fb-1495d7e34662
let # NEW: concercion
	z1 = coerce(makeSicpNumber(3.0)) # NEW: z1 ==> Cons(:rectangular, Cons(3,  0))
	z2 = makeZRectFromRealImag(2, 1)    #   z2 ==> Cons(:rectangular, Cons(2,  1))
	# (3 + 0i)(2 + 1i) = (6 - 0i)(0i + 3i) = (6 + 3i)
	mul(z1, z2)                         #      ==> Cons(:rectangular, Cons(6.0, 3.0)) 
end # let

# ╔═╡ 00ad40e3-49bf-4f14-a53f-ca776ad61bf0
let # NEW: concercion
	z1 = coerce(makeSicpNumber(3)) # NEW: z1 ==> Cons(:rectangular, Cons(3,  0))
	z2 = makeZRectFromRealImag(2, 1)  #   z2 ==> Cons(:rectangular, Cons(2,  1))
	# (3 + 0i)/(2 + 1i) = ((3 + 0i)(2 - 1i))/((2 + 1i)(2 - 1i)) = (6 - 3i)/(4 + 1)
	# = (6 - 3i)/(4 + 1) = 6/5 - 3/5i = (1.2 - 0.6i)
	div(z1, z2)                       #      ==> Cons(:rectangular, Cons(1.2, -0.6)) 
end # let

# ╔═╡ 779a818e-ccc5-4356-a1c2-432c36b61606
md"
---
#### *Test* computations with *rectangular* package
##### Complex *addition*
"

# ╔═╡ 40d9bb00-6ab2-470a-a618-a886c80dd5b3
let
	z1 = makeZRectFromRealImag(2, 1)
	z2 = makeZRectFromRealImag(3, 2)
	add(z1, z2)                       #  ==>5 + 3i
end # let

# ╔═╡ f39a309b-e940-4572-ab5d-d73c204abd34
md"
##### *Cross-type* constructions with *rectangular* package
"

# ╔═╡ a0736f02-ac4c-4bfa-89b2-e4113e835b8e
let
	z = makeZRectFromRealImag(2, 1)
    x = makeSicpNumber(3)            # NEW: cross-type operation
	add(z, x)                        # ==>  Cons(:rectangular, Cons(5, 1)) 
end # let

# ╔═╡ ae6d0a14-8005-41c9-b9d1-5d12df8148c4
md"
###### *Coercion* in Julia
"

# ╔═╡ 9e39ef43-dac2-40b6-bf10-3a59dbda17aa
let
	z1 = Complex(2, 1)
	x = 3
	typeof(z1)                       # ==> Complex{Int64}
	z2::Complex{Int64} = x           # NEW: coercion operation
    z1 + z2                          # ==> 5 + 1im
end # let

# ╔═╡ 61830f4f-84aa-4198-9e90-a80775372ae4
let
	z1 = Complex(2, 1)
	x = 3.0
	z2::Complex{Float64} = x          # NEW: coercion operation 
	typeof(z2)                        # ==> Complex{Float64}
    z1 + z2                           # ==> 5.0 + 1.0im
end # let

# ╔═╡ fba4a8fa-5f31-41b8-b39e-3af75702a90f
md"
---
##### end of ch. 2.5.2.2
"

# ╔═╡ 0d9a52ce-5411-4035-8f09-2c295b8edd1c
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
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
# ╟─80081220-795f-11ed-23a9-7d079b42320f
# ╟─2c0e0e4b-f3c0-45bb-8fb3-d508775d71f3
# ╟─ee92fdf3-7d85-4c69-8290-83d8f98dbf4e
# ╠═065789f1-c472-40fc-a25b-a432ea49f2d8
# ╠═047b139a-1080-4a7a-b712-8df06fe723a1
# ╟─87eed4e2-cf2f-480c-8c05-7c0fa2f78894
# ╠═005205f6-cdc8-4012-b4f5-4c284db68c6e
# ╠═44f345ab-5d90-4d56-8832-5f200eb5e3e2
# ╠═7b009e05-cb78-48b4-8032-4ecc5d4eb96a
# ╟─f9751afb-1b57-4cac-be65-e6670e8f101a
# ╟─d5852ce5-01a3-4b26-ad74-3cd8037a90d8
# ╠═e7c18e36-193b-478b-9b32-76f075e98da0
# ╟─a21bb3b9-c703-44eb-8f01-714af95b69bb
# ╠═04589673-c555-40c7-95f1-ccf1d4a4fd57
# ╟─c075be7b-0e07-485c-912a-3f3a311d8910
# ╠═cc4cf31a-a8d7-43da-9939-e7af65909256
# ╠═19f07f26-c0a1-4328-9510-ab3d853cdcd0
# ╠═734dbaaf-aded-4f52-9144-c8781ce80c06
# ╟─25e78a09-6feb-4224-a91d-ef3a077136dd
# ╠═a2417bb8-abe8-4387-ba35-ffa6094ecade
# ╠═bb6ea0f2-3482-4360-a5b3-d797dfbaf588
# ╠═e38a9de1-db53-408c-adaf-eb7ae6edbefc
# ╟─bc3f117f-ae8c-4fab-a4fa-ebd5a7bbbf88
# ╟─94297eb4-401f-40c4-8648-3d2b8a017e74
# ╠═c784a7ef-6441-4daf-a342-ee52ccd0b525
# ╟─6c8e2f42-39b5-466a-a4dd-41841638b0fe
# ╠═4f593b9f-4fbe-4f2e-9591-2da88ffe1a25
# ╟─11c75ea2-154f-499b-b7f0-3c795f318cd8
# ╠═17860a11-7ae0-470f-8a1a-995933aac5db
# ╟─1654d72c-ba2f-4db7-aa97-b80572faeac9
# ╠═401b05ba-dba9-4517-9209-d836d9f95b44
# ╠═3d9c1d77-ead8-4b26-aa66-cab47a199fa0
# ╠═ba344a65-8eef-4212-8cca-7db1efbe2dd3
# ╠═3d65aa2f-7110-4f6f-b861-c92366795bfe
# ╟─30964238-b1df-4ca3-8aec-28d91ed3576d
# ╟─63e820f8-4d17-4c97-9c7b-cc28b36a1fe1
# ╠═ca61a55d-b635-4b3b-b278-8f3320452dbc
# ╠═1886efa5-ccf6-4a7a-9382-1499ae6dd634
# ╠═620da71b-1cb0-4b85-b0bc-e4a516c3d241
# ╠═2b42a557-c62e-497f-bee1-c06805cebcdb
# ╟─0813383d-bf96-4ebd-8bb2-475f07b57bca
# ╠═d61cdd76-5011-472b-ab00-aad245c465d2
# ╟─96c31367-6bc8-44e5-b7f2-68516c5dfad5
# ╠═7fb19a44-1ca5-437f-9ea1-b1eaedad80bf
# ╠═cfed0369-e64d-4ece-9026-4e93f42fcf2a
# ╠═bb9bd7c0-11ec-4156-885a-33eebc4074b6
# ╠═df61d165-a20a-4042-adb6-4374f761c53c
# ╠═d3c0631a-1479-4b7a-94f9-04ea5fb42387
# ╠═25f60485-ae54-4e36-860f-1b8b37558f90
# ╟─80c7d4ce-c1cf-4996-9526-9a707135aef2
# ╠═d46cdc38-db14-416b-ad34-10e6c63b4062
# ╟─c85fbdb9-5dc1-441b-8adc-f73ed790c566
# ╠═d6b7687a-b0fe-4808-bf21-a8911892883f
# ╠═65987e45-dc6f-4f86-ba09-e731f9ba7438
# ╠═6d6bbce6-72b0-4c68-9b59-d9fcf804fa64
# ╠═d05e736f-5c10-4744-88dd-46dd275e4fc8
# ╠═bf885c19-fcac-4cbc-ad3c-f9ee936a4276
# ╠═78d3e9c2-5585-435e-a039-7f675b6517ab
# ╠═9e34ff9a-727a-4d98-8348-6e4308fc33b7
# ╠═68032f90-adde-41a2-b105-2d7df9e8a083
# ╠═edee136c-1abd-408d-84fb-1495d7e34662
# ╠═00ad40e3-49bf-4f14-a53f-ca776ad61bf0
# ╟─779a818e-ccc5-4356-a1c2-432c36b61606
# ╠═40d9bb00-6ab2-470a-a618-a886c80dd5b3
# ╟─f39a309b-e940-4572-ab5d-d73c204abd34
# ╠═a0736f02-ac4c-4bfa-89b2-e4113e835b8e
# ╟─ae6d0a14-8005-41c9-b9d1-5d12df8148c4
# ╠═9e39ef43-dac2-40b6-bf10-3a59dbda17aa
# ╠═61830f4f-84aa-4198-9e90-a80775372ae4
# ╟─fba4a8fa-5f31-41b8-b39e-3af75702a90f
# ╟─0d9a52ce-5411-4035-8f09-2c295b8edd1c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
