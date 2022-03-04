
(* ================================================================== *)
(* ==================== Programming and proving ===================== *)
(* ================================================================== *)

Require Import ZArith.

Require Import List.

Require Import Lia.


Set Implicit Arguments.

Fixpoint elem (a:Z) (l:list Z) {struct l} : bool :=   (* !!!!!!!!!!! *)
    match l with
      | nil => false
      | cons x xs => if Z.eq_dec x a then true else (elem a xs)
    end.


Proposition elem_corr : forall (a:Z) (l1 l2:list Z),
                  elem a (app l1 l2) = orb (elem a l1) (elem a l2).
Proof.
  induction l1.
  - intros. simpl. reflexivity.
  - intros. simpl.
    elim (Z.eq_dec a0 a).     
    + intros. simpl.  reflexivity.
    + auto.
Qed.


(* Exercise: *)
(* Sugestion: use de previous proposition *)
Lemma ex : forall (a:Z) (l1 l2:list Z), elem a (app l1 (cons a l2)) = true.
Proof.
  intros.
  rewrite (elem_corr a l1 (a::l2)).
  simpl. elim (Z.eq_dec a a).
   - intros. apply Bool.orb_true_r.
   - intros. contradiction.
Qed.

(* ================================================================== *)
(* ======================== Partiality ============================== *)

(* defining the function head *)

Definition head (A:Type) (l:list A) : l<>nil -> A.
(* "refine term" tactic applies to any goal. It behaves like exact with
a big difference: the user can leave some holes (denoted by _ or (_:type)) 
in the term. 
refine will generate as many subgoals as there are holes in the term. *) 
  refine (
  match l as l' return l'<>nil -> A with
  | nil => fun H => _
  | cons x xs => fun H => x
  end ).  
  contradiction.
Defined.

Print  head.
Print Implicit head.


(* head precondition *)
Definition headPre (A:Type) (l:list A) : Prop := l<>nil.

(* the specification of head *) 
Inductive headRel (A:Type) (x:A) : list A -> Prop :=
  headIntro : forall l, headRel x (cons x l).

Print Implicit headRel.


(* we can prove the correctness of head w.r.t. its specification *)
(* note that (head p) is the same as (@head A l p) since A and l are implicit arguments *)
Lemma head_correct : forall (A:Type) (l:list A) (p:headPre l), headRel (head  p) l.
Proof.
  destruct l.
  - intro H. elim H. reflexivity.
  - intros.  destruct l.
   * simpl. constructor.
   * simpl. constructor.
    (* change de proof script so that you can see effect each tactic *)
Qed.



(* ================================================================== *)
(* ==================== Program Extraction ========================== *)

Require Extraction.  (* the extraction framework must be loaded explicitly *)


(* we can convert to Haskell the function head defined *)
Extraction Language Haskell.

Extraction head.

Extraction False_rect.
Extraction Inline False_rect.  (* will make the code more readable *)
Extraction head.

Recursive Extraction head.
Extraction "exemplo1" head.

Extract Inductive list => "[]" [ "[]" "(:)" ].

Recursive Extraction head.
Extraction "exemplo2" head.

(* We have just followed the "weak specification" approach: 
   we defined the function and add, as a companion lemma, that the function 
   satisfies its specification. 
*)


(* ================================================================== *)

(* Instead of this approach, we can give a "strong specification" of a
   function  (using specification types), and extract the function from 
   its proof (the prove that the specification is inhabited).
*)

(* An inductive relation "x is the last element of list l" *)
Inductive Last (A:Type) (x:A) : list A -> Prop :=
| last_base : Last x (cons x nil)
| last_step : forall l y, Last x l -> Last x (cons y l).

 
Theorem last_correct : forall (A:Type) (l:list A), l<>nil -> { x:A | Last x l }.
Proof.
  induction l.
  - intro H. contradiction. (* elim H. reflexivity.*)
  - intros. destruct l.
    + exists a. constructor.
    + elim IHl.
      * intros. exists x. constructor. assumption.
      * discriminate.
Qed.



Recursive Extraction last_correct.


Extraction Inline False_rect sig_rect list_rect.

Recursive Extraction last_correct.



(* ================================================================== *)

(* Following this alternative approach we can give a "strong specification" of 
   function head (using specification types), and extract the function from 
   its proof (the prove that the specification is inhabited).
*)

(* Exercise: built an alternative definition of function head called “head corr” 
   based on the strong specification mechanism *)




(* ================================================================== *)
(* ======================= Sorting a list =========================== *)

Open Scope Z_scope. 

Inductive Sorted : list Z -> Prop := 
  | sorted0 : Sorted nil 
  | sorted1 : forall z:Z, Sorted (z :: nil) 
  | sorted2 : forall (z1 z2:Z) (l:list Z), 
        z1 <= z2 -> Sorted (z2 :: l) -> Sorted (z1 :: z2 :: l). 


Fixpoint count (z:Z) (l:list Z) {struct l} : nat :=
  match l with
  | nil => 0%nat     (* %nat to force the interpretation in nat, since have we open Z_scope *)
  | (z' :: l') => if Z.eq_dec z z' 
                  then S (count z l')
                  else count z l'
  end.


Definition Perm (l1 l2:list Z) : Prop :=
                                 forall z, count z l1 = count z l2.


(* Perm is an equivalence relation (i.e. is reflexive, symmetric and transitive) *)

Lemma Perm_reflex : forall l:list Z, Perm l l.
Proof.
  intros. red. reflexivity.
Qed.

Lemma Perm_sym : forall l1 l2, Perm l1 l2 -> Perm l2 l1.
Proof. 
  unfold Perm.
  intros l1 l2 H z.
  symmetry.
  (* apply H. *)
  generalize z. 
  assumption.
Qed.


Lemma Perm_trans : forall l1 l2 l3, Perm l1 l2 -> Perm l2 l3 -> Perm l1 l3.
Proof.
  unfold Perm.
  intros.
  transitivity (count z l2); [ apply H | apply H0 ].  
Qed.



(*  Exercise: prove the following lemmas: *)


Lemma Perm_cons : forall a l1 l2, Perm l1 l2 -> Perm (a::l1) (a::l2).
Proof.
  intros.
  unfold Perm.
  intros. 
  simpl.
  elim (Z.eq_dec z a).
   - intros. SearchPattern (S _ = S _). apply eq_S. apply H.
   - intros. apply H.
Qed.



Lemma Perm_cons_cons : forall x y l, Perm (x::y::l) (y::x::l).
Proof.
  intros.
  unfold Perm.
  intros.
  simpl.
  elim (Z.eq_dec z x); elim (Z.eq_dec z y); intros; reflexivity.
Qed.





Fixpoint insert (x:Z) (l:list Z) {struct l} : list Z :=
  match l with
    nil => cons x (@nil Z)
  | cons h t => if Z_lt_ge_dec x h
                then cons x (cons h t)
                else cons h (insert x t)
  end.


Fixpoint isort (l:list Z) : list Z :=
  match l with
    nil => nil
  | cons h t => insert h (isort t)
  end.

Print isort.


(* some  usefull lemmas about count *)

Lemma count_insert_eq : forall x l,
                       count x (insert x l) = S (count x l).
Proof.
  induction l.
  - simpl. destruct (Z.eq_dec x x).
    + reflexivity.
    + destruct n. reflexivity.
  - simpl insert. destruct (Z_lt_ge_dec x a).
    + simpl. destruct (Z.eq_dec x x).
      * reflexivity.
      * easy.
    + simpl. destruct (Z.eq_dec x a).
      * rewrite IHl. reflexivity.
      * assumption.
Qed.

Lemma count_cons_diff : forall z x l, z <> x -> count z l = count z  (x :: l).
Proof.
  intros. induction l.
  - simpl. destruct (Z.eq_dec z x); easy.
  - simpl. destruct (Z.eq_dec z a).
    + destruct (Z.eq_dec z x); easy.
    + destruct (Z.eq_dec z x); easy.
Qed.

 
Lemma count_insert_diff : forall z x l, z <> x -> count z l = count z (insert x l).
Proof.
  intros. induction l.
  - simpl. destruct (Z.eq_dec z x); easy.
  - simpl insert. destruct (Z_lt_ge_dec x a).
    + simpl. destruct (Z.eq_dec z x); try easy.
    + simpl. destruct (Z.eq_dec z a); try easy.
      apply f_equal. apply IHl.
Qed.    


(* the two auxiliary lemmas *)

Lemma insert_Perm : forall x l, Perm (x::l) (insert x l).
Proof.
  unfold Perm; induction l.
 - simpl. reflexivity.
 - simpl insert. destruct (Z_lt_ge_dec x a).
   + reflexivity.
   + intros. 
     destruct (Z.eq_dec z a).
     * simpl. destruct (Z.eq_dec z a).
       -- destruct (Z.eq_dec z x). 
          ++ apply f_equal. rewrite e1. rewrite count_insert_eq. reflexivity.
          ++ apply f_equal. apply count_insert_diff. assumption.
       -- destruct (Z.eq_dec z x).
          ++ destruct n. assumption.
          ++ destruct n. assumption.
     * simpl. destruct (Z.eq_dec z a).
       -- destruct (Z.eq_dec z x); easy.
       -- destruct (Z.eq_dec z x). 
          ++ rewrite e. rewrite count_insert_eq. reflexivity.
          ++ rewrite <- count_insert_diff; [reflexivity|assumption].
Qed.



Lemma insert_Sorted : forall x l, Sorted l -> Sorted (insert x l).
Proof.
  - intros x l H; elim H; simpl. 
    + constructor.
    + intro z; elim (Z_lt_ge_dec x z); intros.
      * constructor.
        auto with zarith. constructor.
      * constructor.
        -- auto with zarith.
        -- constructor.
    + intros z1 z2 l0 H0 H1.
      elim (Z_lt_ge_dec x z2); elim (Z_lt_ge_dec x z1).
      * intros. constructor.
        -- lia. (* auto with zarith.*)
        -- constructor.
           ++ lia. 
           ++ assumption.  
      * intros. constructor.
        -- lia.
        -- assumption.
      * intros. constructor.
        -- lia.
        -- constructor; [lia|assumption].
      * intros. constructor; [lia|assumption].
Qed.


(* the proof that isort is correct *)
Theorem isort_correct : forall (l l':list Z), l'=isort l -> Perm l l' /\ Sorted l'.
Proof.
  induction l; intros.
  - unfold Perm; rewrite H; split; auto. simpl. constructor.
  - simpl in H.
    rewrite H. (* ??????????? *) 
    elim (IHl (isort l)); intros; split.
    + apply Perm_trans with (a::isort l).
      * unfold Perm. intro z. simpl. elim (Z.eq_dec z a).
        -- intros. elim H0; reflexivity.   (* auto with zarith. *)
        -- auto with zarith.   (* intros. elim H0. reflexivity. *)
      * apply insert_Perm.
    + apply insert_Sorted. assumption.
Qed.


(* EXTRACTION *) 
(* using specification types *)
Definition inssort : forall (l:list Z), { l' | Perm l l' & Sorted l' }.
Proof.
  induction l.
  - exists nil. constructor. constructor.
  - elim IHl. intros l1 H H1. exists (insert a l1).
(* FILL IN HERE *) 

    
Extraction Language Haskell.
Recursive Extraction inssort.

Extraction Inline list_rec list_rect sig2_rec sig2_rect.

Extraction inssort.
Recursive Extraction inssort.


(* ================================================================== *)
(* =================== Non-structural recursion ===================== *)

Close Scope Z_scope.

Require Import Recdef. (* because of Function *)


Function div (p:nat*nat) {measure fst} : nat*nat :=
  match p with
  | (_,0) => (0,0)
  | (a,b) => if le_lt_dec b a
             then let (x,y):=div (a-b,b) in (1+x,y)
             else (0,a)
  end.
Proof.
 intros. simpl. lia.
Qed.



(* Exercise: *)
Function merge (p:list Z*list Z)
{measure (fun p=>(length (fst p))+(length (snd p)))} : list Z :=
  match p with
  | (nil,l) => l
  | (l,nil) => l
  | (x::xs,y::ys) => if Z_lt_ge_dec x y
                     then x::(merge (xs,y::ys))
                     else y::(merge (x::xs,ys))
  end.
(* FILL IN HERE *)




(* ========== Introducing a new induction principle =========== *)



Fixpoint split (A:Type) (l:list A) : (list A * list A) :=
  match l with
  | [] => ([],[])     (* Import ListNotations. *)
  | [x] => ([x],[])
  | x1::x2::l' => let (l1,l2) := split l' in (x1::l1,x2::l2) 
  end.


(*
    While this function is straightforward to define, it can be a bit challenging
    to work with.  Let's try to prove the following lemma, which is obviously true:
*)

Lemma split_len_first_try: forall (A:Type) (l:list A) (l1 l2: list A),
             split l = (l1,l2) ->  length l1 <= length l /\ length l2 <= length l.
Proof.
  induction l; intros. 
  - inversion H. simpl. lia. 
  - destruct l as [| x l'].
    + inversion_clear H. split; simpl; auto.
    + inversion H. destruct (split l') as [l1' l2']. inversion H1. 
      (* We're stuck! The IH talks about split (x::l') but we
         only know aobut split (a::x::l'). *)
Abort.

(*  The problem here is that the standard induction principle for lists
    requires us to show that the property being proved follows for      
    any non-empty list if it holds for the tail of that list.
    What we want here is a "two-step" induction principle, that instead requires
    us to show that the property being proved follows for a list of
    length at least two, if it holds for the tail of the tail of that list.
    Formally: 
*)

Definition list_ind2_principle:=
    forall (A : Type) (P : list A -> Prop),
      P nil ->
      (forall (a:A), P (a::nil)) ->
      (forall (a b : A) (l : list A), P l -> P (a :: b :: l)) ->
      forall l : list A, P l.

(* If we assume the correctness of this "non-standard" induction principle, 
    our split_len proof is easy, using a form of the induction tactic 
    that lets us specify the induction principle to use: 
 *)



Lemma split_len': list_ind2_principle -> 
    forall (A:Type) (l:list A) (l1 l2: list A),
    split l = (l1,l2) ->
    length l1 <= length l /\
    length l2 <= length l.
Proof.
  unfold list_ind2_principle; intro IP.
  induction l using IP; intros.
  - inversion H. lia.
  - inversion H. simpl; lia.
  - inversion H. destruct (split l) as [l1' l2']. inversion H1. 
    simpl. 
    destruct (IHl l1' l2') as [P1 P2]; auto; lia.
Qed.

(*  We still need to prove list_ind2_principle.  There are several
    ways to do this, but one direct way is to write an explicit proof
    term, thus: *)

Definition list_ind2 :
  forall (A : Type) (P : list A -> Prop),
      P nil ->
      (forall (a:A), P (a::nil)) ->
      (forall (a b : A) (l : list A), P l -> P (a :: b :: l)) ->
      forall l : list A, P l :=
  fun (A : Type)
      (P : list A -> Prop)
      (H : P nil)
      (H0 : forall a : A, P (a::nil))
      (H1 : forall (a b : A) (l : list A), P l -> P (a :: b :: l))  => 
    fix IH (l : list A) :  P l :=
    match l with
    | nil => H
    | (x::nil) => H0 x
    | x::y::l' => H1 x y l' (IH l')
    end.



    
(*  Here, the fix keyword defines a local recursive function IH
    of type forall l:list A, P l, which is returned as the overall value of
    list_ind2. As usual, this function must be obviously terminating 
    to Coq (which it is because the recursive call is on a sublist l' 
    of the original argument l) and the match must be exhaustive over
    all possible lists (which it evidently is). 
*)

(*  With our induction principle in hand, we can finally prove 
    split_len free and clear: 
*)

Lemma split_len: forall (A:Type) (l:list A) (l1 l2: list A),
    split l = (l1,l2) ->
    length l1 <= length l /\
    length l2 <= length l.
Proof.
 apply (split_len' list_ind2).
Qed.








(* ========== Euclidean division correction =========== *)

Definition divRel (args:nat*nat) (res:nat*nat) : Prop := 
          let (n,d):=args in let (q,r):=res in q*d+r=n /\ r<d. 

Definition divPre (args:nat*nat) : Prop := (snd args)<>0.


Theorem div_correct : forall (p:nat*nat),  divPre p -> divRel p (div p). 
Proof. 
  unfold divPre, divRel. 
  intro p. 
  (* we make use of the specialised induction principle to conduct the proof... *) 
  functional induction (div p); simpl. 
  - intro H; elim H; reflexivity. 
  - (* a first trick: we expand (div (a-b,b)) in order to get rid of the let (q,r)=... *) 
    replace (div (a-b,b)) with (fst (div (a-b,b)),snd (div (a-b,b))) in IHp0. 
    + simpl in *. intro H; elim (IHp0 H); intros. split. 
      * (* again a similar trick: we expand "x" and "y0" in order to use an hypothesis *) 
        change (b + (fst (x,y0)) * b + (snd (x,y0)) = a). 
        rewrite <- e1. lia. 
      * (* and again... *) 
        change (snd (x,y0)<b); rewrite <- e1; assumption. 
    + symmetry.  apply surjective_pairing. 
  - auto. 
Qed. 


