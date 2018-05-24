#lang sicp
;Exercise 2.86.  Suppose we want to handle complex numbers whose real parts, imaginary parts, magnitudes, and angles can be either ordinary numbers, rational numbers, or other numbers we might wish to add to the system. Describe and implement the changes to the system needed to accommodate this. You will have to define operations such as sine and cosine that are generic over ordinary numbers and rational numbers.

;To support this, all selectors of the complex numbers (both rectangular and polar representations) must be able to accept any type of tagged argument and perform generic operations on them.  Next, any operations between two complex numbers need to be defined in terms of the generic arithemtic operations.  Finally, the complex package's 'project operator will need to call the constructor of the type in the hierarchy below it (make-real) with the appropriate type.

; define math functions in terms of generic operations
(define (square x) (apply-generic 'square x))
(define (sqrt-gen x) (apply-generic 'sqrt x))
(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))
(define (atang x) (apply-generic 'atang x))

(define (install-scheme-number-package)
  ;...
  ; we don't define sqrt, sine, cosine, atang for integers, because they won't be precise after we round the answers.
  ; instead, we rely on coercion, and the fact that apply-generic will raise scheme-numbers up the hierarchy to a more precise representation
  (put 'square '(scheme-number)
       (lambda (x) (tag (* x x)))))  

(define (install-rational-package)
  ;...
 ; we don't define sqrt, sine, cosine, atang for rational numbers, because they won't be precise after we round the numerator and denominators.
  ; instead, we rely on coercion, and the fact that apply-generic will raise scheme-numbers up the hierarchy to a more precise representation
  (put 'square '(rational)
       (lambda (x) (tag (make-rat (mul (numer x) (numer x))
                                  (mul (denom x) (denom x))))))
  (put 'sqrt '(rational)
       (lambda (x) (tag (/ (sqrt (numer x)) (sqrt (numer x))))))
  (put 'sine '(rational)
       (lambda (x) (tag (sin (/ (numer x) (denom x)))))
  (put 'cosine '(rational)
       (lambda (x) (tag (cos x))))
  (put 'atang '(rational)
       (lambda (x) (tag (atan x)))))

(define (install-real-package)
  ;...
  (put 'square '(real)
       (lambda (x) (tag (* x x))))
  (put 'sqrt '(real)
       (lambda (x) (tag (sqrt x))))
  (put 'sine '(real)
       (lambda (x) (tag (sin x))))
  (put 'cosine '(real)
       (lambda (x) (tag (cos x))))
  (put 'atang '(real)
       (lambda (x) (tag (atan x)))))


;modify complex number selectors to use generic operators
(define (install-rectangular-package)
  ;...
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (magnitude z)
    (sqrt-gen (add (square (real-part z))       ; change sqrt to sqrt-gen and + to add
               (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))         ; change atan to atang
  (define (make-from-mag-ang r a) 
    (cons (mul r (cosine a)) (mul r (sine a))))       ; change *, sin, and cos to mul, sine, and cosine
  ;...
  )

(define (install-polar-package)
  ;...
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (mul (magnitude z) (cosine (angle z))))      ; change * and cos to mul and cosine
  (define (imag-part z)
    (mul (magnitude z) (sine (angle z))))        ; change * and sin to mul and sine
  (define (make-from-real-imag x y) 
    (cons (sqrt-gen (add (square x) (square y))) ; change sqrt and + and sqrt-gen and add
          (atang y x)))                          ; change atan to atang
  ;...
  )

(define (install-complex-package)
  ;...
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))    ; change + to add
                         (add (imag-part z1) (imag-part z2))))  ; change + to add
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))    ; change - to sub
                         (sub (imag-part z1) (imag-part z2))))  ; change - to sub
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))      ; change * to mul
                       (add (angle z1) (angle z2))))            ; change + to add
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))      ; change / to div
                       (sub (angle z1) (angle z2))))            ; change - to sub
  ;...
  (put 'project '(complex)
       (lambda (x) (make-real (drop (real-part x)))))          ; add in drop.  we may need to change the definition of make-real, depending on whether it already supports tagged arguments already or not 
  )

