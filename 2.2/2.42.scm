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


; Let the representation for a single position be a list of lists, where the jth list represents the jth column, the ith entry in that list represents the ith row, an entry of 0 represents the absence of a queen in that location, and a 1 means a queen is present in that location.  Also, if there are no queens in the (j+1)th column up to the board-size column, the (j+1)th up to the board-size lists can be omitted from the representation.  For example, if board-size = 3 and we have the following position:
;0 0 0
;1 1 0
;0 0 0
;this can be represented by ((0 1 0) (0 1 0) (0 0 0)), or also ((0 1 0) (0 1 0)).  Due to the way the n-queens algorithm described in the problem works, we only need to use the latter representation.

; as described in the problem, empty-board means an empty set of positions, which also corresponds to a position with no queens according to our representation.
(define (empty-board) nil)

; adjoin-position takes a position that only has queens in the first (column - 1) columns (i.e. a list with only (column - 1) sublists).
; it then creates a new position by adding a queen in the new-rowth row in the columnth column.  (it adds a list with a 1 in the new-rowth entry)
; TODO: it looks like the column parameter isn't used, perhaps due to our representation. (it would be used if we didn't admit representations that had fewer than board-size columns).  it could possibly be used for error checking.
(define (adjoin-position new-row column position)
  (let ((board-size (if (null? position)
                         0
                         (length (car position)))))
    (append position
            (list (map (lambda (x) (if (= x new-row)
                                       1
                                       0))
                       (enumerate-interval 1 board-size))))))

(adjoin-position 1 1 nil)

(display (adjoin-position 3 2 (list (list 1 2 3 4 5))))
(newline)
;((1 2 3 4 5) (0 0 1 0 0))

(display (adjoin-position 5 2 (list (list 1 2 3 4 5) (list 4 3 0 0 0))))
(newline)
;((1 2 3 4 5) (4 3 0 0 0) (0 0 0 0 1))

; safe checks if the queen in the kth column is safe, given a position consisting of queens only in the first k columns (1 per column), and where the queens in the first k-1 columns are all safe with respect to each other.
(define (safe? k position)
  (define (same-row? col1 col2) (= (dot-product col1 col2) 1)) ; ones lined up in the same position indicate the same row
  (define (row column)                                         ; return the row number of the queen in a given column
    (if (or (null? column) (= (car column) 1))
        1
        (+ 1 (row (cdr column)))))
  (define (same-diag? col1 col1-idx col2 col2-idx)
    (let ((col1-row-idx (row col1))
          (col2-row-idx (row col2))
          (col-diff (- col2-idx col1-idx)))
      (cond ((or (= (+ col1-row-idx col-diff) col2-row-idx)
                 (= (- col1-row-idx col-diff) col2-row-idx))
             false)
            (else true))))
  (let ((kth-col (list-ref position (- k 1))))
    (accumulate (lambda (x y) (and x y))
                true
                (map (lambda (i)
                       (let ((ith-col (list-ref position (- i 1))))
                         (and (not (same-row? (ith-col kth-col)))
                              (not (same-diag? (ith-col i kth-col k))))))
                     (enumerate-interval 1 (- k 1))))))


(flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row 1 rest-of-queens))
                 (enumerate-interval 1 3)))
          nil)


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

;(queens 1)