!> Test with a c_struct type tp control dace handle
!! 
!!
module dace_types
  use iso_c_binding, only: c_int
  implicit none 
  type, bind(c) :: dace_handle_t
    integer(c_int) :: lx
    integer(c_int) :: lx3
    integer(c_int) :: ne
    integer(c_int) :: Klx2
  end type
end module dace_types  

