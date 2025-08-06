subroutine moduli_convert(nz,nx,vp,vs,rho,epsi,delta,theta,&
                 c11_ary,c13_ary,c33_ary,c55_ary,c15_ary,c35_ary)


  implicit none
!  Arguments
      integer nz,nx
      integer ix,iz,i,j
      real vp(nz,nx), vs(nz,nx), rho(nz,nx), epsi(nz,nx), delta(nz,nx), theta(nz,nx)
      real c11_ary(nz,nx), c33_ary(nz,nx), c13_ary(nz,nx), c55_ary(nz,nx)
      real c15_ary(nz,nx), c35_ary(nz,nx)
      real cc(6,6),c(6,6)
      real stb1, stb2, stb3
      real PI
      PI=acos(-1.)

      call taper(epsi, nz,nx, 10)
      call taper(delta, nz,nx, 10)
      call taper(theta, nz,nx, 10)

      do i=1,nz
        do j=1,nx
           c33_ary(i,j)=vp(i,j)*vp(i,j)*rho(i,j)
           c55_ary(i,j)=vs(i,j)*vs(i,j)*rho(i,j)
           c11_ary(i,j)=c33_ary(i,j)*(2.*epsi(i,j)+1.)
           !c13_ary(i,j)=sqrt(2.*c33_ary(i,j)*(c33_ary(i,j)-c55_ary(i,j))*delta(i,j)&
!                    +(c33_ary(i,j)-c55_ary(i,j))*(c33_ary(i,j)-c55_ary(i,j)))-c55_ary(i,j)
           c13_ary(i,j)=sqrt(((2.0*delta(i,j)+1)*c33_ary(i,j)-&
                    c55_ary(i,j))*(c33_ary(i,j)-c55_ary(i,j)))-c55_ary(i,j)
           if (c11_ary(i,j)*c33_ary(i,j) - c13_ary(i,j)*c13_ary(i,j)&
             < -1.) stop 'problem in definition of orthotropic material'


           cc = 0.
           c = 0.
           cc(1,1) = c11_ary(i,j)
           cc(1,3) = c13_ary(i,j)
           cc(3,3) = c33_ary(i,j)
           cc(5,5) = c55_ary(i,j)

           !! stability testing
           !stb1 = ((cc(1,3)+cc(5,5))**2-cc(1,1)*(cc(3,3)-cc(5,5)))&
           !      *((cc(1,3)+cc(5,5))**2+cc(5,5)*(cc(3,3)-cc(5,5)))
           !stb2 = (cc(1,3)+2*cc(5,5))**2-cc(1,1)*cc(3,3)
           !stb3 = (cc(1,3)+cc(5,5))**2-cc(1,1)*cc(3,3)-cc(5,5)*cc(5,5)
           !if (stb1 .gt. 0. .or. stb2 .gt. 0. .or. stb3 .gt. 0.) then
           !   print*, "PML unstable..."
           !   !stop
           !endif
              

           ! fill the zeros
           cc(6,6) = cc(5,5) ! =c55*(1.0+2.0*gamma)
            
           cc(1,2)=cc(1,1)-2.0*cc(6,6)
           cc(2,1)=cc(1,2)
           cc(2,2)=cc(1,1)
           cc(2,3)=cc(1,3)
           cc(3,1)=cc(1,3)
           cc(3,2)=cc(2,3)
           cc(4,4)=cc(5,5)

           call rotation(cos(theta(i,j)/180.*PI), &
                         sin(theta(i,j)/180.*PI),1.,0.,cc,c)
 
           !print*, c(5,5)
           c11_ary(i,j) = c(1,1)
           c13_ary(i,j) = c(1,3)
           c33_ary(i,j) = c(3,3)
           c55_ary(i,j) = c(5,5)
           c15_ary(i,j) = c(1,5)
           c35_ary(i,j) = c(3,5)
           !if (c(1,5).ne.c(5,1)) then
           !   print*, c(3,5), c(5,3), c(5,3)-c(3,5)
           !endif
           !print*, c11_ary(i,j), c13_ary(i,j), c33_ary(i,j), c55_ary(i,j)
          
        enddo
      enddo



end subroutine moduli_convert

!========================================================

  !===========================================================================
  !>
  !! \brief Rotation of stiffness matrix
  !! \param[in]    cos_dip    cos dip angle of the symmetry axis
  !! \param[in]    sin_dip    sin dip angle of the symmetry axis
  !! \param[in]    cos_azi    cos azimuth angle of the symmetry axis
  !! \param[in]    sin_azi    sin azimuth angle of the symmetry axis
  !! \param[in]    cc         input stiffness matrix
  !! \param[out]   c          rotated stiffness matrix
  !<
  subroutine rotation(cos_dip,sin_dip,cos_azi,sin_azi,cc,c)

    real cos_dip,sin_dip,cos_azi,sin_azi
    real cc(1:6,1:6),c(1:6,1:6)
    real xy(1:3,1:3),xm(1:6,1:6),ccc(1:6,1:6)

    integer :: i,j

!!  diva code
!!  xy(1,1)=cos(dip_angle)*cos(azi_angle)
!!  xy(1,2)=-sin(azi_angle)
!!  xy(1,3)=sin(dip_angle)*cos(azi_angle)
!!  xy(2,1)=cos(dip_angle)*sin(azi_angle)
!!  xy(2,2)=cos(azi_angle)
!!  xy(2,3)=sin(dip_angle)*sin(azi_angle)
!!  xy(3,1)=-sin(dip_angle)
!!  xy(3,2)=0
!!  xy(3,3)=cos(dip_angle)

    xy(1,1)=cos_dip*cos_azi
    xy(1,2)=-sin_azi
    xy(1,3)=sin_dip*cos_azi
    xy(2,1)=cos_dip*sin_azi
    xy(2,2)=cos_azi
    xy(2,3)=sin_dip*sin_azi
    xy(3,1)=-sin_dip
    xy(3,2)=0
    xy(3,3)=cos_dip

   !! bond
    xm(1,1)=xy(1,1)*xy(1,1)
    xm(1,2)=xy(1,2)*xy(1,2)
    xm(1,3)=xy(1,3)*xy(1,3)
    xm(1,4)=2.0*xy(1,2)*xy(1,3)
    xm(1,5)=2.0*xy(1,1)*xy(1,3)
    xm(1,6)=2.0*xy(1,1)*xy(1,2)
    xm(2,1)=xy(2,1)*xy(2,1)
    xm(2,2)=xy(2,2)*xy(2,2)
    xm(2,3)=xy(2,3)*xy(2,3)
    xm(2,4)=2.0*xy(2,2)*xy(2,3)
    xm(2,5)=2.0*xy(2,1)*xy(2,3)
    xm(2,6)=2.0*xy(2,1)*xy(2,2)
    xm(3,1)=xy(3,1)*xy(3,1)
    xm(3,2)=xy(3,2)*xy(3,2)
    xm(3,3)=xy(3,3)*xy(3,3)
    xm(3,4)=2.0*xy(3,2)*xy(3,3)
    xm(3,5)=2.0*xy(3,1)*xy(3,3)
    xm(3,6)=2.0*xy(3,1)*xy(3,2)
    xm(4,1)=xy(2,1)*xy(3,1)
    xm(4,2)=xy(2,2)*xy(3,2)
    xm(4,3)=xy(2,3)*xy(3,3)
    xm(4,4)=xy(2,2)*xy(3,3)+xy(2,3)*xy(3,2)
    xm(4,5)=xy(2,1)*xy(3,3)+xy(2,3)*xy(3,1)
    xm(4,6)=xy(2,1)*xy(3,2)+xy(2,2)*xy(3,1)
    xm(5,1)=xy(1,1)*xy(3,1)
    xm(5,2)=xy(1,2)*xy(3,2)
    xm(5,3)=xy(1,3)*xy(3,3)
    xm(5,4)=xy(1,2)*xy(3,3)+xy(1,3)*xy(3,2)
    xm(5,5)=xy(1,1)*xy(3,3)+xy(1,3)*xy(3,1)
    xm(5,6)=xy(1,1)*xy(3,2)+xy(1,2)*xy(3,1)
    xm(6,1)=xy(1,1)*xy(2,1)
    xm(6,2)=xy(1,2)*xy(2,2)
    xm(6,3)=xy(1,3)*xy(2,3)
    xm(6,4)=xy(1,2)*xy(2,3)+xy(2,2)*xy(1,3)
    xm(6,5)=xy(1,1)*xy(2,3)+xy(1,3)*xy(2,1)
    xm(6,6)=xy(1,1)*xy(2,2)+xy(1,2)*xy(2,1)

    !! TI
    ccc=0.0
    c=0.0
    do i=1,6
       do j=1,6
          ccc(i,j)=SUM(xm(i,1:6)*cc(1:6,j))
       enddo
    enddo

    do i=1,6
       do j=1,6
          c(i,j)=SUM(ccc(i,1:6)*xm(j,1:6))
       enddo
    enddo

  end subroutine rotation

