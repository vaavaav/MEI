module LTerm where

type Var = String 
data LTerm = Add LTerm LTerm | Mul Double LTerm | Val Double | Var Var
type AState = Var -> Double

instance Show LTerm where
    show (Add t1 t2) = "(" ++ show t1 ++ ") + (" ++ show t2 ++ ")"
    show (Mul t1 t2) = "(" ++ show t1 ++ ") * (" ++ show t2 ++ ")"
    show (Val r) = show r
    show (Var x) = x
    

semLT :: LTerm -> AState -> Double
semLT (Add t1 t2) s = (semLT t1 s) + (semLT t2 s)
semLT (Mul r t) s = r * semLT t s
semLT (Val r) _ = r
semLT (Var x) f = f x
