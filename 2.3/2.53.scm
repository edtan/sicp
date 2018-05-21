#lang sicp
;Exercise 2.53.  What would the interpreter print in response to evaluating each of the following expressions?

;(list 'a 'b 'c)

;(list (list 'george))
;(cdr '((x1 x2) (y1 y2)))

;(cadr '((x1 x2) (y1 y2)))
;(pair? (car '(a short list)))
;(memq 'red '((red shoes) (blue socks)))

;(memq 'red '(red shoes blue socks))


(display (list 'a 'b 'c))
(newline)
;(a b c)

(display (list (list 'george)))
(newline)
;((george))
(display (cdr '((x1 x2) (y1 y2))))
(newline)
;((y1 y2))
;This is because this is a list of lists.  If it were (cdr (cons '(x1 x2) '(y1 y2))), we'd get (y1 y2)

(display (cadr '((x1 x2) (y1 y2))))
(newline)
;(y1 y2)
(display (pair? (car '(a short list))))
(newline)
;false ('a is not a pair)
(display (memq 'red '((red shoes) (blue socks))))
(newline)
;false
(display (memq 'red '(red shoes blue socks)))
(newline)
;(red shoes blue socks)