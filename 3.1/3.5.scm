#lang sicp
;Exercise 3.5.  Monte Carlo integration is a method of estimating definite integrals by means of Monte Carlo simulation. Consider computing the area of a region of space described by a predicate P(x, y) that is true for points (x, y) in the region and false for points not in the region. For example, the region contained within a circle of radius 3 centered at (5, 7) is described by the predicate that tests whether (x - 5)2 + (y - 7)2< 32. To estimate the area of the region described by such a predicate, begin by choosing a rectangle that contains the region. For example, a rectangle with diagonally opposite corners at (2, 4) and (8, 10) contains the circle above. The desired integral is the area of that portion of the rectangle that lies in the region. We can estimate the integral by picking, at random, points (x,y) that lie in the rectangle, and testing P(x, y) for each point to determine whether the point lies in the region. If we try this with many points, then the fraction of points that fall in the region should give an estimate of the proportion of the rectangle that lies in the region. Hence, multiplying this fraction by the area of the entire rectangle should produce an estimate of the integral.

;Implement Monte Carlo integration as a procedure estimate-integral that takes as arguments a predicate P, upper and lower bounds x1, x2, y1, and y2 for the rectangle, and the number of trials to perform in order to produce the estimate. Your procedure should use the same monte-carlo procedure that was used above to estimate pi. Use your estimate-integral to produce an estimate of  by measuring the area of a unit circle.

;You will find it useful to have a procedure that returns a number chosen at random from a given range. The following random-in-range procedure implements this in terms of the random procedure used in section 1.2.6, which returns a nonnegative number less than its input.8

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (estimate-integral P x1 x2 y1 y2 trials)
  (let ((width (- x2 x1))
        (height (- y2 y1)))
    (let ((total-area (* width height)))
      (* 1.0 (* (monte-carlo trials P) total-area)))))

(define (test-unit-circle x1 x2 y1 y2 trials)
  (define (in-unit-circle?)
    (let ((x (random-in-range x1 x2))
          (y (random-in-range y1 y2)))
      (< (+ (* x x) (* y y)) 1)))
  (estimate-integral in-unit-circle? x1 x2 y1 y2 trials))

; I ran this several times, and got various answers:
(test-unit-circle -3 2 -4 5 1000)
;1.17, 1.035, 1.17, 1.035, 0.765, 1.26, 1.125, 0.9
(test-unit-circle -3 2 -4 5 100000)
;1.0017, 1.0107, 1.0179, 1.0161, 0.99585, 1.02285, 0.9918