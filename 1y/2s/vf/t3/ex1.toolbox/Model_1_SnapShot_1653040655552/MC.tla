---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653040652539120000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653040652539121000 ==
Spec /\ Fairness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653040652539124000 ==
~AllGoCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:57:32 WEST 2022 by vaavaav
