(* Exercise 2 *)

Variables (A:Prop) (B:Prop) (C:Prop).

(* Exercise 2.1 *)
Lemma ex2_1 : (A \/ B) \/ C -> A \/ (B \/ C).
Proof.
  intro.
  destruct H as [H1|H2].
  - destruct H1 as [H11|H12].
    + left. assumption.
    + right. left. assumption.
  - right. right. assumption.
Qed.


(* Exercise 2.2 *)
Lemma ex2_2 : (B -> C) -> A \/ B -> A \/ C.
Proof.
  intros.
  destruct H0 as [H1|H2].
  - left. assumption.
  - right. apply H. assumption.
Qed.



(* Exercise 2.3 *)
Lemma ex2_3 : (A /\ B) /\ C -> A /\ (B /\ C).
Proof.
  intro.
  destruct H as [H1 H2].
  destruct H1 as [H11 H12].
  split.
  - assumption.
  - split.
    + assumption.
    + assumption.
Qed.

(* Exercise 2.4 *)
Lemma ex2_4 : A \/ (B /\ C) -> (A \/ B) /\ (A \/ C).
Proof.
  intro.
  split.
    - destruct H as [H1|H2].
      + left. assumption.
      + destruct H2 as [H21 H22]. right. assumption.
    - destruct H as [H1|H2].
      + left. assumption.
      + destruct H2 as [H21 H22]. right. assumption.
Qed.
