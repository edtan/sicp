#lang sicp
;Exercise 2.52.  Make changes to the square limit of wave shown in figure 2.9 by working at each of the levels described above. In particular:

;a.  Add some segments to the primitive wave painter of exercise  2.49 (to add a smile, for example).

;b.  Change the pattern constructed by corner-split (for example, by using only one copy of the up-split and right-split images instead of two).

;c.  Modify the version of square-limit that uses square-of-four so as to assemble the corners in a different pattern. (For example, you might make the big Mr. Rogers look outward from each corner of the square.)

;a.  I'm not actually going to add a smile, but to modify the primite wave painter, we just have to add segments to the list in the definition of wave (reproduced here for convenience).
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

;b.  corner-split - only one copy instead of 2 of up and right
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left up) ; changed from (beside up up) to up
              (bottom-right right) ; change from (below right right) to right
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

;c.  square-limit - make Mr. Rogers look outwards
(define (square-limit painter n)
  (let ((quarter (corner-split (flip-horiz painter) n)))  ;added flip-horiz
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))