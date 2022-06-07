---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653041008010136000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1653041008010137000 ==
Spec /\ Fairness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1653041008010140000 ==
~AlwaysEventuallyCritical
----
=============================================================================
\* Modification History
\* Created Fri May 20 11:03:28 WEST 2022 by vaavaav
