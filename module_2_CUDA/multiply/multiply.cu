#include <stdio.h>
#include <stdlib.h>

/*
 * add.c
 * 
 * Adds two numbers using the CPU.
 */



#define cudaCheckErrors(msg) \
    do { \
        cudaError_t __err = cudaGetLastError(); \
        if (__err != cudaSuccess) { \
            fprintf(stderr, "Fatal error: %s (%s at %s:%d)\n", \
                msg, cudaGetErrorString(__err), \
                __FILE__, __LINE__); \
            fprintf(stderr, "*** FAILED - ABORTING\n"); \
            exit(1); \
        } \
    } while (0)


__global__
void add(int* a, int* b, int* c) {
    *c = *a * *b;
}

int main() {
    int a, b, c;
    int *d_a, *d_b, *d_c;

    cudaMalloc((void **)&d_a, sizeof(int));  
    cudaMalloc((void **)&d_b, sizeof(int));
    cudaMalloc((void **)&d_c, sizeof(int));
    cudaCheckErrors("cudaMalloc fail");

    a = 9;
    b = 10;

    cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaCheckErrors("cudaMemcpy 1 fail");
    cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
    cudaCheckErrors("cudaMemcpy 2 fail");

    add<<<1,1>>>(d_a, d_b, d_c);

    cudaMemcpy(&c, d_c, sizeof(int),cudaMemcpyDeviceToHost);
    cudaCheckErrors("cudaMemcpy 3 fail");

    cudaDeviceSynchronize();

    printf("GPU says: %d * %d = %d\n", a, b, c);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
