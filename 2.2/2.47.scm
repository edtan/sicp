#lang sicp
;Exercise 2.47.  Here are two possible constructors for frames:

;(define (make-frame origin edge1 edge2)
;  (list origin edge1 edge2))

;(define (make-frame origin edge1 edge2)
;  (cons origin (cons edge1 edge2)))

;For each constructor supply the appropriate selectors to produce an implementation for frames.

(define (make-frame-v1 origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame-v1 frame) (car frame))
(define (edge1-frame-v1 frame) (cadr frame))
(define (edge2-frame-v1 frame) (caddr frame))

; in the following examples, we just use ints instead of vectors for testing
(origin-frame-v1 (make-frame-v1 1 2 3))  
;1
(edge1-frame-v1 (make-frame-v1 1 2 3)) 
;2
(edge2-frame-v1 (make-frame-v1 1 2 3)) 
;3

(define (make-frame-v2 origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin-frame-v2 frame) (car frame)) ; same as v1
(define (edge1-frame-v2 frame) (cadr frame)) ; same as v1
(define (edge2-frame-v2 frame) (cddr frame)) ; different than v1

(origin-frame-v2 (make-frame-v2 1 2 3))  
;1
(edge1-frame-v2 (make-frame-v2 1 2 3)) 
;2
(edge2-frame-v2 (make-frame-v2 1 2 3)) 
;3