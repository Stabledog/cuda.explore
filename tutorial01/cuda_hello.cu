// cuda_hello.c

#include <stdio.h>

__global__ void cuda_hello() {
    printf("Hello world from CUDA");
}

int main(int, char* argc[]) {
    cuda_hello<<<1,1>>>();
    return 0;
}
