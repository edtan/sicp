#lang sicp
;Exercise 1.38.  In 1737, the Swiss mathematician Leonhard Euler published a memoir De Fractionibus Continuis, which included a continued fraction expansion for e - 2, where e is the base of the natural logarithms. In this fraction, the Ni are all 1, and the Di are successively 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, .... Write a program that uses your cont-frac procedure from exercise 1.37 to approximate e, based on Euler's expansion.

(define (cont-frac n d k)
  (define (add-ith-term i)
    (if (= i k)
      (/ (n k) (d k))
      (/ (n i) (+ (d i) (add-ith-term (inc i))))))
  (add-ith-term 1))

; note that the Dis that aren't 1 have indices of 3n + 2, where n is an integer.  We use this fact to find a formula for those terms, and set everything else to 1.  (D1 and D2 are hardcoded to 1 and 2)
(define (e-minus-2)
  (define (n i) 1.0)
  (define (d i)
    (cond ((= i 1) 1)
          ((= i 2) 2)
          ((= (remainder (- i 2) 3) 0)
           (- i (/ (- i 2) 3)))
          (else 1)))
  (cont-frac n d 12))

(+ (e-minus-2) 2)
;2.7182818229439496