#lang sicp
;Exercise 1.41.  Define a procedure double that takes a procedure of one argument as argument and returns a procedure that applies the original procedure twice. For example, if inc is a procedure that adds 1 to its argument, then (double inc) should be a procedure that adds 2. What value is returned by
;(((double (double double)) inc) 5)

(define (double f)
  (lambda (x) (f (f x))))

((double inc) 5) ; 7

(((double (double double)) inc) 5)
; This one took a while.  This natually looks like the result should be 13, because the first double double would be an increase in 4, and the last double would run this a second time, resulting in a total increase of 8.
; However, Scheme evaluated this to be 21!  To understand this, let's first expand (double (double double)) and see what happens.

;(double (double double))
;(lambda (x) ((double double) ((double double) x)))
; The inner (double double) would run x 4 times, and the outer (double double) would run the inner thing 4 times.  Therefore, the function would be applied 16 times!  This matches the observed results above:  5 + 16 = 21

;Let's see if this matches 4 doubles.  By the same reasoning above, the inner double would run 16 times, and the outer double would run 16 times, for a total of 256 runs:
(((double (double (double double))) inc) 5)
; 5 + 256 = 261, which matches the observed results!