# Trabalho de casa #1

**Data**: 23-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução dos exercícios

```c

void gemm3 (float *a, float *b, float *c, int n) {

    int oi, oj, ok; // outer loops 
    int  i,  j,  k; // inner loops
    float cij;      

    for (oi = 0; oi < n; oi += BLOCKSIZE )
    {
        for (oj = 0; oj < n; oj += BLOCKSIZE )
        {
            for (ok = 0; ok < n; ok += BLOCKSIZE ) 
            {
                for(i = oi; i < oi + BLOCKSIZE; i++)
                {
                    for(j = oj; j < oj + BLOCKSIZE; j++)
                    {
                        cij = c[i * n + j];

                        for(k = ok; k < ok + BLOCKSIZE; k++)
                        {
                            cij += a[i * n + k] * b[k * n + j]
                        }

                        c[i * n + j] = cij;
                    }
                }
            }
        }
    }
}

```

Para n = 512,

### Gemm 1

|BLOCKSIZE| Texec (μs) |  #CC    |   #I    |   CPI    |   L1_DCM |
|   :-:   |     :-:    |  :-:    |  :-:    |   :-:    |    :-:   |
|   ---   |   265429   |794300601|941887957|0.84330689|134864607 |


### Gemm 3

|BLOCKSIZE| Texec (μs) |  #CC    |   #I     |   CPI    |   L1_DCM |
|   :-:   |     :-:    |  :-:    |  :-:     |   :-:    |    :-:   |
|    8    |   148732   |430315530|1107346420|0.38860064|7664997   |
|   16    |   139348   |416961020|1010539310|0.41261237|19726719  |
|   32    |   174286   |504067501|974026848 |0.51750884|140839319 |
|   64    |   164415   |475636680|956535151 |0.49724956|139144984 |



