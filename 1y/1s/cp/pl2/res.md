# PL02

**Data**: 21-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Notas da aula

```
              ^                             
              |
              | Reg                         
              |
              |     L1                      
              |
 Velocidade   |         L2              
              |
              |             L3          
              |
              |                 RAM     
              +------------------------>
                        Mem
```   

| Mem | Tam             |   Vel |
| :-: | :-:             |   :-: |
| Reg |                 |    0  |
| L1  | ~32  KiB/core   |  1-3  |
| L2  | ~256 KiB/core   |  5-10 |
| L3  | ~20  MiB/core   |  15-10|
| RAM | 8 GiB           |  200  |

<sub><sup> Valores usuais mas não aplicados a todos os casos.</sup></sub>

---

Quando se carrega algo da RAM, primeiro passa-se por todos os níveis de cache primeiro.

1. PU -> L1 (Tens?) X -> Miss (ir a L2)
2. PU -> L2 (Tens?) X -> Miss (ir a L3)
3. PU -> L3 (Tens?) X -> Miss (ir à RAM)
4. Caso seja utilizado apenas `write through`, voltar diretamente para cima.
5. Senão, (`write back`) escrever em L3, depois em L2, depois em L3 e voltamos para cima.

--- 

Quando se carregam p.e. 4 bytes da RAM, na verdade carrega-se o equivalente ao tamanho da L1. Neste caso, seriam 64 bytes.

Aproveitar a **localidade espacial**.

--- 

**Localidade temporal** não é aceder a dados contínuos, mas sim aceder ao mesmo espaço de memória repetidamente.

Em iterações **sucessivas** estamos a aceder à **mesma posição de memória**.


## Resolução de Exercícios
### 1. Análise da localidade dos dados

#### (a)

No ciclo interior estamos a iterar coluna a coluna cada elemento de uma dada linha da matriz A. Nesse caso, acede-se carrega-se vários elementos de uma só linha devido à contiguidade dos dados e, por isso, exibe localidade espacial.

No caso de B, estamos a aceder linha a linha de uma dada coluna. Na memória a matriz fica registada linha a linha e, por isso, aceder à mesma coluna multiplas vezes não é equivalente a aceder ao mesmo espaço de memória. Logo, não há localidade espacial e temporal.
(A menos que a matriz B fosse de uma dimensão baixa que lhe permitsse carregar mais que uma linha de cada vez).


No caso de C, dentro do ciclo interior estamos a aceder sempre ao mesmo elemento, por isso há localidade temporal. 


#### (b)

- Para a matriz A:

Uma vez que se carrega 64 bytes de cada vez, e um `int` tem 4 bytes de tamanho, então carrega-se 16 elementos da matriz por cada iteração.

$\#\text{L1,A}_\text{DCM} = N^3 \times \frac{1}{16}$

Então, a cada 16 acessos haverá um **miss**. (1 miss por 16 acessos)

- Para a matriz B:

Uma vez que não há localidade espacial nem temporal, a cada acesso ocorrerá um miss. (1 miss por acesso)

$\#\text{L1,B}_\text{DCM} = N^3 \times 1$

---

$\#\text{L1}_\text{DCM} = \#\text{L1,A}_\text{DCM} + \#\text{L1,B}_\text{DCM}$

$\#\text{L1}_\text{DCM} =  N^3 \times \frac{17}{16}$


#### (c)

```c

for (i = 0 ; i < N ; i++)
    for(j = 0 ; j < N ; j++)
        for(k = 0 ; k < N ; k++)
            c[i][j] += a[i][k] * b[k][j];
            // c: temporal
            // a: espacial
            // b: -
```

Se trocarmos os dois ciclos mais interiores:

```c
for (i = 0 ; i < N ; i++)
    for(k = 0 ; k < N ; k++)
        for(j = 0 ; j < N ; j++)
            c[i][j] += a[i][k] * b[k][j];
            // c: espacial
            // a: temporal
            // b: espacial
```

---

### 2. Medição do impacto da localidade espacial dos dados

#### (a).

Há localidade espacial para todas as matrizes! Isto porque assume-se aqui a matriz B já está transposta e, portanto, percorre-se linha a linha.

Uma vez que se carrega 64 bytes de cada vez, e um `int` tem 4 bytes de tamanho, então carrega-se 16 elementos da matriz por cada iteração. 

Logo,

$\#\text{L1,A}_\text{DCM} = N^3 \times \frac{1}{16}$
$\#\text{L1,B}_\text{DCM} = N^3 \times \frac{1}{16}$
$\#\text{L1,C}_\text{DCM} = N^3 \times \frac{1}{16}$

e, portanto,

$\#\text{L1}_\text{DCM} =  N^3 \times \frac{3}{16}$

#### (b).

##### **Tabela 1.**

| N | | Texec (μs) | #CC | CPI | #I | L1_DCM <br> estimados | L1_DCM | L2_DCM | 
|:-:|   :-:   | :-: | :-: | :-: | :-: | :-:    | :-: | :-: |
|256| gemm1() | 20014  | 59.840 M | | 118 M  |17.8 M | 17.0 M | 672 K |
|256| gemm2() | 16959  | 50.7 M |     | 101 M  | 3.15 M | 1.06 M | 15 K|
|   |         |   |  |     |     |        |     |     |
|512| gemm1() | 265376 | 794 M  |     | 941 M | 142  M | 135 M |  135 M |
|512| gemm2() | 140260  | 406 M |     | 807 M  | 25.2 M | 8.42 M | 196 K |



---

### 3. Medição do impacto da localidade temporal dos dados


