#lang sicp
;Exercise 2.65.  Use the results of exercises 2.63 and 2.64 to give O(n) implementations of union-set and intersection-set for sets implemented as (balanced) binary trees.

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? x (left-branch set)))
        ((> x (entry set))
         (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree (entry set) 
                    (adjoin-set x (left-branch set))
                    (right-branch set)))
        ((> x (entry set))
         (make-tree (entry set)
                    (left-branch set)
                    (adjoin-set x (right-branch set))))))

(define (tree->list tree)
  (if (null? tree)
      '()
      (append (tree->list (left-branch tree))
              (cons (entry tree)
                    (tree->list (right-branch tree))))))

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

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((x1 (car set1))
               (x2 (car set2)))
           (cond
             ((= x1 x2) (union-set (cdr set1) set2))
             ((< x1 x2) (cons x1 (union-set (cdr set1) set2)))
             (else (cons x2 (union-set set1 (cdr set2)))))))))

; set1 and set2 are represented as balanced binary trees
; we simply borrow the O(n) procedures for union-set and intersection-set for ordered lists.
; first we convert set1 and set2 to ordered lists using tree->list, which takes O(n) steps
; then we call the corresponding O(n) union/intersection procedure.
; finally we use list->tree to convert back to a balanced binary tree, which takes O(n) steps
; the order of growth is O(n) + O(n) + O(n) = O(n)
(define (union-set-binary-tree set1 set2)
  (let ((set1-list (tree->list set1))
        (set2-list (tree->list set2)))
        (list->tree (union-set set1-list set2-list))))

(display (union-set-binary-tree (list->tree '(2 4 6 8)) (list->tree '(2 4 6))))
(newline)
;(4 (2 () ()) (6 () (8 () ())))
(display (union-set-binary-tree (list->tree '(2 4 6 8)) (list->tree '(1 4 7))))
(newline)
;(4 (1 () (2 () ())) (7 (6 () ()) (8 () ())))

(define (intersection-set-binary-tree set1 set2)
  (let ((set1-list (tree->list set1))
        (set2-list (tree->list set2)))
        (list->tree (intersection-set set1-list set2-list))))

(display (intersection-set-binary-tree (list->tree '(2 4 6 8)) (list->tree '(2 4 6))))
(newline)
;(4 (2 () ()) (6 () ()))
(display (intersection-set-binary-tree (list->tree '(2 4 6 8)) (list->tree '(1 4 7))))
(newline)
;(4 () ())
