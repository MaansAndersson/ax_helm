
#include <cuda_runtime.h>
#include <dace/dace.h>


struct add3s2_t {
    dace::cuda::Context *gpu_context;
};



DACE_EXPORTED int __dace_init_cuda(add3s2_t *__state, int NE);
DACE_EXPORTED void __dace_exit_cuda(add3s2_t *__state);



int __dace_init_cuda(add3s2_t *__state, int NE) {
    int count;

    // Check that we are able to run cuda code
    if (cudaGetDeviceCount(&count) != cudaSuccess)
    {
        printf("ERROR: GPU drivers are not configured or cuda-capable device "
               "not found\n");
        return 1;
    }
    if (count == 0)
    {
        printf("ERROR: No cuda-capable devices found\n");
        return 2;
    }

    // Initialize cuda before we run the application
    float *dev_X;
    cudaMalloc((void **) &dev_X, 1);
    cudaFree(dev_X);

    

    __state->gpu_context = new dace::cuda::Context(1, 1);

    // Create cuda streams and events
    for(int i = 0; i < 1; ++i) {
        cudaStreamCreateWithFlags(&__state->gpu_context->streams[i], cudaStreamNonBlocking);
    }
    for(int i = 0; i < 1; ++i) {
        cudaEventCreateWithFlags(&__state->gpu_context->events[i], cudaEventDisableTiming);
    }

    

    return 0;
}

void __dace_exit_cuda(add3s2_t *__state) {
    

    // Destroy cuda streams and events
    for(int i = 0; i < 1; ++i) {
        cudaStreamDestroy(__state->gpu_context->streams[i]);
    }
    for(int i = 0; i < 1; ++i) {
        cudaEventDestroy(__state->gpu_context->events[i]);
    }

    delete __state->gpu_context;
}

__global__ void add3s2_18_0_0_0(double * __restrict__ a, const double * __restrict__ b, const double * __restrict__ c, int NE, const double c1, const double c2) {
    {
        int i = (blockIdx.x * 32 + threadIdx.x);
        double __tmp1;
        double __tmp2;
        double __tmp3;
        if (i < NE) {
            {
                double __in1 = c1;
                double __in2 = b[i];
                double __out;

                ///////////////////
                // Tasklet code (_Mult_)
                __out = (__in1 * __in2);
                ///////////////////

                __tmp1 = __out;
            }
            {
                double __in1 = c2;
                double __in2 = c[i];
                double __out;

                ///////////////////
                // Tasklet code (_Mult_)
                __out = (__in1 * __in2);
                ///////////////////

                __tmp2 = __out;
            }
            {
                double __in2 = __tmp2;
                double __in1 = __tmp1;
                double __out;

                ///////////////////
                // Tasklet code (_Add_)
                __out = (__in1 + __in2);
                ///////////////////

                __tmp3 = __out;
            }
            {
                double __inp = __tmp3;
                double __out;

                ///////////////////
                // Tasklet code (assign_19_8)
                __out = __inp;
                ///////////////////

                a[i] = __out;
            }
        }
    }
}


DACE_EXPORTED void __dace_runkernel_add3s2_18_0_0_0(add3s2_t *__state, double * __restrict__ a, const double * __restrict__ b, const double * __restrict__ c, int NE, const double c1, const double c2);
void __dace_runkernel_add3s2_18_0_0_0(add3s2_t *__state, double * __restrict__ a, const double * __restrict__ b, const double * __restrict__ c, int NE, const double c1, const double c2)
{

    void  *add3s2_18_0_0_0_args[] = { (void *)&a, (void *)&b, (void *)&c, (void *)&NE, (void *)&c1, (void *)&c2 };
    cudaLaunchKernel((void*)add3s2_18_0_0_0, dim3(int_ceil(int_ceil(NE, 1), 32), 1, 1), dim3(32, 1, 1), add3s2_18_0_0_0_args, 0, __state->gpu_context->streams[0]);
}

