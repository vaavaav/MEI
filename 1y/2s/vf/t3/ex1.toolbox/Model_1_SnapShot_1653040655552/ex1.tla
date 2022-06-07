-------------------------------- MODULE ex1 --------------------------------

EXTENDS Integers, Sequences

CONSTANT N

ASSUME N >= 1

VARIABLES flags, isCritical

----------------------------------------------------------------

TypeOK == (\A i \in 1..N : flags[i] \in 0..4)
       /\ (\A i \in 1..N : isCritical[i] \in {TRUE,FALSE})

----------------------------------------------------------------


idle(i) == flags[i] = 0
        /\ flags' = [flags EXCEPT ![i] = 1]
        /\ UNCHANGED isCritical

wait0(i) == flags[i] = 1
         /\ (\A k \in 1..N : flags[k] \in {0,1,2})
         /\ flags' = [flags EXCEPT ![i] = 3]
         /\ UNCHANGED isCritical
                                 

wait1(i) == flags[i] = 2
         /\ \E k \in 1..N : flags[k] = 4
         /\ flags' = [flags EXCEPT ![i] = 4]
         /\ UNCHANGED isCritical

check(i) == flags[i] = 3
         /\ UNCHANGED isCritical       
         /\ IF \E k \in 1..N : flags[k] = 1 THEN
               flags' = [flags EXCEPT ![i] = 2]
            ELSE
               flags' = [flags EXCEPT ![i] = 4]

wait2(i) == flags[i] = 4
         /\ (\A k \in 1..(i-1) : flags[k] \in {0,1})
         /\ isCritical' = [isCritical EXCEPT ![i] = TRUE]
         /\ UNCHANGED flags

critical(i) == isCritical[i]
            /\ (\A k \in (i+1)..N : flags[k] \in {0,1,4})
            /\ flags' = [flags EXCEPT ![i] = 0]
            /\ isCritical' = [isCritical EXCEPT ![i] = FALSE]

Init == flags = [i \in 1..N |-> 0]
     /\ isCritical = [i \in 1..N |-> FALSE]


Next == \E p \in 1..N : idle(p) \/ wait0(p) \/ wait1(p) \/ check(p) \/ wait2(p) \/ critical(p)

Spec == Init /\ [][Next]_<<flags, isCritical>>

-----------------------------------------------------------------------------

\* (b) Por um lado, não precisamos do program counter uma vez que os valores das flags já praticamente localizam 
\*   em que local do programa cada processo se encontram.
\*   Por outro, é preciso alguma flag extra que diferencie o wait2 do critical, para isso eu criei o isCritical.
\* Por isso, provavelmente no mínimo 2 valores seriam necessários (wait2 e critical) (neste caso uso booleanos). 

-----------------------------------------------------------------------------

\* (c) Garantir exclusão mútua

MutualExclusion == [] (\A i,j \in 1..N: (i # j /\ isCritical[i]) => ~isCritical[j])

-----------------------------------------------------------------------------

\* (d) Garantir que nenhum processo espera indefinidamente:
\*   Se um processo p entre sempre repetidamente na região crítica, então inevitavelmente a ação critical é enabled.

Fairness == \A p \in 1..N : SF_<<flags, isCritical>>(critical(p))

-----------------------------------------------------------------------------

\* (e) Para obter um exemplo onde todos entram na região crítica, basta criar um invariante que nega essa afirmação para assim
\*    a ferramente mostrar um contra exemplo

AllGoCritical == \A p \in 1..N : (~isCritical[p] ~> isCritical[p]) 

\* agora mete-se ~AllGoCritical como propriedade

-----------------------------------------------------------------------------

\* (f)



=============================================================================
\* Modification History
\* Last modified Fri May 20 10:57:30 WEST 2022 by vaavaav
\* Created Fri May 20 09:01:12 WEST 2022 by vaavaav
