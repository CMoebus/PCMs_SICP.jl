### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 7d9a4133-99cf-40f4-9920-c0425f6676f3
using Plots

# ╔═╡ e8c1f880-0278-11ec-2538-13bb2f14d606
md"
======================================================================================
#### SICP: [2.1.1 Arithmetic Operations For Rational Numbers](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1_002e1)

###### file: PCM20210821\_SICP\_2.1.1\_ArithmeticOperationsForRationalNumbers.jl

###### Julia/Pluto.jl-code (1.8.2/0.19.14) by PCM *** 2023/02/20 ***
======================================================================================
"

# ╔═╡ 6011e641-b628-4642-8c55-549b05efbb89
md"
##### Relations between *number* sets

$$\mathbb N \subset \mathbb Z \subset \mathbb Q \subset \mathbb R \subset \mathbb C$$
More on *rational numbers* $$\mathbb Q$$ can be found [here](https://en.wikipedia.org/wiki/Rational_number).

---
"

# ╔═╡ 2b87595b-9491-4ebe-acb9-1ab7d43c4678
md"
#### 2.1.1.1 SICP-Scheme-like *functional*, mostly *un*typed Julia
###### ... with *imperative* construct $$while$$
"

# ╔═╡ 55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
md"
We represent rational numbers as *pairs* of numerator and denominators in four alternative ways:
- the *first* is the *default* way, very *Scheme-like* by an *un*typed *named tuple* with two fields $$car$$ and $$cdr$$; the construction is deferred into the body of a constructor function $$cons$$. 
- the *second* is the first *specialized* way by using Julia's *built-in* type $$Pair$$. The construction of pairs is deferred to the body of a constructor function $$cons2$$. The two fields can accessed by $$first$$ and $$second$$. They are hidden in the *Scheme*-like selector functions $$car2$$ and $$cdr2$$.
- the *third* is the second *specialized* way by using Julia's *built-in* type $$Rational$$. The construction of pairs is deferred to the body of a *Scheme*-like constructor function $$cons3$$. The two fields can accessed by the functions $$numerator$$ and $$denominator$$. They are hidden in the *Scheme*-like selector functions $$car3$$ and $$cdr3$$.
- the *fourth* is the most easy and third *specialized* way by using Julia's *built-in* type $$Rational$$ and its *built-in* operators $$+, -, *, /$$, and $$==$$. The construction of rationals is done by using Julia's *built-in* constructon operator $$//$$. The two fields can accessed by $$numerator$$ and $$denominator$$. 
In this chapter we do *not* exploit Julia's *multiple dispatch*. So all functions have slightly different names depending on the number of the alternative. *Multiple dispatch* is valuable for subordinating alternative *functions* as *methods* under the umbrella of a reduced set of function objects. 
"

# ╔═╡ d4e48294-c66c-4fa3-9586-89fb825a4ee8
md"
##### 2.1.1.1.1 Arithmetic Operations for Rational Numbers 
###### *1st* methods (*default*, *un*typed) of functions $$add\_rat$$, $$sub\_rat$$, $$mul\_rat$$, $$div\_rat$$, $$equal\_rat$$ 
"

# ╔═╡ dc723ee4-97ce-41a3-88b0-49ccb31c289e
md"
---
###### Addition
$$+\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x+y = \frac{n_x}{d_x}+\frac{n_y}{d_y}= \frac{n_x d_y + n_y d_x}{d_x d_y}$$

---
"

# ╔═╡ 68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
md"
---
###### Subtraction
$$-\;\; : \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x-y = \frac{n_x}{d_x}-\frac{n_y}{d_y}= \frac{n_x d_y - n_y d_x}{d_x d_y}$$

---
"

# ╔═╡ bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
md"
---
###### Multiplication
$$\cdot\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$x \cdot y = \frac{n_x}{d_x} \cdot \frac{n_y}{d_y}= \frac{n_x n_y}{d_x d_y}$

---
"

# ╔═╡ 0875ee4d-e127-4140-a863-04c3a02c38a5
md"
---
###### Division
$$/\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb Q$$
$$x/y = \left(\frac{n_x}{d_x}\right)/\left(\frac{n_y}{d_y}\right) = \frac{n_x d_y}{d_x n_y}$$

---
"

# ╔═╡ f74ced3c-487c-4428-bcfc-cc69e5416227
md"
---
###### Equality test
$$=\;\;: \;\; \mathbb Q \times \mathbb Q \rightarrow \mathbb B$$
$$(x=y) \equiv \left(\frac{n_x}{d_x} = \frac{n_y}{d_y}\right) \equiv (n_x d_y = d_x n_y)$$

---
"

# ╔═╡ 08ede030-fb83-4337-8c37-f346b1b7ebc0
md"
---
##### 2.1.1.1.2 Pairs (... as *Named* Tuples)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ as Julia-*tuples* with *named* fields. 

The *interface* of pair-related functions $cons, cadr$, and $cdr$ is similar to *M-expr*-functions (= *Meta-language* expressions) introduced by *McCarthy* et al. (1965, p.9). 

...*there are two LISP's: there is the algorithmic language and there is the programming language. The programing language is a data structure representation of the algorithmic language. The algorithmic language is called the* **meta-language** *or* **M-expr LISP**, *and for historical purposes, the programming language is called* **S-expr LISP**  (Allen, J., 1978, p.107).

So the *interface* of our Scheme-like functions resembles in form and function expressions of *McCarthy's meta-language*.

"

# ╔═╡ d2d4dd60-f2e4-421c-80cd-63fb61faf31c
md"
$$\begin {array}{c|c|c}
                    & \text{Abstraction Hierarchy}               &                  \\
\hline
\text{ Abstract}    &             addRat, subRat                 & \text{level 2}   \\
\text{Operators}    &        mulRat, divRat, equalRat            & \text{Domain}    \\
                    &                printRat                    &                  \\
\hline
\text{Constructor/} &                makeRat                     & \text{level 1}   \\
\text{Selectors}    &              numer, denom                  &                  \\
\hline
\text{Constructor/} &                  cons                      & \text{level 0}   \\
\text{Selectors}    &                car, cdr         & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &    consCell = (car = ... , cdr = ...)      & \text{level -1}  \\
\text{Selectors}    &        consCell.car, consCell.cdr          & \textit{Julia}   \\
\hline
\end {array}$$

**Fig. 2.1.1.1**: *First* default abstraction hierarchy for *rational* number algebra or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1))

---
"

# ╔═╡ 1c6a666d-c388-4ac9-b65f-dcebf9fc082f
md"
###### *1st* method (*default*, *un*typed) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with named fields $$car$$ and $$cdr$$
"

# ╔═╡ 3b7faab0-b8e0-4bea-894f-16fd35e5727f
cons(car, cdr) = (car=car, cdr=cdr) # cons(<par1>, <par2>) = (car=<par1>, cdr=<par2>)

# ╔═╡ 80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
car(cons) = cons.car                # definition of selector 'car'

# ╔═╡ 1c695d3b-c88e-4227-8aa1-e88149a4f9f4
cdr(cons) = cons.cdr                # definition of selector 'cdr'

# ╔═╡ 3e8c66d9-f3ce-4235-b096-6544daf9632f
let
	yMax = 3
	#------------------------------------------------------------------------------
	function plotInvUnaryTree!(markOfLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=2, fontSize=9)
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8),  # root
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree+heightOfTree/8)],                                  # leaf 
			lw=1, linecolor=:black)                      
		annotate!(                                               # mark of leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree, text(markOfLeaf, fontSize, :blue)))                  
		annotate!(                                               # mark of root 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                             
	end # function plotUnaryTree!
	#------------------------------------------------------------------------------
	function plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=1.5, heightOfTree=2, fontSize=9) 
		annotate!(                                          # mark of left leaf 'x'
			(coordinateXOfRootMark-widthOfTree/2, 
			 coordinateYOfRootMark-heightOfTree, 
			 text(markOfLeftLeaf, fontSize, :blue)))         
		plot!([                                     # plot of left vertical arm '|'
			(coordinateXOfRootMark-widthOfTree/2,   
			coordinateYOfRootMark-heightOfTree+heightOfTree/8),  
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		annotate!(                                         # mark of right leaf 'x'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree, 
			text(markOfRightLeaf, fontSize, :blue)))        
		plot!([                                    # plot of right vertical arm '|'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree+heightOfTree/8), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)          
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8)], 
			lw=1, linecolor=:black) 
		annotate!(                                          # mark of root leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                       
	end # function plotBinaryTree!
	#------------------------------------------------------------------------------
	function plotInvTernaryTree!(markOfLeftLeaf, markOfMiddleLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=3.0,
	heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvUnaryTree!(markOfMiddleLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotTernaryTree!
	#------------------------------------------------------------------------------
	function plotInvQuaternyTree!(markOfLeftMostLeaf, markOfLeftLeaf, markOfRightLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=4.0, heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftMostLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree/3, heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotQuaternyTree!
	#------------------------------------------------------------------------------
	plot(xlim=(-1.5, 8.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ b068c8b6-7cfd-47c0-9e87-ee4cd7537bce
md"
**Fig. 2.1.1.2** $$consCell := (1 \bullet 2)$$

---
"

# ╔═╡ 3fba0329-19ac-485a-a56d-ee64ae0e3573
consCell = cons(1, 2)            # construction of 2-tuple consCell

# ╔═╡ 44d3380a-b2ab-43e1-8f03-a14a9599fac0
typeof(consCell)

# ╔═╡ 44017d8b-476e-4e9c-abac-229e9a2e85d1
car(consCell)                    # selection of field 'car' of 2-tuple consCell

# ╔═╡ 51732672-ee53-46e7-85bf-217f531867cc
cdr(consCell)                    # selection of field 'cdr' of 2-tuple consCell

# ╔═╡ 6fa45a52-31fd-44c6-9928-4a75a7feccc0
let
	yMax = 4
	#------------------------------------------------------------------------------
	function plotHorizontalLine!(markOfLeftNode, markOfRightNode, coordinateXOfMiddle, coordinateYOfMiddle; lengthOfLine=2.0, fontSize=9)
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfMiddle-lengthOfLine/2+lengthOfLine/10, coordinateYOfMiddle), 
			(coordinateXOfMiddle+lengthOfLine/2-lengthOfLine/10, coordinateYOfMiddle)], 
			lw=1, linecolor=:black, arrow=true) 
		annotate!(                                         # mark of left node  'x'
			(coordinateXOfMiddle-lengthOfLine/2, coordinateYOfMiddle, text(markOfLeftNode, fontSize, :blue)))                  
		annotate!(                                         # mark of right node 'x'
			(coordinateXOfMiddle+lengthOfLine/2, coordinateYOfMiddle, text(markOfRightNode, fontSize, :blue)))       
	end # function plotHorizontalLine!
	#------------------------------------------------------------------------------
	function plotInvUnaryTree!(markOfLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=2, fontSize=9)
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8),  # root
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree+heightOfTree/8)],                                  # leaf 
			lw=1, linecolor=:black)                      
		annotate!(                                               # mark of leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree, text(markOfLeaf, fontSize, :blue)))                  
		annotate!(                                               # mark of root 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                             
	end # function plotUnaryTree!
	#------------------------------------------------------------------------------
	function plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=1.5, heightOfTree=2, fontSize=9) 
		annotate!(                                          # mark of left leaf 'x'
			(coordinateXOfRootMark-widthOfTree/2, 
			 coordinateYOfRootMark-heightOfTree, 
			 text(markOfLeftLeaf, fontSize, :blue)))         
		plot!([                                     # plot of left vertical arm '|'
			(coordinateXOfRootMark-widthOfTree/2,   
			coordinateYOfRootMark-heightOfTree+heightOfTree/8),  
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		annotate!(                                         # mark of right leaf 'x'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree, 
			text(markOfRightLeaf, fontSize, :blue)))        
		plot!([                                    # plot of right vertical arm '|'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree+heightOfTree/8), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)          
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8)], 
			lw=1, linecolor=:black) 
		annotate!(                                          # mark of root leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                       
	end # function plotBinaryTree!
	#------------------------------------------------------------------------------
	function plotInvTernaryTree!(markOfLeftLeaf, markOfMiddleLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=3.0,
	heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvUnaryTree!(markOfMiddleLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotTernaryTree!
	#------------------------------------------------------------------------------
	function plotInvQuaternyTree!(markOfLeftMostLeaf, markOfLeftLeaf, markOfRightLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=4.0, heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftMostLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree/3, heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotQuaternyTree!
	#------------------------------------------------------------------------------
	plot(xlim=(-1.5, 8.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalLine!("y", "•", 2.0, yMax-2.0;lengthOfLine=4.0)
	plotInvBinaryTree!("3", "4", "•", 4.0, yMax-2.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ 6a584664-cda8-41c1-8bfe-2b7d5b5e1e28
md"
**Fig. 2.1.1.3** consCell $$y \mapsto (3 \bullet 4)$$

---
"

# ╔═╡ a1587038-c11d-4b4b-8436-b098b61f1077
y = cons(3, 4)               # construction of 2-tuple (= cons-cell) y

# ╔═╡ 118b16a3-093f-4b39-823b-ac167da69615
car(y)

# ╔═╡ fb4ecf01-1361-43c5-854d-8c83969a2e60
cdr(y)

# ╔═╡ 099f789b-9fdd-4643-8c6e-b5054af12736
let
	yMax = 4
	#------------------------------------------------------------------------------
	function plotHorizontalArrowFromLeftToRight!(markOfLeftNode, markOfRightNode, coordinateXOfMiddle, coordinateYOfMiddle; lengthOfLine=2.0, fontSize=9)
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfMiddle-lengthOfLine/2+lengthOfLine/10, coordinateYOfMiddle), 
			(coordinateXOfMiddle+lengthOfLine/2-lengthOfLine/10, coordinateYOfMiddle)], 
			lw=1, linecolor=:black, arrow=true) 
		annotate!(                                         # mark of left node  'x'
			(coordinateXOfMiddle-lengthOfLine/2, coordinateYOfMiddle, text(markOfLeftNode, fontSize, :blue)))                  
		annotate!(                                         # mark of right node 'x'
			(coordinateXOfMiddle+lengthOfLine/2, coordinateYOfMiddle, text(markOfRightNode, fontSize, :blue)))       
	end # function plotHorizontalArrowFromLeftToRight!
	#------------------------------------------------------------------------------
	function plotHorizontalArrowFromRightToLeft!(markOfLeftNode, markOfRightNode, coordinateXOfMiddle, coordinateYOfMiddle; lengthOfLine=2.0, fontSize=9)
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfMiddle+lengthOfLine/2-lengthOfLine/10, coordinateYOfMiddle), 
			(coordinateXOfMiddle-lengthOfLine/2+lengthOfLine/10, coordinateYOfMiddle)], 
			lw=1, linecolor=:black, arrow=true) 
		annotate!(                                         # mark of left node  'x'
			(coordinateXOfMiddle-lengthOfLine/2, coordinateYOfMiddle, text(markOfLeftNode, fontSize, :blue)))                  
		annotate!(                                         # mark of right node 'x'
			(coordinateXOfMiddle+lengthOfLine/2, coordinateYOfMiddle, text(markOfRightNode, fontSize, :blue)))       
	end # function plotHorizontalArrowFromRightToLeft!
	#------------------------------------------------------------------------------
	function plotInvUnaryTree!(markOfLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=2, fontSize=9)
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8),  # root
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree+heightOfTree/8)],                                  # leaf 
			lw=1, linecolor=:black)                      
		annotate!(                                               # mark of leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree, text(markOfLeaf, fontSize, :blue)))                  
		annotate!(                                               # mark of root 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                             
	end # function plotUnaryTree!
	#------------------------------------------------------------------------------
	function plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=1.5, heightOfTree=2, fontSize=9) 
		annotate!(                                          # mark of left leaf 'x'
			(coordinateXOfRootMark-widthOfTree/2, 
			 coordinateYOfRootMark-heightOfTree, 
			 text(markOfLeftLeaf, fontSize, :blue)))         
		plot!([                                     # plot of left vertical arm '|'
			(coordinateXOfRootMark-widthOfTree/2,   
			coordinateYOfRootMark-heightOfTree+heightOfTree/8),  
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		annotate!(                                         # mark of right leaf 'x'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree, 
			text(markOfRightLeaf, fontSize, :blue)))        
		plot!([                                    # plot of right vertical arm '|'
			(coordinateXOfRootMark+widthOfTree/2, 
			coordinateYOfRootMark-heightOfTree+heightOfTree/8), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)                   
		plot!([                                        # plot of horizontal bar '-'
			(coordinateXOfRootMark-widthOfTree/2, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark+widthOfTree/2, coordinateYOfRootMark-heightOfTree/2)], 
			lw=1, linecolor=:black)          
		plot!([                                   # plot of middle vertical arm '|'
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/2), 
			(coordinateXOfRootMark, coordinateYOfRootMark-heightOfTree/8)], 
			lw=1, linecolor=:black) 
		annotate!(                                          # mark of root leaf 'x'
			(coordinateXOfRootMark, coordinateYOfRootMark, text(markOfRoot, fontSize, :blue)))                                       
	end # function plotBinaryTree!
	#------------------------------------------------------------------------------
	function plotInvTernaryTree!(markOfLeftLeaf, markOfMiddleLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=3.0,
	heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvUnaryTree!(markOfMiddleLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotTernaryTree!
	#------------------------------------------------------------------------------
	function plotInvQuaternyTree!(markOfLeftMostLeaf, markOfLeftLeaf, markOfRightLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=4.0, heightOfTree=2, fontSize=9)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftMostLeaf, markOfRightMostLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree, heightOfTree=heightOfTree, fontSize=fontSize)
		#---------------------------------------------------------
		plotInvBinaryTree!(markOfLeftLeaf, markOfRightLeaf, markOfRoot, coordinateXOfRootMark, coordinateYOfRootMark; widthOfTree=widthOfTree/3, heightOfTree=heightOfTree, fontSize=fontSize)
	end # function plotQuaternyTree!
	#------------------------------------------------------------------------------
	plot(xlim=(-2.5, 12.0), ylim=(0, yMax), legend=:false, ticks=:none)
	plotHorizontalArrowFromRightToLeft!("•", "y", 9.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("x", "•", 1.0, yMax-2.0;lengthOfLine=4.0)
	plotHorizontalArrowFromLeftToRight!("z", "•", 2.0, yMax-1.0;lengthOfLine=6.0)
	plotInvBinaryTree!("3", "4", "•", 7.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("1", "2", "•", 3.0, yMax-2.0; widthOfTree=2.0, heightOfTree=1)
	plotInvBinaryTree!("•", "•", "•", 5.0, yMax-1.0; widthOfTree=4.0, heightOfTree=1)
	#------------------------------------------------------------------------------
end # let

# ╔═╡ d1cd6289-c53d-4561-9895-4958c3e150b5
md"
**Fig. 2.1.1.4** consCell $$z \mapsto cons(x \bullet y) = ((1 \bullet 2) \bullet (3 \bullet 4))$$

---
"

# ╔═╡ f0c42132-4b04-4b48-aa45-b45b4f585466
x = cons(1, 2)

# ╔═╡ 132232a8-495f-4f2c-a08a-da4b898f606b
z = cons(x, y)               # construction of 2-tuple z

# ╔═╡ 768b4543-6d34-4af7-9ee1-6120a33a169d
car(z)

# ╔═╡ 8b990c96-d5e2-4e77-ae73-eae3bc399f9d
cdr(z)

# ╔═╡ 4e7da88e-e73e-4d15-bd5f-b1eed925322d
car(car(z))

# ╔═╡ 9b7d9d52-77c6-4328-8018-3b1e40fb9558
car(cdr(z))

# ╔═╡ 7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
md"
---
##### 2.1.1.1.3 Representing Rational Numbers (... with *Named* Tuples)

"

# ╔═╡ 8b2fb52c-7519-410f-a872-610cdb911b72
md"
##### 2.1.1.1.3.1 Abstract *Untyped* Constructor $$makeRat$$ based on $$cons$$
"

# ╔═╡ 680c5ec0-6cf2-4b0c-a005-751ef8a7e568
md"
###### *1st* method (default, *un*typed, *without* gcd) of function $$makeRat$$
"

# ╔═╡ 7ff3b4a0-e00b-424f-8118-897019d0fc20
makeRat(n, d) = cons(n, d)  

# ╔═╡ 810b1eca-eac7-49cb-a34f-8328ea432824
md"
###### *2nd* method (*specialized*, *typed*, *with* gcd) of function $$makeRat$$
###### ... with type $$Signed$$ and imperative *looping* construct $$while$$
"

# ╔═╡ df37be85-589a-46aa-a14c-8ab67c461ae9
function makeRat(n::Signed, d::Signed)
	#----------------------------------------------------------
	function gcd2(a, b) 
		#------------------------------------------------------
		remainder = %          # local function definition
	    #------------------------------------------------------
		b == 0 ? a : gcd(b, remainder(a, b))
		#----------------------------------------=-------------
		while !(b == 0)
			a,b = b, remainder(a, b) # parallel (!) assignment
		end # while
		a
		#----------------------------------------=-------------
	end  # function gcd2
	#----------------------------------------=-----------------
	let g = gcd2(n, d)
		cons(n ÷ g, d ÷ g)
	end # let
	#----------------------------------------=-----------------
end # function makeRat

# ╔═╡ 764ec0e3-66c3-4a67-9473-95380e11250b
md"
##### 2.1.1.1.3.2 Abstract *Un*typed Selectors $$numer, denom$$ based on $$car, cdr$$
"

# ╔═╡ 193ae321-0f26-44cc-a48f-1a1b9bc71af8
numer(x) = car(x)            # definition of abstract selector 'numer'

# ╔═╡ d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
denom(x) = cdr(x)            # definition of abstract selector 'denom'

# ╔═╡ ca75c0f7-2e85-4436-8544-9b19aa0f57a8
function addRat(x, y)
	makeRat(+(*(numer(x), denom(y)), *(numer(y), denom(x))), *(denom(x), denom(y)))
end # function addRat

# ╔═╡ a181310f-1f46-43b2-8702-a8a60308ccfe
function subRat(x, y)
	makeRat(-(*(numer(x), denom(y)), *(numer(y), denom(x))), *(denom(x), denom(y)))
end # function subRat

# ╔═╡ 778e12ad-bfe7-4f02-a946-894249fe2375
function mulRat(x, y)
	makeRat(*(numer(x), numer(y)), *(denom(x), denom(y)))
end # function mulRat

# ╔═╡ dce13d9a-7ffd-475a-84de-7826a1198f38
function divRat(x, y)
	makeRat(*(numer(x), denom(y)), *(denom(x), numer(y)))
end # function divRat

# ╔═╡ bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
function equalRat(x, y)
	*(numer(x), denom(y)) == *(denom(x), numer(y))
end # function equalRat

# ╔═╡ 61340177-3808-4a2b-906f-51b801178c6f
md"
##### 2.1.1.1.3.3 Output function $$print\_rat$$
(= Transformation of *internal* into *external* form)

"

# ╔═╡ 172db576-f756-4d62-94c3-128c6ac4f847
# idiomatic Julia-code with string interpolation "$(.....)"
printRat(x) = "$(numer(x))//$(denom(x))"

# ╔═╡ a9341f5b-8b06-4994-ba6b-58070485c336
md"
##### 2.1.1.1.4 Applications
"

# ╔═╡ 9b1a0332-0170-424b-be4d-abba0c042ff6
one_half = makeRat(1, 2)

# ╔═╡ 5e19e77d-ccea-4825-807d-5a278d762978
typeof(one_half)

# ╔═╡ cafada61-82c1-4231-bcd8-9887df2be87c
one_third = makeRat(1, 3)

# ╔═╡ e20d52b3-204c-4105-a362-2b9e66fe22f9
two_twelves = makeRat(2, 12)             # with (!) application of gcd

# ╔═╡ 63d09ac2-193d-49dc-9eff-d5c14f973627
addRat(one_half, one_third)              # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 69facaff-5c1f-4c8e-a436-81e8f9cd73b9
equalRat(makeRat(2, 3), makeRat(6, 9)) # 2/3 = 6/9

# ╔═╡ 45772e1e-aa83-46cd-add7-4f977f58dff0
equalRat(makeRat(1, 2), makeRat(3, 6)) # 1/2 = 3/6 => 1/2 = 1/2

# ╔═╡ d3d1980c-00f3-4d04-abe5-8705f61b3459
equalRat(makeRat(4, 3), makeRat(120, 90))  # 4/3 = 120/90 => 4/3 = 4/3

# ╔═╡ a861fc71-5a96-43b4-9a8f-94a603d2cb3b
md"
###### new: [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ aa7ea22e-f330-427e-9d89-408003e6b8f2
355/113

# ╔═╡ bf4034ad-07ff-4400-8aba-3b855fc43a5c
355/113 - π                   # deviation from Julia π

# ╔═╡ c70c4a99-32b9-4c70-8b36-064d313e753c
md"
---
#### 2.1.1.2 idiomatic *imperative*, *typed* Julia ...
###### ... with types $$Signed$$, $$Pair$$, $$Rational$$, *multiple* methods, '%', and 'while'
"

# ╔═╡ 285428ce-c13e-43ca-add3-672b1e454e18
md"
##### 2.1.1.2.1 Arithmetic Operations for Rational Numbers 
###### *2nd* methods (*specialized*, *typed* ($$Pair$$)) of functions $$addRat$$, $$subRat$$, $$mulRat$$, $$divRat$$, $$equalRat$$
"

# ╔═╡ cc592f32-8785-4735-badd-de3903c20f05
md"
---
##### 2.1.1.2.2 Pairs (... as Julia's $$Pair$$)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ are implemented here as Julia's $$Pair$$
"

# ╔═╡ d4c053d6-ba2c-4d88-beef-19873926df88
md"
###### *2nd* method (*specialized*, *typed*) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with constructor $$Pair(<par1>, <par2>)$$ and fields $$first$$ and $$second$$. These selectors are deferred and hided into the *Scheme*-like selctors $$car, cdr$$.

"

# ╔═╡ 20fa866b-a9d2-4446-a57a-c01fe145aaac
md"
$$\begin {array}{c|c|c}
                    & \text{Abstraction Hierarchy}               &                  \\
\hline
\text{ Abstract}    &             addRat2, subRat2               & \text{level 2}   \\
\text{Operators}    &        mulRat2, divRat2, equalRat2         & \text{Domain}    \\
                    &                printRat                    &                  \\
\hline
\text{Constructor/} &                makeRat2                    & \text{level 1}   \\
\text{Selectors}    &              numer2, denom2                &                  \\
\hline
\text{Constructor/} &                 cons2                      & \text{level 0}   \\
\text{Selectors}    &               car2, cdr2        & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &    consCell = Pair(first:...,second:...)   & \text{level -1}  \\
\text{Selectors}    &      consCell.first, consCell.second       & \textit{Julia}   \\
\hline
\end {array}$$

**Fig. 2.1.1.5**: *Second* abstraction hierarchy for *rational* number algebra or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1))

---

"

# ╔═╡ 0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# idiomatic Julia-code by built-in types 'Signed' and constructor 'Pair'
cons2(car::Signed, cdr::Signed)::Pair = Pair(car::Signed, cdr::Signed)::Pair

# ╔═╡ 1fddd3ae-5da7-4a32-a53e-077b8f37509c
car2(cons::Pair)::Signed = cons.first::Signed   # Pair-selector 'first'

# ╔═╡ b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
cdr2(cons::Pair)::Signed = cons.second::Signed  # Pair-selector 'second'

# ╔═╡ d84101ea-7172-4e1f-9929-1a23acd7a7c7
md"
---
##### 2.1.1.2.3 Representing Rational Numbers (... with type $$Pair$$)

"

# ╔═╡ b4c9a74b-5a49-452e-bbf0-44826cd92e46
md"
###### 2.1.1.2.3.1 Abstract *Typed* Constructor $$make\_rat$$
"

# ╔═╡ 3498e844-931f-4d46-a9aa-b9a2d3b892e7
# idiomatic Julia-code by '÷'
function makeRat2(n::Signed, d::Signed)::Pair
	#----------------------------------------------------------
	function gcd2(a::Signed, b::Signed)::Signed
		#---------------------------------------
		remainder = %
		#---------------------------------------
		b == 0 ? a : gcd(b, remainder(a, b))
		#---------------------------------------
		while !(b == 0)
			a,b = b, remainder(a, b) # multiple (!) assignment
		end # while
		a
	end # function gcd2
	#----------------------------------------------------------
	let g = gcd2(n, d)
		cons2(n ÷ g, d ÷ g)::Pair
	end # let
end # function makeRat2

# ╔═╡ 4e179b9f-021e-4891-8e27-7fa36b827fcf
md"
###### 2.1.1.2.3.2 Abstract *Typed* Selectors $$numer, denom$$
"

# ╔═╡ 7f5b9164-07c2-4ae1-888d-f601fa9d286c
numer2(x::Pair)::Signed = car2(x::Pair)::Signed

# ╔═╡ 3ca05b52-413f-46aa-9fd7-659227dccbd7
denom2(x::Pair)::Signed = cdr2(x::Pair)::Signed

# ╔═╡ 76e3a4bc-fde2-4440-96c1-c492cc120db0
function addRat2(x::Pair, y::Pair)::Pair
	makeRat2(numer2(x) * denom2(y) + numer2(y) * denom2(x), denom2(x) * denom2(y))
end

# ╔═╡ 402d8963-26bc-4db2-b94b-ba4334e1d8fd
function subRat2(x::Pair, y::Pair)::Pair
	makeRat2(numer2(x) * denom2(y) - numer2(y) * denom2(x), denom2(x) * denom2(y))
end

# ╔═╡ 09901068-bf38-4392-ab19-66a44d65344d
function mulRat2(x::Pair, y::Pair)::Pair
	makeRat2(numer2(x) * numer2(y), denom2(x) * denom2(y))
end

# ╔═╡ 555e6212-22bd-4d0e-b221-edfe32f043f5
function divRat2(x::Pair, y::Pair)::Pair
	makeRat2(numer2(x) * denom2(y), denom2(x) * numer2(y))
end

# ╔═╡ afe55885-aba6-4cbc-af2c-23d15bbbf6f5
function equalRat2(x::Pair, y::Pair)::Bool
	numer2(x) * denom2(y) == denom2(x) * numer2(y)
end

# ╔═╡ bbccaeb3-48cf-4f65-9aa2-d0de9940e311
md"
###### 2.1.1.2.3.3 Output (= Transformation of *internal* into *external* form)
"

# ╔═╡ 1248e659-dcdb-442c-859c-3289d5561c6f
printRat(x::Pair)::String = "$(numer2(x))//$(denom2(x))"

# ╔═╡ edd94612-1772-4c7a-b8d5-cf5b4a540487
md"
###### 2.1.1.2.4 Applications
"

# ╔═╡ 0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
a2 = cons2(2, 3)

# ╔═╡ 32e3fc67-3872-4a28-bd6b-9cf06bc094ac
car2(a2)

# ╔═╡ e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
cdr2(a2)

# ╔═╡ cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
typeof(1.2)

# ╔═╡ 4bed1729-8c79-4cf1-95e3-3285010a5622
b2 = cons2(1.2, 3) # first argument is 'Float' but should be 'Signed'

# ╔═╡ 4ee29c75-f689-4332-99b9-d7b0951d4487
one_half2 = makeRat2(1, 2)

# ╔═╡ 86b40359-a87d-477e-9615-6b4803fe4fd7
one_third2 = makeRat2(1, 3)

# ╔═╡ d650d480-08ed-478a-8a9f-92cce23ba072
equalRat2(makeRat2(1, 3), makeRat2(2, 6))

# ╔═╡ 999406e8-787a-4f2b-9805-eed631fc6f54
equalRat2(makeRat2(1, 2), makeRat2(3, 6))

# ╔═╡ 4bbd2664-5846-4487-b91c-be7ff75a4e81
equalRat2(makeRat2(1, 3), makeRat2(3, 6))

# ╔═╡ 5be39e55-32ba-4809-9456-431e118b9195
md"
---
#### 2.1.1.3 idiomatic *imperative*, *typed* Julia ...
###### ... with type $$Rational$$
"

# ╔═╡ bb838586-2f8a-44f9-9672-aced83e8cf76
md"
##### 2.1.1.3.1 Arithmetic Operations for Rational Numbers 
###### *3rd* methods (*specialized*, *typed* ($$Rational$$)) of functions $$add\_rat$$, $$sub\_rat$$, $$mul\_rat$$, $$div\_rat$$, $$equal\_rat$$
"

# ╔═╡ 26593de4-f70d-4aa5-86dd-d09bb6544407
function addRat3(x::Rational, y::Rational)::Rational
	x + y
end # function addRat3

# ╔═╡ 6662d041-af9c-472d-b9fe-efe2c4846267
function subRat3(x::Rational, y::Rational)::Rational
	x - y
end # function subRat3

# ╔═╡ 8fc62f98-9a2e-4fae-83b7-a78118b656d3
function mulRat3(x::Rational, y::Rational)::Rational
	x * y
end # function mulRat3

# ╔═╡ f7bd0981-1534-4c80-9697-e019f29c4a3c
function divRat3(x::Rational, y::Rational)::Rational
	x // y
end # function divRat3

# ╔═╡ b25d2465-7452-43e8-b709-06009642076a
function equalRat3(x::Rational, y::Rational)::Bool
	x == y
end # function equalRat3

# ╔═╡ 32927d21-4f21-41ff-b90c-21a9c15a7a26
md"
---
##### 2.1.1.3.2 Pairs (... as Julia's $$Rational$$)
###### Scheme's pair constructor $$cons$$ and Selectors $$car$$ and $$cdr$$ are implemented here as Julia's $$Rational$$
"

# ╔═╡ 5f1971c7-f3bb-4dbf-aa42-4218055e1fd0
md"
###### *3rd* method (*specialized*, *typed*) of function $$cons, car$$, and $$cdr$$
definition of constructor $$cons$$ with constructor $$//$$ and fields $$numerator$$ and $$denominator$$
"

# ╔═╡ 61794b44-f955-4486-8b1e-863dca1082c2
md"
$$\begin {array}{c|c|c}
                    &        \text{Abstraction Hierarchy}        &                  \\
\hline
\text{ Abstract}    &           addRat3, subRat3                 & \text{level 2}   \\
\text{Operators}    &       mulRat3, divRat3, equalRat3          & \text{Domain}    \\
                    &                printRat                    &                  \\
\hline
\text{Constructor/} &                makeRat3                    & \text{level 1}   \\
\text{Selectors}    &              numer3, denom3                &                  \\
\hline
\text{Constructor/} &                  cons3                     & \text{level 0}   \\
\text{Selectors}    &                car3, cdr3       & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &           consCell = car // cdr            & \text{level -1}  \\
\text{Selectors}    & numerator(consCell), denominator(consCell) & \textit{Julia}   \\
\hline
\end {array}$$

**Fig. 2.1.1.6**: *Third* abstraction hierarchy for *rational* number algebra or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1))

---

"

# ╔═╡ 47d605b7-ec32-4b72-a329-bf47e7273972
cons3(car::Signed, cdr::Signed)::Rational = car // cdr

# ╔═╡ e6e6754c-d86e-449f-a82e-03e0ab2a91cb
car3(cons::Rational)::Signed = numerator(cons)::Signed

# ╔═╡ c356aab4-4717-46a7-b041-aa14800a0253
cdr3(cons::Rational)::Signed = denominator(cons)::Signed

# ╔═╡ abf821d6-3f8a-404d-903d-0a4b49ed9d9b
md"
---
##### 2.1.1.3.3 Representing Rational Numbers (... with type $$Rational$$)

"

# ╔═╡ ce97fbfe-0a85-43c6-980f-18da5e795a98
md"
###### 2.1.1.3.3.1 Abstract *Typed* Constructor $$make\_rat3$$
"

# ╔═╡ 6858b169-b9dc-4a23-8dd3-8951033bd311
# idiomatic Julia-code by '÷'
function makeRat3(n::Int, d::Int)::Rational
	n//d
end # function makeRat3

# ╔═╡ 8d014b03-6124-4937-aa35-599c01301efd
md"
###### 2.1.1.3.3.2 Abstract *Typed* Selectors for Type $$Rational$$
"

# ╔═╡ 0a935144-2c44-480b-9c6e-53408b972e89
numer3(x::Rational)::Signed = numerator(x::Rational)::Signed

# ╔═╡ 7c2af484-eea8-4c8c-8891-4aa4923298ae
denom3(x::Rational)::Signed = denominator(x::Rational)::Signed

# ╔═╡ 846b7522-8088-49b4-8848-9f0031e1004e
md"
##### 2.1.1.3.4 Applications
"

# ╔═╡ bb81d86d-63f6-4e9b-83ba-f10a6fc386b0
cons3(1, 3)

# ╔═╡ 96d4be2d-fab7-484e-8a1e-837df8e71574
car3(cons3(1, 3))

# ╔═╡ d07fe6c8-8577-4ece-94d9-c61d44bc502c
cdr3(cons3(1, 3))

# ╔═╡ 6d096e3e-3313-4889-aa5b-387e75912d5e
printRat(x::Rational)::String = "$(numer3(x))//$(denom3(x))"

# ╔═╡ 8bba74f5-f038-448e-9459-8b6a945c293d
methods(printRat)

# ╔═╡ 6931655c-b8bc-4efb-bad1-5061a5b63548
printRat(one_half)

# ╔═╡ 1d2a90d7-cf23-4cef-b525-f0e0cb77586f
printRat(one_third)

# ╔═╡ c85ab30f-22b4-452d-adb0-401dd0609d79
printRat(two_twelves)                    # with (!) application of gcd

# ╔═╡ 64d8fdee-f7b2-453d-b595-f3d27c69ed20
printRat(makeRat(120,90))               # 120/90 = 12/9 = 4/3

# ╔═╡ 60367294-bac2-4c34-bddd-fc8c8c3a2f34
printRat(addRat(one_half, one_third))   # 1/2 + 1/3 = 3/6 + 2/6 = 5/6

# ╔═╡ 6009d1d7-f87d-440e-bfd5-389f7a6189fe
printRat(subRat(one_half, one_third))   # 1/2 - 1/3 = 3/6 - 2/6 = 1/6

# ╔═╡ d2c09e98-d6b6-43e0-a493-a5c00700b022
printRat(mulRat(one_half, one_third))   # 1/2 * 1/3 = 1/6

# ╔═╡ e8dade6c-874e-4926-bdca-0875509f35ff
printRat(divRat(one_half, one_third))   # (1/2)/(1/3) = (1*3)/(2*1) = 3/2

# ╔═╡ ab78e9ac-762d-4824-a17a-b61695010615
printRat(addRat(one_third, one_third))  # 6/9 = 2/3 

# ╔═╡ 5e3ce89e-16cf-41ab-b65b-0693f152d2e6
printRat(makeRat(355,113))

# ╔═╡ 97c12566-f149-46c0-bb00-55686029f523
methods(printRat)

# ╔═╡ 451f4fcd-3cb6-400b-b7eb-b80cb6a5a712
printRat(one_half2)

# ╔═╡ db489898-bef8-4562-adf7-fab1f56e566e
printRat(one_third2)

# ╔═╡ 02fe4860-7fd6-453a-8eb2-a4654d7dd77b
printRat(addRat2(one_half2, one_third2))

# ╔═╡ 04a336e5-b3d0-4c0c-9275-1ad23a1f19e2
printRat(subRat2(one_half2, one_third2))

# ╔═╡ ed2ac17e-497e-4b96-ba9b-ae7d4433c731
printRat(mulRat2(one_half2, one_third2))

# ╔═╡ 55360263-ea18-4987-98c6-396a88afc60e
printRat(divRat2(one_half2, one_third2))

# ╔═╡ 6598342e-f99c-486f-b486-69ee6d488f75
printRat(addRat2(one_third2, one_third2))

# ╔═╡ 985720fb-c4a2-45cd-9094-6d9363deeca1
printRat(makeRat2(120,90))

# ╔═╡ cbb3d0bd-bf78-4f6b-b332-2289393697ec
methods(printRat)

# ╔═╡ 9672253e-c0be-4da5-9c1b-6882ce5f65c3
one_half3 = makeRat3(1, 2)

# ╔═╡ ed140d1c-110e-4fcb-ba43-807b59ac30ef
printRat(one_half3)

# ╔═╡ ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
one_third3 = makeRat3(1, 3)

# ╔═╡ ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
printRat(one_third3)

# ╔═╡ dc14d933-62ac-4cf7-8563-71fda97afc9a
printRat(addRat3(one_half3, one_third3))

# ╔═╡ 47771613-e613-497b-a020-f825a51b012d
printRat(subRat3(one_half3, one_third3))

# ╔═╡ 1a32f5c0-e644-44bc-9b0a-f47905e98f1d
printRat(mulRat3(one_half3, one_third3))

# ╔═╡ 43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
printRat(divRat3(one_half3, one_third3))

# ╔═╡ 1349941f-f280-47f2-814b-32b3b8ac4e4c
equalRat3(makeRat3(1, 3), makeRat3(2, 6))

# ╔═╡ 7242424b-c8da-4452-b104-b3a2411fc0df
equalRat3(makeRat3(1, 2), makeRat3(3, 6))

# ╔═╡ b202fbe1-f987-4e62-8f6f-3af4d3ca1048
equalRat3(makeRat3(1, 3), makeRat3(3, 6))

# ╔═╡ b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
printRat(addRat3(one_third3, one_third3))

# ╔═╡ f38f0544-6113-4ed9-af22-d5d205078492
printRat(makeRat3(120, 90))

# ╔═╡ bcf4044f-f932-4a90-87bb-12963a67fc99
md"
---
#### 2.1.1.4 idiomatic *typed* Julia ...
###### ... with type $$Rational$$
"

# ╔═╡ e44ece8f-5042-4c0f-a8a2-791622867ad5
md"
$$\begin {array}{c|c|c}
                    &        \text{Abstraction Hierarchy}        &                  \\
\hline
\text{ Abstract}    &                                            & \text{level 2}   \\
\text{Operators} &+\;\;\;\;\;\;\; -\;\;\;\;\; *\;\;\;\;\; /\;\;\;\;\;&\text{Domain} \\
\hline
\text{Constructor/} &                                            & \text{level 1}   \\
\text{Selectors}    &                                            &                  \\
\hline
\text{Constructor/} &                                            & \text{level 0}   \\
\text{Selectors}    &                                 & \textit{Scheme}\text{-like} \\
\hline
\text{Constructor/} &    consCell = //(numerator, denominator)   & \text{level -1}  \\
\text{Selectors}    & numerator(consCell), denominator(consCell) & \textit{Julia}   \\
\hline
\end {array}$$

**Fig. 2.1.1.7**: *Fourth* abstraction hierarchy for *rational* number algebra or [here](https://sarabander.github.io/sicp/html/2_002e1.xhtml#g_t2_002e1))

---

"

# ╔═╡ 6b36e481-d44c-468b-b020-ff7219eb6625
md"
##### 2.1.1.4.4 Applications (pure Julia-Rational-Operators)
"

# ╔═╡ 20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
one_half4 = //(1, 2)            # prefix use of '//'

# ╔═╡ 4691017a-0d04-4d94-a874-c78625a49c92
one_half4 == 1 // 2             # prefix == infix

# ╔═╡ 522016b4-5f42-4cf9-acd7-67afd8116d90
one_third4 = //(1, 3)

# ╔═╡ 4c25c782-decc-4d3b-bc01-31577218c6a7
one_half4 + one_third4

# ╔═╡ da84aea9-d17e-4156-979d-8894066d3e38
one_half4 - one_third4

# ╔═╡ f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
one_half4 * one_third4

# ╔═╡ 8cc968c6-5364-4430-9449-aeafd876d567
one_half4 / one_third4

# ╔═╡ d88f2af4-e182-4c90-ab88-694834485bb7
1 // 3 == 2 // 6 == //(2, 6)

# ╔═╡ dc47a501-9c50-4e5d-bcea-d2fe9609a76c
1 // 3 == 3 // 6 == //(3, 6)

# ╔═╡ 14c8d0af-5eb0-4d7c-b498-8b30e0724490
one_third4 + one_third4

# ╔═╡ 8bd0c86b-fe82-4221-9d4a-66cb192b5649
one_third4 + one_third4 == //(2, 3) == 2//3

# ╔═╡ 03a8961e-031e-4671-9bd5-c35c6c603c19
120 // 90

# ╔═╡ a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
md"
###### [rational approximation to π](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) accurate to seven digits
"

# ╔═╡ d44cb419-7a01-4236-b561-a03892cfcead
pi_approximation =
let pi_rat = 355//113
	numerator(pi_rat)/denominator(pi_rat)
end

# ╔═╡ 118ba1f9-8643-43c8-b5a0-18b71a61547d
error = abs(pi_approximation - π)

# ╔═╡ cffadb80-3e20-4600-8419-8d6a59646471
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; *Structure and Interpretation of Computer Programs*, Cambridge, Mass.: MIT Press, (2/e), 1996, [https://sarabander.github.io/sicp/](https://sarabander.github.io/sicp/), last visit 2022/08/27
- **Allen, J.**, *The Anatomy of Lisp*, New York: McGraw Hill, 1978
- **McCarthy, J., Abrahams, P.W., Edwards, D.J., Hart, T.P., & Levin, M.I.**, *LISP 1.5 Programmer's Manual*, Cambridge, Mass.: The MIT Press, 1965, 1979(11/e) 
- **Wikipedia**; *Rational approximation to π*, [https://en.wikipedia.org/wiki/Approximations_of_%CF%80](https://en.wikipedia.org/wiki/Approximations_of_%CF%80), last visit 2022/08/27
"

# ╔═╡ 965557ac-81b4-4cf7-a2e5-3b6efff094be
md"
---
##### end of ch. 2.1.1
====================================================================================

This is a **draft** under the [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
Plots = "~1.35.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "57f16e3fed8a77522258206aa8caeaf282d2cc57"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "8556f4b387fcd1d9b3013d798eecbcfa0d985e66"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.5.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "5628f092c6186a80484bfefdf89ff64efdaec552"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "cceb0257b662528ecdf0b4b4302eb00e767b38e7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "b434dce10c0290ab22cb941a9d72c470f304c71d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.8"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "249df6fb3520492092ccebe921829920215ab205"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.9"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─e8c1f880-0278-11ec-2538-13bb2f14d606
# ╟─6011e641-b628-4642-8c55-549b05efbb89
# ╠═7d9a4133-99cf-40f4-9920-c0425f6676f3
# ╟─2b87595b-9491-4ebe-acb9-1ab7d43c4678
# ╟─55e8fb6e-4f94-46f2-97ff-42bfdcd37a48
# ╟─d4e48294-c66c-4fa3-9586-89fb825a4ee8
# ╟─dc723ee4-97ce-41a3-88b0-49ccb31c289e
# ╠═ca75c0f7-2e85-4436-8544-9b19aa0f57a8
# ╟─68d7c3b8-d2b6-49d5-9fcc-7a69100e7270
# ╠═a181310f-1f46-43b2-8702-a8a60308ccfe
# ╟─bf2c6ebd-8b13-47c2-b11c-0cbff01978ca
# ╠═778e12ad-bfe7-4f02-a946-894249fe2375
# ╟─0875ee4d-e127-4140-a863-04c3a02c38a5
# ╠═dce13d9a-7ffd-475a-84de-7826a1198f38
# ╟─f74ced3c-487c-4428-bcfc-cc69e5416227
# ╠═bc19acb5-0d08-4f7e-abce-c77fca0e8ac9
# ╟─08ede030-fb83-4337-8c37-f346b1b7ebc0
# ╟─d2d4dd60-f2e4-421c-80cd-63fb61faf31c
# ╟─1c6a666d-c388-4ac9-b65f-dcebf9fc082f
# ╠═3b7faab0-b8e0-4bea-894f-16fd35e5727f
# ╠═80fdcc6e-3435-4c3a-a73a-b4ecf54ecfb2
# ╠═1c695d3b-c88e-4227-8aa1-e88149a4f9f4
# ╟─3e8c66d9-f3ce-4235-b096-6544daf9632f
# ╟─b068c8b6-7cfd-47c0-9e87-ee4cd7537bce
# ╠═3fba0329-19ac-485a-a56d-ee64ae0e3573
# ╠═44d3380a-b2ab-43e1-8f03-a14a9599fac0
# ╠═44017d8b-476e-4e9c-abac-229e9a2e85d1
# ╠═51732672-ee53-46e7-85bf-217f531867cc
# ╟─6fa45a52-31fd-44c6-9928-4a75a7feccc0
# ╟─6a584664-cda8-41c1-8bfe-2b7d5b5e1e28
# ╠═a1587038-c11d-4b4b-8436-b098b61f1077
# ╠═118b16a3-093f-4b39-823b-ac167da69615
# ╠═fb4ecf01-1361-43c5-854d-8c83969a2e60
# ╟─099f789b-9fdd-4643-8c6e-b5054af12736
# ╟─d1cd6289-c53d-4561-9895-4958c3e150b5
# ╠═f0c42132-4b04-4b48-aa45-b45b4f585466
# ╠═132232a8-495f-4f2c-a08a-da4b898f606b
# ╠═768b4543-6d34-4af7-9ee1-6120a33a169d
# ╠═8b990c96-d5e2-4e77-ae73-eae3bc399f9d
# ╠═4e7da88e-e73e-4d15-bd5f-b1eed925322d
# ╠═9b7d9d52-77c6-4328-8018-3b1e40fb9558
# ╟─7ce9706c-99ed-4dd8-bf14-19ad346cfbf4
# ╟─8b2fb52c-7519-410f-a872-610cdb911b72
# ╟─680c5ec0-6cf2-4b0c-a005-751ef8a7e568
# ╠═7ff3b4a0-e00b-424f-8118-897019d0fc20
# ╟─810b1eca-eac7-49cb-a34f-8328ea432824
# ╠═df37be85-589a-46aa-a14c-8ab67c461ae9
# ╟─764ec0e3-66c3-4a67-9473-95380e11250b
# ╠═193ae321-0f26-44cc-a48f-1a1b9bc71af8
# ╠═d5c0f2d2-7e6b-4fc5-b9a2-de927eb5c024
# ╟─61340177-3808-4a2b-906f-51b801178c6f
# ╠═172db576-f756-4d62-94c3-128c6ac4f847
# ╠═8bba74f5-f038-448e-9459-8b6a945c293d
# ╟─a9341f5b-8b06-4994-ba6b-58070485c336
# ╠═9b1a0332-0170-424b-be4d-abba0c042ff6
# ╠═5e19e77d-ccea-4825-807d-5a278d762978
# ╠═6931655c-b8bc-4efb-bad1-5061a5b63548
# ╠═cafada61-82c1-4231-bcd8-9887df2be87c
# ╠═1d2a90d7-cf23-4cef-b525-f0e0cb77586f
# ╠═e20d52b3-204c-4105-a362-2b9e66fe22f9
# ╠═c85ab30f-22b4-452d-adb0-401dd0609d79
# ╠═64d8fdee-f7b2-453d-b595-f3d27c69ed20
# ╠═63d09ac2-193d-49dc-9eff-d5c14f973627
# ╠═60367294-bac2-4c34-bddd-fc8c8c3a2f34
# ╠═6009d1d7-f87d-440e-bfd5-389f7a6189fe
# ╠═d2c09e98-d6b6-43e0-a493-a5c00700b022
# ╠═e8dade6c-874e-4926-bdca-0875509f35ff
# ╠═ab78e9ac-762d-4824-a17a-b61695010615
# ╠═69facaff-5c1f-4c8e-a436-81e8f9cd73b9
# ╠═45772e1e-aa83-46cd-add7-4f977f58dff0
# ╠═d3d1980c-00f3-4d04-abe5-8705f61b3459
# ╟─a861fc71-5a96-43b4-9a8f-94a603d2cb3b
# ╠═5e3ce89e-16cf-41ab-b65b-0693f152d2e6
# ╠═aa7ea22e-f330-427e-9d89-408003e6b8f2
# ╠═bf4034ad-07ff-4400-8aba-3b855fc43a5c
# ╟─c70c4a99-32b9-4c70-8b36-064d313e753c
# ╟─285428ce-c13e-43ca-add3-672b1e454e18
# ╠═76e3a4bc-fde2-4440-96c1-c492cc120db0
# ╠═402d8963-26bc-4db2-b94b-ba4334e1d8fd
# ╠═09901068-bf38-4392-ab19-66a44d65344d
# ╠═555e6212-22bd-4d0e-b221-edfe32f043f5
# ╠═afe55885-aba6-4cbc-af2c-23d15bbbf6f5
# ╟─cc592f32-8785-4735-badd-de3903c20f05
# ╟─d4c053d6-ba2c-4d88-beef-19873926df88
# ╟─20fa866b-a9d2-4446-a57a-c01fe145aaac
# ╠═0ffbaeab-9ff4-484b-95df-3b6aab526e0d
# ╠═1fddd3ae-5da7-4a32-a53e-077b8f37509c
# ╠═b52a93ce-d551-4c8d-bcdc-2a5d69facdcc
# ╟─d84101ea-7172-4e1f-9929-1a23acd7a7c7
# ╟─b4c9a74b-5a49-452e-bbf0-44826cd92e46
# ╠═3498e844-931f-4d46-a9aa-b9a2d3b892e7
# ╟─4e179b9f-021e-4891-8e27-7fa36b827fcf
# ╠═7f5b9164-07c2-4ae1-888d-f601fa9d286c
# ╠═3ca05b52-413f-46aa-9fd7-659227dccbd7
# ╟─bbccaeb3-48cf-4f65-9aa2-d0de9940e311
# ╠═1248e659-dcdb-442c-859c-3289d5561c6f
# ╠═97c12566-f149-46c0-bb00-55686029f523
# ╟─edd94612-1772-4c7a-b8d5-cf5b4a540487
# ╠═0e8fd444-fd9d-4455-8ca2-9d61f84e74d9
# ╠═32e3fc67-3872-4a28-bd6b-9cf06bc094ac
# ╠═e5fbf0c8-1123-4e4c-a5cd-3aeff74d8231
# ╠═cc5f1bf0-f1ae-44fa-94af-e06fedae12f0
# ╠═4bed1729-8c79-4cf1-95e3-3285010a5622
# ╠═4ee29c75-f689-4332-99b9-d7b0951d4487
# ╠═451f4fcd-3cb6-400b-b7eb-b80cb6a5a712
# ╠═86b40359-a87d-477e-9615-6b4803fe4fd7
# ╠═db489898-bef8-4562-adf7-fab1f56e566e
# ╠═02fe4860-7fd6-453a-8eb2-a4654d7dd77b
# ╠═04a336e5-b3d0-4c0c-9275-1ad23a1f19e2
# ╠═ed2ac17e-497e-4b96-ba9b-ae7d4433c731
# ╠═55360263-ea18-4987-98c6-396a88afc60e
# ╠═d650d480-08ed-478a-8a9f-92cce23ba072
# ╠═999406e8-787a-4f2b-9805-eed631fc6f54
# ╠═4bbd2664-5846-4487-b91c-be7ff75a4e81
# ╠═6598342e-f99c-486f-b486-69ee6d488f75
# ╠═985720fb-c4a2-45cd-9094-6d9363deeca1
# ╟─5be39e55-32ba-4809-9456-431e118b9195
# ╟─bb838586-2f8a-44f9-9672-aced83e8cf76
# ╠═26593de4-f70d-4aa5-86dd-d09bb6544407
# ╠═6662d041-af9c-472d-b9fe-efe2c4846267
# ╠═8fc62f98-9a2e-4fae-83b7-a78118b656d3
# ╠═f7bd0981-1534-4c80-9697-e019f29c4a3c
# ╠═b25d2465-7452-43e8-b709-06009642076a
# ╟─32927d21-4f21-41ff-b90c-21a9c15a7a26
# ╟─5f1971c7-f3bb-4dbf-aa42-4218055e1fd0
# ╟─61794b44-f955-4486-8b1e-863dca1082c2
# ╠═47d605b7-ec32-4b72-a329-bf47e7273972
# ╠═e6e6754c-d86e-449f-a82e-03e0ab2a91cb
# ╠═c356aab4-4717-46a7-b041-aa14800a0253
# ╟─abf821d6-3f8a-404d-903d-0a4b49ed9d9b
# ╟─ce97fbfe-0a85-43c6-980f-18da5e795a98
# ╠═6858b169-b9dc-4a23-8dd3-8951033bd311
# ╟─8d014b03-6124-4937-aa35-599c01301efd
# ╠═0a935144-2c44-480b-9c6e-53408b972e89
# ╠═7c2af484-eea8-4c8c-8891-4aa4923298ae
# ╟─846b7522-8088-49b4-8848-9f0031e1004e
# ╠═bb81d86d-63f6-4e9b-83ba-f10a6fc386b0
# ╠═96d4be2d-fab7-484e-8a1e-837df8e71574
# ╠═d07fe6c8-8577-4ece-94d9-c61d44bc502c
# ╠═6d096e3e-3313-4889-aa5b-387e75912d5e
# ╠═cbb3d0bd-bf78-4f6b-b332-2289393697ec
# ╠═9672253e-c0be-4da5-9c1b-6882ce5f65c3
# ╠═ed140d1c-110e-4fcb-ba43-807b59ac30ef
# ╠═ea6f8db4-c507-44d3-9e29-6bfc6b85b4ad
# ╠═ed389d11-5f6c-496c-84bf-6ac6b05ff5a4
# ╠═dc14d933-62ac-4cf7-8563-71fda97afc9a
# ╠═47771613-e613-497b-a020-f825a51b012d
# ╠═1a32f5c0-e644-44bc-9b0a-f47905e98f1d
# ╠═43b0f7a2-d07a-427e-9084-e8d51b8d1e9d
# ╠═1349941f-f280-47f2-814b-32b3b8ac4e4c
# ╠═7242424b-c8da-4452-b104-b3a2411fc0df
# ╠═b202fbe1-f987-4e62-8f6f-3af4d3ca1048
# ╠═b64b8bc6-9746-4ac9-a0fe-dee60bc854ff
# ╠═f38f0544-6113-4ed9-af22-d5d205078492
# ╟─bcf4044f-f932-4a90-87bb-12963a67fc99
# ╟─e44ece8f-5042-4c0f-a8a2-791622867ad5
# ╟─6b36e481-d44c-468b-b020-ff7219eb6625
# ╠═20014c17-f6b4-4e0d-a3e6-5ff3dc47dab4
# ╠═4691017a-0d04-4d94-a874-c78625a49c92
# ╠═522016b4-5f42-4cf9-acd7-67afd8116d90
# ╠═4c25c782-decc-4d3b-bc01-31577218c6a7
# ╠═da84aea9-d17e-4156-979d-8894066d3e38
# ╠═f0e0e3b7-f31d-4082-a512-e3b705a3e5a9
# ╠═8cc968c6-5364-4430-9449-aeafd876d567
# ╠═d88f2af4-e182-4c90-ab88-694834485bb7
# ╠═dc47a501-9c50-4e5d-bcea-d2fe9609a76c
# ╠═14c8d0af-5eb0-4d7c-b498-8b30e0724490
# ╠═8bd0c86b-fe82-4221-9d4a-66cb192b5649
# ╠═03a8961e-031e-4671-9bd5-c35c6c603c19
# ╟─a73fdb19-6096-49fb-b4ef-07a4b27f3cd4
# ╠═d44cb419-7a01-4236-b561-a03892cfcead
# ╠═118ba1f9-8643-43c8-b5a0-18b71a61547d
# ╟─cffadb80-3e20-4600-8419-8d6a59646471
# ╟─965557ac-81b4-4cf7-a2e5-3b6efff094be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
