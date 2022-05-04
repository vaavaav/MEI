# Questão 1

`Q = data . <cliente_cup . Usou°, produto . venda°>°`

# Questão 2

```
id ↾ id = id

:: Igualdade indireta

X ⊆ id ↾ id

≡ { def. ↾}

X ⊆ id /\ X . id° ⊆ id

≡ { id° = id ; X . id = X}

X ⊆ id /\ X ⊆ id

≡ { A /\ A = A}

X ⊆ id

∴ id ↾ id = id

```

# Questão 3

```

in° = [_N_, J]°

= (_N_ . i1° ∪ J . i2°)°

= (_N_ . i1°)° ∪ (J . i2°)°

= i1 . _N_° ∪ i2 . J°

= R
```

Nota : `(_a_) = const a`

Como in é um isomorfismo, então é uma bijeção e logo o seu converso é uma função, ou seja, R é uma função.

# Questão 4

```
ker <S,id> ⊆ f° . S

≡ { Kernel of pairing (5.111) }

<S,id>° . <S,id> => f° . S

≡ { Pairing and converse ; id° = id; natural-id}

(S°. S) ∩ id ⊆ f° . S

≡ { Pointwise (5.19) ; natural-id }

<∀ a,a' :: a' ((S°. S) ∩ id) a => a' (f° . S . id) a >

≡ { "guardanapo" (5.17) ; pointwise (5.56) }

<∀ a,a' :: a' (S°. S) a /\ (a' = a) => (f a') S a >

≡ { Trading-∀ (A.1) }

<∀ a,a' : a' = a : a' (S°. S) a  => (f a') S a >

≡ { One-Point-∀ (A.5) }

a (S°. S) a  => (f a) S a

≡ { Pointwise (5.11); (5.14); Trading-∃ (A.2); A /\ A = A }

<∃ b :: b S a>  => (f a) S a
```



