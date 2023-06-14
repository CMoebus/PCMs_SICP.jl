### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 22907370-fef8-11ed-2fb3-d1536fc68fbd
md"
====================================================================================

#### SICP: 3.3.4.2 Simulator for Digital Circuits: Simulation of Basic Circuits
##### file: PCM20230530\_SICP\_3.3.4.2\_SimulatorForDigitalCircuits.jl
##### Julia/Pluto.jl-code (1.9.0/0.19.25) by PCM *** 2023/06/14 ***

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
###### Circuit: [Half-Adder](https://en.wikipedia.org/wiki/Adder_(electronics)) 
(SICP, Fig.3.25)
The circuit displayed in SICP (Fig.3.25) is only one of several alternatives (Wikipedia: Adder (electornics)). The *truth-table* of the half-adder is:
"

# ╔═╡ 65626b5b-2f62-4de0-a3f3-5bd8812292f6
md"""
|  in1  |  in2  |  sum   | carry-out |
|:------|:------|:-------|:----------|
|   0   |   0   |   0    |     0     |
|   0   |   1   |   1    |     0     |
|   1   |   0   |   1    |     0     |
|   1   |   1   |   0    |     1     |

###### Fig 3.3.4.4.1 *truth-table of the half-adder*
---
"""

# ╔═╡ 932edff1-9a4c-4c2c-a950-7ddd51406763
md"
---
###### Circuit: Full-Adder 
(SICP, Fig.3.26)
The circuit displayed in SICP (Fig.3.26) is only one of several alternatives (Wikipedia: Adder (electornics)). The *truth-table* of the full-adder is:
"

# ╔═╡ 7f82829a-661c-4ae5-9101-1d100a2cb36c
md"""
|  in1  |  in2  | c-in | sum | c-out |
|:------|:------|:-----|:----|:------|
|   0   |   0   |   0  |  0  |   0   |
|   0   |   1   |   0  |  1  |   0   |
|   1   |   0   |   0  |  1  |   0   |
|   1   |   1   |   0  |  0  |   1   |
|  ___  |  ___  |  ___ | ___ |  ___  |
|   0   |   0   |   1  |  1  |   0   |
|   0   |   1   |   1  |  0  |   1   |
|   1   |   0   |   1  |  0  |   1   |
|   1   |   1   |   1  |  1  |   1   |

###### Fig 3.3.4.4.2 *truth-table of the full-adder*
---
"""

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

# ╔═╡ 2ed53df9-f79c-4c6f-8caf-48a7f10e36fb
md"
The *agenda* is a *list of queues*. An example of a typical agenda is here (Guowei Lv; [https://www.lvguowei.me/img/agenda.png](https://www.lvguowei.me/img/agenda.png)) 
"

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

# ╔═╡ 7636a9d4-04fd-4ff0-a3a9-1821b05d5d0d
md"
---
###### Simulation of Half-adder
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
function halfAdder(a, b, s, c, agenda)
	let d = makeWire()
		e = makeWire()
		#---------------------------
		orGate(a, b, d, agenda)
		andGate(a, b, c, agenda)
		inverter(c, e, agenda)
		andGate(d, e, s, agenda)
		#---------------------------
		"halfAdder ==> ok"
	end # let
end # function halfAdder

# ╔═╡ 4609eeda-38fc-4c8d-8c3f-5e616e8fb975
function fullAdder(a, b, cIn, sum, cOut, agenda)
	let s  = makeWire()
		c1 = makeWire()
		c2 = makeWire()
		#---------------------------
		halfAdder(b, cIn,  s, c1, agenda)
		halfAdder(a, s, sum, c2, agenda)
		orGate(c1, c2, cOut, agenda)
		#---------------------------
		"fullAdder ==> ok"
	end # let
end # function halfAdder

# ╔═╡ 3098e180-4654-4d42-859c-dce683a61c2f
halfAddAgenda = makeAgenda()

# ╔═╡ 4ba2f32c-3cc5-40b0-a771-3d3548b4c0e8
pp(halfAddAgenda)        # ==> (0) -->  :)

# ╔═╡ 93f2d63a-c17f-4720-88cb-d2b21bfc3816
in1 = makeWire()

# ╔═╡ 471a8445-8c0d-4089-8d56-cfb9dea00e52
in2 = makeWire()

# ╔═╡ ca27081e-3b59-4c00-b4a9-450535d89ed3
sum = makeWire()

# ╔═╡ 3ab4d3fa-326c-4e74-a05e-e1717fe715f3
carry = makeWire()

# ╔═╡ 41ddb72e-9d52-4c43-9ab8-7530f0fdbce9
probe(1, :sum, sum, halfAddAgenda)  # ==>
# "number = 1, wireName = sum, currentTime = 0, newValue = 0"

# ╔═╡ 47d87d2c-3c14-4b6a-919f-53c0b0fda4bb
probe(2, :carry, carry, halfAddAgenda)  # ==>
# "number = 2, wireName = carry, currentTime = 0, newValue = 0"

# ╔═╡ e5576eff-beda-43b0-844a-4423f523b474
halfAdder(in1, in2, sum, carry, halfAddAgenda) # ==> "halfAdder ==> ok"

# ╔═╡ 2aaace3e-326d-4b4f-9071-d1150d6fb545
setSignal!(in1, 1)                             # ==> "setMySignal! ==> done"

# ╔═╡ c32aad51-db70-4909-a7fe-307adebcc98d
pp(halfAddAgenda)  # ==>
# (0, 2, (#10), #10), (3, (#13, #13, #13, #13, #13), #13), (5, (#16, #16, #16), #16))

# ╔═╡ 13a440d9-00e8-480c-8de1-a90d71bcd0ac
propagate(halfAddAgenda)  # ==> "propagate ==> done"

# ╔═╡ b28f4e7e-0693-44c2-af80-2a7f0f3abfcb
pp(halfAddAgenda)         # ==> (8) -->  :)

# ╔═╡ c4170055-39ef-47aa-ac13-4173a4f97a71
probe(8, :sum, sum, halfAddAgenda)      # ==>
# "number = 8, wireName = sum, currentTime = 8, newValue = 1"   --> :)

# ╔═╡ 38bc1bcf-beb7-4126-84b5-c16663450e9d
probe(9, :carry, carry, halfAddAgenda)  # ==>
# "number = 9, wireName = carry, currentTime = 8, newValue = 0" --> :)

# ╔═╡ cdd380d6-b406-4d83-b066-5c7bbe25d985
setSignal!(in2, 1)                             # ==> "setMySignal! ==> done"

# ╔═╡ efc1d088-2b99-4880-938c-1be98685be64
propagate(halfAddAgenda)                       # ==> "propagate ==> done"

# ╔═╡ df1431f6-04ea-42f6-98b9-0f96010b9bd8
pp(halfAddAgenda)                              # ==> (16)  -->  :)

# ╔═╡ 0d49b8d1-faa3-42bf-b589-14cc83d61c4f
probe(16, :sum, sum, halfAddAgenda)            # ==>
# "number = 16, wireName = sum, currentTime = 16, newValue = 0" -->  :)

# ╔═╡ ca29d3a1-f002-40bf-a903-9747616cd9af
probe(16, :carry, carry, halfAddAgenda)        # ==>
# "number = 16, wireName = carry, currentTime = 16, newValue = 1"  --> 

# ╔═╡ 11e514eb-f533-4d56-a092-bb0c4c3d1007
pp(halfAddAgenda)                              # ==> (16)  -->  :)

# ╔═╡ dfd6524d-6f2a-4d89-ad35-0099d84cd025
md"
---
###### Simulation of Full-adder
"

# ╔═╡ b5d1645e-07f2-4e99-aaa4-9f544a50b8dc
fullAddAgenda = makeAgenda()

# ╔═╡ 6ee3f587-2d88-4d24-b349-db13c2ce62db
pp(fullAddAgenda)        # ==> (0) -->  :)

# ╔═╡ 5e35f0b0-ab9d-4d16-8fed-14111c657d17
inF1 = makeWire()

# ╔═╡ 7f50e2e9-17b2-4255-9970-afbf84743fb7
inF2 = makeWire()

# ╔═╡ a7358bcd-2d5f-41ba-8838-c7ceca1c2219
cInF = makeWire()

# ╔═╡ feb93ad8-61e7-440c-8b71-c5a41b60fce1
sumF = makeWire()

# ╔═╡ 5b09a9bf-0512-4c33-896c-464cf0f5355f
cOutF = makeWire()

# ╔═╡ 8306d459-e3cc-4e70-a9d8-b9c0fe306c23
probe(1, :sumF, sumF, fullAddAgenda)  # ==>
# "number = 1, wireName = sumF, currentTime = 0, newValue = 0"

# ╔═╡ 2713d963-922b-46a8-8fbd-281cfd8d3853
probe(2, :cOutF, cOutF, fullAddAgenda)  # ==>
# "number = 2, wireName = cOutF, currentTime = 0, newValue = 0"

# ╔═╡ c18838a8-9ded-4ce5-ac1a-172ef6eba5e5
fullAdder(inF1, inF2, cInF, sumF, cOutF, fullAddAgenda) # ==> "fullAdder ==> ok"

# ╔═╡ d51e9e5c-5c5a-4999-a4f4-778051eed525
setSignal!(inF1, 1)                             # ==> "setMySignal! ==> done"

# ╔═╡ c39da95d-62b1-4331-b6a8-5a952c1acf11
pp(fullAddAgenda)  # ==>
# (0, 2, (#10, #10, #10, #10), #10), (3, (#13, #13, #13, #13,..., #13), #13), (5, (#16, #16, ..., #16), #16))

# ╔═╡ dd833c6a-a3b3-4704-a1bb-2b29612406e7
propagate(fullAddAgenda)  # ==> "propagate ==> done"

# ╔═╡ 7a45b7de-7e37-4c05-9490-74284604874f
pp(fullAddAgenda)         # ==> (8) -->  :)

# ╔═╡ 22b4fec7-b32a-4433-bf7e-aaab4b485023
probe(8, :sumF, sumF, fullAddAgenda)             # ==>
# "number = 8, wireName = sumF, currentTime = 8, newValue = 1"   --> :)

# ╔═╡ 524912f6-c848-421d-916e-a2d19b790392
probe(9, :cOutF, cOutF, fullAddAgenda)  # ==>
# "number = 9, wireName = cOutF, currentTime = 8, newValue = 0"

# ╔═╡ b58f2525-c4d0-4cd9-ab20-16c80f12926c
setSignal!(cInF, 1)                             # ==> "setMySignal! ==> done"

# ╔═╡ 4dfb7e05-cafe-46c5-be0d-6c68388719e3
propagate(fullAddAgenda)                        # ==> "propagate ==> done"

# ╔═╡ d3b0155f-4a4e-4256-be75-026ead57123b
pp(fullAddAgenda)                               # ==> (24)  -->  :)

# ╔═╡ 0ecab7bf-934c-4cc3-babe-dc3b32bf9851
probe(24, :sumF, sumF, fullAddAgenda)           # ==>
# "number = 24, wireName = sumF, currentTime = 24, newValue = 0" -->  :)

# ╔═╡ 99e6ef5d-2f09-4b9e-999c-a8ec083247e7
probe(24, :cOutF, cOutF, fullAddAgenda)         # ==>
# "number = 24, wireName = cOutF, currentTime = 24, newValue = 1" --> :)

# ╔═╡ de0426cb-d287-4a1e-849e-5750aeb741b2
pp(fullAddAgenda)                              # ==> (24)  -->  :)

# ╔═╡ d43c770b-b407-4a83-bcfb-30fe01e5ce7a
md"
---
##### References

- **Wikipedia**; *Adder(electronics)*, [https://en.wikipedia.org/wiki/Adder_(electronics)](https://en.wikipedia.org/wiki/Adder_(electronics)); last visit, 2023/06/14

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
# ╟─bf845b28-83ca-46e9-9d70-876e75516008
# ╟─4ed0fb98-d7cd-4efc-9543-d63b6517684b
# ╟─03e5855d-a4cf-4fce-971b-a38e3dec2653
# ╠═25149de2-9d94-4f9e-a51a-d41355fea192
# ╟─f322f132-cc45-4753-9640-024df2688dea
# ╟─c00fedaa-6bd3-4cad-9843-c0e9d1689549
# ╠═2ed04385-33e7-483a-be5a-250b34ef16b8
# ╠═c81b9fad-dbb4-4e9a-b41b-ef361aa42645
# ╟─de265e3b-9a06-49e8-bd23-ef93c783aa38
# ╟─034ce3ad-3282-4e5c-ba5f-447dd8b2aa5f
# ╟─6d834cc3-fd8e-41b7-8421-8d0b8c641ab1
# ╟─f63239f5-f5ee-49e7-8fe7-5f702aea971f
# ╠═7edee29e-547b-453b-b43e-3c0eff63aaa9
# ╟─9645e074-4dc3-4269-b4a5-e9efc5d42054
# ╟─a9467ed9-931e-43ba-84dc-ccd5ed9ccd9b
# ╠═9638642d-89d6-4648-bce9-84e99f6fec27
# ╟─ee13f381-11cf-4b6f-937c-c6ffde6550e3
# ╠═6b1a1ea5-1e11-45e1-b0f9-1ed4aca98b45
# ╟─3bc72ea2-c0dd-44e0-a104-d0c9c9c0b0a0
# ╠═51340a5e-f525-47ac-8b2e-3a50bd83af24
# ╠═02cbd75f-74d5-4160-9b9d-cd69ea4eb7d4
# ╟─f1917f7e-7e74-4b96-a4df-f72cabb896c3
# ╟─dd88c337-0eda-4ed9-9b82-a2cb8d1c48d5
# ╠═fdb7f91a-3622-4c42-9883-7e94032ca607
# ╠═91577057-4c41-4eb9-8766-571584264073
# ╟─c8a056e0-444f-435a-8fce-2cc100d686e8
# ╟─07163ded-3e3b-4cba-a5fd-b6d8cf1f7c5b
# ╟─41fdbb86-c059-4758-8b25-e6a369a91d9d
# ╟─395a4f66-4b68-4484-9539-8460645918a0
# ╟─3df31ea8-2b86-4411-8acd-019898d9ab78
# ╠═024520aa-3204-4f5f-81e6-e375fadb59d7
# ╟─f605bccd-5d2b-4417-9d64-a6cea6bc1780
# ╟─09137ca6-5e28-49b1-9899-8cc400e1c2cc
# ╠═02516da6-7eb9-45b6-8513-27ffb8532fd3
# ╠═ac5499b9-9ece-47e0-9c01-6b338c5d3dd0
# ╠═778b1afe-a6f5-4481-9943-e78e3f8b7236
# ╠═6ccb7717-0b49-4b67-99c2-ed5d606174d0
# ╠═67036f78-ce30-4204-88c1-3ddd8570f0c8
# ╠═fb23f9b1-3d1b-4eb8-932f-7074f85b9bde
# ╟─7ac8d855-a27a-43f7-879d-8c75925ee309
# ╠═6e883562-bedf-4ff1-99fb-f37bd0736aa1
# ╠═0ca67d73-9d82-4bf3-a197-30bb0a4df9e7
# ╟─809c1078-c9da-45f3-bfe0-e24289fed597
# ╟─23332628-dc26-4ca9-a28a-10ba64d5f725
# ╟─6d7cab1c-e3be-4305-bd83-eaea9f9987bf
# ╟─e2b4876e-d786-4d09-b1ba-b7d81ca8094a
# ╟─a2d20357-e08f-49df-aa0d-650f97637c36
# ╟─b74d0c0a-bd42-4bc9-9ad8-e8ab076c4f0a
# ╟─e447b533-f3d7-495e-9262-ff056721c704
# ╟─3d6923aa-08ee-4fb7-8707-af865b6fc539
# ╟─65626b5b-2f62-4de0-a3f3-5bd8812292f6
# ╠═ef83722a-8893-4f13-be5a-a951dc6c531d
# ╟─932edff1-9a4c-4c2c-a950-7ddd51406763
# ╟─7f82829a-661c-4ae5-9101-1d100a2cb36c
# ╠═4609eeda-38fc-4c8d-8c3f-5e616e8fb975
# ╟─07871aff-905b-4718-b7e9-1f0de462238a
# ╟─bafe623c-0315-476a-85ba-006a4e9ebd86
# ╠═9ebd2ce6-a832-4363-ac91-b55f53e37688
# ╠═0efb92e2-1f41-4fd2-a241-e26987373bdb
# ╠═4569422d-3e40-4b8d-9d58-fdb78fc21908
# ╠═dfc0a0b4-0a06-4139-bb9d-084eec58b87d
# ╟─cdda9aed-3217-4ec4-8938-ff207ea3da9e
# ╟─e414fcbd-64bd-43c2-b768-25b40d779d89
# ╟─937a5155-b761-443b-9115-4222082f2ff4
# ╟─3ddec46f-1cfc-4305-b6eb-68ecdec73da2
# ╟─f177c735-fc16-4710-889f-aa8c7ac7346b
# ╟─f187b113-d6b5-479e-b956-e5b3f908c1f4
# ╟─31f4e594-c77f-4fcc-9a14-3a3dcb20c2dd
# ╟─b513fc9f-fd7b-462b-95c7-6d9f8b649366
# ╟─e2135618-97e2-4608-a71f-97084e118e40
# ╟─ef530d6e-5840-484b-945e-14265718b67f
# ╟─2f8c3246-4234-47d4-8cce-ef65a609d986
# ╟─b066241d-633d-48d0-b471-3acced1d7928
# ╟─49c0ec59-f4bb-4fca-8a9a-97b4d92ef994
# ╟─cbb46467-f284-4ef8-85a8-3f4d69739c79
# ╟─373ec031-b5f6-45c9-9d04-61989e9ad2a0
# ╟─2ed53df9-f79c-4c6f-8caf-48a7f10e36fb
# ╟─2132b9c5-3d7e-493e-a300-652bdd126c59
# ╠═97596ad0-7aad-4dcd-b5d0-e6d0fbee793f
# ╟─7636a9d4-04fd-4ff0-a3a9-1821b05d5d0d
# ╠═883bb52c-915a-49f3-b7a0-36a58f7e1fdc
# ╠═6b0a398c-3314-4de7-a459-f05570692f71
# ╠═52f1d27b-0ceb-472a-af25-59c2b4d3626a
# ╠═3098e180-4654-4d42-859c-dce683a61c2f
# ╠═4ba2f32c-3cc5-40b0-a771-3d3548b4c0e8
# ╠═93f2d63a-c17f-4720-88cb-d2b21bfc3816
# ╠═471a8445-8c0d-4089-8d56-cfb9dea00e52
# ╠═ca27081e-3b59-4c00-b4a9-450535d89ed3
# ╠═3ab4d3fa-326c-4e74-a05e-e1717fe715f3
# ╠═41ddb72e-9d52-4c43-9ab8-7530f0fdbce9
# ╠═47d87d2c-3c14-4b6a-919f-53c0b0fda4bb
# ╠═e5576eff-beda-43b0-844a-4423f523b474
# ╠═2aaace3e-326d-4b4f-9071-d1150d6fb545
# ╠═c32aad51-db70-4909-a7fe-307adebcc98d
# ╠═13a440d9-00e8-480c-8de1-a90d71bcd0ac
# ╠═b28f4e7e-0693-44c2-af80-2a7f0f3abfcb
# ╠═c4170055-39ef-47aa-ac13-4173a4f97a71
# ╠═38bc1bcf-beb7-4126-84b5-c16663450e9d
# ╠═cdd380d6-b406-4d83-b066-5c7bbe25d985
# ╠═efc1d088-2b99-4880-938c-1be98685be64
# ╠═df1431f6-04ea-42f6-98b9-0f96010b9bd8
# ╠═0d49b8d1-faa3-42bf-b589-14cc83d61c4f
# ╠═ca29d3a1-f002-40bf-a903-9747616cd9af
# ╠═11e514eb-f533-4d56-a092-bb0c4c3d1007
# ╟─dfd6524d-6f2a-4d89-ad35-0099d84cd025
# ╠═b5d1645e-07f2-4e99-aaa4-9f544a50b8dc
# ╠═6ee3f587-2d88-4d24-b349-db13c2ce62db
# ╠═5e35f0b0-ab9d-4d16-8fed-14111c657d17
# ╠═7f50e2e9-17b2-4255-9970-afbf84743fb7
# ╠═a7358bcd-2d5f-41ba-8838-c7ceca1c2219
# ╠═feb93ad8-61e7-440c-8b71-c5a41b60fce1
# ╠═5b09a9bf-0512-4c33-896c-464cf0f5355f
# ╠═8306d459-e3cc-4e70-a9d8-b9c0fe306c23
# ╠═2713d963-922b-46a8-8fbd-281cfd8d3853
# ╠═c18838a8-9ded-4ce5-ac1a-172ef6eba5e5
# ╠═d51e9e5c-5c5a-4999-a4f4-778051eed525
# ╠═c39da95d-62b1-4331-b6a8-5a952c1acf11
# ╠═dd833c6a-a3b3-4704-a1bb-2b29612406e7
# ╠═7a45b7de-7e37-4c05-9490-74284604874f
# ╠═22b4fec7-b32a-4433-bf7e-aaab4b485023
# ╠═524912f6-c848-421d-916e-a2d19b790392
# ╠═b58f2525-c4d0-4cd9-ab20-16c80f12926c
# ╠═4dfb7e05-cafe-46c5-be0d-6c68388719e3
# ╠═d3b0155f-4a4e-4256-be75-026ead57123b
# ╠═0ecab7bf-934c-4cc3-babe-dc3b32bf9851
# ╠═99e6ef5d-2f09-4b9e-999c-a8ec083247e7
# ╠═de0426cb-d287-4a1e-849e-5750aeb741b2
# ╟─d43c770b-b407-4a83-bcfb-30fe01e5ce7a
# ╟─3b572652-fcf7-4f05-8cb6-32840216f7c0
# ╟─457187e1-2f5a-4bfc-ba43-4a7a10dda477
