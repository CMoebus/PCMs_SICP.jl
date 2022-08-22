# PCMs_SICP.jl
This is my personal reconstruction of SICP in Pluto/Julia. It is published here in the expectation that the Pluto/Julia community is willing to provide bug reports and code improvements because you never can be certain that you found the most efficient and elegant solution.

The seminal book "Structure and Interpretation of Computer Programs (SICP)" was documenting the introductory CS course at the MIT for years (https://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs). In both editions the book presented algorithms in the Scheme dialect MIT-Scheme. The book's content was published as html-files in the public domain (https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-10.html). 

Later new lecturers took over the responsibility replacing Scheme by Python. One of the main reasons was the impression that todays developers need a 'glue' language combining libraries. Though the MIT-CS course switched over to Python, the website remained the same in content and url-location.

This year (2022) MIT Press did not provide a follow-up edition like "SICP in Python" but an edition in Javascript (https://en.wikipedia.org/wiki/Structure_and_Interpretation_of_Computer_Programs,_JavaScript_Edition). This is a bit astonishing because the target audience of the SICP-Scheme editions were CS and electrical engineers. These students don't use JS for their work.

In the last two years I became more acquainted with Julia partly because of David Barber's (http://web4.cs.ucl.ac.uk/staff/D.Barber/pmwiki/pmwiki.php?n=Brml.HomePage) recommendation and partly because some time later I came across the elegant probabilistic programming language TURING (https://github.com/TuringLang). Moreover two other probabilistic programming languages (...) are also based on Julia and its libraries. So I realized that Julia is the upcoming scientific programming language replacing Matlab, Python, and Scheme. In any case it is a more natural and more efficient successor of Scheme than JS. 

Now, learning Julia by transpiling the original SICP-Scheme scripts into Pluto/Julia seems to me the best practice in developing CS-skills in various basic domains.

Claus Möbus (2022/08/21)
