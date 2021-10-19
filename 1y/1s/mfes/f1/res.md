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
---

### 4. Puzzle do unicórnio

Consideremos as seguintes variáveis proposicionais:

- A: The unicorn is mythical
- B: The unicorn is immortal
- C: The unicorn is a mammal
- D: The unicorn is horned
- E: The unicorn is magical

Então as seguintes restrições:

1. If the unicorn is mythical, then it is immortal.
2. If the unicorn is not mythical, then it is a mortal mammal.
3. If the unicorn is either immortal or a mammal, then it is horned.
4. The unicorn is magical if it is horned.

Podem se expressar através das seguintes fórmulas proposicionais:

1. `A -> B` 
```
    A -> B
<-> ¬A ∨ B
```

2. `¬A -> ¬B ∧ C` 
```
    ¬A -> ¬B ∧ C
<-> ¬¬A ∨ (¬B ∧ C)
<-> (A ∨ ¬B) ∧ (A ∨ C)
```

3. `B ∨ C -> D` 
```
    B ∨ C -> D
<-> ¬(B ∨ C) ∨ D
<-> (¬B ∧ ¬C) ∨ D
<-> (¬B ∨ D) ∧ (¬C ∨ D)
```

4. `D -> E` 
```
    D -> E
<-> ¬D ∨ E
    
```

Transformando para o formato `.cnf`: 

```
p cnf 5 6
-1 2 0
1 -2 0
1 3 0
-2 4 0
-3 4 0
-4 5 0
```

Primeira solução obtida com o `MiniSAT`:

```
SAT
-1 -2 3 4 5 0
```

**1.**

Acrescentando a negação desta fórmula:

```
p cnf 5 11
-1 2 0
1 -2 0
1 3 0
-2 4 0
-3 4 0
-4 5 0
1 0
2 0
-3 0
-4 0
-5 0
```

Resultado obtido com o `MiniSAT`: `UNSAT`

Logo, há um único modelo que resolve este problema.

**2.**

As claúsulas adicionadas em cima responde há pergunta de "existe um outro modelo em que o unicórnico seja ou mítico ou imortal ou não mamífero ou não chifrudo ou não mágico?". Uma vez que nenhum outro modelo foi obtido a resposta é negativa, ou seja, "o unicórnio não é mítico nem imortal e é mamífero, chifrudo e mágico", respondendo assim às questões colocadas. 


Seja `T`, o conjunto das fórmulas proposicionais deste problema (1., 2., 3. e 4.). Então, verificar que:

- Is the unicorn magical? 

é o mesmo que "`T ⊨ E` ?"

`⋀T -> E` é válido **sse** `⋀T ∧ ¬E` é insatisfazível.

Portanto, acrescentando a clausula `¬E`:

```
p cnf 5 7
-1 2 0
1 -2 0
1 3 0
-2 4 0
-3 4 0
-4 5 0
-5 0
```

Obtém-se o seguinte, através do `MiniSAT`: `UNSAT`.

O processo é análogo para as outras questões, obtendo-se sempre `UNSAT`, i.e., o problema é insatisfazível e, portanto, a resposta é afirmativa para as questões.

---

### 5. Configuração de produtos

Consideremos as seguintes variáveis proposicionais:

```
A : O automóvel tem um ar condicionado Thermotronic 
B : O automóvel tem uma bateria de alta capacidade
C : O automóvel tem motores a gasolina de 3.2 L
```

Configurações disponíveis:
```
    A -> B ∨ G
<-> ¬A ∨ B ∨ G
```

Configurações do cliente: `A ∧ ¬B ∧ ¬G`

É possível?

`(¬A ∨ B ∨ G) ∧ A ∧ ¬B ∧ ¬G`

Transformando para o formato `.cnf`:

```cnf
p cnf 3 2
-1 2 3 0
1 0
-2 0
-3 0
```

Através do `MiniSAT` obtém-se: `UNSAT`, i.e., o problema é insatisfazível e, portanto, não é possível concretizar o pedido do cliente. 

---

### 6. Equivalência de cadeiras `if-then-else`

**(1)**

```c 
if (!a && !b) h();
else if(!a) g();
    else f();
```

### 7. Sentando os convidados


**1.** 

Considerando as seguintes variáveis proposicionais: 

`x`<sub>ij</sub> para `i` ∈ {1,2,3} e `j` ∈ {1,2,3}, sendo que `x`<sub>ij</sub> = 1 sse a pessoa `i` ficar sentada na cadeira `j`.

Em que:

- Ana = 1, Susana = 2, Pedro = 3
- esquerda = 1, meio = 2, direito = 3

Portanto, as seguintes restrições:

1. A Ana não quer ficar sentada à beira do Pedro.
2. A Ana não quer ficar na cadeira da esquerda.
3. A Susana não se quer sentar à esquerda do Pedro.


Podem ser transformadas nas seguintes fórmulas proposicionais:

1. `(x11 -> ¬x32) ∨ (x12 -> ¬x33)`
```
    (x11 -> ¬x32) ∨ (x12 -> ¬x33)

<-> ¬x11 ∨ ¬x32 ∨ ¬x12 ∨ ¬x33
```

2. `¬x11`

3. `(x32 -> ¬x21) ∨ (x33 -> ¬x21 ∧ ¬x22)`
```
    (x32 -> ¬x21) ∨ (x33 -> ¬x21 ∧ ¬x22)

<-> (¬x32 ∨ ¬x21) ∨ (¬x33 ∨ (¬x21 ∧ ¬x22))

<-> (¬x32 ∨ ¬x21 ∨ ¬x33) ∨ ((¬x33 ∨ ¬x21) ∧ (¬x33 ∨ ¬x22))

<-> (¬x32 ∨ ¬x21 ∨ ¬x33) ∧ (¬x32 ∨ ¬x33 ∨ ¬x21 ∨ ¬x22)
```

Além disso, ainda existem as seguintes restrições:

4. Todas as pessoas devem estar sentadas numa cadeira e não poderá haver mais do que uma pessoa em cada cadeira.

4.1. A uma única pessoa na cadeira da esquerda. 
```
    (x11 ∨ v21 ∨ x31) ∧ (x11 -> ¬x21 ∧ ¬x31) ∧ (x21 -> ¬x11 ∧ ¬x31) ∧ (x31 -> ¬x11 ∧ ¬x21) 

<-> (x11 ∨ v21 ∨ x31) ∧ (¬x11 ∨ ¬x21 ∧ ¬x31) ∧ (¬x21 ∨ ¬x11 ∧ ¬x31) ∧ (¬x31 ∨ ¬x11 ∧ ¬x21)

<-> (x11 ∨ v21 ∨ x31) ∧ (¬x11 ∨ ¬x21) ∧ (¬x11 ∨ ¬x31) ∧ (¬x21 ∨ ¬x11) ∧ (¬x21 ∨ ¬x31) ∧ (¬x31 ∨ ¬x11) ∧ (¬x31 ∨ ¬x21)

<-> (x11 ∨ v21 ∨ x31) ∧ (¬x11 ∨ ¬x21) ∧ (¬x11 ∨ ¬x31) ∧ (¬x21 ∨ ¬x31)
```
4.2. A uma única pessoa na cadeira do meio. 
```
    (x12 ∨ x22 ∨ x32) ∧ (x12 -> ¬x22 ∧ ¬x32) ∧ (x22 -> ¬x12 ∧ ¬x32) ∧ (x32 -> ¬x12 ∧ ¬x22) 

<-> (x12 ∨ x22 ∨ x32) ∧ (¬x12 ∨ ¬x22 ∧ ¬x32) ∧ (¬x22 ∨ ¬x12 ∧ ¬x32) ∧ (¬x32 ∨ ¬x12 ∧ ¬x22)

<-> (x12 ∨ x22 ∨ x32) ∧ (¬x12 ∨ ¬x22) ∧ (¬x12 ∨ ¬x32) ∧ (¬x22 ∨ ¬x32)

```

4.3. A uma única pessoa na cadeira da direita. 
```
    (x13 ∨ x23 ∨ x33) ∧ (x13 -> ¬x23 ∧ ¬x33) ∧ (x23 -> ¬x13 ∧ ¬x33) ∧ (x33 -> ¬x13 ∧ ¬x23) 

<-> (x13 ∨ x23 ∨ x33) ∧ (¬x13 ∨ ¬x23 ∧ ¬x33) ∧ (¬x23 ∨ ¬x13 ∧ ¬x33) ∧ (¬x33 ∨ ¬x13 ∧ ¬x23)

<-> (x13 v x23 ∨ x33) ∧ (¬x13 ∨ ¬x23) ∧ (¬x13 ∨ ¬x33) ∧ (¬x23 ∨ ¬x33)
```

Transformando para o formato `.cnf`:

```cnf
p cnf 9 16
-1 -8 -2 -9 0
-1 0
-8 -4 -9 0
-8 -9 -4 -5 0
1 4 7 0
-1 -4 0
-1 -7 0
-4 -7 0
2 5 8 0
-2 -5 0
-2 -8 0
-5 -8 0
3 6 9 0
-3 -6 0
-3 -9 0
-6 -9 0
```

 ^^^^CONFIRMAR