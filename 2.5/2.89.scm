#lang sicp
;Exercise 2.89.  Define procedures that implement the term-list representation described above as appropriate for dense polynomials.

; The only procedures that have to change for the dense representation are make-term, order, and first-term

; These remain the same
(define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
(define (the-empty-termlist) '())
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (coeff term) (cadr term))

;These change
(define (make-term order coeff)
  (if (= order 0)
      (list coeff)
      (append (make-term (- order 1) coeff) (list 0))))
;(display (make-term 3 3))
;(3 0 0 0)
(define (order term) (dec (length term)))
(define (first-term term-list) (make-term (dec (length term-list)) (car term-list)))
;(display (first-term '(3 1 0 2)))
;(3 0 0 0)