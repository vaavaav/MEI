{- Cyber-Physical Programming 2021/2022 - Recalling Haskell.
 - Why Haskell? We will use Haskell in this course to implement 
 - programming languages and respective semantics.
 - Author: Renato Neves.
 - Goal: Solve the exercises listed below.
-}

module LectureCPC where
import Data.Bifunctor
import Data.Char

-- Basic functions and conditionals -- 

-- Implement the function that returns 
-- the maximum of two integers.
max' :: (Int,Int) -> Int
max' (x,y) = if x <= y then y else x  

-- Implement the function that returns 
-- the maximum of three integers.
max3 :: (Int,(Int,Int)) -> Int
max3 = max' . second max'

-- Implement the function that scales 
-- a 2-dimensional real vector by a 
-- real number.
scaleV :: (Double, (Double,Double)) -> (Double, Double)
scaleV = uncurry second . first (*)

-- Implement the function that adds up
-- two 2-dimensional real vectors
addV :: ((Double,Double),(Double,Double)) -> (Double, Double)
addV ((x1,y1),(x2,y2)) = (x1+x2,y1+y2)   

-- Type Synonims
type TSMatrix = ((Double,Double),(Double,Double))
type TVector = (Double,Double)

multM :: (TSMatrix,TVector) -> TVector
multM (((x11,x12),(x21,x22)),(v11,v21)) = (x11*v11+x12*v21, x21*v11+x22*v21) 
--------------------------------------

-- Recursion ------------------------- 

-- Implement the function that calculates
-- the factorial of an integer
fact :: Int -> Int
fact n = product [1..n]

-- Implement the function that return the length
-- of a given list
len :: [a] -> Int
len = foldl (curry (succ . fst)) 0

-- Implement the function that removes all
-- the even numbers from a given list
odds :: [Int] -> [Int]
odds = filter odd

-- Implement Caesar Cypher with shift=3
-- https://en.wikipedia.org/wiki/Caesar_cipher
-- Suggestion: add "import Data.Char", and use
-- the functions "chr" and "ord"
ecode :: String -> String
ecode = map (\c -> if isAlpha c then (if isLower c then shift3a c else shift3A c) else c)
    where shift3A = chr . (+ (ord 'A')) . (`mod` (ord 'A')) . (+3) . ord
          shift3a = chr . (+ (ord 'a')) . (`mod` (ord 'a')) . (+3) . ord

dcode :: String -> String
dcode = map (\c -> if isAlpha c then (if isLower c then shift_3a c else shift_3A c) else c)
    where shift_3A = chr . (+ (ord 'A')) . (`mod` (ord 'A')) . (+ (-3)) . ord
          shift_3a = chr . (+ (ord 'a')) . (`mod` (ord 'a')) . (+ (-3)) . ord

-- Implement the QuickSort algorithm
-- Think how to implement it in your favorite language
-- without using recursion
qSort :: [Int] -> [Int]
qSort = undefined
    where stack = []

-- Implement the solution to the Hanoi problem
-- Think how to implement it in your favorite language
-- without using recursion
hanoi :: Int -> a -> a -> a -> [(a,a)]
hanoi = undefined
-- --------------------------------------

-- Datatypes ----------------------------

-- The datatype of leaf trees
data LTree a = Leaf a | Fork (LTree a, LTree a) deriving Show

outLTree :: LTree a -> Either a (LTree a, LTree a)
outLTree (Leaf a) = Left a
outLTree (Fork t) = Right t

inLTree :: Either a (LTree a, LTree a) -> LTree a
inLTree = either Leaf Fork

cataLTree :: (Either a (b,b) -> b) -> LTree a -> b
cataLTree f = let cf = cataLTree f in f . bimap id (bimap cf cf) . outLTree 

-- Implement the function that increments all values
-- in a given leaf tree
incr :: LTree Int -> LTree Int
incr = cataLTree (inLTree . bimap succ id)

-- Implement the function that counts the number of leafs
-- in a leaf tree 
count :: LTree Int -> Int
count = cataLTree (either id (uncurry (+)))

-- The datatype of binary trees
data BTree a = Empty | Node a (BTree a, BTree a) deriving Show

outBTree :: BTree a -> Either () (a, (BTree a, BTree a))
outBTree Empty = Left ()
outBTree (Node a b) = Right (a,b)

inBTree :: Either () (a, (BTree a, BTree a)) -> BTree a
inBTree = either (const Empty) (uncurry Node)

cataBTree :: (Either () (a, (b, b)) -> b) -> BTree a -> b
cataBTree f = let cf = cataBTree f in f . bimap id (bimap id (bimap cf cf)) . outBTree 

-- Implement the function that increments all values
-- in a given binary tree
bincr :: BTree Int -> BTree Int
bincr = cataBTree (inBTree . bimap id (first succ))

-- Implement the function that counts the number of leafs
-- in a leaf tree 
bcount :: BTree Int -> Int
bcount = cataBTree (either (const 0) ((uncurry (+) . second (uncurry (+)))))


-- The datatype of "full" trees
data FTree a b = Tip a | Join b (FTree a b, FTree a b) deriving Show

outFTree :: FTree a b -> Either a (b, (FTree a b, FTree a b))
outFTree (Tip a) = Left a
outFTree (Join b f) = Right (b,f)

inFTree :: Either a (b, (FTree a b, FTree a b)) -> FTree a b
inFTree = either Tip (uncurry Join)

cataFTree :: (Either a (b, (c, c)) -> c) -> FTree a b -> c
cataFTree f = let cf = cataFTree f in f . bimap id (bimap id (bimap cf cf)) . outFTree 

-- Implement the function that sends a full tree into a leaf tree
fTree2LTree :: FTree a b -> LTree a
fTree2LTree = cataFTree (either Leaf (Fork . snd))

-- Implement the function that sends a full tree into a binary tree
fTree2BTree :: FTree a b -> BTree b 
fTree2BTree = cataFTree (either (const Empty) (uncurry Node))


-- Implement the semantics of the following very simple 
-- language of Arithmetic Expressions
data Vars = X1 | X2
data Ops = Sum | Mult
type AExp = FTree (Either Vars Int) Ops
type AState = Vars -> Int

semA :: (AExp, AState) -> Int 
semA (e,s) = cataFTree (either (either s id) (uncurry h)) e
    where h Sum = uncurry (+)
          h Mult = uncurry (*)

-- The datatype of "rose" trees
data RTree a b = Rtip a | Rjoin b [RTree a b] deriving Show

outRTree :: RTree a b -> Either a (b, [RTree a b])
outRTree (Rtip a) = Left a
outRTree (Rjoin b r) = Right (b,r)

inRTree :: Either a (b, [RTree a b]) -> RTree a b
inRTree = either Rtip (uncurry Rjoin)

cataRTree :: (Either a (b, [c]) -> c) -> RTree a b -> c
cataRTree f = let cf = cataRTree f in f . bimap id (bimap id (map cf)) . outRTree 


-- Implement the semantics of the following very simple 
-- language of Boolean Expressions
data BOps = Disj | Conj | Neg
type BExp = RTree (Either Vars Bool) BOps 
type BState = Vars -> Bool

semB :: (BExp, BState) -> Bool
semB (e,s) = cataRTree (either (either s id) (uncurry h))  e
    where h Disj = or
          h Conj = and
          h Neg = not . and

-- Improve the two previous programming languages by defining
-- data types specific to them
--------------------------------------
