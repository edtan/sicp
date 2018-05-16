#lang sicp
;Exercise 1.27.  Demonstrate that the Carmichael numbers listed in footnote 47 really do fool the Fermat test. That is, write a procedure that takes an integer n and tests whether a^n is congruent to a modulo n for every a<n, and try your procedure on the given Carmichael numbers.

(define (square x) (* x x))
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))        
(define (fermat-test a n)
  (= (expmod a n n) a))
(define (check-carmichael? n)
  (c-iter 1 n))
(define (c-iter a n)
  (cond ((> a (- n 1)) (display "Fooled the Fermat test"))
        ((fermat-test a n) (c-iter (+ a 1) n))
        (else (display "Didn't fool the Fermat test"))))

(check-carmichael? 561)
(check-carmichael? 1105)
(check-carmichael? 1729)
(check-carmichael? 2465)
(check-carmichael? 2821)
(check-carmichael? 6601)

; check some non-primes
(check-carmichael? 255)
(check-carmichael? 16)