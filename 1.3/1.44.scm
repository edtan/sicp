#lang sicp
;Exercise 1.44.  The idea of smoothing a function is an important concept in signal processing. If f is a function and dx is some small number, then the smoothed version of f is the function whose value at a point x is the average of f(x - dx), f(x), and f(x + dx). Write a procedure smooth that takes as input a procedure that computes f and returns a procedure that computes the smoothed f. It is sometimes valuable to repeatedly smooth a function (that is, smooth the smoothed function, and so on) to obtained the n-fold smoothed function. Show how to generate the n-fold smoothed function of any given function using smooth and repeated from exercise 1.43.
(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
  (if (= n 1)
      (lambda (x) (f x))
      (compose f (repeated f (- n 1)))))

(define (average x y z) (/ (+ x y z) 3.0))
(define dx 0.00001)
(define (smooth f)
  (lambda (x) (f (average (- x dx)
                          x
                          (+ x dx)))))

(define (n-fold-smooth f n)
  (repeated smooth n) f)

(define (cube x) (* x x x))

((n-fold-smooth cube 2) 2) ;8, which makes sense, because x^3 is already smooth