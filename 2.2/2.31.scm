#lang sicp
;Exercise 2.31.  Abstract your answer to exercise 2.30 to produce a procedure tree-map with the property that square-tree could be defined as

;(define (square-tree tree) (tree-map square tree))


(define (tree-map proc tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map proc sub-tree)
             (proc sub-tree)))
       tree))

(define (square x) (* x x))
(define (square-tree tree) (tree-map square tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;(mcons 1
;       (mcons
;        (mcons 4 (mcons
;                  (mcons 9 (mcons 16 '()))
;                  (mcons 25 '())))
;        (mcons (mcons 36 (mcons 49 '())) '())))