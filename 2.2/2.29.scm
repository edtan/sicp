#lang sicp

;Exercise 2.29.  A binary mobile consists of two branches, a left branch and a right branch. Each branch is a rod of a certain length, from which hangs either a weight or another binary mobile. We can represent a binary mobile using compound data by constructing it from two branches (for example, using list):

;(define (make-mobile left right)
;  (list left right))

;A branch is constructed from a length (which must be a number) together with a structure, which may be either a number (representing a simple weight) or another mobile:

;(define (make-branch length structure)
;  (list length structure))

;a.  Write the corresponding selectors left-branch and right-branch, which return the branches of a mobile, and branch-length and branch-structure, which return the components of a branch.

;b.  Using your selectors, define a procedure total-weight that returns the total weight of a mobile.

;c.  A mobile is said to be balanced if the torque applied by its top-left branch is equal to that applied by its top-right branch (that is, if the length of the left rod multiplied by the weight hanging from that rod is equal to the corresponding product for the right side) and if each of the submobiles hanging off its branches is balanced. Design a predicate that tests whether a binary mobile is balanced.

;d.  Suppose we change the representation of mobiles so that the constructors are

;(define (make-mobile left right)
;  (cons left right))
;(define (make-branch length structure)
;  (cons length structure))

;How much do you need to change your programs to convert to the new representation?


(define (make-mobile left right)
  (list left right))
(define (make-branch length structure)
  (list length structure))

;a
(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (car (cdr mobile)))
(define (branch-length branch) (car branch))
(define (branch-structure branch) (car (cdr branch)))

;b
(define (total-weight mobile)
  (cond ((not (pair? mobile)) mobile)
        (else (+ (total-weight (branch-structure (left-branch mobile)))
                 (total-weight (branch-structure (right-branch mobile))))))) 
  

(total-weight (make-mobile (make-branch 10 2) (make-branch 2 4)))
;6
(total-weight (make-mobile (make-branch 10 2) (make-branch 1 (make-mobile (make-branch 2 4) (make-branch 3 5)))))
;11

;c
(define (balanced? mobile)
  (cond ((not (pair? mobile)) true)
        ((not (= (* (total-weight (branch-structure (left-branch mobile)))
                    (branch-length (left-branch mobile)))
                 (* (total-weight (branch-structure (right-branch mobile)))
                    (branch-length (right-branch mobile)))))
           false)
          (else (and (balanced? (branch-structure (left-branch mobile))) (balanced? (branch-structure (right-branch mobile)))))))

(balanced? (make-mobile (make-branch 10 3) (make-branch 2 15)))
;t
(balanced? (make-mobile (make-branch 10 3) (make-branch 2 14)))
;f
(balanced? (make-mobile (make-branch 10 9) (make-branch 1 (make-mobile (make-branch 1 45) (make-branch 1 45)))))
;t

;d
; We simply have to change the selectors for right-branch and branch-structure - just remove the outer cars.
;(define (right-branch mobile) (cdr mobile))
;(define (branch-structure branch) (cdr branch))