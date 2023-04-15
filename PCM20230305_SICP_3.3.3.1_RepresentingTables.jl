### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 15cad150-bb4e-11ed-2a31-f366dd23123a
md"
====================================================================================
#### SICP: 3.3.3.1 [Representing Tables](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e3)
##### file: PCM20230305\_SICP\_3.3.3.1\_RepresentingTables.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/04/15 ***

====================================================================================

"


# ╔═╡ 38f34b6f-c119-4eae-897f-4fab0f2613dd
md"
###### Types
"

# ╔═╡ 1f62eb60-7592-4880-8f86-51d9e2ea95f7
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ 5d422679-72be-4913-ae98-32dd50f2accf
md"
---
##### 3.3.3.1.1 Scheme-like Julia
"

# ╔═╡ 99e6a4da-857b-4e05-b733-8459cadcd782
md"
---
###### Constructors
"

# ╔═╡ 6ef86571-3019-4598-ae53-ed1d9b8b8ea2
mutable struct Cons
	car
	cdr
end

# ╔═╡ fc1cf117-5d7f-4d32-9409-086973a15188
AtomConsTuple = Union{Atom, Cons, Tuple}

# ╔═╡ 8c945614-ccbf-4af7-931e-735fbe20755c
# idiomatic Julia with 1st (default) method of cons
cons(car::Any, cdr::Any)::Cons = Cons(car, cdr)::Cons   

# ╔═╡ 4876b9e3-edb2-464a-b926-29cc6d2b30ea
list(elements::Atom...) =
	elements == () ? cons(elements, :nil) :                # --> new line
	lastindex(elements) == 1 ? cons(elements[1], :nil) :
		cons(elements[1], list(elements[2:end]...))

# ╔═╡ 1f50fec5-6a4d-4273-ab77-66b4c367a552
list(elements::AtomConsTuple...) =                        # --> new method
	elements == () ? cons(elements, :nil) :
	lastindex(elements) == 1 ? cons(elements[1], :nil) :
		cons(elements[1], list(elements[2:end]...))

# ╔═╡ 5040923a-1c5e-46a0-a2f6-f9db4a4b02bc
list(1, 2, 3)

# ╔═╡ 45fdd982-618b-4349-b023-632a32bd1055
list(1, (2, 3))

# ╔═╡ c45e82b6-4cc2-4347-bbf0-88f3bb97cde8
typeof(cons(1,2))

# ╔═╡ f23cbf53-705d-4cb7-bcd9-016c8c2e92a8
list(1, cons(2, 3))     # should be ==> (1, (2, 3))

# ╔═╡ a63183ab-5a1c-4489-8a10-313bb247c651
md"
---
###### Selectors
"

# ╔═╡ d8613a32-9f42-4ed9-8ded-03e05cd30376
# 1st method for car
car(cell::Cons) = cell.car

# ╔═╡ 1debf96e-e34e-4017-8fa9-7f23b2aa855e
caar(cell::Cons) = car(car(cell::Cons)::Cons)

# ╔═╡ 587286fa-d302-414e-9e2f-949bf5aed0c6
cdr(cell::Cons)::Any = cell.cdr

# ╔═╡ b0b3f700-8d6f-42ce-9ea4-0270f76aff7a
md"
---
###### Mutator
"

# ╔═╡ a1a1e8b4-a985-4581-8a96-6c56b80aff55
function setCar!(cons::Cons, car) 
	cons.car = car
	cons
end # setCar!

# ╔═╡ aa58ad1b-d8b7-47a6-b3fb-1466380d74ad
function setCdr!(cons::Cons, cdr) 
	cons.cdr = cdr
	cons
end # setCdr!

# ╔═╡ 8d605bad-0cd0-4154-b5ba-8ecdaa16a66f
md"
---
###### Outputs
"

# ╔═╡ ff398b01-a623-4729-b2ae-f3fde77a2ea9
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

# ╔═╡ 6e54aa2b-0cc3-4fcd-b718-4f60815537f3
pp(list(1, 2, 3))

# ╔═╡ f8ff4f6b-dd7d-45f8-a44b-af1f2e268a63
pp(list(1, cons(2, 3)))

# ╔═╡ 5916fe02-b9ac-4ff0-842e-c423fae6a7e1
md"
---
###### Applications
"

# ╔═╡ ad11651a-4cd8-4be4-af9c-736ca703faa9
l1 = cons(:one, cons("two", :nil))

# ╔═╡ 862095a5-d40c-43a8-85e8-51d49338ceb1
pp(l1)

# ╔═╡ 4c4f4b37-2d06-4255-b015-5f5ec513dff1
l2 = list(:one, "two", :nil)

# ╔═╡ 25c92431-3e90-4d04-97cb-6cd838b61430
pp(l2)

# ╔═╡ 92eec5ec-035f-4d15-a162-0e5e149485e3
pp(cons(:a, :b))                        # should be ==> (:a . :b)

# ╔═╡ e16592ec-7fbe-4d89-a572-7bfe4fd50ca0
md"
---
##### 3.3.3.1.1.1 One-dimensional tables
"

# ╔═╡ 2dbdf842-7d2c-4fdf-8c41-7950474cae95
md"
###### Constructor
"

# ╔═╡ 3a4ff6ad-de89-4c53-8752-b6312aaac44a
makeTable(;label="*table*") = list(label)

# ╔═╡ 0f7f51b8-c00a-4fb6-927c-650e65ab57a0
md"
---
###### Selectors
"

# ╔═╡ e7b74d62-3c9c-4f93-8d21-54061d9c2cc7
function assoc(key, records)
	if (records == ()) || (records == :nil) 
		false                                     # if records 'empty' then 'false'
	elseif key == caar(records)                   # otherwise, found
		car(records)      
	else
		assoc(key, cdr(records))                  # otherwise look further
	end # if
end # function assoc

# ╔═╡ ff400772-5721-46b0-a452-14eb6bcf4067
# 1st method of insert! for 1-dim tables
#--------------------------------------------------------------------------------
function insert!(key, value, table)
	let record = assoc(key, cdr(table))
		if record == false
			setCdr!(table, cons(cons(key, value), cdr(table)))
		else
			setCdr!(record, value)
		end # if
	end # let
	"ok, inserted"
end # function insert!

# ╔═╡ c7f318e2-860c-4836-b5e6-8c74c7b2dc3b
# 1st method of lookup for 1-dim tables
#-----------------------------------------------------------------------------
function lookup(key, table)
	let record = assoc(key, cdr(table))
		if (record !== false)  
			cdr(record) 
		else
			false
		end # if
	end # let
end # function lookup

# ╔═╡ 620b1e98-c0d6-436d-8354-145b80f65db2
md"
---
###### [Fig. 3.22, SICP, 1996, p.267](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e3))
"

# ╔═╡ 758a8fef-3323-405c-8a2f-9d3e1d280b06
myTable01 = makeTable() 

# ╔═╡ e65c422f-262e-4deb-a474-19b934a3584d
myTable01

# ╔═╡ e12c0b0a-77bd-4523-a06e-175244630e0c
assoc(:c, cdr(myTable01))

# ╔═╡ b759d5b4-1e1c-4d5b-afa0-fabfaa3aef31
assoc(:c, cdr(myTable01))

# ╔═╡ facfd58c-43a5-4afd-b642-3aa7be21cea9
myTable01

# ╔═╡ 8d154947-93af-4143-9099-9b9a93919d00
pp(myTable01)                                     # Fig.3.22, SICP, 1966, p.267

# ╔═╡ f1b12259-5c53-4781-93a1-5b0fda0a7ac0
md"
---
##### 3.3.3.1.1.2 Two-dimensional table
"

# ╔═╡ df55aa17-c80e-48c2-92c9-723486a6f057
md"
###### Selector
"

# ╔═╡ 9fc7cfa0-1ba5-4882-8c4c-dcb38532ccfa
# 2nd method of lookup for 2-dim tables
#-----------------------------------------------------------------------------
function lookup(key1, key2, table)
	let subtable = assoc(key1, cdr(table))
		if subtable == false
			false
		else
			let record = assoc(key2, cdr(subtable))
				if record == false
					false
				else
					cdr(record)
				end # if
			end # let
		end # if
	end # let
end # function

# ╔═╡ 656e2d72-6073-4d08-9f44-6256e5807b52
lookup(:c, myTable01)

# ╔═╡ 5fea4a3c-e942-443a-bfb2-66ce8da83a5d
md"
---
###### Constructor
"

# ╔═╡ d5bf565d-f09d-4ca9-85ab-7646e8c817bd
# 2nd method of insert! for 2-dim tables
#--------------------------------------------------------------------------------
function insert!(key1, key2, value, table)  
	let subtable = assoc(key1, cdr(table))
		if subtable == false
			setCdr!(table, cons(list(key1, cons(key2, value)), cdr(table)))
		else
			let record = assoc(key2, cdr(table))
				if record == false 
					setCdr!(subtable, cons(cons(key2, value), cdr(subtable)))
				else
					setCdr!(record, value) 
				end # if
			end # let record
		end # if
	end # let subtable
	"ok, inserted"
end # function insert!

# ╔═╡ ee3a76e3-46c6-4d55-965a-287d7c568154
insert!(:c, 3, myTable01)

# ╔═╡ d8c00175-d17e-4355-910e-35fa18827766
insert!(:b, 2, myTable01)

# ╔═╡ 86c06e2e-7695-45e8-9c6a-dcf4fced5982
insert!(:a, 1, myTable01)

# ╔═╡ 202a13ed-464d-4766-a51b-dfc0a4db9d7f
md"
---
###### [Fig. 3.23 (SICP, 1996, p.269)](https://sarabander.github.io/sicp/html/3_002e3.xhtml#g_t3_002e3_002e3)
"

# ╔═╡ ee840950-5015-4668-8e0b-256db252b983
myTable02 = makeTable()

# ╔═╡ 12fe5c00-d870-4b8c-8a78-006364687ebb
assoc(:math, cdr(myTable02))

# ╔═╡ c65abe03-e4a3-49d6-9eba-203224e91f27
insert!(:math, :+, 43, myTable02)

# ╔═╡ b7fa135b-970e-4d8d-bfaa-7936012607b8
insert!(:math, :-, 45, myTable02)

# ╔═╡ f528b96a-c9a7-4a70-9782-b37c9d919765
insert!(:math, :*, 42, myTable02)

# ╔═╡ ef229b5c-5b4e-41d0-8fcf-927558c1e3f0
insert!(:letters, :a, 97, myTable02)

# ╔═╡ c0503002-7a37-473d-b182-02d66e92fbd7
insert!(:letters, :b, 98, myTable02)

# ╔═╡ ec8394e1-faec-448c-a12a-08b11d64d4ba
myTable02

# ╔═╡ c24a0ca3-bf5a-40ae-99e0-5178fe9d66c8
pp(myTable02)

# ╔═╡ 9d627fe4-14fc-4f36-84b8-b4c614219fab
lookup(:math, :+, myTable02)

# ╔═╡ 7be8db73-5218-4bbb-955d-bffc90fc4921
assoc(:math, cdr(myTable02))

# ╔═╡ bcf8a49c-39cc-4921-8f5c-a194e0ddbfac
pp(assoc(:math, cdr(myTable02)))

# ╔═╡ 1a36db29-ffc9-4668-ab10-a9c16e3e6d7f
assoc(:+, cdr(assoc(:math, cdr(myTable02))))

# ╔═╡ a88e8d8a-8672-4a2f-95d3-6603d613c2d9
lookup(:math, :-, myTable02)

# ╔═╡ b2005f50-cf10-41f5-b690-fea51a884f99
lookup(:math, :*, myTable02)

# ╔═╡ 1eae1ca8-fd6f-43d5-8ef0-c6b4fc9f39f3
lookup(:letters, :a, myTable02)

# ╔═╡ 6cfaed65-a0ca-4f9b-96d1-930189443544
lookup(:letters, :b, myTable02)

# ╔═╡ ae7a165a-5843-494f-9a10-5e7e5e5aa466
md"
---
##### 3.3.3.1.1.3 Creating local tables (table objects)
"

# ╔═╡ f5afb899-d419-4788-bcd7-5bb9d803988c
function makeTableObject(;label="*table*")
	let localTable = list(label)
		#----------------------------------------------------------------------------
		function lookup(key1, key2)
			let subtable = assoc(key1, cdr(localTable))
				if subtable == false
					false
				else
					let record = assoc(key2, cdr(subtable))
						if record == false
							false
						else
							cdr(record)
						end # if
					end # let
				end # if
			end # let
		end # function lookup
		#----------------------------------------------------------------------------
		function insert!(key1, key2, value)  
			let subTable = assoc(key1, cdr(localTable))
				if subTable == false
					setCdr!(
						localTable, cons(
							list(key1, cons(key2, value)),  
							cdr(localTable)))
				else
					let record = assoc(key2, cdr(subTable))
						if record == false 
							setCdr!(subTable, cons(cons(key2, value), cdr(subTable)))
						else
							setCdr!(record, value) 
						end # if
					end # let record
				end # if
			end # let subTable
			"ok, inserted"
		end # function insert!
		#----------------------------------------------------------------------------
		function dispatch(message)
			message == :lookup  ? lookup  :        # modified to SICP
			message == :insert! ? insert! :        # modified to SICP
			error("Unknown message $message-- TABLE")
		end # function dispatch
		#----------------------------------------------------------------------------
		dispatch
	end # let
	#--------------------------------------------------------------------------------
end # function makeTableObject

# ╔═╡ c225dea2-613b-4e6c-bdac-51b3388136bf
myTable05 = makeTableObject()                      # modified to SICP

# ╔═╡ bf3d7ccc-6278-4b3f-954c-9a61d34b07bd
myTable05(:lookup)(:math, :+)                      # modified to SICP

# ╔═╡ 938b2d0f-a1ed-4a0a-9d92-c28674e038e1
myTable05(:insert!)(:math, :+, 43)                 # modified to SICP

# ╔═╡ b5cd96f7-9945-4f31-b76b-ca00b2ad2917
myTable05(:lookup)(:math, :+)

# ╔═╡ c2a3ec7a-2dd3-4bd6-a3fe-88e2d2f2fb8f
myTable05(:insert!)(:math, :-, 45)

# ╔═╡ ec8b76aa-02a7-4f92-8f8d-4faaf9d410e7
myTable05(:insert!)(:math, :*, 42)

# ╔═╡ 4a2d95cd-4288-41b7-9aa9-7d83ab5e0dd0
myTable05(:insert!)(:letters, :a, 97)

# ╔═╡ 98c7256b-0667-4d2e-bca0-fe24f63e1733
myTable05(:insert!)(:letters, :b, 98)

# ╔═╡ 18a10807-4f6b-4739-8515-e1bb4f1ec7da
myTable05(:insert!)(:math, :+, 43)   # redundant entry

# ╔═╡ 14c40087-4fbd-48a2-b479-b358dfd1e00b
myTable05

# ╔═╡ 77074a17-7e95-4b11-95e2-652575e98e84
myTable05(:lookup)(:math, :+)

# ╔═╡ 571ddc7a-ce7e-4559-b044-1bfb3f54fc88
myTable05(:lookup)(:math, :-)

# ╔═╡ 1eb4322f-2b7f-4497-96dc-cb65814cf58c
myTable05(:lookup)(:math, :*)

# ╔═╡ 16801fbb-5786-4400-a5fa-b23fd483abba
myTable05(:lookup)(:letters, :a)

# ╔═╡ 4747c42b-ccf2-497b-8c45-05b9db52a7d4
myTable05(:lookup)(:letters, :b)

# ╔═╡ 924bb598-7df2-4c6a-9c5a-66fa64c5a66d
md"
---
##### 3.3.3.1.2 Idiomatic Julia
"

# ╔═╡ 7ada7382-3f60-4267-8aff-43bfc3462844
md"
##### 3.3.3.1.2.1 One-dimensional tables
"

# ╔═╡ 927ca1b1-0e5d-405b-8f2a-38b1d3088b19
md"
###### Constructor
"

# ╔═╡ b36b8e47-e4a0-4506-bb7a-fe3288269f1f
makeTableDict() = Dict()

# ╔═╡ 57b025ab-768d-4d49-9f8a-6d122b11bb62
# 1st method of insertDict! for 1-dim tables
#--------------------------------------------------------------------------------
function insertDict!(key, value, table)
	table[key] = value
end # function insertDict!

# ╔═╡ 8d14a820-43bd-494a-a460-f1a433ca48ff
md"
###### Selector
"

# ╔═╡ 18fbd593-97ba-4217-837a-db88ca760206
# 1st method of lookupDict! for 1-dim tables
#--------------------------------------------------------------------------------
function lookupDict(key, table) 
	get(table, key, "no such found")
end # function lookupDict

# ╔═╡ d704869f-c532-40a8-b1b8-0bb40b2e3b06
md"
---
###### Applications
"

# ╔═╡ d8721df7-4b97-4858-96e4-fd7f3a1a7c89
myTable03 = makeTableDict()

# ╔═╡ c44a358e-793b-4bcd-8fbd-18219fcfc588
typeof(myTable03)

# ╔═╡ 36010552-598b-4c70-97a8-b3797660a743
myTable03

# ╔═╡ f74ffedf-d734-4fea-82e3-8a0b803cb239
md"
---
##### 3.3.3.1.2.2 Two-dimensional tables
"

# ╔═╡ f5520fbc-7e8d-4147-a2b1-c85907869f67
md"
###### Constructor
"

# ╔═╡ b6a58efe-2210-4814-9799-62d0747cb7b9
makeTableDict2() = Dict{Tuple, Int64}()

# ╔═╡ fa66c233-1ea3-4969-befb-6ebf27a58f54
# 2nd method of insertDict! for 2-dim tables
#--------------------------------------------------------------------------------
function insertDict!(key1, key2, value, table)
	table[(key1, key2)] = value
end # function insertDict!

# ╔═╡ 57fec436-539c-43f9-ba78-e3bf837921f0
insertDict!(:a, 1, myTable03)

# ╔═╡ bff1d69b-af56-44da-a73b-5e0c6838c80a
insertDict!(:b, 2, myTable03)

# ╔═╡ 643eee46-4010-44f0-a331-5333c89b4a9e
insertDict!(:c, 3, myTable03)

# ╔═╡ ca2e0763-1be7-4571-b52f-d28394f83a52
insertDict!(:a, 1, myTable03)      # redundant key-value-pair is *not* stored !

# ╔═╡ e3d01454-ba10-4a97-8d4c-b08fb24199e6
md"
---
###### Selector
"

# ╔═╡ 38d6acf1-a0b8-4a98-9575-15a09b5787e2
# 2nd method of lookupDict! for 2-dim tables
#--------------------------------------------------------------------------------
function lookupDict(key1, key2, table) 
	get(table, (key1, key2), "no such found")
end # function lookupDict

# ╔═╡ c4f2f538-5e86-4f88-a078-e868c4d1d898
lookupDict(:b, myTable03)

# ╔═╡ 96030b7c-6b42-4bf1-9b4e-d6f70b4792a9
lookupDict(:c, myTable03)

# ╔═╡ ec833633-2f60-4e16-8663-5197e92bc396
myTable04 = makeTableDict2()

# ╔═╡ ada61327-48f5-4fa0-bbf5-2541dfffb78c
typeof(myTable04)

# ╔═╡ 29dc4720-8ce8-460e-870d-083e1b03622b
insertDict!(:math, :+, 43, myTable04)

# ╔═╡ fe6ad410-3b5f-4855-b7f6-9bb5cd2b015a
insertDict!(:math, :-, 45, myTable04)

# ╔═╡ 6ed1097a-812c-4986-a645-88204567f7bc
insertDict!(:math, :*, 42, myTable04)

# ╔═╡ eb0d1d12-cdd0-49ae-974e-76b28c1d45bd
insertDict!(:letters, :a, 97, myTable04)

# ╔═╡ 5df9e4a7-0582-43b0-981b-5d3791ec6e55
insertDict!(:letters, :b, 98, myTable04)

# ╔═╡ a192ac5b-a89c-4ff0-84dd-315a3d4e3e9f
insertDict!(:math, :+, 43, myTable04)  # insertion of redundant key-value-pair

# ╔═╡ 039714da-0092-4fd0-820d-43dabe0b740e
myTable04

# ╔═╡ 9506ea43-a36d-4bce-b7b1-26a497258cf4
lookupDict(:math, :-,  myTable04)

# ╔═╡ 8df7c62c-773c-4e7d-bb50-3f5ce4f0bd5b
lookupDict(:letters, :b,  myTable04)

# ╔═╡ 86955a97-3a66-4198-b9de-7b8ecdec7dfc
md"
---
##### 3.3.3.1.2.3 Creating local tables (table objects)
"

# ╔═╡ afc46599-c58a-4456-8c9c-f1520e29410d
function makeTableObjectDict()                    # for one- and two-dim tables
	let localTable = Dict{Tuple, Int64}()
		#----------------------------------------------------------------------------
		function lookupDict1(key1) 
			get(localTable, (key1,), "no such found")
		end # function lookupDict1
		#------------------------------------------------------
		function lookupDict2(key1, key2) 
			get(localTable, (key1, key2), "no such found")
		end # function lookupDict2
		#----------------------------------------------------------------------------
		function insertDict1!(key1, value)
			localTable[(key1,)] = value
		end # function insertDict1!
		#-----------------------------------------------------
		function insertDict2!(key1, key2, value)
			localTable[(key1, key2)] = value
		end # function insertDict2!
		#----------------------------------------------------------------------------
		function dispatch(message)
			message == :lookup1  ? lookupDict1  :        # new to SICP
			message == :lookup2  ? lookupDict2  :        # new to SICP
			message == :insert1! ? insertDict1! :        # new to SICP
			message == :insert2! ? insertDict2! :        # new to SICP
			error("Unknown message $message-- TABLE")
		end # function dispatch
		#----------------------------------------------------------------------------
		dispatch
	end # let
	#--------------------------------------------------------------------------------
end # function makeTableObjectDict

# ╔═╡ 5455eb9e-3030-4813-b08a-1fe4273cecaa
md"
---
###### *One*-dimensional table (Fig.3.22, SICP, 1996, p.267)
"

# ╔═╡ bcb38457-9f06-47e6-a567-edec4a0dcda7
myTable06 = makeTableObjectDict()

# ╔═╡ 549fe5ec-3e96-4495-8ff4-b3b7fc5f5a8f
myTable06(:lookup1)(:a)

# ╔═╡ b15da9f0-0433-4f99-8707-9f47a058b357
myTable06(:insert1!)(:a, 1)

# ╔═╡ 1784f45a-1f5d-441e-8b05-2114e43de295
myTable06(:insert1!)(:b, 2)

# ╔═╡ 3bf13743-45d7-409f-8931-92bbc1631cc4
myTable06(:insert1!)(:c, 3)

# ╔═╡ 221c84eb-12af-44b6-91b7-e3598a3aadf0
myTable06(:insert1!)(:a, 1)         # redundant entry

# ╔═╡ 01b4f117-e637-4d43-937a-824dbeee50e4
myTable06(:lookup1)(:a)

# ╔═╡ dec8deb4-a940-4daf-a7ad-f9503877ac05
myTable06(:lookup1)(:c)

# ╔═╡ 15463329-d50b-4902-ba6e-157eb0df3963
md"
---
###### *Two*-dimensional table (Fig.3.22, SICP, 1996, p.267)
"

# ╔═╡ 74bdfe57-42aa-414f-b318-e32ea674e06c
myTable07 = makeTableObjectDict()

# ╔═╡ ea999f08-618a-41cf-8134-f762e69c040c
myTable07(:lookup2)(:math, :+)

# ╔═╡ ba083d21-f6eb-45df-b77c-aaac9391ac73
myTable07(:insert2!)(:math, :+, 43)

# ╔═╡ 9e2b16d7-d3e1-4af7-99f3-c60d1f01a419
myTable07(:insert2!)(:math, :-, 45)

# ╔═╡ ed0ed95f-7d85-43df-8859-2db22ceb085d
myTable07(:insert2!)(:math, :*, 42)

# ╔═╡ b884307c-18cc-49d7-8c78-ab898a17409c
myTable07(:insert2!)(:letters, :a, 97)

# ╔═╡ 68237aae-0601-44db-b10e-379f03f6f929
myTable07(:insert2!)(:letters, :b, 98)

# ╔═╡ f0741a36-8f4c-4b60-aa96-a2dea0297dc8
myTable07(:insert2!)(:math, :+, 43)     # redundant entry

# ╔═╡ 80b392b5-2841-410c-8770-6f5087a92d18
myTable07(:lookup2)(:math, :+)

# ╔═╡ 4cb13912-5bb8-4076-8d24-3bb4e02dd2d5
myTable07(:lookup2)(:letters, :b)

# ╔═╡ a6f8eae0-b69e-4c22-bca7-2300d4637b23
md"
---
##### end of ch. 3.3.3.1

"

# ╔═╡ 99b2ebee-258e-4fd3-a668-ab14075ac5b6
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
# ╟─15cad150-bb4e-11ed-2a31-f366dd23123a
# ╟─38f34b6f-c119-4eae-897f-4fab0f2613dd
# ╠═1f62eb60-7592-4880-8f86-51d9e2ea95f7
# ╠═fc1cf117-5d7f-4d32-9409-086973a15188
# ╟─5d422679-72be-4913-ae98-32dd50f2accf
# ╟─99e6a4da-857b-4e05-b733-8459cadcd782
# ╠═6ef86571-3019-4598-ae53-ed1d9b8b8ea2
# ╠═8c945614-ccbf-4af7-931e-735fbe20755c
# ╠═4876b9e3-edb2-464a-b926-29cc6d2b30ea
# ╠═1f50fec5-6a4d-4273-ab77-66b4c367a552
# ╠═5040923a-1c5e-46a0-a2f6-f9db4a4b02bc
# ╠═6e54aa2b-0cc3-4fcd-b718-4f60815537f3
# ╠═45fdd982-618b-4349-b023-632a32bd1055
# ╠═c45e82b6-4cc2-4347-bbf0-88f3bb97cde8
# ╠═f23cbf53-705d-4cb7-bcd9-016c8c2e92a8
# ╠═f8ff4f6b-dd7d-45f8-a44b-af1f2e268a63
# ╟─a63183ab-5a1c-4489-8a10-313bb247c651
# ╠═d8613a32-9f42-4ed9-8ded-03e05cd30376
# ╠═1debf96e-e34e-4017-8fa9-7f23b2aa855e
# ╠═587286fa-d302-414e-9e2f-949bf5aed0c6
# ╟─b0b3f700-8d6f-42ce-9ea4-0270f76aff7a
# ╠═a1a1e8b4-a985-4581-8a96-6c56b80aff55
# ╠═aa58ad1b-d8b7-47a6-b3fb-1466380d74ad
# ╟─8d605bad-0cd0-4154-b5ba-8ecdaa16a66f
# ╠═ff398b01-a623-4729-b2ae-f3fde77a2ea9
# ╟─5916fe02-b9ac-4ff0-842e-c423fae6a7e1
# ╠═ad11651a-4cd8-4be4-af9c-736ca703faa9
# ╠═862095a5-d40c-43a8-85e8-51d49338ceb1
# ╟─4c4f4b37-2d06-4255-b015-5f5ec513dff1
# ╠═25c92431-3e90-4d04-97cb-6cd838b61430
# ╠═92eec5ec-035f-4d15-a162-0e5e149485e3
# ╟─e16592ec-7fbe-4d89-a572-7bfe4fd50ca0
# ╟─2dbdf842-7d2c-4fdf-8c41-7950474cae95
# ╠═3a4ff6ad-de89-4c53-8752-b6312aaac44a
# ╠═ff400772-5721-46b0-a452-14eb6bcf4067
# ╟─0f7f51b8-c00a-4fb6-927c-650e65ab57a0
# ╠═c7f318e2-860c-4836-b5e6-8c74c7b2dc3b
# ╠═e7b74d62-3c9c-4f93-8d21-54061d9c2cc7
# ╟─620b1e98-c0d6-436d-8354-145b80f65db2
# ╠═758a8fef-3323-405c-8a2f-9d3e1d280b06
# ╠═e65c422f-262e-4deb-a474-19b934a3584d
# ╠═ee3a76e3-46c6-4d55-965a-287d7c568154
# ╠═e12c0b0a-77bd-4523-a06e-175244630e0c
# ╠═656e2d72-6073-4d08-9f44-6256e5807b52
# ╠═b759d5b4-1e1c-4d5b-afa0-fabfaa3aef31
# ╠═d8c00175-d17e-4355-910e-35fa18827766
# ╠═86c06e2e-7695-45e8-9c6a-dcf4fced5982
# ╠═facfd58c-43a5-4afd-b642-3aa7be21cea9
# ╠═8d154947-93af-4143-9099-9b9a93919d00
# ╟─f1b12259-5c53-4781-93a1-5b0fda0a7ac0
# ╟─df55aa17-c80e-48c2-92c9-723486a6f057
# ╠═9fc7cfa0-1ba5-4882-8c4c-dcb38532ccfa
# ╟─5fea4a3c-e942-443a-bfb2-66ce8da83a5d
# ╠═d5bf565d-f09d-4ca9-85ab-7646e8c817bd
# ╟─202a13ed-464d-4766-a51b-dfc0a4db9d7f
# ╠═ee840950-5015-4668-8e0b-256db252b983
# ╠═12fe5c00-d870-4b8c-8a78-006364687ebb
# ╠═c65abe03-e4a3-49d6-9eba-203224e91f27
# ╠═b7fa135b-970e-4d8d-bfaa-7936012607b8
# ╠═f528b96a-c9a7-4a70-9782-b37c9d919765
# ╠═ef229b5c-5b4e-41d0-8fcf-927558c1e3f0
# ╠═c0503002-7a37-473d-b182-02d66e92fbd7
# ╠═ec8394e1-faec-448c-a12a-08b11d64d4ba
# ╠═c24a0ca3-bf5a-40ae-99e0-5178fe9d66c8
# ╠═9d627fe4-14fc-4f36-84b8-b4c614219fab
# ╠═7be8db73-5218-4bbb-955d-bffc90fc4921
# ╠═bcf8a49c-39cc-4921-8f5c-a194e0ddbfac
# ╠═1a36db29-ffc9-4668-ab10-a9c16e3e6d7f
# ╠═a88e8d8a-8672-4a2f-95d3-6603d613c2d9
# ╠═b2005f50-cf10-41f5-b690-fea51a884f99
# ╠═1eae1ca8-fd6f-43d5-8ef0-c6b4fc9f39f3
# ╠═6cfaed65-a0ca-4f9b-96d1-930189443544
# ╟─ae7a165a-5843-494f-9a10-5e7e5e5aa466
# ╠═f5afb899-d419-4788-bcd7-5bb9d803988c
# ╠═c225dea2-613b-4e6c-bdac-51b3388136bf
# ╠═bf3d7ccc-6278-4b3f-954c-9a61d34b07bd
# ╠═938b2d0f-a1ed-4a0a-9d92-c28674e038e1
# ╠═b5cd96f7-9945-4f31-b76b-ca00b2ad2917
# ╠═c2a3ec7a-2dd3-4bd6-a3fe-88e2d2f2fb8f
# ╠═ec8b76aa-02a7-4f92-8f8d-4faaf9d410e7
# ╠═4a2d95cd-4288-41b7-9aa9-7d83ab5e0dd0
# ╠═98c7256b-0667-4d2e-bca0-fe24f63e1733
# ╠═18a10807-4f6b-4739-8515-e1bb4f1ec7da
# ╠═14c40087-4fbd-48a2-b479-b358dfd1e00b
# ╠═77074a17-7e95-4b11-95e2-652575e98e84
# ╠═571ddc7a-ce7e-4559-b044-1bfb3f54fc88
# ╠═1eb4322f-2b7f-4497-96dc-cb65814cf58c
# ╠═16801fbb-5786-4400-a5fa-b23fd483abba
# ╠═4747c42b-ccf2-497b-8c45-05b9db52a7d4
# ╟─924bb598-7df2-4c6a-9c5a-66fa64c5a66d
# ╟─7ada7382-3f60-4267-8aff-43bfc3462844
# ╟─927ca1b1-0e5d-405b-8f2a-38b1d3088b19
# ╠═b36b8e47-e4a0-4506-bb7a-fe3288269f1f
# ╠═57b025ab-768d-4d49-9f8a-6d122b11bb62
# ╟─8d14a820-43bd-494a-a460-f1a433ca48ff
# ╠═18fbd593-97ba-4217-837a-db88ca760206
# ╟─d704869f-c532-40a8-b1b8-0bb40b2e3b06
# ╠═d8721df7-4b97-4858-96e4-fd7f3a1a7c89
# ╠═c44a358e-793b-4bcd-8fbd-18219fcfc588
# ╠═57fec436-539c-43f9-ba78-e3bf837921f0
# ╠═bff1d69b-af56-44da-a73b-5e0c6838c80a
# ╠═643eee46-4010-44f0-a331-5333c89b4a9e
# ╠═ca2e0763-1be7-4571-b52f-d28394f83a52
# ╠═36010552-598b-4c70-97a8-b3797660a743
# ╠═c4f2f538-5e86-4f88-a078-e868c4d1d898
# ╠═96030b7c-6b42-4bf1-9b4e-d6f70b4792a9
# ╟─f74ffedf-d734-4fea-82e3-8a0b803cb239
# ╟─f5520fbc-7e8d-4147-a2b1-c85907869f67
# ╠═b6a58efe-2210-4814-9799-62d0747cb7b9
# ╠═fa66c233-1ea3-4969-befb-6ebf27a58f54
# ╟─e3d01454-ba10-4a97-8d4c-b08fb24199e6
# ╠═38d6acf1-a0b8-4a98-9575-15a09b5787e2
# ╠═ec833633-2f60-4e16-8663-5197e92bc396
# ╠═ada61327-48f5-4fa0-bbf5-2541dfffb78c
# ╠═29dc4720-8ce8-460e-870d-083e1b03622b
# ╠═fe6ad410-3b5f-4855-b7f6-9bb5cd2b015a
# ╠═6ed1097a-812c-4986-a645-88204567f7bc
# ╠═eb0d1d12-cdd0-49ae-974e-76b28c1d45bd
# ╠═5df9e4a7-0582-43b0-981b-5d3791ec6e55
# ╠═a192ac5b-a89c-4ff0-84dd-315a3d4e3e9f
# ╠═039714da-0092-4fd0-820d-43dabe0b740e
# ╠═9506ea43-a36d-4bce-b7b1-26a497258cf4
# ╠═8df7c62c-773c-4e7d-bb50-3f5ce4f0bd5b
# ╟─86955a97-3a66-4198-b9de-7b8ecdec7dfc
# ╠═afc46599-c58a-4456-8c9c-f1520e29410d
# ╟─5455eb9e-3030-4813-b08a-1fe4273cecaa
# ╠═bcb38457-9f06-47e6-a567-edec4a0dcda7
# ╠═549fe5ec-3e96-4495-8ff4-b3b7fc5f5a8f
# ╠═b15da9f0-0433-4f99-8707-9f47a058b357
# ╠═1784f45a-1f5d-441e-8b05-2114e43de295
# ╠═3bf13743-45d7-409f-8931-92bbc1631cc4
# ╠═221c84eb-12af-44b6-91b7-e3598a3aadf0
# ╠═01b4f117-e637-4d43-937a-824dbeee50e4
# ╠═dec8deb4-a940-4daf-a7ad-f9503877ac05
# ╟─15463329-d50b-4902-ba6e-157eb0df3963
# ╠═74bdfe57-42aa-414f-b318-e32ea674e06c
# ╠═ea999f08-618a-41cf-8134-f762e69c040c
# ╠═ba083d21-f6eb-45df-b77c-aaac9391ac73
# ╠═9e2b16d7-d3e1-4af7-99f3-c60d1f01a419
# ╠═ed0ed95f-7d85-43df-8859-2db22ceb085d
# ╠═b884307c-18cc-49d7-8c78-ab898a17409c
# ╠═68237aae-0601-44db-b10e-379f03f6f929
# ╠═f0741a36-8f4c-4b60-aa96-a2dea0297dc8
# ╠═80b392b5-2841-410c-8770-6f5087a92d18
# ╠═4cb13912-5bb8-4076-8d24-3bb4e02dd2d5
# ╟─a6f8eae0-b69e-4c22-bca7-2300d4637b23
# ╟─99b2ebee-258e-4fd3-a668-ab14075ac5b6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
