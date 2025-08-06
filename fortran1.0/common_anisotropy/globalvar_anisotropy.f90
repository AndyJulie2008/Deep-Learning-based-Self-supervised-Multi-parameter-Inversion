!++++++++++++++++++++++++++++++++++++++++
character(len=100)::filenumber_frequency
character(len=100)::filenumber_iteration
character(len=100)::filenumber_repetition
character(len=100)::truevp
character(len=100)::initvp
integer::shot_num,num_shot = 4
!++++++++++++++++++++++++++++++++++++++++





! Modeling parameters
  integer nx, nz, nt
  integer nxsr, nzsr, nsr,itt
  real deltah, dt, freq0
  integer rec_z
! indices
  integer ix, iz, it,rc
  integer isr
  integer itshow, itsnap
! character processing
  integer idpmin,idpmax,imax,imin
! Input File Names
  character*128 vpfile, vsfile, rhofile,filename,datapath
  character*4  cisr
  real :: real0
! Model Arrays
  real, allocatable::&
          zsrg(:),xsrg(:),seri(:),&
          c11_ary(:,:),c13_ary(:,:),c33_ary(:,:),c55_ary(:,:),c15_ary(:,:),c35_ary(:,:),&
          c11_ary_mig(:,:),c13_ary_mig(:,:),c33_ary_mig(:,:),c55_ary_mig(:,:),c15_ary_mig(:,:),c35_ary_mig(:,:),&
          c11_ary_init(:,:),c13_ary_init(:,:),c33_ary_init(:,:),c55_ary_init(:,:),c15_ary_init(:,:),c35_ary_init(:,:),&
          vp(:,:),vs(:,:),epsi(:,:),delta(:,:),theta(:,:),rho(:,:),vp_hor(:,:),vp_nmo(:,:),&
          vp_mig(:,:),vs_mig(:,:),epsi_mig(:,:),delta_mig(:,:),theta_mig(:,:),rho_mig(:,:),&
          vp_init(:,:),vs_init(:,:),epsi_init(:,:),delta_init(:,:),theta_init(:,:),rho_init(:,:),vp_hor_init(:,:),vp_nmo_init(:,:),&
          sxx(:,:),szz(:,:),szx(:,:),&
          vx(:,:), vz(:,:),vz_seismo(:,:),vx_seismo(:,:),vz_wavefield(:,:,:),vx_wavefield(:,:,:), &
          image_vz(:,:),image_vx(:,:),vpx(:,:),vpz(:,:)
!PML Arrays
  real, allocatable::&
          memory_dvx_dx(:,:), memory_dvz_dz(:,:),&
          memory_dvx_dz(:,:), memory_dvz_dx(:,:),&
          memory_dsigmaxx_dx(:,:), memory_dsigmazz_dz(:,:),&
          memory_dsigmazx_dx(:,:), memory_dsigmazx_dz(:,:),&
          a_z(:),b_z(:),k_z(:), a_x(:),b_x(:),k_x(:),&
          a_z_half(:),b_z_half(:),k_z_half(:),&
          a_x_half(:),b_x_half(:),k_x_half(:)
! Lowrank Arrays
  integer, parameter :: knx = 1024
  integer rank, rank_x, rank_k, rank_xa, rank_ka, beta
  integer flag_ps
  real, allocatable::&
          W1_pzz(:,:,:), W2_pzz(:,:,:), A_pzz(:,:),&
          W1_pxx(:,:,:), W2_pxx(:,:,:), A_pxx(:,:),&
          W1_pzx(:,:,:), W2_pzx(:,:,:), A_pzx(:,:)
  integer, allocatable::&
          kx_idx(:),kz_idx(:), x_idx(:),z_idx(:)

! Local parameters
  integer zsrg1, xsrg1, src_int
  integer i, j, cnt
  real amp
! zero
  real, parameter :: ZERO = 0.d0
! FD model extension
  integer, parameter :: lv = 4
  integer, parameter :: mac_len = 4
  real, parameter, dimension(4)::&
      aa = (/1.23538628085693269, &
            -0.109160358903484037, &
             0.246384765606012697E-1, &
            -0.660472512788868975E-2/)


! MPI Parameters
  integer ierr, myid, numprcs, namelen
  real starttime, endtime

  !read input parameters.
  open(51, file='comp.par', status='old')
  call readparameter(51, nz, nx, nt, dt, deltah, &
                      itsnap, itshow, nsr, &
                      zsrg1, xsrg1, src_int, &
                      freq0, flag_ps, rank, datapath)
  close(51)

! allocate source positions
  allocate(zsrg(nsr),xsrg(nsr))
! array for source wavelet
  allocate(seri(nt))

! arrays for the stiffness tensor
  allocate(c11_ary(nz,nx), c13_ary(nz,nx))
  allocate(c33_ary(nz,nx), c55_ary(nz,nx))
  allocate(c15_ary(nz,nx), c35_ary(nz,nx))
  
  allocate(c11_ary_mig(nz,nx), c13_ary_mig(nz,nx))
  allocate(c33_ary_mig(nz,nx), c55_ary_mig(nz,nx))
  allocate(c15_ary_mig(nz,nx), c35_ary_mig(nz,nx))

  allocate(c11_ary_init(nz,nx), c13_ary_init(nz,nx))
  allocate(c33_ary_init(nz,nx), c55_ary_init(nz,nx))
  allocate(c15_ary_init(nz,nx), c35_ary_init(nz,nx))


  allocate(rho(nz,nx), vp(nz,nx))
  allocate(vs(nz,nx), epsi(nz,nx))
  allocate(delta(nz,nx),theta(nz,nx))
  allocate(vp_hor(nz,nx),vp_nmo(nz,nx)) 

  allocate(rho_mig(nz,nx), vp_mig(nz,nx))
  allocate(vs_mig(nz,nx), epsi_mig(nz,nx))
  allocate(delta_mig(nz,nx),theta_mig(nz,nx))

  allocate(rho_init(nz,nx), vp_init(nz,nx))
  allocate(vs_init(nz,nx), epsi_init(nz,nx))
  allocate(delta_init(nz,nx),theta_init(nz,nx))
  allocate(vp_hor_init(nz,nx),vp_nmo_init(nz,nx)) 
!!!!!!!!!!!!!!!!! arrays for the memory variables!!!!!!!!!!!!!!!!!
! could declare these arrays in PML only to save a lot of memory, but proof of concept only here
  allocate(memory_dvx_dx(-lv:nz+lv,-lv:nx+lv),memory_dvz_dz(-lv:nz+lv,-lv:nx+lv))
  allocate(memory_dvx_dz(-lv:nz+lv,-lv:nx+lv),memory_dvz_dx(-lv:nz+lv,-lv:nx+lv))
  allocate(memory_dsigmaxx_dx(-lv:nz+lv,-lv:nx+lv),memory_dsigmazz_dz(-lv:nz+lv,-lv:nx+lv))
  allocate(memory_dsigmazx_dx(-lv:nz+lv,-lv:nx+lv),memory_dsigmazx_dz(-lv:nz+lv,-lv:nx+lv))
  allocate(a_z(1:nz),b_z(1:nz),k_z(1:nz))
  allocate(a_x(1:nx),b_x(1:nx),k_x(1:nx))
  allocate(a_z_half(1:nz),b_z_half(1:nz),k_z_half(1:nz))
  allocate(a_x_half(1:nx),b_x_half(1:nx),k_x_half(1:nx))

!! declare arrays for Lowrank decomposition
!  rank_x = rank
!  rank_k = rank
!  print*, "Rank for decomposition:", rank
!  beta = 3
!  rank_xa = rank_x * beta
!  rank_ka = rank_k * beta
!  allocate(kx_idx(rank_ka), kz_idx(rank_ka))
!  allocate(x_idx(rank_xa), z_idx(rank_xa))
!
!  allocate(W2_pzz(knx, knx, rank_xa))
!  allocate(W1_pzz(nz,  nx, rank_ka))
!  allocate(A_pzz(rank_k, rank_x))
!
!  allocate(W2_pxx(knx, knx, rank_xa))
!  allocate(W1_pxx(nz,  nx, rank_ka))
!  allocate(A_pxx(rank_k, rank_x))
!
!  allocate(W2_pzx(knx, knx, rank_xa))
!  allocate(W1_pzx(nz,  nx, rank_ka))
!  allocate(A_pzx(rank_k, rank_x))
!    kx_idx(:) = ZERO
!    kz_idx(:) = ZERO
!    x_idx(:) = ZERO
!    x_idx(:) = ZERO
!    W2_pzz(:,:,:) = ZERO
!    W1_pzz(:,:,:) = ZERO
!    A_pzz(:,:) = ZERO
!    W2_pxx(:,:,:) = ZERO
!    W1_pxx(:,:,:) = ZERO
!    A_pxx(:,:) = ZERO
!    W2_pzx(:,:,:) = ZERO
!    W1_pzx(:,:,:) = ZERO
!    A_pzx(:,:) = ZERO



! Define source function
  call series(seri, 1, dt, nt, freq0) ! Ricker

! main arrays
  allocate(vx(-lv:nz+lv,-lv:nx+lv),vz(-lv:nz+lv,-lv:nx+lv))
  allocate(vpx(-lv:nz+lv,-lv:nx+lv),vpz(-lv:nz+lv,-lv:nx+lv))
  allocate(sxx(-lv:nz+lv,-lv:nx+lv),szz(-lv:nz+lv,-lv:nx+lv))
  allocate(szx(-lv:nz+lv,-lv:nx+lv))
  allocate(vz_seismo(nx,nt),vx_seismo(nx,nt))
  allocate(vz_wavefield(nz,nx,nt/itsnap),vx_wavefield(nz,nx,nt/itsnap))
  allocate(image_vz(nz,nx),image_vx(nz,nx))