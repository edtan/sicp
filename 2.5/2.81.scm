#lang sicp
;Exercise 2.81.  Louis Reasoner has noticed that apply-generic may try to coerce the arguments to each other's type even if they already have the same type. Therefore, he reasons, we need to put procedures in the coercion table to "coerce" arguments of each type to their own type. For example, in addition to the scheme-number->complex coercion shown above, he would do:

;(define (scheme-number->scheme-number n) n)
;(define (complex->complex z) z)
;(put-coercion 'scheme-number 'scheme-number
;              scheme-number->scheme-number)
;(put-coercion 'complex 'complex complex->complex)

;a. With Louis's coercion procedures installed, what happens if apply-generic is called with two arguments of type scheme-number or two arguments of type complex for an operation that is not found in the table for those types? For example, assume that we've defined a generic exponentiation operation:

;(define (exp x y) (apply-generic 'exp x y))

;and have put a procedure for exponentiation in the Scheme-number package but not in any other package:

;; following added to Scheme-number package
;(put 'exp '(scheme-number scheme-number)
;     (lambda (x y) (tag (expt x y)))) ; using primitive expt

;What happens if we call exp with two complex numbers as arguments?

;b. Is Louis correct that something had to be done about coercion with arguments of the same type, or does apply-generic work correctly as is?

;c. Modify apply-generic so that it doesn't try coercion if the two arguments have the same type.

;a.  It will result in an infinite loop.  First, apply-generic will try to look up the 'exp procedure for '(complex complex) argument types.  Because it can't find this in the table, it will then try to coerce the first argument into the type of the second argument.  It finds the complex->complex coercion procedure in the coercion table, coerces the first argument back to itself, which is still a complex number.  Then, it will call (apply-generic 'exp z1 z2) again, which is the same as the initial call.

;b.  apply-generic works correctly as is, but may lead to some strange stack/error traces as it is.  For example, in part a, if we ran the program without Louis's changes, apply-generic wouldn't find the 'exp procedure for '(complex complex), and then would search the coercion table for 'complex->complex.  It would then fail to find this coercion, and return an error, which is the intended behavior (i.e. that exp isn't defined for complex numbers yet).  However, if you were to look at the stack track, you would see that the failure happened during the lookup of a complex -> complex coercion procedure, instead of failing when trying to look up a definition for 'exp for '(complex complex) arguments, which could make debugging confusing.

;c.  
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (if (eq? type1 type2)      ; error right away if type1 = type2 - don't try to coerce
                    (error "No method for these types"
                                    (list op type-tags))
                    (let ((t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1)))
                      (cond (t1->t2
                             (apply-generic op (t1->t2 a1) a2))
                            (t2->t1
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for these types"
                                    (list op type-tags))))))
                (error "No method for these types"
                       (list op type-tags))))))))