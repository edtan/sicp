#lang sicp
;Exercise 3.17.  Devise a correct version of the count-pairs procedure of exercise 3.16 that returns the number of distinct pairs in any structure. (Hint: Traverse the structure, maintaining an auxiliary data structure that is used to keep track of which pairs have already been counted.)

; The tricky part of this question was defining visited-pairs within the count-pairs environment.  I had initially defined visited-pairs in the global environment, but this caused problems later on when I called count-pairs several times on various list structures that had some shared pairs as previously list structures that were called with count-pairs.

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (count-pairs x)
  (let ((visited-pairs '()))

    (define (already-visited? p)
      (if (memq p visited-pairs)
          true
          false))

    (define (add-visited p)
      (if (null? visited-pairs)
          (set! visited-pairs (cons p '()))
          (let ((last (last-pair visited-pairs)))
            (set-cdr! last (cons p '())))))

    (define (count-pairs-iter x)
      (cond ((or (not (pair? x)) (already-visited? x)) 0)
            (else
             (add-visited x)
             (+ (count-pairs-iter (car x))
                (count-pairs-iter (cdr x))
                1))))

    (count-pairs-iter x)))
  
(define x (list 1 2 3))
(count-pairs x)
;3

(define a (cons 1 '()))
(define b (list a a))
(count-pairs b)
;3

(define d (cons a a))
(define e (cons d d))
(count-pairs e)
;3