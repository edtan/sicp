#lang sicp
;Exercise 1.39.  A continued fraction representation of the tangent function was published in 1770 by the German mathematician J.H. Lambert:

;tan x = x / (1 - (x^2 / 3 - (x^2 / 5 - ...

;where x is in radians. Define a procedure (tan-cf x k) that computes an approximation to the tangent function based on Lambert's formula. K specifies the number of terms to compute, as in exercise 1.37.

(define (cont-frac n d k)
  (define (add-ith-term i)
    (if (= i k)
      (/ (n k) (d k))
      (/ (n i) (+ (d i) (add-ith-term (inc i))))))
  (add-ith-term 1))

(define (tan-cf x k)
  (define (square x) (* x x))
  (define (n i)
    (cond ((= i 1) x)
          (else (* -1 (square x)))))
  (define (d i) (- (* 2 i) 1.0))
  (cont-frac n d k))

(tan-cf 1 12) ; 1.557407724654902
(tan-cf 0.785 12) ; 0.9992039901050428  (0.785 = pi/4)
(tan-cf -0.785 12) ; -0.9992039901050428