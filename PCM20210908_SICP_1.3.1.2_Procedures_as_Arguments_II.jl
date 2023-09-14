### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ d31c78a4-66e9-4196-8fb6-0aba3e4ae0d7
using Statistics, Plots, LaTeXStrings

# ╔═╡ 951cce60-4e4f-11ee-379a-4385f4005380
md"
===================================================================================
#### SICP: 1.3.1.2 Procedures as Arguments II: Nonparametric Voting Model
##### file: PCM20210908\_SICP\_1.3.1.2\_Procedures\_as\_Arguments\_II.jl
##### Julia/Pluto.jl-code (1.9.3/19.27) by PCM *** 2023/09/14 ***

===================================================================================
"


# ╔═╡ 8950b580-db8e-45b4-a9cd-1a532a7a4358
# idiomatic Julia-code with 'Function', 'Real', 'while', '+='
#------------------------------------------------------------------
function sum2(f::Function, a::Real, succ::Function, b::Real)::Real
	sum = 0
	while !(a > b)
		
		sum += f(a)
		a = succ(a)
	end # while
	sum
end # function sum2

# ╔═╡ 40bfbb32-b766-4d45-89e1-6701495cd098
md"
---
##### 1.3.1.2.1 Application of *Nonparametric* Voting Model to Thurstone's 1st Artificial Dataset 

We apply here the *nonparametric* version of our *voting model* to Thurstone first artificial data set. Thurstone describes his dataset as: *Here we* (Thurstone) *have chosen arbitrary bimodal and skewed distributions to illustrate the latitude of the method*. (Thurstone, 1945, p.245)
"

# ╔═╡ b14d83b4-0dc3-4893-a645-fd69d9fb15e6
begin                                         # Thurstone, 1945, p.245, Table 1
	x1 = Array{Real, 2}(undef, (9, 3))
	#------------------------------------------------------------------------------
	x1[1,:] = [.04, .03, .00]
	x1[2,:] = [.16, .13, .02]
	x1[3,:] = [.13, .18, .14]
	x1[4,:] = [.11, .17, .34]
	x1[5,:] = [.08, .15, .34]
	x1[6,:] = [.06, .12, .14]
	x1[7,:] = [.11, .10, .02]
	x1[8,:] = [.19, .08, .00]
	x1[9,:] = [.12, .04, .00]
 	size(x1)
end # begin

# ╔═╡ f2f78b7e-6a68-4fa3-846d-95bb979794c2
function plotRatingDistributions1(x::Array, title; maxY=0.4)
	(nRows, nCols) = size(x)
	nCats = nRows              # number of rating categories
	nStims = nCols             # number of stimuli
	xs = 1:1:nCats
	#----------------------------------------------------------------------------
	plot(xs,  x[:, 1], title=title, xlimits=(0.5, nCats+.5), xticks=:1:1:nCats, ylimits=(-0.05, maxY), seriestype=:scatter, colour=:blue, label="S1", xlabel=L"positive affect rating category $m$", ylabel = L"P(m)")
	if nStims == 3
		#------------------------------------------------------------------------
		plot!(xs, x[:, 2], seriestype=:scatter, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:scatter, colour=:green, label="S3")
		#------------------------------------------------------------------------
		plot!(xs, x[:, 1], seriestype=:line, colour=:blue, label="S1")
		plot!(xs, x[:, 2], seriestype=:line, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:line, colour=:green, label="S3")
		#------------------------------------------------------------------------
	elseif nStims == 4 
		#------------------------------------------------------------------------
		plot!(xs, x[:, 2], seriestype=:scatter, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:scatter, colour=:green, label="S3")
		#------------------------------------------------------------------------
		plot!(xs, x[:, 1], seriestype=:line, colour=:blue, label="S1")
		plot!(xs, x[:, 2], seriestype=:line, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:line, colour=:green, label="S3")
		#------------------------------------------------------------------------
		plot!(xs, x[:, 4], seriestype=:scatter, colour=:orange, label="S4")
		plot!(xs, x[:, 4], seriestype=:line, colour=:orange, label="S4")
	end # if
	#----------------------------------------------------------------------------
end # function plotRatingDistributions1

# ╔═╡ f5aabcd1-58af-418d-82f1-f25bfa171b3f
plotRatingDistributions1(x1,"Thurstone's 1st Ex.(p.245, tab.1, without Controv. S4) ")

# ╔═╡ 3832f1e1-ee46-4a64-9d56-d9698ffc5b20
function discreteVotingModel(x::Array, title; plimit=1.0)
	let (nRows, nCols) = size(x)
		m = nRows                                 # number of rating categories
		k = nCols                                 # number of stimuli
		sumOfProbs = zeros(Float64, k)
		while !(sum(sumOfProbs) > plimit || m < 1)
			for j in 1:k
				sumOfProbs[j] += x[m,j]
			end # for j
			m -= 1
		end # while
		sumOfProbs = map(x -> x/sum(sumOfProbs), sumOfProbs) # normalization of probs
		title, m-1, sumOfProbs, sum(sumOfProbs)
	end # let
end # function discreteVotingModel

# ╔═╡ 71d9d34c-c674-4168-9ecb-52a42c45684d
discreteVotingModel(x1, "Voting Model: Thurstone's 1st data set")

# ╔═╡ e9c53501-7ba2-4393-bdee-f609e371a5ac
function modelComparison1(title, x, y ; xlabel="VotingModel", ylabel="Thurstone Model")
	let rxy = trunc(Statistics.cor(x, y), digits=3)
		xs = [0, 1]; ys = [0, 1]
		#---------------------------------------------------------------------------
		plot(xs, ys, xlims=(-0.01, 1.0), ylims=(-0.01, 1.0), title=title, seriestype=:line, colour=:red, xlabel=xlabel, ylabel=ylabel, label="line of perfect model agreement")
		#---------------------------------------------------------------------------
		plot!((x[1], y[1]), seriestype=:scatter, colour=:blue, label="S1")
		plot!((x[2], y[2]), seriestype=:scatter, colour=:red, label="S2")
		plot!((x[3], y[3]), seriestype=:scatter, colour=:green, label="S3")
		if length(x) == 4
			plot!((x[4], y[4]), seriestype=:scatter, colour=:orange, label="S4")
		end # if
		#---------------------------------------------------------------------------
		annotate!([(0.7, 0.1, "r(model_1, model_2) = $rxy")])
	end # let
end # function modelComparison1

# ╔═╡ 403c8660-75cb-4866-9a70-e822b425c797
modelComparison1("Thurstone vs Voting Model", 
	[0.36129, 0.316129, 0.322581],         # predictions of Voting model
	[0.47, 0.30, 0.23])   # predictions of Thurstone's model (Thurstone, 1945, p.247)

# ╔═╡ 1261f045-99d1-4580-a926-6bba736ec1fe
md"
Though we have a high positive correlation between the predictions of Thurstone's and our voting model they are not perfect. This seems due to the fact that Thurstone's model predictions are more *discriminative* between the stimuli than our voting model. 

The reason for this is hat Thurstone's model favours stimuli which a *controversal* ; that is stimuli with wide (e.g. *uniform*) discriminal dispersions.

A test for the cognitive validity of either model cannot be made here because Thurstone's 'data' are only artificial and not behavioral. The empirical test has to wait until we study our own data set (Ahrens & Möbus, 1968).
"

# ╔═╡ 4460796f-06bc-4cb2-9121-c1ff56dca37c
md"
---
###### Thurstone's 1st Data Set augmented with a *Controversal* Stimulus 
(with Uniform Ratings)
"

# ╔═╡ 28e1cf28-49f4-4488-946c-0c4fcd0689d1
begin
	x2 = Array{Real, 2}(undef, (9, 4))
	#------------------------------------------------------------------------------
	x2[1,:] = [.04, .03, .00, 1/9]
	x2[2,:] = [.16, .13, .02, 1/9]
	x2[3,:] = [.13, .18, .14, 1/9]
	x2[4,:] = [.11, .17, .34, 1/9]
	x2[5,:] = [.08, .15, .34, 1/9]
	x2[6,:] = [.06, .12, .14, 1/9]
	x2[7,:] = [.11, .10, .02, 1/9]
	x2[8,:] = [.19, .08, .00, 1/9]
	x2[9,:] = [.12, .04, .00, 1/9]
 	size(x2)
end # begin

# ╔═╡ 3b5f6d28-7fde-4492-aa10-da11539a1b77
plotRatingDistributions1(x2, "Thurstone's 1st Ex.(p.245, tab.1, incl. Controv. S4)")

# ╔═╡ 9d3e5de5-d489-4bea-af40-d55d3ce076fd
discreteVotingModel(x2, "Voting Model: Thurstone's 1st augmented data set") 

# ╔═╡ 23cb6297-23b8-4cd2-8af4-529e25511f65
md"
The introduction of a maximal *controversal* stimulus distracts preference mass mainly from the most *non*controversal stimus $S_3$:

$\;$

$P(S_1 > S_2, S_3) = 0.36129  > P(S_1 > S_2, S_3, S_4) = 0.336973$
$P(S_2 > S_1, S_3) = 0.316129 > P(S_2 > S_1, S_3, S_4) = 0.23869$
$P(S_3 > S_1, S_2) = 0.322581 >> P(S_3 > S_1, S_2, S_4) = 0.112324$
$P(S_4 > S_1, S_2, S_3) = 0.312012$

$\;$

Stimulus $S_3$ is the main loser when the *controversal* stimulus $S_4$ is introduced into the set of alternatives. This can be seen in the correlational diagram of $modelComparison1$ (below).

$\;$ 

"

# ╔═╡ bac5626f-f5a5-4077-a42a-db1b768754c5
modelComparison1("Voting Model: S3 vs S4", 
	[0.36129, 0.316129, 0.322581], #, 0.0000],      # voting model for S3
	[0.336973, 0.23869, 0.112324], #, 0.31201])     # voting model for S4
	xlabel="Voting Model for S4",
    ylabel="Voting Model for S3") 

# ╔═╡ 45815157-d41f-4c1a-b08d-8a511aacc420
md"
---
##### 1.3.1.2.2 Nonparametric Voting Model: *Thurstone*'s 2nd Numerical Example

Now, we apply the *nonparametric* version of our voting model to Thurstone's second set of articial data. He motivates the characterics of his dataset as: *... we have a numerical example of the theorem that when two psychological objects are tied in average popularity, as measured by the mean scale positions $S_i$ and $S_j$, then the more variable of them can win election for first choice by the introduction of a third competing object of lower average popularity. Here we used 24 successive intervals. All three of these affective distributions were made Gaussian, and it is here assumed that the distributions are at least roughly symmetric. The first two candidates are the leading ones that are tied. The third candidate has a lower average popularity* ...(Thurstone, 1945, p.247)
"

# ╔═╡ f447a7ca-ec7d-4584-ad15-1ee482186e61
begin
	x31 = Array{Real, 2}(undef, (24, 3))
	#------------------------------------------------------------------------------
	x31[ 1,:] = [.00, .00, .00]
	x31[ 2,:] = [.01, .00, .00]
	x31[ 3,:] = [.00, .00, .00]
	x31[ 4,:] = [.01, .00, .01]
	x31[ 5,:] = [.02, .00, .01]
	x31[ 6,:] = [.03, .00, .05]
	x31[ 7,:] = [.04, .01, .09]
	x31[ 8,:] = [.05, .01, .15]
	x31[ 9,:] = [.07, .05, .19]
	x31[10,:] = [.08, .09, .19]
	x31[11,:] = [.09, .15, .15]
	x31[12,:] = [.10, .19, .09]
	x31[13,:] = [.10, .19, .05]
	x31[14,:] = [.09, .15, .01]
	x31[15,:] = [.08, .09, .01]
	x31[16,:] = [.07, .06, .00]
	x31[17,:] = [.05, .01, .00]
	x31[18,:] = [.04, .01, .00]
	x31[19,:] = [.03, .00, .00]
	x31[20,:] = [.02, .00, .00]
	x31[21,:] = [.01, .00, .00]
	x31[22,:] = [.00, .00, .00]
	x31[23,:] = [.01, .00, .00]
	x31[24,:] = [.00, .00, .00]
 	size(x31)
end # begin

# ╔═╡ 8a3b8b4d-e92f-437e-bc28-245c72aaad88
plotRatingDistributions1(x31, "Thurstone's 2nd Example (Tab 2; without Controv. S4)", maxY=0.25)

# ╔═╡ 593f000d-0e11-4a08-a7b4-e737dc3bda2b
discreteVotingModel(x31, "Thurstone's 2nd Example (Tab 2; without Controv. S4)")

# ╔═╡ 1f445771-32a8-41d8-8faf-519fdab8ac93
modelComparison1("Voting vs Thurstone Mod (Thurst.'s 2nd data no S4)",
	[.48, .45, .07],  # Thurstone Model (Thurstone, 1945, p.247) 
	[0.462963, 0.472222, 0.0648148], # Voting Model
	xlabel="Thurstone Model",
	ylabel="Voting Model")  

# ╔═╡ c4898b15-d8d8-4201-bfbe-bf16fbc7ecaf
begin
	x32 = Array{Real, 2}(undef, (24, 4))
	#------------------------------------------------------------------------------
	x32[ 1,:] = [.00, .00, .00, 1/24]
	x32[ 2,:] = [.01, .00, .00, 1/24]
	x32[ 3,:] = [.00, .00, .00, 1/24]
	x32[ 4,:] = [.01, .00, .01, 1/24]
	x32[ 5,:] = [.02, .00, .01, 1/24]
	x32[ 6,:] = [.03, .00, .05, 1/24]
	x32[ 7,:] = [.04, .01, .09, 1/24]
	x32[ 8,:] = [.05, .01, .15, 1/24]
	x32[ 9,:] = [.07, .05, .19, 1/24]
	x32[10,:] = [.08, .09, .19, 1/24]
	x32[11,:] = [.09, .15, .15, 1/24]
	x32[12,:] = [.10, .19, .09, 1/24]
	x32[13,:] = [.10, .19, .05, 1/24]
	x32[14,:] = [.09, .15, .01, 1/24]
	x32[15,:] = [.08, .09, .01, 1/24]
	x32[16,:] = [.07, .06, .00, 1/24]
	x32[17,:] = [.05, .01, .00, 1/14]
	x32[18,:] = [.04, .01, .00, 1/24]
	x32[19,:] = [.03, .00, .00, 1/24]
	x32[20,:] = [.02, .00, .00, 1/24]
	x32[21,:] = [.01, .00, .00, 1/24]
	x32[22,:] = [.00, .00, .00, 1/24]
	x32[23,:] = [.01, .00, .00, 1/24]
	x32[24,:] = [.00, .00, .00, 1/24]
 	size(x32)
end # begin

# ╔═╡ 160981ae-22a9-4ae9-a7a3-935e0a4b39fe
plotRatingDistributions1(x32, "Thurstone's 2nd Example (Tab 2; incl. Controv. S4)", maxY=0.25)

# ╔═╡ a10bd04c-265f-4b78-9f24-cdbb73e47020
discreteVotingModel(x32, "Thurstone's 2nd Example (Tab 2; incl. Controv. S4)")

# ╔═╡ 0a3a119b-211a-4dc4-bc6f-e7860b81e050
modelComparison1("Voting vs Thurstone Mod (Thurst.'s 2nd data incl S4)",
	[.48, .45, .07], #, 00],  # Thurstone Model  
	[0.325708, 0.260566, 0.0162854], #, 0.397441], # Voting Model
	xlabel="Thurstone Model",
	ylabel="Voting Model")  

# ╔═╡ 85331d45-5442-4b01-9c84-5105b7a0ab53
md"
**Summary**: Applied to Thurstone's own published demo data *both* models *agree* perfectly. This coincidence is deteriorated when studying empirical data (below). 
"

# ╔═╡ 9babe800-837a-4d2b-9d59-7ed2d4419719
md"
---
##### 1.3.1.2.3 Nonparametric Voting Model: Attitude and 1st Choice Data 
(Ahrens & Möbus, 1968)
"

# ╔═╡ bcf2c87b-64ed-4aee-a666-b96dd65a5373
md"
---
##### Empirical Validity of Thurstone Model 
(Ahrens & Möbus, 1968)
"

# ╔═╡ 646d5dc9-22ea-40f7-a3d0-d5870e9106e0
md"
Best predictors when using the Thurstone model are *Sencerity/Honesty* ($r=.944$), *Liberality* ($r=.922$), and *Objectivity* ($r=.868$).
"

# ╔═╡ 06e7e9c9-123c-440f-b702-55aca1efdc73
md"
---
##### Empirical Validity of Voting Model 

"

# ╔═╡ 431f0ea9-d09e-4983-978f-5791daf853d0
md"
Best predictors when using the Voting model are *Civil Courage* ($r=.647$) and to a lesser degree *Intelligence* ($r=.424$). Both models seem to make different prediction when using correlations as a judgmental basis.
"

# ╔═╡ f5530e6d-179c-4153-8009-d7713d162c03
md"
---
##### Model Predictions for Thurstone and Voting Model
(Data are obtained from Ahrens & Möbus, 1968, p.558, Tab. 3)
###### 1. Civil Courage Ratings
"

# ╔═╡ 4b9757c8-88e4-4b3a-a435-a647431e713f
begin # Civil Courage; Ahrens & Möbus, 1968, p.558, table 3
	S1 = Array{Real, 2}(undef, (7, 6))
	S1[:, 1] = [.00, .00, .10, .14, .29, .43, .05] # column 1
	S1[:, 2] = [.00, .00, .00, .05, .19, .48, .29] # column 2
	S1[:, 3] = [.00, .00, .05, .00, .33, .52, .10] # ...
	S1[:, 4] = [.00, .00, .10, .10, .19, .38, .24] # ...
	S1[:, 5] = [.00, .00, .00, .05, .57, .33, .05] # ...
	S1[:, 6] = [.00, .05, .05, .19, .43, .29, .00] # column 6
end

# ╔═╡ 974842e6-2257-4e0f-b8c6-efe1ade14ec5
function plotRatingDistributions2(x::Array, title::String)
	let (nRows, nCols) = size(x)
		nStims = 6
		nCats = nRows
		xs = 1:1:nCats
		#----------------------------------------------------------------------------
		plot(xs,  x[:, 1], title=title, xlimits=(0, 8), ylimits=(-0.05, 0.60), seriestype=:scatter, colour=:aquamarine, label="S1", xlabel=L"positive affect ratings $m$", ylabel = L"P(m)")
		#----------------------------------------------------------------------------
		plot!(xs, x[:, 2], seriestype=:scatter, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:scatter, colour=:green, label="S3")
		plot!(xs, x[:, 4], seriestype=:scatter, colour=:violet, label="S4")
		plot!(xs, x[:, 5], seriestype=:scatter, colour=:orange, label="S5")
		plot!(xs, x[:, 6], seriestype=:scatter, colour=:blue, label="S6")
		#----------------------------------------------------------------------------
		plot!(xs, x[:, 1], seriestype=:line, colour=:aquamarine, label="S1")
		plot!(xs, x[:, 2], seriestype=:line, colour=:red, label="S2")
		plot!(xs, x[:, 3], seriestype=:line, colour=:green, label="S3")
		plot!(xs, x[:, 4], seriestype=:line, colour=:violet, label="S4")
		plot!(xs, x[:, 5], seriestype=:line, colour=:orange, label="S5")
		plot!(xs, x[:, 6], seriestype=:line, colour=:blue, label="S6")
		#----------------------------------------------------------------------------
	end # let
end # function plotRatingDistributions2

# ╔═╡ abd1374a-8528-4838-ba5c-924e4cfa557d
plotRatingDistributions2(S1, "Ratings: Civil Courage")

# ╔═╡ c54b5f99-4a0c-4c60-9a04-d01dc5a6664a
discreteVotingModel(S1, "Civil Courage Ratings")

# ╔═╡ 380be5b0-7d95-42f4-ac92-98d151b3851a
function modelComparison2(title, x, y ;xlabel="Voting Model", ylabel="Thurstone Model")
	let rxy = trunc(Statistics.cor(x, y), digits=3)
		xs = [0, 1]; ys = [0, 1]
		#---------------------------------------------------------------------------
		plot(xs, ys, xlims=(-0.01, 1.0), ylims=(-0.01, 1.0), title=title, seriestype=:line, colour=:red, xlabel=xlabel, ylabel=ylabel, label="line of perfect model agreement")
		#---------------------------------------------------------------------------

		plot!((x[1], y[1]), seriestype=:scatter, colour=:aquamarine, label="S1")
		plot!((x[2], y[2]), seriestype=:scatter, colour=:red, label="S2")
		plot!((x[3], y[3]), seriestype=:scatter, colour=:green, label="S3")
		plot!((x[4], y[4]), seriestype=:scatter, colour=:violet, label="S4")
		plot!((x[5], y[5]), seriestype=:scatter, colour=:orange, label="S5")
		plot!((x[6], y[6]), seriestype=:scatter, colour=:blue, label="S6")
		#---------------------------------------------------------------------------
		annotate!([(0.7, 0.1, "r(model_i, model_j) = $rxy")])
	end # let
end # function modelComparison2

# ╔═╡ a63ee0a9-b615-47a9-80a9-0eb46b5088f4
function dataModelComparison(title, x, y,; xlabel="Voting Model", ylabel="Ratings Data")
	let rxy = trunc(Statistics.cor(x, y), digits=3)
		xs = [0, 1]; ys = [0, 1]
		#---------------------------------------------------------------------------
		plot(xs, ys, xlims=(-0.01, 1.0), ylims=(-0.01, 1.0), title=title, seriestype=:line, colour=:red, xlabel=xlabel, ylabel=ylabel, label="line of perfect agreement")
		#---------------------------------------------------------------------------
		plot!((x[1], y[1]), seriestype=:scatter, colour=:aquamarine, label="S1")
		plot!((x[2], y[2]), seriestype=:scatter, colour=:red, label="S2")
		plot!((x[3], y[3]), seriestype=:scatter, colour=:green, label="S3")
		plot!((x[4], y[4]), seriestype=:scatter, colour=:violet, label="S4")
		plot!((x[5], y[5]), seriestype=:scatter, colour=:orange, label="S5")
		plot!((x[6], y[6]), seriestype=:scatter, colour=:blue, label="S6")
		#---------------------------------------------------------------------------
		annotate!([(0.7, 0.1, "r(rating_i, model) = $rxy")])
	end # let
end # function modelDataComparison

# ╔═╡ ea394cd7-e6d0-4e55-8e19-4ff8150a3bfa
dataModelComparison("1st Choice Data - Thurstone Mod.(Sincerity/Honesty)",
	[.33, .20, .29, .10, .08, .00], # Thurstone Model (Ahrens&Möbus,1968,p.560,Tab. 4)
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ eacd0bc1-6579-4395-be97-9a4221c3ab22
dataModelComparison("1st Choice Data vs. Thurstone Model (Liberality)",
	[.25, .23, .21, .19, .09, .03], # Thurstone Model (Ahrens&Möbus,1968,p.560,Tab. 4)
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 04ccd8a7-c97b-4760-bf2b-948dc20409f6
dataModelComparison("1st Choice Data vs. Thurstone Model (Objectivity)",
	[.29, .16, .22, .14, .14, .05], # Thurstone Model (Ahrens&Möbus,1968,p.560,Tab. 4)
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 8cedc30e-6061-4f0b-8fa4-5af825725ea8
dataModelComparison("1st Choice Data vs. Thurstone Model (Intelligence)",
	[.26, .04, .15, .22, .07, .26], # Thurstone Model (Ahrens&Möbus,1968,p.560,Tab. 4)
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ bc5ad309-5b2f-41a4-ad5f-04dd49b410a6
dataModelComparison("1st Choice Data vs. Thurstone Model (Civil Courage)",
	[.11, .10, .06, .31, .17, .25], # Thurstone Model (Ahrens&Möbus,1968,p.560,Tab. 4)
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 70c13302-72e0-4dbb-85c0-3cee2a9f0272
dataModelComparison("1st Choice Data vs. Voting Model (Sincerity/Honesty)",
	[.296296, .117284, .0617284, .0, .234568, .290123], # voting model predictions
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 77547f53-7ba4-4e3f-ae8e-6206cc83c747
dataModelComparison("1st Choice Data vs. Voting Model (Liberality)",
	# Voting Model on basis of liberality ratings
	[.248705, .176166, .0984456, .0259067, .222798, .227979], # voting model preds.   
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 980ca609-9885-44aa-99b8-035d697f2610
dataModelComparison("1st Choice Data vs. Voting Model (Objectivity Ratings)",
	[0.239819, 0.171946, 0.108597, 0.0452489, 0.19457, 0.239819],  # voting model
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ f917eefe-50cf-47f9-9c6b-a19f15ca17c0
dataModelComparison("1st Choice Data vs. Voting Model (Intelligence)",
	# Voting Model on basis of intelligence ratings
	[0.286957, 0.252174, 0.0434783, 0.252174, 0.0, 0.165217], # voting model pred.
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ 9441e656-5fb4-45f2-b4e9-394a08110d6a
dataModelComparison("1st Choice Data vs. Voting Model (Civil Courage)",
	# Voting Model predictions on basis of civil courage ratings
	[.151899, .243671, .196203, .196203, .120253, .0917722], 
	[.33, .28, .24, .10, .05, .00]) # 1st choice data (Ahrens&Möbus,1968,p.560,Tab. 4)

# ╔═╡ ca2c9228-9367-4c62-9e77-8756675e94cf
modelComparison2("Thurstone vs Voting Model (Civil Courage Rating)",
	[0.151899, 0.243671, 0.196203, 0.196203, 0.120253,0.0917722],  # voting model
	[.11, .10, .06, .31, .17, .25])  # Thurstone Model(Ahrens&Möbus,1968,p.560, Tab.4)

# ╔═╡ fdab7ae8-3acc-4ce3-8506-e47a4137b94d
md"
---
###### Liberality Ratings
"

# ╔═╡ d56c1cde-d025-4d8b-be57-33651f8a58cd
begin # Liberality Ratings; Ahrens & Möbus, 1968, p.558, table 3
	S2 = Array{Real, 2}(undef, (7, 6))
	S2[:, 1] = [.00, .00, .05, .14, .33, .43, .05] # column 1
	S2[:, 2] = [.00, .14, .10, .29, .14, .24, .10] # column 2
	S2[:, 3] = [.00, .10, .24, .24, .24, .19, .00] # ...
	S2[:, 4] = [.19, .29, .24, .10, .14, .05, .00] # ...
	S2[:, 5] = [.00, .05, .05, .05, .43, .38, .05] # ...
	S2[:, 6] = [.00, .00, .10, .29, .19, .38, .06] # column 6
end

# ╔═╡ 04aa6f0c-50bd-44b5-980e-a0562e27091b
discreteVotingModel(S2, "Liberality Ratings")

# ╔═╡ ada73f85-c8f1-4baa-9898-0f89dd1c0795
plotRatingDistributions2(S2, "Liberality Ratings")

# ╔═╡ 4a80b025-44b9-492b-9cd3-71550666c7b4
discreteVotingModel(S2, "Liberality Ratings")

# ╔═╡ 54c8c91c-2397-433a-9d3f-cd337154bd0b
modelComparison2("Thurstone vs Voting Model (Liberality Ratings)",
	[.248705, .176166, .0984456, .0259067, .222798, .227979],  # voting model
	[.25, .23, .21, .19, .09, .03])  # Thurstone Model(Ahrens&Möbus,1968,p.560, Tab.4)

# ╔═╡ d4d328c9-15bd-4538-a3ce-e16f951377a8
md"
---
###### Sincerity/Honesty Ratings
"

# ╔═╡ 31b9f7ad-95cb-404e-affb-de0cefea0ade
begin # Sincerity/Honesty Ratings; Ahrens & Möbus, 1968, p.558, table 3
	S3 = Array{Real, 2}(undef, (7, 6))
	S3[:, 1] = [.00, .00, .14, .14, .24, .29, .19] # column 1
	S3[:, 2] = [.00, .00, .19, .24, .38, .19, .00] # column 2
	S3[:, 3] = [.00, .10, .14, .29, .38, .05, .05] # ...
	S3[:, 4] = [.38, .29, .19, .10, .05, .00, .00] # ...
	S3[:, 5] = [.00, .05, .00, .24, .33, .33, .05] # ...
	S3[:, 6] = [.00, .00, .05, .24, .24, .33, .14] # column 6
end

# ╔═╡ d1b49b43-f76a-492d-a90c-cc0f718be634
discreteVotingModel(S3, "Sincerity/Honesty Ratings")

# ╔═╡ 7af53601-021c-4560-8ebd-df89d8c17f47
plotRatingDistributions2(S3, "Sincerity/Honesty Ratings")

# ╔═╡ b8c1072f-c206-4c0b-a088-f10c1491f80a
discreteVotingModel(S3, "Sincerity/Honesty Ratings")

# ╔═╡ 80f8adc0-1e60-4008-9963-36d4ead0f562
modelComparison2("Thurstone - Voting Model(Sincerety/Honesty Ratings)",
	# Voting Model on basis of sincerety/honesty ratings
	[0.296296, 0.117284, 0.0617284, 0.0, 0.234568, 0.290123], # voting model
	[.33, .20, .29, .10, .08, .00])  # Thurstone Model(Ahrens&Möbus,1968,p.560, Tab.4)

# ╔═╡ b3af7545-e622-417b-b56b-6047d50127ae
md"
---
###### Intelligence Ratings
"

# ╔═╡ f8f2b229-efcd-4a0d-a62c-744e1cb8618a
begin # Intelligence
	S4 = Array{Real, 2}(undef, (7, 6))
	S4[:, 1] = [.00, .00, .00, .05, .29, .33, .33] # column 1
	S4[:, 2] = [.00, .00, .10, .10, .24, .29, .29] # column 2
	S4[:, 3] = [.00, .00, .05, .14, .43, .33, .05] 
	S4[:, 4] = [.00, .00, .00, .10, .19, .52, .29] 
	S4[:, 5] = [.00, .00, .10, .14, .43, .33, .00] 
	S4[:, 6] = [.00, .00, .00, .14, .43, .24, .19] # column 6
end

# ╔═╡ 50aef5d2-5b53-4abf-91e9-26b9a91021c9
discreteVotingModel(S4, "Voting Model: Intelligence Ratings")

# ╔═╡ 578a003d-8e39-4dd7-939d-0b4a95040a8a
plotRatingDistributions2(S4, "Intelligence Ratings")

# ╔═╡ 5943c7df-8512-428f-ac17-e16c5450fdd1
discreteVotingModel(S4, "Voting Model: Intelligence Ratings")

# ╔═╡ 2c0d5a84-6dfa-4855-ba41-764cb3d7b078
modelComparison2("Thurstone vs Voting Model (Intelligence Ratings)",
	# Voting Model on basis of intelligence ratings
	[0.286957, 0.252174, 0.0434783, 0.252174, 0.0, 0.165217], # voting model
	[.26, .04, .15, .22, .07, .26])  # Thurstone Model(Ahrens&Möbus,1968,p.560, Tab.4)

# ╔═╡ 01780409-edab-4bcd-8569-e9ee23c9587e
md"
---
###### Objectivity Ratings
"

# ╔═╡ 8c661015-9dfc-4d82-a81c-4fb79cb206e5
begin # Objectivity
	S5 = Array{Real, 2}(undef, (7, 6))
	S5[:, 1] = [.00, .05, .10, .14, .19, .29, .24] # column 1
	S5[:, 2] = [.00, .00, .19, .19, .24, .33, .05] # column 2
	S5[:, 3] = [.00, .10, .29, .19, .19, .10, .14] 
	S5[:, 4] = [.00, .38, .05, .14, .33, .05, .05] 
	S5[:, 5] = [.00, .05, .10, .10, .33, .38, .05] 
	S5[:, 6] = [.00, .00, .14, .10, .24, .43, .10] # column 6
end

# ╔═╡ 16f1cd7b-c994-4271-b556-2bf520c925f3
discreteVotingModel(S5, "Objectivity Ratings")

# ╔═╡ 7de57a9f-fcab-45b4-aec3-7ac478271ba6
plotRatingDistributions2(S4, "Objectivity Ratings")

# ╔═╡ c2b421f4-80f6-4c88-bdae-e4cd97e9c2a5
discreteVotingModel(S5, "Objectivity Ratings")

# ╔═╡ 8c21b6ed-9f4c-4e08-9d88-2c621a68394a
modelComparison2("Thurstone vs Voting Model (Objectivity Ratings)",
	[0.239819, 0.171946, 0.108597, 0.0452489, 0.19457, 0.239819], 
	[.11, .10, .06, .31, .17, .25])  # Thurstone Model(Ahrens&Möbus,1968,p.560, Tab.4)

# ╔═╡ f997f20d-26ba-4ad4-98cd-d050a10c8e30
md"
Both models seem to make very different predictions when we look at correlations as a judgmental basis. The highest congruence between both models is on the basis of *Intelligence* ratings ($r=0.399$). 

As a resume we can say that Thurstone's model seems to have a higher empirical validity than the voting model. The reason for this may be the fact that Thurstone's model exploits information not only from the extreme positive parts of the discriminal dispersions but from the *whole* distributions.
"

# ╔═╡ bbd5f8c0-cfb6-4417-a8d2-5474bf0b4cb1
md"
---
##### References
- **Ahrens, H.J. & Möbus, C.**; [*Zur Verwendung von Einstellungsmessungen bei der Prognose von Wahlentscheidungen*](http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf); Zeitschrift für Experimentelle und Angewandte Psychologie, 1968, Band XV. Heft 4. S.543-563; last visit: 2023/09/08
- **Thurstone, L.L.**; [*The Prediction of Choice*](https://link.springer.com/content/pdf/10.1007/BF02288891.pdf); Psychometrika 10.4 (1945): 237-253; ; last visit 2023/09/08
"

# ╔═╡ 6f837e7f-3085-411b-b39f-c63f7fcf2939
md"
---
##### end of ch. 1.3.1.2
"

# ╔═╡ 517c3c8f-be36-49b2-98da-b9f2d67ddcf8
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
LaTeXStrings = "~1.3.0"
Plots = "~1.39.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "45d9cde2c96eb17dd3a7c5e57287d25dd3077c27"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

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

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "d9a8f86737b665e15a9641ecbac64deef9ce6724"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.23.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

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
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

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
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "d73afa4a2bb9de56077242d98cf763074ab9a970"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.9"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1596bab77f4f073a14c62424283e7ebff3072eca"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.9+1"

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
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "cb56ccdd481c0dd7f975ad2b3b62d9eda088f7e2"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.14"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

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

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

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
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

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
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "a03c77519ab45eb9a34d3cfe2ca223d79c064323"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.1"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

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
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

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
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "bbb5c2115d63c2f1451cb70e5ef75e8fe4707019"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.22+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "364898e8f13f7eaaceec55fd3d08680498c0aa6e"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.4.2+3"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

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
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

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
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

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
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

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
# ╟─951cce60-4e4f-11ee-379a-4385f4005380
# ╠═d31c78a4-66e9-4196-8fb6-0aba3e4ae0d7
# ╠═8950b580-db8e-45b4-a9cd-1a532a7a4358
# ╟─40bfbb32-b766-4d45-89e1-6701495cd098
# ╠═b14d83b4-0dc3-4893-a645-fd69d9fb15e6
# ╟─f2f78b7e-6a68-4fa3-846d-95bb979794c2
# ╠═f5aabcd1-58af-418d-82f1-f25bfa171b3f
# ╠═3832f1e1-ee46-4a64-9d56-d9698ffc5b20
# ╠═71d9d34c-c674-4168-9ecb-52a42c45684d
# ╠═e9c53501-7ba2-4393-bdee-f609e371a5ac
# ╠═403c8660-75cb-4866-9a70-e822b425c797
# ╟─1261f045-99d1-4580-a926-6bba736ec1fe
# ╟─4460796f-06bc-4cb2-9121-c1ff56dca37c
# ╠═28e1cf28-49f4-4488-946c-0c4fcd0689d1
# ╠═3b5f6d28-7fde-4492-aa10-da11539a1b77
# ╠═9d3e5de5-d489-4bea-af40-d55d3ce076fd
# ╟─23cb6297-23b8-4cd2-8af4-529e25511f65
# ╠═bac5626f-f5a5-4077-a42a-db1b768754c5
# ╟─45815157-d41f-4c1a-b08d-8a511aacc420
# ╠═f447a7ca-ec7d-4584-ad15-1ee482186e61
# ╠═8a3b8b4d-e92f-437e-bc28-245c72aaad88
# ╠═593f000d-0e11-4a08-a7b4-e737dc3bda2b
# ╠═1f445771-32a8-41d8-8faf-519fdab8ac93
# ╠═c4898b15-d8d8-4201-bfbe-bf16fbc7ecaf
# ╠═160981ae-22a9-4ae9-a7a3-935e0a4b39fe
# ╠═a10bd04c-265f-4b78-9f24-cdbb73e47020
# ╠═0a3a119b-211a-4dc4-bc6f-e7860b81e050
# ╟─85331d45-5442-4b01-9c84-5105b7a0ab53
# ╟─9babe800-837a-4d2b-9d59-7ed2d4419719
# ╟─bcf2c87b-64ed-4aee-a666-b96dd65a5373
# ╠═ea394cd7-e6d0-4e55-8e19-4ff8150a3bfa
# ╠═eacd0bc1-6579-4395-be97-9a4221c3ab22
# ╠═04ccd8a7-c97b-4760-bf2b-948dc20409f6
# ╠═8cedc30e-6061-4f0b-8fa4-5af825725ea8
# ╠═bc5ad309-5b2f-41a4-ad5f-04dd49b410a6
# ╟─646d5dc9-22ea-40f7-a3d0-d5870e9106e0
# ╟─06e7e9c9-123c-440f-b702-55aca1efdc73
# ╠═70c13302-72e0-4dbb-85c0-3cee2a9f0272
# ╠═d1b49b43-f76a-492d-a90c-cc0f718be634
# ╠═77547f53-7ba4-4e3f-ae8e-6206cc83c747
# ╠═04aa6f0c-50bd-44b5-980e-a0562e27091b
# ╠═980ca609-9885-44aa-99b8-035d697f2610
# ╠═16f1cd7b-c994-4271-b556-2bf520c925f3
# ╠═f917eefe-50cf-47f9-9c6b-a19f15ca17c0
# ╠═50aef5d2-5b53-4abf-91e9-26b9a91021c9
# ╠═9441e656-5fb4-45f2-b4e9-394a08110d6a
# ╟─431f0ea9-d09e-4983-978f-5791daf853d0
# ╟─f5530e6d-179c-4153-8009-d7713d162c03
# ╠═4b9757c8-88e4-4b3a-a435-a647431e713f
# ╟─974842e6-2257-4e0f-b8c6-efe1ade14ec5
# ╠═abd1374a-8528-4838-ba5c-924e4cfa557d
# ╠═c54b5f99-4a0c-4c60-9a04-d01dc5a6664a
# ╠═380be5b0-7d95-42f4-ac92-98d151b3851a
# ╠═a63ee0a9-b615-47a9-80a9-0eb46b5088f4
# ╠═ca2c9228-9367-4c62-9e77-8756675e94cf
# ╟─fdab7ae8-3acc-4ce3-8506-e47a4137b94d
# ╠═d56c1cde-d025-4d8b-be57-33651f8a58cd
# ╠═ada73f85-c8f1-4baa-9898-0f89dd1c0795
# ╠═4a80b025-44b9-492b-9cd3-71550666c7b4
# ╠═54c8c91c-2397-433a-9d3f-cd337154bd0b
# ╟─d4d328c9-15bd-4538-a3ce-e16f951377a8
# ╠═31b9f7ad-95cb-404e-affb-de0cefea0ade
# ╠═7af53601-021c-4560-8ebd-df89d8c17f47
# ╠═b8c1072f-c206-4c0b-a088-f10c1491f80a
# ╠═80f8adc0-1e60-4008-9963-36d4ead0f562
# ╟─b3af7545-e622-417b-b56b-6047d50127ae
# ╠═f8f2b229-efcd-4a0d-a62c-744e1cb8618a
# ╠═578a003d-8e39-4dd7-939d-0b4a95040a8a
# ╠═5943c7df-8512-428f-ac17-e16c5450fdd1
# ╠═2c0d5a84-6dfa-4855-ba41-764cb3d7b078
# ╟─01780409-edab-4bcd-8569-e9ee23c9587e
# ╠═8c661015-9dfc-4d82-a81c-4fb79cb206e5
# ╠═7de57a9f-fcab-45b4-aec3-7ac478271ba6
# ╠═c2b421f4-80f6-4c88-bdae-e4cd97e9c2a5
# ╠═8c21b6ed-9f4c-4e08-9d88-2c621a68394a
# ╟─f997f20d-26ba-4ad4-98cd-d050a10c8e30
# ╟─bbd5f8c0-cfb6-4417-a8d2-5474bf0b4cb1
# ╟─6f837e7f-3085-411b-b39f-c63f7fcf2939
# ╟─517c3c8f-be36-49b2-98da-b9f2d67ddcf8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
