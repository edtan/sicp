#lang sicp
;Exercise 2.62.  Give a O(n) implementation of union-set for sets represented as ordered lists.


(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((x1 (car set1))
               (x2 (car set2)))
           (cond
             ((= x1 x2) (union-set (cdr set1) set2))
             ((< x1 x2) (cons x1 (union-set (cdr set1) set2)))
             (else (cons x2 (union-set set1 (cdr set2)))))))))

(union-set '(2 4 6) '(1 4 8))
;(mcons 1 (mcons 2 (mcons 4 (mcons 6 (mcons 8 '())))))
(union-set '(2 4 6 8 10) '(1 4 8))
;(mcons 1 (mcons 2 (mcons 4 (mcons 6 (mcons 8 (mcons 10 '()))))))
(union-set '(2 5 9) '(2 4 6 8 10))
;(mcons 2 (mcons 4 (mcons 5 (mcons 6 (mcons 8 (mcons 9 (mcons 10 '())))))))