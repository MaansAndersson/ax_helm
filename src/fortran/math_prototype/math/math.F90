module dace_math
  use iso_c_binding, only: c_int, c_ptr
  use num_types, only : rp, c_rp
  implicit none 
 
!  !> Returns \f$ a = c1 * b + c2 * c \f$
!  subroutine add3s2(a, b, c, c1, c2 ,n)
!    integer, intent(in) :: n
!    real(kind=rp), dimension(n), intent(inout) :: a
!    real(kind=rp), dimension(n), intent(in) :: b
!    real(kind=rp), dimension(n), intent(in) :: c
!    real(kind=rp), intent(in) :: c1, c2
!    integer :: i
!
!    do i = 1,n
!       a(i) = c1 * b(i) + c2 * c(i)
!    end do
!
!  end subroutine add3s2

   interface  
     type(c_ptr) function hidden__dace_add3s2_init(ne) &
             bind(c, name='__dace_init_add3s2') 
               use, intrinsic :: iso_c_binding
             type(c_ptr) :: handle
             integer(c_int) :: ne
     end function hidden__dace_add3s2_init
   end interface

   interface 
     subroutine dace_add3s2_delete(handle) & 
             bind(c, name='__dace_exit_add3s2') 
             use, intrinsic :: iso_c_binding 
             type(c_ptr), value :: handle
     end subroutine dace_add3s2_delete
   end interface

   ! Note the order of the input parameters are not consistent 
   ! between the Python script and the SDFG generated code.
   interface
     subroutine dace_device_add3s2(handle, a, b, c, ne, c0, c1) &
       bind(c, name='__program_add3s2')
       use, intrinsic :: iso_c_binding
       import c_rp
       !import :: dace_handle_t
       type(c_ptr), value :: handle
       type(c_ptr), value :: a, b, c 
       real(c_rp), value :: c0, c1
       integer(c_int), value :: ne
     end subroutine dace_device_add3s2
  end interface

end module dace_math

