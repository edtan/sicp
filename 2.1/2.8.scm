#lang sicp

;Exercise 2.8.  Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. Define a corresponding subtraction procedure, called sub-interval.

; When subtracting two intervals, the highest possible value of the new interval would be the upper bound of one interval minus the lower bound of the other interval.  Similarly, the lowest possible value of the new interval would be the lower bound of one interval minus the upper bound of the other interval.

(def (sub-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
                 (- (upper-bound a) (lower-bound b)))