#lang sicp
;Exercise 2.6.  In case representing pairs as procedures wasn't mind-boggling enough, consider that, in a language that can manipulate procedures, we can get by without numbers (at least insofar as nonnegative integers are concerned) by implementing 0 and the operation of adding 1 as

(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;This representation is known as Church numerals, after its inventor, Alonzo Church, the logician who invented the  calculus.

;Define one and two directly (not in terms of zero and add-1). (Hint: Use substitution to evaluate (add-1 zero)). Give a direct definition of the addition procedure + (not in terms of repeated application of add-1).


; Interesting problem. From the beginning, you know that this really shows how procedures can be data, although it is unclear at the beginning how these procedures 'look' like.  After expanding out the terms, you can tell that there is some type of structure to these procedures, so it seems feasible to actually create some type of number system out of them.

;one
;(add-1 zero)
;(lambda (f) (lambda (x) (f ((zero f) x))))
;(lambda (f) (lambda (x) (f (((lambda (f0) (lambda (x0) x0)) f) x))))
;(lambda (f) (lambda (x) (f ((lambda (x0) x0) x))))
;(lambda (f) (lambda (x) (f x)))
(define one (lambda (f) (lambda (x) (f x))))

;two
;(add-1 one)
;(lambda (f) (lambda (x) (f ((one f) x))))
;(lambda (f) (lambda (x) (f (((lambda (f1) (lambda (x1) (f1 x1))) f) x))))
;(lambda (f) (lambda (x) (f ((lambda (x1) (f x1)) x))))
;(lambda (f) (lambda (x) (f (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

; We see that numbers are represented by the number of times f is applied to x in the innner lambda.  So this is how we try to design the + procedure.

; + was designed by first modifying add-1 to become add-0
; (lambda (f) (lambda (x) ((n f) x))) ; just remove the outer f
; Then, realizing that we simply had to pre-apply the other number by first applying it to f.

(define (+ a b)
  (lambda (f) (lambda (x) ((a f) ((b f) x)))))

; check if this works for one + two
;(+ one two)
;(lambda (f) (lambda (x) ((one f) ((two f) x))))
;(lambda (f) (lambda (x) (((lambda (f1) (lambda (x1) (f1 x1))) f) ((lambda (f2) (lambda (x2) (f2 (f2 x2)))) f) x)))
;(lambda (f) (lambda (x) ((lambda (x1) (f x1)) (lambda (x2) (f (f x2))) x)))
;(lambda (f) (lambda (x) ((lambda (x1) (f x1)) (f (f x)))))
;(lambda (f) (lambda (x) (f (f (f x)))))
; which does indeed look like three