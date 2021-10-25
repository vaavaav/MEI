(set-logic QF_LIA)

(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun z () Int)

(assert (> x 0))
(assert (> y 0))
(assert (> z 0))
(assert (distinct x y z))
(assert (= (+ x y z) 8))
(assert (<= y 3))

; R: z = 2, y = 1, x = 5
(assert (not (= z 2)))
(assert (not (= y 1)))
(assert (not (= x 5)))

; R: z = 4, y = 3, x = 1
(assert (not (= z 4)))
(assert (not (= y 3)))
(assert (not (= x 1)))

(check-sat)
(get-model)
; (get-value (x y))

