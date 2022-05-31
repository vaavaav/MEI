# Solving Exercises from [PDBC](https://www4.di.uminho.pt/~jno/ps/pdbc.pdf)
## Part II - Calculating with Relations

### Ex 5.1.
```

S . >= ⊆ ⊤ . S

≡ { (5.11) ; (5.19) }

<∀ n, a :: <∃ n' : a S n' : n' >= n > =>  <∃ a' : a ⊤ a' : a' S n >>

≡ { _ ⊤ _ = True }

<∀ n, a :: <∃ n' : a S n' : n' >= n > =>  <∃ a' :: a' S n >>

≡ {(A.1) ; (A.13) ; (A.7) }

<∀ a,n,n' : a S n' /\ n' >= n : <∃ a' :: a' S n>>

```

Qualquer que seja o aluno, se o número que lhe foi atribuído é menor ou igual a outro, necessariamente existe um aluno que tem esse número.

### Ex 5.2.

```

R . (S . T) 

≡ { Pointwise }

b (R . (S . T)) a

≡ { (5.11) }

<∃ c : b R c : c (S . T) a>

≡ { (5.11) }

<∃ c : b R c : <∃ d : c S d : d T a>>

≡ { (A.14) }

<∃ d : <∃ c : b R c : c S d> : d T a>

≡ { (5.11) }

<∃ d : b (R . S) d> : d T a>

≡ { (5.11) ; Point-free }

(R . S) . T

```

### Ex 5.37.

```
swap is a bijection

≡ { (5.36) }

id = img swap 
id = ker swap 

:: {II}

X ⊆ ker swap 

≡ { def swap; (5.111)}

X ⊆ ker π2 ∩ ker π1 

≡ { 5.32 }

```


### Ex 5.41.

```
img [R,S] = img R ∪ img S

:: {II}

X ⊆ img [R,S]

≡ { (5.33)}

X ⊆ [R,S] . [R,S]°

≡ { (5.33)}

X ⊆ [R,S] . [R,S]°

≡ { (5.121)}

X ⊆ (R.R˚) ∪ (S.S°)

≡ { (5.33)}

X ⊆ img R ∪ img S
```

```
img i1 ∪ img i2 = id

:: {II}

img i1 ∪ img i2 ⊆ X

≡ { (5.59)}

img i1 ⊆ X
img i2 ⊆ X

<= { Como i1 e i2 são funções, então img i1 ⊆ id, por isso, "raise lower side" }

id ⊆ X
id ⊆ X

≡ { A /\ A = A}

id ⊆ X
```

### Ex 5.43.

```
X . f = X/f°

:: {II}

Y ⊆ X . f

≡ {(5.47)}

Y . f° ⊆ X 

≡ {(5.157)}

Y ⊆ X/f° 
```

```
X/id = X

:: {II}

Y ⊆ X/id

≡ {(5.157)}

Y . id ⊆ X 

≡ {(5.13)}

Y ⊆ X 
```

### Ex 5.44.

```
X\Y = (Y°/X°)°

:: {II}

Z ⊆ X\Y

≡ {(5.157)}

X.Z ⊆ Y

≡ {(5.137)}

(X.Z)° ⊆ Y°

≡ {(5.16)}

Z° . X° ⊆ Y°

≡ {(5.157)}

Z° ⊆ Y°/X°

≡ {(5.137); (5.15)}

Z ⊆ (Y°/X°)°
```


### Ex 5.50.

```
R ↾ S = R ∩ S / R°

:: { Igualdade Indireta }

X ⊆ R ∩ S / R°

≡ { Universal-∩ }

X ⊆ R  /\ X ⊆ S / R°

≡ { (.R) ⊢ (/R) }

X ⊆ R  /\ X . R° ⊆ S

≡ { def. ↾}

X ⊆ R ↾ S

```

### Extra

```
R ⊆ R ↾ id = R . R° ⊆ id
```
Isto dá o maior fragmento simples da relação `R`. 


### Ex 5.51.

#### (b)

```
R † S = S ∪ (R ∩ ⊥ / S°)

:: {II}

X ⊆ S ∪ (R ∩ ⊥ / S°)

≡ {(- R) ⊢ (R ∪) (ou Universal-(-))}  

X - S ⊆ R ∩ ⊥ / S°

≡ {Universal-∩}

X - S ⊆ R /\ X - S ⊆ ⊥ / S°

≡ {(.R) ⊢ (/R) }

X - S ⊆ R /\ (X - S) . S° ⊆ ⊥

```

```
b (R † S) a ≡ b (S ∪ (R ∩ ⊥ / S°)) a

≡ b S a \/ b (R ∩ ⊥ / S°) a

≡ b S a \/ b R a /\  b (⊥ / S°) a

≡ b S a \/ (b R a /\  <∀ b' : b' S A : b ⊥ b'>)

≡ b S a \/ (b R a /\  <∀ b' : b' S A : FALSE>)

```
### Ex 5.57.

```

y R x ≡ y² + x² = 1

R = sq° . (1-) . sq

y R x ≡ y² (1-) x² 

≡ y² = 1- x² 

≡ y² + x² = 1 

```

é difuncional


```
sq° . (1-) . sq . sq° . (1-)° . sq . sq° . (1-) . sq ⊆ sq° . (1-) . sq

<= {Image; sq é função e como img sq ⊆ id, podemos subir o lado de baixo; natural-id}

sq° . (1-) . (1-)°. (1-) . sq ⊆ sq° . (1-) . sq

<= {Image; (1-) é função e como img (1-) ⊆ id, podemos subir o lado de baixo; natural-id}

sq° . (1-) . sq ⊆ sq° . (1-) . sq

≡ TRUE

```

# Extra

