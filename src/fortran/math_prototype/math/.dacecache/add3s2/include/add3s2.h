#include <dace/dace.h>
typedef void * add3s2Handle_t;
extern "C" add3s2Handle_t __dace_init_add3s2(int NE);
extern "C" void __dace_exit_add3s2(add3s2Handle_t handle);
extern "C" void __program_add3s2(add3s2Handle_t handle, double * __restrict__ a, double * __restrict__ b, double * __restrict__ c, int NE, double c1, double c2);
