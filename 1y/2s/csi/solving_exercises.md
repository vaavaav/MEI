# Solving Exercises from [PDBC](https://www4.di.uminho.pt/~jno/ps/pdbc.pdf)
## Part II - Calculating with Relations

### Ex 5.1.



### Ex 5.2.

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

