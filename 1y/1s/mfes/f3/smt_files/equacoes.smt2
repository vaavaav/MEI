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

(check-sat)
(get-model)
; (get-value (x y))

