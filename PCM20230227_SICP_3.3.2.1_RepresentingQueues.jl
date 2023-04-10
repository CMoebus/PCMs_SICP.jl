### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ c74486e0-b696-11ed-127e-c7ccc7f538e1
md"
====================================================================================
#### SICP: 3.3.2.1 [Representing Queues](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2) (FIFOs)
##### file: PCM20230227\_SICP\_3.3.2.1\_RepresentingQueues.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/04/10 ***

====================================================================================
"

# ╔═╡ ef92d4d5-2a46-4d2f-8f5b-bcb2aa11ce9f
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ ea447685-1666-4dac-b347-bc4f2ff0f4e7
md"
###### *List* Constructor
"

# ╔═╡ 1f7759f3-17a5-4613-8f8a-9b56bde81ae3
mutable struct Cons # 'mutable' is dangerous ! 
	car
	cdr
end # struct Cons

# ╔═╡ 1119c1d8-ace0-439a-aa0d-f67149208a03
cons(car, cdr) = Cons(car, cdr)

# ╔═╡ d8a7e6eb-5528-4696-b520-ca55449bf1b9
md"
---
###### *List* Selectors
"

# ╔═╡ e8b30f65-1e4e-44fb-ae96-7aa5b961be79
car(cons::Cons) = cons.car

# ╔═╡ b9e6d635-faa2-478f-84a8-cf69befd343b
cdr(cons::Cons) = cons.cdr

# ╔═╡ cfcc3201-e41d-4a73-9ef5-e9a19fb2bdd7
#------------------------------------------------------------------------------------
# this method pretty-prints a latent hierarchical cons-structure as a nested 
#    tuple structure which has similarity with a Lisp- or Scheme-list
# also used in 3.3.1 and 3.3.2.1
# case 4 (one-dotted-pair) is new here for ch-3.3.3.1
#------------------------------------------------------------------------------------
function pp(consStruct)
	#--------------------------------------------------------------------------------
	function pp_iter(consStruct, arrayList)
		#----------------------------------------------------------------------------
		if consStruct == :nil                               # termination case 1 
			()
		elseif typeof(consStruct) <: Atom                   # termination case_2 
			consStruct
		#----------------------------------------------------------------------------
		# one-element list                                  # termination case_3 
		elseif (typeof(car(consStruct)) <: Atom) && (cdr(consStruct) == :nil)
			Tuple(push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		# one-dotted-pair                                   # termination case_4
		elseif (typeof(car(consStruct)) <: Atom) && (typeof(cdr(consStruct)) <: Atom)
			Tuple(push!(arrayList, car(consStruct), cdr(consStruct)))
		#----------------------------------------------------------------------------
		# flat multi-element list
		elseif (car(consStruct) == :nil) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, ()))
		elseif (typeof(car(consStruct)) <: Atom) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, car(consStruct)))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
			elseif (typeof(car(consStruct)) <: Cons) && (cdr(consStruct) == :nil)
				Tuple(push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		# nested sublist as first element of multi-element list
		elseif (typeof(car(consStruct)) <: Cons) && (typeof(cdr(consStruct)) <: Cons)
			pp_iter(cdr(consStruct), push!(arrayList, pp(car(consStruct))))
		#----------------------------------------------------------------------------
		else
			error("==> unknown case for: $consStruct")
		end # if
	end # pp_iter
	#--------------------------------------------------------------------------------
	pp_iter(consStruct, [])      
end # function pp
#------------------------------------------------------------------------------------

# ╔═╡ aaa6fed3-441c-4d68-a0af-e1fe37ae2ac4
md"
---
###### *List* Modifier
"

# ╔═╡ 3db9e3ff-22be-4008-b07e-e6f51cb90b1f
function setCar!(cons::Cons, car) 
	cons.car = car
	cons
end # setCar!

# ╔═╡ 7f36366d-14f2-4b36-b973-9244a65edaa4
function setCdr!(cons::Cons, cdr) 
	cons.cdr = cdr
	cons
end # setCdr!

# ╔═╡ 7913a799-69d5-42e7-a1ac-5c2dafbf3fb0
md"
---
###### *Queue* Constructor
"

# ╔═╡ 37b9ea90-f993-4891-b0a1-cde59246da3e
makeQueue() = cons(:nil, :nil)

# ╔═╡ 7c5b3054-6d93-4190-b5a7-15b0283ce19e
md"
---
###### *Queue* Selectors
"

# ╔═╡ 6ecadcb1-30fa-41ab-8df9-ff662553b90b
frontPtr(queue) = car(queue)

# ╔═╡ 9c28ce6f-ce69-4f46-8d1e-b78453c77df2
rearPtr(queue) = cdr(queue)

# ╔═╡ 87ab609b-1485-450e-9dc7-c2ea535fcae4
md"
---
###### *Queue* Modifier
"

# ╔═╡ 861a5f6b-dca1-4538-b4c3-6e2c099a24e5
setFrontPtr!(queue, item) = setCar!(queue, item)

# ╔═╡ 7d167f48-2d8d-4c18-9a40-da73be3b833b
setRearPtr!(queue, item) = setCdr!(queue, item)

# ╔═╡ 46f15584-29f6-4f6e-8206-694b53577a9a
md"
---
###### *Queue* Operations
"

# ╔═╡ a65a1b02-bc31-47de-8a33-71458fb4530e
isEmptyQueue(queue) = :nil == frontPtr(queue)

# ╔═╡ f9bf9411-bb35-4d07-b89e-daef782033f6
function frontQueue(queue)
	isEmptyQueue(queue) ? error("FRONT called with an empty queue $queue") :
		car(frontPtr(queue))
end # function frontQueue

# ╔═╡ ea838792-b5a2-4273-9984-82aeba867912
function insertQueue!(queue, item) 
	let
		newPair = cons(item, :nil)
		if isEmptyQueue(queue) 
			setFrontPtr!(queue, newPair)
			setRearPtr!(queue, newPair)       # can be factored out
			queue                             # can be factored out
		else
			setCdr!(rearPtr(queue), newPair)
			setRearPtr!(queue, newPair)       # can be factored out
			queue                             # can be factored out
		end # if
	end # let
end # function insertQueue!

# ╔═╡ 8577b6ab-1b3d-4262-93b6-2d4efbe4c661
function deleteQueue!(queue)
	if isEmptyQueue(queue) 
		error("DELETE! called with an empty queue $queue") 
	else
		setFrontPtr!(queue, cdr(frontPtr(queue)))
		queue
	end # if
end # function deleteQueue!

# ╔═╡ 94691870-2633-4aeb-a8ee-40d9eb49a6a0
md"
---
###### Applications with *Queue*
"

# ╔═╡ c7c27bfe-f919-4948-9640-f2dd1d5dc068
let 
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
end # let

# ╔═╡ 144e69b5-741d-4adb-82a8-4e57610f56df
let 
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	pp(q)                     # ==> (())
	#-------------------------------------------------------------
end # let

# ╔═╡ 3f5f7e76-f128-4dde-a8e4-b0bc624e40e3
let 
	q1 = makeQueue()          # ==> Cons(:nil, ;nil) ->  :)
	isEmptyQueue(q1)          # ==> true -->  :)
end # let

# ╔═╡ 22b8d24f-c220-4ede-b546-6eb8045b6def
let 
	#-------------------------------------------------------------
	q = makeQueue()          # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
	isEmptyQueue(q)          # ==> true -->  :)
	frontQueue(q)            # ==> error("...")        -->  :)
	q
end # let

# ╔═╡ 591ec7fc-7dfd-4b36-bf79-7fdfc9b72b26
let 
	#-------------------------------------------------------------
	q = makeQueue()          # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
	isEmptyQueue(q)          # ==> true -->  :)
	# frontQueue(q1)         # ==> error("...")        -->  :)
    insertQueue!(q, :a)      # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	q
end # let

# ╔═╡ 5fce921f-a38c-490a-999c-551cac39967f
let 
	#-------------------------------------------------------------
	q = makeQueue()          # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
	isEmptyQueue(q)          # ==> true -->  :)
	# frontQueue(q1)         # ==> error("...")        -->  :)
    insertQueue!(q, :a)      # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	pp(q)                    # ==> ((:a), :a)
end # let

# ╔═╡ a8771d28-538f-41bc-a053-5048286f8a31
md"
---
###### *Queue* $q$ as a List with Front and Rear Pointers
(cf. [**Fig. 3.19**, SICP, 1996](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2))

"

# ╔═╡ 05f6cf7c-3a73-450c-a889-c14343320233
let                           
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	q                   # ==> Cons(Cons(:a, Cons(:b, Cons(:c, :nil))), Cons(:c, :nil))
end # let

# ╔═╡ b0838bdd-8b8b-4a93-9181-38d114a203cd
let                           
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	pp(q)                     # ==> ((:a, :b, :c), :c) -->  :)
end # let

# ╔═╡ 44345b17-a04b-486e-b65e-e572108baff5
md"
---
###### *Queue* $q$ as a List after $insertQueue!(q, :d)$
(cf. [**Fig. 3.20**, SICP, 1996](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2))

"

# ╔═╡ fbb36162-7aed-4005-9a43-ad43ba65eea2
let                           
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	q
end # let

# ╔═╡ a7690490-f656-4bee-862f-e758e3bfc634
let                           
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	pp(q)                     # ==> ((:a, :b, :c, :d), :d) -->  :)
end # let

# ╔═╡ 227ed817-cee7-4bfd-a328-12cd6655bd92
md"
---
###### *Queue* $q$ as a List after $deleteQueue!(q)$
(cf. [**Fig. 3.21**, SICP, 1996](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2))

"

# ╔═╡ f4dbbfed-1e14-450d-b913-5917c1d91754
let                         
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
	isEmptyQueue(q)           # ==> true -->  :)
	# frontQueue(q1)          # ==> error("...")        -->  :)
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	deleteQueue!(q)
	q
end # let

# ╔═╡ bbead2c3-0d81-4d10-aaed-4a0a70ff7e5a
let                         
	#-------------------------------------------------------------
	q = makeQueue()           # ==> Cons(:nil, ;nil) ->  :)
	#-------------------------------------------------------------
	isEmptyQueue(q)           # ==> true -->  :)
	# frontQueue(q1)          # ==> error("...")        -->  :)
    insertQueue!(q, :a)       # ==> Cons(Cons(:a, :nil), Cons(:a, :nil)) ->  :)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	deleteQueue!(q)
	pp(q)                     # ==> ((:b, :c, :d), :d) -->  :)
end # let

# ╔═╡ d061cc09-e0a5-4885-90d5-d30073e07345
md"
---
###### [Exercise 3.21](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e2)

*Pluto* prints the *correct* storage structure of the queues, wheras our $pp$-function acts like the standard Scheme output function. As such Exercise 3.21 is already solved by *Pluto* !
"

# ╔═╡ 64550fab-18ec-4677-890d-011c3cf4071f
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	q1
end # let

# ╔═╡ 0356a941-77e6-4327-b9b9-ffaf527f45ca
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	pp(q1)                # ==> ((:a), :a) -->  :)       
end # let

# ╔═╡ d5a1a7b5-ccad-4d08-99f9-3ab82e3fe132
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	q1
end # let

# ╔═╡ a26eb0d0-bba7-4bd5-982c-a376498bb873
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	pp(q1)                # ==> ((:a, :b), :b) -->  :)  
end # let

# ╔═╡ 3b750efe-fab1-4e05-9700-7d73c3a9cb25
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(Cons(:b, :nil), Cons(:b, :nil))
	q1
end # let

# ╔═╡ 34ab1503-6eb3-4333-a506-6fd380ab34c8
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(Cons(:b, :nil), Cons(:b, :nil))
	pp(q1)                # ==> ((:b), :b) -->  :)  
end # let

# ╔═╡ 51a15713-553e-4501-8b5f-fa850f0f0519
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(Cons(:b, :nil), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(:nil, Cons(:b, :nil))
	q1
end # let

# ╔═╡ af69b1c2-5382-4c8a-8421-ac82ccbbf4f5
let 
	q1 = makeQueue()
	insertQueue!(q1, :a)  # ==> Cons(Cons(:a, :nil), Cons(:a, :nil))
	insertQueue!(q1, :b)  # ==> Cons(Cons(:a, Cons(:b, :nil)), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(Cons(:b, :nil), Cons(:b, :nil))
	deleteQueue!(q1)      # ==> Cons(:nil, Cons(:b, :nil))
	pp(q1)                # ==> pp(Cons((), (:b))) ==> ((), :b) -->  :)
end # let

# ╔═╡ 53f87045-e788-42ec-b3a3-a2de9aee3be0
md"
---

##### end of ch. 3.3.2.1
"

# ╔═╡ f3f6ed46-f4bf-47b7-9b2c-c2ea2a278f3b
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

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
# ╟─c74486e0-b696-11ed-127e-c7ccc7f538e1
# ╠═ef92d4d5-2a46-4d2f-8f5b-bcb2aa11ce9f
# ╠═cfcc3201-e41d-4a73-9ef5-e9a19fb2bdd7
# ╟─ea447685-1666-4dac-b347-bc4f2ff0f4e7
# ╠═1f7759f3-17a5-4613-8f8a-9b56bde81ae3
# ╠═1119c1d8-ace0-439a-aa0d-f67149208a03
# ╟─d8a7e6eb-5528-4696-b520-ca55449bf1b9
# ╠═e8b30f65-1e4e-44fb-ae96-7aa5b961be79
# ╠═b9e6d635-faa2-478f-84a8-cf69befd343b
# ╟─aaa6fed3-441c-4d68-a0af-e1fe37ae2ac4
# ╠═3db9e3ff-22be-4008-b07e-e6f51cb90b1f
# ╠═7f36366d-14f2-4b36-b973-9244a65edaa4
# ╟─7913a799-69d5-42e7-a1ac-5c2dafbf3fb0
# ╠═37b9ea90-f993-4891-b0a1-cde59246da3e
# ╟─7c5b3054-6d93-4190-b5a7-15b0283ce19e
# ╠═6ecadcb1-30fa-41ab-8df9-ff662553b90b
# ╠═9c28ce6f-ce69-4f46-8d1e-b78453c77df2
# ╟─87ab609b-1485-450e-9dc7-c2ea535fcae4
# ╠═861a5f6b-dca1-4538-b4c3-6e2c099a24e5
# ╠═7d167f48-2d8d-4c18-9a40-da73be3b833b
# ╟─46f15584-29f6-4f6e-8206-694b53577a9a
# ╠═a65a1b02-bc31-47de-8a33-71458fb4530e
# ╠═f9bf9411-bb35-4d07-b89e-daef782033f6
# ╠═ea838792-b5a2-4273-9984-82aeba867912
# ╠═8577b6ab-1b3d-4262-93b6-2d4efbe4c661
# ╟─94691870-2633-4aeb-a8ee-40d9eb49a6a0
# ╠═c7c27bfe-f919-4948-9640-f2dd1d5dc068
# ╠═144e69b5-741d-4adb-82a8-4e57610f56df
# ╠═3f5f7e76-f128-4dde-a8e4-b0bc624e40e3
# ╠═22b8d24f-c220-4ede-b546-6eb8045b6def
# ╠═591ec7fc-7dfd-4b36-bf79-7fdfc9b72b26
# ╠═5fce921f-a38c-490a-999c-551cac39967f
# ╟─a8771d28-538f-41bc-a053-5048286f8a31
# ╠═05f6cf7c-3a73-450c-a889-c14343320233
# ╠═b0838bdd-8b8b-4a93-9181-38d114a203cd
# ╟─44345b17-a04b-486e-b65e-e572108baff5
# ╠═fbb36162-7aed-4005-9a43-ad43ba65eea2
# ╠═a7690490-f656-4bee-862f-e758e3bfc634
# ╟─227ed817-cee7-4bfd-a328-12cd6655bd92
# ╠═f4dbbfed-1e14-450d-b913-5917c1d91754
# ╠═bbead2c3-0d81-4d10-aaed-4a0a70ff7e5a
# ╟─d061cc09-e0a5-4885-90d5-d30073e07345
# ╠═64550fab-18ec-4677-890d-011c3cf4071f
# ╠═0356a941-77e6-4327-b9b9-ffaf527f45ca
# ╠═d5a1a7b5-ccad-4d08-99f9-3ab82e3fe132
# ╠═a26eb0d0-bba7-4bd5-982c-a376498bb873
# ╠═3b750efe-fab1-4e05-9700-7d73c3a9cb25
# ╠═34ab1503-6eb3-4333-a506-6fd380ab34c8
# ╠═51a15713-553e-4501-8b5f-fa850f0f0519
# ╠═af69b1c2-5382-4c8a-8421-ac82ccbbf4f5
# ╟─53f87045-e788-42ec-b3a3-a2de9aee3be0
# ╟─f3f6ed46-f4bf-47b7-9b2c-c2ea2a278f3b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
