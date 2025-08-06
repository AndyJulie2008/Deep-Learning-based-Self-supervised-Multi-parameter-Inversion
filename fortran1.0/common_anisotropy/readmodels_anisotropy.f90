
  !================================================================================================================
  !
  ! input the true vp model:
  !
  vp(:,:)  = real0    
  vs(:,:)  = real0    
  rho(:,:)  = real0   
  epsi(:,:)  = real0   
  delta(:,:)  = real0   
  theta(:,:)   = real0   
  print *, trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'truevp.dat'
 
  open(1, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'truevp.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open truevp file failed!'
  do i = 1,nx
  do j = 1,nz
      read(1,'(f17.8)',rec=j+(i-1)*nz) vp(j,i) 
  end do
  end do
  close(1)

  open(2, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'truevs.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open truevs file failed!'
  do i = 1,nx
  do j = 1,nz
      read(2,'(f17.8)',rec=j+(i-1)*nz) vs(j,i) 
  end do
  end do
  close(2)

  open(3, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'truerho.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open truerho file failed!'
  do i = 1,nx
  do j = 1,nz
      read(3,'(f17.8)',rec=j+(i-1)*nz) rho(j,i) 
  end do
  end do
  close(3)

  vp=vp*1000
  vs=vs*1000
  rho=rho*1000
  
  open(4, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'trueepsi.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open trueepsi file failed!'
  do i = 1,nx
  do j = 1,nz
      read(4,'(f17.8)',rec=j+(i-1)*nz) epsi(j,i) 
  end do
  end do
  close(4)

  open(5, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'truedelta.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open truedelta file failed!'
  do i = 1,nx
  do j = 1,nz
      read(5,'(f17.8)',rec=j+(i-1)*nz) delta(j,i) 
  end do
  end do
  close(5)

  !================================================================================================================

  
  !================================================================================================================
  !
  ! input the mig vp model:
  !
  vp_init(:,:)  = real0    
  vs_init(:,:)  = real0    
  rho_init(:,:)  = real0   
  epsi_init(:,:)  = real0   
  delta_init(:,:)  = real0   
  theta_init(:,:)   = real0   

  open(1, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'migvp.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open migvp file failed!'
  do i = 1,nx
  do j = 1,nz
      read(1,'(f17.8)',rec=j+(i-1)*nz) vp_init(j,i) 
  end do
  end do
  close(1)

  open(2, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'migvs.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open migvs file failed!'
  do i = 1,nx
  do j = 1,nz
      read(2,'(f17.8)',rec=j+(i-1)*nz) vs_init(j,i) 
  end do
  end do
  close(2)

  open(3, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'migrho.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open migrho file failed!'
  do i = 1,nx
  do j = 1,nz
      read(3,'(f17.8)',rec=j+(i-1)*nz) rho_init(j,i) 
  end do
  end do
  close(3)

  vp_init=vp_init*1000
  vs_init=vs_init*1000
  rho_init=rho_init*1000
  
  open(4, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'migepsi.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open migepsi file failed!'
  do i = 1,nx
  do j = 1,nz
      read(4,'(f17.8)',rec=j+(i-1)*nz) epsi_init(j,i) 
  end do
  end do
  close(4)

  open(5, file=trim(adjustl(model_in))//trim(adjustl(filenumber_iteration))//'migdelta.dat',status='old'& 
  ,form='formatted', access='direct', recl=17,iostat=rc)
  if(rc/=0) print *,'open migdelta file failed!'
  do i = 1,nx
  do j = 1,nz
      read(5,'(f17.8)',rec=j+(i-1)*nz) delta_init(j,i) 
  end do
  end do
  close(5)

  !================================================================================================================