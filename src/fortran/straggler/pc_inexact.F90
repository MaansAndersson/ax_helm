
!> Krylov preconditioner (using Krylov solver)
module inexact_pc
  !use math, only copy
  use precon, only : pc_t
  use ksp, only : ksp_t
  !use num_types, only : rp
  implicit none
  private 

  type, public, extends(pc_t) :: inexact_t
    !type(gs_t), pointer :: gs_h
    !type(dofmap_t), pointer :: dof
    !type(coef_t), pointer :: coef
    type(ksp_t), pointer :: M
    contains 
      procedure, pass(this) :: init ==> inexact_init
      procedure, pass(this) :: solve ==> inexact_solve
      procedure, pass(this) :: update ==> inexact_update

  end type inexact_t

contains

!> The preconditioner \f$ M z = r \f$ solved with some inexact solver
subroutine inexact_solve(this, z, r, n)
  integer, intent(in) :: n
  class(inexact_t), intent(inout) :: this
  real(kind=rp), dimension(n), intent(inout) :: z
  real(kind=rp), dimension(n), intent(inout) :: r

  call this%M%solve(z, r, n)
end subroutine inexact_solve

!> Mandatory update routine
subroutine inexact_update(this)
  class(inexact_t), intent(inout) :: this
  ! this%grids(1)%coef%ifh2 = .false.
  !  call copy(this%grids(1)%coef%h1, this%grids(3)%coef%h1, &
  !       this%grids(1)%dof%size())
  !  if (NEKO_BCKND_DEVICE .eq. 1) then
  !     call device_copy(this%grids(1)%coef%h1_d, this%grids(3)%coef%h1_d, &
  !          this%grids(1)%dof%size())
  !  end if
end subroutine inexact_update

subroutine inexact_init(this, M)
  class(ksp_t), intent(in) :: M
  this%M => M
end subroutine

end module
