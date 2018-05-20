#lang sicp

;Exercise 2.43.  Louis Reasoner is having a terrible time doing exercise 2.42. His queens procedure seems to work, but it runs extremely slowly. (Louis never does manage to wait long enough for it to solve even the 6× 6 case.) When Louis asks Eva Lu Ator for help, she points out that he has interchanged the order of the nested mappings in the flatmap, writing it as

;(flatmap
; (lambda (new-row)
;   (map (lambda (rest-of-queens)
;          (adjoin-position new-row k rest-of-queens))
;        (queen-cols (- k 1))))
; (enumerate-interval 1 board-size))

;Explain why this interchange makes the program run slowly. Estimate how long it will take Louis's program to solve the eight-queens puzzle, assuming that the program in exercise 2.42 solves the puzzle in time T.

;Louis's program will take approximately T^T time.  This is because every time the procedure adjoins a new row for a particular column, it needs to make a recursive call to queens-cols.  In particular, it now calls it board-size times for each iteration vs once per iteration.  Because there are board-size iterations, the total number of calls are now approximately board-size^board-size, so it follows that the run time will increase to approximately T^T.