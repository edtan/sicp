#lang sicp
;Exercise 1.46.  Several of the numerical methods described in this chapter are instances of an extremely general computational strategy known as iterative improvement. Iterative improvement says that, to compute something, we start with an initial guess for the answer, test if the guess is good enough, and otherwise improve the guess and continue the process using the improved guess as the new guess. Write a procedure iterative-improve that takes two procedures as arguments: a method for telling whether a guess is good enough and a method for improving a guess. Iterative-improve should return as its value a procedure that takes a guess as argument and keeps improving the guess until it is good enough. Rewrite the sqrt procedure of section 1.1.7 and the fixed-point procedure of section 1.3.3 in terms of iterative-improve.

; This problem was quite tricky for me.  It took me some time to realize that the 'trick' behind this problem was to return a recursive procedure.  Also, determining the correct parameters to good-enough? and realizing the definition of sqrt-improve needed to be bound to an outer variable took some time.

; good-enough? takes two parameters - the improved guess, and the previous guess
; improve takes one parameter - the guess to improve
(define (iterative-improve good-enough? improve-guess)
  (lambda (x)
    (define (iter good-enough? improve-guess guess)
      (let ((next (improve-guess guess)))
        (if (good-enough? next guess)
            next
            (iter good-enough? improve-guess next))))
    (iter good-enough? improve-guess x)))

; re-implementing sqrt of 1.1.7
(define (square x) (* x x))
(define (average x y)
  (/ (+ x y) 2.0))

(define (sqrt x)
  ; in sqrt-good-enough, we set the previous guess parameter to a dummy variable, as we want to compare the current guess to x (bound to (sqrt x) above)
  (define (sqrt-good-enough? guess dummy) 
    (< (abs (- (square guess) x)) 0.001))
  (define (sqrt-improve guess)
    (average guess (/ x guess)))
  ((iterative-improve sqrt-good-enough? sqrt-improve) x))
(sqrt 2)

; re-implementing fixed-point of 1.3.3
(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (improve-guess x) (f x))
  ((iterative-improve close-enough? improve-guess) first-guess))

(define (sqrt-fixed-pt x)
  (fixed-point (lambda (y) (average y (/ x y))) 1.0))
(sqrt-fixed-pt 2)
