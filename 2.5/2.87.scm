#lang sicp
;Exercise 2.87.  Install =zero? for polynomials in the generic arithmetic package. This will allow adjoin-term to work for polynomials with coefficients that are themselves polynomials.

(define (install-polynomial-package)
  (define (=zero-poly? p)
    (let ((terms (term-list p)))
      (cond ((empty-termlist? terms) true)
            (else (and (=zero? (coeff (first-term terms)))  ; calls generic =zero? procedure
                       (=zero-poly? (make-polynomial (variable p) (rest-terms terms))))))))   ; we could have used =zero? instead of =zero-poly?, but this saves a table lookup
  (put '=zero? '(polynomial) =zero-poly?))