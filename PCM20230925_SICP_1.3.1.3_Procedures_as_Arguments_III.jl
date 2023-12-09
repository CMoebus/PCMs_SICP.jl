### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ c4ac1d38-eea8-4e67-a841-e08f017f9d50
using Statistics, Plots, LaTeXStrings, LinearAlgebra

# ╔═╡ ff9905c0-5bb9-11ee-13a0-d19d37925232
md"
===================================================================================
#### SICP: 1.3.1.3 Procedures as Arguments III: Statistical First Choice Models
##### file: PCM20230925\_SICP\_1.3.1.3\_Procedures\_as\_Arguments\_III.jl
##### Julia/Pluto.jl-code (1.9.4/19.27) by PCM *** 2023/12/09 ***

===================================================================================

"

# ╔═╡ 9cd660f5-3661-47ba-9c2b-728ca344d8ac
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

# ╔═╡ 98c606de-82d0-4395-8949-f3968dd5eed6
function plotRatingDistributions1(x::Array; title="Discriminal Dispersions (Thurstone's 1st Example)", ylimits=(-0.05, 0.40), labels=[L"S1", L"S2", L"S3"])
	let (nRows, nCols) = size(x)
		nS = 3
		nCats = nRows
		xs = 1:1:nCats
		#----------------------------------------------------------------------------
		plot(xs,  x[:, 1], title=title, xlimits=(0.5, nCats+0.5), xticks=:1:1:nCats, ylimits=ylimits, seriestype=:scatter, colour=:blue, label=labels[1], xlabel=L"positive affect rating category $k$", ylabel = L"P(k)")
		#----------------------------------------------------------------------------
		plot!(xs, x[:, 2], seriestype=:scatter, colour=:red, label=labels[2])
		plot!(xs, x[:, 3], seriestype=:scatter, colour=:green, label=labels[3])
		plot!(xs, x[:, 1], seriestype=:line, colour=:blue, label=labels[1])
		plot!(xs, x[:, 2], seriestype=:line, colour=:red, label=labels[2])
		plot!(xs, x[:, 3], seriestype=:line, colour=:green, label=labels[3])
		#----------------------------------------------------------------------------
	end # let
end # function plotRatingDistributions1

# ╔═╡ d8c2066f-3539-462f-a6c7-48b85fbe0d06
function plotRatingDistributions2(x::Array, title::String)
	let (nRows, nCols) = size(x)
		nStims = 6
		nCats = nRows
		xs = 1:1:nCats
		#----------------------------------------------------------------------------
		plot(xs,  x[:, 1], title=title, xlimits=(0, nCats+4), ylimits=(-0.05, 0.60), seriestype=:scatter, colour=:aquamarine, label=L"S1\;(=Schröder)", xlabel=L"positive affect ratings $c$", ylabel = L"P(c)")
		#----------------------------------------------------------------------------
		plot!(xs, x[:, 2], seriestype=:scatter, colour=:red, label=L"S2\;(=Schmidt)")
		plot!(xs, x[:, 3], seriestype=:scatter, colour=:green, label=L"S3\;(=Wehner)")
		plot!(xs, x[:, 4], seriestype=:scatter, colour=:violet, label=L"S4\;(=Strauß)")
		plot!(xs, x[:, 5], seriestype=:scatter, colour=:orange, label=L"S5\;(=Brandt)")
		plot!(xs, x[:, 6], seriestype=:scatter, colour=:blue, label=L"S6\;(=Kiesinger)")
		#----------------------------------------------------------------------------
		plot!(xs, x[:, 1], seriestype=:line, colour=:aquamarine, label=L"S1\;(=Schröder)")
		plot!(xs, x[:, 2], seriestype=:line, colour=:red, label=L"S2\;(=Schmidt)")
		plot!(xs, x[:, 3], seriestype=:line, colour=:green, label=L"S3\;(=Wehner)")
		plot!(xs, x[:, 4], seriestype=:line, colour=:violet, label=L"S4\;(=Strauß)")
		plot!(xs, x[:, 5], seriestype=:line, colour=:orange, label=L"S5\;(=Brandt)")
		plot!(xs, x[:, 6], seriestype=:line, colour=:blue, label=L"S6\;(=Kiesinger)")
		#----------------------------------------------------------------------------
	end # let
end # function plotRatingDistributions2

# ╔═╡ 3fb6649d-eeb0-4d9c-ae3a-5574ebf6f171
function modelComparison1(title, x, y; xlabel="VotingModel", ylabel="Thurstone Model")
	let x = x                             # probs of voting model
		y = y                             # probs of Thurstone model (p.245)
		rxy = trunc(Statistics.cor(x, y), digits=3)
		xs = [0, 1]; ys = [0, 1]
		#---------------------------------------------------------------------------
		plot(xs, ys, xlims=(-0.01, 0.75), ylims=(-0.01, 0.75), title=title, seriestype=:line, colour=:red, xlabel=xlabel, ylabel=ylabel, label="line of perfect model agreement")
		#---------------------------------------------------------------------------
		plot!((x[1], y[1]), seriestype=:scatter, colour=:blue, label=L"S1")
		plot!((x[2], y[2]), seriestype=:scatter, colour=:red, label=L"S2")
		plot!((x[3], y[3]), seriestype=:scatter, colour=:green, label=L"S3")
		#---------------------------------------------------------------------------
		annotate!([(0.42, 0.05, "r($ylabel, $xlabel) = $rxy")])
	end # let
end # function modelComparison1

# ╔═╡ ef5b0168-84f9-4e97-b4a0-c2bb87948612
function dataModelComparison(x, y; xlabel="Model", ylabel="Voting Probs", title="Data-Model-Comp.")
	let x = x                             # probs of model
		y = y                             # probs of data
		rxy = trunc(Statistics.cor(x, y), digits=3)
		xs = [0, 1]; ys = [0, 1]
		#---------------------------------------------------------------------------
		plot(xs, ys, xlims=(-0.02, 0.75), ylims=(-0.02, 0.75), title=title, seriestype=:line, colour=:red, xlabel=xlabel, ylabel=ylabel, label="line of perfect agreement")
		#---------------------------------------------------------------------------
		plot!((x[1], y[1]), seriestype=:scatter, colour=:aquamarine, label=L"S1\; (=Schröder)")
		plot!((x[2], y[2]), seriestype=:scatter, colour=:red, label=L"S2\;(=Schmidt)")
		plot!((x[3], y[3]), seriestype=:scatter, colour=:green, label=L"S3\;(=Wehner)")
		plot!((x[4], y[4]), seriestype=:scatter, colour=:violet, label=L"S4\; (=Strauß)")
		plot!((x[5], y[5]), seriestype=:scatter, colour=:orange, label=L"S5\; (=Brandt)")
		plot!((x[6], y[6]), seriestype=:scatter, colour=:blue, label=L"S6\; (=Kiesinger)")
		#---------------------------------------------------------------------------
		annotate!([(0.42, 0.02, "r($xlabel, $ylabel) = $rxy")])
	end # let
end # function modelDataComparison

# ╔═╡ 466b2de4-36f1-48d9-85e4-2f7bdbbcdb08
md"
---
##### 1.3.1.3.1 Prediction of *1st*-Choice by Regression Models

Thurstone's Prediction of Choice ([Thurstone, 1945](https://link.springer.com/article/10.1007/BF02288891); [Ahrens & Möbus, 1965](http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf)) and our [Voting model](https://uol.de/f/2/dept/informatik/ag/lks/download/Probabilistic_Programming/JULIA/Pluto.jl/SICP/PCM20210811_SICP_1.3.1.1_Procedures_as_Arguments_I.html?v=1694519967) are *cognitive* psychological models (Wang & Busemeyer, 2021; Katsikopoulos, 2023) which are *true* prognosis models. The characteristic of these models is that they can predict the distribution of *1st*-choice votings *before* the voting process is starting. This is possible by using attitude or affective ratings alone without any *1st-choice* votes.

In contrast to that there are *expost* prediction models like *regressions*. Their use consists of two phases. In the first parameters are *estimated* on the basis of a *complete* set of data (attitude ratings plus *1st-choice* votes). In the second *prediction phase* parameter estimates and new attitude ratings are plugged into the formerly constructed regression model. The model generates as a prediction a distribution of votes. These can *expost* compared with those used in the first *estimation phase* or new votes. In the first case the result of this comparison is too optimistic. The unbiased comparison can only be made with a *fresh* set of votes. 

"

# ╔═╡ a54dbf87-3ab4-4005-beaa-a3b7905b74e8
md"
Here we demonstrate the use of *classical-linear* and *logit*-regressions (Fahrmeir et al. 2013). In both cases it is sufficient for estimation purposes to use Julia's *matrix division operator* $\text{\\}.$.

One of the results is that knowledge of only a small portion of ratings in one or two of the more affective categories is sufficient for the prediction of *1st-choice* voting of probabilities.
"

# ╔═╡ 390b1aad-a075-45b9-be77-ba9c0b460dab
md"
---
##### Thurstone's 1st Dataset: *Discriminal Dispersions* and Distribution of *1st-Choice* Votings
(Thurstone, 1945, TABLE 1, columns *1-3*, p.245)
"

# ╔═╡ 51c83dc0-691b-4bcb-826d-4902613a520c
begin     # Data of Discriminal Dispersions for 3 Stimuli
	X1 = Array{Real, 2}(undef, (9, 3))
	#------------------------------------------------------------------------------
	X1[1,:] = [.04, .03, .00]
	X1[2,:] = [.16, .13, .02]
	X1[3,:] = [.13, .18, .14]
	X1[4,:] = [.11, .17, .34]
	X1[5,:] = [.08, .15, .34]
	X1[6,:] = [.06, .12, .14]
	X1[7,:] = [.11, .10, .02]
	X1[8,:] = [.19, .08, .00]
	X1[9,:] = [.12, .04, .00]
 	nCats1, nStims1 = size(X1)    # nCats = #categories, nStims = #stimuli
end # begin

# ╔═╡ 39794b9e-3146-45d2-9e27-f6116ed5cba7
plotRatingDistributions1(X1)

# ╔═╡ c50ab7d7-c24d-4571-ad31-a292db6b6b80
# predicted proportions by Thurstone's 1st choice model (Thurstone, 1945, p.247)
py1ThurstoneModel = [0.475799, 0.301452, 0.230428] 

# ╔═╡ a60caaac-e87f-44a7-846f-edc140a79308
md"""
---
###### Classical Linear OLS-Regression and Julia's Matrix Division Operator "\\"

The equation of the *classical linear (multiple regression)* model (Fahrmeir et al, 2/e, 2022, ch. 3, p.87f) is

$\mathbf y = \mathbf X \mathbf{\beta} + \mathbf{\epsilon}$

$\;$

where:

$_N\mathbf{X}_M = \text{ 'design'-matrix (= matrix of fixed or observed predictor values) }$

$\;$

$N = \text{\#observations, } i=1,...,N; M = \text{\#variables, } j=1,...,M$ 


$\;$

$_M\mathbf{\beta}_1 = \text{ vector of regression weights }$

$\;$

$_N\mathbf{\epsilon}_1 = \text{ vector of residuals (= errors) }$

$\;$

$_N\mathbf{y}_1 = \text{ vector of dependent variable (= criterion) values }$

$\;$

Two of the assumptions of classical-linear-regression are that the

- observations are *independent identical distributed (i.i.d.)* and 
- *independence* of the error variable $\epsilon$ from the predictors $X_j\;; j=1,...,M$ and from the criterion variable $Y$:

$Y, X_j \;\bot\; \epsilon\;\;; j=1...,M.$

$\;$

The first means, that *rows* of $\mathbf{X, y}$ are independently sampled from a common distribution.
The second means that *no* for the prediction of the criterion $Y$ relevant variable is left out from the model equation.

"""

# ╔═╡ d8d7c504-20a6-48a9-8988-d119ae1b8085
md"

For the use of multiple OLS-regression we use Julia's matrix division operator $\text{\\}$ which is documented as:

$\mathbf {X = }\text{ \\ } \mathbf{(A, B)}$

$\;$

*Matrix division using a polyalgorithm. For input matrices $\mathbf A$ and $\mathbf B$, the result $\mathbf X$ is such that* 

$\mathbf{A \cdot X} = \mathbf B$ 

$\;$

*when $\mathbf A$ is square. The solver that is used depends upon the structure of $\mathbf A$. If $\mathbf A$ is upper or lower triangular (or diagonal), no factorization of $\mathbf A$ is required and the system is solved with either forward or backward substitution. For non-triangular square matrices, an LU factorization is used. For rectangular $\mathbf A$ the result is the minimum-norm least squares solution computed by a pivoted QR factorization of $\mathbf A$ and a rank estimate of $\mathbf A$ based on the $R$ factor. so that:*

$\mathbf{A \cdot X = B}.$

$\;$

For using *matrix division* in our problem of predicting *1st choice* votings 

$\mathbf y = \mathbf{X \; \widehat{\beta} + \widehat{\epsilon}}$

$\;$

$\mathbf{\hat y} = \mathbf{X \; \widehat{\beta}}$

$\;$

$\mathbb{E}(\mathbf{y|X}) = \mathbf{X \; \hat{\beta}}.$

$\;$

we have to match our matrices and vectors with those in the documentation:

$\mathbf{A := X',\; X := \widehat{\beta} = b,\; B := y = p}_y$

$\;$

where:

$_{nCats}\mathbf{X}_{nStims} \text{ = matrix with probabilities of attitude ratings}$

$\;$

$_{nStims}\mathbf {X'}_{nCats} \text{ = transposed matrix with probabilities of attitude ratings}$

$\;$

$_{nCats}\widehat{\beta}_1 = _{nCats}\mathbf{b}_1 \text{ = column vector of regression coefficients (= weights of categories)}$

$\;$
$\;$

$_{nStims}\mathbf{y}_1 = \mathbf{p}_y = \text{ column vector of 1st-choice probabilities }$

$\;$

$nCats \text{ = number of rating categories }$ 

$\;$

$nStims \text{ = number of stimuli }$ 
 
"


# ╔═╡ 3ddb407e-8be5-4358-8731-97ab93e1b914
md"
---
###### *Logit*-Regression with *Logit-Link-* and *Logistic-Response-*Functions
The prediction of *1st*-choice probabilities $\mathbf{p}_y$ with classical OLS-regressions suffers from the problem that estimates $\widehat{\mathbf p}_y$ may lay outside the interval $[0,1].$ 

To satisfy this constraint it is recommended to transform the $\mathbf{p}_y$ to *logits* $log(\mathbf{odds(p_y)})$ (= *link* function; Fahrmeir et al, 2022, p.285, 316):

$\mathbf{\eta} = logit(\mathbf{p}_y) = log(odds\mathbf{p}_y) = log\left(\frac{\mathbf {p}_y}{\mathbf{1-p}_y}\right)\;\;;\text{ (= link function }\;g(p)=\eta).$

$\;$
$\;$
$\;$

After estimation of the OLS-regression model

$\mathbf{\eta} = logit(\mathbf{p}_y) = \mathbf{X\cdot\beta}_{logit}+\mathbf{\epsilon}_{logit}$

$\;$
$\;$

$\widehat{\mathbf{\eta}} = \widehat{logit(\mathbf{p}_y)} = \mathbf{X\cdot\hat{\beta}}_{logit}$

$\;$
$\;$

the predicted logits $\widehat{\mathbf{\eta}}$ are transformed back to predicted probabilites by the *logistic* function (= *response* function $h(\eta)$; Fahrmeir et al, 2022, p.285, 316):

$\hat{\mathbf p} = logistic(\mathbf{\eta}) = \frac{1}{1 + e^{-\widehat{\mathbf{\eta}}}} \in [0,1]\;\;;\text{ (= response function }\;\;h(\eta) = p; h = g^{-1}).$

$\;$
$\;$

For demonstration purpose we plot and compose *link* $g(p)$ and *response* $h(\eta)$ functions

$p = h(g(p)) \;\;; \text{ (= composition )}$

$\;$
$\;$

and 

$p = h ∘ g \;\;; \text{ (= piping in JULIA )}$ 

$\;$
$\;$

"

# ╔═╡ 19ea4ab6-93f3-4cc9-8862-1e9a18bae8fe
let ps = 0:0.01:1
	logit(x)    = log(x/(1-x))                    # logit function
	plot(ps, logit, title=L"Logit-(Link-)Function $\;log\;\left(\frac{p}{1-p}\right)$", xlimits=(0.0, 1.0), yticks=-6.0:1:6.0, ylimits=(-5.5, +5.5), seriestype=:line, colour=:blue, label="", xlabel=L"Probability\; p", ylabel = L"Logit(p)")
end # let

# ╔═╡ 5b7bcf2c-b4f1-4723-97fa-5ceb0e28bb27
let logs = -5.5:0.01:+5.5                        # logits
	logistic(x) = 1/(1+exp(-x))                  # logistic function
	plot(logs, logistic, title=L"Logistic-(Response-)Function $\left(\frac{1}{1+e^{-x}}\right)$", xlimits=(-6, +6), xticks=-6:1:+6, ylimits=(0, 1), seriestype=:line, colour=:blue, label="", xlabel=L"Logits", ylabel = L"Probability \; p")
end # let

# ╔═╡ d7287d9d-3e8a-4a83-82ea-155f1fbbded8
let ps = 0:0.01:1
	logit(x)    = log(x/(1-x))                    # logit function
	logistic(x) = 1/(1+exp(-x))                   # logistic function
	plot(ps, logistic ∘ logit, title=L"Composition and Piping: $p=h(g(p)) = h\; ∘\; g(p)$", xlimits=(-0.0, 1.1), ylimits=(-0.0, 1.1), seriestype=:line, colour=:blue, label="", xlabel=L"Probability\; p", ylabel = L"p=Logistic(Logit(p))")
end # let

# ╔═╡ 5b3d00c5-39d7-415e-a7ba-df30080a9a76
md"
---
###### Results of Full Classical and Logit Regression Models
"

# ╔═╡ 84281755-8e8d-4638-ad02-0043e5ddaad2
md"
*First*, we solve the regression problem with a model containing *all* categories as predictors. These *expost* 'prognoses' are *exact*: both *classical* and *logit*-ressions generate identical perfect predictions (see below). 

Then, in a *second* step we reduce the number of parameters to a minimum of one or two parameters far less than before. The selection of predictors (categories) is guided by their contributions to overall importance measured by the error-sum-of-squares $eSSQ, eSSQ_L$.

"

# ╔═╡ daa9bbf3-fb5c-4870-bb7a-8e07f8b07593
function firstChoiceRegression(X, py)
	b = \(X, py)                      # estimated OLS regression weights
	pyHat = X*b                       # estimated 1st-choice vote probabilties
	sum_pyHat = sum(pyHat)               # do the probabilities sum to one ?
	e = py - pyHat                    # residuals
	eSSQ = e'e                        # error sum-of-squares
	r = cor(py, pyHat)                # correlation between criterium and prognosis
	b, pyHat, sum_pyHat, eSSQ, r      # return results
end # function firstChoiceRegression

# ╔═╡ f5dce854-62f2-4d36-a723-c95e7e74b2d8
md"
Thurstone's model (Thurstone, 1945, p.247) predicts *1st*-choices $\mathbf{p}_y$. These data are the criterion in the regression models.
"

# ╔═╡ f39fd70b-bb89-43c6-b337-c265b0fbc847
# predictions from Thurstone's 1st choice model (Thurstone, 1945, p.247)
py1ThurstoneModel

# ╔═╡ 3ff052e0-fd05-41d4-88e3-e840bef6d27a
(b1, pYHat1, sum_pYhat1, eSSQ1, r1) = firstChoiceRegression(X1', py1ThurstoneModel)

# ╔═╡ 4846d725-71a6-41ef-8c81-eaf29c6f0c1b
function firstChoiceLogitRegression(X, py)
	logit(x)    = log(x/(1-x))                  # link (logit) function
	logistic(x) = 1/(1+exp(-x))                 # response (logistic) function
	#-------------------------------------------------------------------------------
	logOddsY   = broadcast(logit, py)           # link function: logOdds(p) = logit(p)
	bLogit     = \(X, logOddsY)                 # regression coefficients
	etaHat     = X*bLogit                       # predicted logits etaHat
	pyHatL     = broadcast(logistic, etaHat)    # predicted probablities
	sum_pyHatL = sum(pyHatL)
	errorL     = logOddsY - etaHat                # errors in logit regression
	eSSQL      = errorL'errorL
	rL_logOddsY_etaHat = cor(logOddsY, etaHat)  # correlation between logits
	rL_py_pyHat = cor(py, pyHatL)               # correlation between probabilities
	#-------------------------------------------------------------------------------
	bLogit, pyHatL, sum_pyHatL, eSSQL, rL_py_pyHat
end # function firstChoiceLogitRegression

# ╔═╡ 2312b040-eeac-4ff3-8ed2-ec2656d1a91f
(bL1, pyHatL1, sum_pyhatL1, eSSQL1, rL1) = 
	firstChoiceLogitRegression(X1', py1ThurstoneModel)

# ╔═╡ 0654cef2-0108-4332-8398-5c5363297e27
pyHatL1                                          # predicted vote probs

# ╔═╡ f5631ab3-d8be-4957-9fc3-d02fcda0b738
md"
error sum of squares $eSSQ_{L1}$:
"

# ╔═╡ c8ef1769-cbc9-491e-9916-8b7bc64b8ede
eSSQL1

# ╔═╡ fd2dc361-80a2-46ba-93e8-4a3e7e51ced8
md"
correlation $r(p_y, \hat p_y)$
"

# ╔═╡ 9214d187-0f6f-4eb8-aad7-9c7286b7e0a2
rL1                             # correlation between vote probs and their predictions

# ╔═╡ 772028ee-f04d-48a8-83b8-92f91f00b14d
md"
---
###### Classical Linear- and Logit-Regressions with Single Most Important Regressor
Extract *one* predictor (= column) of $\mathbf{X_1}$ with smallest error sum-of-squares $eSSQ$ or $eSSQ_L$. This generates good predictions with $r(p_y, \hat p_{y_L})^2 \ge .50$ : 

- Classical-Linear-Regression: for category 7: $eSSQ = 0.0332$ and *positive* single $r(p_y, \hat p_y) = 0.7897$ 
- Logit-Regression: for category 5: $eSSQ_L = 0.123232$ and *positive* single $r(p_y, \hat p_{y_L}) = 0.894778$ 

$\;$

"

# ╔═╡ 7e4e8d1c-5f4e-49a7-9dd7-4745b102eb99
function lookForSingleBestCategory(X, y)
	nStims, nCats = size(X)
	eSSQ_Min  = 1.0; index_k_Min  = 0; r_Min  = 0.0
	eSSQL_Min = Inf; indexL_k_Min = 0; rL_Min = 0.0
	for k in 1:nCats
		xk = X[:, k]                         # copy column k out of X
		#-------------------------------------------------------------------
		if !(reduce(+, xk, init=0.0) ≈ 0.0)  # only include nonzero xk
			b, yHat, sum(yHat), eSSQ, r = firstChoiceRegression(xk, y)
			if eSSQ < eSSQ_Min
				eSSQ_Min = eSSQ
				index_k_Min = k
				r_Min = r
				end # if
			println("=========================================================")
			println("k = $k, eSSQ  = $eSSQ, r = $r") 
			println("        yHat = $yHat")
			println("        y    = $y")
		end # if
		#-------------------------------------------------------------------
		if !(reduce(+, xk, init=0.0) ≈ 0.0)  # only include nonzero xk
			# bLogit, pYHat, sum(pYHat), eSSQLogit, r_pY_pYHat
			bL, pYHat, sum_pYH, eSSQL, rPyPyH = firstChoiceLogitRegression(xk, y)
			if eSSQL < eSSQL_Min
				eSSQL_Min = eSSQL
				indexL_k_Min = k
				rL_Min = rPyPyH
			end # if
			println("k = $k, eSSQL = $eSSQL, rPyPyH = $rPyPyH") 
			println("       pYHat = $pYHat")
			println("           y = $y")
		end # if
	end # for k
	(index_k_Min, eSSQ_Min, r_Min), (indexL_k_Min, eSSQL_Min, rL_Min)
end # function lookForSíngleBestCategory

# ╔═╡ 3b529980-f7d4-4e2c-b902-4d9d8f33ba17
lookForSingleBestCategory(X1', py1ThurstoneModel)

# ╔═╡ fb01e2b3-dbaf-4ed5-8737-6f871aeff40f
modelComparison1(L"cat 5, eSSQ_L=0.1232, r(p_y, \hat p_{y_L}) = 0.8948", 
	[0.42529507901085595, 0.362503927809625, 0.2176247286843727], 
	py1ThurstoneModel; xlabel="Logit-Regression", ylabel="Thurstone Model")

# ╔═╡ 7f1bf0d9-47d6-4bf9-9d8d-c2e83e5eec53
md"
---
###### Classical Linear- and Logit-Regression with 2 Most Important Regressors
Extract *pair* of predictors (= columns) of X1 with smallest eSSQ and eSSQL. This happens for the

- Classical-Linear-Regression: for the combination of the *4th* and the *8th* category. This generates nearly exact predictions: the multiple $R(y, \hat y)=0.99688$ with an $eSSQ=0.00023.$ 

- Logit-Regression: for the combination of the *6th* and the *8th* category. This generates nearly exact predictions: the multiple $R(y, \hat y_L)=0.99991.$ with an $eSSQ_L=0.00016.$ 

"

# ╔═╡ f4baecd3-99ff-4cef-8103-8e19d52012b2
function lookForPairOfBestCategories(X, y)
	nStims, nCats = size(X)
	xk = zeros(Float64, nStims, 2)
	eSSQ_Min  = 1.0; index_k_Min  = 0; index_l_Min  = 0; r_Min  = 0.0
	eSSQL_Min = Inf; indexL_k_Min = 0; indexL_l_Min = 0; rL_Min = 0.0
	for k in 1:nCats
		for l in k+1:nCats
			xk[:,1] = X[:, k]            # copy column k out of X
			xk[:,2] = X[:, l]            # copy column l out of X
			#-------------------------------------------------------------------
			# only include if nonzero xk[:,1] and nonzero xk[:,2] 
			if !(reduce(+, xk[:,1], init=0.0) ≈ 0.0) || !(reduce(+, xk[:,2], init=0.0) ≈ 0.0)
				b, yHat, sum_yHat, eSSQ, r = firstChoiceRegression(xk, y)
				if eSSQ < eSSQ_Min
					eSSQ_Min = eSSQ
					index_k_Min = k; index_l_Min = l
					r_Min = r
				end # if
				println("=========================================================")
				println("k=$k,l=$l,  eSSQ = $eSSQ, r = $r") 
				println("          yHat = $yHat")
				println("          y    = $y")
			end # if
			#-------------------------------------------------------------------
			# only include if nonzero xk[:,1] and nonzero xk[:,2] 
			if !(reduce(+, xk[:,1], init=0.0) ≈ 0.0) || !(reduce(+, xk[:,2], init=0.0) ≈ 0.0)
				# bLogit, pYHat, sum(pYHat), eSSQLogit, r_pY_pYHat
				bL, pYHat, sum_pYH, eSSQL, rPyPyH = firstChoiceLogitRegression(xk, y)
				if eSSQL < eSSQL_Min
					eSSQL_Min = eSSQL
					indexL_k_Min = k; indexL_l_Min = l
					rL_Min = rPyPyH
				end # if
				println("k=$k,l=$l, eSSQL = $eSSQL, rPyPyH = $rPyPyH") 
				println("         pYHat = $pYHat")
				println("             y = $y")
			end # if
			#-------------------------------------------------------------------
		end # for l
	end # for k
	(index_k_Min, index_l_Min, eSSQ_Min, r_Min), (indexL_k_Min, indexL_l_Min, eSSQL_Min, rL_Min)
end # function lookForPairOfBestCategories

# ╔═╡ a84e8ab7-0935-4dd0-976a-59f861abed0d
lookForPairOfBestCategories(X1', py1ThurstoneModel)

# ╔═╡ 44709a59-eb71-49e0-a2a0-82c9bf3ca3ae
modelComparison1("cats 6 and 8, eSSQL=0.00016, rPyPyH = 0.99989", 
	[0.47685352870164477, 0.2993419015177674, 0.23163505408734608], 
	py1ThurstoneModel; xlabel="Logit-Regression", ylabel="Thurstone Model")

# ╔═╡ be160724-356f-4fb9-8ff7-14049d7293a8
md"
---
##### Thurstone's 2nd Dataset: *Discriminal Dispersions* and Distribution of *1st-Choice* Votings
(Thurstone, 1945, TABLE 2, columns *1-3*, p.246)
"

# ╔═╡ 802c2949-b3ac-42d0-b0fc-553f7bdb51d1
begin
	X2 = Array{Real, 2}(undef, (24, 3))
	#------------------------------------------------------------------------------
	X2[ 1,:] = [.00, .00, .00]
	X2[ 2,:] = [.01, .00, .00]
	X2[ 3,:] = [.00, .00, .00]
	X2[ 4,:] = [.01, .00, .01]
	X2[ 5,:] = [.02, .00, .01]
	X2[ 6,:] = [.03, .00, .05]
	X2[ 7,:] = [.04, .01, .09]
	X2[ 8,:] = [.05, .01, .15]
	X2[ 9,:] = [.07, .05, .19]
	X2[10,:] = [.08, .09, .19]
	X2[11,:] = [.09, .15, .15]
	X2[12,:] = [.10, .19, .09]
	X2[13,:] = [.10, .19, .05]
	X2[14,:] = [.09, .15, .01]
	X2[15,:] = [.08, .09, .01]
	X2[16,:] = [.07, .05, .00]
	X2[17,:] = [.05, .01, .00]
	X2[18,:] = [.04, .01, .00]
	X2[19,:] = [.03, .00, .00]
	X2[20,:] = [.02, .00, .00]
	X2[21,:] = [.01, .00, .00]
	X2[22,:] = [.00, .00, .00]
	X2[23,:] = [.01, .00, .00]
	X2[24,:] = [.00, .00, .00]
 	[sum(X2[:, j]) for j in 1:3], size(X2)  # column sums and size
end # begin

# ╔═╡ 4cdcaad1-8cff-46e2-a99f-895294225353
plotRatingDistributions1(X2, title="Thurstone's 2nd Data Set", ylimits=(-0.04, +0.24))

# ╔═╡ 6cb733aa-ebaa-461a-9a3d-d29cd3f40a0d
# predictions from Thurstone's 1st choice model (Thurstone, 1945, p.247)
py2ThurstoneModel = [0.48, 0.45, 0.07]

# ╔═╡ 27b9a96f-633b-4ca2-bd7c-5986866dfc7d
md"
---
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of X2 with smallest error sum-of-squares $eSSQL$. This generates good predictions with $r(p_y, \hat p_{y_L})^2 \ge .50$ : 

- for category 8: $eSSQ_L = 0.552552$ and *positive* single $r(p_y, \hat p_{y_L}) = 0.892489$ 

"

# ╔═╡ ac8c5d44-f740-4098-9976-aa2e39c1a56b
lookForSingleBestCategory(X2', py2ThurstoneModel)

# ╔═╡ f4ab6423-ad57-4876-8b9a-a173dee8b570
modelComparison1("cat 8, eSSQL = 0.55255, r = 0.89249 ", 
	[0.31326802407118187, 0.46083614183387994, 0.08669649110992561], 
	py2ThurstoneModel; xlabel="Regression", ylabel="Thurstone Model")

# ╔═╡ efb3eeca-e169-4473-bec1-68bc3e710062
md"
---
###### Logit-Regression with 2 Most Important Regressors
Extract a *pair* of columns of X2 with smallest eSSQL. This happens for the combination of the *5th* and the *8th* category. This generates nearly exact predictions: the multiple $R(p_y, \hat p_{y_L}) = 0.99999$ with an $eSSQ_L=9.30595e-6.$ 

"

# ╔═╡ f1c839d7-7df1-41b9-8829-119be55b53f2
lookForPairOfBestCategories(X2', py2ThurstoneModel)

# ╔═╡ 47d4c770-bf1a-4450-a0c8-d31bac444d03
modelComparison1("cats 5, 8, eSSQL = 9.306e-6, R = 0.9999", 
	[0.47996966432607013, 0.44924810183172237, 0.07001582583015961], 
	py2ThurstoneModel; xlabel="Logit-Regression", ylabel="Thurstone Model")

# ╔═╡ 027c3cdb-a4bd-4760-9bcb-ab501fa8b48c
md"
---
##### Prediction of *1st Choice* Probabilities
(Data from [Ahrens & Möbus, 1968](http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf))

"

# ╔═╡ ea1d87e8-247d-4482-80f0-2dba4736ed5b
md"
---
###### *1st Choice Voting Probabilities

To avoid zero voting probabilities we have to correct such probabilities. We add $0.01$ to this zero entry and reduce five nonzero voting probabilities by 0.99 This way the sum of transformed probabilities remains $\approx 1.0$.
"

# ╔═╡ 5f006406-68cf-4949-ac04-3a6604b53c4d
py =
	let yProbs = 	[.33, .28, .24, .10, .05, .00]       # empirical voting data  
		yProbsC = yProbs.*0.99
		yProbsC[6] = .01
		yProbsC                                          # null corrected voting data
	end # let

# ╔═╡ 57895480-c96b-4901-b740-39b8e4dcba7f
sum(py)

# ╔═╡ dead5cb6-776f-42c0-a87e-fef4bfd51548
md"
---
###### Civil Courage Ratings $X := S_j', X' = S_j$
"

# ╔═╡ e25439ec-01b2-4312-96c3-8f09c0950c99
begin # Civil Courage
	S1 = Array{Real, 2}(undef, (7, 6))
	S1[:, 1] = [.00, .00, .10, .14, .29, .43, .05] # column 1
	S1[:, 2] = [.00, .00, .00, .05, .19, .48, .29] # column 2
	S1[:, 3] = [.00, .00, .05, .00, .33, .52, .10] # column 3
	S1[:, 4] = [.00, .00, .10, .10, .19, .38, .24] # column 4
	S1[:, 5] = [.00, .00, .00, .05, .57, .33, .05] # column 5
	S1[:, 6] = [.00, .05, .05, .19, .43, .29, .00] # column 6
	size(S1)
end

# ╔═╡ 9c1db2a2-4f50-4a98-a2f5-4b4148b7a00d
plotRatingDistributions2(S1, "Civil Courage Ratings")

# ╔═╡ 147b9adb-41f9-445a-a917-f41d856c9fbf
lookForSingleBestCategory(S1', py)

# ╔═╡ 31e42220-7ce7-4681-9bc3-39ee0b08dd5e
md"
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of $X:=S1'$ with smallest error sum-of-squares $eSSQL$. This generates moderate good predictions: 

- for category 5: $eSSQL = 7.14685,  r(y,\hat y) = 0.486889$

The order of regression predictions is not the same as the order of voting data.

"

# ╔═╡ 9df0d4d2-366b-42e2-8d0a-ac442733cde8
dataModelComparison(title="Data-Model-Comparison:Civil Courage; cat 5",
	[0.14064531350777892, 0.2340068022422968, 0.11308719675331302, 0.2340068022422968, 0.027720548175821858, 0.06394176631696957], # Regression Model
	py, xlabel="Logit-Regression")                                  # empirical voting

# ╔═╡ 51706771-e51f-435b-96c3-e0211723d2f4
md"
---
###### Logit-Regression with 2 Most Important Regressors
Extract that *pair* of columns of S1' with smallest eSSQ. This happens for the combination of the *2nd* and the *5th* category. This generates not an improvement of prediction quality: multiple $R(y, yHat) = 0.631955$ with an $eSSQ_L=2.34856.$
"

# ╔═╡ 69c5aabd-33cb-47b6-aa03-6c82bc098c97
lookForPairOfBestCategories(S1', py)

# ╔═╡ bfbbb36d-81f0-471d-be86-2a8e6b878631
dataModelComparison(title="Data-Model-Comparison: Civil Courage; cats 2, 5",
	[0.1968625491085917, 0.28471638443223507, 0.1679880561474627, 0.28471638443223507, 0.059325565879579316, 0.010000000000000002],# Logit-Regress.
	py, xlabel="Regression Model")                                   # empir. voting

# ╔═╡ 4a4ccf0d-4ab3-4a18-8620-bf4ec27c4b5a
md"
---
###### Liberality Ratings
"

# ╔═╡ 315da59b-12fe-402a-a92f-54a505dcf990
begin # Liberality
	S2 = Array{Real, 2}(undef, (7, 6))
	S2[:, 1] = [.00, .00, .05, .14, .33, .43, .05] # column 1
	S2[:, 2] = [.00, .14, .10, .29, .14, .24, .10] # column 2
	S2[:, 3] = [.00, .10, .24, .24, .24, .19, .00] # column 3
	S2[:, 4] = [.19, .29, .24, .10, .14, .05, .00] # column 4
	S2[:, 5] = [.00, .05, .05, .05, .43, .38, .05] # column 5
	S2[:, 6] = [.00, .00, .10, .29, .19, .38, .05] # column 6
end

# ╔═╡ b6ea59bf-2c21-4a65-ae6e-273d06cff10b
plotRatingDistributions2(S2, "Liberality Ratings")

# ╔═╡ 926ad061-2f5e-4e4b-9df2-8b9d9b75003c
py                                               # empirical voting data

# ╔═╡ 36f11d3c-2212-4b3d-9012-83e24f4f89e0
md"
---
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of S2' with smallest error sum-of-squares $eSSQ_L$. This generates bad predictions: 

- for category 6: $eSSQ_L = 12.9861$ and *positive* single $r(y, \hat y_L) = -0.05976$ 

"

# ╔═╡ 7d555fe1-c33b-4dfb-a934-6c2b7856ba8b
lookForSingleBestCategory(S2', py)

# ╔═╡ c5016fea-b5f8-4a67-b269-8db42badecaf
dataModelComparison(title="Data-Model-Comparison: Liberality; cat 6",
	[0.05675132162705544, 0.17239673818719495, 0.22410273012317158, 0.4190145946512725, 0.07699948010703088, 0.07699948010703088],  # Regression Model
	py, xlabel="Logit-Regression")                                  # empirical voting

# ╔═╡ 9f4bce9d-d2e2-425a-b956-07f360e77c7d
md"
###### Logit-Regression with 2 Most Important Regressors
Extract that *pair* of columns of S2' with smallest $eSSQ_L$. This happens for the combination of the *1st* and the *6th* category. This generates slightly improved predictions: the multiple $R(p_y, \hat p_{y_L}) = 0.379743$ with an $eSSQ_L = 9.47233.$
"

# ╔═╡ 3279576b-9fca-4e65-8002-61c54efcd4be
lookForPairOfBestCategories(S2', py)

# ╔═╡ 1a8794d6-97cf-4435-8b5d-a85c2e02f7a3
dataModelComparison(title="Data-Model-Comparison: Liberality; cats 1, 6",
	[0.060666588483031365, 0.17811397562527725, 0.22959502779139151, 0.10000000000000007, 0.08157041433897129, 0.08157041433897129], # Regression Model
	py, xlabel="Regression Model")                                  # empirical voting

# ╔═╡ 2fe58310-e7a4-443f-8589-197adfc906b8
md"
---
###### Sincerity / Honesty Ratings
"

# ╔═╡ e62d8a93-b6ee-489b-839f-8f7773421c4a
begin # Sincerity/Honesty
	S3 = Array{Real, 2}(undef, (7, 6))
	S3[:, 1] = [.00, .00, .14, .14, .24, .29, .19] # column 1
	S3[:, 2] = [.00, .00, .19, .24, .38, .19, .00] # column 2
	S3[:, 3] = [.00, .10, .14, .29, .38, .05, .05] # column 3
	S3[:, 4] = [.38, .29, .19, .10, .05, .00, .00] # column 4
	S3[:, 5] = [.00, .05, .00, .24, .33, .33, .05] # column 5
	S3[:, 6] = [.00, .00, .05, .24, .24, .33, .14] # column 6
end

# ╔═╡ 1dde5ef9-308a-42ec-923c-62147c9080aa
plotRatingDistributions2(S3, "Sincerity/Honesty Ratings")

# ╔═╡ 7bd7e434-bba9-4bee-a9b2-4f3ed12f4e85
py                                                        # empirical voting data

# ╔═╡ 3833ba78-cab3-4cd5-b351-e1f12b8c7bcf
md"
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of S3' with smallest error sum-of-squares $eSSQ$. This generates good predictions: 

- for category 4: $eSSQ_L = 12.0909$ and *positive* single $r(p_y, \hat p_{y_L}) = 0.0657598$

"

# ╔═╡ da03ea0d-8b63-4d93-8213-b920df1d81d0
lookForSingleBestCategory(S3', py)

# ╔═╡ 4461c98e-4a23-4cef-b02a-34672fd0993c
dataModelComparison(title="Data-Model-Comparison: Honesty; cat 4",
	[0.2117935357695817, 0.09510602963362882, 0.061678106351902885, 0.28116760880025055, 0.09510602963362882, 0.09510602963362882], # Regression Model
	py, xlabel="Logit-Regression")                                  # empirical voting

# ╔═╡ b53b39d1-018a-4f93-b6b5-3b5730c97b4e
md"
###### Logit-Regression with 2 Most Important Regressors
Extract that *pair* of columns of S3' with smallest eSSQ. This happens for the combination of the *4th* and the *5th* category. This generates very good predictions: the multiple $R(p_y, \hat p_{y_L}) = 0.777932$ with an $eSSQ_L = 4.59218.$
"

# ╔═╡ 8f2f08ad-8a4f-4aa7-bb2b-8050127ef861
lookForPairOfBestCategories(S3', py)

# ╔═╡ 9a245e3f-abb8-4685-97b6-99fdbf768f72
dataModelComparison(title="Data-Model-Comparison: Honesty; cat 4, 5",
	[0.44328122657552094, 0.26862010587030233, 0.06011808759237316, 0.07422486574040009, 0.12198988982566365, 0.023580480877779735],# Regression Model
	py, xlabel="Regression Model")                                  # empirical voting

# ╔═╡ 008ab6ee-fa95-41df-b733-ed2e328fd400
md"
---
###### Intelligence Ratings
"

# ╔═╡ 1f06728b-ee2b-4fd5-a249-8f26c8a91219
begin # Intelligence
	S4 = Array{Real, 2}(undef, (7, 6))
	S4[:, 1] = [.00, .00, .00, .05, .29, .33, .33] # column 1
	S4[:, 2] = [.00, .00, .10, .10, .24, .29, .29] # column 2
	S4[:, 3] = [.00, .00, .05, .14, .43, .33, .05] # column 3
	S4[:, 4] = [.00, .00, .00, .10, .19, .52, .29] # column 4
	S4[:, 5] = [.00, .00, .10, .14, .43, .33, .00] # column 5
	S4[:, 6] = [.00, .00, .00, .14, .43, .24, .19] # column 6
end

# ╔═╡ 622e0f68-4383-4ea5-bbd0-dbf8ad28dd36
plotRatingDistributions2(S4, "Intelligence Ratings")

# ╔═╡ 5794da09-09ca-4e87-9341-f7d0031f1c32
py                                                  # empirical voting data

# ╔═╡ 46513a43-666a-4373-950a-de312c036131
md"
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of S4' with smallest error sum-of-squares $eSSQ_L$. This generates moderate good predictions: 

- for category 4: $eSSQ_L= 7.15164$ and *positive* single $r(p_y, \hat p_{y_L}) = 0.680415$ 

"

# ╔═╡ ae1343d7-d107-4840-80ab-ca73473d98f3
lookForSingleBestCategory(S4', py)

# ╔═╡ 168712bf-88b6-4a85-93d3-99de262a8ee4
dataModelComparison(title="Data-Model-Comparison:Intelligence; cat 4",
	[0.2761976258623405, 0.12710480752004327, 0.06311956478369593, 0.12710480752004327, 0.06311956478369593, 0.06311956478369593], # Regression Model
	py,  xlabel="Logit-Regression")                                 # empirical voting

# ╔═╡ 8ca447df-0779-41fd-b2cc-51c24ef3d023
md"
###### Logit-Regression with 2 Most Important Regressors
Extract that *pair* of columns of S4' with smallest $eSSQ_L$. This happens for the combination of the *3rd* and the *4th* category. This combination generates moderate good predictions: multiple $R(p_y, \hat p_{y_L}) = 0.745198$ with an $eSSQ_L = 5.0227.$
"

# ╔═╡ 7d322c5d-a484-4dbb-ad37-0b728584bcf0
lookForPairOfBestCategories(S4', py)

# ╔═╡ 29c9f6f2-e1eb-40ac-a1a7-049717b5a1e3
dataModelComparison(title="Data-Model-Comparison:Intelligence; cats 3, 4",
	[0.22572961963634994, 0.25859840274392254, 0.06035360806332148, 0.07833650551253407, 0.11513469411807686, 0.03073210849604627], # Regression Mod
	py, xlabel="Logit-Regression")                                  # empirical voting

# ╔═╡ de302637-a7e7-410c-b816-9e48c991e75a
md"
---
###### Objectivity Ratings
"

# ╔═╡ c740a512-553c-4fba-a5c6-e4cae979140f
begin # Objectivity
	S5 = Array{Real, 2}(undef, (7, 6))
	S5[:, 1] = [.00, .05, .10, .14, .19, .29, .24] # column 1
	S5[:, 2] = [.00, .00, .19, .19, .24, .33, .05] # column 2
	S5[:, 3] = [.00, .10, .29, .19, .19, .10, .14] # column 3
	S5[:, 4] = [.00, .38, .05, .14, .33, .05, .05] # column 4
	S5[:, 5] = [.00, .05, .10, .10, .33, .38, .05] # column 5
	S5[:, 6] = [.00, .00, .14, .10, .24, .43, .10] # column 6
end

# ╔═╡ 00b44640-4748-4ff1-a9f2-2793664512e3
plotRatingDistributions2(S5, "Objectivity Ratings")

# ╔═╡ e5dd35f6-38b3-47a3-b14c-f9c903ba84b3
py                                                   # empirical voting data

# ╔═╡ baeaf685-7e4f-4afe-bc1d-635c568592cd
md"
###### Logit-Regression with Single Most Important Regressor
Extract *one* column of S5' with smallest error sum-of-squares $eSSQ_L$. This generates moderate good predictions: 

- for category 5: $eSSQ_L = 9.1435$ and *positive* single $r(p_y, \hat p_{y_L}) = 0.703688$ 

"

# ╔═╡ ba6dbcba-f54c-4fa4-8a9a-00ff4279d0a8
lookForSingleBestCategory(S5', py)

# ╔═╡ a92df357-86cb-42bb-bef1-6c79e0edff2f
dataModelComparison(title="Data-Model-Comparison: Objectivity; cat=5",
	[0.17011554964438697, 0.1190074104989989, 0.17011554964438697, 0.059942107259230576, 0.059942107259230576, 0.1190074104989989],  # Regression 
	py, xlabel="Logit-Regression")

# ╔═╡ c4b9ef7f-8c60-4527-b781-a915dc9b8914
md"
###### Logit-Regression with 2 Most Important Regressors
Extract that *pair* of columns of S5' with smallest $eSSQ_L$. This happens for the combination of the *2nd* and the *6th* category. This generates not very good predictions: the multiple $R(p_y, \hat p_{y_L}) = 0.479668$ with an $eSSQ_L = 6.7263.$
"

# ╔═╡ a3c4d037-0a67-40e2-8c08-e09ab9ff945a
lookForPairOfBestCategories(S5', py)

# ╔═╡ c2694462-a1be-431a-a7f5-c61df42595b9
dataModelComparison(title="Data-Model-Comparison: Objectivity, cats 2, 6",
	[0.10404029857292586, 0.10028485271654, 0.24696425400371924, 0.11481861002661797, 0.060002099260702255, 0.05422147955697393],                     # Regression Mod
	py, xlabel="Regression Model")                                  # empirical voting

# ╔═╡ 7d1c439d-6a41-4124-a2d7-e84d999da83b
md"
---
##### Summary of Logit-Regression Results

$\begin{array}{c|c|c}
\text{scale} & \text{cat} & \text{eSSQL for 1 cat} & \text{r for 1 cat} & \text{cats}  & \text{eSSQL for 2 cats} & \text{R for 2 cats}  \\

\hline & & & & & & \\

\text{Civil Courage} & 5 & 7.14685 & 0.486889 & 2, 5 & 2.34856 & 0.631955 \\
\text{Liberality}  & 6 & 12.9862 & -0.05976 & 1, 6 & 9.47233 & 0.379743 \\
\mathbf{Honesty} & 4 & 12.0909 & 0.06576 & \mathbf{4, 5} & \mathbf{4.59218} & \mathbf{0.777932} \\
\mathbf{Intelligence}  & 4 & 7.15164 & 0.680415 & \mathbf{3, 4} & \mathbf{5.0227} & \mathbf{0.745198} \\
\text{Objectivity} & 5 & 9.1435 & 0.703688 & 2, 6 & 6.7263 & 0.47966  \\

\hline & & & & & & \\

\end{array}$

$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$
$\;$

The table (above) demonstrates that the most informative categories $3, 4, 5$ are the most affective rating categories. The best predictor is *Honesty* followed by *Intelligence*. The importance of *Honesty* is congruent with the *Voting* model.

"

# ╔═╡ 335e0278-9e8d-41d7-83df-cef45613c69c
md"
---
##### References
- **Ahrens, H.J. & Möbus, C.**; [Zur Verwendung von Einstellungsmessungen bei der Prognose von Wahlentscheidungen](http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf); Zeitschrift für Experimentelle und Angewandte Psychologie, 1968, Band XV. Heft 4. S.543-563; [http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf](http://oops.uni-oldenburg.de/2729/1/PCM1968.pdf) last visit: 2023/09/29
- **Fahrmeir, L., Kneib, Th., Lang, St. & Marx, B.**; *Regression: Models, Methods, and Applications*; Heidelberg: Springer, 2nd/e, 2022
- **Katsikopoulos, K.V.**; *Cognitive Operations: Models that Open the Black Box and Predict our Decisions*, Cham, Switzerland: Palgrave Macmillan, 2023
- **Thurstone, L.L.**; [The Prediction of Choice](https://link.springer.com/content/pdf/10.1007/BF02288891.pdf); Psychometrika 10.4 (1945): 237-253; [https://link.springer.com/content/pdf/10.1007/BF02288891.pdf](https://link.springer.com/content/pdf/10.1007/BF02288891.pdf); last visit 2023/09/29
- **Wang, Z, J. & Busemeyer, J.R.**; *Cognitive Choice Modeling*, Cambridge, Mass: MIT Press, 2021
"


# ╔═╡ 3b6f9e44-5fa0-4216-ab64-c02d6955c358
md"
---
##### End of ch. 1.3.1.3
"

# ╔═╡ ab7edd53-28d6-44f6-8773-4fdf3ee4548f
md"
====================================================================================

This is a **draft** under the Attribution-NonCommercial-ShareAlike 4.0 International **(CC BY-NC-SA 4.0)** license. Comments, suggestions for improvement and bug reports are welcome: **claus.moebus(@)uol.de**

====================================================================================
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
LaTeXStrings = "~1.3.1"
Plots = "~1.39.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "0c9117518018e11689100c8b18e2e18969b87aea"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

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
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

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
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

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

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

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
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

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
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

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
git-tree-sha1 = "9fb0b890adab1c0a4a475d4210d51f228bfc250d"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.6"

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
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

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
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

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
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "f512dc13e64e96f703fd92ce617755ee6b5adf0f"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.8"

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
git-tree-sha1 = "cc6e1927ac521b659af340e0ca45828a3ffc748f"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.12+0"

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
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

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
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

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
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

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
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

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
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

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
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

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
git-tree-sha1 = "242982d62ff0d1671e9029b52743062739255c7e"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.18.0"

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

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522b8414d40c4cbbab8dee346ac3a09f9768f25d"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.5+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

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

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "47cf33e62e138b920039e8ff9f9841aafe1b733e"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.35.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

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

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

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

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

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
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─ff9905c0-5bb9-11ee-13a0-d19d37925232
# ╠═c4ac1d38-eea8-4e67-a841-e08f017f9d50
# ╟─9cd660f5-3661-47ba-9c2b-728ca344d8ac
# ╟─98c606de-82d0-4395-8949-f3968dd5eed6
# ╟─d8c2066f-3539-462f-a6c7-48b85fbe0d06
# ╟─3fb6649d-eeb0-4d9c-ae3a-5574ebf6f171
# ╟─ef5b0168-84f9-4e97-b4a0-c2bb87948612
# ╟─466b2de4-36f1-48d9-85e4-2f7bdbbcdb08
# ╟─a54dbf87-3ab4-4005-beaa-a3b7905b74e8
# ╟─390b1aad-a075-45b9-be77-ba9c0b460dab
# ╠═51c83dc0-691b-4bcb-826d-4902613a520c
# ╠═39794b9e-3146-45d2-9e27-f6116ed5cba7
# ╠═c50ab7d7-c24d-4571-ad31-a292db6b6b80
# ╟─a60caaac-e87f-44a7-846f-edc140a79308
# ╟─d8d7c504-20a6-48a9-8988-d119ae1b8085
# ╟─3ddb407e-8be5-4358-8731-97ab93e1b914
# ╠═19ea4ab6-93f3-4cc9-8862-1e9a18bae8fe
# ╠═5b7bcf2c-b4f1-4723-97fa-5ceb0e28bb27
# ╠═d7287d9d-3e8a-4a83-82ea-155f1fbbded8
# ╟─5b3d00c5-39d7-415e-a7ba-df30080a9a76
# ╟─84281755-8e8d-4638-ad02-0043e5ddaad2
# ╠═daa9bbf3-fb5c-4870-bb7a-8e07f8b07593
# ╟─f5dce854-62f2-4d36-a723-c95e7e74b2d8
# ╠═f39fd70b-bb89-43c6-b337-c265b0fbc847
# ╠═3ff052e0-fd05-41d4-88e3-e840bef6d27a
# ╠═4846d725-71a6-41ef-8c81-eaf29c6f0c1b
# ╠═2312b040-eeac-4ff3-8ed2-ec2656d1a91f
# ╠═0654cef2-0108-4332-8398-5c5363297e27
# ╟─f5631ab3-d8be-4957-9fc3-d02fcda0b738
# ╠═c8ef1769-cbc9-491e-9916-8b7bc64b8ede
# ╠═fd2dc361-80a2-46ba-93e8-4a3e7e51ced8
# ╠═9214d187-0f6f-4eb8-aad7-9c7286b7e0a2
# ╟─772028ee-f04d-48a8-83b8-92f91f00b14d
# ╠═7e4e8d1c-5f4e-49a7-9dd7-4745b102eb99
# ╠═3b529980-f7d4-4e2c-b902-4d9d8f33ba17
# ╠═fb01e2b3-dbaf-4ed5-8737-6f871aeff40f
# ╟─7f1bf0d9-47d6-4bf9-9d8d-c2e83e5eec53
# ╠═f4baecd3-99ff-4cef-8103-8e19d52012b2
# ╠═a84e8ab7-0935-4dd0-976a-59f861abed0d
# ╠═44709a59-eb71-49e0-a2a0-82c9bf3ca3ae
# ╟─be160724-356f-4fb9-8ff7-14049d7293a8
# ╠═802c2949-b3ac-42d0-b0fc-553f7bdb51d1
# ╠═4cdcaad1-8cff-46e2-a99f-895294225353
# ╠═6cb733aa-ebaa-461a-9a3d-d29cd3f40a0d
# ╟─27b9a96f-633b-4ca2-bd7c-5986866dfc7d
# ╠═ac8c5d44-f740-4098-9976-aa2e39c1a56b
# ╠═f4ab6423-ad57-4876-8b9a-a173dee8b570
# ╟─efb3eeca-e169-4473-bec1-68bc3e710062
# ╠═f1c839d7-7df1-41b9-8829-119be55b53f2
# ╠═47d4c770-bf1a-4450-a0c8-d31bac444d03
# ╟─027c3cdb-a4bd-4760-9bcb-ab501fa8b48c
# ╟─ea1d87e8-247d-4482-80f0-2dba4736ed5b
# ╠═5f006406-68cf-4949-ac04-3a6604b53c4d
# ╠═57895480-c96b-4901-b740-39b8e4dcba7f
# ╟─dead5cb6-776f-42c0-a87e-fef4bfd51548
# ╠═e25439ec-01b2-4312-96c3-8f09c0950c99
# ╠═9c1db2a2-4f50-4a98-a2f5-4b4148b7a00d
# ╠═147b9adb-41f9-445a-a917-f41d856c9fbf
# ╟─31e42220-7ce7-4681-9bc3-39ee0b08dd5e
# ╠═9df0d4d2-366b-42e2-8d0a-ac442733cde8
# ╟─51706771-e51f-435b-96c3-e0211723d2f4
# ╠═69c5aabd-33cb-47b6-aa03-6c82bc098c97
# ╠═bfbbb36d-81f0-471d-be86-2a8e6b878631
# ╟─4a4ccf0d-4ab3-4a18-8620-bf4ec27c4b5a
# ╠═315da59b-12fe-402a-a92f-54a505dcf990
# ╠═b6ea59bf-2c21-4a65-ae6e-273d06cff10b
# ╠═926ad061-2f5e-4e4b-9df2-8b9d9b75003c
# ╟─36f11d3c-2212-4b3d-9012-83e24f4f89e0
# ╠═7d555fe1-c33b-4dfb-a934-6c2b7856ba8b
# ╠═c5016fea-b5f8-4a67-b269-8db42badecaf
# ╟─9f4bce9d-d2e2-425a-b956-07f360e77c7d
# ╠═3279576b-9fca-4e65-8002-61c54efcd4be
# ╠═1a8794d6-97cf-4435-8b5d-a85c2e02f7a3
# ╟─2fe58310-e7a4-443f-8589-197adfc906b8
# ╠═e62d8a93-b6ee-489b-839f-8f7773421c4a
# ╠═1dde5ef9-308a-42ec-923c-62147c9080aa
# ╠═7bd7e434-bba9-4bee-a9b2-4f3ed12f4e85
# ╟─3833ba78-cab3-4cd5-b351-e1f12b8c7bcf
# ╠═da03ea0d-8b63-4d93-8213-b920df1d81d0
# ╠═4461c98e-4a23-4cef-b02a-34672fd0993c
# ╟─b53b39d1-018a-4f93-b6b5-3b5730c97b4e
# ╠═8f2f08ad-8a4f-4aa7-bb2b-8050127ef861
# ╠═9a245e3f-abb8-4685-97b6-99fdbf768f72
# ╟─008ab6ee-fa95-41df-b733-ed2e328fd400
# ╠═1f06728b-ee2b-4fd5-a249-8f26c8a91219
# ╠═622e0f68-4383-4ea5-bbd0-dbf8ad28dd36
# ╠═5794da09-09ca-4e87-9341-f7d0031f1c32
# ╟─46513a43-666a-4373-950a-de312c036131
# ╠═ae1343d7-d107-4840-80ab-ca73473d98f3
# ╠═168712bf-88b6-4a85-93d3-99de262a8ee4
# ╟─8ca447df-0779-41fd-b2cc-51c24ef3d023
# ╠═7d322c5d-a484-4dbb-ad37-0b728584bcf0
# ╠═29c9f6f2-e1eb-40ac-a1a7-049717b5a1e3
# ╟─de302637-a7e7-410c-b816-9e48c991e75a
# ╠═c740a512-553c-4fba-a5c6-e4cae979140f
# ╠═00b44640-4748-4ff1-a9f2-2793664512e3
# ╠═e5dd35f6-38b3-47a3-b14c-f9c903ba84b3
# ╟─baeaf685-7e4f-4afe-bc1d-635c568592cd
# ╠═ba6dbcba-f54c-4fa4-8a9a-00ff4279d0a8
# ╠═a92df357-86cb-42bb-bef1-6c79e0edff2f
# ╟─c4b9ef7f-8c60-4527-b781-a915dc9b8914
# ╠═a3c4d037-0a67-40e2-8c08-e09ab9ff945a
# ╠═c2694462-a1be-431a-a7f5-c61df42595b9
# ╟─7d1c439d-6a41-4124-a2d7-e84d999da83b
# ╟─335e0278-9e8d-41d7-83df-cef45613c69c
# ╟─3b6f9e44-5fa0-4216-ab64-c02d6955c358
# ╟─ab7edd53-28d6-44f6-8773-4fdf3ee4548f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
