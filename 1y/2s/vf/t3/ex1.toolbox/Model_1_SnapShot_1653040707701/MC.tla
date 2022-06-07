---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653040704678125000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653040704678126000 ==
Spec /\ Fairness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653040704678129000 ==
~AllGoCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:58:24 WEST 2022 by vaavaav
