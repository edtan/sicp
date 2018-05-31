#lang sicp
;Exercise 3.18.  Write a procedure that examines a list and determines whether it contains a cycle, that is, whether a program that tried to find the end of the list by taking successive cdrs would go into an infinite loop. Exercise 3.13 constructed such lists.

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (has-cycle? l)
  (let ((visited-pairs '()))

    (define (already-visited? p)
      (if (memq p visited-pairs)
          true
          false))

    (define (add-visited p)
      (if (null? visited-pairs)
          (set! visited-pairs (cons p '()))
          (let ((last (last-pair visited-pairs)))
            (set-cdr! last (cons p '())))))

    (define (has-cycle-iter? l)
      (cond ((null? (cdr l)) false)
            ((already-visited? l) true)
            (else
             (add-visited l)
             (has-cycle-iter? (cdr l)))))

    (has-cycle-iter? l)))
  
    
(has-cycle? (list 1 2 3))
;false

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
(has-cycle? z)
;true