  program vesou2d
  implicit none
  character(len=100)::model_in='../matlab1.0/models/'
  character(len=100)::data_out='output0'

  include "./common_anisotropy/globalvar_anisotropy.f90" !include common global variables
  call system('mkdir '//trim(adjustl(data_out))) !create the output folder for migration image
  
  shot_num = 0
  write(filenumber_iteration,'(i5)')shot_num
  include "./common_anisotropy/readmodels_anisotropy.f90" !read parameters!

call  moduli_convert(nz,nx,vp,vs,rho,epsi,delta,theta,&
                c11_ary,c13_ary,c33_ary,c55_ary,c15_ary,c35_ary)


! Initiate PML related variables
call define_pml(nz, nx, vp, vs, epsi, freq0, deltah, deltah, dt, &
                a_z, b_z, k_z, a_x, b_x, k_x,&
  a_z_half, b_z_half, k_z_half, a_x_half, b_x_half, k_x_half)
deallocate(vp,vs,epsi,delta,theta)

print *,'Velocity of qP along vertical axis. . . =',sqrt(c33_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *,'Velocity of qP along horizontal axis. . =',sqrt(c11_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *
print *,'Velocity of qSV along vertical axis . . =',sqrt(c55_ary(nz/2,nx/2)/rho(nz/2,nx/2))
print *


! LOOP OVER SOURCES

  do isr=1,1 !nsr

    zsrg(isr)=zsrg1
    xsrg(isr)=xsrg1+src_int*(isr-1)
    !define source location in the grid.
    nzsr=zsrg(isr)
    nxsr=xsrg(isr)
    rec_z=nzsr
    
    print *, 'nxsr =', isr !if(mod(it,100)==1) 

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

      if(mod(it,100)==1)then
        write(filenumber_iteration,'(i5)')it
        open(10, file=trim(adjustl(data_out))//'/wavefield'//trim(adjustl(filenumber_iteration))//'.dat')
        close(10,status='delete')
        open(10, file=trim(adjustl(data_out))//'/wavefield'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
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
  

  write(filenumber_iteration,'(i5)')isr
  open(10, file=trim(adjustl(data_out))//'/seis_data'//trim(adjustl(filenumber_iteration))//'.dat')
  close(10,status='delete')
  open(10, file=trim(adjustl(data_out))//'/seis_data'//trim(adjustl(filenumber_iteration))//'.dat',status='new'& 
  ,form='formatted', access='direct', recl=17,iostat=rc) 
  if(rc/=0) print *,'open file failed!'

  do i=1,nt
  do j=1,nx
          write(10,'(f17.8)',rec=j + (i-1)*nx + 0*nx*nt) vz_seismo(j,i)/100
  end do
  end do

  do i=1,nt
  do j=1,nx
          write(10,'(f17.8)',rec=j + (i-1)*nx + 1*nx*nt) vx_seismo(j,i)/100
  end do
  end do

  close(10)
  
enddo   ! END SOURCE LOOP

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
  
