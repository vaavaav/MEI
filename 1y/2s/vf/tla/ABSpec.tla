------------------------------ MODULE ABSpec --------------------------------
EXTENDS Integers

CONSTANT Data  \* The set of all possible data values.

VARIABLES AVar,   \* The last <<value, bit>> pair A decided to send.
          BVar    \* The last <<value, bit>> pair B received.
          

TypeOK == /\ AVar \in Data \X {0,1}
          /\ BVar \in Data \X {0,1}

vars == << AVar, BVar >>


Init == /\ AVar \in Data \X {1} 
        /\ BVar = AVar

A == /\ AVar = BVar
     /\ \E d \in Data: AVar' = <<d, 1 - AVar[2]>>
     /\ BVar' = BVar

B == /\ AVar # BVar
     /\ BVar' = AVar
     /\ AVar' = AVar

Next == A \/ B

Spec == Init /\ [][Next]_vars


Inv == (AVar[2] = BVar[2]) => (AVar = BVar)
-----------------------------------------------------------------------------

FairSpec == Spec /\ WF_vars(Next) 
=============================================================================
\* Modification History
\* Last modified Fri May 20 00:23:25 WEST 2022 by vaavaav
\* Last modified Wed Oct 18 04:07:37 PDT 2017 by lamport
\* Created Fri Sep 04 07:08:22 PDT 2015 by lamport

