!> Module for reusing linear solvers as preconditioner.
!! Do we really need a seprate device module? Could be solved with a if BCKND else. 
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
  !use ax, only : ax_t
  !use dofmap
  !use gather_scatter
  !use krylov
  !use device, only : device_get_ptr
  !use 
  !use bc_list !, only : bc_list_t
  implicit none
  private

  !> Defines the inexact preconditioner
  type, public, extends(pc_t) :: device_inexact_t
    type(gs_t), pointer :: gs_h
    type(dofmap_t), pointer :: dof
    type(coef_t), pointer :: coef
    type(bc_list_t), pointer :: bclst
    class(ax_t), pointer :: Ax
    class(ksp_t), pointer :: M => null()
    type(field_t) :: temp_field
    integer :: inner_iter 
    contains
      procedure, pass(this) :: init => device_inexact_init
      procedure, pass(this) :: solve => device_inexact_solve
      procedure, pass(this) :: update => device_inexact_update
      procedure, pass(this) :: free => device_inexact_free
  end type device_inexact_t

contains

!> The preconditioner \f$ M z = r \f$ solved with some inexact solver
  subroutine device_inexact_solve(this, z, r, n)
    class(device_inexact_t), intent(inout) :: this
    integer, intent(in) :: n
    real(kind=rp), dimension(n), intent(inout) :: z
    real(kind=rp), dimension(n), intent(inout) :: r
    type(ksp_monitor_t) :: ksp_mon
    type(c_ptr) :: z_d, r_d

    ksp_mon = this%M%solve(this%Ax, this%temp_field, r, n, this%coef, this%bclst, this%gs_h, this%inner_iter)
    z_d = device_get_ptr(z)

    !write(*,*) ksp_mon%iter, &
    !     ksp_mon%res_start, &
    !     ksp_mon%res_final


    call device_copy(z_d,this%temp_field%x_d,n)
  end subroutine device_inexact_solve

!> Init
  subroutine device_inexact_init(this, Ax, M, inner_iter, coef, dof, gs_h, bclst)
    class(device_inexact_t), intent(inout) :: this
    class(ax_t), intent(in), target :: Ax
    class(ksp_t), intent(in), target :: M
    type(gs_t), intent(in), target :: gs_h
    type(dofmap_t), intent(in), target :: dof
    type(coef_t), intent(in), target :: coef
    type(bc_list_t), intent(in), target :: bclst
    integer, intent(in) :: inner_iter

    call this%free()
    call this%temp_field%init(dof)
    this%inner_iter = inner_iter
    this%Ax => Ax
    this%M => M
    this%gs_h => gs_h
    this%dof => dof
    this%coef => coef
    this%bclst => bclst

    call device_inexact_update(this)

  end subroutine device_inexact_init

!> Mandatory update routine
!! Should probably update BCs, tolerance etc.
  subroutine device_inexact_update(this)
    class(device_inexact_t), intent(inout) :: this
  ! this%grids(1)%coef%ifh2 = .false.
  !  call copy(this%grids(1)%coef%h1, this%grids(3)%coef%h1, &
  !       this%grids(1)%dof%size())
  !  if (NEKO_BCKND_DEVICE .eq. 1) then
  !     call device_copy(this%grids(1)%coef%h1_d, this%grids(3)%coef%h1_d, &
  !          this%grids(1)%dof%size())
  !  end if
  end subroutine device_inexact_update

  subroutine device_inexact_free(this)
    class(device_inexact_t), intent(inout) :: this

    nullify(this%dof)
    nullify(this%gs_h)
    nullify(this%coef)
  end subroutine device_inexact_free

  end module device_inexact_pc
