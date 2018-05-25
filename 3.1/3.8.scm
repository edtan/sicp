#lang sicp
;Exercise 3.8.  When we defined the evaluation model in section 1.1.3, we said that the first step in evaluating an expression is to evaluate its subexpressions. But we never specified the order in which the subexpressions should be evaluated (e.g., left to right or right to left). When we introduce assignment, the order in which the arguments to a procedure are evaluated can make a difference to the result. Define a simple procedure f such that evaluating (+ (f 0) (f 1)) will return 0 if the arguments to + are evaluated from left to right but will return 1 if the arguments are evaluated from right to left.

;initial state is 1, and use multiplication

(define f
  (let ((state 1))
    (lambda (x)
      (set! state (* x state))
      state)))

;If we run these two statements, simulating a run from left to right, we get:
;(f 0)
;0
;(f 1)
;0
; so the sum is 0.

;If we run the two statements in the other order first, simulating evaluation from right to left:
;(f 1)
;1
;(f 0)
;0
;the sum is 1.