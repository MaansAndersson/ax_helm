#include "include/ax.h"
#include "include/add3s2.h"

#include <cstdio>

add3s2Handle_t init_add3s2(int NE){
  return __dace_init_add3s2(NE);
}

void eval_add3s2(add3s2Handle_t handle, double * __restrict__ a, double * __restrict__ b, double * __restrict__ c, int NE, double c1, double c2){
  __program_add3s2(handle, a, b, c, NE, c1, c2);
}

void delete_add3s2(add3s2Handle_t handle){
  int err = __dace_exit_add3s2(handle);
}

axHandle_t gen_handle(int lx, int ne){
 switch (lx) {
    case 8:
      return __dace_init_ax8(lx, ne);
    case 7:
      return __dace_init_ax7(lx, ne);
    case 6:
      return __dace_init_ax6(lx, ne);
    case 5:
      return __dace_init_ax5(lx, ne);
    case 4:
      return __dace_init_ax4(lx, ne);
    case 3:
      return __dace_init_ax3(lx, ne);
    case 2:
      return __dace_init_ax2(lx, ne);
   default:
      return __dace_init_ax8(lx, ne);
}
}

void eval_ax(axHandle_t handle, double * dx_d, double * dxt_d, double * dy_d, double * dyt_d, double * dz_d, double * dzt_d, double * g11_d, double * g12_d, double * g13_d, double * g22_d, double * g23_d, double * g33_d, double * h1_d, double * u_d, double * w_d, int lx, int ne){

  switch (lx) {
    case 8:
      __program_ax8(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 7:
      __program_ax7(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 6:
      __program_ax6(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 5:
      __program_ax5(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 4:
      __program_ax4(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 3:
      __program_ax3(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
    case 2:
      __program_ax2(handle, dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, h1_d, u_d, w_d, lx, ne);
      break;
  };
}

// What the fuck is happening here?
void del_ax(axHandle_t handle){
 int err;
 int lx = 8;
 switch (lx) {
    case 8:
      err = __dace_exit_ax8(handle);
      break;
    case 7:
      err = __dace_exit_ax7(handle);
      break;
    case 6:
      err = __dace_exit_ax7(handle);
      break;
    case 5:
      err = __dace_exit_ax7(handle);
      break;
    case 4:
      err = __dace_exit_ax7(handle);
      break;
    case 3:
      err = __dace_exit_ax7(handle);
      break;
    case 2:
      err = __dace_exit_ax7(handle);
      break;
   default:
      err = __dace_exit_ax8(handle);
      break;
 };
}


