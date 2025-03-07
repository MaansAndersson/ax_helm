module setup_driver
  use num_types, only : rp
  use dofmap, only : dofmap_t
  use mesh, only : mesh_t
  use utils, only : nonlinear_index
  use dirichlet, only : dirichlet_t
  implicit none
contains
  ! Setup rhs
  subroutine set_f(f, dm)
    type(dofmap_t), intent(in) :: dm
    real(kind=rp), intent(inout), dimension(dm%size()) :: f
    integer :: n
    real(kind=rp) :: dx, dy, dz
    real(kind=rp), parameter :: arg = 2d0
    integer :: i, idx(4)

    do i = 1, dm%size()
       idx = nonlinear_index(i, dm%Xh%lx, dm%Xh%ly, dm%Xh%lz)
       dx = dm%x(idx(1), idx(2), idx(3), idx(4)) - 4.0d0
       dy = dm%y(idx(1), idx(2), idx(3), idx(4)) - 4.0d0
       dz = dm%z(idx(1), idx(2), idx(3), idx(4)) - 4.0d0
       f(i) = 500d0*exp(-(dx**arg + dy**arg + dz**arg)/arg)
    end do
  end subroutine set_f

  ! Set Dirichlet conditions
  subroutine set_bc(bc_, msh)
    type(mesh_t), intent(in) :: msh
    type(dirichlet_t), intent(inout) :: bc_
    integer :: i

    do i = 1, msh%nelv
       if (msh%facet_neigh(1, i) .eq. 0) then
         call bc_%mark_facet(1, i)
       end if
       if (msh%facet_neigh(2, i) .eq. 0) then
         call bc_%mark_facet(2, i)
       end if
       if (msh%facet_neigh(3, i) .eq. 0) then
         call bc_%mark_facet(3, i)
       end if
       if (msh%facet_neigh(4, i) .eq. 0) then
         call bc_%mark_facet(4, i)
       end if
       if (msh%facet_neigh(5, i) .eq. 0) then
         call bc_%mark_facet(5, i)
       end if
       if (msh%facet_neigh(6, i) .eq. 0) then
         call bc_%mark_facet(6, i)
       end if
    enddo
  end subroutine set_bc

end module setup_driver


program nekobench
  use neko
  use setup_driver
  use dace_math
  use dace_ax_helm_device
  use device_inexact_pc
  use inexact_pc

  implicit none

  character(len=NEKO_FNAME_LEN) :: fname, lxchar
  type(mesh_t) :: msh
  type(file_t) :: nmsh_file, mf
  type(space_t) :: Xh
  type(dofmap_t) :: dm
  type(gs_t) :: gs_h
  type(coef_t) :: coef
  class(ax_t), allocatable :: ax_helm
  type(field_t) :: f1, f2, f3, f4
  real(kind=rp) :: byte, flop, n_tot, t0, t1, time
  real(kind=rp) :: c1, c2, abstol
  class(ksp_t), allocatable :: solver
  type(ksp_monitor_t) :: ksp_mon
  type(dirichlet_t) :: dir_bc
  type(bc_list_t) :: bclst
  integer :: argc, niter, ierr, lx, nelt, bcknd
  integer :: i, n
  ! Inexact preconditioner
  class(ksp_t), allocatable :: solver_pc
  class(inexact_pc_t), allocatable :: pc


  ! Dace
  argc = command_argument_count()

  if ((argc .lt. 4) .or. (argc .gt. 4)) then
     write(*,*) 'Usage: ./nekobench <neko mesh> <N> <niter> <bcknd (dace : 0)>'
     write(*,*) 'Use meshes from nekbone, e.g. ../nekobone/data.512.nmsh'
     stop
  end if

  call neko_init

  call get_command_argument(1, fname)
  call get_command_argument(2, lxchar)
  read(lxchar, *) lx
  call get_command_argument(3, lxchar)
  read(lxchar, *) niter
  call get_command_argument(4, lxchar)
  read(lxchar, *) bcknd

  nmsh_file = file_t(fname)
  call nmsh_file%read(msh)

  !Init things
  call Xh%init(GLL, lx, lx, lx)
  call dm%init(msh,Xh)
  call gs_h%init(dm)
  call f1%init(dm)
  call f2%init(dm)
  call f3%init(dm)
  call f4%init(dm)
  call coef%init(gs_h)

  n_tot = dble(msh%glb_nelv)*dble(niter)*dble(Xh%lxyz) 
  n = dm%size()
  if (pe_rank .eq. 0) then
     write(*,*) 'Nekobench '
     write(*,*) 'lx:', lx
     write(*,*) 'N elements tot:', msh%glb_nelv
     write(*,*) 'N ranks:', pe_size
     write(*,*) 'N iterations:', niter
     write(*,*) 'lx^3*N elements tot*N iter:', n_tot 
  end if
  call MPI_Barrier(NEKO_COMM, ierr)


  f1 = 1.0_rp
  f2 = 1.0_rp
  f3 = 1.0_rp

  call device_sync()

  call set_f(f1%x,f1%dof)
  if(NEKO_BCKND_DEVICE .eq. 1) call device_memcpy(f1%x, f1%x_d, n, HOST_TO_DEVICE,sync=.true.) 
  call device_sync()

  call MPI_Barrier(NEKO_COMM, ierr)
  t0 = MPI_Wtime()
  t1 = MPI_Wtime()
  time = t1 - t0

  !example us of cg solver
  !init bcs...
  call dir_bc%init_from_components(coef,real(0.0d0,rp))

  !user specified
  call set_bc(dir_bc, msh)

  call dir_bc%finalize()
  call bclst%init()
  call bclst%append(dir_bc)

  abstol = 1e-16

  call ax_helm_factory(ax_helm, .FALSE.)
  call krylov_solver_factory(solver_pc, dm%size(), 'gmres', niter, abstol)
  !allocate(device_inexact_pc_t::pc)
  allocate(inexact_pc_t::pc)
  select type (pc => pc)
  ! change gs_h such that it is a gs that times out for small ts
  !type is (device_inexact_pc_t)
  !  call pc%init(ax_helm, solver_pc, 15, coef, dm, gs_h, bclst)
  type is (inexact_pc_t)
    call pc%init(ax_helm, solver_pc, 15, coef, dm, gs_h, bclst)
  end select

  abstol = 1e-14! Something small so we dont converge
  call krylov_solver_factory(solver, dm%size(), 'gmres', niter, abstol, pc)


  f2 = 1.0_rp

  !if (bcknd .eq. 0) then
  !ksp_mon = solver%solve(dace_ax_helm, f2, f1%x, dm%size(), coef, bclst, gs_h, niter)
  !else
  ksp_mon = solver%solve(ax_helm, f2, f1%x, dm%size(), coef, bclst, gs_h, niter)
  !end if

  write(*,*) ksp_mon%iter, &
         ksp_mon%res_start, &
         ksp_mon%res_final

  if (NEKO_BCKND_DEVICE .eq. 1) &
     call device_memcpy(f2%x, f2%x_d, n, DEVICE_TO_HOST, sync=.true.)
  ! Store the solution
  fname = 'out.fld'
  mf = file_t(fname)
  call mf%write(f2)

  call neko_finalize

end program nekobench

