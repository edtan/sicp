#lang sicp
;Exercise 1.37.  a. An infinite continued fraction is an expression of the form
;f = N1 / (D1 + (N2 / D2 + (N3 / D3 + ...  

;As an example, one can show that the infinite continued fraction expansion with the Ni and the Di all equal to 1 produces 1/phi, where phi is the golden ratio (described in section 1.2.2). One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms. Such a truncation -- a so-called k-term finite continued fraction -- has the form

;(N1 / (D1 + (N2 / ... + (NK / DK)

;Suppose that n and d are procedures of one argument (the term index i) that return the Ni and Di of the terms of the continued fraction. Define a procedure cont-frac such that evaluating (cont-frac n d k) computes the value of the k-term finite continued fraction. Check your procedure by approximating 1/phi using
;(cont-frac (lambda (i) 1.0)
;           (lambda (i) 1.0)
;           k)
;for successive values of k. How large must you make k in order to get an approximation that is accurate to 4 decimal places?

;b. If your cont-frac procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

(define (cont-frac n d k)
  (define (add-ith-term i)
    (if (= i k)
      (/ (n k) (d k))
      (/ (n i) (+ (d i) (add-ith-term (inc i))))))
  (add-ith-term 1))

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           12)
; actual value of 1/golden ratio is 0.61803398875
; It took k=12 to make the computation accurate to 4 decimal places: 0.6180257510729613.

; Now we define the iterative version of the cont-frac procedure.  Due to the way continued fractions are defined, it seems like the only way to store 'state' is to work backwards from the kth term and down to the first term.

(define (cont-frac-iter n d k)
  (define (iter i result)
    (if (= i 1)
        (/ (n i) (+ (d i) result))
        (iter (dec i)
              (/ (n i) (+ (d i) result)))))
  (iter k 0))
(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                12)