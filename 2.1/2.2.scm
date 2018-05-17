#lang sicp
;Exercise 2.2.  Consider the problem of representing line segments in a plane. Each segment is represented as a pair of points: a starting point and an ending point. Define a constructor make-segment and selectors start-segment and end-segment that define the representation of segments in terms of points. Furthermore, a point can be represented as a pair of numbers: the x coordinate and the y coordinate. Accordingly, specify a constructor make-point and selectors x-point and y-point that define this representation. Finally, using your selectors and constructors, define a procedure midpoint-segment that takes a line segment as argument and returns its midpoint (the point whose coordinates are the average of the coordinates of the endpoints). To try your procedures, you'll need a way to print points:

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-point x y) (cons x y))
(define (x-point pt) (car pt))
(define (y-point pt) (cdr pt))

(define (make-segment start-pt end-pt) (cons start-pt end-pt))
(define (start-segment seg) (car seg))
(define (end-segment seg) (cdr seg))

(define (midpoint-segment seg)
  (define (average x y) (/ (+ x y) 2.0))
  (let ((start (start-segment seg))
        (end (end-segment seg)))
    (make-point (average (x-point start) (x-point end))
                (average (y-point start) (y-point end)))))

(let ((p1 (make-point 1 1))
      (p2 (make-point 11 11)))
  (let ((seg (make-segment p1 p2)))
    (print-point (midpoint-segment seg))))
;(6.0,6.0)