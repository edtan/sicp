#lang sicp
;Exercise 2.89.  Define procedures that implement the term-list representation described above as appropriate for dense polynomials.

; These definitions remain the same
(define (the-empty-termlist) '())
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))

;These definitions change

(define (make-term order coeff)
  (if (= order 0)
      (list coeff)
      (append (make-term (- order 1) coeff) (list 0))))
;(display (make-term 3 3))
;(3 0 0 0)

(define (coeff term) (car term))
(define (order term) (dec (length term)))

(define (first-term term-list) (make-term (dec (length term-list)) (car term-list)))
;(display (first-term '(3 1 0 2)))
;(3 0 0 0)

;adjoin-term assumes that the order of term is greater than term-list
(define (adjoin-term term term-list)
  (let ((order-diff (- (order term) (order (first-term term-list)))))
    (cond ((=zero? (coeff term)) term-list)
          ((> order-diff 0) (append (make-term (- order-diff 1) (coeff term)) term-list))
          (else (error "term must be greater than order of term-list" term term-list)))))
;(display (adjoin-term '(4 0 0 0 0) '(1 2 0)))
;(4 0 1 2 0)