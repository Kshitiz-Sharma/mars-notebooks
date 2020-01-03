# Mars notebooks
<img src="logo/mars.png" width="300">

#### Literate programming micro framework for Shell Scripts
>Literate programming is a programming paradigm introduced by Donald Knuth in which a program is given as an explanation of the program logic in a natural language, such as English, interspersed with snippets of code, from which a compilable source code can be generated

https://en.wikipedia.org/wiki/Literate_programming

#### Naming and source of inspiration
`Jupyter Notebooks` allow literate programming in Python by embedding code snippets inside a readable document. 

They are popular in Data Science, and Machine Learning since documenting a program in these fields requires more of an explanation of the underlying theory and math than the implementation code itself. 
Hence the notebook is written as a set of equations and diagrams, interspersed with code snippets.
https://en.wikipedia.org/wiki/Project_Jupyter

Mars notebooks provide similar functionality for Shell Scripts.

#### Video documentation
An overview of the framework and usage instructions are provided here [url]

#### Best practices
- Each notebook should have the following sections
    + About section with purpose of document
    + Dependencies: what other notebooks does this depend on
    + TODO: description of partially implemented functions, bugs, and limitations
    + Functions themselves
- Each function should be defined in 3 parts
    + Name and description
    + Usage: general syntax and 1 example
    + Code
- Check the sample-notebooks provided for a practical reference
