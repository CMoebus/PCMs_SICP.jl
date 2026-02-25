### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ 94810bf0-1243-11f1-9c64-61ad6aa7f1af
md"
====================================================================================
#### SICP: [1.1 *The Elements of Programming*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-10.html)
##### file: PCM20260225\_1.1\_TheElementsOfProgramming.jl
##### Julia/Pluto.jl: 1.12.5/0.20.4 by PCM *** 2026/02/25 ***

====================================================================================
"


# ╔═╡ 7eb293fe-67ed-43d7-a37d-203d8021bbae
md"
---
##### Introduction
*A powerful programming language is more than just a means for instructing a computer to perform tasks. The language also serves as a framework within which we organize our ideas about processes. Thus, when we describe a language, we should pay particular attention to the means that the language provides for combining simple ideas to form more complex ideas. Every powerful language has three mechanisms for accomplishing this*:

- **primitive expressions**, *which represent the simplest entities the language is concerned with*,

- **means of combination**, *by which compound elements are built from simpler ones, and*

- **means of abstraction**, *by which compound elements can be named and manipulated as units*.

*In programming, we deal with two kinds of elements: procedures and data. (Later we will discover that they are really not so distinct.) Informally, data is ``stuff'' that we want to manipulate, and procedures are descriptions of the rules for manipulating the data. Thus, any powerful programming language should be able to describe primitive data and primitive procedures and should have methods for combining and abstracting procedures and data.* (Abelson, H.; Sussman, G.J. & Sussman, J.; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-10.html); MIT Press (4th printing, 1999); last visit 2026/02/25)
"

# ╔═╡ 244dbf20-1766-4a6d-a640-6088fe92def5
md"
---
##### References
- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book.html), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2026/02/25), Cambridge, Mass.: MIT Press, (2/e), 1996

- **Abelson, H., Sussman, G.J. & Sussman, J.**; [*Structure and Interpretation of Computer Programs*](https://web.mit.edu/6.001/6.037/sicp.pdf), Cambridge, Mass.: MIT Press, (2/e), 2016; last visit 2026/02/25

"

# ╔═╡ 8564eb84-79f0-4bb7-be80-89f50d9aeaa4
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

julia_version = "1.12.5"
manifest_format = "2.0"
project_hash = "71853c6197a6a7f222db0f1978c7cb232b87c5ee"

[deps]
"""

# ╔═╡ Cell order:
# ╟─94810bf0-1243-11f1-9c64-61ad6aa7f1af
# ╟─7eb293fe-67ed-43d7-a37d-203d8021bbae
# ╟─244dbf20-1766-4a6d-a640-6088fe92def5
# ╟─8564eb84-79f0-4bb7-be80-89f50d9aeaa4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
