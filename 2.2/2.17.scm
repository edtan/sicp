#lang sicp
;Exercise 2.17.  Define a procedure last-pair that returns the list that contains only the last element of a given (nonempty) list:


(define (last-pair l)
  (if (null? (cdr l))
      (car l)
      (last-pair (cdr l))))

(last-pair (list 23 72 149 34))
;34
(last-pair (list 23 72 149))
;149