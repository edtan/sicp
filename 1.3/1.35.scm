#lang sicp
;Exercise 1.35.  Show that the golden ratio phi (section 1.2.2) is a fixed point of the transformation x -> 1 + 1/x, and use this fact to compute by means of the fixed-point procedure.

;To show phi is a fixed point of the transformation, simply plug in the formula for phi into the function and simplify:

;1 + 1/phi
;= 1 + 1/(1 + sqrt(5))/2
;= 1 + 2/(1 + sqrt(5))
;= (3 + sqrt(5)) / (1 + sqrt(5)) * (1 - sqrt(5)) / (1 - sqrt(5))
;= (3 - 2*sqrt(5) - 5) / (1 - 5)
;= (-2 - 2*sqrt(5)) / -4
;= -2 * (1 + sqrt(5)) / -4
;= (1 + sqrt(5)) / 2
;= phi

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(fixed-point (lambda (x) (+ 1 (/ 1 x)))
             1.0)


