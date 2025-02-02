!> Module for reusing linear solvers as preconditioner.
!!
!! Used with FMGRES or BiCGSTAB.

!> Krylov preconditioner (using Krylov solver)
module device_inexact_pc
  use neko

  !use math, only : copy
  !use precon, only : pc_t
  !use coefs, only : coef_t
  !use num_types, only : c_rp, rp
  !use, intrinsic :: iso_c_binding , only : c_ptr, c_int
  !use field, only : field_t
  use ax_helm, only : ax_helm_t
  !use dofmap
  !use gather_scatter
  !use krylov
  !use device, only : device_get_ptr
  !use 
  !use bc_list !, only : bc_list_t


  implicit none
  private

  type, public, extends(pc_t) :: device_inexact_t
    type(gs_t), pointer :: gs_h
    type(dofmap_t), pointer :: dof
    type(coef_t), pointer :: coef
    type(bc_list_t), pointer :: bclst
    type(ax_helm_t), pointer :: ax_helm
    class(ksp_t), pointer :: M => null() !allocatable?
    type(field_t), pointer :: temp_field
    contains
      procedure, pass(this) :: init => device_inexact_init
      procedure, pass(this) :: solve => device_inexact_solve
      procedure, pass(this) :: update => device_inexact_update
      !procedure, pass(this) :: free => inexact_free
  end type device_inexact_t

contains

!> The preconditioner \f$ M z = r \f$ solved with some inexact solver
  subroutine device_inexact_solve(this, z, r, n)
    class(inexact_t), intent(inout) :: this
    integer, intent(in) :: n
    real(kind=rp), dimension(n), intent(inout) :: z
    real(kind=rp), dimension(n), intent(inout) :: r
    type(ksp_monitor_t) :: ksp_mon
    type(ax_helm_t) :: ax_helm

    type(c_ptr) :: z_d, r_d

    !this%bclst
    this%temp_field%x = 0.0_rp
    ksp_mon = this%M%solve(ax_helm, this%temp_field, r, n, this%coef, this%bclst, this%gs_h, 100)

    ! device it?
    ! probably split it
    call copy(z, this%temp_field%x, n)

    !if (NEKO_BCKND_DEVICE .eq. 1) then
    !  z_d = device_get_ptr(z)
    !  call device_copy(z_d, this%temp_field%x_d, n)
    !else
    !  call copy(z, this%temp_field%x, n)
    !end if
  end subroutine device_inexact_solve

!> Init
  subroutine device_inexact_init(this, ax_helm, M, coef, dof, gs_h, bclst)
    class(inexact_t), intent(inout) :: this
    type(ax_helm_t), intent(in), target :: ax_helm
    class(ksp_t), intent(in), target :: M
    type(gs_t), intent(in), target :: gs_h
    type(dofmap_t), intent(in), target :: dof
    type(coef_t), intent(in), target :: coef
    type(bc_list_t), intent(in), target :: bclst

    ! Is this correct?
    type(field_t), target :: temp_field1
    this%bclst => bclst

    call temp_field1%init(dof)
    this%temp_field => temp_field1


    this%ax_helm => ax_helm
    this%M => M
    this%gs_h => gs_h
    this%dof => dof
    this%coef => coef
  end subroutine device_inexact_init

!> Mandatory update routine
!! Should probably update BCs, tolerance etc.
  subroutine device_inexact_update(this)
    class(inexact_t), intent(inout) :: this
  ! this%grids(1)%coef%ifh2 = .false.
  !  call copy(this%grids(1)%coef%h1, this%grids(3)%coef%h1, &
  !       this%grids(1)%dof%size())
  !  if (NEKO_BCKND_DEVICE .eq. 1) then
  !     call device_copy(this%grids(1)%coef%h1_d, this%grids(3)%coef%h1_d, &
  !          this%grids(1)%dof%size())
  !  end if
  end subroutine device_inexact_update

  end module device_inexact_pc
