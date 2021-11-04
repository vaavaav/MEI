# PL03

**Data**: 28-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Notas da aula

## Resolução de Exercícios
### **1.** Loop-unrolling
#### **a)** Apresente quais as vantagens de utilização da técnica?

No hardware, não existe uma única ALU como tal é possível realizar várias operações aritméticas em paralelo, desde que não dependam entre si.

No caso do `unroll-2`, as operações:

- `A[i][k] * B[k][j]`
- `A[i][k+1] * B[k+1][j]`
 
simultaneamente.

#### **b)** Utilize a opção `-funroll-loops` no `gcc` para otimizar a função `gemm1()`. Analise o código assembly gerado. Identifique quantas vezes foi desdobrado o ciclo e estime o total de instruções executadas (utilize o tamanho 512). Apresente uma estimativa para o ganho obtido com esta otimização (compare a versão base com a versão otimizada).

```assembly
.L5:
	movss	(%r10,%rax,4), %xmm8
	mulss	(%r8), %xmm8
	movss	4(%r10,%rax,4), %xmm9
	addq	%r9, %r8
	movss	8(%r10,%rax,4), %xmm10
	mulss	(%r8), %xmm9
	addq	%r9, %r8
	mulss	(%r8), %xmm10
	movss	12(%r10,%rax,4), %xmm11
	addq	%r9, %r8
	movss	16(%r10,%rax,4), %xmm12
	mulss	(%r8), %xmm11
	addq	%r9, %r8
	addss	%xmm8, %xmm0
	mulss	(%r8), %xmm12
	addq	%r9, %r8
	movss	20(%r10,%rax,4), %xmm13
	mulss	(%r8), %xmm13
	movss	24(%r10,%rax,4), %xmm14
	addq	%r9, %r8
	movss	28(%r10,%rax,4), %xmm15
	addss	%xmm9, %xmm0
	mulss	(%r8), %xmm14
	addq	%r9, %r8
	mulss	(%r8), %xmm15
	addq	$8, %rax
	addq	%r9, %r8
	cmpl	%eax, %esi
	addss	%xmm10, %xmm0
	addss	%xmm11, %xmm0
	addss	%xmm12, %xmm0
	addss	%xmm13, %xmm0
	addss	%xmm14, %xmm0
	addss	%xmm15, %xmm0
	jg	.L5
```

Temos um desdobramento de ciclo de nível 8.
Para uma dada iteração, serão executadas 35 instruções.

##### Estimativa do número total de instruções executadas 

Como há um desdobramento de nível 8,

$$\#I_{\text{funroll}} = N^2 \cdot \frac{N}{8} \cdot 35$$

e $N = 512$, então:

$$\#I_{\text{funroll}} = 512^2 \cdot \frac{512}{8} \cdot 35 = 587 \text{M}$$

Para a versão base:

Como **não** há desdobramento de ciclo,

$$\#I_{\text{funroll}} = N^3 \cdot 7$$

e $N = 512$, então:

$$\#I_{\text{funroll}} = 512^3 \cdot 7 = 940 \text{M}$$

Logo,

$$\text{Ganho} = \frac{512 \text{M}}{940 \text{M}} \approx 0.54$$

i.e, uma redução de quase metade.

---

### **2.** Medição do impacto do loop-unrolling

#### **a)** Execute novamente a versão gemm1() com a otimização de loop-unrolling (`srun –partition=cpar ./gemm 512 1`) e compare com os resultados obtidos em aulas anteriores. Preencha a Tabela 2 e comente as diferenças quanto ao número de instruções? Calcule o ganho obtido quanto número de ciclos executados.

|   versão      |  #CC  |   CPI   |    #I     |
|  :-:     |  :-:  |   :-:   |    :-:    |
| original | 794 M |   0.84  | 942 M     |
|loop-unrolling<br>estimado|--|--|  587 M |
|loop-unrolling|784 M | 1.32 |595 M|

Devido ao unrolling a maioria das instruções no ciclo mais interior são as do acesso à memória, que são as mais pesadas. Com efeito, o CPI aumenta (visto que é uma média sobre as instruções).

### **3.** Análise da versão `ijk` (dot)

#### **a)** O compilador não consegue vetorizar automaticamente a versão dot (`ijk`). Identifique os motivos através da análise do padrão de acessos às matrizes `A`,`B` e `C` (localidade espacial, escritas concorrentes).

Não é possível vetorizar o programa, porque os 4 inteiros (32 bits) de uma coluna da matriz B não estão contíguos na memória (sendo impossível carrega-los para um registo de 128 bits) (As matrizes são registadas na memória linha a linha). 

#### **b)** É possível trocar a ordem de execução dos ciclos originando diferentes desempenhos. Qual ou quais as variantes que facilitam a geração de instruções vetoriais?

A versão `ikj`.

### **4.** Utilização de instruções vetoriais (análise + medição)

```c
void gemm4(float *__restrict__ a, float *__restrict__ b, float *__restrict__ c, int n) {
    int i, j, k;
    float aik;

    for (i = 0; i < n; ++i)
    {
        for (k = 0; k < n; ++k)
        {
            aik = a[i * n + k];
            for (j = 0; j < n; j++)
            {
                c[i * n + j] += aik * b[k * n + j];
            }
        }
    }
}

```


#### **a)** Quantos elementos são calculados de cada vez? Estime a quantidade de instruções executadas, preencha a respetiva coluna na Tabela 2.

- C : localidade espacial
- A : localidade temporal
- B : localidade espacial

Uma vez que será executado numa máquina com vetores de 128 bits e um inteiro tem 32 bits, então por cada instrução algébrica vetorial serão processados simultaneamente 4 inteiros.

$$\#I_{\text{vec}} = N^2 \cdot \frac{N}{4} * 7$$

#### **b)** Execute a versão gemm4() (`srun –-partition=cpar ./gemm 32 4`) da multiplicação de matrizes e preencha a Tabela 2. Como aumentam as várias grandezas em função do tamanho da matriz? Discuta as diferenças entre o ganho esperado e o ganho medido? 



|   n      |  #CC     |   CPI   |    #I    |#I estimados|
|  :-:     |  :-:     |   :-:   |    :-:   |    :-:    |
|   32     |  35.45 K |  0.3389 |  104.6 K |   57.3 K  |
|   128    | 2.269 M  | 0.4059  | 5.591 M  |   3.67 M  |
|   512    | 137.3 M  | 0.4026  | 341.1 M  |   235 M   |


### **5.** OpenMP para Kernel `ijk`

```c
void gemm5(float *a, float *b, float *c, int n) {
    int i, j, k;
    float cij;

    for (i = 0; i < n; ++i)
    {
        for (j = 0; j < n; ++j)
        {
            cij = a[i * n + j];
			#pragma omp simd reduction(+:cij)
            for (k = 0; k < n; ++k)
            {
                cij += a[i * n + k] * b[j * n + k];
            }
			c[i * n + j] = cij;
        }
    }
}
```

#### **a)** Execute a versão `gemm4()` (`srun –-partition=cpar ./gemm 32 5`) da multiplicação de matrizes e preencha a Tabela 3. O que justifica a diminuição do tempo de execução (#CC mais baixo) em relação a versão `ikj` (análise o kernel)? 


|   n      |  #CC     |   CPI   |    #I    |
|  :-:     |  :-:     |   :-:   |    :-:   |
|   32     |  36.33 K |  0.3565  |  101.9 K |
|   128    |  1.744 M |  0.3657  |  4.769 M |
|   512    |  107.2 M |  0.3862 |  277.6 M |