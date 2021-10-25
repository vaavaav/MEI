; Unicorn puzzle

(set-logic QF_UF)

(declare-fun mythical () Bool)
(declare-fun immortal () Bool)
(declare-fun mammal () Bool)
(declare-fun horned () Bool)
(declare-fun magical () Bool)

; - If the unicorn is mythical, then it is immortal.
; - If the unicorn is not mythical, then it is a mortal mammal.
; - If the unicorn is either immortal or a mammal, then it is horned. 
; - The unicorn is magical if it is horned.

(assert (=> mythical immortal))
(assert (=> (not mythical) (and (not immortal) mammal)))
(assert (=> (or immortal mammal) horned))
(assert (=> horned magical))

(push)

; - Is the unicorn magical?
(echo "Is the unicorn magical?")

; - Is the unicorn horned?
(echo "Is the unicorn horned?")

; - Is the unicorn mythical?
(echo "Is the unicorn mythical?")



...
