------------------------------ MODULE die_hard ------------------------------

EXTENDS Integers

VARIABLES small, big

TypeOK == /\ small \in 0..3
          /\ big \in 0..5

Init == /\ big = 0 
        /\ small = 0
        
FillSmall == /\ small' = 3
             /\ big' = big

FillBig == /\ big' = 5
           /\ small' = small

EmptySmall == /\ small' = 0
              /\ big' = big

EmptyBig == /\ big' = 0
            /\ small' = small
            
SmallToBig == IF big + small <= 5 THEN
                 /\ big' = big + small
                 /\ small' = 0
              ELSE
                 /\ big' = 5
                 /\ small' = big + small - 5

BigToSmall == IF big + small <= 3 THEN
                 /\ small' = big + small 
                 /\ big' = 0
              ELSE
                 /\ small' = 3
                 /\ big' = big + small - 3
        
Next == \/ FillSmall
        \/ FillBig 
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

=============================================================================
\* Modification History
\* Last modified Thu May 19 10:01:54 WEST 2022 by vaavaav
\* Created Thu May 19 09:36:26 WEST 2022 by vaavaav
