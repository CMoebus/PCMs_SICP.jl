### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ eeebdde0-9c08-11ed-1bee-89bc2518d37a
md"
====================================================================================
#### SICP: [3.2.1 The Rules for Evaluation](https://sarabander.github.io/sicp/html/3_002e2.xhtml#g_t3_002e2_002e1)
##### file: PCM20230124\_SICP\_3.2.1\_TheRulesForEvaluation.jl
##### Julia/Pluto.jl-code (1.8.3/0.19.14) by PCM *** 2023/01/24 ***

====================================================================================
"

# ╔═╡ 78539779-7135-43c9-ad94-f53d8789ba66
md"
*The environment model of evaluation replaces the substitution model in specifying what it means to apply a compound procedure to arguments.
... a procedure is always a pair consisting of some code and a pointer to an environment.* (SICP, 1996, p.238)
"

# ╔═╡ a224ee70-9a3c-471f-aec6-5a7bcb3b5666
md"
---
###### *Global* environment *E0* 
(simulated by a $$let$$-expression)
"

# ╔═╡ 7fad9ca2-bb22-4a56-8bdc-a668d80c4850
md"
*square* evaluates to $$\lambda$$-expression: $$square \Longrightarrow x \rightarrow *(x, x)$$
"

# ╔═╡ 5002c5cb-7cbc-4143-83fc-08e2912aa6f6
let square = x -> *(x, x)  # simulated global environment E0
	square                 # square ==> x -> *(x, x); square evaluates to λ-expression
end # let

# ╔═╡ dfafeb4d-93b6-482d-b025-dc15652f8da5
md"
**Fig. 3.2.1** *Environment diagram E0* after evaluating $$square$$ (cf. SICP, 1996, Fig. 3.2)
"

# ╔═╡ 34407212-d1fa-44d7-aae0-80a49eb922b2
md"
---
###### *Extending* global environment *E0* by *E1*
"

# ╔═╡ c9456bfc-8833-409c-b706-367707be797e
md"
*square(6)* evaluates to $$36$$: $$square(6) \Longrightarrow 36$$ after parameter-argument binding and extension of E0 to E1
"

# ╔═╡ 109f49c7-c120-4854-acd0-a10bca16ab1c
let square = x -> *(x, x)        # simulated global environment E0
	square(6)                    # ==> 36, evaluation in E0
	(x -> *(x, x))(6)            # square ==> x -> *(x, x), evaluation of square
	let x = 6                    # parameter-argument binding, extending E0 by E1
		*(x, x)                  # ==> 36, evaluation in E1
		*(6, 6)                  # ==> 36, evaluation in E1
	end # let
end # let 

# ╔═╡ 25fac027-1ee6-4488-9d69-cf57b23600f9
md"
**Fig. 3.2.2** *Extended* environment diagram after evaluating '$$square2(6)$$' (cf. SICP, 1996, Fig. 3.3)
"

# ╔═╡ 43da2893-dd3a-45ee-a775-7cd43c343996
md"
---
##### Environment model of procedure application
- **Rule 1**: A procedure object is applied to a set of arguments by: 
	(1) constructing a frame, 
	(2) binding the formal parameters of the procedure to the arguments of the call, 
	(3) and then evaluating the body of the procedure in the context of the new (extended) environment constructed. 
The *new* frame has as its enclosing environment the environment part of the procedure object being applied.(cf. SICP, 1996, ch.3.2.1, p.240f) 
"

# ╔═╡ 4d2bd09b-3de7-487d-abc8-03511e3fd9cc
md"
- **Rule 2**: A procedure is created by evaluating a λ-expression relative to a given environment. The resulting procedure object is a *pair* consisting of the text of the λ-expression and a pointer to the environment in which the procedure was created.(cf. SICP, 1996, ch.3.2.1, p.240f) 
"

# ╔═╡ 98ed3edc-b7ce-47bb-8c91-cdb7b5a4a894
md"
- **Rule 3**: Defining a symbol with 'function' or '=' creates a binding in the current environment frame and assigns to the symbol the indicated value.(cf. SICP, 1996, ch.3.2.1, p.240f)
"

# ╔═╡ 9c34669d-2ad6-4255-bd24-4c0080a4fc22
md"
- **Rule 4**: Evaluating the expression '<symbol> = <value>' in some environment locates the binding of the variable in the environment and changes that binding to indicate the new value. That is, one finds the first frame in the environment that contains a binding for the variable and modifies that frame.
"

# ╔═╡ b710a49d-8a72-426e-80a7-1d4b2c6f8ec9
md"
---
##### 3.2.1.2 Idiomatic Julia
"

# ╔═╡ 64fe8052-c451-47f6-95c7-5de57cf413d9
let foo() = x                     # simulated global environment E0
	let x = 1                     # simulated  local environment E1
		let x = 2                 # simulated  local environment E2
			foo()                 # evaluation in E2
		end # let
	end # let
end # let

# ╔═╡ a48d5fd3-ef58-4db3-b166-9d5387f8cec4
let x = 1                         # simulated global environment E0
	let foo() = x                 # simulated  local environment E1
		let x = 2                 # simulated  local environment E2
			foo()                 # evaluation in E2
		end # let
	end # let
end # let

# ╔═╡ 0609c54f-9d6d-41a4-b28b-a3dce8ff2b4c
let x = 1                          # simulated global environment E0
	let x = 2                      # simulated  local environment E1
		let foo() = x              # simulated  local environment E2
			foo()                  # evaluation in E2
		end # let
	end # let
end # let

# ╔═╡ 453908cd-138d-459d-80ab-52c2e69ff86a
md"
---
##### end of ch. 3.2.1
"


# ╔═╡ 47829574-dbc0-4c68-9cad-fd5564e3ec99
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

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─eeebdde0-9c08-11ed-1bee-89bc2518d37a
# ╟─78539779-7135-43c9-ad94-f53d8789ba66
# ╟─a224ee70-9a3c-471f-aec6-5a7bcb3b5666
# ╟─7fad9ca2-bb22-4a56-8bdc-a668d80c4850
# ╠═5002c5cb-7cbc-4143-83fc-08e2912aa6f6
# ╟─dfafeb4d-93b6-482d-b025-dc15652f8da5
# ╟─34407212-d1fa-44d7-aae0-80a49eb922b2
# ╟─c9456bfc-8833-409c-b706-367707be797e
# ╠═109f49c7-c120-4854-acd0-a10bca16ab1c
# ╟─25fac027-1ee6-4488-9d69-cf57b23600f9
# ╟─43da2893-dd3a-45ee-a775-7cd43c343996
# ╟─4d2bd09b-3de7-487d-abc8-03511e3fd9cc
# ╟─98ed3edc-b7ce-47bb-8c91-cdb7b5a4a894
# ╟─9c34669d-2ad6-4255-bd24-4c0080a4fc22
# ╟─b710a49d-8a72-426e-80a7-1d4b2c6f8ec9
# ╠═64fe8052-c451-47f6-95c7-5de57cf413d9
# ╠═a48d5fd3-ef58-4db3-b166-9d5387f8cec4
# ╠═0609c54f-9d6d-41a4-b28b-a3dce8ff2b4c
# ╟─453908cd-138d-459d-80ab-52c2e69ff86a
# ╟─47829574-dbc0-4c68-9cad-fd5564e3ec99
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
