### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 843709b0-0b76-11ee-0c22-b7be9fa055ad
md"
====================================================================================
#### SICP: 3.3.5 [Propagation of Constraints](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-22.html#%_sec_3.3.5)
##### - DSL + Relational Computation -
##### file: PCM20230530\_SICP\_3.3.5\_Propagation\_of\_Constraints.jl
##### Julia/Pluto.jl-code (1.9.0/0.19.25) by PCM *** 2023/06/26 ***
====================================================================================
"

# ╔═╡ 906f42b0-02e1-4187-9723-93eb25ddff0c
md"
##### 3.3.5.1 Cons-cells and Lists
"

# ╔═╡ 15ca1e27-c0f0-451c-9c55-8e7bf5a3d5a0
md"
###### Constructors
"

# ╔═╡ f0ad7f8f-49db-4f29-93fd-0804eaa3bcba
#----------------------------------------------
# taken from 3.3.1
#----------------------------------------------
mutable struct Cons # 'mutable' is dangerous ! 
	car
	cdr
end # struct Cons

# ╔═╡ 5a54a1fa-4e50-4b62-b020-59fcfee31d03
cons(car, cdr) = Cons(car, cdr)     # 'Cons' is a structure with 'car' and 'cdr'

# ╔═╡ 47b3a3d1-609c-4727-8a69-7896d25b33be
#---------------------------------------------------
# taken from ch. 2.2.1
#---------------------------------------------------
list(elements...) = 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], list(elements[2:end]...))
	end #if

# ╔═╡ e0064cce-a035-480c-8f47-3823c4d86cd2
list()

# ╔═╡ 5f05a88a-b389-4e19-9a16-f9c9ff418a00
list(())

# ╔═╡ 94b5abbe-af43-4a86-9f41-da83c7adf7c0
list(:nil)

# ╔═╡ beda16f5-29e7-4dd0-9d6b-cc5667a0260c
md"
---
###### Selectors
"

# ╔═╡ dd69bf91-c644-4846-958d-a638c4687a9a
car(cons::Cons) = cons.car

# ╔═╡ de7d7656-598a-46f7-bdc3-b5eaeb693406
cdr(cons::Cons) = cons.cdr

# ╔═╡ a5dbc915-abce-4674-a33a-9014cbed390b
md"
---
###### Predicates
"

# ╔═╡ 65def842-3bc2-4456-8051-4cf7b0aa794f
function null(list)
	list == ()   ? true :	
	list == :nil ? true :
	((car(list) == :nil) || car(list) == ()) && 
		(cdr(list) == :nil ) ? true : false
end # function

# ╔═╡ c43f39f2-493a-45a4-8c9a-ff8ce8b193cf
null(())

# ╔═╡ 46df5136-53d4-4c93-ace2-02ded669e34c
null(list(()))

# ╔═╡ 55699211-b893-4a13-b131-5ea78c97d85f
null(list(:nil))

# ╔═╡ 5a77e577-58af-41ba-99f3-b24f8a91061a
#-------------------------------------------------------------------------------
# from SICP, ch 2.3.1
# the return type of 'memq' is a union of 'Bool', Symbol(:nil), and 'Cons';
# usually this union of return types is considered *bad* practice
#-------------------------------------------------------------------------------
function memq(
	item::Union{Symbol, Function, Cons}, 
	items::Union{Symbol, Function, Cons})::Union{Bool, Symbol, Function, Cons}
	items == list(:nil) ? false : # ==> 'Bool'
	items == list()     ? false : # ==> 'Bool'
	items == list(())   ? false : # ==> 'Bool'
	items == :nil ? false :       # ==> 'Bool'
	item == car(items) ? items :  # ==> Symbol :nil, Function, or 'Cons'
	memq(item, cdr(items))        # tail-recursive call
end # function memq

# ╔═╡ 374f761c-8002-4e63-ac7b-172f72d6fd03
typeof(false)

# ╔═╡ 23509e90-b5fa-4027-b055-7da3c73566f7
typeof(list(:nil))

# ╔═╡ 19447b8d-085c-437e-a6a0-9242c7c750d6
md"
---
###### Tests
"

# ╔═╡ b0034ffd-beee-4551-a316-4015b5f12510
x = cons(()->"here", list())

# ╔═╡ b78e4dc4-efbb-46c7-a473-397ecad489e7
car(x)()

# ╔═╡ 25684760-cb4c-49c0-bc89-9acf83cbef51
list(:pear, :banana, :prune)

# ╔═╡ 8c8c241b-f859-4bab-bfe1-25c37f2c7178
cdr(list(:pear, :banana, :prune))

# ╔═╡ fb0179b6-1e76-472b-9c9e-83443d222379
null(cdr(list(:pear, :banana, :prune)))

# ╔═╡ c87bd9f4-6f9e-4d2d-aaaa-723bfd407fa8
cdr(cdr(list(:pear, :banana, :prune)))

# ╔═╡ 6949cd4a-828b-43fe-894e-96f042e46aea
null(cdr(cdr(list(:pear, :banana, :prune))))

# ╔═╡ 3dd04078-cf4b-4cce-b4b2-5001a57aa2a0
cdr(cdr(cdr(list(:pear, :banana, :prune))))

# ╔═╡ 749064e0-8570-495a-9855-e7d9c0a1466c
null(cdr(cdr(cdr(list(:pear, :banana, :prune)))))

# ╔═╡ d5d558c4-b551-45b3-9e8c-f0e0981a8bbb
memq(:apple, list(()))

# ╔═╡ 91a3201a-0458-4853-96e6-3b93647f38fc
memq(:apple, list(:pear, :banana, :prune))

# ╔═╡ cf329838-2b45-4587-8416-f7120ca714b0
memq(:banana, list(:pear, :banana, :prune))

# ╔═╡ b3a86028-7fc0-4715-a4ae-ba7d467cd280
memq(:nil, list())

# ╔═╡ ae22e237-c55e-462f-b845-956301fe53c6
memq(:nil, list(:nil))

# ╔═╡ d364a72e-de35-45ed-b475-fe7d49a66b80
memq(:nil, list(()))

# ╔═╡ 04e5a4fa-87ca-41b7-a9fe-ccb7fc10cb0e
md"
---
##### 3.3.5.2 Using (and Testing) Basic Components of the [Constraint System](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e5)
###### The Celsius-Fahrenheit-Converter
The relation $9C=5(F-32)$ expressed as a constraint network (SICP, Fig.3.28, p.287):

$\begin{array}{c|c|c|c|}
n & \text{Left} & \text{Center} & \text{Right} \\
\hline
1 & w =  9             & u = 225           & v = 45         \\
2 & C = 25             & x =   5           & y = 32         \\
3 & u = C\cdot w = 225 & v = u \div x = 45 & F = v + y = 77 \\
\hline
\end{array}$


"

# ╔═╡ f800e49d-5e2b-468d-89b2-5f11164f61a9
md"
---
###### Test of a Connector
"

# ╔═╡ aa1eb77c-7bc2-4685-82d0-44f0ffee4719
md"
---
###### Test of the Multiplier: $C \cdot w = u$
"

# ╔═╡ 22731ccd-4500-4e6f-bd86-89ccc0bf797c
md"
---
###### Test of the Multiplier: $v \cdot x = u$
"

# ╔═╡ 1cc61b9c-71e2-4bbe-b43c-2df8b7ccd0a1
md"
---
###### Test of the Adder: $v + y = F$
"

# ╔═╡ c7b7a87f-c322-4e7e-8ace-789740a6dae7
md"
---
##### 3.3.5.3 Testing the Celsius-Fahrenheit Converter

"

# ╔═╡ e58aa940-7951-45f3-bc2c-fd218c998dbe
md"
---
###### celsiusFahrenheitConverter (cf. SICP, Fig 3.28, p. 287)
"

# ╔═╡ 3a927c04-6033-4192-9260-44252e63bd76
md"
---
###### 1. Step: Initialisation of constants
"

# ╔═╡ b5b3ae86-11b5-4016-99b7-c16e77336ad6
md"""
---
###### 2. Step "Working Forward": Set Celsius C = 25
"""

# ╔═╡ 954d39d4-e141-4e7a-8242-acda2ff7a52f
md"""
---
###### 3. Step "Working Backward": Set Fahrenheit F = 212
"""

# ╔═╡ 8272a7de-8a4f-4d20-8cf9-969e4578f3ad
md"""
---
###### 4. Step "Working Backward": Forgetting Fahrenheit F = 77
"""

# ╔═╡ 9b8eaa85-5e61-4d3c-9536-f4579e6fc542
md"""
---
###### 5. Step "Working Forward": Forgetting Celsius C = 25
"""

# ╔═╡ c4a1d46e-5931-4fe8-aa35-11c767b63f7b
md"
---
##### 3.3.5.4  Implementing the Constraint System
"

# ╔═╡ 96e0bd89-4d06-4fe9-a922-f314fbfac399
md"
---
###### probe(name, connector) (SICP, p.292)
"

# ╔═╡ ce6f2f4b-8ae9-4b22-ad80-2b47aa4b6927
md"
---
###### hasValue(connector) (SICP, p. 289, p.294)
"

# ╔═╡ 3242a596-6c60-452a-b189-bea3e6c87ecb
hasValue(connector) = connector(:hasValue)

# ╔═╡ ff053448-fa8f-4a06-952d-9b117445eebf
md"
---
###### getValue(connector) (SICP, p. 289, p.294)
"

# ╔═╡ 8031b116-306b-4703-a3b5-77ef73ad4fcd
getValue(connector) = connector(:value)

# ╔═╡ f97eeeea-ba72-4f17-b7a7-c4218f00fa80
md"
---
###### setValue!(connector, newValue, informant) (SICP, p. 289, p.294)
"

# ╔═╡ 9540e540-4b9f-4eb2-ab58-04cd02667f36
setValue!(connector, newValue, informant) = 
	connector(:setValue!)(newValue, informant)

# ╔═╡ 94d007fe-bb8c-48a4-9313-25e6c42328d3
md"
---
###### forgetValue!(connector, retractor) (SICP, p. 289, p.294)
"

# ╔═╡ 2d23ac03-f0c0-4f63-973d-a2ff73559fe6
forgetValue!(connector, retractor) = 
	connector(:forget)(retractor)

# ╔═╡ 99db67d0-9b1d-4d9f-b3d6-834427a0bc9a
md"
---
###### connect(connector, newConstraint) (SICP, p. 289, p.294)
"

# ╔═╡ 54b8da7e-2a22-4f47-b137-87b0f8037104
function connect(connector, newConstraint)
	connector(:connect)(newConstraint)
end # function connect

# ╔═╡ 8826343e-cba1-4f02-99ba-37f5dca38a44
function probe(name, connector)
	#---------------------------------------------------------------------------
	function printProbe(value)
		println("probe: name = $name, value = $value")
	end # function printProbe
	#-------------------------------------------------------------------
	function processNewValue()
		printProbe(getValue(connector))
	end # function processNewValue
	#-------------------------------------------------------------------
	function processForgetValue()
		printProbe("?")
	end # function processForgetValue
	#-------------------------------------------------------------------
	function mySelf(request)
		request == :I_have_a_value  ? processNewValue() :
		request == :I_lost_my_value ? processForgetValue() :
			error("Unknown request -- PROBE, request = $request")
	end # function mySelf
	#-------------------------------------------------------------------
	connect(connector, mySelf)
	mySelf
	#---------------------------------------------------------------------------
end # function probe

# ╔═╡ 173bf5d7-2b24-4a22-a893-624f5bf89c29
md"
---
###### adder(a1, a2, sum) (SICP, p.290)
"

# ╔═╡ 54aa28e3-aa4f-4dea-b007-9048fdb62847
function adder(a1, a2, sum)
	#-------------------------------------------------------------
	function processNewValue()
		gVa1  = getValue(a1)
		gVa2  = getValue(a2)
		gVsum = getValue(sum)
		#------------------------------------------------------------------------
		if (typeof(gVa1) <: Number)      && (typeof(gVa2) <: Number)
			setValue!(sum, gVa1 + gVa2, mySelf)
		elseif (typeof(gVsum) <: Number) && (typeof(gVa1) <: Number)
			setValue!(a2, getValue(sum) - gVa1, mySelf)
		elseif (typeof(gVsum) <: Number) && (typeof(gVa2) <: Number)
			setValue!(a1, gVsum - gVa2, mySelf)
		else
		end # if
		#------------------------------------------------------------------------
	end # function processNewValue
	#-------------------------------------------------------------
	function processForgetValue()
		forgetValue!(sum, mySelf)
		forgetValue!(a1,  mySelf)
		forgetValue!(a2,  mySelf)
		processNewValue()
	end # function processforgetValue
	#-------------------------------------------------------------
	function mySelf(request)
		request == :I_have_a_value  ? processNewValue()    :
		request == :I_lost_my_value ? processForgetValue() :
			error("Unknown request -- ADDER, request = $request")
	end # function mySelf
	#-------------------------------------------------------------
	connect(a1,  mySelf)
	connect(a2,  mySelf)
	connect(sum, mySelf)
	mySelf
end # function adder

# ╔═╡ 86a43b8e-ab36-4b1c-91b8-f52ea9603e01
md"
---
###### multiplier(m1, m2, product) (SICP, p.291)
"

# ╔═╡ c1803c03-6cee-4d5a-a252-41a8c39c8cff
function multiplier(m1, m2, prod)
	#------------------------------------------------------------------
	function processNewValue()
		#--------------------------------------------------------------
		gVm1   = getValue(m1)
		gVm2   = getValue(m2)
		gVprod = getValue(prod)
		#--------------------------------------------------------------
		if  (typeof(gVm1) <: Number)      && gVm1 == 0 
			setValue!(prod, 0, mySelf)
		elseif (typeof(gVm2) <: Number)   && gVm2 == 0
			setValue!(prod, 0, mySelf)
		elseif (typeof(gVm1) <: Number)   && (typeof(gVm2) <: Number)
			setValue!(prod, gVm1 * gVm2, mySelf)
		elseif (typeof(gVprod) <: Number) && (typeof(gVm1) <: Number) 
			setValue!(m2, gVprod / gVm1, mySelf)
		elseif (typeof(gVprod) <: Number) && (typeof(gVm2) <: Number)
			setValue!(m1, gVprod / gVm2, mySelf)
		else
		end # if
	end # function processNewValue
	#------------------------------------------------------------------
	function processForgetValue()
		forgetValue!(prod, mySelf)
		forgetValue!(m1,   mySelf)
		forgetValue!(m2,   mySelf)
		processNewValue()
	end # function processforgetValue
	#------------------------------------------------------------------
	function mySelf(request)
		request == :I_have_a_value  ? processNewValue()    :
		request == :I_lost_my_value ? processForgetValue() :
			error("Unknown request -- MULTIPLIER, request = $request")
	end # function mySelf
	#------------------------------------------------------------------
	connect(m1, mySelf)
	connect(m2, mySelf)
	connect(prod, mySelf)
	mySelf
end # function multiplier

# ╔═╡ 52dad1f9-7053-4d87-9169-95cff7807d57
md"
---
###### constant(value, connector) (SICP, p.292)
"

# ╔═╡ 66586cb4-85f2-49fd-9937-a82fe3b65b5c
function constant(connector, value)       # reordered (!) arguments
	#-------------------------------------------------------------------
	function mySelf(request)
		println(error("Unknown request -- CONSTANT, request=$request"))
	end # function mySelf
	#-------------------------------------------------------------------
	connect(connector, mySelf)
	setValue!(connector, value, mySelf)
	mySelf
	#-------------------------------------------------------------------
end # function constant

# ╔═╡ e0edcf5e-156d-4d99-9ecf-ea71aff0b2ce
md"
---
##### 3.3.5.5  Representing Connectors
"

# ╔═╡ 626fbdfe-c15e-4bd6-92cf-dd652af77155
function informAboutValue(constraint) 
	constraint(:I_have_a_value)     # SICP, p.290
end # function informAboutValue

# ╔═╡ 7d177012-7ea1-48a8-b5f5-599ceebd24d5
function informAboutNoValue(constraint) 
	constraint(:I_lost_my_value)    # SICP, p.290
end # function informAboutNoValue

# ╔═╡ c71856a8-92ed-4fea-934b-3ac89b324f5e
md"
---
###### makeConnector() (SICP, p.293)
"

# ╔═╡ ddc08894-918c-4ab9-8b55-8bdc62ce1d1d
memq(()->"here", list())

# ╔═╡ 711706b5-02ca-4459-87cd-2051133d2b96
typeof(false) <: Number

# ╔═╡ d5ad5287-a6a3-4562-bdc8-ed4ac1dd6e38
md"
---
###### forEachExcept(exception, procedure, list) (SICP, p.294)
"

# ╔═╡ 1791a98b-9794-4353-8af4-9a8a331c4fdc
function forEachExcept(exception, procedure, listOfConstraints)
	#------------------------------------
	function loop(constraints)
		if null(constraints) 
			"null constraints: forEachExcept ==> done" 
		elseif car(constraints) == exception 
			loop(cdr(constraints)) 
		else
			constraint = car(constraints)
			procedure(constraint)
			loop(cdr(constraints))
		end # if
	end # function loop
	#------------------------------------
	loop(listOfConstraints)
end # function forEachExcept

# ╔═╡ 2acb1574-88ec-4b37-a5e2-69ccb6b7b04d
function makeConnector()
	let value       = false
		informant   = false
		constraints = list()
		#------------------------------------------------------------------
		function setMyValue(newVal, setter)
			if  !(hasValue(mySelf))
				value     = newVal
				informant = setter
				forEachExcept(setter, informAboutValue, constraints)
			elseif !(value == newVal)
				error("Contradiction: value = $value, newVal = $newVal")
			else
				"setMyValue ==> ignored"
			end # if
		end # function setMyValue
		#------------------------------------------------------------------
		function forgetMyValue(retractor)
			if  retractor == informant
				informant = false
				value     = false      # new (!), this was missing in SICP
				forEachExcept(retractor, informAboutNoValue, constraints)
			else
				"forgetMyValue ==> ignored, because retractor ≠ informant"
			end # if
		end # function forgetMyValue
		#-------------------------------------------------------------------
		function connect(newConstraint)
			arg = memq(newConstraint, constraints)
			if !(memq(newConstraint, constraints))
				newConstraint_constraints = cons(newConstraint, constraints)
				constraints = cons(newConstraint, constraints)
			end # if
			if hasValue(mySelf)
				informAboutValue(newConstraint)
			end # if
			"connect ==> done"
		end # function connect
		#------------------------------------------------------------------
		function mySelf(request)            # dispatch
			request == :hasValue  ? (informant !== false ? true : false) : 
			request == :value     ? (value !== false ? value : :nothing) : # new
			request == :setValue! ? setMyValue    :
			request == :forget    ? forgetMyValue :  
			request == :connect   ? connect       :
				error("Unknown operation -- CONNECTOR, request = $request")
		end # function myself
		#-------------------------------------------------------------------
		mySelf
	end # let
end # function makeConnector

# ╔═╡ dd31bab8-1270-46fc-9578-f5e282cddcf9
let C = makeConnector()
	probe("C", C, )
	C(:hasValue)                  # ==> false     -->  :)
	C(:value)                     # ==> :nothing  -->  :)
	C(:setValue!)(25, :user)
	C(:hasValue)                  # ==> true      -->  :)
	C(:value)                     # ==> 25        -->  :)
	C(:forget)(:user)             # ==> "null constraints: forEachExcept ==> done"
	C(:hasValue)                  # ==> false     -->  :)
	C(:value)                     # ==> :nothing  -->  :)
	C(:setValue!)(-15, :user)
	C(:hasValue)                  # ==> true      -->  :)
	C(:value)                     # ==> -15       -->  :)
	C(:forget)(:user)             # ==> "null constraints: forEachExcept ==> done"
	C(:value)                     # ==> :nothing  -->  :)
	constant(C, 20)               # a constant cannot be forgotten or removed
	C(:value)                     # ==> 20        -->  :)
	C(:forget)(:user)     # "forgetMyValue ==> ignored, because retractor ≠ informant"
	C(:value)                     # ==> 20        -->  :)
end # let

# ╔═╡ 9b46c41b-5763-4019-9b52-a80343dab1ee
let C = makeConnector()
	w = makeConnector()
	u = makeConnector()
	probe("C", C); probe("w", w); probe("u", u)
	multiplier(C, w, u)
	constant(w, 9)
	C(:setValue!)(25, :user)
	C(:value), w(:value), u(:value)
end # let

# ╔═╡ c9dfaa89-202c-4afc-8611-3e53c9f67311
let
	v = makeConnector()
	x = makeConnector()
	u = makeConnector()
	multiplier(v, x, u)
	probe("v", v); probe("x", x); probe("u", u)
	constant(x, 5)
	u(:setValue!)(225, :user)
	v(:value), x(:value), u(:value)
end # let

# ╔═╡ 02d1a445-7d5c-47ca-85d2-df24a731ab18
let
	v = makeConnector()
	y = makeConnector()
	F = makeConnector()
	adder(v, y, F)
	probe("v", v); probe("y", y); probe("F", F)
	constant(y, 32)
	v(:value), y(:value), F(:value)
	v(:setValue!)(45, :user)
	v(:value), y(:value), F(:value)
end # let

# ╔═╡ 326ad5aa-df56-46b5-9507-7426bc982eeb
function celsiusFahrenheitConverter(c, f)
	u = makeConnector()
	v = makeConnector()
	w = makeConnector()
	x = makeConnector()
	y = makeConnector()
	multiplier(c, w, u)
	multiplier(v, x, u)
	adder(v, y, f)
	constant(w, 9)
	constant(x, 5)
	constant(y, 32)
	probe("u", u), probe("v", v), probe("w", w), probe("x", x), probe("y", y)  
	"celsiusFahrenheitConverter ==> done"
end # function celsiusFahrenheitConverter

# ╔═╡ 5e5cf39c-7748-457d-816b-86246d570f36
let C = makeConnector(); F = makeConnector()
	probe("Celsius", C); probe("Fahrenheit", F) # ==> (mySelf, mySelf)   -->  :) 
	C(:value), F(:value)                        # ==> (nothing, nothing) -->  :)
	celsiusFahrenheitConverter(C, F) # ==> "celsiusFahrenheitConverter ==> done"
end # let

# ╔═╡ b9503dfc-d19e-49ad-abed-e8d334662936
let C = makeConnector(); F = makeConnector()
	probe("Celsius", C); probe("Fahrenheit", F) # ==> (mySelf, mySelf)   -->  :) 
	C(:value), F(:value)                        # ==> (nothing, nothing) -->  :)
	celsiusFahrenheitConverter(C, F) # ==> "celsiusFahrenheitConverter ==> done"
	setValue!(C, 25, :user)          # ==> "null constraints: forEachExcept ==> done"
end # let

# ╔═╡ 541ca1dc-fc6a-4336-b5ee-ce9dc00f8eae
let C = makeConnector(); F = makeConnector()
	probe("Celsius", C); probe("Fahrenheit", F) # ==> (mySelf, mySelf)   -->  :) 
	C(:value), F(:value)                        # ==> (nothing, nothing) -->  :)
	celsiusFahrenheitConverter(C, F) # ==> "celsiusFahrenheitConverter ==> done"
	setValue!(C,  25, :user)         # ==> "null constraints: forEachExcept ==> done"
	setValue!(F, 212, :user)         # ==> Contradiction: value = 77.0, newVal = 212
	C(:value), F(:value)
end # let

# ╔═╡ 7736248f-5dd8-45be-83d1-251e5c7d0444
let C = makeConnector(); F = makeConnector()
	probe("Celsius", C); probe("Fahrenheit", F) # ==> (mySelf, mySelf)   -->  :) 
	C(:value), F(:value)                        # ==> (nothing, nothing) -->  :)
	celsiusFahrenheitConverter(C, F) # ==> "celsiusFahrenheitConverter ==> done"
	setValue!(C,  25, :user)         # ==> "null constraints: forEachExcept ==> done"
	# setValue!(F, 212, :user)       # ==> Contradiction: value = 77.0, newVal = 212
	forgetValue!(F, :user)           # ==> ...
	# ==> "forgetMyValue ==> ignored, because retractor ≠ informant"
end # let

# ╔═╡ 7d4895bc-106a-4a87-bb1b-330a86777d68
let C = makeConnector(); F = makeConnector()
	probeNr = 0
	probe("Celsius", C); probe("Fahrenheit", F) # ==> (mySelf, mySelf)   -->  :) 
	C(:value), F(:value)                        # ==> (nothing, nothing) -->  :)
	celsiusFahrenheitConverter(C, F) # ==> "celsiusFahrenheitConverter ==> done"
	setValue!(C,  25, :user)         # ==> "null constraints: forEachExcept ==> done"
	# setValue!(F, 212, :user)       # ==> Contradiction: value = 77.0, newVal = 212
	# forgetValue!(F, :user)         # ==> ...
	forgetValue!(C, :user)           # ==> forget all values, working forward
	celsiusFahrenheitConverter(C, F)
	C(:value), F(:value)             # ==> (:nothing, :nothing) -->  :)
end # let

# ╔═╡ 07e80b0f-e7a9-4015-a442-bcd70a326b84
md"
---
##### end of Ch. 3.3.5
"

# ╔═╡ b18367e0-1785-4ecf-b383-d5a9a965dd4c
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ Cell order:
# ╟─843709b0-0b76-11ee-0c22-b7be9fa055ad
# ╟─906f42b0-02e1-4187-9723-93eb25ddff0c
# ╟─15ca1e27-c0f0-451c-9c55-8e7bf5a3d5a0
# ╠═f0ad7f8f-49db-4f29-93fd-0804eaa3bcba
# ╠═5a54a1fa-4e50-4b62-b020-59fcfee31d03
# ╠═47b3a3d1-609c-4727-8a69-7896d25b33be
# ╠═e0064cce-a035-480c-8f47-3823c4d86cd2
# ╠═5f05a88a-b389-4e19-9a16-f9c9ff418a00
# ╠═94b5abbe-af43-4a86-9f41-da83c7adf7c0
# ╟─beda16f5-29e7-4dd0-9d6b-cc5667a0260c
# ╟─dd69bf91-c644-4846-958d-a638c4687a9a
# ╟─de7d7656-598a-46f7-bdc3-b5eaeb693406
# ╟─a5dbc915-abce-4674-a33a-9014cbed390b
# ╠═65def842-3bc2-4456-8051-4cf7b0aa794f
# ╠═c43f39f2-493a-45a4-8c9a-ff8ce8b193cf
# ╠═46df5136-53d4-4c93-ace2-02ded669e34c
# ╠═55699211-b893-4a13-b131-5ea78c97d85f
# ╠═5a77e577-58af-41ba-99f3-b24f8a91061a
# ╠═374f761c-8002-4e63-ac7b-172f72d6fd03
# ╠═23509e90-b5fa-4027-b055-7da3c73566f7
# ╟─19447b8d-085c-437e-a6a0-9242c7c750d6
# ╠═b0034ffd-beee-4551-a316-4015b5f12510
# ╠═b78e4dc4-efbb-46c7-a473-397ecad489e7
# ╠═25684760-cb4c-49c0-bc89-9acf83cbef51
# ╠═8c8c241b-f859-4bab-bfe1-25c37f2c7178
# ╠═fb0179b6-1e76-472b-9c9e-83443d222379
# ╠═c87bd9f4-6f9e-4d2d-aaaa-723bfd407fa8
# ╠═6949cd4a-828b-43fe-894e-96f042e46aea
# ╠═3dd04078-cf4b-4cce-b4b2-5001a57aa2a0
# ╠═749064e0-8570-495a-9855-e7d9c0a1466c
# ╠═d5d558c4-b551-45b3-9e8c-f0e0981a8bbb
# ╠═91a3201a-0458-4853-96e6-3b93647f38fc
# ╠═cf329838-2b45-4587-8416-f7120ca714b0
# ╠═b3a86028-7fc0-4715-a4ae-ba7d467cd280
# ╠═ae22e237-c55e-462f-b845-956301fe53c6
# ╠═d364a72e-de35-45ed-b475-fe7d49a66b80
# ╟─04e5a4fa-87ca-41b7-a9fe-ccb7fc10cb0e
# ╟─f800e49d-5e2b-468d-89b2-5f11164f61a9
# ╠═dd31bab8-1270-46fc-9578-f5e282cddcf9
# ╟─aa1eb77c-7bc2-4685-82d0-44f0ffee4719
# ╠═9b46c41b-5763-4019-9b52-a80343dab1ee
# ╟─22731ccd-4500-4e6f-bd86-89ccc0bf797c
# ╠═c9dfaa89-202c-4afc-8611-3e53c9f67311
# ╟─1cc61b9c-71e2-4bbe-b43c-2df8b7ccd0a1
# ╠═02d1a445-7d5c-47ca-85d2-df24a731ab18
# ╟─c7b7a87f-c322-4e7e-8ace-789740a6dae7
# ╟─e58aa940-7951-45f3-bc2c-fd218c998dbe
# ╠═326ad5aa-df56-46b5-9507-7426bc982eeb
# ╟─3a927c04-6033-4192-9260-44252e63bd76
# ╠═5e5cf39c-7748-457d-816b-86246d570f36
# ╟─b5b3ae86-11b5-4016-99b7-c16e77336ad6
# ╠═b9503dfc-d19e-49ad-abed-e8d334662936
# ╟─954d39d4-e141-4e7a-8242-acda2ff7a52f
# ╠═541ca1dc-fc6a-4336-b5ee-ce9dc00f8eae
# ╟─8272a7de-8a4f-4d20-8cf9-969e4578f3ad
# ╠═7736248f-5dd8-45be-83d1-251e5c7d0444
# ╟─9b8eaa85-5e61-4d3c-9536-f4579e6fc542
# ╠═7d4895bc-106a-4a87-bb1b-330a86777d68
# ╟─c4a1d46e-5931-4fe8-aa35-11c767b63f7b
# ╟─96e0bd89-4d06-4fe9-a922-f314fbfac399
# ╠═8826343e-cba1-4f02-99ba-37f5dca38a44
# ╟─ce6f2f4b-8ae9-4b22-ad80-2b47aa4b6927
# ╠═3242a596-6c60-452a-b189-bea3e6c87ecb
# ╟─ff053448-fa8f-4a06-952d-9b117445eebf
# ╠═8031b116-306b-4703-a3b5-77ef73ad4fcd
# ╟─f97eeeea-ba72-4f17-b7a7-c4218f00fa80
# ╠═9540e540-4b9f-4eb2-ab58-04cd02667f36
# ╟─94d007fe-bb8c-48a4-9313-25e6c42328d3
# ╠═2d23ac03-f0c0-4f63-973d-a2ff73559fe6
# ╟─99db67d0-9b1d-4d9f-b3d6-834427a0bc9a
# ╠═54b8da7e-2a22-4f47-b137-87b0f8037104
# ╟─173bf5d7-2b24-4a22-a893-624f5bf89c29
# ╠═54aa28e3-aa4f-4dea-b007-9048fdb62847
# ╟─86a43b8e-ab36-4b1c-91b8-f52ea9603e01
# ╠═c1803c03-6cee-4d5a-a252-41a8c39c8cff
# ╟─52dad1f9-7053-4d87-9169-95cff7807d57
# ╠═66586cb4-85f2-49fd-9937-a82fe3b65b5c
# ╟─e0edcf5e-156d-4d99-9ecf-ea71aff0b2ce
# ╠═626fbdfe-c15e-4bd6-92cf-dd652af77155
# ╠═7d177012-7ea1-48a8-b5f5-599ceebd24d5
# ╟─c71856a8-92ed-4fea-934b-3ac89b324f5e
# ╠═2acb1574-88ec-4b37-a5e2-69ccb6b7b04d
# ╠═ddc08894-918c-4ab9-8b55-8bdc62ce1d1d
# ╠═711706b5-02ca-4459-87cd-2051133d2b96
# ╟─d5ad5287-a6a3-4562-bdc8-ed4ac1dd6e38
# ╠═1791a98b-9794-4353-8af4-9a8a331c4fdc
# ╟─07e80b0f-e7a9-4015-a442-bcd70a326b84
# ╟─b18367e0-1785-4ecf-b383-d5a9a965dd4c
