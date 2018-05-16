#lang sicp
;Exercise 1.23.  The smallest-divisor procedure shown at the start of this section does lots of needless testing: After it checks to see if the number is divisible by 2 there is no point in checking to see if it is divisible by any larger even numbers. This suggests that the values used for test-divisor should not be 2, 3, 4, 5, 6, ..., but rather 2, 3, 5, 7, 9, .... To implement this change, define a procedure next that returns 3 if its input is equal to 2 and otherwise returns its input plus 2. Modify the smallest-divisor procedure to use (next test-divisor) instead of (+ test-divisor 1). With timed-prime-test incorporating this modified version of smallest-divisor, run the test for each of the 12 primes found in exercise 1.22. Since this modification halves the number of test steps, you should expect it to run about twice as fast. Is this expectation confirmed? If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2?

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