#lang sicp
;Exercise 2.1.  Define a better version of make-rat that handles both positive and negative arguments. Make-rat should normalize the sign so that if the rational number is positive, both the numerator and denominator are positive, and if the rational number is negative, only the numerator is negative.

(define (make-rat n d)
  (define (sign x)
    (if (> x 0)
        1
        -1))
  (let ((g (gcd n d)))
    (let ((n-over-g (/ n g))   ; note that I had to define a "sub" let, because as explained in SICP, the arguments of let are evaluated in the body of the procedure.  therefore, it wouldn't have know what 'g' meant if n-over-g and d-over-g were defined within the same let as g.
          (d-over-g (/ d g)))
    (if (= (* (sign n) (sign d))
           -1)
        (cons (* -1 (abs n-over-g)) (abs d-over-g)) ; negative
        (cons       (abs n-over-g)  (abs d-over-g)))))) ; positive

(make-rat 1 5)
;(mcons 1 5)
(make-rat 2 -4)
;(mcons -1 2)
(make-rat -3 7)
;(mcons -3 7)
(make-rat -4 -3)
;(mcons 4 3)