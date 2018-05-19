#lang sicp
;Exercise 2.32.  We can represent a set as a list of distinct elements, and we can represent the set of all subsets of the set as a list of lists. For example, if the set is (1 2 3), then the set of all subsets is (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)). Complete the following definition of a procedure that generates the set of subsets of a set and give a clear explanation of why it works:

;(define (subsets s)
;  (if (null? s)
;      (list nil)
;      (let ((rest (subsets (cdr s))))
;        (append rest (map <??> rest)))))


; Ahh, the good ole power set.
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))


(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x)
                            (cons (car s) x))
                          rest)))))

(subsets (list 1 2 3))
;(mcons
; '()
; (mcons
;  (mcons 3 '())
;  (mcons
;   (mcons 2 '())
;   (mcons
;    (mcons 2 (mcons 3 '()))
;    (mcons (mcons 1 '()) (mcons (mcons 1 (mcons 3 '())) (mcons (mcons 1 (mcons 2 '())) (mcons (mcons 1 (mcons 2 (mcons 3 '()))) '()))))))))

; This works because in the append step, we are combining two different sets of sets:
; 1) rest - rest contains all subsets of s that do not contain (car s) (i.e. the first element)
; 2) result of map - The result of map contains all subsets of s that do contain (car s)
; These two subsets are mutually exclusive and cover all subsets of S.
; Note that the terminal case adds the null set to the list - this includes the case where there are no elements in the set.