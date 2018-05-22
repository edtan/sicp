#lang sicp
;Exercise 2.72.  Consider the encoding procedure that you designed in exercise 2.68. What is the order of growth in the number of steps needed to encode a symbol? Be sure to include the number of steps needed to search the symbol list at each node encountered. To answer this question in general is difficult. Consider the special case where the relative frequencies of the n symbols are as described in exercise 2.71, and give the order of growth (as a function of n) of the number of steps needed to encode the most frequent and least frequent symbols in the alphabet.

;For the special case as described in exercise 2.71, the left branch always just has a single symbol and is a leaf, and the right branch contains the remaining symbols.  During each iteration, the symbol lists of the left branch and right branches are searched.  The left branch takes O(1) time to search because it only contains a single element.  For the right branch, each child right branch has one less symbol than its parent.  The symbol list at each node is not sorted, so the whole list would have to be searched in the worst case.  Thus, in the worst case, the number of symbols that have to be search through is
;(left branches) + (right branches)
;= (1 + ... + 1) + (n + (n-1) + (n-2) + ... + 2 + 1)
;= n + n * (n + 1) / 2
;= O(n^2)
