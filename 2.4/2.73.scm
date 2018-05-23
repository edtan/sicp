#lang sicp
;Exercise 2.73.  Section 2.3.2 described a program that performs symbolic differentiation:

;(define (deriv exp var)
;  (cond ((number? exp) 0)
;        ((variable? exp) (if (same-variable? exp var) 1 0))
;        ((sum? exp)
;         (make-sum (deriv (addend exp) var)
;                   (deriv (augend exp) var)))
;        ((product? exp)
;         (make-sum
;           (make-product (multiplier exp)
;                         (deriv (multiplicand exp) var))
;           (make-product (deriv (multiplier exp) var)
;                         (multiplicand exp))))
;        <more rules can be added here>
;        (else (error "unknown expression type -- DERIV" exp))))

;We can regard this program as performing a dispatch on the type of the expression to be differentiated. In this situation the ``type tag'' of the datum is the algebraic operator symbol (such as +) and the operation being performed is deriv. We can transform this program into data-directed style by rewriting the basic derivative procedure as

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         (else ((get 'deriv (operator exp)) (operands exp)
                                            var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;a.  Explain what was done above. Why can't we assimilate the predicates number? and same-variable? into the data-directed dispatch?

;b.  Write the procedures for derivatives of sums and products, and the auxiliary code required to install them in the table used by the program above.

;c.  Choose any additional differentiation rule that you like, such as the one for exponents (exercise 2.56), and install it in this data-directed system.

;d.  In this simple algebraic manipulator the type of an expression is the algebraic operator that binds it together. Suppose, however, we indexed the procedures in the opposite way, so that the dispatch line in deriv looked like

;((get (operator exp) 'deriv) (operands exp) var)

;What corresponding changes to the derivative system are required?


;a.  The program above assumes the expression is in prefix notation with the operator being the first element in the list.  Therefore, it uses the operator as the 'tag type' for the expression.
;We can't assimilate the predicates number? and same-variable? because these are basically the 'base' cases that the evaluations terminate at.  For example, when we evaluate (deriv 3), we don't expect to have to label every 3 with a 'number symbol; otherwise it would lead to expressions like (deriv 'number 3), and (deriv 'variable x) which would not be very useful.

;b and c.
; TODO: this is untested, and very likely to have some bug in it.  will be tested after exercise 3.24 is completed.
(define (install-deriv-package)
  (define (=number? exp num)
    (and (number? exp) (= exp num)))
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
          ((=number? a2 0) a1)
          ((and (number? a1) (number? a2))
           (+ a1 a2))
          (else (list '+ a1 a2))))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0)
               (=number? m2 0))
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2))
           (* m1 m2))
          (else (list '* m1 m2))))
  (define (make-exponentiation base exp)
    (cond ((=number? exp 0) 1)
          ((=number? exp 1) base)
          (else (list '** base exp))))
  (define (addend operands) (car s))     ; removed 1 d
  (define (augend operands) (cadr s))    ; removed 1 d
  (define (multiplier operands) (car p))        ; removed 1 d
  (define (multiplicand operands) (cadr p))     ; removed 1 d

  (define (exponentiation? x) (and (pair? x) (eq? (car x) '**)))
  (define (base operands) (car exp))         ; removed 1 d
  (define (exponent operands) (cadr exp))    ; removed 1 d
  
  (put 'deriv '+
       (lambda (operands var)
         ((make-sum (deriv (addend operands) var)
                    (deriv (augend operands) var)))))
  (put 'deriv '*
       (lambda (operands var)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand operands) var))
           (make-product (deriv (multiplier operands) var)
                         (multiplicand exp)))))
  (put 'deriv '**
       (lambda (operands var)
         (make-product
          (exponent operands)
          (make-exponentiation (base operands)
                               (make-sum (exponent operands) -1))))))

;d
; We would simply need to change the order of the first two arguments to each put in the install procedure.  e.g.
;(put '+ 'deriv ...
;(put '* 'deriv ...
;(put '** 'deriv ...
         