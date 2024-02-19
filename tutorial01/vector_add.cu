// cuda_hello.c


#include <stdio.h>
#define N 10000000

__global__ void vector_add(float *out, float *a, float *b, int n) {
    for (int i = 0; i < n; i++) {
        out[i] = a[i] + b[i];
    }
}

int main() {
    float *a = (float*)malloc(sizeof(float) * N);
    float *b = (float*)malloc(sizeof(float) * N);
    float *out = (float*)malloc(sizeof(float) * N);
    for (int i = 0; i < N; ++i) {
        a[i] = 1.0f; b[i] = 2.0f;
    }
    vector_add<<<1,1>>>(out,a,b,N);
    for (int i = 10; i < 20; ++i) {
        printf("%f\n", out[i]);
    }
    return 0;
}
