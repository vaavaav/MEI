# PL08

**Data**: 02-12-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Resolução de Exercícios

### **1.** Prime calculation using the Sieve of Eratosthenes 

#### **a)** Parallelize  the  code  using  MPI  through  the  implementation  of  a  pipeline  of  processes  that  receives an array of integers, created by the generate function, and each process filters out a subset of the input. The mprocess method implements the filtering of the primes, and end prints the final amount of primes found.  This  pipeline  should  have  3  processes, one for each instance of PrimeServer performing the filtering. 

#### **b)** Modify the parallelization implemented in a) to work with an arbitrary number of processes and messages.   

#### **c)** Parallelize the sequential application through the implementation of a farm of processes behaving in a "work sharing" paradigm with dynamic scheduling. 
