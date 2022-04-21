module WProg where

import LTerm
import BTerm

data WProg = Asg String LTerm | Seq WProg WProg | Cond BTerm WProg WProg | While BTerm WProg

pr :: WProg
pr = While ((Var "x") `Geq` (Var "y")) (("x" `Asg` ((Var "x") `Add` (Var "y"))) `Seq` ("y" `Asg` ((Var "y") `Add` (Val 1))))

chMem :: Var -> Double -> (Var -> Double) -> (Var -> Double)
chMem v1 r m v2 
    | v1 == v2 = r
    | otherwise = m v2

wsem :: WProg -> (Var -> Double) -> (Var -> Double)
wsem (Asg v t) m = chMem v (semLT t m) m
wsem (Seq p1 p2) m = let m' = wsem p1 m in wsem p2 m'
wsem (Cond b p1 p2) m = wsem (if bsem b m then p1 else p2) m
wsem (While b p) m = if bsem b m then (wsem (While b p) (wsem p m)) else m
