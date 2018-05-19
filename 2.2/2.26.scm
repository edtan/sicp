#lang sicp
;Exercise 2.26.  Suppose we define x and y to be two lists:

(define x (list 1 2 3))
(define y (list 4 5 6))

;What result is printed by the interpreter in response to evaluating each of the following expressions:

(append x y)
;Should be equivalent to (1 2 3 4 5 6 nil)
;Actual result: (mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 (mcons 6 '()))))))

(cons x y)
;Should be equivalent to ((1 2 3) (4 5 6))
;Actual result: (mcons (mcons 1 (mcons 2 (mcons 3 '()))) (mcons 4 (mcons 5 (mcons 6 '()))))

(list x y)
;Should be equivalent to ((1 2 3) (4 5 6) nil)
;Actual result: (mcons (mcons 1 (mcons 2 (mcons 3 '()))) (mcons (mcons 4 (mcons 5 (mcons 6 '()))) '()))