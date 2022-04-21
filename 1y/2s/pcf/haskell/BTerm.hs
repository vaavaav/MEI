module BTerm where

import LTerm

data BTerm = Geq LTerm LTerm | Conj BTerm BTerm | Neg BTerm deriving Show

bsem :: BTerm -> AState -> Bool
bsem (Geq t1 t2) f = (semLT t1 f) <= (semLT t2 f)
bsem (Conj b1 b2) f = (bsem b1 f) && (bsem b2 f)
bsem (Neg b) f = not (bsem b f)

