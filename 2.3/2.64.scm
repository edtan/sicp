#lang sicp
;Exercise 2.64.  The following procedure list->tree converts an ordered list to a balanced binary tree. The helper procedure partial-tree takes as arguments an integer n and list of at least n elements and constructs a balanced tree containing the first n elements of the list. The result returned by partial-tree is a pair (formed with cons) whose car is the constructed tree and whose cdr is the list of elements not included in the tree.

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

;a. Write a short paragraph explaining as clearly as you can how partial-tree works. Draw the tree produced by list->tree for the list (1 3 5 7 9 11).

;b. What is the order of growth in the number of steps required by list->tree to convert a list of n elements?

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

;a.
; partial-tree begins by first dividing the elements into two groups - the first floor((n-1) / 2) elements and the rest of the elements.  It then recursively calls partial tree twice, once for each of the 2 groups, to create balanced trees for each group.  The first group becomes the left branch, the first element of the second group becomes the top-most node of the tree, and the remaining items in the second group become the right branch.  This describes the first element of the returned list.
; for the second parameter, if partial-tree was called with n less than the size of elts, there will be remaining elements after the process described above.  these elements are not in the constructed partial tree, and are still in order.  these remaining arguments are returned as the second element of the returned list.

;The generated tree for (1 3 5 7 9 11) will look like:
;       5
;     /   \
;    /     \
;   1       9
;    \     /  \
;     3   7   11
(display (list->tree '(1 3 5 7 9 11)))
;(5 (1 () (3 () ())) (9 (7 () ()) (11 () ())))

;b.
;During each iteration, the elements are divided into two sets of roughly the equal size, and partial-tree is called recursively for each of these sets.  Because the sets are split into two at each step, it follows that it will take log_2(n) splits to split a set of n elements into individual elements.  During each split, partial-tree is called twice.  Therefore, partial-tree will be called approximately 2^(log_2(n)) = n times for a list of n times.  Therefore, the order of growth is O(n).
;Another simpler way to estimate the number of times partial-tree is called, is to realize that partial-tree needs to return each node exactly once.  The number of nodes in the balanced tree is n, so it makes sense that the order of growth is O(n).