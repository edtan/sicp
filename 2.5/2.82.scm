#lang sicp
;Exercise 2.82.  Show how to generalize apply-generic to handle coercion in the general case of multiple arguments. One strategy is to attempt to coerce all the arguments to the type of the first argument, then to the type of the second argument, and so on. Give an example of a situation where this strategy (and likewise the two-argument version given above) is not sufficiently general. (Hint: Consider the case where there are some suitable mixed-type operations present in the table that will not be tried.)

(define (apply-generic op . args)

  (define (return-error)
    (error "No method for these types"
           (list op (map type-tag args))))
  
  (define (apply-iter types)
    (let ((remaining-types (cdr types)))
      (if (null? remaining-types)
          (return-error)
          (let ((cur-type (car types)))
              (let ((proc (get op (map (lambda (x) (cur-type)) args))))
                (if proc
                    (let (coerced-args (map (lambda (arg)
                                              (if (eq? (type-tag arg) cur-type)
                                                  arg
                                                  (let ((arg->cur-type (get-coercion (type-tag arg) cur-type)))
                                                    (if (eq? arg->cur-type false)
                                                        '()
                                                        (arg->cur-type arg)))))
                                            args))
                      (let ((missing-coercion? (not (eq? (memq '() coercions-to-cur-type) '#f))))   ; this checks to see if get-coercion returned false for any items '#f seems to be Racket's internal representation for false.
                        (if (missing-coercion?)
                            (apply-iter remaining-types)        ; couldn't find coercion for the current type, so try the next type
                            (apply proc (map contents coerced-args)))))
                    (apply-iter remaining-types)))))))          ; couldn't find a proc definition with the current type only, so try the next type
                    
  
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (apply-iter type-tags)))))
          


; An example where this strategy is not sufficiently general is when the table has a mixed-type operation in one direction, but not the other.  For example, suppose we have an operation 'combine in the table that is defined only for '(room building), but not for '(building room).  When the (apply-generic 'combine building1 room1) is called, it doesn't find an entry for 'combine with arg types '(building room), so it tries to coerce building1 into type 'room.  However, if this coercion procedure doesn't exist, it returns an error.
;However, in fact, this combine procedure would have worked properly if it had been called with the arguments in the opposite order, e.g. (apply-generic 'combine room1 building1).
;The main issue is that for multiple arguments, there might be a single procedure in the operations table that is defined for only particular orderings of those argument types.  Because the strategy described above tries to coerce all arguments to a single type, it may miss the procedure that may actually work.