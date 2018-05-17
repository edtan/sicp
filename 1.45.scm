#lang sicp
;Exercise 1.45.  We saw in section 1.3.3 that attempting to compute square roots by naively finding a fixed point of y -> x/y does not converge, and that this can be fixed by average damping. The same method works for finding cube roots as fixed points of the average-damped y -> x/y2. Unfortunately, the process does not work for fourth roots -- a single average damp is not enough to make a fixed-point search for y -> x/y3 converge. On the other hand, if we average damp twice (i.e., use the average damp of the average damp of y -> x/y3) the fixed-point search does converge. Do some experiments to determine how many average damps are required to compute nth roots as a fixed-point search based upon repeated average damping of y -> x/yn-1. Use this to implement a simple procedure for computing nth roots using fixed-point, average-damp, and the repeated procedure of exercise 1.43. Assume that any arithmetic operations you need are available as primitives.

(define (average x y) (/ (+ x y) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
               1.0))

(define (square x) (* x x))
(define (cube-root x)
  (fixed-point (average-damp (lambda (y) (/ x (square y))))
               1.0))


(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
  (if (= n 1)
      (lambda (x) (f x))
      (compose f (repeated f (- n 1)))))

; a to the power of n (note that we are not using the fast-expt from before)
(define (pow a n)
  ((repeated (lambda (x) (* x a)) n) 1))

; num-damps was written after analyzing experimental results.  see below for more info.
(define (num-damps n)
  (define (check-bin k)
    (if (< n (pow 2 (+ k 1)))  ; since we're starting from k=1, we don't need to check for n > 2^k
        k
        (check-bin (+ k 1))))
  (check-bin 1))

(define (nth-root x n)
  (fixed-point ((repeated average-damp (num-damps n)) (lambda (y) (/ x (pow y (- n 1)))))
               1.0))
(nth-root 256 8)
(nth-root 64000 16)
(nth-root 64000 32)

; I manually adjusted the average-damp parameter above (manually determined (num-damps n)) and came up with the following experimental results.  The left column indicates n (for the nth root), and the right column indicates the number of average damps required for the procedure to finish.
;2 1
;3 1
;4 2
;5 2
;6 2
;7 2
;8 3
;9 3
;10 3
;11 3
;12 3
;13 3
;14 3
;15 3
;16 4
;The pattern that emerges is that the number of average damps needed increases by 1 at each power of 2.  We can think of the number on the right (i.e. the number of average damps required) to be the 'bin' number of powers of two.  bin #1 would contain numbers between 2^1 and 2^2, bin #2 between 2^2 and 2^3, and bin #k between 2^k and 2^(k+1).  For example, 2 and 3 belong to bin 1, 4 through 7 belong to bin 2, and so on.
; Therefore, this is how num-damps was designed.
