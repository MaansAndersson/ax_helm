! Copyright (c) 2021-2023, The Neko Authors
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
module ax_helm_dace_fctry
  use neko_config
  use ax_product, only : ax_t
  use ax_product_dace, only : ax_dace_t
  use ax_helm_device, only : ax_helm_device_t
  use ax_helm_xsmm, only : ax_helm_xsmm_t
  use ax_helm_sx, only : ax_helm_sx_t
  use ax_helm, only : ax_helm_t
  use ax_helm_dace_device, only : ax_helm_dace_device_t
  implicit none
  private

  public :: ax_helm_dace_factory, ax_dace_t

contains

  subroutine ax_helm_dace_factory(Ax)
    class(ax_dace_t), allocatable, intent(inout) :: Ax
    
    !write(*,*) 'In my Factory'
    if (allocated(Ax)) then
       deallocate(Ax)
    end if

    !if (1 .eq. 0) then  
    !  if (NEKO_BCKND_SX .eq. 1) then
    !     allocate(ax_helm_sx_t::Ax)
    !  else if (NEKO_BCKND_XSMM .eq. 1) then
    !     allocate(ax_helm_xsmm_t::Ax)
    !  else if (NEKO_BCKND_DEVICE .eq. 1)then
    !     allocate(ax_helm_device_t::Ax)
    !end if 
    !else if (NEKO_BCKND_DEVICE .eq. 100)then
    !   allocate(ax_helm_t::Ax)
    !else 
    !   write(*,*) 'In DaCe'
       allocate(ax_helm_dace_device_t::Ax)
    !   write(*,*) 'Fin ax_helm_dace allocate'
    !end if 
    !write(*,*) 'Out my Factory'
  end subroutine ax_helm_dace_factory

end module ax_helm_dace_fctry
