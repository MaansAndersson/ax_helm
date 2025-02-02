!> Module for reusing linear solvers as preconditioner.
!! Used with FMGRES or BiCGSTAB.

!> Krylov preconditioner (using Krylov solver)
module inexact_pc
  !use math, only copy
  use precon, only : pc_t
  use coefs, only : coef_t
  use num_types, only : rp
  use dofmap
  use gather_scatter
  use krylov !: ksp_t, ksp_monitor_t
  use field, only : field_t
  use ax_helm, only : ax_helm_t

  implicit none
  private

  type, public, extends(pc_t) :: inexact_t
    type(gs_t), pointer :: gs_h
    type(dofmap_t), pointer :: dof
    type(coef_t), pointer :: coef
    type(ax_helm_t), pointer :: ax_helm
    class(ksp_t), pointer :: M => null() !allocatable?
    contains
      procedure, pass(this) :: init => inexact_init
      procedure, pass(this) :: solve => inexact_solve
      procedure, pass(this) :: update => inexact_update
      !procedure, pass(this) :: free => inexact_free
  end type inexact_t

contains

!> The preconditioner \f$ M z = r \f$ solved with some inexact solver
  subroutine inexact_solve(this, z, r, n)
    class(inexact_t), intent(inout) :: this
    integer, intent(in) :: n
    real(kind=rp), dimension(n), intent(inout) :: z
    real(kind=rp), dimension(n), intent(inout) :: r
    type(ksp_monitor_t) :: ksp_mon

    !move to global?
    type(field_t) :: temp_field
    type(ax_helm_t) :: ax_helm

    !ksp_mon = this%M%solve(z, r, n)
    !ax_helm
    !this%dm%size()
    !this%bclst

    !temp_field%x = 0
    !ksp_mon = this%M%solve(ax_helm, temp_field, r, 10, this%coef, 1, this%gs_h, 100)
    !z = temp_field%x
  end subroutine inexact_solve

!> Init
  subroutine inexact_init(this, ax_helm, M, coef, dof, gs_h)
    class(inexact_t), intent(inout) :: this
    type(ax_helm_t), intent(in), target :: ax_helm
    class(ksp_t), intent(in), target :: M
    type(gs_t), intent(in), target :: gs_h
    type(dofmap_t), intent(in), target :: dof
    type(coef_t), intent(in), target :: coef

    !call this%free()
    this%ax_helm => ax_helm
    this%M => M
    this%gs_h => gs_h
    this%dof => dof
    this%coef => coef
  end subroutine

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

end module inexact_pc
