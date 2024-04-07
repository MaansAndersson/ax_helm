module setup
  use neko
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



end module setup


program nekobench
  use neko
  use dace_ax_helm_device
  use setup
  use dace_math
!  use ax8mod
!  use ax7mod
!  use ax6mod
!  use ax5mod
!  use ax4mod
!  use ax3mod
!  use ax2mod
!  use ax1mod
  
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
    
  ! Dace
  class(dace_ax_helm_device_t), allocatable :: dace_ax_helm
  !type(c_ptr) :: handle_add3s2
  type(field_t) :: stmp, rtmp, ttmp, urtmp, ustmp, uttmp !temporary  
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
  dm = dofmap_t(msh,Xh)
  call gs_h%init(dm)
  call f1%init(dm)
  call f2%init(dm)
  call f3%init(dm)
  call f4%init(dm)
  call coef%init(gs_h)
  call ax_helm_factory(ax_helm)
  
  allocate(dace_ax_helm)

  abstol = 1e-12 ! SOmething small so we dont converge
  call krylov_solver_factory(solver, dm%size(), 'cg', niter, abstol)
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
  
  !Benchmark copy speed f1 = f2
  call device_sync()
  t0 = MPI_Wtime()
  do i = 1, niter
     if (NEKO_BCKND_DEVICE .eq. 1) then
        call device_copy(f1%x_d,f2%x_d,dm%size())
    else
        call copy(f1%x,f2%x,dm%size())
     end if
  end do
  call device_sync()
  t1 = MPI_Wtime()

  time = t1 - t0
  !Assume double precision
  byte = n_tot*2d0*8d0*1e-9
  if (pe_rank .eq. 0) then
     write(*,*) 'copy Time:',time
     write(*,*) 'copy GByte:',byte
     write(*,*) 'copy GB/s:', byte/time
  end if

  f1 = 1.0_rp
  f2 = 1.0_rp
  f3 = 1.0_rp
  c1 = 2.0_rp
  c2 = 1.0_rp
  
  call dace_add3s2_init(dm%size())
  
  !Benchmark vector add f1 = c1*f2 + c2*f3
  call device_sync()
  call MPI_Barrier(NEKO_COMM, ierr)
  t0 = MPI_Wtime()
  do i = 1, niter
     if (NEKO_BCKND_DEVICE .eq. 1) then
        if (bcknd .eq. 0) then
          call dace_add3s2(f1%x_d,f2%x_d,f3%x_d,c1,c2,dm%size())
          !call device_add3s2(f1%x_d,f2%x_d,f3%x_d,c1,c2,dm%size())
          !if (i .eq. 1) print *, niter*0.25*device_glsc2(f1%x_d,f1%x_d,dm%size())
        else 
          call device_add3s2(f1%x_d,f2%x_d,f3%x_d,c1,c2,dm%size())
        end if 
    else
        call add3s2(f1%x,f2%x,f3%x,c1,c2,dm%size())
     end if
  end do
  call device_sync()
  t1 = MPI_Wtime()
  
  call device_sync()
  if (NEKO_BCKND_DEVICE .eq. 1) then
     print *, "norm of ||add3s2 f2||, L2 norm squared", device_glsc2(f1%x_d,f1%x_d,n)
  else
     print *, "norm of ||add3s2 f2||, L2 norm squared", glsc2(f2%x,f2%x,n)
  end if

  time = t1 - t0
  !Assume double precision
  flop = 3d0*n_tot*1e-9
  byte = n_tot*3d0*8d0*1e-9
  if (pe_rank .eq. 0) then
     write(*,*) 'add3s2 Time:',time
     write(*,*) 'add3s2 GFlop:', flop
     write(*,*) 'add3s2 GByte:',byte
     write(*,*) 'add3s2 Gflop/s:', flop/time
     write(*,*) 'add3s2 GB/s:', byte/time
  end if

  call device_sync()

  call stmp%init(dm) 
  call rtmp%init(dm) 
  call ttmp%init(dm) 
  call urtmp%init(dm)
  call ustmp%init(dm)
  call uttmp%init(dm)

  call device_sync()
  
  call dace_ax_helm_device_init(Xh%lx, msh%nelv) !, rtmp%x_d, stmp%x_d, ttmp%x_d, urtmp%x_d, ustmp%x_d, uttmp%x_d)
  call device_sync()
  call set_f(f1%x,f1%dof)
  if(NEKO_BCKND_DEVICE .eq. 1) call device_memcpy(f1%x, f1%x_d, n, HOST_TO_DEVICE,sync=.true.) 
   
  call device_sync()
  
  !Benchmark Ax, lets not overengineer this...
  ! To not time the autotune...
  if (bcknd .eq. 0) then  
     call dace_ax_helm%compute(f2%x, f1%x, coef, msh, Xh)       
  else 
     call ax_helm%compute(f2%x, f1%x, coef, msh, Xh)       
  end if

  call device_sync()
  if (NEKO_BCKND_DEVICE .eq. 1) then
     print *, "norm of ||A*f||, L2 norm squared", device_glsc2(f2%x_d,f2%x_d,n)
  else
     print *, "norm of ||A*f||, L2 norm squared", glsc2(f2%x,f2%x,n)
  end if

  call MPI_Barrier(NEKO_COMM, ierr)
  t0 = MPI_Wtime()
  !h1, h2 are initialized to something
  do i = 1, niter
  if (bcknd .eq. 0) then  
     call dace_ax_helm%compute(f2%x, f1%x, coef, msh, Xh)       
  else 
     call ax_helm%compute(f2%x, f1%x, coef, msh, Xh)       
  end if

  end do
  call device_sync()
  t1 = MPI_Wtime()

  time = t1 - t0
  flop = (19d0 + 12d0*Xh%lx)*n_tot*1e-9
  !Assume double precision
  byte = n_tot*8d0*8d0*1e-9
  if (pe_rank .eq. 0) then
     write(*,*) 'Ax_helm Time:',time
     write(*,*) 'Ax_helm GFlop:', flop
     write(*,*) 'Ax_helm GByte:',byte
     write(*,*) 'Ax_helm Gflop/s:', flop/time
     write(*,*) 'Ax_helm GB/s:', byte/time
  end if
  !example us of cg solver
  !init bcs...
  call dir_bc%init(dm)
  call dir_bc%set_g(real(0.0d0,rp))
 
  !user specified
  call set_bc(dir_bc, msh)
 
  call dir_bc%finalize()
  call bc_list_init(bclst)
  call bc_list_add(bclst,dir_bc)

  if (bcknd .eq. 0) then  
  ksp_mon = solver%solve(dace_ax_helm, f2, f1%x, dm%size(), coef, bclst, gs_h, niter)
  else 
  ksp_mon = solver%solve(ax_helm, f2, f1%x, dm%size(), coef, bclst, gs_h, niter)
  end if 

  if (NEKO_BCKND_DEVICE .eq. 1) &
     call device_memcpy(f2%x, f2%x_d, n, DEVICE_TO_HOST, sync=.true.)
  ! Store the solution
  fname = 'out.fld'
  mf = file_t(fname)
  call mf%write(f2)

  call neko_finalize  

end program nekobench

