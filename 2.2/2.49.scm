#lang sicp
(#%require sicp-pict)
;Exercise 2.49.  Use segments->painter to define the following primitive painters:

;a.  The painter that draws the outline of the designated frame.

;b.  The painter that draws an ``X'' by connecting opposite corners of the frame.

;c.  The painter that draws a diamond shape by connecting the midpoints of the sides of the frame.

;d.  The wave painter.

;Because I'm using DrRacket, I will use Racket's provided sicp picture library procedures for this exercise so I can visually see the results.
;https://docs.racket-lang.org/sicp-manual/index.html

;a
(define frame-outline
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 0 0.99))
                           (make-segment (make-vect 0 0.99) (make-vect 0.99 0.99))
                           (make-segment (make-vect 0.99 0.99) (make-vect 0.99 0))
                           (make-segment (make-vect 0.99 0) (make-vect 0 0)))))
(paint frame-outline)

;b
(define big-x
  (segments->painter (list (make-segment (make-vect 0 0) (make-vect 0.99 0.99))
                           (make-segment (make-vect 0.99 0) (make-vect 0 0.99)))))
(paint big-x)

;c
(define diamond
  (segments->painter (list (make-segment (make-vect 0.5 0) (make-vect 0 0.5))
                           (make-segment (make-vect 0 0.5) (make-vect 0.5 1))
                           (make-segment (make-vect 0.5 1) (make-vect 1 0.5))
                           (make-segment (make-vect 1 0.5) (make-vect 0.5 0)))))
(paint diamond)

;d
(define wave
  (segments->painter (list (make-segment (make-vect 0.25 0) (make-vect 0.35 0.5))  ;bottom-left
                           (make-segment (make-vect 0.35 0.5) (make-vect 0.3 0.6))
                           (make-segment (make-vect 0.3 0.6) (make-vect 0.2 0.4))
                           (make-segment (make-vect 0.2 0.4) (make-vect 0 0.7))
                           (make-segment (make-vect 0 0.88) (make-vect 0.2 0.6))  ;top-left
                           (make-segment (make-vect 0.2 0.6) (make-vect 0.3 0.65))
                           (make-segment (make-vect 0.3 0.65) (make-vect 0.4 0.65))
                           (make-segment (make-vect 0.4 0.65) (make-vect 0.35 0.88))
                           (make-segment (make-vect 0.35 0.88) (make-vect 0.4 1))
                           (make-segment (make-vect 0.6 1) (make-vect 0.65 0.88)) ;top-right
                           (make-segment (make-vect 0.65 0.88) (make-vect 0.6 0.65))
                           (make-segment (make-vect 0.6 0.65) (make-vect 0.75 0.65))
                           (make-segment (make-vect 0.75 0.65) (make-vect 1 0.35))
                           (make-segment (make-vect 0.6 1) (make-vect 0.65 0.88)) ;bottom-right
                           (make-segment (make-vect 1 0.2) (make-vect 0.6 0.4))
                           (make-segment (make-vect 0.6 0.4) (make-vect 0.8 0))
                           (make-segment (make-vect 0.4 0) (make-vect 0.5 0.33))  ; middle-bottom
                           (make-segment (make-vect 0.5 0.33) (make-vect 0.6 0))
                           )))
(paint wave)