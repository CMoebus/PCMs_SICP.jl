### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 96241377-fc34-47b0-b8ba-a3f61bc1bdc5
using Pkg

# ╔═╡ 178c5951-3382-44b3-ab9e-21e384b657e1
Pkg.add("DataStructures")

# ╔═╡ 11261a85-a821-4d77-b1af-cf847d00d45e
using DataStructures

# ╔═╡ 027f6960-ba83-11ed-1786-d7fda6715ae5
md"
====================================================================================
#### SICP: 3.3.2.2 Representing Queues With DataStructures.jl
##### file: PCM20230304\_SICP\_3.3.2.2\_QueuesWithDataStructures.jl
##### Julia/Pluto.jl-code (1.8.5/0.19.12) by PCM *** 2023/03/04 ***

====================================================================================

"

# ╔═╡ e209878e-76f7-437c-9927-e48141fdac10
Atom = Union{Number, Symbol, Char, String}

# ╔═╡ ede85161-1ce5-4fbe-a85a-e6c7a9de426c
md"
---
###### Constructor
"

# ╔═╡ 308932bb-a856-4c7b-8307-b0cc345efbec
makeQueue()::Queue = Queue{Atom}()::Queue

# ╔═╡ c6954374-4644-4df8-92c2-94a6d4b35aaf
md"
---
###### Selectors

"

# ╔═╡ 31f9aea2-a230-4f77-add6-9fbd9c5852c7
isEmptyQueue(q::Queue) = isempty(q::Queue)

# ╔═╡ 343d4c29-8cb5-42a4-b9a7-87fdd3e67d5c
frontQueue = first

# ╔═╡ ac15f3c4-c39a-4c6d-95ec-fec6d54e2107
md"
--- 
###### Mutators
"

# ╔═╡ f4d6b5e1-ff9e-4985-b972-dae385c264b9
insertQueue!(q::Queue, item::Atom)::Queue = enqueue!(q::Queue, item::Atom)::Queue

# ╔═╡ 3a2a24d8-e4be-4e9c-8323-f7de718f9e96
deleteQueue!(q::Queue)::Queue = dequeue!(q::Queue)::Atom

# ╔═╡ 9d72424e-ad80-4996-9433-d391b791a229
let q = makeQueue()
	q
end # let

# ╔═╡ 0173c66a-9219-4144-b8c2-73ed806269c2
let q = makeQueue()
	typeof(q), isempty(q)
end # let

# ╔═╡ 2590460a-a69a-45b7-a50e-13ff6995924c
let q = makeQueue()
	insertQueue!(q, :a)
	q
end # let

# ╔═╡ 9b4f70ee-ea7a-4e46-bb0b-a437c5638994
let q = makeQueue()
	insertQueue!(q, :a)
	insertQueue!(q, :b)
	q
end # let

# ╔═╡ a15cabcf-46e7-4af8-b8bd-0c7abdbbdf27
md"
---
(cf. **Fig. 3.19**; SICP, 1996, p.263)
"

# ╔═╡ 1d299422-efd0-4039-b624-8e6666681f0c
let q = makeQueue()
	insertQueue!(q, :a)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	q
end # let

# ╔═╡ 67d57ce5-cd98-4d19-bbd2-c9adeeb3f70c
md"
---
(cf. **Fig. 3.20**; SICP, 1996, p.263)
"

# ╔═╡ 5d686a9d-5fa6-4a19-b38d-43b11cd50300
let q = makeQueue()
	insertQueue!(q, :a)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	q
end # let

# ╔═╡ 05885bff-b880-437b-8e1b-5a946743d1bb
md"
---
(cf. **Fig. 3.21**; SICP, 1996, p.263)
"

# ╔═╡ 12510ecd-9f74-40e7-9be4-0544acb1b19a
let q = makeQueue()
	insertQueue!(q, :a)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	q
end # let

# ╔═╡ b9ecaf3d-ea62-42ac-acce-1cc171152328
let q = makeQueue()
	insertQueue!(q, :a)
	insertQueue!(q, :b)
	insertQueue!(q, :c)
	insertQueue!(q, :d)
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	isEmptyQueue(q) !== true ? dequeue!(q) : error("queue is empty $q")
	q
end # let

# ╔═╡ 25a294e6-4c7c-4ff5-a549-65d6523355be
md"
---
##### end of ch. 3.3.2.2

"

# ╔═╡ 46f80425-ed32-4f1d-8622-daf67812f1a9
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================

"

# ╔═╡ Cell order:
# ╟─027f6960-ba83-11ed-1786-d7fda6715ae5
# ╠═96241377-fc34-47b0-b8ba-a3f61bc1bdc5
# ╠═178c5951-3382-44b3-ab9e-21e384b657e1
# ╠═e209878e-76f7-437c-9927-e48141fdac10
# ╠═11261a85-a821-4d77-b1af-cf847d00d45e
# ╟─ede85161-1ce5-4fbe-a85a-e6c7a9de426c
# ╠═308932bb-a856-4c7b-8307-b0cc345efbec
# ╟─c6954374-4644-4df8-92c2-94a6d4b35aaf
# ╠═31f9aea2-a230-4f77-add6-9fbd9c5852c7
# ╠═343d4c29-8cb5-42a4-b9a7-87fdd3e67d5c
# ╟─ac15f3c4-c39a-4c6d-95ec-fec6d54e2107
# ╠═f4d6b5e1-ff9e-4985-b972-dae385c264b9
# ╠═3a2a24d8-e4be-4e9c-8323-f7de718f9e96
# ╠═9d72424e-ad80-4996-9433-d391b791a229
# ╠═0173c66a-9219-4144-b8c2-73ed806269c2
# ╠═2590460a-a69a-45b7-a50e-13ff6995924c
# ╠═9b4f70ee-ea7a-4e46-bb0b-a437c5638994
# ╟─a15cabcf-46e7-4af8-b8bd-0c7abdbbdf27
# ╠═1d299422-efd0-4039-b624-8e6666681f0c
# ╟─67d57ce5-cd98-4d19-bbd2-c9adeeb3f70c
# ╠═5d686a9d-5fa6-4a19-b38d-43b11cd50300
# ╟─05885bff-b880-437b-8e1b-5a946743d1bb
# ╠═12510ecd-9f74-40e7-9be4-0544acb1b19a
# ╠═b9ecaf3d-ea62-42ac-acce-1cc171152328
# ╟─25a294e6-4c7c-4ff5-a549-65d6523355be
# ╟─46f80425-ed32-4f1d-8622-daf67812f1a9
