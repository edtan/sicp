#lang sicp
;Exercise 3.6.  It is useful to be able to reset a random-number generator to produce a sequence starting from a given value. Design a new rand procedure that is called with an argument that is either the symbol generate or the symbol reset and behaves as follows: (rand 'generate) produces a new random number; ((rand 'reset) <new-value>) resets the internal state variable to the designated <new-value>. Thus, by resetting the state, one can generate repeatable sequences. These are very handy to have when testing and debugging programs that use random numbers.

; just define dummy definitions for random-init and rand-update for testing
(define random-init 1)
(define (rand-update x) (+ x 1))

(define rand
  (let ((x random-init))
    (define (generate)
      (set! x (rand-update x))
      x)
    (define (reset new-value)
      (set! x new-value)
      (display x)
      (newline))
    (define (dispatch op)
      (cond ((eq? op 'generate) (generate))
            ((eq? op 'reset) reset)
            (else (error "Unsupported op" op))))
    dispatch))

(rand 'generate)
;2
(rand 'generate)
;3
((rand 'reset) 1)
;1
(rand 'generate)
;2

; The following was my first attempt at this problem, which doesn't work.  (rand 'generate) would always return 2, because instead of letting rand refer to a procedure with a local variable, I was defining rand 'as' a procedure which initialized x to random-init every time the procedure was evaluated.

;(define (rand op)
;  (let ((x random-init))
;    (define (generate)
;      (set! x (rand-update x))
;      x)
;    (define (reset new-value)
;      (set! x new-value))
;    (cond ((eq? op 'generate) (generate))
;          ((eq? op 'reset) reset)
;          (else (error "Unsupported op" op)))))