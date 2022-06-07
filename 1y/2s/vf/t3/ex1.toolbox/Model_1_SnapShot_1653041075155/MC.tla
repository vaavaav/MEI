---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653041071137159000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653041071137160000 ==
Spec /\ Fairness /\ EventuallyCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 11:04:31 WEST 2022 by vaavaav
