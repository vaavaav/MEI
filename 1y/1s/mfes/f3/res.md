# FOL

**Date**: 25-10-2021

## Info

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução dos exercícios

### 1. SMT-LIB 2: um exemplo simples

### 2. Z3Py: API do Z3 para Python

### 3. Unicorn puzzle

### 4. Sudoku

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
