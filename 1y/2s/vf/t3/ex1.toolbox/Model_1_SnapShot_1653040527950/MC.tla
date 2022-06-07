---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653040509831101000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653040509831102000 ==
Spec /\ Fairness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653040509831105000 ==
~AllGoCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:55:09 WEST 2022 by vaavaav
