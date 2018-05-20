#lang sicp
;Exercise 2.46: A two-dimensional vector v running from the origin to a point can be represented as a pair consisting of an x-coordinate and a y-coordinate. Implement a data abstraction for vectors by giving a constructor make-vect and corresponding selectors xcor-vect and ycor-vect. In terms of your selectors and constructor, implement procedures add-vect, sub-vect, and scale-vect that perform the operations vector addition, vector subtraction, and multiplying a vector by a scalar:
;(x1,y1)+(x2,y2) = (x1+x2,y1+y2)
;(x1,y1)-(x2,y2) = (x1-x2,y1-y2)
;s⋅(x,y) = (sx,sy)

(define (make-vect x y) (cons x y))
(define (xcor-vect vect) (car vect))
(define (ycor-vect vect) (cdr vect))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect vect scale)
  (make-vect (* scale (xcor-vect vect))
             (* scale (ycor-vect vect))))

(let ((v1 (make-vect 2 3))
      (v2 (make-vect 4 4)))
  (add-vect v1 v2))
; 6 7
(let ((v1 (make-vect 2 3))
      (v2 (make-vect 4 4)))
  (sub-vect v1 v2))
; -2 -1
(let ((v1 (make-vect 2 3)))
  (scale-vect v1 2))
; 4 6