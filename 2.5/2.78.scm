#lang sicp
;Exercise 2.78.  The internal procedures in the scheme-number package are essentially nothing more than calls to the primitive procedures +, -, etc. It was not possible to use the primitives of the language directly because our type-tag system requires that each data object have a type attached to it. In fact, however, all Lisp implementations do have a type system, which they use internally. Primitive predicates such as symbol? and number? determine whether data objects have particular types. Modify the definitions of type-tag, contents, and attach-tag from section 2.4.2 so that our generic system takes advantage of Scheme's internal type system. That is to say, the system should work as before except that ordinary numbers should be represented simply as Scheme numbers rather than as pairs whose car is the symbol scheme-number.

(define (attach-tag type-tag contents)
  (cond ((eq? type-tag 'scheme-number) contents)
        (else (cons type-tag contents))))
(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum -- TYPE-TAG" datum))))
(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (cdr datum))
        (error "Bad tagged datum -- CONTENTS" datum)))

;The following shows the output of a 'scheme-number represented directly as a primitive Scheme number still exhibits the behavior of a 'scheme-number.  Therefore, the generic system should work as before.

(attach-tag 'complex-number 5)
;(mcons 'complex-number 5)
(attach-tag 'scheme-number 5)
;5

(type-tag (attach-tag 'complex-number 5))
;'complex-number
(type-tag 5)
;'scheme-number

(contents (attach-tag 'complex-number 5))
;5
(contents 5)
;5

