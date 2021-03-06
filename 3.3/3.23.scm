#lang sicp
;Exercise 3.23.  A deque (``double-ended queue'') is a sequence in which items can be inserted and deleted at either the front or the rear. Operations on deques are the constructor make-deque, the predicate empty-deque?, selectors front-deque and rear-deque, and mutators front-insert-deque!, rear-insert-deque!, front-delete-deque!, and rear-delete-deque!. Show how to represent deques using pairs, and give implementations of the operations. (Be careful not to make the interpreter try to print a structure that contains cycles.) All operations should be accomplished in O(1) steps.

; Most of the operations and representation are similar to the queue.  However, we now need to store pointers to the previous pair in the list, in order to be able to support the rear-delete-queue! operation, since lists only store the linkages in a single direction.  We will store the pointer to the previous item in the list in the cdr of the element.  (e.g. prev-ptr is (cdr (car list-pair)) )

(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))
(define (get-data deque-elem) (car (car deque-elem)))
(define (get-prev-elem deque-elem) (cdr (car deque-elem)))
(define (set-data! deque-elem data) (set-car! (car deque-elem) data))
(define (set-prev-elem! deque-elem prev-elem)
  (if (null? deque-elem)
      '()
      (set-cdr! (car deque-elem) prev-elem)))

(define (empty-deque? deque)
  (or (null? (front-ptr deque))
      (null? (rear-ptr deque))))
(define (make-deque) (cons '() '()))
(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (get-data (front-ptr deque))))
(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque" deque)
      (get-data (rear-ptr deque))))

(define (front-insert-deque! deque item)
  (let ((data (cons item '())))
    (let ((new-pair (cons data '())))
      (cond ((empty-deque? deque)
             (set-front-ptr! deque new-pair)
             (set-rear-ptr! deque new-pair)
             deque)
            (else
             (set-prev-elem! (front-ptr deque) new-pair)
             (set-cdr! new-pair (front-ptr deque))
             (set-front-ptr! deque new-pair)
             deque)))))
(define (rear-insert-deque! deque item)
  (let ((data (cons item '())))
    (let ((new-pair (cons data '())))
      (cond ((empty-deque? deque)
             (set-front-ptr! deque new-pair)
             (set-rear-ptr! deque new-pair)
             deque)
            (else
             (set-prev-elem! new-pair (rear-ptr deque))
             (set-cdr! (rear-ptr deque) new-pair)
             (set-rear-ptr! deque new-pair)
             deque)))))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque" deque))
        (else
         (set-front-ptr! deque (cdr (front-ptr deque)))
         (set-prev-elem! (front-ptr deque) '())
         deque)))
(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque" deque))
        (else
         (set-rear-ptr! deque (get-prev-elem (rear-ptr deque)))
         (if (null? (rear-ptr deque))
             (set-front-ptr! deque '())
             (set-cdr! (rear-ptr deque) '()))
         deque)))


(define (print-deque deque)
  (define (print-deque-iter remaining-pairs)
    (cond ((null? remaining-pairs) '())
          (else
           (display (get-data remaining-pairs))
           (display " ")
           (print-deque-iter (cdr remaining-pairs)))))
  (display "(")
  (print-deque-iter (car deque))
  (display ")")
  (newline))

(define d (make-deque))
(print-deque d)
;()
(empty-deque? d)
;true
(print-deque (front-insert-deque! d 1))
;(1 )
(print-deque (front-insert-deque! d 2))
;(2 1)
(print-deque (rear-insert-deque! d 3))
;(2 1 3 )
(print-deque (rear-insert-deque! d 4))
;(2 1 3 4 )
(front-deque d)
;2
(print-deque (rear-delete-deque! d))
;(2 1 3 )
(empty-deque? d)
;false
(print-deque (front-delete-deque! d))
;(1 3 )
(print-deque (front-delete-deque! d))
;(3 )
(empty-deque? d )
;false 
(print-deque (rear-delete-deque! d))
;'()
(empty-deque? d )
;true

(print-deque (rear-insert-deque! d 123))
;(123 )