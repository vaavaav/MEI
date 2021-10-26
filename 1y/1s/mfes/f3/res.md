# FOL

**Date**: 25-10-2021

## Info

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução dos exercícios

### 1. SMT-LIB 2: um exemplo simples

```smt2
(set-logic QF_LIA)

(declare-fun x () Int)
(declare-fun y () Int)
(declare-fun z () Int)

(assert (> x 0))
(assert (> y 0))
(assert (> z 0))
(assert (distinct x y z))
(assert (= (+ x y z) 8))
(assert (<= y 3))

; R: z = 2, y = 1, x = 5
(assert (not (= z 2)))
(assert (not (= y 1)))
(assert (not (= x 5)))

; R: z = 4, y = 3, x = 1
(assert (not (= z 4)))
(assert (not (= y 3)))
(assert (not (= x 1)))

(check-sat)
(get-model)
; (get-value (x y))
```

### 2. Z3Py: API do Z3 para Python

#### 1. Defina uma função `prove` que verifique se uma fórmula proposicional é válida e use essa função para provar lei de Morgan $A \wedge B = \neg (\neg A \vee \neg B)$.

```py
from z3 import *

def prove(f):
    s = Solver()
    s.add(f)
    return (s.check() == sat)

a = Bool('a')
b = Bool('b')
demorgan = And(a,b) == Not(Or(Not(a),Not(b)))

if prove(demorgan):
    print("De Morgan is valid!")
```

#### 2. Modelação em Lógica Proposicional

Recorde o seguinte problema:

*When can the meeting take place?*

  * *Anne cannot meet on Friday.*
  * *Peter can only meet either on Monday, Wednesday or Thursday.*
  * *Mike cannot meet neither on Tuesday nor on Thursday.*

Vamos usar o Z3 para encontrar a solução. 

1. Vamos modelar o problema em Lógica Proposicional, criando uma variável proposicional para cada dia da semana ($\mathit{Mon}$,$\mathit{Tue}$,$\mathit{Wed}$,$\mathit{Thu}$, e $\mathit{Fri}$), com a seguinte semântica: se a variável for `True` é porque a reunião se pode fazer nesse dia, caso contrário será `False`.

2. De seguida, teremos que modelar cada uma das restrições, acrescentando as fórmulas lógicas correspondentes.

$$
\begin{array}{c}
\neg \mathit{Wed}\\
\mathit{Mon} \vee \mathit{Wed} \vee \mathit{Thu}\\
\neg \mathit{Tue} \wedge \neg \mathit{Thu}\\
\end{array}$$



3. Finalmente testamos se o conjunto de restrições é satisfazível e extraimos a solução calculada.

```py
from z3 import *

days = [Mon, Tue, Wed, Thu, Fri] = Bools('Monday Tuesday Wednesday Thursday Friday')
s = Solver()
s.add(Not(Wed))
s.add(Or(Mon,Wed,Thu))
s.add(And(Not(Tue),Not(Thu))) 

possible_days = []

while s.check() == sat:
    m = s.model()
    for day in days:
        if(m[day]):
            possible_days.append(day)
            s.add(Not(day))

if(possible_days == []):
    print('There are no days available to set a meeting.')
else:
    print('The meeting can be on days: ', ",".join(map(str,possible_days)))


```

O código acima foi alterado para imprimir os vários dias em que poderá ocorrer a reunião. Imprime apenas os dias em vez de imprimir todo o modelo.

### 4. Sudoku

#### 1. 

```py
from z3 import * 

N = 3
D = N*N
NS = range(D)

s = Solver()

x = {}
for i in NS:
    x[i] = {}
    for j in NS:
        # variable declaration
        x[i][j] = Int(f'x{i}{j}')       
        # variables in [1, D]
        s.add(And(1 <= x[i][j], x[i][j] <= D))

# all numbers in a line need to be different
for i in range(D):
    for j in range(D):
        s.add(And([x[i][j] != x[i][k] for k in NS if j != k]))

# all numbers in a column need to be different
for j in range(D):
    for i in range(D):
        s.add(And([x[i][j] != x[k][j] for k in NS if i != k]))

s.check()

s.model()
```

### 5. Manipulação de arrays

```smt2
(declare-const a0 (Array Int Int))
(declare-const a1 (Array Int Int))
(declare-const a2 (Array Int Int))
(declare-const x0 Int)
(declare-const y0 Int)
(declare-const y1 Int)
(declare-const i0 Int)

; x = a[i]
(assert (= x0 (select a0 i0)))

; y = y + x
(assert (= y1 (+ y0 x0)))    
 
; a[i] = 5 + a[i]
(assert (= a1 (store a0 i0 (+ 5 (select a0 i0))))) 

; a[i+1] = a[i-1] - 5
(assert (= a2 (store a1 (+ i0 1) (- (select a1 (- i0 1)
) 5)))) 
```

#### 1.

Para que `x + a[i-1] = a[i] + a[i+1]` seja válido, então a sua negação em conjunto com as propriedades do programa terá de resultar em `UNSAT`, i.e., insatisfazível.

```smt2
(push)

(assert (not (= (+ x0 (select a2 (- i0 1))) (+ (select a2 i0) (select a2 (+ i0 1))))))

(check-sat)

(pop)
```

#### 2. 


Para que `a[i-1] + a[i] > 0` seja válido, então a sua negação em conjunto com as propriedades do programa terá de resultar em `UNSAT`, i.e., insatisfazível.

```smt2
(push)

(assert (not (> (+ (select a2 (- i0 1)) (select a2 i0)) 0)))

(check-sat)

(get-model)

(pop)
```

#### 3.

Para que `if (y < 5) then a[i] > y` seja válido, então a sua negação em conjunto com as propriedades do programa terá de resultar em `UNSAT`, i.e., insatisfazível.

```smt2
(push)

(assert (not (if (< y1 5) (> (select a2 i0) y1) true)))

(check-sat)

(pop)
```

### 6. Teoria de bitvectors: o problema das N-rainhas

### 7. Skycrapers puzzles

### 8. Scheduling
