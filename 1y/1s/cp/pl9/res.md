# PL09

**Data**: 09-12-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

---

## Resolução de Exercícios

### **1.** 1D stencil  

```c
void launchStencilKernel (float *a, float *c) {
        // pointers to the device memory
        float *da, *dc;
        // declare variable with size of the array in bytes
        int bytes = SIZE * sizeof(float);

        // allocate the memory on the device
        cudaMalloc ((void**) &da, bytes);
        cudaMalloc ((void**) &dc, bytes);
        checkCUDAError("mem allocation");

        // copy inputs to the device
        cudaMemcpy (da, a, bytes, cudaMemcpyHostToDevice);
        checkCUDAError("memcpy h->d");

        // launch the kernel
        startKernelTime ();
        stencilKernel <<< NUM_THREADS_PER_BLOCK, NUM_BLOCKS >>> (da,dc);
        stopKernelTime ();
        checkCUDAError("kernel invocation");

        // copy the output to the host
        cudaMemcpy (c, dc, bytes, cudaMemcpyDeviceToHost);
        checkCUDAError("memcpy d->h");

        // free the device memory
        cudaFree(da);
        cudaFree(dc);
        checkCUDAError("mem free");
}
```

```c
__global__ 
void stencilKernel (float *a, float *c) {
        int id = blockIdx.x * blockDim.x + threadIdx.x;

        // **************
        // to be used only on exercise 2
        //__shared__ float temp[NUM_THREADS_PER_BLOCK + ?];
        // now, fill the temp array
        //temp[threadIdx.x] = ?
        //__syncthreads();
        // **************

        // initialise the array with the results
        c[id] = 0;

        // iterate through the neighbours required to calculate
        // the values for the current position of c
        //for (int i = ?; i < ?; i++) {
        //      ??
        //}

        for (int i = -2; i < 3; i++) {
                if(id + i >= 0 && id + i < SIZE) {
                        c[id] += a[id + i];
                }
        }
}
```


| | Toriginal | T 2 x NUM_BLOCKS | T 16 viz (1 x NUM_BLOCKS) |T 16 viz (2 x NUM_BLOCKS)|
|:-:| :- | :- | :- | :- |
|Kernel| ~ 10 $\mu$s| ~13 $\mu$s |~19 $\mu$s | ~34 $\mu$s |
|h->d| ~ 20 $\mu$s  | ~ 44 $\mu$s|~20 $\mu$s | ~ 44 $\mu$s|
|d->h| ~ 20 $\mu$s  | ~ 40 $\mu$s|~20 $\mu$s | ~ 40 $\mu$s|

---

### **2.** Sharing memory among CUDA threads

### Consider the implementation of `stencilKernel` developed in 1.b). Extend the code so that all input data required for the CUDA threads of a given block is stored  in  shared  memory.  Pay  close  attention  to  the comments on the code that may hint to the steps required for this implementation. 