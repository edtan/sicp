#lang sicp

;Exercise 1.33.  You can obtain an even more general version of accumulate (exercise 1.32) by introducing the notion of a filter on the terms to be combined. That is, combine only those terms derived from values in the range that satisfy a specified condition. The resulting filtered-accumulate abstraction takes the same arguments as accumulate, together with an additional predicate of one argument that specifies the filter. Write filtered-accumulate as a procedure. Show how to express the following using filtered-accumulate:

;a. the sum of the squares of the prime numbers in the interval a to b (assuming that you have a prime? predicate already written)

;b. the product of all the positive integers less than n that are relatively prime to n (i.e., all positive integers i < n such that GCD(i,n) = 1).

; definition for prime?
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

; definition for GCD
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

; filtered-accumulate definition
(define (filtered-accumulate combiner filter null-value term a next b)
  (if (> a b)
      null-value
      (combiner (if (filter a)
                    (term a)
                    null-value)
                (filtered-accumulate combiner filter null-value term (next a) next b))))

; a: sum of primes

(define (identity x) x)
(define (sum-primes a b)
  (filtered-accumulate + prime? 0 identity a inc b))

(sum-primes 2 11)

; b: product of relatively prime numbers to n less than n

(define (product-rel-prime n)
  (define (rel-prime? x)
    (= (gcd n x) 1))
  (filtered-accumulate * rel-prime? 1 identity 1 inc n))

(product-rel-prime 10)
(product-rel-prime 11)