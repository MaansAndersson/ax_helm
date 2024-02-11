
! All rights reserved.
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions
! are met:
!
!   * Redistributions of source code must retain the above copyright
!     notice, this list of conditions and the following disclaimer.
!
!   * Redistributions in binary form must reproduce the above
!     copyright notice, this list of conditions and the following
!     disclaimer in the documentation and/or other materials provided
!     with the distribution.
!
!   * Neither the name of the authors nor the names of its
!     contributors may be used to endorse or promote products derived
!     from this software without specific prior written permission.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
! "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
! LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
! FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
! COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
! INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
! BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
! CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
! LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
! ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
! POSSIBILITY OF SUCH DAMAGE.
!
module dace_ax_helm_device
  use num_types
  use coefs
  use device
  use space
  use field
  use mesh 
  use ax_product, only : ax_t 
  use device_math, only : device_addcol4
  use device, only : device_get_ptr
  use num_types, only : rp, c_rp
  use, intrinsic :: iso_c_binding, only : c_ptr, c_int

  implicit none
  type(c_ptr) :: handle

  type, public, extends(ax_t) :: dace_ax_helm_device_t
   contains
     procedure, nopass :: compute => dace_ax_helm_device_compute 
  !   procedure, nopass :: init => dace_ax_helm_device_init
  !   procedure, nopass :: free => dace_ax_helm_device_free
  end type dace_ax_helm_device_t

   interface  
     type(c_ptr) function dace_ax_init(LX, NE) &
             bind(c, name='__dace_init_ax')  
             use, intrinsic :: iso_c_binding
             type(c_ptr) :: handle
             integer(c_int) :: LX, NE 
     end function dace_ax_init
   end interface

   interface 
     subroutine dace_ax_helm_device_delete(handle) & 
             bind(c, name='__dace_exit_ax') 
             use, intrinsic :: iso_c_binding 
             type(c_ptr), value :: handle
     end subroutine dace_ax_helm_device_delete
   end interface

   interface
     subroutine dace_ax_helm_device_evaluate(handle, &
          dx_d, dxt_d, dy_d, dyt_d, dz_d, dzt_d, &
          g11_d, g12_d, g13_d, g22_d, g23_d, g33_d, &
          h1_d, u_d, w_d, lx, ne) &
          bind(c, name='__program_ax')
          use, intrinsic :: iso_c_binding
       import c_rp
       type(c_ptr), value :: handle
       type(c_ptr), value :: w_d, u_d
       type(c_ptr), value :: dx_d, dy_d, dz_d
       type(c_ptr), value :: dxt_d, dyt_d, dzt_d
       type(c_ptr), value :: h1_d, g11_d, g22_d, g33_d, g12_d, g13_d, g23_d
       integer(c_int), value :: NE, LX
     end subroutine dace_ax_helm_device_evaluate
  end interface

contains
  subroutine dace_ax_helm_device_compute(w, u, coef, msh, Xh)
    type(mesh_t),  intent(inout) :: msh
    type(space_t), intent(inout) :: Xh
    type(coef_t),  intent(inout) :: coef
    real(kind=rp), intent(inout) :: w(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: u(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    type(c_ptr) :: u_d, w_d !, handle 
    
    !write(*,*) 'compute()'
    !handle = this%get_handle()

    u_d = device_get_ptr(u)
    w_d = device_get_ptr(w)

    call dace_ax_helm_device_evaluate(handle, &
         Xh%dx_d, Xh%dxt_d, &
         Xh%dy_d, Xh%dyt_d, &
         Xh%dz_d, Xh%dzt_d, &
         coef%G11_d, coef%G12_d, coef%G13_d, &
         coef%G22_d, coef%G23_d, coef%G33_d, &
         coef%h1_d, u_d, w_d, &
         Xh%lx,msh%nelv)
    if (coef%ifh2) then
       call device_addcol4(w_d ,coef%h2_d, coef%B_d, u_d, coef%dof%size())
    end if
    
  end subroutine dace_ax_helm_device_compute
  
  subroutine dace_ax_helm_device_init(lx, ne)
        integer, intent(in) :: lx, ne 
        print *, handle
        handle = dace_ax_init(lx, ne)  
        print *, handle, 'hey'
  end subroutine dace_ax_helm_device_init

  subroutine dace_ax_helm_device_free()
        !type(c_ptr) :: handle  
    call dace_ax_helm_device_delete(handle)
  end subroutine 

end module dace_ax_helm_device
