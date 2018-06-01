#lang sicp
;Exercise 3.19.  Redo exercise 3.18 using an algorithm that takes only a constant amount of space. (This requires a very clever idea.)

; I already knew the idea to this one as it's a common interview question.  It's also known as the tortoise and the hare algorithm.

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (has-cycle? l)
  (let ((first-pair l))

    (define (next l)
      (if (or (null? l) (null? (cdr l)))
          '()
          (cdr l)))

    (define (has-cycle-iter tortoise hare)
      (cond ((or (null? tortoise) (null? hare)) false)
            ((or (eq? tortoise hare)
                 (eq? tortoise first-pair)) true)
            (else (has-cycle-iter (next tortoise) (next (next hare))))))

    (if (or (null? l) (null? (next l)))
        false
        (has-cycle-iter (next l) (next (next l))))))

(has-cycle? (list 1 2 3))
;false

(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
(has-cycle? z)
;true