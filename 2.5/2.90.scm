#lang sicp
;Exercise 2.90.  Suppose we want to have a polynomial system that is efficient for both sparse and dense polynomials. One way to do this is to allow both kinds of term-list representations in our system. The situation is analogous to the complex-number example of section 2.4, where we allowed both rectangular and polar representations. To do this we must distinguish different types of term lists and make the operations on term lists generic. Redesign the polynomial system to implement this generalization. This is a major effort, not a local change.

; The main thing to watch out for is that adjoin-term is used in the definitions for both add-term and mul-term, so we'll need to define a generic adjoin-term.  Then we define methods for converting sparse->dense and dense->sparse terms, so that one can be coerced to the other.  This means that whether one is converted into the other depends on which argument comes first in the call to apply-generic.
;Other than that, most of the solution consists of plumbing and boilerplate code.

(define (install-sparse-term-package)
  (define (adjoin-term term term-list)
  (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (tag x) (attach-tag 'sparse x))
  (put 'adjoin-term '(sparse sparse)
       (lambda (term term-list)
         (map tag (adjoin-term term term-list))))
  (put 'first-term '(sparse)
       (lambda (term-list) (tag (first-term term-list))))
  (put 'rest-terms '(sparse)
       (lambda (term-list) (map tag (rest-terms term-list))))
  (put 'make-term 'sparse
       (lambda (order coeff) (tag (make-term order coeff))))
  (put 'order '(sparse)
       (lambda (term) (order term)))
  (put 'coeff '(sparse)
       (lambda (term) (coeff term))))

(define (install-dense-term-package)
  (define (adjoin-term term term-list)
    (let ((order-diff (- (order term) (order (first-term term-list)))))
      (cond ((=zero? (coeff term)) term-list)
            ((> order-diff 0) (append (make-term (- order-diff 1) (coeff term)) term-list))
            (else (error "term must be greater than order of term-list" term term-list)))))
  (define (first-term term-list) (make-term (dec (length term-list)) (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (make-term order coeff)
    (if (= order 0)
        (list coeff)
        (append (make-term (- order 1) coeff) (list 0))))
  (define (order term) (dec (length term)))
  (define (coeff term) (car term))

  (define (tag x) (attach-tag 'dense x))
  (put 'adjoin-term '(dense dense)
       (lambda (term term-list)
         (map tag (adjoin-term term term-list))))
  (put 'first-term '(dense)
       (lambda (term-list) (tag (first-term term-list))))
  (put 'rest-terms '(dense)
       (lambda (term-list) (map tag (rest-terms term-list))))
  (put 'make-term 'dense
       (lambda (order coeff) (tag (make-term order coeff))))
  (put 'order '(dense)
       (lambda (term) (order term)))
  (put 'coeff '(dense)
       (lambda (term) (coeff term))))

; Because these two methods don't take any arguments, we don't need to make these generic operations.  Basically, each representation for terms and term-lists need to be consistent with these definitions of 'empty'
(define (the-empty-termlist) '())
(define (empty-termlist? term-list) (null? term-list))

; Define generic operations
(define (adjoin-term term term-list) (apply-generic 'adjoin-term term term-list))
(define (first-term term) (apply-generic 'first-term term))
(define (rest-terms term-list) (apply-generic 'rest-terms term-list))
(define (order term) (apply-generic 'order term))
(define (coeff term) (apply-generic 'coeff term))

; Define make-terms
(define (make-sparse-term order coeff) (apply-generic 'make-term (tag 'sparse (list order coeff))))
(define (make-dense-term order coeff) (apply-generic 'make-term (tag 'dense (list order coeff))))

(define (sparse->dense sparse-term)
  (make-dense-term (order sparse-term) (coeff sparse-term)))
(define (dense->sparse dense-term)
  (make-sparse-term (order dense-term) (coeff dense-term)))
(put-coercion 'sparse 'dense sparse->dense)
(put-coercion 'dense 'sparse dense->sparse)