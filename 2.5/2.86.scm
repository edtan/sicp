#lang sicp
;Exercise 2.85.  This section mentioned a method for ``simplifying'' a data object by lowering it in the tower of types as far as possible. Design a procedure drop that accomplishes this for the tower described in exercise 2.83. The key is to decide, in some general way, whether an object can be lowered. For example, the complex number 1.5 + 0i can be lowered as far as real, the complex number 1 + 0i can be lowered as far as integer, and the complex number 2 + 3i cannot be lowered at all. Here is a plan for determining whether an object can be lowered: Begin by defining a generic operation project that ``pushes'' an object down in the tower. For example, projecting a complex number would involve throwing away the imaginary part. Then a number can be dropped if, when we project it and raise the result back to the type we started with, we end up with something equal to what we started with. Show how to implement this idea in detail, by writing a drop procedure that drops an object as far as possible. You will need to design the various projection operations (A real number can be projected to an integer using the round primitive, which returns the closest integer to its argument.) and install project as a generic operation in the system. You will also need to make use of a generic equality predicate, such as described in exercise 2.79. Finally, use drop to rewrite apply-generic from exercise 2.84 so that it ``simplifies'' its answers.

(define (install-rational-package)
  ;...
   (put 'project '(rational)
       (lambda (n) (make-integer (round (/ (numer n) (denom n)))))))
(define (install-real-package)
  ;...
  (put 'project '(real)
       (lambda (x) (make-rational x 1))))
(define (install-complex-package)
  ;...
  (put 'project '(complex)
       (lambda (x) (make-real (real-part x)))))

(define (project x) (apply-generic 'project x))

; projects x as far as possible
(define (drop x)
  (if (not (get 'project (type-tag x)))
      x ; was an integer (at the lowest part of the hierarchy
      (let (projected-raised-x (apply-generic 'raise (apply-generic 'project x)))
        (if (equ? x projected-raised-x)
            (drop projected-raised-x)
            x))))

