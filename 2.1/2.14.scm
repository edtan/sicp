#lang sicp

;Exercise 2.14.  Demonstrate that Lem is right. Investigate the behavior of the system on a variety of arithmetic expressions. Make some intervals A and B, and use them in computing the expressions A/A and A/B. You will get the most insight by using intervals whose width is a small percentage of the center value. Examine the results of the computation in center-percent form (see exercise 2.12).

(define (make-interval a b) (cons a b))
(define (upper-bound interval) (cdr interval))
(define (lower-bound interval) (car interval))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

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

(define (display-center-percent interval)
  (display "Center: ")
  (display (center interval))
  (display ", percent: ")
  (display (percent interval))
  (newline))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (mixed? interval)    (and (< (lower-bound interval) 0) (> (upper-bound interval) 0)))
(define (div-interval x y)
  (if (mixed? y)
      (display "Error: Can't divide by an interval that has zero width!")
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))

(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
(define (par2 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

; Lem is correct, based on the observations of par1 and par2 below.
; par1 vs par2 for 10 +/- 1 and 10 +/- 1
(display-center-percent (par1 (make-center-percent 10 1) (make-center-percent 10 1)))
; Center: 5.0005000125003125, percent: 2.999800014998914
(display-center-percent (par2 (make-center-percent 10 1) (make-center-percent 10 1)))
; Center: 5.0, percent: 1.0000000000000142

; par1 vs par2 for 10 +/- 1 and 2 +/- 0.1
(display-center-percent (par1 (make-center-percent 10 1) (make-center-percent 2 0.1)))
; Center: 1.666739897156059, percent: 1.94995167000056
(display-center-percent (par2 (make-center-percent 10 1) (make-center-percent 2 0.1)))
; Center: 1.6666619790819972, percent: 0.25000309381457114

; A/A for A = 10 +/- 0.1
(display-center-percent (div-interval (make-center-percent 10 0.1) (make-center-percent 10 0.1)))
;Center: 1.000000500000125, percent: 0.1999999500000376

; A/B for A = 10 +/- 0.1, B = 2 +/- 0.1
(display-center-percent (div-interval (make-center-percent 10 0.1) (make-center-percent 2 0.1)))

; See 2.15 for an explanation of this behavior.
