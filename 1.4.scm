#lang racket
;Exercise 1.4.  Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; This takes a and adds the absolute value of b to it.
; If b is positive, the operator evaluates to "+", but if
; b is negative, the operator evaluates to "-".