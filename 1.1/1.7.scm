#lang racket
;Exercise 1.7.  The good-enough? test used in computing square roots will not be very effective for finding the square roots
;of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision.
;This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails
;for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one
;iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure
;that uses this kind of end test. Does this work better for small and large numbers?


(define (sqrt-iter guess x)
  ;(display guess) (newline)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (square x) (* x x))

; As numbers get smaller, their square roots also get smaller.  Since we've hard-coded the good-enough? test
; to 0.001, the test will fail once we start looking at numbers whose square roots are much smaller than 0.001.

; The following example shows that it fails for finding the square rooot of 0.0001 which should be 0.001.
;(sqrt-iter 1.0 0.0001)  ; returns 0.03230844833048122

; Since there is limited precision to represent numbers in computers, this causes issues when the current algorithm
; is used for very large numbers.  For very large numbers, we start to lose precision - larger numbers that can be
; represented become more "spread out".  E.g. instead of being able to represent up to 3 decimal places, only integers
; might only be able to be represented.  Because of this, the good-enough? check might always fail for larger numbers
; leading to an infinit loop.

; The following example shows an example of an infinite loop.
;(sqrt-iter 1.0 65535868928114687942656017919996416000447999968000001)  ; Expected answer: 255999744000095999984000001


; The following modifies the algorithm to check for percentage changes in the guess.
(define (good-enough2? improvement original)
  (< (/ (abs (- original improvement)) original) 0.001))

(define (sqrt-iter2 guess x)
  (define improved-guess (improve guess x))
  (display improved-guess) (newline)
  (if (good-enough2? improved-guess guess)
      improved-guess
      (sqrt-iter2 improved-guess
                 x)))
; The algorithm now performs better for small and large numbers, and also still works for the "moderately" sized 2.
(sqrt-iter2 1.0 2)
(sqrt-iter2 1.0 0.0001)
(sqrt-iter2 1.0 65535868928114687942656017919996416000447999968000001)