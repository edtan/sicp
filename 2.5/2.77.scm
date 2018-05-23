#lang sicp

;Exercise 2.77.  Louis Reasoner tries to evaluate the expression (magnitude z) where z is the object shown in figure 2.24. To his surprise, instead of the answer 5 he gets an error message from apply-generic, saying there is no method for the operation magnitude on the types (complex). He shows this interaction to Alyssa P. Hacker, who says ``The problem is that the complex-number selectors were never defined for complex numbers, just for polar and rectangular numbers. All you have to do to make this work is add the following to the complex package:''

(put 'real-part '(complex) real-part)
(put 'imag-part '(complex) imag-part)
(put 'magnitude '(complex) magnitude)
(put 'angle '(complex) angle)

;Describe in detail why this works. As an example, trace through all the procedures called in evaluating the expression (magnitude z) where z is the object shown in figure 2.24. In particular, how many times is apply-generic invoked? What procedure is dispatched to in each case?

;In section 2.4 these procedures were defined in the table of operations only for operands with tag types of '(rectangular) and '(polar).  The generic selectors were then defined as:
(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

; Thus, for the object z in figure 2.24, z = (cons 'complex (cons 'rectangular (cons 3 4)))
(magnitude (z))
(magnitude (cons 'complex (cons 'rectangular (cons 3 4))))
(apply-generic 'magnitude (cons 'complex (cons 'rectangular (cons 3 4))))
; apply-generic above will find the entry for '(complex), and find that the corresponding procedure is magnitude
(magnitude (cons rectangular (cons 3 4)))
(apply-generic 'magnitude (cons rectangular (cons 3 4)))
; apply-generic above will find the entry for '(rectangular), and find that the coresponding procedure is the one installed in the complex number package
5

;Therefore, apply-generic is invoked twice.  During the first call to apply-generic, the generic magnitude selector is dispatched.  In the second call to apply-generic, the rectangular magnitude selector is dispatched.
