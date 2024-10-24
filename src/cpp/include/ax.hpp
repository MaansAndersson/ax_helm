#include <dace/dace.h>
#include "ax2.h"
#include "ax3.h"
#include "ax4.h"
#include "ax5.h"
#include "ax6.h"
#include "ax6.h"
#include "ax7.h"
#include "ax8.h"


typedef void * axHandle_t;
extern "C" axHandle_t gen_handle(int lxx, int ne);
extern "C" void del_ax(axHandle_t handle);
extern "C" void eval_ax(axHandle_t handle, double * __restrict__ dx_d, double * __restrict__ dxt_d, double * __restrict__ dy_d, double * __restrict__ dyt_d, double * __restrict__ dz_d, double * __restrict__ dzt_d, double * __restrict__ g11_d, double * __restrict__ g12_d, double * __restrict__ g13_d, double * __restrict__ g22_d, double * __restrict__ g23_d, double * __restrict__ g33_d, double * __restrict__ h1_d, double * __restrict__ u_d, double * __restrict__ w_d, int lxx, int ne);

typedef void * add3s2Handle_t;
extern "C" add3s2Handle_t init_add3s2(int NE);
extern "C" void delete_add3s2(add3s2Handle_t handle);
extern "C" void eval_add3s2(add3s2Handle_t handle, double * __restrict__ a, double * __restrict__ b, double * __restrict__ c, int NE, double c1, double c2);
