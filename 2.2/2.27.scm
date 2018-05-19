#lang sicp
;Exercise 2.27.  Modify your reverse procedure of exercise 2.18 to produce a deep-reverse procedure that takes a list as argument and returns as its value the list with its elements reversed and with all sublists deep-reversed as well. For example,

;(define x (list (list 1 2) (list 3 4)))

;x
;((1 2) (3 4))

;(reverse x)
;((3 4) (1 2))

;(deep-reverse x)
;((4 3) (2 1))

(define (reverse l)
  (define (r-iter remaining result)
    (if (null? remaining)
        result
        (r-iter (cdr remaining) (cons (car remaining) result))))
  (r-iter l nil))


; This one was quite tricky.  I had tried to define a recusive process directly, but had problems with handling the nil entry in the reversed list.  The trick was to define deep-reverse in terms of reverse - at each pair, just reverse the pair, before recursively running through deep-reverse.
; I was having a hard time handling the nils because I wasn't thinking of using the list keyword to create new lists.  Instead, I was using cons and append.  Using list might simplify this solution.
(define (deep-reverse l)
  (cond ((null? l) nil)
        ((not (pair? l)) l)
        (else (let ((reversed (reverse l)))
                    (cons (deep-reverse (car reversed)) (deep-reverse (cdr reversed)))))))

    
(define x (list (list 1 2) (list 3 4)))
(display "x--------")
(newline)
x
;(mcons (mcons 1 (mcons 2 '())) (mcons (mcons 3 (mcons 4 '())) '()))
(reverse x)
;(mcons (mcons 3 (mcons 4 '())) (mcons (mcons 1 (mcons 2 '())) '()))
(deep-reverse x)
;(mcons (mcons 4 (mcons 3 '())) (mcons (mcons 2 (mcons 1 '())) '()))


(define y (list (list 1 2) (list 3 4) (list 5 6 (list 7 8))))
(display "y--------")
(newline)
y
;(mcons (mcons 1 (mcons 2 '())) (mcons (mcons 3 (mcons 4 '())) (mcons (mcons 5 (mcons 6 (mcons (mcons 7 (mcons 8 '())) '()))) '())))
(reverse y)
;(mcons (mcons 5 (mcons 6 (mcons (mcons 7 (mcons 8 '())) '()))) (mcons (mcons 3 (mcons 4 '())) (mcons (mcons 1 (mcons 2 '())) '())))
(deep-reverse y)
;(mcons (mcons (mcons 8 (mcons 7 '())) (mcons 5 (mcons 6 '()))) (mcons (mcons 2 (mcons 1 '())) (mcons (mcons 4 (mcons 3 '())) '())))