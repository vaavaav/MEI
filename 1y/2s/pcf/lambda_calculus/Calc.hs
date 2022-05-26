-- Different variants of a Calculator 
module Calc where

-- Import of two monads
import DurationMonad
import Probability 

------ Exceptions --------
-- The calculator may raise exceptions



-- Raises an Exception
e :: () -> Maybe a
e = const Nothing

-- A program that can possibly raise an exception.
myDiv :: (Double,Double) -> Maybe Double
myDiv (x,0) = e ()
myDiv (x,y) = return (x / y)


-- Calculates x / (y / z). Note that there are two possible ways
-- of raising an exception.
calc1 :: (Double,Double,Double) -> Maybe Double
calc1 (x,y,z) = (curry (myDiv) x) =<< myDiv (y,z) 

-- Calculates (x / y) / z.
calc2 :: (Double,Double,Double) -> Maybe Double
calc2 (x,y,z) = myDiv (x,y) >>= (flip (curry myDiv) z)

-- A program that can possibly raise an exception.
mysqrt :: Double -> Maybe Double
mysqrt x = if x < 0 then e () else return (sqrt x)


-- Calculates sqrt ( sqrt(x) / y ).
calc3 :: (Double,Double) -> Maybe Double
calc3 (x,y) = mysqrt x >>= flip (curry myDiv) y >>= mysqrt  

------ Durations ---------
-- The calculator takes time to calculate

myDiv' :: (Double,Double) -> Duration Double
myDiv' = wait2 . return . uncurry (/)

-- Calculates x / (y / z) 
calc1' :: (Double,Double,Double) -> Duration Double
calc1' (x,y,z) = (curry (myDiv') x) =<< myDiv' (y,z)

-- Calculates (x / y) / z
calc2' :: (Double,Double,Double) -> Duration Double
calc2' (x,y,z) = myDiv' (x,y) >>= (flip (curry myDiv') z)

mysqrt' :: Double -> Duration Double
mysqrt' = wait1 . return . sqrt 

-- Calculates sqrt ( sqrt(x) / y )
calc3' :: (Double,Double) -> Duration Double
calc3' (x,y) = mysqrt' x >>= flip (curry myDiv') y >>= mysqrt'

------ Non-determinism ---------
-- The calculator nondeterministically outputs wrong values.

nor :: ([a],[a]) -> [a]
nor (l1,l2) = l1 ++ l2

myDiv'' :: (Double,Double) -> [Double]
myDiv'' (x,y) = nor ( return (x / y), return 7 )

-- Calculates x / (y / z) 
calc1'' :: (Double,Double,Double) -> [Double]
calc1'' (x,y,z) = (curry (myDiv'') x) =<< myDiv'' (y,z)

-- Calculates (x / y) / z
calc2'' :: (Double,Double,Double) -> [Double]
calc2'' (x,y,z) = myDiv'' (x,y) >>= (flip (curry myDiv'') z)

mysqrt'' :: Double -> [Double]
mysqrt'' x = nor (return $ sqrt x, return 3.14)

-- Calculates sqrt ( sqrt(x) / y )
calc3'' :: (Double,Double) -> [Double]
calc3'' (x,y) = mysqrt'' x >>= flip (curry myDiv'') y >>= mysqrt''

------ Probabilities ---------
-- The calculator outputs wrong values with a certain probability

por :: (Dist a, Dist a) -> Dist a
por (x,y) = do a <- x
               b <- y
               choose 0.5 a b

myDiv''' :: (Double,Double) -> Dist Double
myDiv''' (x,y) = por ( return (x / y), return 7 )

-- Calculates x / (y / z) 
calc1''' :: (Double,Double,Double) -> Dist Double
calc1''' (x,y,z) = (curry (myDiv''') x) =<< myDiv''' (y,z)

-- Calculates (x / y) / z
calc2''' :: (Double,Double,Double) -> Dist Double
calc2''' (x,y,z) = myDiv''' (x,y) >>= (flip (curry myDiv''') z)

mysqrt''' :: Double -> Dist Double
mysqrt''' x = por (return $ sqrt x, return 3.14)

-- Calculates sqrt ( sqrt(x) / y )
calc3''' :: (Double,Double) -> Dist Double
calc3''' (x,y) = mysqrt''' x >>= flip (curry myDiv''') y >>= mysqrt'''