
;; 4-queens

(set-logic QF_BV)

;; The 4 rows are represented by 4 bitvectors of length 4

(declare-fun r1 () (_ BitVec 4))
(declare-fun r2 () (_ BitVec 4))
(declare-fun r3 () (_ BitVec 4))
(declare-fun r4 () (_ BitVec 4))

;; constrain rows



;; constrain columns


;; constrain diagonals




(check-sat)

