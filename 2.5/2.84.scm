#lang sicp
;Exercise 2.84.  Using the raise operation of exercise 2.83, modify the apply-generic procedure so that it coerces its arguments to have the same type by the method of successive raising, as discussed in this section. You will need to devise a way to test which of two types is higher in the tower. Do this in a manner that is ``compatible'' with the rest of the system and will not lead to problems in adding new levels to the tower.

; we modify the 2 argument apply-generic from exercise 2.81 instead of the multi-argument apply-generic of 2.82 for simplicity

; given a type in our arithmetic system, this finds the 'rank' of this type - i.e. the distance it is from the top-most type in the system.  the lower the rank, the higher it is in the hierarchy.
(define (find-rank type)
  (let ((parent-type (get 'raise type)))
    (if parent-type
        (+ 1 (find-rank parent-type))
        0)))

; calls raise n times on x
(define (raise-n-times x n)
  (if (= n 0)
      x
      (raise-n-times (raise x) (- n 1))))
  
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((rank1 (find-rank type1))
                      (rank2 (find-rank typ2)))
                  (let ((r1-r2 (- rank1 rank2))
                        (r2-r1 (- rank2 rank1)))
                    (cond ((> r1-r2 0)
                           (apply-generic op a1 (raise-n-times a2 r1-r2)))
                          ((> r2-r1 0)
                           (apply-generic op (raise-n-times a1 r1-r2) a2))
                          (else
                           (error "No method for these types"
                                  (list op type-tags))))))))))))