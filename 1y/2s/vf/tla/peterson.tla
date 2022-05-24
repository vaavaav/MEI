------------------------------ MODULE peterson ------------------------------

EXTENDS Integers
VARIABLES flags, turn, pc

vars == <<flags, turn, pc>>

Init == /\ flags = [f \in {0,1} |-> FALSE]
        /\ turn \in {0,1}
        /\ pc = [p \in {0,1} |-> "idle"]

ask(p) == /\ pc[p] = "idle"
          /\ pc' = [pc EXCEPT ![p] = "wait"]
          /\ turn' = 1 - p
          /\ flags' = [flags EXCEPT ![p] = TRUE] 

enter(p) == /\ pc[p] = "wait"
            /\ ~(flags[1 - p] /\ turn = 1 - p)
            /\ pc' = [pc EXCEPT ![p] = "crit"]
            /\ UNCHANGED flags
            /\ UNCHANGED turn

exit(p) == /\ pc[p] = "crit"
           /\ pc' = [pc EXCEPT ![p] = "idle"]
           /\ flags' = [flags EXCEPT ![p] = FALSE]
           /\ UNCHANGED turn
           
Next == ask(0) \/ ask(1) \/ enter(0) \/ enter(1) \/ exit(0) \/ exit(1)
Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

MutualExclusion == [] ~(pc[0] = "crit" /\ pc[1] = "crit")
LockoutFreedom == ((pc[0] = "wait" ~> pc[0] = "crit") /\ (pc[1] = "wait" ~> pc[1] = "crit"))



=============================================================================
\* Modification History
\* Last modified Fri May 20 01:01:29 WEST 2022 by vaavaav
\* Created Fri Apr 29 10:16:40 WEST 2022 by vaavaav
