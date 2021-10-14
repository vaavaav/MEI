# PL01

**Data**: 14-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução de Exercícios
### 1.

**a)** O(c × N × N × N) = O(N<sup>3</sup>)


$T_{exec} = #CC × T_{cc}$
    = #CC × 1/f <br>
    = (#I × CPI) / f 

 - T<sub>exec</sub> : Tempo médio de execução
 - T<sub>cc</sub> : Tempo por ciclo de _clock_
 - #CC : Número de ciclos de _clock_
 - f : frequência do CPU
 - #I : número de instruções
 - CPI : Ciclos por instrução

Com a duplicação do N, o tempo irá aumentar em 8x.

O mais afetado é o número de instruções (que também irá aumentar).

**b)**

Ciclo mais interior é a com etiqueta `L5`

- Versão normal: 28 linhas

```assembly
.L5:
	movl	-4(%rbp), %eax
	imull	-44(%rbp), %eax
	movl	%eax, %edx
	movl	-12(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm1
	movl	-12(%rbp), %eax
	imull	-44(%rbp), %eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	mulss	%xmm1, %xmm0
	movss	-16(%rbp), %xmm1
	addss	%xmm1, %xmm0
	movss	%xmm0, -16(%rbp)
	addl	$1, -12(%rbp)
.L4:
	movl	-12(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L5
```

- Versão com `-O2`: 7 linhas

```assembly
.L5:
	movss	(%r10,%rax,4), %xmm0
	addq	$1, %rax
	mulss	(%r8), %xmm0
	addq	%r9, %r8
	cmpl	%eax, %ecx
	addss	%xmm0, %xmm1
    jg	.L5
```

### 2.

**a)**

#I<sub>-O0</sub> = 28

O(N<sup>3</sup>)

|<br>N<br>|Tempo<br>medido<br>(µs)|<br>#CC<br>|<br>#I<br>|#I<br>estimado|CPI<br>calculado
|:-:|:-:|:-:|:-:|:-:|:-:|
|128|7646|22866077 = 23 M|59229502 = 59 M|128<sup>3</sup> × 28 = 58.7 M |~ 0.39|
|256|75545|226070914 = 226 M|471796226 = 472 M|256<sup>3</sup> × 28 = 469.8 M|~ 0.48   |
|512|790091|2364659011 = 2 G|3766229961 = 3.77 G|512<sup>3</sup> × 28 = 3.76 M |~ 0.63  |


Speedup<sub>A->B</sub> = B/A

= (N<sup>3</sup> × 28) / (N<sup>3</sup> × 7) = 4


**b)**



### 3.

|<br>linhas<br>|Tempo<br>medido<br>(µs)|<br>#CC<br>|<br>#I<br>|#I<br>estimado|CPI<br>calculado
|:-:|:-:|:-:|:-:|:-:|:-:|
|128||||128<sup>3</sup> × 7 = ? |~ |
|256||||256<sup>3</sup> × 7 = ? |~ |
|512||||512<sup>3</sup> × 7 = ? |~ |


---

Wall clock: O tempo desde que a aplicação começou a executar até acabar. 

User clock: 

System clock:
