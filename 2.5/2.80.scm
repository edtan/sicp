#lang sicp
;Exercise 2.80.  Define a generic predicate =zero? that tests if its argument is zero, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.

;First install the type-specific procedures in the corresponding packages:

(define (install-scheme-number-package)
  ;...
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0))))
(define (install-rational-package)
  ;...
   (put '=zero? '(rational)
       (lambda (x) (= (numer x) 0))))
(define (install-complex-package)
  ;...
  (put '=zero? '(complex)
       (lambda (x) (= (magnitude x) 0))))

;Then define =zero? in our generic arithmetic package.
(define (=zero? x y) (apply-generic '=zero? x y))