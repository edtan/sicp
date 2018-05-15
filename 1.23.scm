#lang sicp
(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))
(define (next test-divisor)
  (if (even? test-divisor)
      (+ test-divisor 1)
      (+ test-divisor 2)))
(define (divides? a b)
  (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) start-time))))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

; Note: The 'dummy' parameter was just used so that I could evaluate timed-prime-test in the definition of s-iter-odd.  It is unclear from SICP so far on how to "execute multiple statements" (i.e. evaluate multiple expressions) from a single expression.
(define (search-for-primes low high)
  ;Initial definition of the iterative step
  (define (s-iter-odd n dummy)
    (if (> n high)
         (newline)  ; end loop
         (s-iter-odd (+ n 2) (timed-prime-test n))))

  ; Kick off the search process with an odd number.
  (if (even? low)
      (s-iter-odd (+ low 1) 0)
      (s-iter-odd low 0)))

(search-for-primes 1000 1019)
;1009 *** 2   vs. 3  = 1.5
;1013 *** 2   vs. 3  = 1.5
;1019 *** 2   vs. 3  = 1.5
(search-for-primes 10000 10037)
;10007 *** 5   vs. 8  = 1.6
;10009 *** 5   vs. 8  = 1.6
;10037 *** 4   vs. 8  = 2
(search-for-primes 100000 100043)
;100003 *** 14   vs. 24  = 1.67
;100043 *** 15   vs. 23  = 1.53
(search-for-primes 1000000 1000037)
;1000003 *** 44   vs. 73  = 1.66
;1000033 *** 45   vs. 72  = 1.64
;1000037 *** 44   vs. 72  = 1.64

;We see about a 1.6x increase in speed, as opposed to a 2x increase.  This is likely due to the overhead of the 'next' function call - in particular, it now has to check if the number is even or odd.  So although we've decreased the number of calls to find-divisor by 2, each time find-divisor is called, it has an additional expression to evaluate.  This probably accounts for the discrepancy.