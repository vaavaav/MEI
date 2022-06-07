---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653041096666164000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653041096666165000 ==
Spec /\ Fairness /\ EventuallyCritical
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653041096666168000 ==
~AlwaysEventuallyCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 11:04:56 WEST 2022 by vaavaav
