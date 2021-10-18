# Propositional Logic & SAT solving

**Data**: 11-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Notas

### Precdência dos operadores lógicos

1. `¬`
2. `∧`
3. `∨`
4. `->`
5. `<->`

## Resolução dos exercícios

### 2. Conversão para CNF e classificação de fórmulas

<br>

**1.** `A ∨ (A -> B) -> A ∨ ¬B`

```
    A ∨ (A -> B) -> A ∨ ¬B

<-> ¬(A ∨ (A -> B)) ∨ (A ∨ ¬B)

<-> (¬A ∧ ¬(¬A ∨ B)) ∨ (A ∨ ¬B) 

<-> (¬A ∧ A ∧ ¬B) ∨ (A ∨ ¬B) 

<-> (⊥ ∧ ¬B) ∨ (A ∨ ¬B)

<-> ⊥ ∨ (A ∨ ¬B) 

<-> A ∨ ¬B 
```

Transformando no formato `.cnf`:

```
p cnf 2 1
1 -2 0
```

Com recurso ao `MiniSat`, obtém-se:

```
SAT
1 -2 0
```
i.e., a fórmula é satisfazível (para A = 1, B = 0).

<br><br>

**2.** `(A -> B ∨ C) ∧ ¬(A ∧ ¬B -> C)`

```
    (A -> B ∨ C) ∧ ¬(A ∧ ¬B -> C)

<-> (¬A ∨ (B ∨ C)) ∧ ¬(¬(A ∧ ¬B) ∨ C)

<-> (¬A ∨ B ∨ C) ∧ ((A ∧ ¬B) ∧ ¬C)

<-> (¬A ∨ B ∨ C) ∧ A ∧ ¬B ∧ ¬C
```

Transformando no formato `.cnf`:

```
p cnf 3 4
-1 2 3 0
1 0
-2 0
-3 0
```

Com recurso ao `MiniSat`, obtém-se:

`UNSAT`, i.e., a fórmula é insatisfazível.

<br><br>

**3.** `(¬A -> ¬B) -> (¬A -> B) -> A`

```
    (¬A -> ¬B) -> (¬A -> B) -> A

<-> ¬(¬A -> ¬B) ∨ ((¬A -> B) -> A)

<-> ¬(¬¬A ∨ ¬B) ∨ (¬(¬¬A ∨ B) ∨ A)

<-> ¬(A ∨ ¬B) ∨ (¬(A ∨ B) ∨ A)

<-> (¬A ∧ B) ∨ ((¬A ∧ ¬B) ∨ A)

<-> (¬A ∧ B) ∨ ((¬A ∨ A) ∧ (¬B ∨ A))

<-> (¬A ∧ B) ∨ (⊤ ∧ (¬B ∨ A))

<-> (¬A ∧ B) ∨ (¬B ∨ A)

<-> ((¬A ∨ (¬B ∨ A)) ∧ (B ∨ (¬B ∨ A))) 

<-> ((¬A ∨ ¬B ∨ A) ∧ (B ∨ ¬B ∨ A))

<-> ⊤
```
Logo, é válida.

<br><br>

**(extra)** Determinar a satisfazibilidade da fórmula `P ∧ Q ∨ (R ∧ P)`, utilizando a transformação de Tseitin.

1. Atribuir uma variável por cada subfórmula <sub><sup>(nota: a fórmula principal também é subfórmula)</sup></sub>

```
A1 : P ∧ Q ∨ (R ∧ P)
A2 : P ∧ Q
A3 : R ∧ P
```

2. Precisamos de satisfazer `A1` junto com as seguintes equivalências:
   
- `A1 <-> A2 ∨ A3`
- `A2 <-> P ∧ Q`
- `A3 <-> R ∧ P`

3. Transformar cada uma para CNF:

```
    A1 <-> A2 ∨ A3

<-> (A1 -> A2 v A3) ∧ (A2 ∨ A3 -> A1)

<-> (¬A1 v A2 v A3) ∧ (¬(A2 ∨ A3) v A1)

<-> (¬A1 v A2 v A3) ∧ ((¬A2 ∧ ¬A3) v A1)

<-> (¬A1 v A2 v A3) ∧ (¬A2 v A1) ∧ (¬A3 v A1)
```

```
    A2 <-> P ∧ Q

<-> (A2 -> P ∧ Q) ∧ (P ∧ Q -> A2)

<-> (¬A2 v (P ∧ Q)) ∧ (¬(P ∧ Q) v A2)

<-> (¬A2 v P) ∧ (¬A2 v Q) ∧ (¬P v ¬Q v A2)
```

```
    A3 <-> R ∧ P

<-> (A3 -> R ∧ P) ∧ (R ∧ P -> A3)

<-> (¬A3 v (R ∧ P)) ∧ (¬(R ∧ P) v A3)

<-> (¬A3 v R) ∧ (¬A3 v P) ∧ (¬R v ¬P v A3)
```

4. A fórmula equisatisfazível é: 
   
`A1 ∧ (¬A1 v A2 v A3) ∧ (¬A2 v A1) ∧ (¬A3 v A1) ∧ (¬A2 v P) ∧ (¬A2 v Q) ∧ (¬P v ¬Q v A2) ∧ (¬A3 v R) ∧ (¬A3 v P) ∧ (¬R v ¬P v A3)`

Transformando para o formato `.cnf`:

```
p cnf 6 10
1 0
-1 2 3 0
-2 1 0
-3 1 0
-2 4 0
-2 5 0
-4 -5 2 0
-3 6 0
-3 4 0
-6 -4 3 0
```
Com recurso ao `MiniSat`, obtém-se:

```
SAT
1 2 -3 4 5 -6 0
```

Logo, é satisfazível (para P = 1, Q = 1 e R = 0).

---

### 3. SAT solvers API

```py
from pysat.solvers import Minisat22

s = Minisat22()

workdays = ['Mon','Tue','Wed','Thu','Fri']
x = {}
c = 1
for d in workdays:
    x[d] = c
    c += 1
    
s.add_clause([-x['Fri']])
s.add_clause([x['Mon'], x['Wed'], x['Thu']])
s.add_clause([-x['Tue']])
s.add_clause([-x['Thu']])

while s.solve():
    m = s.get_model()
    print(m)
    for w in workdays:
        if m[x[w]-1]>0:
            print("The meeting can take place on %s." % w)
            # add a new clause that forces that day to now be invalid
            # now, the solver is gonna try to find a new solution
            s.add_clause([-x[w]])         
            
s.delete()    
```