----------------------------- MODULE PaxosCommit ----------------------------

EXTENDS Integers

Maximum(S) == 
  IF S = {} THEN -1
            ELSE CHOOSE n \in S : \A m \in S : n \geq m

CONSTANT RM,             \* The set of resource managers.
         Acceptor,       \* The set of acceptors.
         Majority,       \* The set of majorities of acceptors
         Ballot          \* The set of ballot numbers


ASSUME  
  /\ Ballot \subseteq Nat
  /\ 0 \in Ballot
  /\ Majority \subseteq SUBSET Acceptor
  /\ \A MS1, MS2 \in Majority : MS1 \cap MS2 # {}

       
Messages ==

  [type : {"phase1a"}, ins : RM, bal : Ballot \ {0}] 
      \cup
  [type : {"phase1b"}, ins : RM, mbal : Ballot, bal : Ballot \cup {-1},
   val : {"prepared", "aborted", "none"}, acc : Acceptor] 
      \cup
  [type : {"phase2a"}, ins : RM, bal : Ballot, val : {"prepared", "aborted"}]
      \cup                              
  [type : {"phase2b"}, acc : Acceptor, ins : RM, bal : Ballot,  
   val : {"prepared", "aborted"}] 
      \cup
  [type : {"Commit", "Abort"}]
-----------------------------------------------------------------------------
VARIABLES
  rmState,  \* rmState[r] is the state of resource manager r.
  aState,   \* aState[ins][ac] is the state of acceptor ac for instance 
            \* ins of the Paxos algorithm. 
  msgs      \* The set of all messages ever sent.

PCTypeOK ==  
  /\ rmState \in [RM -> {"working", "prepared", "committed", "aborted"}]
  /\ aState  \in [RM -> [Acceptor -> [mbal : Ballot,
                                      bal  : Ballot \cup {-1},
                                      val  : {"prepared", "aborted", "none"}]]]
  /\ msgs \subseteq Messages

PCInit ==  \* The initial predicate.
  /\ rmState = [r \in RM |-> "working"]
  /\ aState  = [r \in RM |-> 
                 [ac \in Acceptor 
                    |-> [mbal |-> 0, bal  |-> -1, val  |-> "none"]]]
  /\ msgs = {}
-----------------------------------------------------------------------------

Send(m) == msgs' = msgs \cup {m}

-----------------------------------------------------------------------------

RMPrepare(r) == 
  /\ rmState[r] = "working"
  /\ rmState' = [rmState EXCEPT ![r] = "prepared"]
  /\ Send([type |-> "phase2a", ins |-> r, bal |-> 0, val |-> "prepared"])
  /\ UNCHANGED aState
  
RMChooseToAbort(r) ==
  /\ rmState[r] = "working"
  /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
  /\ Send([type |-> "phase2a", ins |-> r, bal |-> 0, val |-> "aborted"])
  /\ UNCHANGED aState

RMRcvCommitMsg(r) ==
  /\ [type |-> "Commit"] \in msgs
  /\ rmState' = [rmState EXCEPT ![r] = "committed"]
  /\ UNCHANGED <<aState, msgs>>

RMRcvAbortMsg(r) ==
  /\ [type |-> "Abort"] \in msgs
  /\ rmState' = [rmState EXCEPT ![r] = "aborted"]
  /\ UNCHANGED <<aState, msgs>>
-----------------------------------------------------------------------------

Phase1a(bal, r) ==

  /\ Send([type |-> "phase1a", ins |-> r, bal |-> bal])
  /\ UNCHANGED <<rmState, aState>>

Phase2a(bal, r) ==

  /\ ~\E m \in msgs : /\ m.type = "phase2a"
                      /\ m.bal = bal
                      /\ m.ins = r
  /\ \E MS \in Majority :    
        LET mset == {m \in msgs : /\ m.type = "phase1b"
                                  /\ m.ins  = r
                                  /\ m.mbal = bal 
                                  /\ m.acc  \in MS}
            maxbal == Maximum({m.bal : m \in mset})
            val == IF maxbal = -1 
                     THEN "aborted"
                     ELSE (CHOOSE m \in mset : m.bal = maxbal).val
        IN  /\ \A ac \in MS : \E m \in mset : m.acc = ac
            /\ Send([type |-> "phase2a", ins |-> r, bal |-> bal, val |-> val])
  /\ UNCHANGED <<rmState, aState>>

PCDecide == 
  /\ LET Decided(r, v) ==
           \E b \in Ballot, MS \in Majority : 
             \A ac \in MS : [type |-> "phase2b", ins |-> r, 
                              bal |-> b, val |-> v, acc |-> ac ] \in msgs
     IN  \/ /\ \A r \in RM : Decided(r, "prepared")
            /\ Send([type |-> "Commit"])
         \/ /\ \E r \in RM : Decided(r, "aborted")
            /\ Send([type |-> "Abort"])
  /\ UNCHANGED <<rmState, aState>>
-----------------------------------------------------------------------------
Phase1b(acc) ==  
  \E m \in msgs : 
    /\ m.type = "phase1a"
    /\ aState[m.ins][acc].mbal < m.bal
    /\ aState' = [aState EXCEPT ![m.ins][acc].mbal = m.bal]
    /\ Send([type |-> "phase1b", 
             ins  |-> m.ins, 
             mbal |-> m.bal, 
             bal  |-> aState[m.ins][acc].bal, 
             val  |-> aState[m.ins][acc].val,
             acc  |-> acc])
    /\ UNCHANGED rmState

Phase2b(acc) == 
  /\ \E m \in msgs : 
       /\ m.type = "phase2a"
       /\ aState[m.ins][acc].mbal \leq m.bal
       /\ aState' = [aState EXCEPT ![m.ins][acc].mbal = m.bal,
                                   ![m.ins][acc].bal  = m.bal,
                                   ![m.ins][acc].val  = m.val]
       /\ Send([type |-> "phase2b", ins |-> m.ins, bal |-> m.bal, 
                  val |-> m.val, acc |-> acc])
  /\ UNCHANGED rmState
-----------------------------------------------------------------------------
PCNext ==  \* The next-state action
  \/ \E r \in RM : \/ RMPrepare(r) 
                   \/ RMChooseToAbort(r) 
                   \/ RMRcvCommitMsg(r) 
                   \/ RMRcvAbortMsg(r)
  \/ \E bal \in Ballot \ {0}, r \in RM : Phase1a(bal, r) \/ Phase2a(bal, r)
  \/ PCDecide
  \/ \E acc \in Acceptor : Phase1b(acc) \/ Phase2b(acc) 
-----------------------------------------------------------------------------

PCSpec == PCInit /\ [][PCNext]_<<rmState, aState, msgs>>


THEOREM PCSpec => []PCTypeOK
-----------------------------------------------------------------------------

INSTANCE tcommit

THEOREM PCSpec => TCSpec
=============================================================================
