---- MODULE MC ----
EXTENDS ex1, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1653040640540112000 == 
3
----

\* INIT definition @modelBehaviorNoSpec:0
init_1653040640540113000 ==
FALSE/\flags = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_1653040640540114000 ==
FALSE/\flags' = flags
----
=============================================================================
\* Modification History
\* Created Fri May 20 10:57:20 WEST 2022 by vaavaav
