#lang racket
;Exercise 1.18.  Using the results of exercises 1.16 and 1.17, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps.

; The main idea is that a*b = (2a - 1)*(b/2) + (b/2)

(define (double x) (+ x x))
(define (halve x) (/ x 2))

(define (mult a b)
  (mult-iter a b 0))
(define (mult-iter a b sum)
  (cond ((= b 1) (+ a sum))
        ((even? b) (mult-iter (- (double a) 1) (halve b) (+ (halve b) sum)))
        (else (mult-iter a (- b 1) (+ a sum)))))

(mult 2 10)
(mult 3 6)
(mult 5 8)
(mult 9 7)