#lang sicp

;Exercise 2.13.  Show that under the assumption of small percentage tolerances there is a simple formula for the approximate percentage tolerance of the product of two intervals in terms of the tolerances of the factors. You may simplify the problem by assuming that all numbers are positive.

;Let px be the percentage tolerance of x, py be the percentage tolerance of y, z = x*y, and pz the percentage tolerance of z.

;Then,
;x = [x_c - px*x_c  x_c + px*x_c], y = [y_c - py*p_c  y_c + py*y_c]

;pz = [(x_c + px*x_c)*(y_c + py*y_c) - (x_c - px*x_c)*(y_c - py*y_c)] / [2 * (x_c * y_c)]
;   = [x_c * y_c * (1 + px) * (1 + py) - x_c * y_c * (1 - px) * (1 - py)] / [2 * x_c * y_c]
;   = [(1 + px + py + px*py) - (1 - px - py - px*py)] / 2
;   = (2px + 2py) / 2    ; since px and py are small, px*py is negligible and can be removed
;   = px + py

; Therefore, pz = px + py for small px and py.