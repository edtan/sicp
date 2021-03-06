#lang sicp
;Exercise 2.63.  Each of the following two procedures converts a binary tree to a list.

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
              (cons (entry tree)
                    (tree->list-1 (right-branch tree))))))
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

;a. Do the two procedures produce the same result for every tree? If not, how do the results differ? What lists do the two procedures produce for the trees in figure 2.16?

;b. Do the two procedures have the same order of growth in the number of steps required to convert a balanced tree with n elements to a list? If not, which one grows more slowly?

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

;a. evaluting the trees in figure 2.16
;Yes, the two procedures produce the same result for every tree, and the results below confirm it for the trees in figure 2.16.
; Because both procedures are defined with the top-level tree entry sandwiched between the left and right branches, the resulting list will be in order.

;left figure
(display (tree->list-1 (make-tree 7 (make-tree 3 (make-tree 1 '() '()) (make-tree 5 '() '())) (make-tree 9 '() (make-tree 11 '() '())))))
(newline)
;(1 3 5 7 9 11)
(display (tree->list-2 (make-tree 7 (make-tree 3 (make-tree 1 '() '()) (make-tree 5 '() '())) (make-tree 9 '() (make-tree 11 '() '())))))
(newline)
;(1 3 5 7 9 11)

;middle figure
(display (tree->list-1 (make-tree 3 (make-tree 1 '() '()) (make-tree 7 (make-tree 5 '() '()) (make-tree 9 '() (make-tree 11 '() '()))))))
(newline)
;(1 3 5 7 9 11)
(display (tree->list-2 (make-tree 3 (make-tree 1 '() '()) (make-tree 7 (make-tree 5 '() '()) (make-tree 9 '() (make-tree 11 '() '()))))))
(newline)
;(1 3 5 7 9 11)

;right figure
(display (tree->list-1 (make-tree 5 (make-tree 3 (make-tree 1 '() '()) '()) (make-tree 9 (make-tree 7 '() '()) (make-tree 11 '() '())))))
(newline)
;(1 3 5 7 9 11)
(display (tree->list-2 (make-tree 5 (make-tree 3 (make-tree 1 '() '()) '()) (make-tree 9 (make-tree 7 '() '()) (make-tree 11 '() '())))))
(newline)
;(1 3 5 7 9 11)

;b.
;Both procedures produce similar recursive processes, and so both run with the same run time.  These are both tree recursive processes, where each node of the tree is visited exactly once per procedure call.  Therefore, this algorithm takes O(n) time for a tree of size n.