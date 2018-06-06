#lang sicp
;Exercise 3.25.  Generalizing one- and two-dimensional tables, show how to implement a table in which values are stored under an arbitrary number of keys and different values may be stored under different numbers of keys. The lookup and insert! procedures should take as input a list of keys used to access the table.

(define (empty? table)
  (null? (cdr table)))
(define (make-table)
  (list '*table*))

(define (lookup keys table)
  (cond ((and (null? keys) (pair? table)) false)  ; ran out of keys => keys only pointed to a subtable, not an actual value
        ((and (pair? keys) (null? table)) false)  ; more keys than subtables ==> requested combination of keys not found
        ((and (null? keys) (null? table))
         (error "This shouldn't happen (no keys or subtables left)" keys table))
        (else
         (let ((cur-key (car keys))
               (remaining-keys (cdr keys)))
           (let ((record (assoc cur-key (cdr table))))
             (cond ((eq? record false) false)
                   ((and (not (pair? (cdr record))) (null? remaining-keys)) (cdr record))
                   ((and (not (pair? (cdr record))) (not (null? remaining-keys))) false)   ; more keys than subtables ==> requested combination of keys not found
                   (else
                    (lookup remaining-keys record))))))))

(define (insert! keys value table)
      (let ((cur-key (car keys))
            (remaining-keys (cdr keys)))
        (let ((record (assoc cur-key (cdr table))))
          (if record
              (cond ((null? remaining-keys)
                     (begin (set-cdr! record value)
                            'ok-existing-subtable-existing-key))
                    ((null? (cdr remaining-keys))
                      (set-cdr! record
                                (cons (cons (car remaining-keys) value)
                                      '()))
                      'ok-existing-subtable-new-key)
                    (else
                     (insert! remaining-keys value record)))
              (begin (if (empty? table)
                         (set-cdr! table
                                   (cons (list cur-key)
                                         '()))
                         (set-cdr! table
                                   (cons (list cur-key)
                                         (cdr table))))
                     (if (null? remaining-keys)
                         (begin (set-cdr! (cadr table) value)
                                'ok-new-subtable-new-key)
                         (insert! remaining-keys value (cadr table))))))))
  

(define t (make-table))
(insert! '(a b) 1 t)
(lookup '(a) t)
;false
(lookup '(a b) t)
;1
(lookup '(a b c) t)
;false
(lookup '(c b) t)
;false

(insert! '(a) 3 t)
(lookup '(a) t)
;3
(lookup '(a b) t)
;false
(lookup '(a b c) t)
;false
(lookup '(c b) t)
;false

(insert! '(a b) 5 t)
(lookup '(a) t)
;false
(lookup '(a b) t)
;5
(lookup '(a b c) t)
;false
(lookup '(c b) t)
;false

(insert! '(a b c) 7 t)
(lookup '(a) t)
;false
(lookup '(a b) t)
;false
(lookup '(a b c) t)
;7
(lookup '(c b) t)
;false


(insert! '(c b) 11 t)
(lookup '(a) t)
;false
(lookup '(a b) t)
;false
(lookup '(a b c) t)
;7
(lookup '(c b) t)
;11


