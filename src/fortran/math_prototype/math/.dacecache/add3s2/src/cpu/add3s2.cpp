/* DaCe AUTO-GENERATED FILE. DO NOT MODIFY */
#include <dace/dace.h>
#include "../../include/hash.h"

struct add3s2_t {
    dace::cuda::Context *gpu_context;
};

DACE_EXPORTED void __dace_runkernel_add3s2_18_0_0_0(add3s2_t *__state, double * __restrict__ a, const double * __restrict__ b, const double * __restrict__ c, int NE, const double c1, const double c2);
void __program_add3s2_internal(add3s2_t *__state, double * __restrict__ a, double * __restrict__ b, double * __restrict__ c, int NE, double c1, double c2)
{

    {

        __dace_runkernel_add3s2_18_0_0_0(__state, a, b, c, NE, c1, c2);
        cudaStreamSynchronize(__state->gpu_context->streams[0]);


    }
}

DACE_EXPORTED void __program_add3s2(add3s2_t *__state, double * __restrict__ a, double * __restrict__ b, double * __restrict__ c, int NE, double c1, double c2)
{
    __program_add3s2_internal(__state, a, b, c, NE, c1, c2);
}
DACE_EXPORTED int __dace_init_cuda(add3s2_t *__state, int NE);
DACE_EXPORTED int __dace_exit_cuda(add3s2_t *__state);

DACE_EXPORTED add3s2_t *__dace_init_add3s2(int NE)
{
    int __result = 0;
    add3s2_t *__state = new add3s2_t;


    __result |= __dace_init_cuda(__state, NE);

    if (__result) {
        delete __state;
        return nullptr;
    }
    return __state;
}

DACE_EXPORTED void __dace_exit_add3s2(add3s2_t *__state)
{
    __dace_exit_cuda(__state);
    delete __state;
}

