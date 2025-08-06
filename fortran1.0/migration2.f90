  program vesou2d
  implicit none
  character(len=100)::model_in='given_models2/'
  character(len=100)::data_out='output2'

  include "./common_anisotropy/globalvar_anisotropy.f90" !include common global variables
  call system('mkdir '//trim(adjustl(data_out))) !create the output folder for migration image
  
  do 100 shot_num = 1,100
  write(filenumber_iteration,'(i5)')shot_num
  include "./common_anisotropy/readmodels_anisotropy.f90" !read parameters!

  write(filenumber_iteration,'(i5)')shot_num
open(10, file='./output2/Fortran_rtm'//trim(adjustl(filenumber_iteration))//'.dat')
close(10,status='delete')
open(10, file='./output2/Fortran_rtm'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
,form='formatted', access='direct', recl=17,iostat=rc)
if(rc/=0) print *,'open file failed!'

do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 2*nz*nx) vp_init(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 3*nz*nx) vs_init(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 4*nz*nx) rho_init(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 5*nz*nx) vp(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 6*nz*nx) vs(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 7*nz*nx) rho(j,i)
  end do
  end do
  
  vp_hor = vp*sqrt(1+2*epsi)
  vp_nmo = vp*sqrt(1+2*delta)
  vp_hor_init = vp_init*sqrt(1+2*epsi_init)
  vp_nmo_init = vp_init*sqrt(1+2*delta_init)
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 8*nz*nx) vp_hor(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 9*nz*nx) vp_nmo(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 10*nz*nx) vp_hor_init(j,i)
  end do
  end do
  
  do i=1,nx
  do j=1,nz
          write(10,'(f17.8)',rec=j + (i-1)*nz + 11*nz*nx) vp_nmo_init(j,i)
  end do
  end do

call  moduli_convert(nz,nx,vp,vs,rho,epsi,delta,theta,&
                c11_ary,c13_ary,c33_ary,c55_ary,c15_ary,c35_ary)

! Initiate PML related variables
call define_pml(nz, nx, vp, vs, epsi, freq0, deltah, deltah, dt, &
                a_z, b_z, k_z, a_x, b_x, k_x,&
  a_z_half, b_z_half, k_z_half, a_x_half, b_x_half, k_x_half)


c11_ary_mig = c11_ary(1,1)
c13_ary_mig = c13_ary(1,1)
c33_ary_mig = c33_ary(1,1)
c55_ary_mig = c55_ary(1,1)
c15_ary_mig = c15_ary(1,1)
c35_ary_mig = c35_ary(1,1)

call  moduli_convert(nz,nx,vp_init,vs_init,rho_init,epsi_init,delta_init,theta_init,&
                c11_ary_init,c13_ary_init,c33_ary_init,c55_ary_init,c15_ary_init,c35_ary_init)

print *,'Velocity of qP along vertical axis. . . =',sqrt(c33_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *,'Velocity of qP along horizontal axis. . =',sqrt(c11_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *
print *,'Velocity of qSV along vertical axis . . =',sqrt(c55_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *


! LOOP OVER SOURCES

  do isr=1,nsr

    

    zsrg(isr)=zsrg1
    xsrg(isr)=xsrg1+src_int*(isr-1)
    !define source location in the grid.
    nzsr=zsrg(isr)
    nxsr=xsrg(isr)
    rec_z=nzsr
    
    print *, 'nxsr =', isr !if(mod(it,100)==1) 

    !********************************************************************
    ! 1.1 Forward wavefield modeling with direct wave
    !********************************************************************

    print *,'1.1 forward modeling with direct wave'
!   initialize arrays
    vx(:,:) = ZERO
    vz(:,:) = ZERO
    sxx(:,:) = ZERO
    szz(:,:) = ZERO
    szx(:,:) = ZERO
    vpx(:,:) = ZERO
    vpz(:,:) = ZERO

!   PML
    memory_dvx_dx(:,:) = ZERO
    memory_dvx_dz(:,:) = ZERO
    memory_dvz_dx(:,:) = ZERO
    memory_dvz_dz(:,:) = ZERO
    memory_dsigmaxx_dx(:,:) = ZERO
    memory_dsigmazz_dz(:,:) = ZERO
    memory_dsigmazx_dx(:,:) = ZERO
    memory_dsigmazx_dz(:,:) = ZERO

    !-  --
    !-  --  beginning of time loop
    !-  --

    do it = 1,nt
    !-  -----------------------------------------------------------
    !   compute stress sigma and update memory variables for C-PML
    !-  -----------------------------------------------------------
        call hooke(nx,nz,deltah,dt,lv,aa,&
                   c11_ary,c13_ary,c33_ary,c55_ary,&
                   c15_ary,c35_ary,&
                   vx,vz,sxx,szz,szx,&
                   memory_dvx_dx,memory_dvz_dz,&
                   memory_dvz_dx,memory_dvx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)
        
    !-  -------------------------------------------------------
    !   compute velocity and update memory variables for C-PML
    !-  -------------------------------------------------------
        call  eqmot(nx, nz, deltah, dt,lv,aa,&
                   rho,vx,vz,sxx,szz,szx,&
                   memory_dsigmaxx_dx,memory_dsigmazz_dz,&
                   memory_dsigmazx_dx,memory_dsigmazx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)

    !store the seimogram data 
        vz_seismo(1:nx,it) = vz(nzsr,1:nx) 
        vx_seismo(1:nx,it) = vx(nzsr,1:nx) 

      if(mod(it,100)==-1)then
        write(filenumber_iteration,'(i5)')it
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat')
        close(10,status='delete')
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
        ,form='formatted', access='direct', recl=17,iostat=rc) 
        if(rc/=0) print *,'open file failed!'
      
        do i=1,nz
        do j=1,nx
                write(10,'(f17.8)',rec=j + (i-1)*nx) vz(i,j)
        end do
        end do
        close(10)
      endif  
    
    !   add source
        amp = seri(it)
        sxx(nzsr,nxsr)=sxx(nzsr,nxsr)-amp*10000000000
        szz(nzsr,nxsr)=szz(nzsr,nxsr)-amp*10000000000


    enddo   ! end of time loop
  


    !********************************************************************
    ! 1.2 Forward wavefield modeling to remove direct wave
    !********************************************************************
    print *,'1.2 forward modeling to remove direct wave'
!   initialize arrays
    vx(:,:) = ZERO
    vz(:,:) = ZERO
    sxx(:,:) = ZERO
    szz(:,:) = ZERO
    szx(:,:) = ZERO
    vpx(:,:) = ZERO
    vpz(:,:) = ZERO

!   PML
    memory_dvx_dx(:,:) = ZERO
    memory_dvx_dz(:,:) = ZERO
    memory_dvz_dx(:,:) = ZERO
    memory_dvz_dz(:,:) = ZERO
    memory_dsigmaxx_dx(:,:) = ZERO
    memory_dsigmazz_dz(:,:) = ZERO
    memory_dsigmazx_dx(:,:) = ZERO
    memory_dsigmazx_dz(:,:) = ZERO

    !-  --
    !-  --  beginning of time loop
    !-  --

    do it = 1,nt
    !-  -----------------------------------------------------------
    !   compute stress sigma and update memory variables for C-PML
    !-  -----------------------------------------------------------
        call hooke(nx,nz,deltah,dt,lv,aa,&
                   c11_ary_mig,c13_ary_mig,c33_ary_mig,c55_ary_mig,&
                   c15_ary_mig,c35_ary_mig,&
                   vx,vz,sxx,szz,szx,&
                   memory_dvx_dx,memory_dvz_dz,&
                   memory_dvz_dx,memory_dvx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)
        
    !-  -------------------------------------------------------
    !   compute velocity and update memory variables for C-PML
    !-  -------------------------------------------------------
        call  eqmot(nx, nz, deltah, dt,lv,aa,&
                   rho,vx,vz,sxx,szz,szx,&
                   memory_dsigmaxx_dx,memory_dsigmazz_dz,&
                   memory_dsigmazx_dx,memory_dsigmazx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)

    !store the seimogram data 
        vz_seismo(1:nx,it) = vz_seismo(1:nx,it) - vz(nzsr,1:nx) 
        vx_seismo(1:nx,it) = vx_seismo(1:nx,it) - vx(nzsr,1:nx) 

      if(mod(it,100)==-1)then
        write(filenumber_iteration,'(i5)')it
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat')
        close(10,status='delete')
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
        ,form='formatted', access='direct', recl=17,iostat=rc) 
        if(rc/=0) print *,'open file failed!'
      
        do i=1,nz
        do j=1,nx
                write(10,'(f17.8)',rec=j + (i-1)*nx) vz(i,j)
        end do
        end do
        close(10)
      endif

    !   add source
        amp = seri(it)
        sxx(nzsr,nxsr)=sxx(nzsr,nxsr)-amp*10000000000
        szz(nzsr,nxsr)=szz(nzsr,nxsr)-amp*10000000000

    enddo   ! end of time loop



    !********************************************************************
    ! 2. Forward wavefield modeling to store source wavefield
    !********************************************************************
    print *,'2. forward modeling on initial model to store source wavefield'
!   initialize arrays
    vx(:,:) = ZERO
    vz(:,:) = ZERO
    sxx(:,:) = ZERO
    szz(:,:) = ZERO
    szx(:,:) = ZERO
    vpx(:,:) = ZERO
    vpz(:,:) = ZERO

!   PML
    memory_dvx_dx(:,:) = ZERO
    memory_dvx_dz(:,:) = ZERO
    memory_dvz_dx(:,:) = ZERO
    memory_dvz_dz(:,:) = ZERO
    memory_dsigmaxx_dx(:,:) = ZERO
    memory_dsigmazz_dz(:,:) = ZERO
    memory_dsigmazx_dx(:,:) = ZERO
    memory_dsigmazx_dz(:,:) = ZERO

    !-  --
    !-  --  beginning of time loop
    !-  --
    itt = 0
    do it = 1,nt
    !-  -----------------------------------------------------------
    !   compute stress sigma and update memory variables for C-PML
    !-  -----------------------------------------------------------
        call hooke(nx,nz,deltah,dt,lv,aa,&
                   c11_ary_init,c13_ary_init,c33_ary_init,c55_ary_init,&
                   c15_ary_init,c35_ary_init,&
                   vx,vz,sxx,szz,szx,&
                   memory_dvx_dx,memory_dvz_dz,&
                   memory_dvz_dx,memory_dvx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)
        
    !-  -------------------------------------------------------
    !   compute velocity and update memory variables for C-PML
    !-  -------------------------------------------------------
        call  eqmot(nx, nz, deltah, dt,lv,aa,&
                   rho,vx,vz,sxx,szz,szx,&
                   memory_dsigmaxx_dx,memory_dsigmazz_dz,&
                   memory_dsigmazx_dx,memory_dsigmazx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)


      if(mod(it,100)==-1)then
        write(filenumber_iteration,'(i5)')it
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat')
        close(10,status='delete')
        open(10, file=trim(adjustl(data_out))//'/forwavefield'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
        ,form='formatted', access='direct', recl=17,iostat=rc) 
        if(rc/=0) print *,'open file failed!'
      
        do i=1,nz
        do j=1,nx
                write(10,'(f17.8)',rec=j + (i-1)*nx) vz(i,j)
        end do
        end do
        close(10)
      endif

    if(mod(it,itsnap)==0)then
        itt = itt + 1
        vz_wavefield(1:nz,1:nx,itt) = vz(1:nz,1:nx)
        vx_wavefield(1:nz,1:nx,itt) = vx(1:nz,1:nx)
    end if

    !   add source
        amp = seri(it)
        sxx(nzsr,nxsr)=sxx(nzsr,nxsr)-amp*10000000000
        szz(nzsr,nxsr)=szz(nzsr,nxsr)-amp*10000000000

    enddo   ! end of time loop


  !********************************************************************
  ! 3. RTM
  !********************************************************************
  print *, '3. RTM'
!   initialize arrays
    vx(:,:) = ZERO
    vz(:,:) = ZERO
    sxx(:,:) = ZERO
    szz(:,:) = ZERO
    szx(:,:) = ZERO
    vpx(:,:) = ZERO
    vpz(:,:) = ZERO

!   PML
    memory_dvx_dx(:,:) = ZERO
    memory_dvx_dz(:,:) = ZERO
    memory_dvz_dx(:,:) = ZERO
    memory_dvz_dz(:,:) = ZERO
    memory_dsigmaxx_dx(:,:) = ZERO
    memory_dsigmazz_dz(:,:) = ZERO
    memory_dsigmazx_dx(:,:) = ZERO
    memory_dsigmazx_dz(:,:) = ZERO

    !-  --
    !-  --  beginning of time loop
    !-  --
    itt = 0
    do it = 1,nt
    !-  -----------------------------------------------------------
    !   compute stress sigma and update memory variables for C-PML
    !-  -----------------------------------------------------------
        call hooke(nx,nz,deltah,dt,lv,aa,&
                   c11_ary_init,c13_ary_init,c33_ary_init,c55_ary_init,&
                   c15_ary_init,c35_ary_init,&
                   vx,vz,sxx,szz,szx,&
                   memory_dvx_dx,memory_dvz_dz,&
                   memory_dvz_dx,memory_dvx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)
        
    !-  -------------------------------------------------------
    !   compute velocity and update memory variables for C-PML
    !-  -------------------------------------------------------
        call  eqmot(nx, nz, deltah, dt,lv,aa,&
                   rho_init,vx,vz,sxx,szz,szx,&
                   memory_dsigmaxx_dx,memory_dsigmazz_dz,&
                   memory_dsigmazx_dx,memory_dsigmazx_dz,&
                   a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)

    if(mod(it,itsnap)==0)then
        itt = itt + 1
        image_vz = image_vz + vz_wavefield(1:nz,1:nx,nt/itsnap-itt+1)*vz(1:nz,1:nx)
        image_vx = image_vx + vx_wavefield(1:nz,1:nx,nt/itsnap-itt+1)*vx(1:nz,1:nx)
    end if


      if(mod(it,100)==-1)then
        write(filenumber_iteration,'(i5)')it
        open(10, file=trim(adjustl(data_out))//'/backwavefield'//trim(adjustl(filenumber_iteration))//'.dat')
        close(10,status='delete')
        open(10, file=trim(adjustl(data_out))//'/backwavefield'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
        ,form='formatted', access='direct', recl=17,iostat=rc) 
        if(rc/=0) print *,'open file failed!'
      
        do i=1,nz
        do j=1,nx
                write(10,'(f17.8)',rec=j + (i-1)*nx) vz(i,j)
        end do
        end do
        close(10)
      endif
        
    !store the seimogram data 
        vz(nzsr,1:nx) = vz_seismo(1:nx,nt-it+1)
        vx(nzsr,1:nx) = vx_seismo(1:nx,nt-it+1)

    enddo   ! end of time loop
  
  enddo   ! END SOURCE LOOP

do i=1,nx
do j=1,nz
        write(10,'(f17.8)',rec=j + (i-1)*nz + 0*nz*nx) image_vz(j,i)/100
end do
end do

do i=1,nx
do j=1,nz
        write(10,'(f17.8)',rec=j + (i-1)*nz + 1*nz*nx) image_vx(j,i)/100
end do
end do


close(10)



100 end do
  print *
  print *,'End of the simulation'
  print *

  end program vesou2d
  include "./common_anisotropy/skiplines_anisotropy.f90"
  include "./common_anisotropy/processpar_anisotropy.f90"
  include "./common_anisotropy/define_pml_anisotropy.f90"

  include "./common_anisotropy/propagate_anisotropy.f90"
  include "./common_anisotropy/wavelet_anisotropy.f90"
  include "./common_anisotropy/moduli_convert_anisotropy.f90"
  include "./common_anisotropy/taper_anisotropy.f90"
  
