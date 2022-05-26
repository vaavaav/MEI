module MontyHall where

import Probability 

-- The Monty Hall problem
data Prize = Goat | Car deriving (Show,Eq,Ord)

por' :: (Dist a, Dist a) -> Dist a
por' (x,y) = do a <- x
                b <- y
                choose (2/3) a b

sw :: Prize -> Dist Prize
sw Goat = return Car
sw Car = return Goat

run = do x <- por'(return Goat, return Car); sw x
