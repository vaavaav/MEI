

Set Implicit Arguments.


Require Import List.
Require Import ZArith.
Require Import Lia.




Section Parte1.
(* Prove os lemas desta secção SEM usar táticas automáticas *)

Variables A B C D : Prop.
Variable X : Set.
Variables P W Q : X -> Prop.

Lemma questao1 : (A->B) /\ (C->D) -> (A\/C) -> (B\/D).
Proof.
 intros.
 destruct H.
 destruct H0.
 - left. apply H. assumption.
 - right. apply H1. assumption.
Qed.



Lemma questao2 : (A /\ B) -> ~(~A \/ ~B).
Proof.
 intros H H1.
 destruct H.
 destruct H1. 
  - contradiction.
  - contradiction.
Qed.



Lemma questao3 : (forall x:X, (P x) -> (Q x)) -> (forall y:X, ~(Q y)) -> (forall x:X, ~(P x)).
Proof.
 intros.
 red.
 intros.
 apply H in H1. 
 red in H0. apply H0 in H1.
 contradiction. 
Qed.




Lemma questao4 :  (forall z:X, (P z)-> (W z)) -> (exists x:X, (P x)/\(Q x)) -> (exists y:X, (W y)/\(Q y)).
Proof.
 intros.
 destruct H0.
 destruct H0.
 exists x.
 split.
  - apply H. assumption.
  - assumption. 
Qed.



Lemma questao5 : forall (x y:nat), x + 3 = y -> x < y.
Proof.
 intros.
 SearchRewrite (_ + 0) .
 rewrite plus_n_O with (n := x).
 induction H.
 SearchPattern (_ + _ < _ + _).
 apply plus_lt_compat_l.
 SearchPattern (0 < _).
 apply Nat.lt_0_succ.
Qed.



End Parte1.




Open Scope Z_scope.


Section Parte2.
(* ================================================================== *)
(* Prove os lemas desta secção. Pode usar táticas automáticas.        *)
(* Se precisar de definir lemas auxiliares, deverá também prova-los.  *)


Inductive In (A:Type) (y:A) : list A -> Prop :=
| InHead : forall (xs:list A), In y (cons y xs)
| InTail : forall (x:A) (xs:list A), In y xs -> In y (cons x xs).


Inductive Suffix (A:Type) : list A -> list A -> Prop :=
| Suf0 : forall (l:list A), Suffix nil l
| Suf1 : forall (x:A) (l1 l2:list A), Suffix l1 l2 -> Suffix (x::l1) (x::l2)
| Suf2 : forall (x:A) (l1 l2:list A), Suffix l1 l2 -> Suffix (l1) (x::l2).


Inductive Menores (x:Z) : list Z -> Prop :=
| Men_nil : Menores x nil
| Men_cons : forall (l:list Z) (y:Z), y < x -> Menores x l -> Menores x (y::l).



Fixpoint drop (A:Type)(n:nat) (l:list A) : list A :=
  match n with
  | O => l
  | S x => match l with
           | nil => nil
           | y::ys => drop x ys
           end
  end.


Fixpoint delete (x:Z) (l:list Z)  : list Z :=
  match l with
  | nil => nil
  | (h :: t) => if (Z.eq_dec x h) then t else h :: delete x t
  end.


Lemma  questao6 : forall (A:Type) (l:list A),  drop (length l) l = nil.
Proof.
 intros.
 induction l.
 - simpl. reflexivity.
 - simpl. assumption.
Qed.



Lemma questao7 : forall (A: Type) (x: A) (l: list A),
         In x l ->  exists l1: list A, exists l2: list A, l = l1 ++ (x :: l2).
Proof.
 intros.
 induction H.
  - exists nil. exists xs. simpl. reflexivity.
  - destruct IHIn as [l1 [l2 H1]]. rewrite H1. exists (x0::l1). exists l2. reflexivity.
Qed.



Lemma questao8 : forall (x:Z) (l1 l2:list Z),  Menores x l2 /\ Suffix l1 l2 -> Menores x l1.
Proof.
 intros. 
 destruct H.
 induction H0.
  - constructor.
  - inversion H. constructor. 
   * assumption.
   * apply IHSuffix. assumption.
  - apply IHSuffix. inversion H. assumption.
Qed.


Lemma questao9 : forall (x:Z) (l:list Z), In x l -> (length (delete x l) < length l)%nat.
Proof.
 intros.
 induction l.
  - inversion H.
  - simpl. elim (Z.eq_dec  x a).
   * intros. lia.
   * intros. simpl. Search (S _ < S _)%nat. apply lt_n_S. apply IHl. inversion H.
    + contradiction.
    + assumption.
Qed.



End Parte2.

Close Scope Z_scope.




Section Parte3.
(* ================================================================== *)
(* Considere as funções abaixo definidas e prove o teorema.           *)
(* Pode usar táticas automáticas.                                     *)
(* Se precisar de definir lemas auxiliares, deverá também prova-los.  *)



Fixpoint numOc (a:nat) (l: list (nat*nat)) : nat :=
  match l with
  | nil => 0 
  | ((x,n)::xs) => if (Nat.eq_dec a x) then n else numOc a xs
  end.


Fixpoint insN (a n:nat) (l: list (nat*nat)) : list (nat*nat) :=
  match l with
  | nil => (a,n)::nil
  | ((x,n1)::xs) => if (Nat.eq_dec a x) then  ((x,n+n1)::xs) else (x,n1) :: insN a n xs
  end.                                                         



Theorem questao10 : forall x n l, n <= numOc x (insN x n l).
Proof.
 intros.
 induction l.
  - simpl. elim (Nat.eq_dec x x).
   + intros. trivial.
   + intros. contradiction.
  - induction numOc.
   + Search (_ <= 0). apply le_n_0_eq in IHl. rewrite <- IHl. Search (0 <= _). apply Nat.le_0_l.
Qed.



End Parte3.
