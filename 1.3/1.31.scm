#lang sicp
;Exercise 1.31.   
;a.  The sum procedure is only the simplest of a vast number of similar abstractions that can be captured as higher-order procedures. Write an analogous procedure called product that returns the product of the values of a function at points over a given range. Show how to define factorial in terms of product. Also use product to compute approximations to pi using the formula

;pi/4 = 2/3 * 4/3 * 4/5 * 6/5 * 6/7 * 8/7 * ...


;b.  If your product procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

; a: recurive product definition
(define (product-recursive term a next b)
  (if (> a b)
      1
      (* (term a)
         (product-recursive term (next a) next b))))

(define (identity x) x)

; factorial in terms of product-recursive
(define (factorial n)
  (product-recursive identity 1 inc n))
(factorial 5)
(factorial 10)

; approximation to pi using product
(define (pi-by-4)
  (define (term n)
    (if (odd? n)
        (/ (+ n 1) (+ n 2))
        (/ (+ n 2) (+ n 1.0))))
  (product-recursive term 1 inc 10000))

(define pi (* 4 (pi-by-4)))
(display pi)
(newline)

; b: iterative product definition
(define (product-iter term a next b)
  (define (iter a product)
    (if (> a b)
        product
        (iter (next a) (* (term a) product))))
  (iter a 1))
(product-iter identity 1 inc 5)
(product-iter identity 1 inc 10)