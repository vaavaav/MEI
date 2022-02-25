Require Import ZArith.

(* ================================================================== *)
(* ================ Coq as a Programming Language =================== *)

(* prints the definition of an identifier *)
Print nat.

(* check the type of the nat recursors / eliminators *)
Check nat_rect.
Check nat_ind.
Check nat_rec.


(* check the type of an expression *)
Check S (S O).


(* defining new constants *)

(* using the eliminators *)
Definition double : nat->nat := nat_rec (fun _ => nat) 0 (fun x y => S (S y)).

Check double.
Print double.

(* using general recursion *)
Fixpoint double'  (n : nat) : nat := 
  match n with 
  | O => O 
  | S x => S (S (double' x))
  end.

Definition triple := fun x : nat => x + (double x).

Definition quadruple (x:nat) : nat := (double' x) + (double' x).

Check triple.

(* performs evaluation of an expression
   strategy: call-by-value;  reductions: delta*)
Eval cbv delta [double] in (double 22).

(* "Eval compute" is equivalent to "Eval cbv delta beta iota zeta" *) 
Eval compute in (double 22).

Eval compute in (double' 15).

Eval compute in triple (double 10).

Eval compute in (quadruple 5).


(* ================================================================== *)
(* ================== Interpretation Scopes ========================= *)


(* some notations are overloaded *)

(* to find the function hidden behind a notation *)
Locate "+".
Locate "*".

Print Scope nat_scope.
Print Scope Z_scope.


Check 3.
Eval compute in 4+5.

Check (3*5)%Z.  (* "term%key" bounds the interpretation of "term" to the scope "key" *)
Eval compute in (3 + 5)%Z.


(* When a given notation has several interpretations, 
   the most recently opened scope takes precedence. *)
Open Scope Z_scope.


Check 3.
Check (S (S (S O))).
Eval compute in 7*3.

Close Scope Z_scope.

Check 3.



(* ================================================================== *)
(* ===================== Implicit Arguments ========================= *)


Definition comp : forall A B C:Set, (A->B) -> (B->C) -> A -> C
  := fun A B C f g x => g (f x).

Definition example0 (A:Set) (f:nat->A) := comp _ _ _ S f.

Print example0.

(* The implicit arguments mechanism makes possible to avoid _ in Coq expressions. *)
Set Implicit Arguments.

Definition comp1 : forall A B C:Set, (A->B) -> (B->C) -> A -> C
  := fun A B C f g x => g (f x).

Print comp1.

Definition example1 (A:Set) (f:nat->A) := comp1 S f.

Check comp1 S.
Check (comp1 (C:=nat) S).

(* A special syntax (using @) allows to refer to the constant without implicit arguments. *)
Check (@comp1 nat nat nat S S).

(* The generation of implicit arguments can be disabled. *)
Unset Implicit Arguments.



Set Implicit Arguments.


(* ================================================================== *)
(* ====================== Proof irrelevance ========================= *)

Section ProofIrrelevance.
  
Variable P : Prop.

Theorem t1 : P -> P.
Proof (fun x => x).

Lemma t2 :  P -> P.
Proof.
  exact (fun x => x).
Qed.

Definition t3 (x:P) :P := x.

Let t4 (x:P) :P := x.

Variable a:P.

Eval compute in t1 a.
Eval cbv delta in t1 a.
Eval cbv delta in t3 a.
Eval compute in t3 a.
Eval compute in t2 a.
Eval cbv delta in t2 a.
Eval cbv delta in t4 a.
Eval compute in t4 a.

End ProofIrrelevance.


(* ================================================================== *)
(* ===================== Finding existing proofs ==================== *)

Section Examples.
        
Search le.

SearchPattern (_ + _ <= _ + _).

SearchRewrite (_+(_-_)).

SearchRewrite (?A + (_ - ?A)).


Lemma ex16 : 1 <= 3.
Proof. 
Search le.  Print le.
  apply le_S.
  apply le_S.  
  apply le_n.
Qed.           (* The automatic tactic "firstorder" would solve the goal. *)


Lemma ex17 : forall x y:nat, x <= 5 -> 5 <= y -> x <= y.
Proof.
  intros.
  Search le. 
  Check Nat.le_trans.
  apply Nat.le_trans with (m:=5).   (* or simply "apply Nat.le_trans with 5." *)
(* We can itemize the subgoals using - for each of them. Note that whem entering in
 this mode the other subgoals are not displayed. For nested item use the 
symbols -, +, *, --, ++, **, ... *)
  - assumption.
  - assumption.
Qed.

Lemma ex18 : forall n:nat, n+n = 2*n.
Proof.
  intros.
  simpl.                (* simpl – performs evaluation. *)
  SearchRewrite (_+O).
  rewrite <- plus_n_O.  (* rewrite <- – rewrites a goal using an equality in the reverse direction. *)
  reflexivity.          (* reflexivity – reflexivity property for equality. *)
Qed.


Lemma ex19 : forall x y:nat, (x + y) * (x + y) = x*x + 2*x*y + y*y.
Proof. 
  intros.
  SearchRewrite (_ * (_ + _)).
  rewrite Nat.mul_add_distr_l.      (* rewrite – rewrites a goal using an equality. *)
  SearchRewrite ((_ + _) * _).
  rewrite Nat.mul_add_distr_r.
  rewrite Nat.mul_add_distr_r.
  SearchRewrite (_ + (_ + _)). 
  rewrite Nat.add_assoc.
  Check Nat.add_assoc.
  rewrite <- Nat.add_assoc with (n := x * x).  
  SearchPattern (?x * ?y = ?y * ?x).
  rewrite Nat.mul_comm with (n:= y) (m:=x).
  rewrite ex18.
  SearchRewrite (_ * ( _ * _)).
  rewrite Nat.mul_assoc.
  reflexivity.                 
Qed.


Lemma ex20 : forall n:nat, n <= 2*n.
Proof.
  induction n.                 (* induction – performs induction on an identifier. *)
  - simpl.                     (* simpl – performs evaluation. *)
    Search le. 
    apply Nat.le_refl.        
  - simpl.
    SearchPattern (S _ <= S _).   
    apply le_n_S. 
    SearchPattern (_<= _ + _).
    apply le_plus_l.
Qed.


Lemma ex20' : forall n:nat, n <= 2*n.
Proof.
  induction n.    (* induction – performs induction on an identifier. *)
  - simpl.        (* simpl – performs evaluation. *)
    Print le.     (* Observe the type of the constructors of the inductive definition le. *)
    constructor.  (* constructor - apply the appropriate introduction rule. *)
  - simpl. 
    apply le_n_S.
    apply le_plus_l.
Qed.    

End Examples.

