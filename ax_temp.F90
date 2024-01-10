module ax_temp
  use iso_c_binding, only: c_int, c_ptr
  use num_types, only : rp, c_rp
  implicit none 

  interface  
     type(c_ptr) function dace_init(ne) &
             bind(c, name='__dace_init_ax') 
             use, intrinsic :: iso_c_binding
             type(c_ptr) :: handle
             integer(c_int) :: ne !,lx
     end function dace_init
   end interface


   interface 
     subroutine dace_delete(handle) & 
             bind(c, name='__dace_exit_ax') 
             use, intrinsic :: iso_c_binding 
             type(c_ptr), value :: handle
     end subroutine dace_delete
   end interface

   interface
     subroutine ax_temp_evaluate(handle, u_d, w_d, & 
         ! dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, &
         ! g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, &
         ! h1_d, u_d, w_d, LX, 
         ne) &
          bind(c, name='__program_ax')
       use, intrinsic :: iso_c_binding
       type(c_ptr), value :: handle
       type(c_ptr), value :: w_d, u_d
       !type(c_ptr), value :: dx_d, dy_d, dz_d
       !type(c_ptr), value :: dxt_d, dyt_d, dzt_d
       !type(c_ptr), value :: h1_d, g11_d, g22_d, g33_d, g12_d, g13_d, g23_d
       integer(c_int), value :: ne !,LX
     end subroutine ax_temp_evaluate
  end interface

end module ax_temp

