#lang sicp
;Exercise 2.88.  Extend the polynomial system to include subtraction of polynomials. (Hint: You may find it helpful to define a generic negation operation.)

; The generic negate operation is simple, assuming that the raise procedure works properly for the types ranging between integer, rational, real, and complex.  We simply multiply the argument by -1, and because we are using the generic mul operation which has already been defined for all tag types, it should promote the integer to the correct type.  However, because we haven't defined a raise procedure for complex to polynomials, instead, we simply put a direct entry in the coercion table for 'scheme-number to 'polynomial.  Finally, we define polynomial subtraction in terms of addition.
(define (negative x) (mul -1 x))


(define (install-polynomial-package)
  (define (sub-poly p1 p2) (add-poly p1 (negative p2)))
  ;...
  (put-coercion 'scheme-number 'polynomial
       (lambda (n p) (mul (make-polynomial (variable p) (adjoin-term (make-term 1 n) the-empty-termlist))
                          p))))