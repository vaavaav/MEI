-------------------------------- MODULE seq --------------------------------

EXTENDS Integers, Sequences

Remove(i, seq) == 
  [j \in 1..(Len(seq)-1) |-> IF j < i THEN seq[j] 
                                      ELSE seq[j+1]]


=============================================================================
\* Modification History
\* Last modified Fri May 20 00:15:16 WEST 2022 by vaavaav
\* Created Fri May 20 00:15:10 WEST 2022 by vaavaav
