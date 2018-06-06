#lang sicp

;Exercise 3.24.  In the table implementations above, the keys are tested for equality using equal? (called by assoc). This is not always the appropriate test. For instance, we might have a table with numeric keys in which we don't need an exact match to the number we're looking up, but only a number within some tolerance of it. Design a table constructor make-table that takes as an argument a same-key? procedure that will be used to test ``equality'' of keys. Make-table should return a dispatch procedure that can be used to access appropriate lookup and insert! procedures for a local table.


; We simply change the definition of assoc to assoc-updated, which uses same-key? instead of equal?

(define (make-table same-key?)
  (define (assoc-updated key records)
    (cond ((null? records) false)
          ((same-key? key (caar records)) (car records))
          (else (assoc-updated key (cdr records)))))
  (let ((local-table (list '*table*)))
    (define (lookup key)
      (let ((record (assoc-updated key (cdr local-table))))
        (if record
            (cdr record)
            false)))
    (define (insert! key value)
      (let ((record (assoc-updated key (cdr local-table))))
        (if record
            (set-cdr! record value)
            (set-cdr! local-table
                      (cons (cons key value)
                                  (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define t (make-table equal?))
(define get-t (t 'lookup-proc))
(define put-t (t 'insert-proc!))

(put-t 1 'a)
(put-t 20 'b)
(put-t 300 'c)

(get-t 1)
;a
(get-t 20)
;b
(get-t 300)
;c
(get-t 2)
;false

; Test with a close-enough? function that checks if numeric keys are within some tolerance (2) of each other
(define (close-enough? key1 key2)
  (define tolerance 2)
  (cond ((and (number? key1) (number? key2)
              (<= (abs (- key1 key2)) tolerance)) true)
        (else (equal? key1 key2))))

(define v (make-table close-enough?))
(define get-v (v 'lookup-proc))
(define put-v (v 'insert-proc!))

(put-v 1 'a)
(put-v 20 'b)
(put-v 300 'c)

(get-v 1)
;a
(get-v 20)
;b
(get-v 300)
;c
(get-v 2)
;a
(get-v 3)
;a
(get-v 4)
;false
(get-v 22)
;b
(get-v 23)
;false