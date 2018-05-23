#lang sicp
;Exercise 2.79.  Define a generic equality predicate equ? that tests the equality of two numbers, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

;First install the type-specific procedures in the corresponding packages:

(define (install-scheme-number-package)
  ;...
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y))))
(define (install-rational-package)
  ;...
   (put 'equ? '(rational rational)
       (lambda (x y) (= (* (numer x) (denom y))
                        (* (denom x) (number y))))))
(define (install-complex-package)
  ;...
  (put 'equ? '(complex complex)
       (lambda (x y) (and (= (real-part x) (real-part y))
                          (= (imag-part x) (imag-part y))))))

;Then define equ? in our generic arithmetic package.
(define (equ? x y) (apply-generic 'equ? x y))