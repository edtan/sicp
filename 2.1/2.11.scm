#lang sicp
;Exercise 2.11.  In passing, Ben also cryptically comments: ``By testing the signs of the endpoints of the intervals, it is possible to break mul-interval into nine cases, only one of which requires more than two multiplications.'' Rewrite this procedure using Ben's suggestion.

(define (make-interval a b) (cons a b))
(define (upper-bound interval) (cdr interval))
(define (lower-bound interval) (car interval))

; Let x = [x_l x_h] and y = [x_l x_h] be the two intervals being multiplied, and z = x * y.
; By listing out the nine possible cases for the signs of the intervals and reasoning about the signs and magnitudes of the values (e.g. a negative lower bound would be obtained by maximizing its absolute value), we get:
; 0 < x_l < x_h and 0 < y_l < y_h    (both positive)             ->  z = [x_l * y_l  x_h * y_h]
; x_l < x_h < 0 and y_l < y_h < 0    (both negative)             ->  z = [x_h * y_h  x_l * y_l]
; 0 < x_l < x_h and y_l < y_h < 0    (x positive, y negative)    ->  z = [x_h * y_l  x_l * y_h]
; x_l < x_h < 0 and 0 < y_l < y_h    (x negative, y positive)    ->  z = [x_l * y_h  x_h * y_l]
; x_l < 0 < x_h and y_l < y_h < 0    (x mixed, y negative)       ->  z = [x_h * y_l  x_l * y_l]
; x_l < 0 < x_h and y_l < 0 < y_h    (x mixed, y mixed)          ->  z = [min(x_l*y_h, x_h*y_l) max(x_l*y_l, x_h*y_h)]
; x_l < 0 < x_h and 0 < y_l < y_h    (x mixed, y positive)       ->  z = [x_l * y_h  x_h * y_h]
; x_l < x_h < 0 and y_l < 0 < y_h    (x negative, y mixed)       ->  z = [x_l * y_h  x_l * y_l]
; 0 < x_l < x_h and y_l < 0 < y_h    (x positive, y mixed)       ->  z = [x_h * y_l  x_h * y_h]


(define (positive? interval) (or (> (lower-bound interval) 0) (= (lower-bound interval) 0)))    ; careful:  (not (postive? interval)) doesn't mean negative in this case!!
(define (negative? interval) (or (< (upper-bound interval) 0) (= (upper-bound interval) 0)))
(define (mixed? interval)    (and (< (lower-bound interval) 0) (> (upper-bound interval) 0)))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (cond ((and (positive? x) (positive? y)) (make-interval p1 p4))
          ((and (negative? x) (negative? y)) (make-interval p4 p1))
          ((and (positive? x) (negative? y)) (make-interval p3 p2))
          ((and (negative? x) (positive? y)) (make-interval p2 p3))
          ((and (mixed? x)    (negative? y)) (make-interval p3 p1))
          ((and (mixed? x)       (mixed? y)) (make-interval (min p2 p3) (max p1 p4)))
          ((and (mixed? x)    (positive? y)) (make-interval p2 p4))
          ((and (negative? x)    (mixed? y)) (make-interval p2 p1))
          ((and (positive? x)    (mixed? y)) (make-interval p3 p4)))))


(let ((a (make-interval 0 10))
      (b (make-interval 1 10)))
  (mul-interval a b))
(let ((a (make-interval -10 -1))
      (b (make-interval -10 -1)))
  (mul-interval a b))
(let ((a (make-interval 0 10))
      (b (make-interval -10 -1)))
  (mul-interval a b))
(let ((a (make-interval -10 0))
      (b (make-interval 1 10)))
  (mul-interval a b))
(let ((a (make-interval -10 1))
      (b (make-interval -10 -1)))
  (mul-interval a b))
(let ((a (make-interval -10 1))
      (b (make-interval -1 1)))
  (mul-interval a b))
(let ((a (make-interval -10 1))
      (b (make-interval 1 10)))
  (mul-interval a b))
(let ((a (make-interval -10 -1))
      (b (make-interval -1 1)))
  (mul-interval a b))
(let ((a (make-interval 1 10))
      (b (make-interval -1 1)))
  (mul-interval a b))