#include <cstdlib>
#include "../include/add3s2.h"

int main(int argc, char **argv) {
    add3s2Handle_t handle;
    int NE = 42;
    double c1 = 42;
    double c2 = 42;
    double * __restrict__ a = (double*) calloc(NE, sizeof(double));
    double * __restrict__ b = (double*) calloc(NE, sizeof(double));
    double * __restrict__ c = (double*) calloc(NE, sizeof(double));


    handle = __dace_init_add3s2(NE);
    __program_add3s2(handle, a, b, c, NE, c1, c2);
    __dace_exit_add3s2(handle);

    free(a);
    free(b);
    free(c);


    return 0;
}
