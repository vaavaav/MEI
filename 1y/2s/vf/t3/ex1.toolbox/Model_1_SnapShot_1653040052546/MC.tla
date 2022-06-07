---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_165304003351996000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_165304003351997000 ==
Spec /\ Fairness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653040033519100000 ==
~AllGoCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:47:13 WEST 2022 by vaavaav
