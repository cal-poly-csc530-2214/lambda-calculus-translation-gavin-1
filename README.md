# lambda-calculus-translation-gavin-1
I used the code from class as my base code. I modified the original "translate-arithmetic" function to be a general "translate-lc" that will translate from the lambda calculus grammar to Python. I didn't change the LC grammar and tried to just meet the possible situations shown in the grammar. For example, strings aren't a part of the grammar so I didn't consider looking for strings as a "terminal" case since strings aren't a number or an id. Thus, an input lambda calculus string like (println "Hello World!") will cause an error because I didn't handle parsing quotes ("). The details of the grammar are shown below.

I also made some example outputs and test cases for the translated Python code. The tests aren't very extensive, but I believe that the tests cover most of the situations I can think of that can actually be run in Python.

LC	 	=	 	    num
                |	 	id
                |	 	(/ id => LC)
                |	 	(LC LC)
                |	 	(+ LC LC)
                |	 	(* LC LC)
                |	 	(ifleq0 LC LC LC)
                |	 	(println LC)