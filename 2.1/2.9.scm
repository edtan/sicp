#lang sicp
;Exercise 2.9.  The width of an interval is half of the difference between its upper and lower bounds. The width is a measure of the uncertainty of the number specified by the interval. For some arithmetic operations the width of the result of combining two intervals is a function only of the widths of the argument intervals, whereas for others the width of the combination is not a function of the widths of the argument intervals. Show that the width of the sum (or difference) of two intervals is a function only of the widths of the intervals being added (or subtracted). Give examples to show that this is not true for multiplication or division.

; Let x and y be two intervals, with their lower and upper bounds as x_l and x_h for x, and y_l and y_h for y.
; The width of these intervals are:
; w_x = (x_h - x_l) / 2
; w_y = (y_h - y_l) / 2
; Let z = x + y
; z = (x_l + y_l, x_h + y_h)
; So the width of z is:
; w_z = ((x_h + y_h) - (x_l + y_l)) / 2
;     = ((x_h - x_l) - (y_h - y_l)) / 2
;     = (w_x + w_y) / 2

; Similarly, for subtraction, let s = x - y
; s = (x_l - y_h, x_h - y_l)
; w_s = ((x_h - y_l) - (x_l - y_h)) / 2
;     = ((x_h - x_l) - (y_l - y_h)) / 2
;     = (w_x + w_y) / 2

; Thus, the widths of the sum and difference of two intervals is a function of just the widths of the original intervals.

; Now, let's take a look at multiplying two intervals of width 1.
; [0 1] * [0 1] = [0 1]
; The widths of the original intervals are 1, and the width of the product is also 1.
; However, look at:
; [1 2] * [1 2] = [1 4]
; The widths of the original intervals are 1, but the width of the product is 3.
; Since the product of two intervals of width 1 have different values as shown above, the product's width can't just be a function of the widths alone.