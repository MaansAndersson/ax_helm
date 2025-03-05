
! All rights reserved.
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions
! are met:
! * Redistributions of source code must retain the above copyright
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
!  use num_types
  use coefs, only : coef_t
  use space, only : space_t
  use mesh, only : mesh_t
  use field, only : field_t
  use ax_product, only : ax_t
  use device_math, only : device_addcol4
  use device, only : device_get_ptr
  use opencl_intf !!!! Why is this
  use num_types, only : rp, c_rp, i8
  use, intrinsic :: iso_c_binding, only : c_ptr, c_int, C_NULL_PTR
  use axmod

  implicit none
  ! Why is this problematic?
  type(c_ptr), bind(c) :: handle = C_NULL_PTR

  type, abstract, extends(ax_t) :: dace_ax_t
   contains
     procedure, nopass :: compute => dace_ax_helm_device_compute
     procedure, pass(this) :: compute_vector => ax_helm_device_compute_vector
  !   procedure, nopass :: init => dace_ax_helm_device_init
  !   procedure, nopass :: free => dace_ax_helm_device_free
  end type dace_ax_t

  type, public, extends(dace_ax_t) :: dace_ax_helm_device_t
  end type dace_ax_helm_device_t


  interface
    subroutine dace_ax_helm_device_delete(handle) &
            bind(c, name='del_ax')
            use, intrinsic :: iso_c_binding
            type(c_ptr), value :: handle
    end subroutine dace_ax_helm_device_delete
  end interface

contains
  subroutine dace_ax_helm_device_compute(w, u, coef, msh, Xh)
    type(mesh_t),  intent(inout) :: msh
    type(space_t), intent(inout) :: Xh
    type(coef_t),  intent(inout) :: coef
    real(kind=rp), intent(inout) :: w(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: u(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    type(c_ptr) :: u_d, w_d

    u_d = device_get_ptr(u)
    w_d = device_get_ptr(w)

    call dace_ax_helm_device_evaluate_CPP(handle, &
         Xh%dx_d, Xh%dxt_d, &
         Xh%dy_d, Xh%dyt_d, &
         Xh%dz_d, Xh%dzt_d, &
         coef%G11_d, coef%G12_d, coef%G13_d, &
         coef%G22_d, coef%G23_d, coef%G33_d, &
         coef%h1_d, &
         u_d, &
         w_d, &
         Xh%lx, msh%nelv)
    if (coef%ifh2) then
       call device_addcol4(w_d ,coef%h2_d, coef%B_d, u_d, coef%dof%size())
    end if
  end subroutine dace_ax_helm_device_compute

  subroutine dace_ax_helm_device_init(lx, ne)
    integer, intent(inout) :: lx, ne
    handle = dace_ax_init(lx,ne)

  end subroutine dace_ax_helm_device_init

  subroutine dace_ax_helm_device_free(lx)
    integer :: lx
    call dace_ax_helm_device_delete(handle)
  end subroutine

  subroutine ax_helm_device_compute_vector(this, au, av, aw, u, v, w, coef, msh, Xh)
    class(dace_ax_t), intent(in) :: this
    type(space_t), intent(inout) :: Xh
    type(mesh_t), intent(inout) :: msh
    type(coef_t), intent(inout) :: coef
    real(kind=rp), intent(inout) :: au(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: av(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: aw(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: u(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: v(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
    real(kind=rp), intent(inout) :: w(Xh%lx, Xh%ly, Xh%lz, msh%nelv)

    call this%compute(au, u, coef, msh, Xh)
    call this%compute(av, v, coef, msh, Xh)
    call this%compute(aw, w, coef, msh, Xh)
  end subroutine
end module dace_ax_helm_device
