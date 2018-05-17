#lang sicp

;Exercise 1.29.  Simpson's Rule is a more accurate method of numerical integration than the method illustrated above. Using Simpson's Rule, the integral of a function f between a and b is approximated as

;h/3 * [y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + 2y(n-2) + 4y(n-1) + yn]

;where h = (b - a)/n, for some even integer n, and yk = f(a + kh). (Increasing n increases the accuracy of the approximation.) Define a procedure that takes as arguments f, a, b, and n and returns the value of the integral, computed using Simpson's Rule. Use your procedure to integrate cube between 0 and 1 (with n = 100 and n = 1000), and compare the results to those of the integral procedure shown above.

(define (cube x) (* x x x))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

; The tricky part of this question was that it initially seemed like there was no way to specify the coefficients of the y_n terms in the sum, without changing the existing definition of sum.  So instead of modifying the definition of sum, I first split the sum up into different summations where the coefficients were constant.

(define (simpson f a b n)
  (define h (/ (- b a) n))
  (define (add-h x) (+ x h))
  (define (add-2h x) (+ x (* 2 h)))
  (* (/ h 3.0)
     (+ (f a) (f b)  ; add first and last term
        (* 2 (sum f (+ a h) add-h (- b h))) ; add all inner terms twice
        (* 2 (sum f (+ a h) add-2h (- b h))))))   ; add all inner odd terms twice

(display "Integral")
(newline)
(integral cube 0 1 0.01)
(integral cube 0 1 0.001)
(display "Simpson")
(newline)
(simpson cube 0 1 100)
(simpson cube 0 1 1000)

; After some more thought, there is a way to generalize the summation (i.e. to specify the coefficients).  Sum over k=0 to n, and make everything a function of k!  This looks a lot more like the actual summation math notation.
(define (simpson-general f a b n)
  (define h (/ (- b a) n))
  (define (yk k) (f (+ a (* k h))))
  (define (simpson-term k)
    (* (cond ((or (= k 0)
                  (= k n)) 1)
             ((even? k) 2)
             (else 4))
        (yk k)))
  (* (/ h 3.0) (sum simpson-term 0 inc n)))

(display "Simpson Generalized")
(newline)
(simpson-general cube 0 1 100)
(simpson-general cube 0 1 1000)