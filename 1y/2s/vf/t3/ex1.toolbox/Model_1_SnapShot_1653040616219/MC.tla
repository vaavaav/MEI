---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653040614197109000 == 
3
----

\* INIT definition @modelBehaviorNoSpec:0
init_1653040614197110000 ==
FALSE/\flags = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_1653040614197111000 ==
FALSE/\flags' = flags
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:56:54 WEST 2022 by vaavaav
