#lang racket
;Exercise 1.10.  The following procedure computes a mathematical function called Ackermann's function.

(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

;What are the values of the following expressions?

(A 1 10)
; = A( 0 (A 1 9))
; = (* 2 (A 1 9))
; = (* 2 2 (A 1 8))
; ...
; = 2 ^ 10
; = 1024

(A 2 4)
; = (A 1 (A 2 3))
; = (A 1 (A 1 (A 2 2)))
; = (A 1 (A 1 (A 1 (A 2 1))))
; = (A 1 (A 1 (A 1 (2))))
; = (A 1 (A 1 4))  ; see definition and explation of (f n) below to see why this step holds
; = (A 1 16)
; = 65536 (2 ^ 16)

(A 3 3)
; = (A 2 (A 3 2))
; = (A 2 (A 2 (A 3 1)))
; = (A 2 (A 2 2))
; = (A 2 4)  ; because of the definition of (h n) as discussed below
; = 65536


;Consider the following procedures, where A is the procedure defined above:

(define (f n) (A 0 n))
; This can easily be seen to be (* 2 n), as read directly in the definition of (A x y)

(define (g n) (A 1 n))
; From the evaluation of (A 1 10) shown above, we can see that this is the same as 2^n, since the first
; argument (1) ends up acting like a x2 multiplier while the second argument is decremented in each iteration.

(define (h n) (A 2 n))
; Looking at the evaluation of (A 2 4) above, we can see that this is the same as 2^...^2 n-1 times.  This is because
; the y argument leads to y expansions of (A 1 n).  The last expansion always evaluates to (A 2 1), which is 2.
; Substiting 2 and n for x and y, this means we have n expansions of (A 1 y), with the last operand being (A 2 1), which is 2.
; Because (g n) = 2^n, this means that we are starting with 2, then for each successive call to A, we are raising 2 to the result.
; So it's result_n = 2^(result_n-1^...^2).  Which is the same as 2^2^...^2 n-1 times.

(define (k n) (* 5 n n))

; Give concise mathematical definitions for the functions computed by the procedures f, g, and h for positive integer values of n.
; For example, (k n) computes 5n^2.

; The answers have been given above in-line.