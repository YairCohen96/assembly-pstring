# assembly-pstring
linux gnu assembly implementation of pstring structure and functions (string type in c) 

a simple assembly implementation for pstring string type of c.
done as a part of computer structure course at BIU.

to use the program:

after downloading the files to your computer (linux system required),
on your terminal:
press make to compile.
run ./a.out (then input:)
first string length
firts string
second length
second string
choose an number of the following:
31 - will print the two lengths. (pstrlen)
32+33 - will take two more chars as input, and replace the first one for the second, on both strings. (replaceChar)
35 - will take two indices as input, i & j, and will copy second string substring from i to j, to first string (strcpy)
36 - will swap every letter's case - upper to lower or lower to upper. (swapCase)
37 - lexical comparison between the two string (the order determined by ascii table) (strcmmp)

as mentioned, all functions are implemented fully in assembly.
