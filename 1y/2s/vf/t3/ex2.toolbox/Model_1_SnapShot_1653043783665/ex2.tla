-------------------------------- MODULE ex2 --------------------------------

EXTENDS Integers, Sequences

CONSTANT N, V

ASSUME N >= 1
ASSUME V > 0

VARIABLES channel, \* canal de comunicação
          ages


----------------------------------------------------------------------------

TypeOK == (\A i \in 1..N : ages[i] \in 0..N)

----------------------------------------------------------------------------

send(v) == \E i \in 1..N : ages[i] = 0 => 
            /\ channel' = [channel EXCEPT ![i] = v]
            /\ (\A j \in 1..i-1 : IF ages[j] > 0 THEN ages'[j] = ages[j] + 1 ELSE ages'[j] = ages[j])
            /\ ages'[i] = 1
            /\ (\A j \in (i+1)..N : IF ages[j] > 0 THEN ages'[j] = ages[j] + 1 ELSE ages'[j] = ages[j])

read(v) == \E i \in 1..N : channel[i] = v /\ ages[i] > 0 /\ (\A j \in 1..N : ages[i] >= ages[j]) 
            => ages' = [ages EXCEPT ![i] = 0]

Init == ages = [i \in 1..N |-> 0]

Next == \E v \in 0..(V-1) : send(v) \/ read(v)

---------------------------------------------------------------------------

\* (b) O canal nunca contém valores inválidos

Valid == \A i \in 1..N : ages[i] > 0 => channel[i] \in 0..(V-1)

---------------------------------------------------------------------------

\* (c) Dizemos que caso o canal fique cheio nunca fica vazio, assim a ferramenta dá um contra exemplo.

NeverEmptiesIfFilled == ~( (\A i \in 1..N : ages[i] > 0) ~> ~(\E i \in 1..N : ages[i] > 0))







=============================================================================
\* Modification History
\* Last modified Fri May 20 11:49:04 WEST 2022 by vaavaav
\* Created Fri May 20 11:05:21 WEST 2022 by vaavaav
