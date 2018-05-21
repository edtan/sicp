#lang sicp
;Exercise 2.60.  We specified that a set would be represented as a list with no duplicates. Now suppose we allow duplicates. For instance, the set {1,2,3} could be represented as the list (2 3 2 1 3 2 2). Design procedures element-of-set?, adjoin-set, union-set, and intersection-set that operate on this representation. How does the efficiency of each compare with the corresponding procedure for the non-duplicate representation? Are there applications for which you would use this representation in preference to the non-duplicate one?

; element-of-set? remains the same, because it already stops searching after it finds the first match
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

; for adjoin-set, we can simply tack on the new element x.
; because we don't call element-of-set? anymore, the run time has changed from O(n) to O(1).
(define (adjoin-set x set) (cons x set))

(display (adjoin-set 'x '(x y z x)))
(newline)
;(x x y z x)

; for union-set, we can simply append the two sets together
; because we don't call element-of-set? anymore, the run time has changed from O(n^2) to O(1).
(define (union-set set1 set2) (append set1 set2))
(display (union-set '(x y z) '(y y z)))

; intersection-set remains the same, because we still have to search all of set2 for each item in set1
(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

; This representation could be useful if the application adjoined unique elements to an existing set, or if it took the union of sets with unique entries.  For example, storing debug/error logs in an application.  If the log messages were timestamped, they'd all be unique elements, and lots of time would be saved with this modified representation.
