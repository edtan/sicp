#lang sicp

(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

;Exercise 1.22.  Most Lisp implementations include a primitive called runtime that returns an integer that specifies the amount of time the system has been running (measured, for example, in microseconds). The following timed-prime-test procedure, when called with an integer n, prints n and checks to see if n is prime. If n is prime, the procedure prints three asterisks followed by the amount of time used in performing the test.

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

;Using this procedure, write a procedure search-for-primes that checks the primality of consecutive odd integers in a specified range. Use your procedure to find the three smallest primes larger than 1000; larger than 10,000; larger than 100,000; larger than 1,000,000. Note the time needed to test each prime. Since the testing algorithm has order of growth of O(sqrt(n)), you should expect that testing for primes around 10,000 should take about sqrt(10) times as long as testing for primes around 1000. Do your timing data bear this out? How well do the data for 100,000 and 1,000,000 support the sqrt(n) prediction? Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation?


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

;(search-for-primes 1000 10000)
; The 3 smallest prime results:
;1009 *** 3
;1013 *** 3
;1019 *** 3
;(search-for-primes 10000 11000)
;10007 *** 8
;10009 *** 8
;10037 *** 8
; 3 * sqrt(10) = 9.48.  This approximately matches the observed times.
;(search-for-primes 100000 110000)
;100003 *** 24
;100019 *** 25
;100043 *** 23
; 8 * sqrt(10) = 25.30, which approximately matches the observed times.
(search-for-primes 1000000 1001000)
;1000003 *** 73
;1000033 *** 72
;1000037 *** 72
; 24 * sqrt(10) = 75.89, which approximately matches the observed times.

; This does support the notion that the programs on this machine run in time proportional to the number of steps required for computation.
