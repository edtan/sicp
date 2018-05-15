#lang racket

;Exercise 1.16.  Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt. (Hint: Using the observation that (b^(n/2))^2 = (b^2)^(n/2), keep, along with the exponent n and the base b, an additional state variable a, and define the state transformation in such a way that the product a bn is unchanged from state to state. At the beginning of the process a is taken to be 1, and the answer is given by the value of a at the end of the process. In general, the technique of defining an invariant quantity that remains unchanged from state to state is a powerful way to think about the design of iterative algorithms.)

; Using the hint, we can factor out (b^2) at each step.  E.g.
; if n is odd:
;1 * b^n
;= b * b^(n-1)
; if n is even:
;1 * b^n
;= (b^2)^(n/2)
;= (b^2) * (b^2)^((n/2)-1)

(define (square x)
  (* x x))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast-expt b n)
  (fast-expt-iter b n 1))

(define (fast-expt-iter b n a)
  (cond ((= n 0) a)
        ((not (even? n)) (fast-expt-iter b (- n 1) (* b a)))
        (else (fast-expt-iter (square b) (- (/ n 2) 1) (* (square b) a)))))


(fast-expt 9 10) ;3486784401

;example for 2^10
(fast-expt 2 10)
(fast-expt-iter 2 10 1)
(fast-expt-iter 4 4 4)
(fast-expt-iter 16 1 64)
(fast-expt-iter 16 0 1024)