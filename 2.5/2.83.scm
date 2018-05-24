#lang sicp
;Exercise 2.83.  Suppose you are designing a generic arithmetic system for dealing with the tower of types shown in figure 2.25: integer, rational, real, complex. For each type (except complex), design a procedure that raises objects of that type one level in the tower. Show how to install a generic raise operation that will work for each type (except complex).

(define (install-integer-package)
  ;...
  (put 'raise '(integer)
       (lambda (n) (make-rational n 1))))
(define (install-rational-package)
  ;...
   (put 'raise '(rational)
       (lambda (n) ((div (make-real (numer n))
                         (make-real (denom n)))))))
(define (install-real-package)
  ;...
  (put 'raise '(real)
       (lambda (x) (make-complex-from-real-imag x 0))))

(define (raise x) (apply-generic 'raise x))
