#lang sicp
;Exercise 3.4.  Modify the make-account procedure of exercise 3.3 by adding another local state variable so that, if an account is accessed more than seven consecutive times with an incorrect password, it invokes the procedure call-the-cops.


(define (make-account balance password)
  (let ((attempts-left? 7))
    (define (withdraw amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (call-the-cops amount)
      (display "Cops have been called!")
      (newline))      
    (define (dispatch p m)
      (cond ((= attempts-left? 0) call-the-cops)
            ((not (eq? p password))
             (lambda (amount)
               (set! attempts-left? (- attempts-left? 1))
               (display "Incorrect password")
               (newline)))
            ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))
    dispatch))


(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40)
;60
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Incorrect password
((acc 'some-other-password 'deposit) 50)
;Cops have been called!