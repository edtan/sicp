#lang sicp

;Exercise 2.12.  Define a constructor make-center-percent that takes a center and a percentage tolerance and produces the desired interval. You must also define a selector percent that produces the percentage tolerance for a given interval. The center selector is the same as the one shown above.

(define (make-interval a b) (cons a b))
(define (upper-bound interval) (cdr interval))
(define (lower-bound interval) (car interval))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))


(define (make-center-percent c p)
  (let ((tolerance (/ (* (/ p 100) c)
                           2.0)))
    (make-center-width c tolerance)))
(define (percent interval) (* (/ (* 2 (width interval)) (center interval)) 100.0))

(make-center-percent 50 10)
; 47.5 52.5
(percent (make-center-percent 50 10))
; 10.0
(width (make-center-percent 50 10))
; 2.5