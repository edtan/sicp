#lang sicp
;Exercise 2.58.  Suppose we want to modify the differentiation program so that it works with ordinary mathematical notation, in which + and * are infix rather than prefix operators. Since the differentiation program is defined in terms of abstract data, we can modify it to work with different representations of expressions solely by changing the predicates, selectors, and constructors that define the representation of the algebraic expressions on which the differentiator is to operate.

;a. Show how to do this in order to differentiate algebraic expressions presented in infix form, such as (x + (3 * (x + (y + 2)))). To simplify the task, assume that + and * always take two arguments and that expressions are fully parenthesized.

;b. The problem becomes substantially harder if we allow standard algebraic notation, such as (x + 3 * (x + y + 2)), which drops unnecessary parentheses and assumes that multiplication is done before addition. Can you design appropriate predicates, selectors, and constructors for this notation such that our derivative program still works?

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
         (error "unknown expression type -- DERIV" exp))))

(define (=number? exp num)
  (and (number? exp) (= exp num)))
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;part a
;(define (make-sum a1 a2)
;  (cond ((=number? a1 0) a2)
;        ((=number? a2 0) a1)
;        ((and (number? a1) (number? a2)) (+ a1 a2))
;        (else (list a1 '+ a2))))       ; change position of '+
;(define (make-product m1 m2)
;  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
;        ((=number? m1 1) m2)
;        ((=number? m2 1) m1)
;        ((and (number? m1) (number? m2)) (* m1 m2))
;        (else (list m1 '* m2))))       ; change position of '*
;(define (sum? x)
;  (and (pair? x) (eq? (cadr x) '+)))   ; change from car to cadr
;(define (addend s) (car s))            ; change from cadr to car
;(define (augend s) (caddr s))          ; augend remains the same (it's already in the same position)
;(define (product? x)
;  (and (pair? x) (eq? (cadr x) '*)))   ; change from car to cadr
;(define (multiplier p) (car p))        ; change from cadr to car
;(define (multiplicand p) (caddr p))    ; multiplicand remains the same (it's already in the same position)

;(deriv '(x + (3 * (x + (y + 2)))) 'x)
;4


; part b
; This one took a whole afternoon, but was very cool.

; we need to have the predicates, selectors, and constructors handle the correct order of operations to handle this.
; the correct order of operations is:
; 1: evaluate all parentheses first
; 2: apply multiplications
; 3: apply additions
; we also need to handle the lack of parentheses (i.e. don't just stop at the second operand)

; in order to apply the correct order of operations, a simplify procedure was created that would try to simplify a given expression.  This would be the basis of the correct order of operations.  simplify calls make-sum and make-product, which both in turn call back simplify.  This was the main trick behind this problem.

; For addition, the trick was to see if a '+ was found in the expression.  If so, the addend was everything before the first '+, and the augend was everything afterwards.  However, this caused a small issue, where everything returned was a list, including single arguments.  For example, the addend and augend are (1) and (2) for '(1 + 2).  Because we can't change deriv to handle this, I modified the multiplicand selector and multiplier predicate to handle this.

; For multiplication, the selectors and predicate were changed to only consider consecutive multiplications as a product.  Therefore, expressions like '(1 + 2 * x) are not products, but expressions like '(1 * 2 * x) are products.  The multiplier is defined as the first operand (car exp), and the multiplicand is everything after the first '*.  Also, to handle the bug from addition mentioned above, if there is a list of length 1, we consider it a product, with a multiplicand of 1.


(define (simplify exp)
  (cond ((number? exp) exp)
        ((variable? exp) exp)
        ((= (length exp) 1) (car exp))
        ((product? exp) (make-product (multiplier exp) (multiplicand exp)))
        ((sum? exp) (make-sum (addend exp) (augend exp)))
        (else (error "unable to simplify " exp))))
  
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list (simplify a1) '+ (simplify a2)))))
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list (simplify m1) '* (simplify m2)))))

; sum? checks the list for a presence of '+.  if its found, the addend is everything before it in parentheses, and the augend is everything after in in parentheses
(define (sum? x) (not (eq? (memq '+ x) false)))
(define (addend s)
  (cond ((or (eq? (car s) '+) (null? s)) '())
        (else (cons (car s) (addend (cdr s))))))
  
(define (augend s) (cdr (memq '+ s)))

(define (product? x)
  ;(display x)
  ;(newline)
  (if (= (length x) 1)
      true
      (and (pair? x) (eq? (cadr x) '*)
       (cond ((null? (cdddr x)) true)
             (else (product? (cddr x)))))))    ; all remaining operations are products

(define (multiplier p) (car p))
(define (multiplicand p)
  (cond ((= (length p) 1) 1)
        ((null? (cdddr p)) (caddr p))   ; last term
        (else (cddr p))))   ; all remaining products

(deriv '(x + 3) 'x)
;1

(deriv '(x + 3 * (x + y + 2)) 'x)
;4

(deriv '((x * 4 + x * 2) + (x * 3)) 'x)
;9

(deriv '(x + 2 * x + 4 * x) 'x)
;7

(display (deriv '(3 * x * y + 4 + x + 9 * x * z) 'x))
;((3 * y) + (1 + (9 * z)))