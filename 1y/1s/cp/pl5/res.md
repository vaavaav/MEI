# PL05

**Data**: 11-11-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Resolução de Exercícios

### **1.** Data sharing with OpenMP 

#### **1.0**

##### **a)** 

For every thread, the `w` is increasing through the iterations `i`. But to an individual thread, `w` is not sequential.   

##### **b)** 

Yes, this is caused by two or more threads accessing the same memory region (the critial regions, which is `w` in this case) simultaneously.  

##### **c)** 

No, it's impossible to estimate the correct value of `w` at the end of the execution because of race conditions.

#### **1.1** `private(w)`

##### **a)** 

For every thread, the `w` is increasing sequential through the iterations `i`. Because of `private(w)`, the variable `w` is not a shared memory region to each thread anymore. So, for each thread the number goes up from 0 to $\frac{100}{\text{number of threads}} - 1$. 

##### **b)** 

No, for each thread the number goes up from 0 $\frac{100}{\text{number of threads}} - 1$.

##### **c)** 

No, it would be expected that in the master thread, the number would go up from 10 to $10 + \frac{100}{\text{number of threads}} - 1$


#### **1.2** `firstprivate(w)`

##### **a)** 

Because of `firstprivate(w)` the initial value of `w` is 10 and the same to all of the threads.
The first value of `w` before the critical region is the one already assigned.

##### **b)** 

No, for each thread the number goes up from 10 to $10 + \frac{100}{\text{number of threads}} - 1$.

##### **c)** 

No, this is because the value of `w` does not change because it is private. So, it remains at 10.


#### **1.3** `lastprivate(w)`

##### **a)** 

The value is the same for all the threads. But starts at 0.

##### **b)** 

No, for each thread the number goes up from 0 to $\frac{100}{\text{number of threads}} - 1$.

##### **c)**

Yes, the number is  $10 + \frac{100}{\text{number of threads}}$. This is because, the last value of `w` after the critical region, is the one that will be assigned to it.

#### **1.4** `reduction(+:w)`

Reduction privatizes the variable and in the end does the respective reduction operation (`+`, in this case).

##### **a)** 

The value is the same for all the threads. But starts at 0.

##### **b)** 

No, for each thread the number goes up from 0 to $\frac{100}{\text{number of threads}} - 1$.

##### **c)** 

Yes, it is $10 + \text{number of threads} \cdot \frac{100}{\text{number of threads}} = 10 + 100 = 110$.

--- 

### **2.** Data races in OpenMP 

#### **a)**

Yes, this is caused by two or more threads accessing the same memory region (the critial regions, which is `dot` in this case) simultaneously. (Concurrency problem)

#### **b)**

With the increasing number of threads, the number of simultaneous accesses to the same memory region(concurrency problems) becomes more and more frequent. So, with 2 threads the results it's almost the same all the time, but with 4 and 8 the problems become more apparent.

#### **c)**


```
#include<omp.h> 
#include<stdio.h> 
#define size 100000 
double a[size], b[size]; 
int main() { 
   // init vectors 
    for(int i=0;i<size; i++) { 
            a[i] = 1.0/((double) (size-i)); 
            b[i] = a[i] * a[i]; 
    } 
    // compute dot product 
    double dot = 0; 
#pragma omp parallel for
    for(int i=0;i<size; i++) { 
#pragma omp critical
        dot += a[i]*b[i]; 
    } 
    printf("Dot is %18.16f\n",dot); 
}
```
Now, `dot` can be accessed by one and only one thread at a time. 
Note: this won't give the exact correct value because of problems with sum of floats (e.g, 0.1 + 0.2 ≠ 0.3, but 0.1 + 0.2 ≈ 0.3).


#### **d)**

```
#include<omp.h> 
#include<stdio.h> 
#define size 100000 
double a[size], b[size]; 
int main() { 
   // init vectors 
    for(int i=0;i<size; i++) { 
            a[i] = 1.0/((double) (size-i)); 
            b[i] = a[i] * a[i]; 
    } 
    // compute dot product 
    double dot = 0; 
#pragma omp parallel for reduction (+:dot)
    for(int i=0;i<size; i++) { 
        dot += a[i]*b[i]; 
    } 
    printf("Dot is %18.16f\n",dot); 
}
```

Now, `dot` is private to each thread. The calculated dot product of the matrices depends on `i`, the weight is equally distributed to each thread and each thread calculates products that no other threads does. So, there are no waiting times (for a thread to reach the critical region), because there is no critical region.
Note: this won't give the exact correct value because of problems with sum of floats (e.g, 0.1 + 0.2 ≠ 0.3, but 0.1 + 0.2 ≈ 0.3).

---

### **3.** Parallelisation scalability

```
#include<omp.h> 
#include<stdio.h> 

double f( double a ) { 
    return (4.0 / (1.0 + a*a)); 
} 
double pi = 3.141592653589793238462643; 
int main() { 
    double mypi = 0; 
    int n = 1000000000; // number of points to compute 
    float h = 1.0 / n; 
    #pragma omp parallel for reduction (+:mypi)
    for(int i=0; i<n; i++) { 
        mypi = mypi + f(i*h); 
    } 
    mypi = mypi * h; 
    printf(" pi = %.10f \n", mypi); 
} 
```

|Threads|T(ms)    | Speedup           |
|   :-: |:-       |:-                 |
|   1   |  6 487  |   -               |
|   2   |  3 316  |   1.96 $\times$   |
|   4   |  1 732  |   3.75 $\times$   |
|   8   |    959  |   6.76 $\times$   |
|   16  |    547  |  11.86 $\times$   |


The machine used in the PL classes have 2 CPU with 8 cores each. So when the number of threads is greater than 8, the other CPU is used aswell. Because each of the CPU has it's own memory, but `mypi` is firstly allocated only in one of the them. Because of `reduction(+:mypi)` the threads in the second CPU have to go the the other CPU's memory and get value of `mypi`. The same process happens after the `for-loop` to process the reduction (write operation). 