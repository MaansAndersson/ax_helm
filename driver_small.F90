program test 
  use ax_helm_dace_fctry
  use ax_helm_dace_device
  use dace_types 
  use, intrinsic :: iso_c_binding, only : c_ptr, c_int
  !use ax_helm
  implicit none
  
  type(c_ptr) :: dace_handle
  !dace_handle_t :: dace_handle 
  class(ax_dace_t), allocatable :: ax_helm
          
  write(*,*) 'Huh'  
  call ax_helm_dace_factory(ax_helm)
  write(*,*) 'Huh'  
  call ax_helm%init(dace_handle,1,2,3,4)
  
  !call device_sync()
  !call ax_helm%compute(f2%x, f1%x, coef, msh, Xh)
  call ax_helm%delete(dace_handle) 
end program
