#lang sicp
;Exercise 2.38.  The accumulate procedure is also known as fold-right, because it combines the first element of the sequence with the result of combining all the elements to the right. There is also a fold-left, which is similar to fold-right, except that it combines elements working in the opposite direction:

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

;What are the values of

;(fold-right / 1 (list 1 2 3))
;(fold-left / 1 (list 1 2 3))
;(fold-right list nil (list 1 2 3))
;(fold-left list nil (list 1 2 3))

;Give a property that op should satisfy to guarantee that fold-right and fold-left will produce the same values for any sequence.


(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op initial (cdr sequence)))))

(fold-right / 1 (list 1 2 3))
; 1 / (2 / (3 / initial))
; 1 / (2 / 3)
; 3/2
(fold-left / 1 (list 1 2 3))
; ((initial / 1) / 2) / 3
; = (1 / 2) / 3
; = 1/6
(display (fold-right list nil (list 1 2 3)))
(newline)
;   (list 1 (list 2 (list 3)))
; = (1 (2 (3 ())))
(display (fold-left list nil (list 1 2 3)))
(newline)
; (list((list((list((list nil) 1) 2) 3)
; = (((() 1) 2) 3)

; As shown in the above examples, op must be associative in order for fold-right and fold-left to produce the same values for any sequence.  For example:
(display (fold-right * 1 (list 1 2 3)))
(newline)
;6
(display (fold-left * 1 (list 1 2 3)))
(newline)
;6