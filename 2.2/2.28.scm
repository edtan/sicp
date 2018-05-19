#lang sicp

;Exercise 2.28.  Write a procedure fringe that takes as argument a tree (represented as a list) and returns a list whose elements are all the leaves of the tree arranged in left-to-right order. For example,

(define x (list (list 1 2) (list 3 4)))

;(fringe x)
;(1 2 3 4)

;(fringe (list x x))
;(1 2 3 4 1 2 3 4)

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define (fringe l)
  (cond ((null? l) nil)
        ((not (pair? l)) (cons l nil))
        (else (append (fringe (car l)) (fringe (cdr l))))))

(fringe x)
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 '()))))

(fringe (list x x))
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 1 (mcons 2 (mcons 3 (mcons 4 '()))))))))

(define y (list (list 1 2) (list 3 4) (list 5 6 (list 7 8))))
(fringe y)
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 (mcons 6 (mcons 7 (mcons 8 '()))))))))