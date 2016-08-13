# Elvish Vectorial Images and nitcc

Now that you are an expert with class refinement and heterogeneous data structures, let's try something fancier.

[nitcc](http://info.uqam.ca/~privat/catalog/p/nitcc.html) is an ad-hoc, experimental and work-in-progress compiler generator greatly inspired by [SableCC](http://www.sablecc.org/).
We will use it to transform a formal language description (tokens and grammar) into classes to represent, parse and manipulate abstract syntax trees.

Here the language specification for a vectorial, elvish drawing system.

* [logolas grammar](logolas.sablecc)

## Mission

* Difficulty: medium

Your first step is to compile it.

* compile a recent version of nitcc.
* execute it on the provided grammar of `logolas`.
* compile the generated `logo_test_parser.nit` program
* execute the program on the following example: [elen](elen.logolas)
* compute the MD5 message digest of the generated `logolas.ast.out`
* send the flag `UQAM{md5}`
