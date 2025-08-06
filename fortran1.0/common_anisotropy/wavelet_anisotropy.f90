subroutine series(seri, minstep, dt, nstep, fdom)
implicit none
integer nstep, nprd, minstep
real  dt, seri(minstep:nstep)
!  Local Parameters
      integer it
      real  pi, amax, fdom, a, t,t0
!
!     added by Xinfa Zhu
      nprd = nint(1.0/(1.4*fdom*dt))
!
      pi=4.*atan(1.)
! assign 0 to maximum value.
      amax=0.
! choose source as derivative (with respect to time) of a gaussian.
! Option 1
!      do 815 it=1,nstep
!       seri(it)=-2.*(it-nprd+2)*exp(-(pi*dt*(it-nprd+2)/(nprd*dt))**2)
!         if(abs(seri(it)).gt.amax)amax=abs(seri(it))
! 815  continue

! Option 2
      a=pi*pi*fdom*fdom
      t0 = 1.20 /fdom 
      do 818 it=1,nstep
        t = real(it-1)*dt
        seri(it) = (1.e0 - 2.e0*a*(t-t0)**2)*exp(-a*(t-t0)**2)
         if(abs(seri(it)).gt.amax)amax=abs(seri(it))
 818  continue
!
! normalize source function.
      do 817 it=1,nstep
         seri(it)=seri(it)/amax
 817  continue
!
      return
      end