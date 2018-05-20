#lang sicp
;Exercise 2.40.  Define a procedure unique-pairs that, given an integer n, generates the sequence of pairs (i,j) with 1< j< i< n. Use unique-pairs to simplify the definition of prime-sum-pairs given above.

(define (square x) (* x x))
(define (smallest-divisor n)
  (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b)
  (= (remainder b a) 0))
(define (prime? n)
  (= n (smallest-divisor n)))

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

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))
(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))


;Although this problem was easy to complete (e.g. just refactoring the code within SICP), it took me a while to understand what exactly the difference between map and flatmap was, and to understand how to write proper procs for use in flatmap.

; So, what exactly is the difference between map and flatmap?
; map will just apply the proc to each element of the list and return a new list with the results.
; flatmap is focused on nested maps - it expects that you have a sequence of sequences after applying lambda to the original sequence.  That is, if you call flatmap on a list, say (1 2 3), it expects proc to transform each element into a list.  E.g (proc 1) -> (5 6 7), (proc 2) -> (8), (proc 3) -> (3 1 4).  flatmap then accumulates the results into a single list: ((5 6 7) (8) (3 1 4)
(display (map square (enumerate-interval 1 10)))
(newline)
;(1 4 9 16 25 36 49 64 81 100)
(display (flatmap (lambda (x) (list (square x))) (enumerate-interval 1 10)))
;(1 4 9 16 25 36 49 64 81 100)


;Solution to 2.40
(define (unique-pairs n)
  (flatmap
   (lambda (i)
     (map (lambda (j) (list i j))
          (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(display (unique-pairs 5))
(newline)
;((2 1) (3 1) (3 2) (4 1) (4 2) (4 3) (5 1) (5 2) (5 3) (5 4))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))

(display (prime-sum-pairs 10))
(newline)
;((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7) (6 1 7) (6 5 11) (7 4 11) (7 6 13) (8 3 11) (8 5 13) (9 2 11) (9 4 13) (9 8 17) (10 1 11) (10 3 13) (10 7 17) (10 9 19))