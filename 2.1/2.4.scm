#lang sicp

;Exercise 2.4.  Here is an alternative procedural representation of pairs. For this representation, verify that (car (cons x y)) yields x for any objects x and y.

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

;What is the corresponding definition of cdr? (Hint: To verify that this works, make use of the substitution model of section 1.1.5.)


(define (cdr z)
  (z (lambda (p q) q)))

; In words, this is what's happening: (cons x y) returns a procedure, which takes as an argument another procedure that takes two arguments, and applies that procedure to x and y.  Thus, x and y are bound to the returned procedure - this is how the procedure 'is' the data - it has memory of x and y at the time that cons was called.  When car is applied to (cons x y), it simply picks out x or y (named p and q in the inner lambda of car).

; Here's what it looks like when expanding using the substitution model:

(car (cons 3 6))
(car (lambda (m) (m 3 6)))
((lambda (m) (m 3 6)) (lambda (p q) p))
((lambda (p q) p) 3 6)
;3

(cdr (cons 3 6))
(cdr (lambda (m) (m 3 6)))
((lambda (m) (m 3 6)) (lambda (p q) q))
((lambda (p q) q) 3 6)
;6