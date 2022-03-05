Require Import List.
Import ListNotations.
Set Implicit Arguments.
Locate "*".

(* using general recursion *)
Fixpoint sum  (l : list nat) : nat := 
  match l with 
  | nil => O 
  | (cons h t) => h + sum t
  end.

Check sum.
Print sum.


(* Only works when ListNotations in imported *)
Eval compute in sum [1;2;3].
Eval compute in sum [].
(* Else*)
Eval compute in sum (cons 1 (cons 2(cons 3 nil))).
Eval compute in sum nil.
(**)


(* Exercise 3 *)

(*3.1*)
Theorem sum_app : forall l1 l2, sum (l1 ++ l2) = sum l1 + sum l2.
Proof.
  intros.
  elim l1.
   - simpl. reflexivity.
   - intros. simpl. rewrite H. SearchRewrite (_ + (_ + _)). rewrite PeanoNat.Nat.add_assoc. reflexivity.
Qed.

(*3.2*)
Theorem len_rev : forall (A:Type) (l:list A), length (rev l) = length l.
Proof.
  intros.
  elim l.
   - simpl. reflexivity.
   - intros. simpl. SearchRewrite (length (_ ++ _)). rewrite last_length. rewrite H. reflexivity.
Qed.

(*3.3*)
Theorem map_rev : forall (A B:Type) (f:A->B) (l:list A), rev (map f l) = map f (rev l).
Proof.
 intros.
 elim l.
  - simpl. reflexivity.
  - intros. simpl. SearchRewrite (map _ (_ ++ _)). rewrite map_last. rewrite H. reflexivity.
Qed.

(* Exercise 4 *)


Inductive In (A:Type) (y:A) : list A -> Prop :=
 | InHead : forall (xs:list A), In y (cons y xs)
 | InTail : forall (x:A) (xs:list A), In y xs -> In y (cons x xs).


(*4.1*)

Theorem in_head_or_tail : forall (A:Type) (a b : A) (l : list A), In b (a :: l) -> a = b \/ In b l.
Proof.
 intros.
 inversion H.
  - left. reflexivity.
  - right. assumption.
Qed.

(*4.2*)

Theorem in_app : forall (A:Type) (l1 l2: list A) (x:A), In x l1 \/ In x l2 -> In x (l1 ++ l2).
Proof.
 intros.
 destruct H.
  - induction H; simpl; constructor; assumption.
  - induction l1; simpl; [|constructor]; assumption.
Qed.


(*4.3*)
Theorem in_rev : forall (A:Type) (x:A) (l:list A), In x l -> In x (rev l).
Proof.
 intros.
 induction l.
  - simpl. assumption.
  - simpl. apply in_app. inversion H.
    * right. constructor.
    * left. apply IHl. assumption.
Qed.

(*4.4*)
Theorem in_map: forall (A B:Type) (y:B) (f:A->B) (l:list A), In y (map f l) -> exists x, In x l /\ y = f x.
Proof.
 intros.
 induction l.
  - inversion H.
  - simpl in H. apply in_head_or_tail in H. destruct H.
   * exists a. split; [constructor|rewrite H; reflexivity].
   * destruct IHl.
    +  assumption.
    +  exists x. destruct H0. split.
      -- constructor. assumption.
      --  assumption.
Qed. 


(* Exercise 5 *)

Inductive Prefix (A:Type) : list A -> list A -> Prop :=
| PreNil : forall l:list A, Prefix nil l
| PreCons : forall (x:A) (l1 l2:list A), Prefix l1 l2 -> Prefix (x::l1) (x::l2).

(*5.1*)

Theorem pre_len: forall (A:Type) (l1 l2:list A), Prefix l1 l2 -> length l1 <= length l2.
Proof.
 intros. induction H; simpl; [apply le_0_n | apply le_n_S]. assumption.
Qed.

(*5.2*)

Theorem pre_sum: forall l1 l2, Prefix l1 l2 -> sum l1 <= sum l2.
Proof.
  intros. induction H; simpl.
   - apply le_0_n.
   - apply PeanoNat.Nat.add_le_mono.
    * trivial.
    * assumption.
Qed.

(*5.3*)
Theorem pre_in: forall (A:Type) (l1 l2:list A) (x:A), (In x l1) /\ (Prefix l1 l2) -> In x l2.
Proof.
 intros.
 destruct H as [H1 H2].
 induction H2; inversion H1; constructor. apply IHPrefix. assumption. 
Qed. 

(* Exercise 6 *)

Inductive SubList (A:Type) : list A -> list A -> Prop :=
| SLnil : forall l:list A, SubList nil l
| SLcons1 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList (x::l1) (x::l2)
| SLcons2 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList l1 (x::l2).

(*6.1*)
Theorem cringe: SubList (1::3::nil) (3::1::2::3::4::nil).
Proof.
 repeat constructor.
Qed. 

(*6.2*)
Theorem sub_app: forall (A:Type) (l1 l2 l3 l4:list A), SubList l1 l2 -> SubList l3 l4 -> SubList (l1++l3) (l2++l4).
Admitted.

(*6.3*)
Theorem sub_rev: forall (A:Type) (l1 l2:list A), SubList l1 l2 -> SubList (rev l1) (rev l2).
Proof.
  intros.
  induction H; simpl.
   - constructor.
   - apply sub_app. 
    * assumption.
    * repeat constructor.
   - rewrite app_nil_end with (l := rev l1). apply sub_app.
    * assumption.
    * constructor.
Qed.

(*6.4*)
Theorem sub_in: forall (A:Type) (x:A) (l1 l2:list A), SubList l1 l2 -> In x l1 -> In x l2.
Proof.
  intros.
  induction H; inversion H0; constructor; apply IHSubList; assumption.
Qed.





