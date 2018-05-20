#lang sicp
;Exercise 2.33.  Fill in the missing expressions to complete the following definitions of some basic list-manipulation operations as accumulations:

;(define (map p sequence)
;  (accumulate (lambda (x y) <??>) nil sequence))
;(define (append seq1 seq2)
;  (accumulate cons <??> <??>))
;(define (length sequence)
;  (accumulate <??> 0 sequence))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
          
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))
(map (lambda (x) (* x x)) (list 1 2 3 4))
;(mcons 1 (mcons 4 (mcons 9 (mcons 16 '()))))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))
(append (list 1 2 3 4) (list 5 6 7))
;(mcons 1 (mcons 2 (mcons 3 (mcons 4 (mcons 5 (mcons 6 (mcons 7 '())))))))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
(length (list 1 2 3 4 5))
;5