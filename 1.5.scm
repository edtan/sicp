#lang racket
;Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

;Then he evaluates the expression

(test 0 (p))

;What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

; If using applicative-order evaluation, the interpreter will run an infinite loop, because it first evaluates all
; subexpressions before applying the operator to the operands.  Thus, it would try to evaluate (p) first, and continue
; to do so indefinitely.

; If the interpreter uses normal-order evaluation, it would return 0.  Due to normal-order evaluation,
; the operands aren't evaluated at the beginning, and instead are substitued into the compound procedure:
; (if (= 0 0) 0 (p)).  The if primitive procedure is then evaluated, and because the predicate is true, 0
; is returned.

; When executing the test method in DrRacket, an infinite loop occurred, suggesting that the interpreter
; follows applicative-order evaluation for this expression.  (Which is what the text had said in the chapter.)