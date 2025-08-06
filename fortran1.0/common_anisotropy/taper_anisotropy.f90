! ********************************************************************** C
!                                                                        C
!  Program  :  taper.f90                                                C
!  Coded by :  Wenlong Wang                                              C
!  Function :  Apply tapering to the edges of wavefield/seismograms      C
!  Date     :  2015                                                      C
!  Language :  Fortran 90                                                C
!  Copyright:  Center for Lithospheric Studies                           C
!              The University of Texas at Dallas, 2015                   C
!                                                                        C
! ********************************************************************** C
! ===================================================================

      subroutine taper(snap, nz,nx,npml)
      parameter (pi=3.1415926)
      integer nz,nx,nzsr, bound1,bound2,npml
      real damp, ntpp, tp, ntp1
      real snap(nz,nx)
      real snap_o(nz,nx)
      real xx(nx), yy(nz), cc(nz,nx)
! mute
      ntpp = 10
      bound1=ntpp+npml
      tp = pi/ntpp
      ntp1 = nx - ntpp + 1
      bound2=nx-bound1+1
      do i = 1,nx
         xx(i) = 1.0
         if(i .le. bound1) xx(i) = 0.5*(1.0-cos((i+ntpp-bound1)*tp))
         if(i .le. (bound1-ntpp)) xx(i) = 0.0
         if(i .ge. bound2) xx(i) = 0.5*(1.0+cos(((i-bound2))*tp))
         if(i .ge. bound2+ntpp) xx(i) = 0.0
      enddo

      ntp1 = nz - ntpp + 1
      bound2=nz-bound1+1
      do i = 1,nz
         yy(i) = 1.0
         if(i .le. bound1) yy(i) = 0.5*(1.0-cos((i+ntpp-bound1)*tp))
         if(i .le. (bound1-ntpp)) yy(i) = 0.0
         if(i .ge. bound2) yy(i) = 0.5*(1.0+cos(((i-bound2))*tp))
         if(i .ge. bound2+ntpp) yy(i) = 0.0
      enddo

      ! get two-dimension taper array
      do iz = 1,nz
      do ix = 1,nx
         cc(iz,ix) = xx(ix) * yy(iz)
         snap(iz,ix) = snap(iz,ix)*cc(iz,ix)
      enddo
      enddo

        end


