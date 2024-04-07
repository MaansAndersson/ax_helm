module ax8mod
  use num_types, only : rp, c_rp
  use, intrinsic :: iso_c_binding , only : c_ptr, c_int
  implicit none


   interface  
     type(c_ptr) function dace_ax_init8(LX, NE) &
             bind(c, name='__dace_init_ax8')  
             use, intrinsic :: iso_c_binding
             type(c_ptr) :: handle
             integer(c_int) :: LX, NE 
     end function dace_ax_init8
   end interface

  interface
    subroutine dace_ax_helm_device_evaluate8(handle, &
         dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, &
         g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, &
         h1_d, &
         u_d, &
         w_d, lx, ne) &
         bind(c, name='__program_ax8')
      use, intrinsic :: iso_c_binding
      import c_rp
      type(c_ptr), value :: handle
      type(c_ptr), value :: w_d, u_d
      type(c_ptr), value :: dx_d, dy_d, dz_d
      type(c_ptr), value :: dxt_d, dyt_d, dzt_d
      type(c_ptr), value :: h1_d, g11_d, g22_d, g33_d, g12_d, g13_d, g23_d
      integer(c_int), value :: NE, LX
    end subroutine dace_ax_helm_device_evaluate8
  end interface
end module ax8mod
