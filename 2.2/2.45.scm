#lang sicp
(#%require sicp-pict)
;Exercise 2.45.  Right-split and up-split can be expressed as instances of a general splitting operation. Define a procedure split with the property that evaluating

;(define right-split (split beside below))
;(define up-split (split below beside))

;produces procedures right-split and up-split with the same behaviors as the ones already defined.
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))
(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))


(define (split t1 t2)
  (lambda (painter n)
    (define (paint-iter times-left)
      (if (= times-left 0)
          painter
          (let ((smaller (paint-iter (- times-left 1))))
            (t1 painter (t2 smaller smaller)))))
    (paint-iter n)))

(define right-split (split beside below))
(define up-split (split below beside))


(paint (up-split einstein 2))
(paint (square-limit einstein 5))