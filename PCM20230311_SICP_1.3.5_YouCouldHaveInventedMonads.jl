### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ ecfab450-c03b-11ed-2757-47f8cc23856a
md"
=================================================================================
### NonSICP: 1.3.5 [You Could have Invented Monads ?!](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html)
##### file: PCM20230311\_SICP\_1.3.5\_YouCouldHaveInventedMonads.jl
##### Julia/Pluto-code (1.8.5/19...)  by *** PCM 2023/03/19 ***

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

# ╔═╡ 128e9c6d-8710-49ad-9739-c09805a2ea39
md"
---
##### 2. Introduction of *side effects* to make functions *impure*
Sigfe calls *impure* functions in his example '*debuggable*'.
"

# ╔═╡ c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
md"

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

# ╔═╡ 6deab13f-f9bd-4bde-be94-f78b8df1ce58
md"

###### Haskell : $f',g' :: Float \rightarrow (Float, String)$
To be precise *String* is in Haskell a *list* of *characters*
###### Julia   : $fQM, gQM : Real \rightarrow (Real, String)$
"

# ╔═╡ 9f239124-aae1-42be-af16-044d7e11e746
md"
---
###### *Simple* function composition doesn't work with *impure* functions: 

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
##### Elaborated composition of *impure* functions 
Sigfe proposes a *handcoded* solution for function composition of *impure* functions. In his example the *impure* function is called *'debuggable'*.
 
###### Dataflow Diagram of composition of *impure* functions
(adapted from [Sigfe](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html), 2023)

                                        x
                                        |
                                        |
                                     +-----+
                                     | fQM |    fQM (=f-Quotation-Mark) = f'
                                     +-----+
					                   / \
                                     /     \ 
                                   /         \
                                 /             \
                     (fx, fs) ==> (f(x),   '1st, f was called')
                              /                    \
                            /                        \
                          /                            \
                       +-----+                           \
                       | gQM |                             \   
                       +-----+                              |
				         / \                                /  
                       /     \                            /
                     /         \                        / 
                   /             \                    /
    (gfx, gs) ==> (g(f(x)),  '2nd, g was called')   /
                  |                 \             /
                  |                   \         /
                  |                     \     /
                  |                       \ /
                  |                    +------+
                  |                    |  ++  |
                  |                    +------+
                  |                       |
                  |                       |
                  |                       |
    (gfx, fs++gs) = (g(f(x)),  '1st, f was called ++ 2nd,  gwas called')


**Fig. 1.3.5.2** Dataflow-diagram of composing *impure* ('*debuggable*') functions 

"

# ╔═╡ 1ffaf5f9-5a1d-4a32-a259-31d43767c636
md"
---
###### *Handcoded* composition of *impure* functions in Haskell:
We have Sigfe's Haskell [example](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html) slightly modified by renaming functions and local variables.

       let (fx, fs) = f' x
           (gfx, gs) = g' fx in (gfx, fs ++ gs)

###### *Handcoded* composition of *impure* functions in Julia
(code close to Sigfe's Haskell proposal) 
"

# ╔═╡ 43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
let                              
	x = 3
	++ = string                   # local definition of Haskell-like '++'
	f(x::Real)::Real = x*2
	g(x::Real)::Real = x*3
	fQM(x::Real)::Tuple{Real, String} = (f(x), "1st, f was called with $x")
	gQM(x::Real)::Tuple{Real, String} = (g(x), "2nd, g was called with $x")
	(fx, fs) = fQM(x)::Tuple{Real, String}
	(gfx, gs) = gQM(fx)::Tuple{Real, String}
	(gfx, gfs) = (gfx, ++(gs, " ++ ", fs))::Tuple{Real, String}
	(fx, fs), (gfx, gs), (gfx, gfs)::Tuple{Real, String}
end # let

# ╔═╡ f0f8e521-0fc5-496c-a53d-7a623dd24d21
md"""
$(fx, fs), (gfx, gs), (gfx, gfs) \Rightarrow$ 
=> *(6, "1st, f was called with 3"), (18, "2nd, g was called with 6"), (18, "2nd, g was called with 6 ++ 1st, f was called with 3"))*

"""

# ╔═╡ 2e356840-cf1f-4014-9336-29bc28afd5c3
md"
---
##### *Mechanization* composition of *impure* functions with $bind$

Sigfe wants to mechanize the composition of *impure* functions. To this end the 2nd function $g'$ (or our $gQM$) has to be *plumbed* from a *1-ary* $g'$ (or our $gQM$) to a *2-ary* $g''$ (or our $gQQM$) function so that is composable like in gQQM(fQM)(x). The signatures *before* and *after* plumbing are:

*before* plumbing:

$\text{Haskell: } g':: Float \rightarrow (Float, String)$

$\text{Julia: } gQM :: Real \rightarrow (Real, String)$

*after* plumbing:

$\text{Haskell: } g'':: (Float, String) \rightarrow (Float, String)$

$\text{Julia: } gQQM :: (Real, String) \rightarrow (Real, String)$

Plumbing of the *2nd* function should be made by a *higher-order* function $bind$ so that the result is a modified function $g''$ with the signature

$(bind\; g') \Rightarrow g'' :: (Float,String) \rightarrow (Float,String)$

This implies a signature for $bind$:

$bind :: typeof(g') \rightarrow typeof(g'')$ 

and substituting signatures for $typeof(g')$ and $typeof(g'')$

$bind :: (Float -> (Float,String)) \rightarrow ((Float,String) \rightarrow (Float,String))$

*bind*'s purpose is twofold: *it must (1) apply g' to the correct part of f' x and (2) concatenate the string returned by f' with the string returned by g'* (Sigfe, 2006).

As a reminder, the proposal for the *handcoded* composition was (s. above):

       let (fx, fs) = f' x
           (gfx, gs) = g' fx in (gfx, fs ++ gs)

Sigfe (modified) proposal for implementing $bind$ is
 
$bind\; g' \; (fx,fs) = let \; (gfx,gs) = g' \; fx \; in \; (gfx, fs\text{ ++ }gs)$



"

# ╔═╡ c84b120a-5d5f-4d25-b210-5e21e9f377e2
md"
---
###### Implementation of $bind$ in Julia
The Julian code for $bind$ is below. It follows close Sigfe's Haskell proposal. We designed $bind$ as a higher order function returning an anonymous $\lambda$-function with parameters $fx$ and $fs$. These parameters are bound to the values of the function application $fQM(3)::(Real, String)$. The result of this application is a *tuple* with type $Tuple\{Real, String\}.$

"

# ╔═╡ bce7b530-774c-4ed2-a732-7017d522499a
let                                 
	x = 3
	++ = string   
	#-----------------------------------------------
	fQM(x::Real)::Tuple{Real, String} = 
		let f(x::Real)::Real = x*2
			(f(x), "1st, f was called with $x")
		end # let
	#-----------------------------------------------
	gQM(x::Real)::Tuple{Real, String} = 
		let g(x::Real)::Real = x*3
			(g(x), "2nd, g was called with $x")
		end # let
	#-----------------------------------------------
	function bind(gQM::Function)::Function          # bind := curryfied compose !
		(fx, fs)::Tuple{Real, String} ->            # (fx, fs) = fQM(3)
			let (gfx, gs) = gQM(fx)::Tuple{Real, String}
				(gfx, ++(gs, " ++ ", fs))::Tuple{Real, String}
			end # let
	end # function bind
	#-----------------------------------------------
	gQQM = bind(gQM)::Function
	gQQM(fQM(x))::Tuple{Real, String}
end # let

# ╔═╡ 0d86a503-7060-4028-9e6a-fbe9b16a5bae
md"""

The signature of our Julian implementation of $bind$ demonstrates the equivalence to Sigfe's Haskell proposal. The signature of Julian $bind$ is:

$bind::typeof(gQM) \rightarrow typeof(qQQM)$

and inserting signatures $typeof(gQM), typeof(qQQM)$:

$bind:: (Real \rightarrow (Real, String)) \rightarrow ((Real, String) \rightarrow (Real, String))$

This is the same signature as from Sigfe's proposal.

$bind :: typeof(g') \rightarrow typeof(g'')$ 

and substituting signatures for $typeof(g')$ and $typeof(g'')$

$bind :: (Float -> (Float,String)) \rightarrow ((Float,String) \rightarrow (Float,String)).$

Application $bind(gQM)$ generates a *plumbed* version $gQQM$ of $gQM$ with signature

$bind(gQM) \Rightarrow gQQN::(Real, String) \rightarrow (Real, String)$

and application to the result of $fQM(3)$ generates the desired tuple 

$(gfx, \text{++(gs, " ++ "}, fs)):: (Real, String)$

or

$bind(gQM)((fQM(3)) \Rightarrow gQQM(fQM(3) :: (Real, String).$

The result is:

$bind(gQM)(fQM(3)) == gQQM(fQM(3)) \Rightarrow$

=> *(18, "2nd, g was called with 6 ++ 1st, f was called with 3"*)

"""

# ╔═╡ 87dc553a-86d4-425b-8ec8-cdd911b79e0b
md"
---
###### Composition variants of *impure* functions with a *curryfied* $bindQM$
($bindQM$ is an *extension* to Sigfe's $bind$)

- The signature of the fully *currified* call $bindQM(gQM)(fQM)(x)$ is:

$bindQM :: Real \rightarrow typeof(fQM) \rightarrow typeof(gQM) \rightarrow (Real, String)$

$bindQM :: Real \rightarrow (Real \rightarrow (Real, String)) \rightarrow (Real \rightarrow (Real, String)) \rightarrow (Real, String)$

- The signature of the shortened call $bindQM(gQM)(fQM)$ is:

$bindQM :: typeof(fQM) \rightarrow typeof(gQM)$

$bindQM :: (Real \rightarrow (Real, String)) \rightarrow (Real \rightarrow (Real, String))$

- The signature of $bindQM(gQM)$ is:

$bindQM :: typeof(gQM)$

$bindQM :: (Real \rightarrow (Real, String))$

"

# ╔═╡ 31643b02-de5a-411a-af7c-a3e47123df4f
let
	 #------------------------------------------------------------------
     x = 3
     ++ = string
     #------------------------------------------------------------------
     fQM(x::Real)::Tuple{Real, String} =
         let f(x::Real)::Real = x*2
             (f(x), "1st, f was called with $x")
         end # let
     #------------------------------------------------------------------
     gQM(x::Real)::Tuple{Real, String} =
         let g(x::Real)::Real = x*3
             (g(x), "2nd, g was called with $x")
         end # let
     #------------------------------------------------------------------
	 # bind := curryfied compose !
     function bindQM(gQM::Function)::Function  
         fQM::Function ->
             x::Real ->
                 let (fx, fs) = fQM(x)::Tuple{Real, String}
                     (gfx, gs) = gQM(fx)::Tuple{Real, String}
                     (gfx, ++(gs, " ++ ", fs))::Tuple{Real, String}
                 end # let
     end # function bind
     #------------------------------------------------------------------
     # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     bindQM(gQM, fQM, x) = bindQM(gQM)(fQM)(x)
     bindQM(gQM, fQM, x)
     #------------------------------------------------------------------    		 	 # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     bindQM(gQM, fQM)    = bindQM(gQM)(fQM) 
     bindQM(gQM, fQM)(x)
     #------------------------------------------------------------------
	 # ==> (18, "1st, f was called with 3 ++ 2nd, g was called with 6")
     bindQM(gQM)        = bindQM(gQM)
     bindQM(gQM)(fQM)(x)
     #------------------------------------------------------------------
end # let


# ╔═╡ 07e7e133-7076-47b9-a9ba-1db8305a6025
md"""
The three alternatives using $bind$ are:

The last variant is close but not identical to Sigfe's proposal. Sigfe's $bind(g')$ and our $bind(QM)$ expect a *tuple* $(Real, String)$, whereas the $bindQM(gQM)$ expects a *function* $fQM(x)$ with a different signature.
This mismatch can be seen below, when we feed *our* full *curryfied* $bindQM$ with the application $fQM(x)$.

"""

# ╔═╡ 521ea93c-5838-4782-ba6a-436ba900b6e8
let
	 #------------------------------------------------------------------
     x = 3
     ++ = string
     #------------------------------------------------------------------
     fQM(x::Real)::Tuple{Real, String} =
         let f(x::Real)::Real = x*2
             (f(x), "1st, f was called with $x")
         end # let
     #------------------------------------------------------------------
     gQM(x::Real)::Tuple{Real, String} =
         let g(x::Real)::Real = x*3
             (g(x), "2nd, g was called with $x")
         end # let
     #------------------------------------------------------------------
	 # bind := curryfied compose !
     function bindQM(gQM::Function)::Function  
         fQM::Function ->
             x::Real ->
                 let (fx, fs) = fQM(x)::Tuple{Real, String}
                     (gfx, gs) = gQM(fx)::Tuple{Real, String}
                     (gfx, ++(gs, " ++ ", fs))::Tuple{Real, String}
                 end # let
     end # function bind
     #------------------------------------------------------------------
     bindQM(gQM)        = bindQM(gQM)
     bindQM(gQM)(fQM(x))                 #  <==  error: mismatch !
end # let

# ╔═╡ 9f1a9576-4fa2-47d4-b9ae-11a136fa71b2
md"
What is a resumee of the effect of $bind$ and $bindQM$ ? We have two alternatives $bind, bindQM$ in composing *impure* functions $f',g'$ or $fQM, gQM$. We have to see, what of both provides us more insight into the concept *monad*. 

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
# ╟─128e9c6d-8710-49ad-9739-c09805a2ea39
# ╟─c1aa3a0b-2bbd-449d-adfd-3d22e1251aeb
# ╟─6deab13f-f9bd-4bde-be94-f78b8df1ce58
# ╟─9f239124-aae1-42be-af16-044d7e11e746
# ╠═880c2599-0f86-41c0-b496-1635e1264e4a
# ╟─f5b7cf8e-3127-4253-9ebb-62f7ae8fbc65
# ╟─1ffaf5f9-5a1d-4a32-a259-31d43767c636
# ╠═43a6ddf5-60ad-4fab-a3d3-a7a2e7bdafd4
# ╟─f0f8e521-0fc5-496c-a53d-7a623dd24d21
# ╟─2e356840-cf1f-4014-9336-29bc28afd5c3
# ╟─c84b120a-5d5f-4d25-b210-5e21e9f377e2
# ╠═bce7b530-774c-4ed2-a732-7017d522499a
# ╟─0d86a503-7060-4028-9e6a-fbe9b16a5bae
# ╟─87dc553a-86d4-425b-8ec8-cdd911b79e0b
# ╠═31643b02-de5a-411a-af7c-a3e47123df4f
# ╟─07e7e133-7076-47b9-a9ba-1db8305a6025
# ╠═521ea93c-5838-4782-ba6a-436ba900b6e8
# ╟─9f1a9576-4fa2-47d4-b9ae-11a136fa71b2
# ╟─1fb51d85-8dff-40c3-8f51-158516255409
# ╟─8826d494-fa7d-4882-be93-7d5069d245b3
# ╟─94bf2bc2-5d9e-412c-96e5-6b6e350b9ff4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
