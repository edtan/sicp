#lang sicp
;Exercise 2.41.  Write a procedure to find all ordered triples of distinct positive integers i, j, and k less than or equal to a given integer n that sum to a given integer s.

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))



(define (unique-tuples n)
  (flatmap
   (lambda (i)
     (flatmap (lambda (j)
                (map (lambda (k) (list i j k))
                 (enumerate-interval 1 (- j 1))))
              (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(display (unique-tuples 5))
(newline)
;((3 2 1) (4 2 1) (4 3 1) (4 3 2) (5 2 1) (5 3 1) (5 3 2) (5 4 1) (5 4 2) (5 4 3))

(define (unique-triple-sum n s)
  (filter (lambda (x)
            (= (+ (car x) (cadr x) (caddr x)) s))
          (unique-tuples n)))
(display (unique-triple-sum 10 13))
;((6 4 3) (6 5 2) (7 4 2) (7 5 1) (8 3 2) (8 4 1) (9 3 1) (10 2 1))