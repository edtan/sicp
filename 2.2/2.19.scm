#lang sicp
;Exercise 2.19.  Consider the change-counting program of section 1.2.2. It would be nice to be able to easily change the currency used by the program, so that we could compute the number of ways to change a British pound, for example. As the program is written, the knowledge of the currency is distributed partly into the procedure first-denomination and partly into the procedure count-change (which knows that there are five kinds of U.S. coins). It would be nicer to be able to supply a list of coins to be used for making change.

;We want to rewrite the procedure cc so that its second argument is a list of the values of the coins to use rather than an integer specifying which coins to use. We could then have lists that defined each kind of currency:

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

;We could then call cc as follows:

;(cc 100 us-coins)
;292

;To do this will require changing the program cc somewhat. It will still have the same form, but it will access its second argument differently, as follows:

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

;Define the procedures first-denomination, except-first-denomination, and no-more? in terms of primitive operations on list structures. Does the order of the list coin-values affect the answer produced by cc? Why or why not?

(define (no-more? l) (null? l))
(define (except-first-denomination l) (cdr l))
(define (first-denomination l) (car l))

(cc 100 us-coins) ;292
(cc 100 uk-coins) ;104561

(define (reverse l)
  (define (r-iter remaining result)
    (if (null? remaining)
        result
        (r-iter (cdr remaining) (cons (car remaining) result))))
  (r-iter l nil))
(cc 100 (reverse us-coins)) ; 292
(cc 100 (list 1 5 25 50 10)) ; 292
(cc 100 (reverse uk-coins)) ;104561

;Changing the order of the list doesn't change the answer.  However, the run-time seems to have increased when starting with the smaller values first.  This is because with smaller coin values in the beginning of the list, the algorithm gets called more times in the beginning with similar values as the original problem.  E.g. for the US coins, in the first iteration, it would look for ways of counting change for 100 cents with 4 remaining coin values plus ways of change of 99 cents with 5 coin values.  This is opposed to finding ways of counting change for 100 cents with 4 remaining coin values plus ways of change of 50 cents with 5 coin values.  When listing change in decreasing order of magnitude, the tree structure is much smaller.