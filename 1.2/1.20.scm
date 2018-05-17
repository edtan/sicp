#lang racket
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
;Exercise 1.20.  The process that a procedure generates is of course dependent on the rules used by the interpreter. As an example, consider the iterative gcd procedure given above. Suppose we were to interpret this procedure using normal-order evaluation, as discussed in section 1.1.5. (The normal-order-evaluation rule for if is described in exercise 1.5.) Using the substitution method (for normal order), illustrate the process generated in evaluating (gcd 206 40) and indicate the remainder operations that are actually performed. How many remainder operations are actually performed in the normal-order evaluation of (gcd 206 40)? In the applicative-order evaluation?

;normal-order evaluation (only evaluate operands when needed - i.e. at the very end)
(gcd 206 40)
(if (= 40 0) ...
(gcd 40 (remainder 206 40))
(if (= (remainder 206 40) 0)...  ; +1
    (= 6 0)
(gcd (remainder 206 40)
     (remainder 40 (remainder 206 40)))  
(if (= (remainder 40 (remainder 206 40)) 0)...  ; +2
    (= (remainder 40 6) 0)
    (= 4 0)
(gcd (remainder 40 (remainder 206 40))
     (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))
(if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0)...  ; +4
    (= (remainder 6 (remainder 40 6)) 0)
    (= (remainder 6 4) 0)
    (= 2 0)
(gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))
     (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))
(if (= (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 0)...  ; +7
    (= (remainder (remainder 40 6) (remainder 6 (remainder 40 6))) 0)
    (= (remainder 4 (remainder 6 4)) 0)
    (= (remainder 4 2) 0)
    true! so finally evaluate a:
(remainder (remainder 206 40) (remainder 40 (remainder 206 40)))   ; +4
(remainder 6 (remainder 40 6))
(remainder 6 4)
2
; Adding all the calls as shown above, there are 18 calls to remainder in normal-order evaluation.
 
;applicative-order evaluation (first evaluate operands before complex operators)
(gcd 206 40)
(gcd 40 (remainder 206 40))
(gcd 40 6)
(gcd 6 (remainder 40 6))
(gcd 6 4)
(gcd 4 (remainder 6 4))
(gcd 4 2)
(gcd 2 (remainder 4 2))
(gcd 2 0)
; There are 4 calls to remainder in applicative-order evaluation