#lang racket
;Exercise 1.12.  The following pattern of numbers is called Pascal's triangle.
;1
;11
;121
;1331
;14641
;The numbers at the edge of the triangle are all 1, and each number inside the triangle
;is the sum of the two numbers above it.35 Write a procedure that computes elements of Pascal's
;triangle by means of a recursive process.

; We represent the triangle as the lower triangle of a square matrix.
; Return 0 if col > row (outside the triangle).

(define (pascal row col)
  (cond ((or (= row 1) (= col 1) (= col row)) 1)
        ((> col row) 0)
        (else (+ (pascal (- row 1) (- col 1))
                 (pascal (- row 1) col)))))

(pascal 3 2) ; 2
(pascal 4 3) ; 3
(pascal 5 3) ; 6
(pascal 6 3) ; 10