#lang sicp

;Exercise 2.42. The ``eight-queens puzzle'' asks how to place eight queens on a chessboard so that no queen is in check from any other (i.e., no two queens are in the same row, column, or diagonal). One possible solution is shown in figure 2.8. One way to solve the puzzle is to work across the board, placing a queen in each column. Once we have placed k - 1 queens, we must place the kth queen in a position where it does not check any of the queens already on the board. We can formulate this approach recursively: Assume that we have already generated the sequence of all possible ways to place k - 1 queens in the first k - 1 columns of the board. For each of these ways, generate an extended set of positions by placing a queen in each row of the kth column. Now filter these, keeping only the positions for which the queen in the kth column is safe with respect to the other queens. This produces the sequence of all ways to place k queens in the first k columns. By continuing this process, we will produce not only one solution, but all solutions to the puzzle.

;We implement this solution as a procedure queens, which returns a sequence of all solutions to the problem of placing n queens on an n× n chessboard. Queens has an internal procedure queen-cols that returns the sequence of all ways to place queens in the first k columns of the board.

;(define (queens board-size)
;  (define (queen-cols k)  
;    (if (= k 0)
;        (list empty-board)
;        (filter
;         (lambda (positions) (safe? k positions))
;         (flatmap
;          (lambda (rest-of-queens)
;            (map (lambda (new-row)
;                   (adjoin-position new-row k rest-of-queens))
;                 (enumerate-interval 1 board-size)))
;          (queen-cols (- k 1))))))
;  (queen-cols board-size))

;In this procedure rest-of-queens is a way to place k - 1 queens in the first k - 1 columns, and new-row is a proposed row in which to place the queen for the kth column. Complete the program by implementing the representation for sets of board positions, including the procedure adjoin-position, which adjoins a new row-column position to a set of positions, and empty-board, which represents an empty set of positions. You must also write the procedure safe?, which determines for a set of positions, whether the queen in the kth column is safe with respect to the others. (Note that we need only check whether the new queen is safe -- the other queens are already guaranteed safe with respect to each other.)

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))
(define (dot-product v w)
  (accumulate + 0 (map * v w)))


; This one took a while.  The main problem was that I chose a bad representation at the beginning - I initially used a list of lists denoting a matrix, with 0s meaning the absence of a queen, and a 1 meaning the presence of a queen.  Once I had simplified the representation, this problem was straightforward to implement.

; Let the representation for a single position be a list of numbers, where the jth entry represents the jth column, and the value of the jth entry indicates which row the queen is on.  (This assumes that there is only 1 queen per column.)  If there are no queens in the (j+1)th column up to the board-sizeth column, the (j+1)th up to the board-size entries can be omitted from the representation.  For example, if board-size = 3 and we have the following position:
;0 0 0
;0 1 0
;1 0 0
;this is represented by (3 2).

; as described in the problem, empty-board means an empty set of positions, which also corresponds to a position with no queens according to our representation.  note that this is transformed into (list nil) for us in the provided definition of queens
(define (empty-board) nil)

; adjoin-position takes a position that only has queens in the first (column - 1) columns (i.e. a list with only (column - 1) sublists).
; it then creates a new position by adding a queen in the new-rowth row in the columnth column.
; WARNING: if you set column to a column within the position, it will truncate the position to the length of column
(define (adjoin-position new-row column position)
  (cond ((and (null? position) (> column 1))
         (cons 0 (adjoin-position new-row (- column 1) nil)))  ; fill in 0s if columns don't already exist for them and we're putting a queen in a column further up
         ((= column 1) (cons new-row nil))   ; set column to new-row
         (else (cons (car position) (adjoin-position new-row (- column 1) (cdr position))))))

;(display (adjoin-position 1 1 (list nil)))
;(newline)
;(1)
;(display (adjoin-position 3 2 (list 1)))
;(newline)
;(1 3)

;(display (adjoin-position 5 5 (list 1 2 3)))
;(newline)
;(1 2 3 0 5)

; safe checks if the queen in the kth column is safe, given a position consisting of queens only in the first k columns (1 per column), and where the queens in the first k-1 columns are all safe with respect to each other.
(define (safe? k position)
  (define (same-row? col1 col2) (= col1 col2))
  (define (same-diag? queen1-row queen1-col queen2-row queen2-col)
    (let ((col-diff (- queen2-col queen1-col)))
      (cond ((or (= (+ queen1-row col-diff) queen2-row)
                 (= (- queen1-row col-diff) queen2-row))
             true)
            (else false))))
  (let ((kth-col (list-ref position (- k 1))))
    (accumulate (lambda (x y) (and x y))
                true
                (map (lambda (i)
                       (let ((ith-col (list-ref position (- i 1))))
                         (and (not (same-row? ith-col kth-col))
                              (not (same-diag? ith-col i kth-col k)))))
                     (enumerate-interval 1 (- k 1))))))


;(flatmap
;          (lambda (rest-of-queens)
;            (map (lambda (new-row)
;                   (adjoin-position new-row 1 rest-of-queens))
;                 (enumerate-interval 1 3)))
;          nil)


(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(display (queens 1))
(newline)
;((1))
(display (queens 2))
(newline)
;()
(display (queens 3))
(newline)
;()
(display (queens 4))
(newline)
;((2 4 1 3) (3 1 4 2))
(display (queens 5))
(newline)
;((1 3 5 2 4) (1 4 2 5 3) (2 4 1 3 5) (2 5 3 1 4) (3 1 4 2 5) (3 5 2 4 1) (4 1 3 5 2) (4 2 5 3 1) (5 2 4 1 3) (5 3 1 4 2))
(display (queens 6))
(newline)
;((2 4 6 1 3 5) (3 6 2 5 1 4) (4 1 5 2 6 3) (5 3 1 6 4 2))
(display (length (queens 7)))
(newline)
;40
(display (length (queens 8)))
(newline)
;92
(length (queens 10))
;724