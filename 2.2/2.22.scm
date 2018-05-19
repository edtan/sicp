#lang sicp

;Exercise 2.22.  Louis Reasoner tries to rewrite the first square-list procedure of exercise 2.21 so that it evolves an iterative process:

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))

;Unfortunately, defining square-list this way produces the answer list in the reverse order of the one desired. Why?

;Louis then tries to fix his bug by interchanging the arguments to cons:

(define (square-list2 items)   ; note: in the text, this is still defined as square-list.  I changed it to square-list2 for testing purposes.
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

;This doesn't work either. Explain.

(define (square x) (* x x))
(square-list (list 1 2 3 4))
(square-list2 (list 1 2 3 4))

; The first version of Louis's square-list builds up the answer by cons-ing the current item in the list with answer.  So at each step, it is setting answer = [cur-item answer].  However, this means the next step would look like answer = [next-item cur-item answer], which results in the reversed order.

; The second version of Louis's square-list doesn't build a list structure, but builds some other type of hierarchical structure.  In a list, the cdr of each element points to another list.  However, in Louis's second square-list above, the cdr of each element points to the actual data value.  The final data structure is several nested cons's.  For example, (square-list2 (list 1 2 3 4)) would evaluate as:
;(cons (cons (cons (cons nil 1) 4) 9) 16)

;On the other hand, a list would look like:
;(cons 1 (cons 4 (cons 9 (cons 16 nil))))