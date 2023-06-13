### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 22907370-fef8-11ed-2fb3-d1536fc68fbd
md"
====================================================================================

#### SICP: 3.3.4.1 Simulator for Digital Circuits: Simulation of Basic Gates
##### file: PCM20230530\_SICP\_3.3.4.1\_SimulatorForDigitalCircuits.jl
##### Julia/Pluto.jl-code (1.9.0/0.19.25) by PCM *** 2023/06/13 ***

====================================================================================
"


# ╔═╡ 7a4ec6bd-c63c-4c35-9074-b5c16e36fa09
Atom = Union{Number, Symbol, Char, String, Function} # new ! extended with 'Function'

# ╔═╡ 4ed0fb98-d7cd-4efc-9543-d63b6517684b
md"
---
##### 3.3.4.1 Cons-cells and Lists
###### Constructors
"

# ╔═╡ 03e5855d-a4cf-4fce-971b-a38e3dec2653
#----------------------------------------------
# taken from 3.3.1
#----------------------------------------------
mutable struct Cons # 'mutable' is dangerous ! 
	car
	cdr
end # struct Cons

# ╔═╡ 25149de2-9d94-4f9e-a51a-d41355fea192
cons(car, cdr) = Cons(car, cdr)

# ╔═╡ f322f132-cc45-4753-9640-024df2688dea
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

# ╔═╡ c00fedaa-6bd3-4cad-9843-c0e9d1689549
md"
---
###### Selectors
"

# ╔═╡ 2ed04385-33e7-483a-be5a-250b34ef16b8
car(cons::Cons) = cons.car

# ╔═╡ c81b9fad-dbb4-4e9a-b41b-ef361aa42645
cdr(cons::Cons) = cons.cdr

# ╔═╡ bf845b28-83ca-46e9-9d70-876e75516008
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
		# one-element list                                  # termination case_3 
		elseif (typeof(car(consStruct)) <: Atom) && (cdr(consStruct) == :nil)
			Tuple(push!(arrayList, pp(car(consStruct))))
		elseif (typeof(car(consStruct)) <: Function) && (cdr(consStruct) == :nil)
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

# ╔═╡ de265e3b-9a06-49e8-bd23-ef93c783aa38
md"
---
###### Modifiers
"

# ╔═╡ 034ce3ad-3282-4e5c-ba5f-447dd8b2aa5f
# taken from 3.3.1
#----------------------------------------------
function setCar!(cons::Cons, car) 
	cons.car = car
	cons
end # setCar!

# ╔═╡ 6d834cc3-fd8e-41b7-8421-8d0b8c641ab1
# taken from 3.3.1
#----------------------------------------------
function setCdr!(cons::Cons, cdr) 
	cons.cdr = cdr
	cons
end # setCdr!

# ╔═╡ f63239f5-f5ee-49e7-8fe7-5f702aea971f
md"
---
###### Predicate
"

# ╔═╡ 7edee29e-547b-453b-b43e-3c0eff63aaa9
null(list) = (list == () || list == :nil) ? true : false

# ╔═╡ 64697e17-597c-4d22-8d77-b01a377d69fe
null(())

# ╔═╡ 918a4614-2157-41bc-98ab-cf8a32fa817b
null(:nil)

# ╔═╡ 9645e074-4dc3-4269-b4a5-e9efc5d42054
md"
---
##### 3.3.4.2 Queues
"

# ╔═╡ a9467ed9-931e-43ba-84dc-ccd5ed9ccd9b
md"
###### Constructor
"

# ╔═╡ 9638642d-89d6-4648-bce9-84e99f6fec27
makeQueue() = cons(:nil, :nil)

# ╔═╡ ee13f381-11cf-4b6f-937c-c6ffde6550e3
md"
---
###### Predicate
"

# ╔═╡ 3bc72ea2-c0dd-44e0-a104-d0c9c9c0b0a0
md"
---
###### Selectors
"

# ╔═╡ 51340a5e-f525-47ac-8b2e-3a50bd83af24
frontPtr(queue) = car(queue)                  # SICP, p.263

# ╔═╡ 6b1a1ea5-1e11-45e1-b0f9-1ed4aca98b45
emptyQueue(queue) = :nil == frontPtr(queue)   # SICP, p.264

# ╔═╡ 02cbd75f-74d5-4160-9b9d-cd69ea4eb7d4
rearPtr(queue) = cdr(queue)                   # SICP, p.263

# ╔═╡ f1917f7e-7e74-4b96-a4df-f72cabb896c3
function frontQueue(queue)
	emptyQueue(queue) ? error("FRONT called with an empty queue $queue") :
		car(frontPtr(queue))
end # function frontQueue

# ╔═╡ dd88c337-0eda-4ed9-9b82-a2cb8d1c48d5
md"
---
###### Mutators
"

# ╔═╡ fdb7f91a-3622-4c42-9883-7e94032ca607
setFrontPtr!(queue, item) = setCar!(queue, item)

# ╔═╡ 91577057-4c41-4eb9-8766-571584264073
setRearPtr!(queue, item) = setCdr!(queue, item)

# ╔═╡ c8a056e0-444f-435a-8fce-2cc100d686e8
function insertQueue!(queue, item)            # SICP, p.264
	let newPair = cons(item, :nil)
		if 	emptyQueue(queue) 
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

# ╔═╡ 07163ded-3e3b-4cba-a5fd-b6d8cf1f7c5b
function deleteQueue!(queue)
	if emptyQueue(queue) 
		error("DELETE! called with an empty queue $queue") 
	else
		setFrontPtr!(queue, cdr(frontPtr(queue)))
		queue
	end # if
end # function deleteQueue!

# ╔═╡ 41fdbb86-c059-4758-8b25-e6a369a91d9d
md"
---
##### 3.3.4.3 Agendas
"

# ╔═╡ 395a4f66-4b68-4484-9539-8460645918a0
md"
###### Constructor
"

# ╔═╡ 3df31ea8-2b86-4411-8acd-019898d9ab78
# makeAgenda() = cons(0, :nil)                             # variant
makeAgenda() = list(0)                                     # SICP, p.283

# ╔═╡ 024520aa-3204-4f5f-81e6-e375fadb59d7
makeTimeSegment(time, queue) = cons(time, queue)           # SICP, p.283

# ╔═╡ f605bccd-5d2b-4417-9d64-a6cea6bc1780
md"
---
###### Selectors
"

# ╔═╡ 02516da6-7eb9-45b6-8513-27ffb8532fd3
currentTime(agenda) =  car(agenda)                          # SICP, p.283

# ╔═╡ ac5499b9-9ece-47e0-9c01-6b338c5d3dd0
segments(agenda) = cdr(agenda)        # = queues of agenda  # SICP, p.283

# ╔═╡ 778b1afe-a6f5-4481-9943-e78e3f8b7236
firstSegment(agenda) = car(segments(agenda))                # SICP, p.283

# ╔═╡ 6ccb7717-0b49-4b67-99c2-ed5d606174d0
restSegments(agenda) = cdr(segments(agenda))                # SICP, p.283

# ╔═╡ 67036f78-ce30-4204-88c1-3ddd8570f0c8
segmentTime(segment) = car(segment)                         # SICP, p.283

# ╔═╡ fb23f9b1-3d1b-4eb8-932f-7074f85b9bde
segmentQueue(segment) = cdr(segment)                        # SICP, p.283

# ╔═╡ 7ac8d855-a27a-43f7-879d-8c75925ee309
md"
---
###### Mutators
"

# ╔═╡ 6e883562-bedf-4ff1-99fb-f37bd0736aa1
setCurrentTime!(agenda, time) = setCar!(agenda, time)       # SICP, p.283

# ╔═╡ 0ca67d73-9d82-4bf3-a197-30bb0a4df9e7
setSegments!(agenda, segments) = setCdr!(agenda, segments)  # SICP, p.283

# ╔═╡ 809c1078-c9da-45f3-bfe0-e24289fed597
function removeFirstAgendaItem!(agenda)                     # SICP, p.285
	let queue = segmentQueue(firstSegment(agenda))
		deleteQueue!(queue)
		if emptyQueue(queue)
			setSegments!(agenda, restSegments(agenda))
		end # if
	end # let
end # function removeFirstAgendaItem

# ╔═╡ 23332628-dc26-4ca9-a28a-10ba64d5f725
function addActionToAgenda!(time, action, agenda)           # SICP, p.284
	#--------------------------------------------------------
	function belongsBefore(segments)
		null(segments) || time < segmentTime(car(segments)) 
	end # function belongsBefore
	#--------------------------------------------------------
	function makeNewTimeSegment(time, action)
		let queue = makeQueue()
			insertQueue!(queue, action)
			makeTimeSegment(time, queue)
		end # let
	end # function makeNewTimeSegment
	#--------------------------------------------------------
	function addToSegments!(segments)
		if segmentTime(car(segments)) == time
			insertQueue!(segmentQueue(car(segments)), action)
		else
			let rest = cdr(segments)
				if 	belongsBefore(rest)
					setCdr!(
						segments, 
						cons(makeNewTimeSegment(time, action), cdr(segments)))
				else
					addToSegments!(rest)
				end # if
			end # let
		end # if
	end # function addToSegments!
	#--------------------------------------------------------
	let segments = segments(agenda)
		if belongsBefore(segments)
			setSegments!(agenda, cons(makeNewTimeSegment(time, action), segments))
		else
			addToSegments!(segments)
		end # if
	end # let
	#--------------------------------------------------------
end # function addActionToAgenda!

# ╔═╡ 6d7cab1c-e3be-4305-bd83-eaea9f9987bf
function addActionToAgendaAfterDelay!(delay, action, agenda)         # SICP, p.281
	addActionToAgenda!(delay + currentTime(agenda), action, agenda)
end # function addActionToAgendaAfterDelay!

# ╔═╡ a2d20357-e08f-49df-aa0d-650f97637c36
md"
---
###### Predicate
"

# ╔═╡ b74d0c0a-bd42-4bc9-9ad8-e8ab076c4f0a
function emptyAgenda(agenda)
	null(segments(agenda))
end # function emptyAgenda

# ╔═╡ 09137ca6-5e28-49b1-9899-8cc400e1c2cc
function firstAgendaItem(agenda)                            # SICP, p.285
	emptyAgenda(agenda) ? error("Agenda is empty - FIRST-AGENDA-ITEM") :
		let firstSegment = firstSegment(agenda)             # segment == queue
			setCurrentTime!(agenda, segmentTime(firstSegment))
			frontQueue(segmentQueue(firstSegment))
		end # let
end # function firstAgendaItem

# ╔═╡ e2b4876e-d786-4d09-b1ba-b7d81ca8094a
function propagate(agenda)                                         # SICP, p.281
	emptyAgenda(agenda) ? "propagate ==> done" :
		let firstItem = firstAgendaItem(agenda)
			firstItem()
			removeFirstAgendaItem!(agenda)
			propagate(agenda)
		end # let
end # function propagate

# ╔═╡ e447b533-f3d7-495e-9262-ff056721c704
md"
---
##### 3.3.4.4 Wires and Circuits
"

# ╔═╡ 3d6923aa-08ee-4fb7-8707-af865b6fc539
md"
---
###### Circuit: Half-Adder 
(SICP, Fig.3.25)
"

# ╔═╡ 932edff1-9a4c-4c2c-a950-7ddd51406763
md"
---
###### Circuit: Full-Adder 
(SICP, Fig.3.26)
"

# ╔═╡ 07871aff-905b-4718-b7e9-1f0de462238a
md"
---
##### 3.3.4.5 Primitive Function Boxes
"

# ╔═╡ bafe623c-0315-476a-85ba-006a4e9ebd86
md"
###### Wire-centered Functions
"

# ╔═╡ 9ebd2ce6-a832-4363-ac91-b55f53e37688
getSignal(wire) = wire(:getSignal)

# ╔═╡ 0efb92e2-1f41-4fd2-a241-e26987373bdb
setSignal!(wire, newValue) = wire(:setSignal!)(newValue)

# ╔═╡ 4569422d-3e40-4b8d-9d58-fdb78fc21908
addActionToWire!(wire, actionProcedure) = wire(:addActionToWire!)(actionProcedure)

# ╔═╡ dfc0a0b4-0a06-4139-bb9d-084eec58b87d
getProcedures(wire) = wire(:getProcedures)

# ╔═╡ cdda9aed-3217-4ec4-8938-ff207ea3da9e
md"
---
###### Logical Not 
"

# ╔═╡ e414fcbd-64bd-43c2-b768-25b40d779d89
function logicalNot(s)
	s == 0 ? 1 :
	s == 1 ? 0 :
	error("Invalid signal s = $s")
end # function logicalNot

# ╔═╡ b8a33da6-7ab2-44a5-9d69-298c0d9617a6
logicalNot(0)

# ╔═╡ 08a24fa5-d455-42fe-b252-e9711ea43761
logicalNot(1)

# ╔═╡ 175cab75-9e28-4c07-a60b-fa43721529e9
logicalNot("1")

# ╔═╡ 937a5155-b761-443b-9115-4222082f2ff4
md"
---
###### Inverter 
"

# ╔═╡ f177c735-fc16-4710-889f-aa8c7ac7346b
md"
---
###### Logical Or
"

# ╔═╡ f187b113-d6b5-479e-b956-e5b3f908c1f4
function logicalOr(s1, s2)
    !(s1 == 0 ||  s1 == 1) ? error("Invalid signal s1 = '$s1'") :
	!(s2 == 0 ||  s2 == 1) ? error("Invalid signal s2 = '$s2'") :
	(s1 == 1) || (s2 == 1) ? 1 : 0
end # function logicalOr

# ╔═╡ 687eb9ae-47ba-4db9-b1c8-2bef50b95d37
logicalOr(1, 1)

# ╔═╡ 8ddf6747-8f37-4de0-8b26-f55e38d6494b
logicalOr(1, 0)

# ╔═╡ 56a369fb-a2d6-4cdb-9a58-5d2960dee528
logicalOr(0, 1)

# ╔═╡ b2f84e93-7d20-489c-84de-76d3443a005d
logicalOr(0, 0)

# ╔═╡ f14122a4-8448-45c5-aeea-5a8df395d05f
logicalOr("0", 0)

# ╔═╡ ee28f9a1-0d73-4ae3-b1e2-c3c852e39fb3
logicalOr(0, "0")

# ╔═╡ b98d78c7-749d-458b-9c38-50a41bd7fb4b
logicalOr("0", "0")

# ╔═╡ 31f4e594-c77f-4fcc-9a14-3a3dcb20c2dd
md"
---
###### Or-Gate
"

# ╔═╡ e2135618-97e2-4608-a71f-97084e118e40
md"
---
###### Logical And
"

# ╔═╡ ef530d6e-5840-484b-945e-14265718b67f
function logicalAnd(s1, s2)
    !(s1 == 0 ||  s1 == 1) ? error("Invalid signal s1 = '$s1'") :
	!(s2 == 0 ||  s2 == 1) ? error("Invalid signal s2 = '$s2'") :
	(s1 == 1) && (s2 == 1) ? 1 : 0
end # function logicalAnd

# ╔═╡ 6b6c9298-9a25-4b97-85f1-8ce1e5e09d0f
logicalAnd(1, 1)

# ╔═╡ b9638b0c-5b36-496d-ad9b-7363b26bfc6e
logicalAnd(1, 0)

# ╔═╡ 0497dacb-965d-4287-8968-68fbcedfe5c5
logicalAnd(0, 1)

# ╔═╡ d91daa1f-421f-4093-8467-68c869b54abf
logicalAnd(0, 0)

# ╔═╡ db4fdb78-580b-4b67-97d3-ab7e14afbb1f
logicalAnd("1", 0)

# ╔═╡ c0e4afac-c9cb-4573-971a-630757c2f29a
logicalAnd(0, "1")

# ╔═╡ d0a02148-b912-4cb2-85ce-23284f62c8ed
logicalAnd("0", "1")

# ╔═╡ 2f8c3246-4234-47d4-8cce-ef65a609d986
md"
---
###### And-Gate
"

# ╔═╡ 49c0ec59-f4bb-4fca-8a9a-97b4d92ef994
md"
---
##### 3.3.4.6 Representing Wires
"

# ╔═╡ 373ec031-b5f6-45c9-9d04-61989e9ad2a0
function callEach(procedures)
	if null(procedures)
		"callEach ==> done"
	else
		begin
			car(procedures)()
			callEach(cdr(procedures))
		end # begin
	end # if
end # function callEach

# ╔═╡ cbb46467-f284-4ef8-85a8-3f4d69739c79
function makeWire()
	let signalValue = 0
		actionProcedures = ()
		#---------------------------------------------------
		function setMySignal!(newValue)
			if !(signalValue == newValue)
				begin
					signalValue = newValue
					callEach(actionProcedures)
				end # begin
			else
				"setMySignal! ==> done"
			end # if
		end # function setMySignal!
		#---------------------------------------------------
		function acceptActionProcedure!(proc)
			actionProcedures = cons(proc, actionProcedures)
			proc()
		end # function acceptActionProcedure!
		#---------------------------------------------------
		function dispatch(message)
			message == :getSignal  ? signalValue  :
			message == :setSignal! ? setMySignal! :
			message == :addActionToWire! ? acceptActionProcedure! :
			message == :getProcedures ? actionProcedures :    # new
			error("Unknown operation -- WIRE m = $message")
		end # function dispatch
		dispatch
	end # let
end # function makeWire

# ╔═╡ ff80b64e-4831-4b86-a8d4-426fd9599cfb
md"
---
##### 3.3.4.7 Test of Queues
(the Test follows a proposal of Guowei Lv: [https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim/](https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim/))
"

# ╔═╡ 7e376df5-45b5-4d7c-a831-cc5695d58fef
qTest = makeQueue()

# ╔═╡ 28513c8f-669a-4571-87f0-432683f6b1bc
emptyQueue(qTest)

# ╔═╡ 03137370-404d-4405-bcca-32da365b23a5
pp(qTest)

# ╔═╡ b4445591-be0f-4587-aad1-78d74d67fdda
# (insert-queue! q 1)
insertQueue!(qTest, 1) 

# ╔═╡ e594a510-c8fe-4be7-bce8-ed66f8a7a418
pp(qTest)               # ==> ((1) 1)   ;; Scheme

# ╔═╡ 054440fb-e606-4268-8858-e0098a1002f2
# (insert-queue! q 2)
insertQueue!(qTest, 2) 

# ╔═╡ e01eaa63-7e8b-4a0b-9bb0-2f5761e31e0c
pp(qTest)               # ==> ((1 2) 2) ;; Scheme

# ╔═╡ 52eade69-76d9-49c3-bb59-a58bc3a98f51
# (insert-queue! q 3)
insertQueue!(qTest, 3) 

# ╔═╡ ccc27ca3-3431-4bd2-bf75-6a5453b61398
pp(qTest)               # ==> ((1 2 3) 3) ;; Scheme

# ╔═╡ e686ab6d-2b6c-4375-aa8d-c46111181cfb
deleteQueue!(qTest)

# ╔═╡ 551fc1ec-82c9-48ff-9640-f03ccebff6ad
pp(qTest)               # ==> ((2 3) 3)  ;; Scheme

# ╔═╡ 794dc3e5-52f0-4644-82ee-a11abb1842e6
frontQueue(qTest)       # ==> 2

# ╔═╡ 5fb2a95a-a5a3-421d-b2df-6c0b415546ec
md"
---
##### 3.3.4.8 Test of Agendas
(the Test follows a proposal of Guowei Lv: [https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim-2/](https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim-2/))
"

# ╔═╡ 2ed53df9-f79c-4c6f-8caf-48a7f10e36fb
md"
The *agenda* is a *list of queues*. An example of a typical agenda is here (Guowei Lv; [https://www.lvguowei.me/img/agenda.png](https://www.lvguowei.me/img/agenda.png)) 
"

# ╔═╡ fafd9373-e63c-4e96-89af-3e637b650580
# Define a global variable 'theTestAgenda'
theTestAgenda = makeAgenda()        # ==> list

# ╔═╡ 3d4a0a43-a979-4395-a316-236bc264eb4d
pp(theTestAgenda)                   # ==> (0) --> :)

# ╔═╡ c380fd8c-8f29-4623-920d-e2006c3a56b6
# Test that theTestAgenda is empty
emptyAgenda(theTestAgenda)          # ==> true --> :)

# ╔═╡ 2b505c78-7d79-4b36-9708-6ae868885733
# The current time should be 0
currentTime(theTestAgenda)          # ==> 0 --> :)

# ╔═╡ feb28621-971b-445a-b6fc-30c9163f9cf1
# segments == queues of scheduled actions
segments(theTestAgenda)             # ==> :nil --> :)

# ╔═╡ ec3902a8-cb1c-4f34-8dc3-f30d4953bb96
theTestAgenda                       # ==> Cons(0, :nil) --> :)

# ╔═╡ f372638b-3d93-44cd-82ff-d55c6874d788
# Add a procedure to execute at time 1
addActionToAgenda!(1, () -> println("Wake up!"), theTestAgenda)

# ╔═╡ bcbfcc5b-7352-45ac-8eaa-1616fa710fab
pp(theTestAgenda)                    # ==> (0, (1, (#3), #3)) --> :)

# ╔═╡ 85b97fb7-33c0-43d0-80f3-58d9de403c3f
addActionToAgenda!(1, () -> println("Wake up, again!"), theTestAgenda)

# ╔═╡ 1effa575-1f95-47cf-9846-25063560dfaf
pp(theTestAgenda)                    # ==> (0, (1, (#3, #9), #9)) --> :)

# ╔═╡ 8aea2143-0a22-461b-a08a-0057bb8c4f41
# (add-to-agenda! 2 (lambda() (display "Go to school!")) the-agenda)
addActionToAgenda!(2, () -> println("Go to school!"), theTestAgenda)

# ╔═╡ 2a723f7b-8935-426b-ae1f-a7a8d8b06d5f
# ;; At this point, there should be two queues in the-agenda, 
#        one for time 1 and one for time 2, let's examine the queue for time 1
pp(theTestAgenda)    # ==> (0, (1, (#3, #9), #9), (2, (#11), #11)) --> :)

# ╔═╡ fff20f14-d3e8-43d2-995c-b603e0fa2626
propagate(theTestAgenda)

# ╔═╡ 98706b9a-b8a7-4cb9-90e5-9c213b68937c
# ;; After propagate, let's check the current time

# ╔═╡ 3f901e51-2538-4f3b-8f62-2ed8724442e6
currentTime(theTestAgenda)                         # ==> 2 --> :)

# ╔═╡ 2132b9c5-3d7e-493e-a300-652bdd126c59
md"
---
##### 3.3.4.9 Sample Circuit Simulations
"

# ╔═╡ 97596ad0-7aad-4dcd-b5d0-e6d0fbee793f
function probe(number, wireName, wire, agenda)
	#---------------------------------------------------------------------------
	currentTimeFromAgenda = currentTime(agenda)
	getSignalFromWire     = getSignal(wire)
	addActionToWire!(wire, 
		() -> "number = $number, wireName = $wireName, currentTime = $currentTimeFromAgenda, newValue = $getSignalFromWire")
	#---------------------------------------------------------------------------
end # function probe

# ╔═╡ 21a016af-cd4e-4c9d-9b5f-a43cb1aeafa7
md"
---
###### Simulation of Inverter-Gate
When we set the input *invIn* to '0' we get after the propagation a signal '1' on output *invOut* after a *delay* of '2'.
"

# ╔═╡ 883bb52c-915a-49f3-b7a0-36a58f7e1fdc
inverterDelay = 2

# ╔═╡ 3ddec46f-1cfc-4305-b6eb-68ecdec73da2
function inverter(input, output, agenda)
	#----------------------------------------------------------------------
	function invertInput()
		let newValue = logicalNot(getSignal(input))
			addActionToAgendaAfterDelay!(
				inverterDelay, () -> setSignal!(output, newValue), agenda)
		end # let
	end # function invertInput
	#----------------------------------------------------------------------
	addActionToWire!(input, invertInput)
	"addActionToWire!(input, invertInput) ==> done"
end # function inverter

# ╔═╡ 913495d0-f04d-4f43-943b-3e7d02f4004c
theInvAgenda = makeAgenda()      # ==> Cons(0, :nil)

# ╔═╡ de939d3b-5575-4c2a-b634-5a128301edcf
pp(theInvAgenda)                 # ==> (0) -->  :)

# ╔═╡ 3e52f2d2-5f9b-413e-9529-55d095862bc7
invIn = makeWire()

# ╔═╡ 889c9055-3f97-48c6-bb71-5aea11e7dc6f
invOut = makeWire()

# ╔═╡ c040e9d4-61e2-4ce7-88e1-6d00416881e4
probe(1, :invOut, invOut, theInvAgenda) # ==>
 # "number = 1, wireName = invOut, currentTime = 2, newValue = 0"

# ╔═╡ fda49a86-3282-4269-9fb3-c14d66904645
inverter(invIn, invOut, theInvAgenda)   # ==>
# "addActionToWire!(input, invertInput) ==> done"  -->  :)

# ╔═╡ 77c45ad4-837c-4da0-9c77-5e789115c0a1
setSignal!(invIn, 0)      # ==> "setMySignal! ==> done"

# ╔═╡ 6e495e1f-2b05-4439-86ed-4a44a049552b
probe(2, :invOut, invOut, theInvAgenda) # ==>
# "number = 1, wireName = invOut, currentTime = 2, newValue = 0"

# ╔═╡ 9e169fcd-b622-4c1e-adc1-c0004bfee28c
propagate(theInvAgenda)   # ==> "propagate ==> done"  -->  :)

# ╔═╡ a9662e31-2b5e-47ca-b5ca-8f95c65c5852
pp(theInvAgenda)   # ==> (2)

# ╔═╡ 176f7ffb-7c49-43ab-872b-4e319244ec1b
probe(3, :invOut, invOut, theInvAgenda) # ==>
# "number = 3, wireName = e, currentTime = 2, newValue = 1"

# ╔═╡ 435ff7e9-e7d4-4fbc-bb20-29a8e5653506
md"
---
###### Simulation of AND-Gate
When we set the inputs *andIn1* to '1' and *andIn2* to '1' we get after the propagation a signal '1' on output *andOut* after a *delay* of '3'.
"

# ╔═╡ 6b0a398c-3314-4de7-a459-f05570692f71
andGateDelay = 3

# ╔═╡ b066241d-633d-48d0-b471-3acced1d7928
function andGate(a1, a2, output, agenda)
	function andActionProcedure()
		let newValue = logicalAnd(getSignal(a1), getSignal(a2))
			addActionToAgendaAfterDelay!(
				andGateDelay, () -> setSignal!(output, newValue), agenda)
		end # let
	end # function andActionProcedure
	addActionToWire!(a1, andActionProcedure)
	addActionToWire!(a2, andActionProcedure)
	"andGate ==> ok"
end # function andGate

# ╔═╡ 793f03d9-f526-4fb0-8ebb-a55c525d98d6
theAndAgenda = makeAgenda() 

# ╔═╡ 7de2e089-2e88-43ff-9f18-21f164e3a3f9
pp(theAndAgenda)                          # ==> (0) -->  :)

# ╔═╡ 9b1298a1-d678-4053-8d24-18d4d6b58113
andIn1 = makeWire()

# ╔═╡ df610ed5-76d0-40ca-9229-449d02a70db5
probe(1, :andIn1, andIn1, theAndAgenda)   # ==>
# "number = 1, wireName = andIn1, currentTime = 0, newValue = 0"

# ╔═╡ bcffe901-c95d-4667-ac87-e764049ea695
andIn2 = makeWire()

# ╔═╡ 95b1808a-a33b-48fe-a3da-9aa15d84c3af
probe(2, :andIn2, andIn2, theAndAgenda)   # ==>
# "number = 2, wireName = andIn2, currentTime = 0, newValue = 0"

# ╔═╡ a66c2949-1512-4e3d-b43b-5f29c71f1b09
andOut = makeWire()

# ╔═╡ 92a4317a-c70b-426d-9591-aa68134939ef
probe(3, :andOut, andOut, theAndAgenda) # ==>
# "number = 3, wireName = andOut1, currentTime = 0, newValue = 0"

# ╔═╡ 469432fc-610f-4759-a497-5d301bfd0bed
pp(theAndAgenda)                 # ==> (0) -->  :)

# ╔═╡ 100037ac-8c86-4b52-bc4a-44b5c9e12d36
andGate(andIn1, andIn2, andOut, theAndAgenda)

# ╔═╡ fd85861b-ecba-4609-9464-9c9fae5e4005
pp(theAndAgenda)                 # ==> (0, (3, (#1, #1), #1)) -->  :)

# ╔═╡ a1defdcb-e238-4ea8-92f4-a3e2f14c591a
setSignal!(andIn1, 1)

# ╔═╡ 40177b0e-1d65-46f8-85bc-3a11b2e57e1f
setSignal!(andIn2, 1)

# ╔═╡ bd06d000-c5a0-4d24-9adc-efb40da3b178
pp(theAndAgenda)                 # ==> (0, (3, (#1, #1, #1, #1), #1)) -->  :)

# ╔═╡ b841f888-0f5b-4d69-85ba-9f131a16712e
probe(4, :andOut, andOut, theAndAgenda)   # ==>
# "number = 4, wireName = andOut1, currentTime = 0, newValue = 0"

# ╔═╡ 2143c24c-de64-4ce3-8c83-e47aae00f61b
propagate(theAndAgenda)

# ╔═╡ 656890b3-aaa0-4fe9-909f-b626ecec63cd
probe(5, :andOut, andOut, theAndAgenda)  # ==>
# "number = 5, wireName = andOut1, currentTime = 3, newValue = 1"

# ╔═╡ 111ef1d2-8d8e-4839-b3c5-94b4526249e4
pp(theAndAgenda)  # ==> (3) -->  :)

# ╔═╡ a196f418-b86c-46f2-90cc-9bedddc1b5fa
probe(6, :andOut, andOut, theAndAgenda)   # ==>
# "number = 6, wireName = andOut1, currentTime = 3, newValue = 1"

# ╔═╡ 20038f70-389d-4c2c-88fd-bc2932bb8875
md"
---
###### Simulation of OR-Gate
When we set the inputs *orIn1* to '1' and *orIn2* to '0' we get after the propagation a signal '1' on output *orOut* after a *delay* of '5'.
"

# ╔═╡ 52f1d27b-0ceb-472a-af25-59c2b4d3626a
orGateDelay = 5

# ╔═╡ b513fc9f-fd7b-462b-95c7-6d9f8b649366
function orGate(a1, a2, output, agenda)
	function orActionProcedure()
		let newValue = logicalOr(getSignal(a1), getSignal(a2))
			addActionToAgendaAfterDelay!(
				orGateDelay, () -> setSignal!(output, newValue), agenda)
		end # let
	end # function andActionProcedure
	addActionToWire!(a1, orActionProcedure)
	addActionToWire!(a2, orActionProcedure)
	"orGate ==> ok"
end # function andGate

# ╔═╡ ef83722a-8893-4f13-be5a-a951dc6c531d
function halfAdder(a, b, s, c)
	let d = makeWire()
		e = makeWire()
		#---------------------------
		orGate(a, b, d)
		andGate(a, b, c)
		inverter(c, e)
		andGate(d, e, s)
		#---------------------------
		"halfAdder ==> ok"
	end # let
end # function halfAdder

# ╔═╡ 4609eeda-38fc-4c8d-8c3f-5e616e8fb975
function fullAdder(a, b, cIn, sum, cOut)
	let s  = makeWire()
		c1 = makeWire()
		c2 = makeWire()
		#---------------------------
		halfAdder(b, cIn,  s, c1)
		halfAdder(a, s, sum, c2)
		orGate(c1, c2, cOut)
		#---------------------------
		"fullAdder ==> ok"
	end # let
end # function halfAdder

# ╔═╡ 85cd31d8-e9b7-4c03-bfa6-baaf75da5058
theOrAgenda = makeAgenda() 

# ╔═╡ ddcf7eaf-f5eb-436a-8adf-1f272c5c90ce
pp(theOrAgenda)                       # ==> (0) -->  :)

# ╔═╡ fbdb499e-d781-4240-bc8d-42b8997a7056
orIn1 = makeWire()

# ╔═╡ b3905a46-65f7-486f-baa2-3bf74da02c4b
probe(1, :orIn1, orIn1, theOrAgenda)  # ==>
# "number = 1, wireName = orIn1, currentTime = 0, newValue = 0"

# ╔═╡ 4bd0ebcb-2800-43ba-8443-3a81656aeaa3
orIn2 = makeWire()

# ╔═╡ 7db90b7d-e060-4a9b-a6e2-1e0c8a9c7297
probe(2, :orIn2, orIn2, theOrAgenda)  # ==>
# "number = 2, wireName = orIn2, currentTime = 0, newValue = 0"

# ╔═╡ cd38cbb3-2795-47e5-8131-6862eceff440
orOut = makeWire()

# ╔═╡ b49a291a-6f4f-45c6-863c-f6d2d2462217
probe(3, :orOut, orOut, theOrAgenda) # ==>
# "number = 3, wireName = orOut, currentTime = 0, newValue = 0"

# ╔═╡ c443a873-3dbc-40d5-8c36-69b8e49f6e54
pp(theOrAgenda)                             # ==> (0, (5, (#1, #1), #1))

# ╔═╡ fb384747-edd7-432e-9128-f0d8cbc62130
orGate(orIn1, orIn2, orOut, theOrAgenda)    # ==> "orGate ==> ok" -->  :)

# ╔═╡ 1e4fb4fd-8854-49fa-b958-8da72b54c5fe
setSignal!(orIn1, 1)                        # ==> "callEach ==> done" -->  :)

# ╔═╡ b29b9861-d0d8-4af6-9111-ab36ae4bdf7b
setSignal!(orIn2, 0)                        # ==> "callEach ==> done" -->  :)

# ╔═╡ ae851504-0c7c-4a7c-b414-1416a165a8e5
pp(theOrAgenda)                             # ==> (0, (5, (#1, #1, #1, #1), #1)) -->  :)

# ╔═╡ 6b421e97-9bd0-42d9-9d3a-5221c48a402b
probe(4, :orOut, orOut, theOrAgenda)        # ==>
# "number = 4, wireName = orOut, currentTime = 0, newValue = 0"

# ╔═╡ 0f7eadbc-0e58-412c-991b-0ca4137b9b5f
propagate(theOrAgenda)                      # ==> "propagate ==> done" -->  :)

# ╔═╡ e1f17835-7674-464d-9d61-0b4315383937
pp(theOrAgenda) 

# ╔═╡ 92fd1c0b-73e9-4a9b-8ab1-7176a2fa23c2
probe(5, :orOut, orOut, theOrAgenda)        # ==>
# "number = 5, wireName = orOut, currentTime = 5, newValue = 1"

# ╔═╡ d43c770b-b407-4a83-bcfb-30fe01e5ce7a
md"
---
##### References

- **Guowei Lv (吕国威的博客)**; [*SICP Goodness - A Simulator for Digital Circuits (I)*](https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim/); last visit 2023/06/09
- **Guowei Lv (吕国威的博客)**; [*SICP Goodness - A Simulator for Digital Circuits (II)*](https://www.lvguowei.me/post/sicp-goodness-digital-circuits-sim-2/); lasit visit 2023/06/09
	"

# ╔═╡ 3b572652-fcf7-4f05-8cb6-32840216f7c0
md"
---
##### end of ch. 3.3.3.1
"

# ╔═╡ 457187e1-2f5a-4bfc-ba43-4a7a10dda477
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ Cell order:
# ╟─22907370-fef8-11ed-2fb3-d1536fc68fbd
# ╠═7a4ec6bd-c63c-4c35-9074-b5c16e36fa09
# ╠═bf845b28-83ca-46e9-9d70-876e75516008
# ╟─4ed0fb98-d7cd-4efc-9543-d63b6517684b
# ╠═03e5855d-a4cf-4fce-971b-a38e3dec2653
# ╠═25149de2-9d94-4f9e-a51a-d41355fea192
# ╠═f322f132-cc45-4753-9640-024df2688dea
# ╟─c00fedaa-6bd3-4cad-9843-c0e9d1689549
# ╠═2ed04385-33e7-483a-be5a-250b34ef16b8
# ╠═c81b9fad-dbb4-4e9a-b41b-ef361aa42645
# ╟─de265e3b-9a06-49e8-bd23-ef93c783aa38
# ╠═034ce3ad-3282-4e5c-ba5f-447dd8b2aa5f
# ╠═6d834cc3-fd8e-41b7-8421-8d0b8c641ab1
# ╟─f63239f5-f5ee-49e7-8fe7-5f702aea971f
# ╠═7edee29e-547b-453b-b43e-3c0eff63aaa9
# ╠═64697e17-597c-4d22-8d77-b01a377d69fe
# ╠═918a4614-2157-41bc-98ab-cf8a32fa817b
# ╟─9645e074-4dc3-4269-b4a5-e9efc5d42054
# ╟─a9467ed9-931e-43ba-84dc-ccd5ed9ccd9b
# ╠═9638642d-89d6-4648-bce9-84e99f6fec27
# ╟─ee13f381-11cf-4b6f-937c-c6ffde6550e3
# ╠═6b1a1ea5-1e11-45e1-b0f9-1ed4aca98b45
# ╠═28513c8f-669a-4571-87f0-432683f6b1bc
# ╟─3bc72ea2-c0dd-44e0-a104-d0c9c9c0b0a0
# ╠═51340a5e-f525-47ac-8b2e-3a50bd83af24
# ╠═02cbd75f-74d5-4160-9b9d-cd69ea4eb7d4
# ╠═f1917f7e-7e74-4b96-a4df-f72cabb896c3
# ╟─dd88c337-0eda-4ed9-9b82-a2cb8d1c48d5
# ╠═fdb7f91a-3622-4c42-9883-7e94032ca607
# ╠═91577057-4c41-4eb9-8766-571584264073
# ╠═c8a056e0-444f-435a-8fce-2cc100d686e8
# ╠═07163ded-3e3b-4cba-a5fd-b6d8cf1f7c5b
# ╟─41fdbb86-c059-4758-8b25-e6a369a91d9d
# ╟─395a4f66-4b68-4484-9539-8460645918a0
# ╠═3df31ea8-2b86-4411-8acd-019898d9ab78
# ╠═024520aa-3204-4f5f-81e6-e375fadb59d7
# ╟─f605bccd-5d2b-4417-9d64-a6cea6bc1780
# ╠═09137ca6-5e28-49b1-9899-8cc400e1c2cc
# ╠═02516da6-7eb9-45b6-8513-27ffb8532fd3
# ╠═ac5499b9-9ece-47e0-9c01-6b338c5d3dd0
# ╠═778b1afe-a6f5-4481-9943-e78e3f8b7236
# ╠═6ccb7717-0b49-4b67-99c2-ed5d606174d0
# ╠═67036f78-ce30-4204-88c1-3ddd8570f0c8
# ╠═fb23f9b1-3d1b-4eb8-932f-7074f85b9bde
# ╟─7ac8d855-a27a-43f7-879d-8c75925ee309
# ╠═6e883562-bedf-4ff1-99fb-f37bd0736aa1
# ╠═0ca67d73-9d82-4bf3-a197-30bb0a4df9e7
# ╠═809c1078-c9da-45f3-bfe0-e24289fed597
# ╠═23332628-dc26-4ca9-a28a-10ba64d5f725
# ╠═6d7cab1c-e3be-4305-bd83-eaea9f9987bf
# ╠═e2b4876e-d786-4d09-b1ba-b7d81ca8094a
# ╟─a2d20357-e08f-49df-aa0d-650f97637c36
# ╠═b74d0c0a-bd42-4bc9-9ad8-e8ab076c4f0a
# ╟─e447b533-f3d7-495e-9262-ff056721c704
# ╟─3d6923aa-08ee-4fb7-8707-af865b6fc539
# ╠═ef83722a-8893-4f13-be5a-a951dc6c531d
# ╟─932edff1-9a4c-4c2c-a950-7ddd51406763
# ╠═4609eeda-38fc-4c8d-8c3f-5e616e8fb975
# ╟─07871aff-905b-4718-b7e9-1f0de462238a
# ╟─bafe623c-0315-476a-85ba-006a4e9ebd86
# ╠═9ebd2ce6-a832-4363-ac91-b55f53e37688
# ╠═0efb92e2-1f41-4fd2-a241-e26987373bdb
# ╠═4569422d-3e40-4b8d-9d58-fdb78fc21908
# ╠═dfc0a0b4-0a06-4139-bb9d-084eec58b87d
# ╟─cdda9aed-3217-4ec4-8938-ff207ea3da9e
# ╠═e414fcbd-64bd-43c2-b768-25b40d779d89
# ╠═b8a33da6-7ab2-44a5-9d69-298c0d9617a6
# ╠═08a24fa5-d455-42fe-b252-e9711ea43761
# ╠═175cab75-9e28-4c07-a60b-fa43721529e9
# ╟─937a5155-b761-443b-9115-4222082f2ff4
# ╠═3ddec46f-1cfc-4305-b6eb-68ecdec73da2
# ╟─f177c735-fc16-4710-889f-aa8c7ac7346b
# ╠═f187b113-d6b5-479e-b956-e5b3f908c1f4
# ╠═687eb9ae-47ba-4db9-b1c8-2bef50b95d37
# ╠═8ddf6747-8f37-4de0-8b26-f55e38d6494b
# ╠═56a369fb-a2d6-4cdb-9a58-5d2960dee528
# ╠═b2f84e93-7d20-489c-84de-76d3443a005d
# ╠═f14122a4-8448-45c5-aeea-5a8df395d05f
# ╠═ee28f9a1-0d73-4ae3-b1e2-c3c852e39fb3
# ╠═b98d78c7-749d-458b-9c38-50a41bd7fb4b
# ╟─31f4e594-c77f-4fcc-9a14-3a3dcb20c2dd
# ╠═b513fc9f-fd7b-462b-95c7-6d9f8b649366
# ╟─e2135618-97e2-4608-a71f-97084e118e40
# ╠═ef530d6e-5840-484b-945e-14265718b67f
# ╠═6b6c9298-9a25-4b97-85f1-8ce1e5e09d0f
# ╠═b9638b0c-5b36-496d-ad9b-7363b26bfc6e
# ╠═0497dacb-965d-4287-8968-68fbcedfe5c5
# ╠═d91daa1f-421f-4093-8467-68c869b54abf
# ╠═db4fdb78-580b-4b67-97d3-ab7e14afbb1f
# ╠═c0e4afac-c9cb-4573-971a-630757c2f29a
# ╠═d0a02148-b912-4cb2-85ce-23284f62c8ed
# ╟─2f8c3246-4234-47d4-8cce-ef65a609d986
# ╠═b066241d-633d-48d0-b471-3acced1d7928
# ╟─49c0ec59-f4bb-4fca-8a9a-97b4d92ef994
# ╠═cbb46467-f284-4ef8-85a8-3f4d69739c79
# ╠═373ec031-b5f6-45c9-9d04-61989e9ad2a0
# ╟─ff80b64e-4831-4b86-a8d4-426fd9599cfb
# ╠═7e376df5-45b5-4d7c-a831-cc5695d58fef
# ╠═03137370-404d-4405-bcca-32da365b23a5
# ╠═b4445591-be0f-4587-aad1-78d74d67fdda
# ╠═e594a510-c8fe-4be7-bce8-ed66f8a7a418
# ╠═054440fb-e606-4268-8858-e0098a1002f2
# ╠═e01eaa63-7e8b-4a0b-9bb0-2f5761e31e0c
# ╠═52eade69-76d9-49c3-bb59-a58bc3a98f51
# ╠═ccc27ca3-3431-4bd2-bf75-6a5453b61398
# ╠═e686ab6d-2b6c-4375-aa8d-c46111181cfb
# ╠═551fc1ec-82c9-48ff-9640-f03ccebff6ad
# ╠═794dc3e5-52f0-4644-82ee-a11abb1842e6
# ╟─5fb2a95a-a5a3-421d-b2df-6c0b415546ec
# ╟─2ed53df9-f79c-4c6f-8caf-48a7f10e36fb
# ╠═fafd9373-e63c-4e96-89af-3e637b650580
# ╠═3d4a0a43-a979-4395-a316-236bc264eb4d
# ╠═c380fd8c-8f29-4623-920d-e2006c3a56b6
# ╠═2b505c78-7d79-4b36-9708-6ae868885733
# ╠═feb28621-971b-445a-b6fc-30c9163f9cf1
# ╠═ec3902a8-cb1c-4f34-8dc3-f30d4953bb96
# ╠═f372638b-3d93-44cd-82ff-d55c6874d788
# ╠═bcbfcc5b-7352-45ac-8eaa-1616fa710fab
# ╠═85b97fb7-33c0-43d0-80f3-58d9de403c3f
# ╠═1effa575-1f95-47cf-9846-25063560dfaf
# ╠═8aea2143-0a22-461b-a08a-0057bb8c4f41
# ╠═2a723f7b-8935-426b-ae1f-a7a8d8b06d5f
# ╠═fff20f14-d3e8-43d2-995c-b603e0fa2626
# ╠═98706b9a-b8a7-4cb9-90e5-9c213b68937c
# ╠═3f901e51-2538-4f3b-8f62-2ed8724442e6
# ╟─2132b9c5-3d7e-493e-a300-652bdd126c59
# ╠═97596ad0-7aad-4dcd-b5d0-e6d0fbee793f
# ╟─21a016af-cd4e-4c9d-9b5f-a43cb1aeafa7
# ╠═883bb52c-915a-49f3-b7a0-36a58f7e1fdc
# ╠═913495d0-f04d-4f43-943b-3e7d02f4004c
# ╠═de939d3b-5575-4c2a-b634-5a128301edcf
# ╠═3e52f2d2-5f9b-413e-9529-55d095862bc7
# ╠═889c9055-3f97-48c6-bb71-5aea11e7dc6f
# ╠═c040e9d4-61e2-4ce7-88e1-6d00416881e4
# ╠═fda49a86-3282-4269-9fb3-c14d66904645
# ╠═77c45ad4-837c-4da0-9c77-5e789115c0a1
# ╠═6e495e1f-2b05-4439-86ed-4a44a049552b
# ╠═9e169fcd-b622-4c1e-adc1-c0004bfee28c
# ╠═a9662e31-2b5e-47ca-b5ca-8f95c65c5852
# ╠═176f7ffb-7c49-43ab-872b-4e319244ec1b
# ╟─435ff7e9-e7d4-4fbc-bb20-29a8e5653506
# ╠═6b0a398c-3314-4de7-a459-f05570692f71
# ╠═793f03d9-f526-4fb0-8ebb-a55c525d98d6
# ╠═7de2e089-2e88-43ff-9f18-21f164e3a3f9
# ╠═9b1298a1-d678-4053-8d24-18d4d6b58113
# ╠═df610ed5-76d0-40ca-9229-449d02a70db5
# ╠═bcffe901-c95d-4667-ac87-e764049ea695
# ╠═95b1808a-a33b-48fe-a3da-9aa15d84c3af
# ╠═a66c2949-1512-4e3d-b43b-5f29c71f1b09
# ╠═92a4317a-c70b-426d-9591-aa68134939ef
# ╠═469432fc-610f-4759-a497-5d301bfd0bed
# ╠═100037ac-8c86-4b52-bc4a-44b5c9e12d36
# ╠═fd85861b-ecba-4609-9464-9c9fae5e4005
# ╠═a1defdcb-e238-4ea8-92f4-a3e2f14c591a
# ╠═40177b0e-1d65-46f8-85bc-3a11b2e57e1f
# ╠═bd06d000-c5a0-4d24-9adc-efb40da3b178
# ╠═b841f888-0f5b-4d69-85ba-9f131a16712e
# ╠═2143c24c-de64-4ce3-8c83-e47aae00f61b
# ╠═656890b3-aaa0-4fe9-909f-b626ecec63cd
# ╠═111ef1d2-8d8e-4839-b3c5-94b4526249e4
# ╠═a196f418-b86c-46f2-90cc-9bedddc1b5fa
# ╟─20038f70-389d-4c2c-88fd-bc2932bb8875
# ╠═52f1d27b-0ceb-472a-af25-59c2b4d3626a
# ╠═85cd31d8-e9b7-4c03-bfa6-baaf75da5058
# ╠═ddcf7eaf-f5eb-436a-8adf-1f272c5c90ce
# ╠═fbdb499e-d781-4240-bc8d-42b8997a7056
# ╠═b3905a46-65f7-486f-baa2-3bf74da02c4b
# ╠═4bd0ebcb-2800-43ba-8443-3a81656aeaa3
# ╠═7db90b7d-e060-4a9b-a6e2-1e0c8a9c7297
# ╠═cd38cbb3-2795-47e5-8131-6862eceff440
# ╠═b49a291a-6f4f-45c6-863c-f6d2d2462217
# ╠═c443a873-3dbc-40d5-8c36-69b8e49f6e54
# ╠═fb384747-edd7-432e-9128-f0d8cbc62130
# ╠═1e4fb4fd-8854-49fa-b958-8da72b54c5fe
# ╠═b29b9861-d0d8-4af6-9111-ab36ae4bdf7b
# ╠═ae851504-0c7c-4a7c-b414-1416a165a8e5
# ╠═6b421e97-9bd0-42d9-9d3a-5221c48a402b
# ╠═0f7eadbc-0e58-412c-991b-0ca4137b9b5f
# ╠═e1f17835-7674-464d-9d61-0b4315383937
# ╠═92fd1c0b-73e9-4a9b-8ab1-7176a2fa23c2
# ╟─d43c770b-b407-4a83-bcfb-30fe01e5ce7a
# ╟─3b572652-fcf7-4f05-8cb6-32840216f7c0
# ╟─457187e1-2f5a-4bfc-ba43-4a7a10dda477
