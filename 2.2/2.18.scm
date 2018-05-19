#lang sicp
;Exercise 2.18.  Define a procedure reverse that takes a list as argument and returns a list of the same elements in reverse order:

(define (reverse l)
  (define (r-iter remaining result)
    (if (null? remaining)
        result
        (r-iter (cdr remaining) (cons (car remaining) result))))
  (r-iter l nil))

(reverse (list 1 4 9 16 25))
;(mcons 25 (mcons 16 (mcons 9 (mcons 4 (mcons 1 '())))))