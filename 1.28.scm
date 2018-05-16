#lang sicp
;Exercise 1.28.  One variant of the Fermat test that cannot be fooled is called the Miller-Rabin test (Miller 1976; Rabin 1980). This starts from an alternate form of Fermat's Little Theorem, which states that if n is a prime number and a is any positive integer less than n, then a raised to the (n - 1)st power is congruent to 1 modulo n. To test the primality of a number n by the Miller-Rabin test, we pick a random number a<n and raise a to the (n - 1)st power modulo n using the expmod procedure. However, whenever we perform the squaring step in expmod, we check to see if we have discovered a ``nontrivial square root of 1 modulo n,'' that is, a number not equal to 1 or n - 1 whose square is equal to 1 modulo n. It is possible to prove that if such a nontrivial square root of 1 exists, then n is not prime. It is also possible to prove that if n is an odd number that is not prime, then, for at least half the numbers a<n, computing an-1 in this way will reveal a nontrivial square root of 1 modulo n. (This is why the Miller-Rabin test cannot be fooled.) Modify the expmod procedure to signal if it discovers a nontrivial square root of 1, and use this to implement the Miller-Rabin test with a procedure analogous to fermat-test. Check your procedure by testing various known primes and non-primes. Hint: One convenient way to make expmod signal is to have it return 0.

; The first hard part was figuring out how to modify the expmod procedure to signal (i.e. return 0) for non-trivial square roots of 1 mod n.  This was because I'm used to being able to use a number of "statements" in a programming language, whereas in SICP so far, we've only been exposed to evaluating expressions and procedures.
; The second thing that took me a while to understand was justifying why it was ok to return 0 as a signal, with the main concern being, what if a^_(n-1) = 0 mod n for other other values of a?  This is simply because if that were true, then we would know that n wasn't prime anyways, and could return.

(define (square x) (* x x))
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (square-mod-n (expmod base (/ exp 2) m) m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                                       m))))

(define (square-mod-n a n)
  (if (and (not (= a 1)) (not (= a (- n 1))) (= (remainder (square a) n) 1))
      0
      (remainder (square a) n)))

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))
(define (fast-strong-prime? n times)  ; check half the numbers < n according to the theorem
  (cond ((< times 0) true)
        ((miller-rabin-test n) (fast-strong-prime? n (- times 1)))
        (else false)))
(define (check-prime? n)
  (fast-strong-prime? n (/ n 2)))

(display "Carmichael numbers")
(newline)
(check-prime? 561)
(check-prime? 1105)
(check-prime? 1729)
(check-prime? 2465)
(check-prime? 2821)
(check-prime? 6601)

(display "Non-prime numbers")
(newline)
(check-prime? 4)
(check-prime? 16)
(check-prime? 27)
(check-prime? 255)
(check-prime? 999996)

(display "Prime numbers")
(newline)
(check-prime? 2)
(check-prime? 13)
(check-prime? 17)
(check-prime? 1009)
(check-prime? 1013)
(check-prime? 100019)
(check-prime? 1000003)
