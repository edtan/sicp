#lang sicp

;Exercise 2.5.  Show that we can represent pairs of nonnegative integers using only numbers and arithmetic operations if we represent the pair a and b as the integer that is the product 2a 3b. Give the corresponding definitions of the procedures cons, car, and cdr.

;This is based on the fundamental theorem of arithemetic - each integer can be representation by a unique prime factorization.  We simply need to count the factors of 2 and 3 in the integer.  Using fast-expt from 1.16 for exponentation

(define (square x)
  (* x x))

(define (even? n)
  (= (remainder n 2) 0))

(define (fast-expt b n)
  (fast-expt-iter b n 1))

(define (fast-expt-iter b n a)
  (cond ((= n 0) a)
        ((not (even? n)) (fast-expt-iter b (- n 1) (* b a)))
        (else (fast-expt-iter (square b) (- (/ n 2) 1) (* (square b) a)))))


(define (cons a b) (* (fast-expt 2 a) (fast-expt 3 b)))
(cons 1 2)
;18 = 2^1 * 3^2

; given a positive integer n, this will count the number of times prime factor p is contained in the integer
(define (count-factors n p)
  (define (count-iter n-prime result)   ; loop-invariant: n-prime * p^result = n
    (if (not (= (remainder n-prime p) 0))
        result
        (count-iter (/ n-prime p) (+ result 1))))
  (count-iter n 0))

(count-factors 18 2)
;1
(count-factors 18 3)
;2

(define (car z) (count-factors z 2))
(define (cdr z) (count-factors z 3))
(car (cons 3 7))
;3
(cdr (cons 3 7))
;7