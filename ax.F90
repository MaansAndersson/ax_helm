! Copyright (c) 2020-2021, The Neko Authors
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
!> Defines a Matrix-vector product
module ax_product_dace
  use num_types
  !use dace_types
  use coefs
  use space
  use field
  use mesh
  use, intrinsic :: iso_c_binding, only : c_ptr, c_int
  implicit none

  !> Base type for a matrix-vector product providing \f$ Ax \f$
  type, abstract :: ax_dace_t
   contains
     procedure(ax_compute), nopass, deferred :: compute
     procedure(ax_init),    nopass, deferred :: init
     procedure(ax_delete),  nopass, deferred :: delete
  end type ax_dace_t

  !> Abstract interface for computing\f$ Ax \f$ inside a Krylov method
  !!
  !! @param handle
  !! @param w vector of size @a (lx,ly,lz,nelv)
  !! @param u vector of size @a (lx,ly,lz,nelv)
  !! @param coef Coefficients
  !! @param msh mesh
  !! @param Xh function space \f$ X_h \f$
  abstract interface
  subroutine ax_compute(handle, w, u, coef, msh, Xh)
       import space_t
       import mesh_t
       import coef_t
       import ax_dace_t
       import rp
       import c_ptr
       implicit none
       type(c_ptr),   intent(inout) :: handle     
       type(space_t), intent(inout) :: Xh
       type(mesh_t),  intent(inout) :: msh              
       type(coef_t),  intent(inout) :: coef
       real(kind=rp), intent(inout) :: w(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
       real(kind=rp), intent(inout) :: u(Xh%lx, Xh%ly, Xh%lz, msh%nelv)
     end subroutine ax_compute
  end interface 

  !> Abstract interface for setting up\f$ Ax \f$ computation with dace
  !!
  !! @param handle 
  !! @param lx 
  !! @param ne    
  abstract interface
    subroutine ax_init(handle, lx, ne)
       import c_ptr
       implicit none
       type(c_ptr), intent(inout) :: handle     
       integer :: lx
       integer :: ne
    end subroutine
  end interface
  
  !> Abstract interface for setting up\f$ Ax \f$ computation with dace
  !!
  !! @param handle (pointer to c-struct?)
  abstract interface
    subroutine ax_delete(handle)
      import c_ptr
      implicit none
      type(c_ptr), value :: handle 
    end subroutine
  end interface


end module ax_product_dace
