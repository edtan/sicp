#lang sicp
;Exercise 2.61.  Give an implementation of adjoin-set using the ordered representation. By analogy with element-of-set? show how to take advantage of the ordering to produce a procedure that requires on the average about half as many steps as with the unordered representation.

;This adjoin-set will keep track of the lowest member in the variable x, and recursively call adjoin-set with x and (cdr set), while checking if x is equal to a member of the set.  If it is equal to the set, adjoin-set simply returns the set.
(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (let ((cur-set-item (car set))
            (rest-of-set (cdr set)))
        (cond ((< x cur-set-item) (cons x (adjoin-set cur-set-item rest-of-set)))  ; swap x and cur-set-item
              ((= x cur-set-item) set)
              (else (cons cur-set-item (adjoin-set x rest-of-set)))))))

(adjoin-set 1 '(2 4 6 8))
;(mcons 1 (mcons 2 (mcons 4 (mcons 6 (mcons 8 '())))))
(adjoin-set 2 '(2 4 6 8))
;(mcons 2 (mcons 4 (mcons 6 (mcons 8 '()))))
(adjoin-set 4 '(2 4 6 8))
;(mcons 2 (mcons 4 (mcons 6 (mcons 8 '()))))
(adjoin-set 5 '(2 4 6 8))
;(mcons 2 (mcons 4 (mcons 5 (mcons 6 (mcons 8 '())))))