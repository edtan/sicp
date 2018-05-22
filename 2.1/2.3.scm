#lang sicp

;Exercise 2.3.  Implement a representation for rectangles in a plane. (Hint: You may want to make use of exercise 2.2.) In terms of your constructors and selectors, create procedures that compute the perimeter and the area of a given rectangle. Now implement a different representation for rectangles. Can you design your system with suitable abstraction barriers, so that the same perimeter and area procedures will work using either representation?


; to keep things simple, we only consider rectangles that are lined up with x and y axes, and assume the provided input is valid (no error checking)

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


;make-rectangle takes 2 line segments
;seg1 is the segment from the bottom left to the bottom right of the rectangle
;seg2 is the segment from the bottom left to the top left of the rectangle
(define (make-rectangle seg1 seg2) (cons seg1 seg2))
(define (get-bottom-left-pt rectangle)
  (let ((seg1 (car rectangle)))
    (start-segment seg1)))
(define (get-bottom-right-pt rectangle)
  (let ((seg1 (car rectangle)))
    (end-segment seg1)))
(define (get-top-left-pt rectangle)
  (let ((seg2 (cdr rectangle)))
    (end-segment seg2)))

(define (width rectangle)
  (- (x-point (get-bottom-right-pt rectangle))
     (x-point (get-bottom-left-pt rectangle))))
(define (height rectangle)
  (- (y-point (get-top-left-pt rectangle))
     (y-point (get-bottom-left-pt rectangle))))

(define (perimeter rectangle)
  (+ (* 2 (width rectangle))
     (* 2 (height rectangle))))
(define (area rectangle)
  (* (width rectangle) (height rectangle)))

(define my-rectangle
  (make-rectangle (make-segment (make-point 1 1) (make-point 10 1))
                  (make-segment (make-point 1 1) (make-point 5 5))))
(perimeter my-rectangle)
;26
(area my-rectangle)
;36


; Yes, we can change the representation of the rectangles without changing the definition of the perimeter and area procedures. for example, we could flip the position of seg1 and seg2 in the rectangle constructor above, and modify the corresponding get-*-*-pt selectors accordingly.  because perimeter and area are defined in terms of width and height, and because width and height are defined in terms of these selectors, we don't have to change width, height, perimeter, or area.
        