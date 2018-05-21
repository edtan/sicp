#lang sicp

;Exercise 2.55.  Eva Lu Ator types to the interpreter the expression

;(car ''abracadabra)

;To her surprise, the interpreter prints back quote. Explain.

;This expands out to:
(car '(quote abracadabra))
(car (list 'quote 'abracadabra))   ; that is, we have a list with two elements - the first element is the symbol "quote", and the second element is the symbol "abracadara"
'quote