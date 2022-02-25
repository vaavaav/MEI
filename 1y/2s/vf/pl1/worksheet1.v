(* Exercise 2 : Lógica Proposicional*)
Section PL.

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

(* Exercise 2.5 *)
Lemma ex2_5 : (A /\ B) \/ (A /\ C) <-> A /\ (B \/ C).
Proof.
  split.
  - intro. split.
    + destruct H as [H1|H2].
      * destruct H1 as [H11 H12]. assumption.
      * destruct H2 as [H21 H22]. assumption.
    + destruct H as [H1|H2].
      * destruct H1 as [H11 H12]. left. assumption.
      * destruct H2 as [H21 H22]. right. assumption.
  - intro. destruct H as [H1 H2]. destruct H2 as [H2|H3].
    + left. split. 
      * assumption.
      * assumption.
    + right. split.
      * assumption.
      * assumption.
Qed.

(* Exercise 2.6 *)
Lemma ex2_6 : (A \/ B) /\ (A \/ C) <-> A \/ (B /\ C).
Proof.
  split.
  - intro. destruct H as [H1 H2]. destruct H1 as [H1|H3].
    + left. assumption.
    + destruct H2 as [H4|H5].
      * left. assumption.
      * right. split. 
        -- assumption.
        -- assumption.
  - apply ex2_4.
Qed.

End PL.

(* Exercise 3: FOL*)

Section FOL.

Variables X Y: Set.
Variables P Q R: X -> Prop.
Variables P' : X -> Y -> Prop.

(* Exercise 3.1 *)
Lemma ex3_1 : (exists x, P x /\ Q x) -> (exists x, P x) /\ (exists x, Q x).
Proof.
  intro.
  destruct H as [x H].
  destruct H as [H1 H2].
  split.
   - exists x. assumption.
   - exists x. assumption.
Qed.

(* Exercise 3.2 *)
Lemma ex3_2 : (exists x, forall y, P' x y) -> forall y, exists x, P' x y.
Proof.
  intro.
  destruct H as [x H].
  intro.
  exists x.
  apply H.
Qed.

(* Exercise 3.3 *)
Lemma ex3_3 : (exists x, P x) -> (forall x, forall y, P x -> Q y) -> forall y, Q y.
Proof.
 intros.
 elim H.
 intro.
 apply H0.
Qed.


(* Exercise 3.4 *)
Lemma ex3_4 : (forall x, Q x -> R x) -> (exists x, P x /\ Q x) -> exists x, P x /\ R x.
Proof.
 intros.
 destruct H0 as [x H0].
 exists x.
 destruct H0 as [H01 H02].
 split.
 - assumption.
 - apply H. assumption.
Qed.

(* Exercise 3.5 *)
Lemma ex3_5 :  (forall x, P x -> Q x) -> (exists x, P x) -> exists y, Q y.
Proof.
 intros.
 destruct H0 as [x H0].
 exists x.
 apply H.
 assumption.
Qed.

(* Exercise 3.6 *)
Lemma ex3_6 :  (exists x, P x) \/ (exists x, Q x) <-> (exists x, P x \/ Q x).
Proof.
 split.
 - intro. destruct H as [H1|H2].
   + destruct H1 as [x H1]. exists x. left. assumption.
   + destruct H2 as [x H2]. exists x. right. assumption.
 - intro. destruct H as [x H]. destruct H as [H1|H2].
   + left. exists x. assumption.
   + right. exists x. assumption.
Qed.


End FOL.


(* Exercise 4: CL*)

Section CL.

Variables A B : Prop.
Variables X : Set.
Variables P : X -> Prop.

Axiom law_of_excluded_middle : forall C : Prop, C \/ ~ C.

(* Exercise 4.1 *)
Lemma ex4_1 : ((A -> B) -> A) -> A.
Proof.
 intros.
 destruct law_of_excluded_middle with A.
 - assumption.
 - apply H. contradiction.
Qed.

(* Exercise 4.2 *)
Lemma ex4_2 : ~~A -> A.
Proof.
 intro.
 destruct law_of_excluded_middle with A.
 - assumption.
 - contradiction.
Qed.

(* Exercise 4.3 *)
Lemma ex4_3 : (~ forall x, P x) -> exists x, ~ P x.
Proof.
Qed.


End CL.



