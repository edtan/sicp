#lang sicp
;Exercise 2.35.  Redefine count-leaves from section 2.2.2 as an accumulation:

;(define (count-leaves t)
;  (accumulate <??> <??> (map <??> <??>)))


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (count-leaves t)
  (accumulate +
              0
              (map (lambda (x)
                     (cond ((null? x) 0)
                           ((not (pair? x)) 1)
                           (else (+ (count-leaves x)))))
                   t)))

(count-leaves (list 1 2 (list 3 (list 4 5))))
;5
(count-leaves (list 3 (list 4 5)))
;3
(count-leaves (list 1 3 0 5 0 1))
;6