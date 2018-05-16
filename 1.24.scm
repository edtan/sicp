#lang sicp
;Exercise 1.24.  Modify the timed-prime-test procedure of exercise 1.22 to use fast-prime? (the Fermat method), and test each of the 12 primes you found in that exercise. Since the Fermat test has (log n) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? Do your data bear this out? Can you explain any discrepancy you find?

(define (square x) (* x x))
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))        
(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))
(define (start-prime-test n start-time)
  (if (fast-prime? n 1000)
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
;1009 *** 1323
;1013 *** 1362
;1019 *** 1402
(search-for-primes 10000 10037)
;10007 *** 1766
;10009 *** 1677
;10037 *** 1794
(search-for-primes 100000 100043)
;100003 *** 1936
;100019 *** 2082
;100043 *** 1992
(search-for-primes 1000000 1000037)
;1000003 *** 2206
;1000033 *** 2230
;1000037 *** 2418

;As the Fermat test grows as O(log n), we should expect testing primes near 1000000 would take approximately log_2(1000000) /log_2(1000) = 2 times as long as testing primes near 1000.  (The base of 2 was chosen because expmod using squaring, but any base would return the same computation.)  The observed results above agree with the predicted increase in runtime.