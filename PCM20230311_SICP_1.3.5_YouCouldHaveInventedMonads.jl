### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ ecfab450-c03b-11ed-2757-47f8cc23856a
md"
=================================================================================
### NonSICP: 1.3.5 [You Could have Invented Monads !](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html)
##### file: PCM20230311\_SICP\_1.3.5\_YouCouldHaveInventedMonads.jl
##### Julia/Pluto-code (1.8.5/19...)  by *** PCM 2023/03/12 ***

=================================================================================
"

# ╔═╡ cb877fe5-b57a-40bf-94cd-e575d299a9cd
md"
This chapter does not appear in SICP. But it is worth to report my studies of the question how *continuations* and *monads* are related. Continuations are well known in Scheme. But the meaning of monads is a bit mysterious to me, though it seems to be a fundamental concept in the *pure* functional language Haskell (Hutton, 2017, ch.12).

A low level entry to monads seemed to me the blog *You Could Have Invented Monads! (And Maybe You Already Have.)* of (Sigfe, 2006). After a few attempts to copy his code and try it out in an online Haskell environment I came to the conclusion that it would be more learn-efficient to translate his Haskell-code into Julia and run it in my comfortable Julia/Pluto environment. 
"

# ╔═╡ 475dfabe-5e88-4d0b-b585-98ab6f3230cd
md"
##### 1. Composition of *pure* functions

###### Haskell : $f,g :: Float \rightarrow Float$
###### Julia : $f,g ::Real \rightarrow Real$
"

# ╔═╡ 05b93c6a-8d5c-4795-841b-45232725607b
supertype(Real)

# ╔═╡ ffa1ecb5-e06b-4544-a979-07c7efad81fc
subtypes(Real)

# ╔═╡ 0ee558b6-e703-460e-8d88-fa276c6c2027
let                                     # f and g are reversed to relation to Sigfe
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	gf1(x::Real)::Real = g(f(x))                              # nesting
	gf2(x::Real)::Real = (g ∘ f)(x)                           # composition
	gf3(x::Real)::Real = x |> f |> g                          # piping
	gf1(3), gf2(3), gf3(3)
end # let

# ╔═╡ c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
md"
---
##### 2. Addition of side *effects* (='*debuggable*' impure functions)

###### Haskell : $f',g' :: Float \rightarrow (Float, String)$
###### Julia   : $QM',gQM :: Real \rightarrow (Real, String)$

                        x
                        |
                        |
                     +-----+
                     | fQM |    fQM = f-Quotation-Mark = f'
                     +-----+
					   |  \
                       |   \ 
                       |    \
                    f(x)   'f was called'

**Fig. 1.3.5.1** Input-, Output-Diagram of *debuggable* function (adapted from [Sigfe](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html), 2023)
"

# ╔═╡ 9f239124-aae1-42be-af16-044d7e11e746
md"
---
###### Simple composition doesn't work: $gQM(fQM(3)) \mapsto \bot$
"


# ╔═╡ 880c2599-0f86-41c0-b496-1635e1264e4a
let                                     # f and g are reversed to relation to Sigfe
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	fQM(x::Real)::Tuple{Real, String} = (f(x), "f was called")
	gQM(x::Real)::Tuple{Real, String} = (g(x), "g was called")
	# gf1(x::Real)::Real = g(f(x))
	fQM(3), gQM(3), gQM(fQM(3))                  # simple composition doesn't work
end # let

# ╔═╡ f5b7cf8e-3127-4253-9ebb-62f7ae8fbc65
md"
---
###### Composition of *debuggable* (impure) functions 

###### Haskell:
(Sigfe's (slightly) *modified* Haskell [proposal](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html))

       let (y,s) = f' x
           (z,t) = g' y in (z,t++s)

###### Julia 
(Dataflow Diagram and Code):

                        x
                        |
                        |
                     +-----+
                     | fQM |    fQM = f-Quotation-Mark = f'
                     +-----+
					   |  \
                       |    \ 
                       |      \
          (y, s) = (f(x), 'f was called')
                       |         \
                       |           \
                    +-----+          \
                    | gQM |            \  
                    +-----+              \
					   |  \                \
                       |    \                \
                       |      \               |
        (z, t) = (g(f(x)), 'g was called')    |
                       |         \            /
                       |           \        /
                       |             \    /
                       |            +------+
                       |            |  ++  |
                       |            +------+
                       |               |
                       |               |
        (z, t++s) = (g(f(x)), 'g was called ++ f was called')

**Fig. 1.3.5.2** Input-, Output-Diagram of *composition* of debuggable functions (adapted from [Sigfe](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html), 2023)
"

# ╔═╡ 43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
let                                   # f and g are reversed to relation to Sigfe
	x = 3
	++ = string
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	fQM(x::Real)::Tuple{Real, String} = (f(x), "f was called")
	gQM(x::Real)::Tuple{Real, String} = (g(x), "g was called ++ ")
	(y, s) = fQM(x)
	(z, t) = gQM(y)
	(z, ts) = (z, ++(t, s))
	(y, s), (z, t), (z, ts)
end # let

# ╔═╡ 1fb51d85-8dff-40c3-8f51-158516255409
md"
---
#### References

- **Hutton, G.**; *Programming in Haskell*; Cambridge: Cambridge University Press, 2017 (2/e)
- **Sigfe**; [You Could Have Invented Monads! (And Maybe You Already Have.) ](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html); 2006; last visit 2023/03/12
"

# ╔═╡ 8826d494-fa7d-4882-be93-7d5069d245b3
md"
---
##### end of ch. 1.3.5
"

# ╔═╡ 94bf2bc2-5d9e-412c-96e5-6b6e350b9ff4
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
# ╟─ecfab450-c03b-11ed-2757-47f8cc23856a
# ╟─cb877fe5-b57a-40bf-94cd-e575d299a9cd
# ╟─475dfabe-5e88-4d0b-b585-98ab6f3230cd
# ╠═05b93c6a-8d5c-4795-841b-45232725607b
# ╠═ffa1ecb5-e06b-4544-a979-07c7efad81fc
# ╠═0ee558b6-e703-460e-8d88-fa276c6c2027
# ╟─c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
# ╟─9f239124-aae1-42be-af16-044d7e11e746
# ╠═880c2599-0f86-41c0-b496-1635e1264e4a
# ╟─f5b7cf8e-3127-4253-9ebb-62f7ae8fbc65
# ╠═43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
# ╟─1fb51d85-8dff-40c3-8f51-158516255409
# ╟─8826d494-fa7d-4882-be93-7d5069d245b3
# ╟─94bf2bc2-5d9e-412c-96e5-6b6e350b9ff4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
