# PL07

**Data**: 25-11-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Resolução de Exercícios

### **1.** Pipeline of processes 

#### **a)** Start by modifying the program to support a pipeline with four processes:  process with rank 0 sends the message that is successively processed (e.g., printed) by each process in the pipeline.  

```c
#include <mpi.h> 
#include <stdio.h> 
int main( int argc, char *argv[]) { 
 int rank, msg; 
 MPI_Status status; 
 MPI_Init(&argc, &argv); 
 MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank 
 
 /* Process 0 sends and Process 1 receives */ 
 if (rank == 0) { 
  msg = 123456; 
  MPI_Send( &msg, 1, MPI_INT, 1, 0, MPI_COMM_WORLD); 
 } 
 else if (rank == 1) { 
  MPI_Recv( &msg, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status ); 
  printf( "Rank #%d, Received %d, forwarded to Rank #%d\n", rank, msg, 2); 
  MPI_Send( &msg, 1, MPI_INT, 2, 0, MPI_COMM_WORLD); 
 } 
 else if (rank == 2) {
  MPI_Recv( &msg, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, &status ); 
  printf( "Rank #%d, Received %d, forwarded to Rank #%d\n", rank, msg, 3);
  MPI_Send( &msg, 1, MPI_INT, 3, 0, MPI_COMM_WORLD);
 }
 else if (rank == 3) {
  MPI_Recv( &msg, 1, MPI_INT, 2, 0, MPI_COMM_WORLD, &status ); 
  printf( "Rank #%d, Received %d\n", rank, msg); 
 }
 MPI_Finalize(); 
 return 0; 
}
```

#### **b)** Modify the program developed in **a)** to implement a pipeline with an arbitrary number of processes specified as a parameter in the command `mpirun -np xx`. Note that MPI is based on the SPMD style of parallel programming: the same process will be spawned $xx$ times. The number of processes spawned by the `mpirun` command can be retrieved with the `MPI_Comm_size` call. 

```c
#include <mpi.h> 
#include <stdio.h> 
int main( int argc, char *argv[]) { 
 int rank, msg, n; 
 MPI_Status status; 
 MPI_Init(&argc, &argv); 
 MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank 
 MPI_Comm_size( MPI_COMM_WORLD, &n);
 
 /* Process 0 sends and Process 1 receives */ 
 if (rank == 0) { 
  msg = 123456;
  MPI_Send( &msg, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
  printf( "R%d->: %d\n", rank, msg);
 } 
 else if (rank == n - 1) { 
  MPI_Recv( &msg, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status ); 
  printf( "->R%d: %d\n", rank, msg);
 } 
 else { 
  MPI_Recv( &msg, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status ); 
  printf( "->R%d->: %d\n", rank, msg);
  MPI_Send( &msg, 1, MPI_INT, rank+1, 0, MPI_COMM_WORLD); 
 } 
 MPI_Finalize(); 
 return 0; 
}
```

#### **c)** Modify the program developed in b) to process 10 messages: the process with rank 0 should send 10 messages to the next in the pipeline; each other process should receive a message, process it (e.g., print) and send it to the next one in the pipeline. 

```c
#include <mpi.h> 
#include <stdio.h> 
int main( int argc, char *argv[]) { 
 int rank, msg, n, i; 
 MPI_Status status; 
 MPI_Init(&argc, &argv); 
 MPI_Comm_rank( MPI_COMM_WORLD, &rank ); // gets this process rank 
 MPI_Comm_size( MPI_COMM_WORLD, &n);
 
 /* Process 0 sends and Process 1 receives */ 
 if (rank == 0) { 
  for(i = 0; i < 10; i++) {
   MPI_Send( &i, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
   printf( "R%d->: %d\n", rank, i);
  }
 } 
 else if (rank == n - 1) { 
  for(i = 0; i < 10; i++) {
   MPI_Recv( &msg, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status ); 
   printf( "->R%d: %d\n", rank, msg);
  }
 } 
 else { 
  for(i = 0; i < 10; i++) {
   MPI_Recv( &msg, 1, MPI_INT, rank-1, 0, MPI_COMM_WORLD, &status ); 
   printf( "->R%d->: %d\n", rank, msg);
   MPI_Send( &msg, 1, MPI_INT, rank+1, 0, MPI_COMM_WORLD); 
  } 
 } 
 MPI_Finalize(); 
 return 0; 
}
```

---

### **2.** Farm of processes and collective operations

#### **a)** <u>Static scheduling</u>: set the number of tasks to process equal to the number of MPI worker processes (one task per worker).

#### **b)** <u>Dynamic scheduling</u>: set the number of tasks as 10x the number of MPI worker processes; faster processes should get more tasks.  

#### **c)** <u>Collective operations</u>: a message is broadcasted to all workers and then a reduce with the sum operation joins the results from all workers. 

