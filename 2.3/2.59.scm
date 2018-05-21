#lang sicp
;Exercise 2.59.  Implement the union-set operation for the unordered-list representation of sets.

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((element-of-set? (car set1) set2)
         (union-set (cdr set1) set2))
        (else (cons (car set1)
                    (union-set (cdr set1) set2)))))

(display (union-set '(a b c) '(b c d)))
(newline)
;(a b c d)
(display (union-set '(a b c) '(d e f)))
(newline)
;(a b c d e f)
(display (union-set '(a b c) '(b d e c a z t)))
(newline)
;(b d e c a z t)