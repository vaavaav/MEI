(set-logic QF_UFLIA)

(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun z () Int)

(assert (distinct x y z))
(assert (> (+ x y) (* 2 z)))
(assert (>= x 0))
(assert (>= y 0))
(assert (>= z 0))

(check-sat)
(get-model)
(get-value (x y z))
