#lang sicp
;Exercise 2.48.  A directed line segment in the plane can be represented as a pair of vectors -- the vector running from the origin to the start-point of the segment, and the vector running from the origin to the end-point of the segment. Use your vector representation from exercise 2.46 to define a representation for segments with a constructor make-segment and selectors start-segment and end-segment.

(define (make-vect x y) (cons x y))
(define (xcor-vect vect) (car vect))
(define (ycor-vect vect) (cdr vect))

(define (make-point x y) (cons x y))
(define (x-point pt) (car pt))
(define (y-point pt) (cdr pt))

; makes a segment internally represented by vectors
(define (make-segment start-pt end-pt)
  (cons (make-vect (x-point start-pt)
                   (y-point start-pt))
        (make-vect (x-point end-pt)
                   (y-point end-pt))))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

(make-segment (make-point 1 1) (make-point 2 5))
;(mcons (mcons 1 1) (mcons 2 5))
(start-segment (make-segment (make-point 1 1) (make-point 2 5)))
;(mcons 1 1)
(end-segment (make-segment (make-point 1 1) (make-point 2 5)))
;(mcons 2 5)