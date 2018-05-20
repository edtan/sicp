#lang sicp
;Exercise 2.37.  Suppose we represent vectors v = (vi) as sequences of numbers, and matrices m = (mij) as sequences of vectors (the rows of the matrix). For example, the matrix

;[ 1 2 3 4 ]
;[ 4 5 6 6 ]
;[ 6 7 8 9 ]

;is represented as the sequence ((1 2 3 4) (4 5 6 6) (6 7 8 9)). With this representation, we can use sequence operations to concisely express the basic matrix and vector operations. These operations (which are described in any book on matrix algebra) are the following:

;(dot-product v w)  returns the sum Σ_i v_i*w_i;
;(matrix-*-vector m v) returns the vector t, where t_i = Σ_j m_ij*v_j;
;(matrix-*-matrix m n) returns the matrixp ,where p_ij =Σ_k m_ik*n_kj;
;(transpose m) returns the matrix n , where n_ij = m_ji.

;We can define the dot product as

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

;Fill in the missing expressions in the following procedures for computing the other matrix operations. (The procedure accumulate-n is defined in exercise 2.36.)

;(define (matrix-*-vector m v)
;  (map <??> m))
;(define (transpose mat)
;  (accumulate-n <??> <??> mat))
;(define (matrix-*-matrix m n)
;  (let ((cols (transpose n)))
;    (map <??> m)))

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))
(display (matrix-*-vector (list (list 1 2) (list 3 4)) (list 1 2)))
(newline)
;(5 11)

(define (transpose mat)
  (accumulate-n cons nil mat))
(display (transpose (list (list 1 2 3) (list 4 5 6))))
(newline)
;((1 4) (2 5) (3 6))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (m-row)
           (map (lambda (col)
                  (dot-product m-row col))
                  cols))
         m)))

(display (matrix-*-matrix (list (list 1 2 3) (list 4 5 6))
                          (list (list 1 1) (list 1 1) (list 1 1))))
;((6 6) (15 15))