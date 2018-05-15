#lang racket
 ;Exercise 1.11.  A function f is defined by the rule that f(n) = n if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n>= 3.
; Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process.

; Recursive process
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1)) (* 2 (f (- n 2))) (* 3 (f (- n 3))))))

; Iterative process
; The general rule we are trying to capture is:
; a' <- a + 2b + 3c
; b' <- a
; c' <- b
; Following the example in the text for the iterative process of Fibinacci's sequence, we have

(define (f2 n)
  (define (f-iter a b c count)
    (if (<= count 0)
        c
        (f-iter (+ a (* 2 b) (* 3 c)) a b (- count 1))))
  (f-iter 2 1 0 n))