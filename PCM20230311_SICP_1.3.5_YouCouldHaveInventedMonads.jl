### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ ecfab450-c03b-11ed-2757-47f8cc23856a
md"
=================================================================================
### NonSICP: 1.3.5 [You Could have Invented Monads !](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html)
##### file: PCM20230311\_SICP\_1.3.5\_YouCouldHaveInventedMonads.jl
##### Julia/Pluto-code (1.8.5/19...)  by *** PCM 2023/03/15 ***

=================================================================================
"

# ╔═╡ cb877fe5-b57a-40bf-94cd-e575d299a9cd
md"
This chapter does not appear in SICP. But it is worth to report my studies of the question how *continuations* and *monads* are related. Continuations are well known in Scheme. But the meaning of monads is a bit mysterious to me, though it seems to be a fundamental concept in the *pure* functional language Haskell (Hutton, 2017, ch.12).

A low level entry to monads seemed to me the blog *You Could Have Invented Monads! (And Maybe You Already Have.)* of (Sigfe, 2006). After a few attempts to copy his code and try it out in an online Haskell environment I came to the conclusion that it would be more learn-efficient to translate his Haskell-code into Julia and run it in my comfortable Julia/Pluto environment. Beware that I switched his functions names, so his functions $g$ and $f$ become my $f$ and $g$. So alphabetic order corresponds to application order.
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

# ╔═╡ 86a75358-b058-4356-b4ed-e1bd0571f5ef
md"
---
##### *Nesting*, *Composition*, and *Piping* of *pure* functions in Julia
"

# ╔═╡ 0ee558b6-e703-460e-8d88-fa276c6c2027
let                                                           
	f(x::Real)::Real = x*2                                    # f := g in Sigfe
	g(x::Real)::Real = x*3                                    # g := f in Sigfe
	gf1(x::Real)::Real = g(f(x))                              # nesting
	gf2(x::Real)::Real = (g ∘ f)(x)                           # composition
	gf3(x::Real)::Real = x |> f |> g                          # piping
	gf1(3), gf2(3), gf3(3)
end # let

# ╔═╡ 6deab13f-f9bd-4bde-be94-f78b8df1ce58
md"
---
##### 2. Introduction of side *effects* (='*debuggable*') to make functions *impure*

###### Haskell : $f',g' :: Float \rightarrow (Float, String)$
###### Julia   : $fQM, gQM : Real \rightarrow (Real, String)$
"

# ╔═╡ c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
md"
---

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

**Fig. 1.3.5.1** Dataflow-diagram of *debuggable* function (adapted from [Sigfe](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html), 2023)
"

# ╔═╡ 9f239124-aae1-42be-af16-044d7e11e746
md"
---
###### Simple function composition doesn't work with *impure* functions: 

$gQM(fQM(3)) \mapsto \bot$
"


# ╔═╡ 880c2599-0f86-41c0-b496-1635e1264e4a
let                                     # f and g are reversed to relation to Sigfe
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	fQM(x::Real)::Tuple{Real, String} = (f(x), "1st f was called")
	gQM(x::Real)::Tuple{Real, String} = (g(x), "2nd g was called")
	fQM(3), gQM(3), gQM(fQM(3))         # simple composition of impures doesn't work
end # let

# ╔═╡ f5b7cf8e-3127-4253-9ebb-62f7ae8fbc65
md"
---
###### Composition of *impure* (=debuggable) functions 

###### Haskell:
(Sigfe's (slightly) *modified* Haskell [proposal](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html))

       let (y,s) = f' x
           (z,t) = g' y in (z,t++s)

###### Julia (Dataflow Diagram and Code):

                             x
                             |
                             |
                          +-----+
                          | fQM |    fQM = f-Quotation-Mark = f'
                          +-----+
					       /  \
                        /       \ 
                      /           \
              (y, s) = (f(x), '1st, f was called')
                    /                \
                  /                    \
               +-----+                   \
               | gQM |                     \  
               +-----+                       \
				  |  \                         \
                  |    \                         \
                  |      \                        |
        (z, t) = (g(f(x)), '2nd, g was called')   |
                  |         \                     |
                  |           \                  /
                  |             \              /
                  |               \          /
                  |                 \      /
                  |                   \  /
                  |                 +------+
                  |                 |  ++  |
                  |                 +------+
                  |                    |
                  |                    |
        (z, t++s) = (g(f(x)), '1st, f was called ++ 2nd,  gwas called')

**Fig. 1.3.5.2** Dataflow-diagram of *composing* impure (debuggable) functions (adapted from [Sigfe](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html), 2023)
"

# ╔═╡ 1ffaf5f9-5a1d-4a32-a259-31d43767c636
md"
---
###### Composition of *impure* functions 
(close to Sigfe's *Haskell* proposal) 
"

# ╔═╡ 43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
let                                   # f and g are reversed to relation to Sigfe
	x = 3
	++ = string                       # local definition of Haskell-like '++'
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	fQM(x::Real)::Tuple{Real, String} = (f(x), "1st, f was called with $x ++ ")
	gQM(x::Real)::Tuple{Real, String} = (g(x), "2nd, g was called with $x")
	(y, s) = fQM(x)
	(z, t) = gQM(y)
	(z, ts) = (z, ++(s, t))
	(y, s), (z, t), (z, ts)
end # let

# ╔═╡ f0f8e521-0fc5-496c-a53d-7a623dd24d21
md"""
==> *((6, "1st, f was called with 3 ++ "), (18, "2nd, g was called with 6"), (18, "1st, f was called with 3 ++ 2nd, g was called with 6"))*

"""

# ╔═╡ 461ce343-1a37-4242-b0aa-6959c299f2f4
md"
---
###### Composition of *impure* functions, the Julian way with a *2-ary* $compose$
"

# ╔═╡ 94882499-3216-4a4c-80cd-fc4b6323238b
let                                 
	x = 3
	++ = string   
	#-----------------------------------------------
	fQM(x::Real)::Tuple{Real, String} = 
		let f(x::Real)::Real = x*2
			(f(x), "1st, f was called with $x ++ ")
		end # let
	#-----------------------------------------------
	gQM(x::Real)::Tuple{Real, String} = 
		let g(x::Real)::Real = x*3
			(g(x), "2nd, g was called with $x")
		end # let
	#-----------------------------------------------
	function compose(gQM::Function, (y, s)::Tuple{Real, String})::Tuple{Real, String}
		(z, t) = gQM(y)
		(z, ts) = (z, ++(s, t))
		(z, ts)
	end # function compose
	compose(gQM, fQM(3))
end # let

# ╔═╡ b375110f-3848-4e86-9eea-c8123a031936
md"
---
###### Composition of *impure* functions, the Julian way with a *curryfied*  *1-ary* $bind$
*bind* is a *curryfied* version of the *2-ary* function *compose*
(close to Sigfe's *Haskell* proposal) 

The *Haskell* declaration of $bind$ is:

$bind :: (Float \rightarrow (Float,String)) \rightarrow ((Float,String) \rightarrow (Float,String)).$

The meaning of this declaration is that $bind$ is a higher-order function, which maps a *1-ary* function $g'$ into a *2-ary* function $g''$.

So when we *apply* $bind$ to g' the output type is a *2-ary* function g'':

$bind\; g' :: (Float,String) \rightarrow (Float,String)$

*bind* must serve two purposes: it must (1) apply $g'$ to the correct part of $f'\; x$ and (2) concatenate the string returned by $'$ with the string returned by $g'$. (Sigfe, 2006).

Sigfe's proposal in Haskell is (slightly modified): 

$bind\; g'\; (fx,fs) = let\; (gx,gs) = g'\; fx\ in\; (gx,fs\; \text{++}\;gs)$

Our proposal for $bind$ in Jula is below. Because in Haskell all functions are *curryfied* so that the are *1-ary* (take only *one* parameter), we designed $bind$ as a higher order function returning an anonymous $\lambda$-function with parameter $valueOf\_fQM$. This parameter is bound to the value of the function application $fQM(3)$. The result of this application is a *tuple* with type $Tuple\{Real, String\}.$

"

# ╔═╡ bce7b530-774c-4ed2-a732-7017d522499a
let                                 
	x = 3
	++ = string   
	#-----------------------------------------------
	fQM(x::Real)::Tuple{Real, String} = 
		let f(x::Real)::Real = x*2
			(f(x), "1st, f was called with $x ++ ")
		end # let
	#-----------------------------------------------
	gQM(x::Real)::Tuple{Real, String} = 
		let g(x::Real)::Real = x*3
			(g(x), "2nd, g was called with $x")
		end # let
	#-----------------------------------------------
	function bind(gQM::Function)::Function          # bind := curryfied compose !
		(fx, fs)::Tuple{Real, String} ->            # (y, s) = fQM(3)
			let (gx, gs) = gQM(fx)::Tuple{Real, String}
				(gx, ++(fs, gs))::Tuple{Real, String}
			end # let
	end # function bind
	#-----------------------------------------------
	bind(gQM)(fQM(3))::Tuple{Real, String}
end # let

# ╔═╡ 0d86a503-7060-4028-9e6a-fbe9b16a5bae
md"""
==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")

---
"""

# ╔═╡ 87dc553a-86d4-425b-8ec8-cdd911b79e0b
md"
---
###### Composition alternatives of *impure* functions with a *curryfied*  *1-ary* $bind$
(this is an *extension* to Segfe's $bind$)

"

# ╔═╡ 31643b02-de5a-411a-af7c-a3e47123df4f
let
	 #------------------------------------------------------------------
     x = 3
     ++ = string
     #------------------------------------------------------------------
     fQM(x::Real)::Tuple{Real, String} =
         let f(x::Real)::Real = x*2
             (f(x), "1st, f was called with $x ++ ")
         end # let
     #------------------------------------------------------------------
     gQM(x::Real)::Tuple{Real, String} =
         let g(x::Real)::Real = x*3
             (g(x), "2nd, g was called with $x")
         end # let
     #------------------------------------------------------------------
	 # bind := curryfied compose !
     function bind(gQM::Function)::Function  
         fQM::Function ->
             x::Real ->
                 let (fx, fs) = fQM(x)::Tuple{Real, String}
                     (gx, gs) = gQM(fx)::Tuple{Real, String}
                     (gx, ++(fs, gs))::Tuple{Real, String}
                 end # let
     end # function bind
     #------------------------------------------------------------------
     # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     compose(g, f, x) = bind(g)(f)(x)
     compose(gQM, fQM, x)
     #------------------------------------------------------------------    		 	 # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     compose(g, f)    = bind(g)(f) 
     compose(gQM, fQM)(x)
     #------------------------------------------------------------------
	 # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     compose(g)        = bind(g)
     compose(gQM)(fQM)(x)
     #------------------------------------------------------------------
end # let


# ╔═╡ 07e7e133-7076-47b9-a9ba-1db8305a6025
md"""
==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")

---
"""

# ╔═╡ 9f1a9576-4fa2-47d4-b9ae-11a136fa71b2
md"
What is a resumee of the effect of $bind$ ? *Given a pair of debuggable functions,
$f'$ and $g'$, we can now compose them together to make a new debuggable function
bind $f' . g'$. Write this composition as $f'\cdot g'$. Even though the output of $g'$ is incompatible with the input of $f'$ we still have a nice easy way to concatenate their operations.*(Sigfe, 2006) 

"

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
# ╟─86a75358-b058-4356-b4ed-e1bd0571f5ef
# ╠═0ee558b6-e703-460e-8d88-fa276c6c2027
# ╟─6deab13f-f9bd-4bde-be94-f78b8df1ce58
# ╟─c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
# ╟─9f239124-aae1-42be-af16-044d7e11e746
# ╠═880c2599-0f86-41c0-b496-1635e1264e4a
# ╟─f5b7cf8e-3127-4253-9ebb-62f7ae8fbc65
# ╟─1ffaf5f9-5a1d-4a32-a259-31d43767c636
# ╠═43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
# ╟─f0f8e521-0fc5-496c-a53d-7a623dd24d21
# ╟─461ce343-1a37-4242-b0aa-6959c299f2f4
# ╠═94882499-3216-4a4c-80cd-fc4b6323238b
# ╟─b375110f-3848-4e86-9eea-c8123a031936
# ╠═bce7b530-774c-4ed2-a732-7017d522499a
# ╟─0d86a503-7060-4028-9e6a-fbe9b16a5bae
# ╟─87dc553a-86d4-425b-8ec8-cdd911b79e0b
# ╠═31643b02-de5a-411a-af7c-a3e47123df4f
# ╟─07e7e133-7076-47b9-a9ba-1db8305a6025
# ╟─9f1a9576-4fa2-47d4-b9ae-11a136fa71b2
# ╟─1fb51d85-8dff-40c3-8f51-158516255409
# ╟─8826d494-fa7d-4882-be93-7d5069d245b3
# ╟─94bf2bc2-5d9e-412c-96e5-6b6e350b9ff4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
