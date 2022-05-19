------------------------------ MODULE tcommit ------------------------------

CONSTANT RM       \* The set of participating resource managers

VARIABLE rmState  \* rmState[rm] is the state of resource manager rm.

-----------------------------------------------------------------------------
TCTypeOK == 
  rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]
        
TCInit ==   rmState = [r \in RM |-> "working"]


canCommit == \A r \in RM : rmState[r] \in {"prepared", "committed"}


notCommitted == \A r \in RM : rmState[r] # "committed" 

-----------------------------------------------------------------------------

Prepare(r) == /\ rmState[r] = "working"
              /\ rmState' = [rmState EXCEPT ![r] = "prepared"]

Decide(r)  == \/ /\ rmState[r] = "prepared"
                 /\ canCommit
                 /\ rmState' = [rmState EXCEPT ![r] = "committed"]
              \/ /\ rmState[r] \in {"working", "prepared"}
                 /\ notCommitted
                 /\ rmState' = [rmState EXCEPT ![r] = "aborted"]

TCNext == \E r \in RM : Prepare(r) \/ Decide(r)

-----------------------------------------------------------------------------
TCConsistent ==  

  \A r1, r2 \in RM : ~ /\ rmState[r1] = "aborted"
                       /\ rmState[r2] = "committed"
-----------------------------------------------------------------------------

TCSpec == TCInit /\ [][TCNext]_rmState


THEOREM TCSpec => [](TCTypeOK /\ TCConsistent)

=============================================================================
\* Modification History
\* Last modified Thu May 19 10:17:13 WEST 2022 by vaavaav
\* Created Thu May 19 10:15:54 WEST 2022 by vaavaav
