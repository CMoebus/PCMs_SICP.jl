### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 748d5b90-b040-11ed-0d1b-f962ab37133b
md"
====================================================================================
#### SICP: 3.3.1 [Mutable List Structure](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1)
##### file: PCM20230219\_SICP\_3.3.1\_MutableListStructure.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/02/28 ***

====================================================================================
"

# ╔═╡ 002152bc-c3d5-4622-a697-6992246b84c1
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ 1b26224f-e39b-4576-aef3-8c2ca50e3c2c
md"
###### Constructor
"

# ╔═╡ bd62ca5c-23d3-4a1f-844d-7280a79aadf8
mutable struct Cons # 'mutable' is dangerous ! 
	car
	cdr
end # struct Cons

# ╔═╡ 73db0581-5f6a-41de-9740-4f143fc5826c
cons(car, cdr) = Cons(car, cdr)

# ╔═╡ 16a5a470-3cb4-4a86-947d-2bb82ebd1f2d
md"
###### Selectors
"

# ╔═╡ 8ba44863-2554-4e62-916d-0a4f1691d67b
car(cons::Cons) = cons.car

# ╔═╡ 7178c3ce-411a-44d4-9d19-948fa0f87c84
cdr(cons::Cons) = cons.cdr

# ╔═╡ 958f5314-8e9f-4ae6-b8ab-1bf9b89fab7a
# this method pretty-prints a latent hierarchical cons-structure as a nested 
#    tuple structure which has similarity with a Lisp- or Scheme-list
#    also used in ch.2.2.2
function pp(consList)
	#-------------------------------------------------------------------------------
	function pp_iter(arrayList, shortList)
		# termination cases
		if shortList == :nil
			arrayList
		elseif car(shortList) == :nil && cdr(shortList) == :nil
			arrayList
		# one-element list
		elseif (typeof(car(shortList)) <: Atom) && (cdr(shortList) == :nil)
			push!(arrayList, car(shortList)) 
		# => new !
		elseif (typeof(car(shortList)) <: Atom) && (typeof(cdr(shortList)) <: Atom) 
			(car(shortList), cdr(shortList))  
		# flat multi-element list
		elseif (typeof(car(shortList)) <: Atom) && (typeof(cdr(shortList)) <: Cons)
			pp_iter(push!(arrayList, car(shortList)), cdr(shortList))
		# nested sublist as last element of multi-element list
		elseif (typeof(car(shortList)) <: Cons) && (cdr(shortList) == :nil)
			pp_iter(push!(arrayList, pp(car(shortList))), cdr(shortList))
		# nested sublist as first element of multi-element list
		elseif (typeof(car(shortList)) <: Cons) && (typeof(cdr(shortList)) <: Cons)
			pp_iter(push!(arrayList, pp(car(shortList))), cdr(shortList))
		else
			error("==> unknown case")
		end # if
	end # pp_iter
	#-------------------------------------------------------------------------------
	Tuple(pp_iter([], consList))      # converts array to tuple
end

# ╔═╡ 64a572cf-a84c-4730-b1e3-96a592df7db0
md"
###### Modifier
"

# ╔═╡ 017e8090-9c40-4dba-a851-1cc939f79b85
function setCar!(cons::Cons, car) 
	cons.car = car
	cons
end # setCar!

# ╔═╡ 571a9137-1eeb-4c01-af51-27d11ca4c503
function setCdr!(cons::Cons, cdr) 
	cons.cdr = cdr
	cons
end # setCdr!

# ╔═╡ 34d785d5-feb7-4c5f-ad0e-649c38a6e972
md"
---
Mutation is a dangerous concept, especially in combination with *Pluto*. Pluto is a *reactive* notebook. That means that all instances of a variable in diverse places (cells) are constrained to have the *same* value. The consequence is that *all* instances get the *latest* binding. So the history of bindings shrinks to the *latest* one. To avoid this effect we embed mutations in a $let\; x=... y=... set...end$-expression, so bindings are *local*.
"

# ╔═╡ 963528f4-2b12-4a92-9a0f-f80d0679265c
md"
---
###### Start configuration
(cf. [**Fig. 3.12**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
In *Julia* a call of our function 'cons' evaluates to the *structure* 'Cons'.

*Scheme*-list: 

$x:= (((a\;b)\centerdot(c\;d))=((a\;b)\;c\;d)$
$y:= (e\;f)$

*Julia*-structure:

$x := Cons(Cons(:a, Cons(:b, :nil)), Cons(:c, Cons(:d, :nil)))$
$y := Cons(:e, Cons(:f, :nil))$

$pp(x) \Rightarrow ((:a, :b), :c, :d)$
$pp(y) \Rightarrow (:e, :f)$

"

# ╔═╡ 9a9811a1-daef-47dc-8d4d-022df37659c5
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil))) 
end # let

# ╔═╡ 5be8288e-c6a8-479f-b712-794967a33b01
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil))) 
	pp(x)
end # let

# ╔═╡ 5e440043-b740-4fc1-962e-9818d9779a4a
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil))) 
	y = cons(:e, cons(:f, :nil)) 
end # let

# ╔═╡ 1cfd56e2-0f36-4f4e-939d-bdb0ebb270da
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil))) 
	y = cons(:e, cons(:f, :nil)) 
	pp(y)
end # let

# ╔═╡ 74f35c1e-bc32-4a33-a4f8-f9193e189701
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	x, y
end # let

# ╔═╡ c225c596-45e3-4dba-ae85-1e2c6f104069
let # this one layer on top of x and y (s.a. Fig. 3.12, SICP, 1996, p.253)
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	cons(x, y)
end # let

# ╔═╡ 21baa558-7ff6-4c87-8a72-8afd03974dbf
let # this one layer on top of x and y (s.a. Fig. 3.12, SICP, 1996, p.253)
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	pp(cons(x, y))
end # let

# ╔═╡ 0278613d-f097-4a27-949f-d04bd38523e5
pp(cons(:a, :b)) 

# ╔═╡ 8bf38dfa-266b-4d18-a3b1-2ac2882344fd
Tuple((:a, :b))

# ╔═╡ b03a3591-63d9-44e2-a3c8-38fa8eb164d3
md"
---
###### *Mutating* Application $x2 = setCar!(x, y)$:
(cf. [**Fig. 3.13**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996).

Scheme (*before* mutation):

$x := (a\;b)\centerdot(c\;d))=((a\;b)\;c\;d)$
$y := (e\;f)$

Scheme (*after* mutation):

$x := (set\text{-}car! \; x \; y) = ((e\;f)\centerdot(c\;d))=((e\;f)\;c\;d)$
$y := (e\;f)$

Julia (*before* mutation):

$x := Cons(Cons(:a, Cons(:b, :nil)), Cons(:c, Cons(:d, :nil)))$
$y := Cons(:e, Cons(:f, :nil))$

$pp(x) \Rightarrow ((:a, :b), :c, :d)$
$pp(y) \Rightarrow (:e, :f)$

Julia (*after* mutation):

$x = setCar!(x, y) = Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))$
$y = Cons(:e, Cons(:f, :nil))$

$pp(x) \Rightarrow ((:e, :f), :c, :d)$
$pp(y) \Rightarrow (:e, :f)$

Julia's $Cons(:a, Cons(:b, :nil))$ is now garbage.

"

# ╔═╡ c7f5e87b-7363-4ecf-b7fe-874d1eec7fda
md"
---
###### *Non*mutating Application $z = cons(x, cdr(y))$:
(cf. [**Fig. 3.14**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)

*Scheme*:

$x:= (((a\;b)\centerdot(c\;d))=((a\;b)\;c\;d)$
$y:= (e\;f)$
$z = cons(y, cdr(x)) = ((e\;f)\centerdot(c\;d)) = ((e\;f)\;c\;d)$

*Julia*:

$x = Cons(Cons(:a, Cons(:b, :nil)), Cons(:c, Cons(:d, :nil)))$
$y = Cons(:e, Cons(:f, :nil))$

$pp(x) \Rightarrow ((:a, :b), :c, :d)$
$pp(y) \Rightarrow (:e, :f)$

$z = cons(y, cdr(x)) = Cons(Cons(:e,Cons(:f,:nil)), Cons(Cons(:c,Cons(:d,:nil))))$
$pp(z) \Rightarrow ((:e, :f), :c, :d)$

"

# ╔═╡ 5ba1029e-1c86-4c61-901e-4229dd501e8f
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))
	z = cons(y, cdr(x))
end # let

# ╔═╡ 7283b7db-c4cf-4ef1-87ea-1cb6fe3c029d
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))
	z = cons(y, cdr(x))
	pp(z)
end # let

# ╔═╡ 5b03f41b-7833-4001-ba61-7f26b0b10bc3
md"
---
###### *Mutating* Application $setCdr!(x, y)$
(cf. [**Fig. 3.15**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)

Scheme (*before* mutation):

$x := (((a\;b)\centerdot(c\;d))=((a\;b)\;c\;d)$
$y := (e\;f)$

Scheme (*after* mutation): 

$x := (setCdr!\;x,\; y) = ((a\;b)\centerdot(e\;f))=((a\;b)\;e\;f)$

Julia (*before* mutation):

$x = Cons(Cons(:a, Cons(:b, :nil)), Cons(:c, Cons(:d, :nil)))$
$y = Cons(:e, Cons(:f, :nil))$

$pp(x) \Rightarrow ((:a, :b), :c, :d)$
$pp(y) \Rightarrow (:e, :f)$

Julia (*after* mutation):

$x = setCdr!(x, y) = ...$
$... = Cons(Cons(:a,Cons(:b,:nil)), Cons(Cons(:e,Cons(:f,:nil))))$
$pp(x) \Rightarrow ((:a, :b), :e, :f)$
$pp(y) \Rightarrow (:e, :f)$

"

# ╔═╡ 524590ef-079a-47c4-8c36-dc9897a8c340
md"
---
###### Implementing cons in terms of two mutators $setCar!$ and $setCdr!$
"

# ╔═╡ c8d27bd2-fe57-44f5-89b8-1df77ccad610
md"
---
##### Sharing and Identity
"

# ╔═╡ 3f94dfb1-7898-4b43-9a63-24c8e3aefdde
# taken from ch. 2.2.1
list(elements...) = 
	if ==(elements, ())
		cons(:nil, :nil)
	elseif ==(lastindex(elements), 1)
		cons(elements[1], :nil)
	else
		cons(elements[1], list(elements[2:end]...))
	end #if

# ╔═╡ e5bb0a44-3cba-401e-a43d-5de6b7495369
md"
---
###### *Sharing* of individual pairs among *different* data objects
(cf. [**Fig. 3.16**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ 386563cc-1c7b-4896-92c6-482aa289842c
md"
---
*Scheme*: 

$x := (list\;\; 'a\;\; 'b) = (cons\; 'a\; (cons\; 'b\; nil)) \Rightarrow (a\;b)$
$z1 := (cons\;x\;x) = ((a\;b)\centerdot(a\;b)) = ((a\;b)\;a\;b)$

*Julia*:

$x = list(:a,\;:b) = Cons(:a,\; Cons(:b,\;:nil))$
$z1 = cons(x, x) = Cons(Cons(:a, Cons(:b, :nil)), Cons(:a, Cons(:b, :nil)))$
"

# ╔═╡ 97a30de2-7eda-41e0-83ed-cf78c11668a3
let 
	x = list(:a, :b)
  	pp(x)
end # let

# ╔═╡ 2b4c9532-0b08-4bdf-a865-4b0e59965d07
let 
	x = list(:a, :b)
	z1 = cons(x, x)
end # let

# ╔═╡ 2e839c16-d0de-4b8b-bd7d-0d9f6b324053
let 
	x = list(:a, :b)
	z1 = cons(x, x)
  	pp(z1)
end # let

# ╔═╡ 1dc3e03a-8361-45f4-bffd-bad162dc1ff4
let 
	x = list(:a, :b)
	z1 = cons(x, x)
	z1, z1.car == z1.cdr ? 
		"==> pair sharing    --> :)" : 
		"==> pair diversity  --> :("
end # let

# ╔═╡ 42d35aa7-8958-43b1-b70e-80a388ac5e62
md"
---
###### *Non*sharing of *Pairs* but *Sharing* of individual *Symbols* 
(cf. [**Fig. 3.17**](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e1), SICP, 1996)
"

# ╔═╡ 68759b9d-e392-40f6-b5b8-eccba62d7331
md"
*Scheme*:

$(list\;\; 'a\;\; 'b) = (cons\; 'a\; (cons\; 'b\; nil)) \Rightarrow (a\;b)$
$z2 = (cons (list\;'a\;'b)\; (list\;'a\;'b)) = (('a\;'b)\centerdot('b\;'c))=(('a\;'b)\;'b\;'c)$



*Julia*:

$list(:a,\;:b) = Cons(:a,\; Cons(:b,\;:nil))$
$z2 = cons(list(:a, :b), list(:a, :b)) =...$
$...= Cons(Cons(:a, Cons(:b, :nil)), Cons(:a, Cons(:b,:nil)))$

$pp(z2) \Rightarrow ((:ab, :b), ;a, :b)$
"

# ╔═╡ 25853a74-9d7c-46ca-9a5d-a070f8264025
let 
	x = list(:a, :b)
	z2 = cons(list(:a, :b), list(:a, :b))
	pp(z2)
end # let

# ╔═╡ 2646bd67-d99a-438e-94d6-df5357876ea0
let 
	x = list(:a, :b)
	z2 = cons(list(:a, :b), list(:a, :b))
	z2, z2.car == z2.cdr ? "==> sharing of pairs :)" : "==> nonsharing of pairs :("
end # let

# ╔═╡ f49f88ff-b434-479e-ad0a-0b1009c09d7f
md"
---
###### Mutation of lists with *shared* and *non*shared pairs (= cons- or Cons-cells)  by $setToWow!$
"

# ╔═╡ 7dae5653-87f3-4961-aa15-14608dde8eea
md"
---
###### Mutation of lists with *shared* pairs by $setToWow!(z1)$

*Scheme*: 

$x := (list\;\; 'a\;\; 'b) = (cons\; 'a\; (cons\; 'b\; nil)) \Rightarrow (a\;b)$
$z1 := (cons\;x\;x) = ((a\;b)\centerdot(a\;b)) = ((a\;b)\;a\;b)$
$(seToWow!\;z1) := ((wow\;b).(wow\;b)) = ((wow\;b)\;wow\;b)$

*Julia*:

$x = list(:a,\;:b) = Cons(:a,\; Cons(:b,\;:nil))$
$z1 = cons(x, x) = Cons(Cons(:a, Cons(:b, :nil)), Cons(:a, Cons(:b, :nil)))$
$setToWow!(z1) = Cons(Cons(:wow, Cons(:b, :nil)), Cons(:wow, Cons(:b, :nil)))$

$pp(z1) \Rightarrow ((:wow, :b), :wow, :b)$

"

# ╔═╡ ee731a0d-79c8-43cb-8120-62d482f8fb5d
md"
---
###### Mutation of lists with *non*shared pairs with $setToWow!(z2)$

*Scheme*: 

$x := (list\;\; 'a\;\; 'b) = (cons\; 'a\; (cons\; 'b\; nil)) \Rightarrow (a\;b)$
$z2 := (cons\;(list\;\; 'a\;\; 'b)\;(list\;\; 'a\;\; 'b)) = ((a\;b)\centerdot(a\;b)) = ((a\;b)\;a\;b)$
$(seToWow!\;z2) := ((wow\;b).(a\;b)) = ((wow\;b)\;a\;b)$

*Julia*:

$x = list(:a,\;:b) = Cons(:a,\; Cons(:b,\;:nil))$
$z2 = Cons(Cons(:a, Cons(:b, :nil)), Cons(:a, Cons(:b, :nil)))$
$setToWow!(z2) = Cons(Cons(:wow, Cons(:b, :nil)), Cons(:a, Cons(:b, :nil)))$

$z2 \Rightarrow ((:wow, :b), :a, :b)$
"

# ╔═╡ 4e7e9954-b411-4ef9-b7e0-d5a2f8999543
md"
---
##### Mutation is just Assignment
"

# ╔═╡ faed53ac-758f-43fe-880c-42d1c0a89868
md"
###### *Pairs* as Procedures
"

# ╔═╡ 18df98a6-8e77-48a4-bbd3-37ad9b0d3a45
# taken from ch. 2.1.3
#------------------------------------------------------
function cons2(car, cdr)
	function dispatch(message)
		message == :car ? car :
		message == :cdr ? cdr :
		error("Undefined operation -- CONS: $message")
	end # function dispatch
	dispatch
end # function

# ╔═╡ 9843d588-5380-4afc-9205-6830219baa9c
car2(z) = z(:car)

# ╔═╡ f03e600f-35db-4169-92bd-1b790e19cdda
cdr2(z) = z(:cdr)

# ╔═╡ 51fbca79-96dd-4989-be41-ce03b3140064
md"
---
"

# ╔═╡ 51368535-faf8-4f19-97e0-0f900e21ae17
cellAC = cons2(:a, :c)     

# ╔═╡ 954103a0-7018-425d-8c79-bb58fd3e81de
md"
###### OO-Message-Passing similar to *Smalltalk* or *[Pharo](https://files.pharo.org/media/pharoCheatSheet.pdf)*
(s.a. [pharoCheatSheet](https://files.pharo.org/media/pharoCheatSheet.pdf))
"

# ╔═╡ 0308b76f-0823-4092-91e9-8655d4207afa
cellAC(:car) == :a               # ==> true -->  :)

# ╔═╡ e5ea6b19-2c73-48db-84ad-d42e51a64a32
cellAC(:cdr) == :c               # ==> true -->  :)

# ╔═╡ 6c520987-adeb-47b8-ae9a-bd24cfec0d61
let 
	z = cons2(1, 3)
end # let

# ╔═╡ 86a20838-3feb-4acc-bcf4-4b61aa0b28dc
let 
	z = cons2(1, 3)
	z(:car)
end # let

# ╔═╡ 4668c2e4-25ce-477f-9178-bec3e6d39c75
let 
	z = cons2(1, 3)
	z(:cdr)
end # let

# ╔═╡ 4862d998-eb91-4067-8429-5c8a6f53ca60
md"
---
###### *Mutable Data Objects* as Procedures
"

# ╔═╡ 39a6a94b-9af5-427c-8c06-cd86a6b960f4
function cons3(car, cdr)  
	#--------------------------------------------------
	function setCar!(newCar)
		car = newCar
	end # function setCar!
	#--------------------------------------------------
	function setCdr!(value)
		cdr = newCdr
	end # function setCdr!
	#--------------------------------------------------
	function dispatch(message)
		message == :car     ?     car :
		message == :cdr     ?     cdr :
		message == :setCar! ? setCar! :
		message == :setCdr! ? setCdr! :
		error("Undefined operation -- CONS: $message")
	end # function dispatch
	#--------------------------------------------------
	dispatch # closure with free variables car, cdr, setCar!, setCdr!
end # function cons3

# ╔═╡ 7ea9af63-81c0-4fc0-a524-bd90c2ed4746
car3(z) = z(:car)

# ╔═╡ ea967c82-7dc5-4586-908b-1345978ba69e
cdr3(z) = z(:cdr)

# ╔═╡ a6861e42-d98e-43ab-a431-f3588f64afc5
# 2nd (!) method; the 1st needed as 1st parm a 'Cons'
function setCar!(z, newCar) 
	z(:setCar!)(newCar)
	z
end # function setCar!

# ╔═╡ 70532e8c-ba7e-4163-bc65-a18cccac23ff
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))
	setCar!(x, y)
end # let

# ╔═╡ e7ceb1c9-8a8c-4fe5-bf7a-3cb26774092b
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))
	setCar!(x, y)
	pp(x)
end # let

# ╔═╡ 8ca38746-0505-4ede-93c6-85ab8ad8593c
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:e, Cons(:f, :nil)), Cons(:c, Cons(:d, :nil)))
	setCar!(x, y)
	pp(y)    # ==> (:e, :f) --> untouched! -->  :)
end # let

# ╔═╡ 7d08280b-db84-480f-9a22-99724d08e66a
function setToWow!(x)
	setCar!(car(x), :wow)
	x
end # function setToWow!

# ╔═╡ ddec30d5-52fa-4267-9736-6b2c523a47ba
let 
	x = list(:a, :b)
	z1 = cons(x, x)
	setToWow!(z1)
end # let

# ╔═╡ ab7f7376-9b90-407d-92e2-f9c5b66e9dcf
let 
	x = list(:a, :b)
	z1 = cons(x, x)
	setToWow!(z1)
	pp(z1)
end # let

# ╔═╡ 095473d1-c4db-44c0-8159-f5cc04bcf801
let 
	x = list(:a, :b)
	z2 = cons(list(:a, :b), list(:a, :b))
	setToWow!(z2)
end # let

# ╔═╡ ee12a2ee-2205-4704-86f5-6572f33eff7d
let 
	x = list(:a, :b)
	z2 = cons(list(:a, :b), list(:a, :b))
	setToWow!(z2)
	pp(z2)
end # let

# ╔═╡ f380d122-c359-491f-8c5e-992f8ab80c21
# 2nd (!) method; the 1st needed as 1st parm a 'Cons'
function setCdr!(z, newCdr) 
	z(:setCdr!)(newCdr)
	z
end # function setCdr!

# ╔═╡ 28941107-d0ea-4c32-8bb3-1b822190f68a
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:e, Cons(:f, :nil)))
	setCdr!(x, y)
end # let

# ╔═╡ 10a80314-132b-4f54-8281-a9c59d57b914
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:e, Cons(:f, :nil)))
	setCdr!(x, y)
	pp(x)
end # let

# ╔═╡ 444b05e5-48b5-4d14-834c-2c8299e2ec11
let 
	x = cons(cons(:a, cons(:b, :nil)), cons(:c, cons(:d, :nil)))
	y = cons(:e, cons(:f, :nil)) 
	# ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:e, Cons(:f, :nil)))
	setCdr!(x, y)
	pp(y)                  #  ==> (;e, :f) --> untouched -- :)
end # let

# ╔═╡ c6d01f37-03ab-42be-b757-5ce9fc350aa6
function consWithMutators(car, cdr)
	let 
		new = Cons(nothing, nothing)
		setCar!(new, car)
		setCdr!(new, cdr)
	end # let
end # function consWithMutators

# ╔═╡ 7a88fbb8-9684-4d5d-a5f4-d0d7706b489f
z11 = consWithMutators(:c, :d)

# ╔═╡ b5af832f-d7f9-4d45-a3ee-5436090db99f
pp(z11)

# ╔═╡ 1f989823-7642-4a07-b2fa-8faa0a3da325
z11.car

# ╔═╡ 9caa69ae-be37-48dd-850a-6ea1d41e8dd6
z11.cdr

# ╔═╡ 4915ce5e-a46d-4246-a3d7-16ff01cbc531
md"
---
###### Selection in Scheme-lists $x := ((a\; b)\; c\; d)$ and $y := (e\; f)$
(cf. **Fig. 3.12**, SICP, 1996)
"

# ╔═╡ 1379f90c-0e0c-482c-a507-a2fac0170b7a
# *replication* of x but *here with* 'cons3'
# built as a nested 'Cons'-structure (big 'C') !
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
end # let

# ╔═╡ 8af591d3-b18c-494b-b439-1f89a3423d41
let                           
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:car) # ==> Cons(:a, Cons(:b, :nil))let
end # let 

# ╔═╡ 512a19f1-0842-4a4e-9e87-a3122bf5efba
let                           
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:car)                            # ==> Cons(:a, Cons(:b, :nil))let
	x(:car)(:car) == :a                # ==> true -->    :)
end # let 

# ╔═╡ e544bfa0-a8cf-48d5-aa2d-1b66ded12087
let                           
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:car)                            # ==> Cons(:a, Cons(:b, :nil))let
	x(:car)(:car) == :a                # ==> true -->    :)
	x(:car)(:cdr)(:car) == :b          # ==> true -->    :)
end # let 

# ╔═╡ 3e61e457-dc30-41e6-9454-a7d28e8a0f65
let                           
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:car)                            # ==> Cons(:a, Cons(:b, :nil))let
	x(:car)(:car) == :a                # ==> true -->    :)
	x(:car)(:cdr)(:car) == :b          # ==> true -->    :)
	x(:cdr)(:car) == :c                # ==> true -->    :)
end # let 

# ╔═╡ dab33c0b-aeed-4187-b867-0d870c24e69d
let                           
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:car)                            # ==> Cons(:a, Cons(:b, :nil))
	x(:car)(:car) == :a                # ==> true -->    :)
	x(:car)(:cdr)(:car) == :b          # ==> true -->    :)
	x(:cdr)(:car) == :c                # ==> true -->    :)
	x(:cdr)(:cdr)(:car) == :d          # ==> true -->    :)
end # let 

# ╔═╡ cb629a58-d93a-48c3-a1a6-786975283490
let                           
	y = cons3(:e, cons3(:f, :nil))     # ==> Cons(:e, Cons(:f, :nil))
end # let 

# ╔═╡ e7570fd4-7c7a-4963-b98e-4869f26ab9e3
let                           
	y = cons3(:e, cons3(:f, :nil))     # ==> Cons(:e, Cons(:f, :nil))
	y(:car) == :e                      # ==> true -->    :)   
end # let 

# ╔═╡ cbe705f3-1853-4514-9708-d2fdb7c69802
let                           
	y = cons3(:e, cons3(:f, :nil))     # ==> Cons(:e, Cons(:f, :nil))
	y(:car) == :e                      # ==> true -->    :)   
	y(:cdr)(:car) == :f                # ==> true -->    :) 
end # let 

# ╔═╡ 3c02de21-2a3f-4796-bb50-be473c07403e
md"
---
###### Mutation by $setCar!(x, y)$
(**Fig.3.13**, SICP, 1996)

Scheme (*before* mutation):

$x:= ((a\; b)\;(c\; d))$
$y:= (e\; f)$

Scheme (*after* mutation):

$x:= (setCar!\; x\; y) := ((e\; f)\;(c\; d))$

Julia (*before* mutation):

$x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil)))$

Julia (*after* mutation):

$x := x(:setCar!)(y):=cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))$

"

# ╔═╡ a93cdd9a-dd61-4801-8967-901a8e5ebae9
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)  
end # let

# ╔═╡ 0f9a5602-4cd5-4205-9d2b-5cbc3f96275f
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
end # let

# ╔═╡ 5fc53445-cb49-417f-9e4d-fc951366c23c
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
	x(:car)(:car) == :e         # ==> true  -->  :)
end # let

# ╔═╡ b0fa1f1e-bac5-401d-b52e-3e8771a7dfe7
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
	x(:car)(:car) == :e         # ==> true  -->  :)
	x(:car)(:cdr)(:car) == :f   # ==> true  -->  :)
end # let

# ╔═╡ 7cc03a60-3f21-4375-abb2-5810e6e71942
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
	x(:car)(:car) == :e         # ==> true  -->  :)
	x(:car)(:cdr)(:car) == :f   # ==> true  -->  :)
	x(:cdr)                     # ==> cons3(:c, cons3(:d, :nil))
end # let

# ╔═╡ 3767c9c6-51a6-44ef-b943-e7368c9144b5
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
	x(:car)(:car) == :e         # ==> true  -->  :)
	x(:car)(:cdr)(:car) == :f   # ==> true  -->  :)
	x(:cdr)                     # ==> cons3(:c, cons3(:d, :nil))
	x(:cdr)(:car) == :c         # ==> true  -->  :)
end # let

# ╔═╡ 832a435d-9582-4bdc-bc75-a8cbb53366e1
let
	x = cons3(cons3(:a, cons3(:b, :nil)), cons3(:c, cons3(:d, :nil))) 
	y = cons3(:e, cons3(:f, :nil))
	# ==> cons3(cons3(:e, cons3(:f, :nil)), cons3(:c, cons3(:d, :nil)))
	x(:setCar!)(y)
	x(:car)                     # ==> cons3(:e, cons3(:f, :nil))
	x(:car)(:car) == :e         # ==> true  -->  :)
	x(:car)(:cdr)(:car) == :f   # ==> true  -->  :)
	x(:cdr)                     # ==> cons3(:c, cons3(:d, :nil))
	x(:cdr)(:car) == :c         # ==> true  -->  :)
	x(:cdr)(:cdr)(:car) == :d  # ==> true  -->  :)
end # let

# ╔═╡ 87b28792-10b8-4ec3-b8dd-638b01fa0aa5
md"
---
##### References
- **pharoCheatSheet**; [https://files.pharo.org/media/pharoCheatSheet.pdf}(https://files.pharo.org/media/pharoCheatSheet.pdf) last visit 2023/02/26.
"

# ╔═╡ f24a3af4-a34e-4d44-96c8-13654e5c2db8
md"
---
##### end of ch. 3.3.1
"

# ╔═╡ 56d08cbd-8a11-4c07-98c3-6c5f83704c3b
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

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─748d5b90-b040-11ed-0d1b-f962ab37133b
# ╠═002152bc-c3d5-4622-a697-6992246b84c1
# ╠═958f5314-8e9f-4ae6-b8ab-1bf9b89fab7a
# ╟─1b26224f-e39b-4576-aef3-8c2ca50e3c2c
# ╠═bd62ca5c-23d3-4a1f-844d-7280a79aadf8
# ╠═73db0581-5f6a-41de-9740-4f143fc5826c
# ╟─16a5a470-3cb4-4a86-947d-2bb82ebd1f2d
# ╠═8ba44863-2554-4e62-916d-0a4f1691d67b
# ╠═7178c3ce-411a-44d4-9d19-948fa0f87c84
# ╟─64a572cf-a84c-4730-b1e3-96a592df7db0
# ╠═017e8090-9c40-4dba-a851-1cc939f79b85
# ╠═571a9137-1eeb-4c01-af51-27d11ca4c503
# ╟─34d785d5-feb7-4c5f-ad0e-649c38a6e972
# ╟─963528f4-2b12-4a92-9a0f-f80d0679265c
# ╠═9a9811a1-daef-47dc-8d4d-022df37659c5
# ╠═5be8288e-c6a8-479f-b712-794967a33b01
# ╠═5e440043-b740-4fc1-962e-9818d9779a4a
# ╠═1cfd56e2-0f36-4f4e-939d-bdb0ebb270da
# ╠═74f35c1e-bc32-4a33-a4f8-f9193e189701
# ╠═c225c596-45e3-4dba-ae85-1e2c6f104069
# ╠═21baa558-7ff6-4c87-8a72-8afd03974dbf
# ╠═0278613d-f097-4a27-949f-d04bd38523e5
# ╠═8bf38dfa-266b-4d18-a3b1-2ac2882344fd
# ╟─b03a3591-63d9-44e2-a3c8-38fa8eb164d3
# ╠═70532e8c-ba7e-4163-bc65-a18cccac23ff
# ╠═e7ceb1c9-8a8c-4fe5-bf7a-3cb26774092b
# ╠═8ca38746-0505-4ede-93c6-85ab8ad8593c
# ╟─c7f5e87b-7363-4ecf-b7fe-874d1eec7fda
# ╠═5ba1029e-1c86-4c61-901e-4229dd501e8f
# ╠═7283b7db-c4cf-4ef1-87ea-1cb6fe3c029d
# ╟─5b03f41b-7833-4001-ba61-7f26b0b10bc3
# ╠═28941107-d0ea-4c32-8bb3-1b822190f68a
# ╠═10a80314-132b-4f54-8281-a9c59d57b914
# ╠═444b05e5-48b5-4d14-834c-2c8299e2ec11
# ╟─524590ef-079a-47c4-8c36-dc9897a8c340
# ╠═c6d01f37-03ab-42be-b757-5ce9fc350aa6
# ╠═7a88fbb8-9684-4d5d-a5f4-d0d7706b489f
# ╠═b5af832f-d7f9-4d45-a3ee-5436090db99f
# ╠═1f989823-7642-4a07-b2fa-8faa0a3da325
# ╠═9caa69ae-be37-48dd-850a-6ea1d41e8dd6
# ╟─c8d27bd2-fe57-44f5-89b8-1df77ccad610
# ╠═3f94dfb1-7898-4b43-9a63-24c8e3aefdde
# ╟─e5bb0a44-3cba-401e-a43d-5de6b7495369
# ╟─386563cc-1c7b-4896-92c6-482aa289842c
# ╠═97a30de2-7eda-41e0-83ed-cf78c11668a3
# ╠═2b4c9532-0b08-4bdf-a865-4b0e59965d07
# ╠═2e839c16-d0de-4b8b-bd7d-0d9f6b324053
# ╠═1dc3e03a-8361-45f4-bffd-bad162dc1ff4
# ╟─42d35aa7-8958-43b1-b70e-80a388ac5e62
# ╟─68759b9d-e392-40f6-b5b8-eccba62d7331
# ╠═25853a74-9d7c-46ca-9a5d-a070f8264025
# ╠═2646bd67-d99a-438e-94d6-df5357876ea0
# ╟─f49f88ff-b434-479e-ad0a-0b1009c09d7f
# ╠═7d08280b-db84-480f-9a22-99724d08e66a
# ╟─7dae5653-87f3-4961-aa15-14608dde8eea
# ╠═ddec30d5-52fa-4267-9736-6b2c523a47ba
# ╠═ab7f7376-9b90-407d-92e2-f9c5b66e9dcf
# ╟─ee731a0d-79c8-43cb-8120-62d482f8fb5d
# ╠═095473d1-c4db-44c0-8159-f5cc04bcf801
# ╠═ee12a2ee-2205-4704-86f5-6572f33eff7d
# ╟─4e7e9954-b411-4ef9-b7e0-d5a2f8999543
# ╟─faed53ac-758f-43fe-880c-42d1c0a89868
# ╠═18df98a6-8e77-48a4-bbd3-37ad9b0d3a45
# ╠═9843d588-5380-4afc-9205-6830219baa9c
# ╠═f03e600f-35db-4169-92bd-1b790e19cdda
# ╟─51fbca79-96dd-4989-be41-ce03b3140064
# ╠═51368535-faf8-4f19-97e0-0f900e21ae17
# ╟─954103a0-7018-425d-8c79-bb58fd3e81de
# ╠═0308b76f-0823-4092-91e9-8655d4207afa
# ╠═e5ea6b19-2c73-48db-84ad-d42e51a64a32
# ╠═6c520987-adeb-47b8-ae9a-bd24cfec0d61
# ╠═86a20838-3feb-4acc-bcf4-4b61aa0b28dc
# ╠═4668c2e4-25ce-477f-9178-bec3e6d39c75
# ╟─4862d998-eb91-4067-8429-5c8a6f53ca60
# ╠═39a6a94b-9af5-427c-8c06-cd86a6b960f4
# ╠═7ea9af63-81c0-4fc0-a524-bd90c2ed4746
# ╠═ea967c82-7dc5-4586-908b-1345978ba69e
# ╠═a6861e42-d98e-43ab-a431-f3588f64afc5
# ╠═f380d122-c359-491f-8c5e-992f8ab80c21
# ╟─4915ce5e-a46d-4246-a3d7-16ff01cbc531
# ╠═1379f90c-0e0c-482c-a507-a2fac0170b7a
# ╠═8af591d3-b18c-494b-b439-1f89a3423d41
# ╠═512a19f1-0842-4a4e-9e87-a3122bf5efba
# ╠═e544bfa0-a8cf-48d5-aa2d-1b66ded12087
# ╠═3e61e457-dc30-41e6-9454-a7d28e8a0f65
# ╠═dab33c0b-aeed-4187-b867-0d870c24e69d
# ╠═cb629a58-d93a-48c3-a1a6-786975283490
# ╠═e7570fd4-7c7a-4963-b98e-4869f26ab9e3
# ╠═cbe705f3-1853-4514-9708-d2fdb7c69802
# ╟─3c02de21-2a3f-4796-bb50-be473c07403e
# ╠═a93cdd9a-dd61-4801-8967-901a8e5ebae9
# ╠═0f9a5602-4cd5-4205-9d2b-5cbc3f96275f
# ╠═5fc53445-cb49-417f-9e4d-fc951366c23c
# ╠═b0fa1f1e-bac5-401d-b52e-3e8771a7dfe7
# ╠═7cc03a60-3f21-4375-abb2-5810e6e71942
# ╠═3767c9c6-51a6-44ef-b943-e7368c9144b5
# ╠═832a435d-9582-4bdc-bc75-a8cbb53366e1
# ╟─87b28792-10b8-4ec3-b8dd-638b01fa0aa5
# ╟─f24a3af4-a34e-4d44-96c8-13654e5c2db8
# ╟─56d08cbd-8a11-4c07-98c3-6c5f83704c3b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
