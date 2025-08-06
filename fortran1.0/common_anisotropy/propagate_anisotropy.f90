! ********************************************************************** C
!                                                                        C
!  Program  :  propagate.f90                                             C
!  Coded by :  Wenlong Wang                                              C
!  Function :  Numerically calculate stress-velocity formulation         C
!  Date     :  2015                                                      C
!  Language :  Fortran 90                                                C
!  Copyright:  Center for Lithospheric Studies                           C
!              The University of Texas at Dallas, 2015                   C
!                                                                        C
! ********************************************************************** C
! ===================================================================
!
      subroutine eqmot(nx, nz, deltah, dt,lv,aa,&
                       rho,vx,vz,sxx,szz,szx,&
                       memory_dsigmaxx_dx,memory_dsigmazz_dz,&
                       memory_dsigmazx_dx,memory_dsigmazx_dz,&
                       a_z,b_z,k_z,a_x,b_x,k_x,&
                   a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)


!
! -------------------------------------------------------------------
! equation of motion
! compute particle velocities and displacement from stresses
! Copyright : The University of Texas at Dallas, 2014.
! -------------------------------------------------------------------
!
      implicit none
!
!  Arguments
      integer nx, nz, lv
      real deltah, dt
      real aa(4)
      real rho(1:nz,1:nx)
      real vx(-lv:nz+lv,-lv:nx+lv),vz(-lv:nz+lv,-lv:nx+lv)
      real sxx(-lv:nz+lv,-lv:nx+lv),szz(-lv:nz+lv,-lv:nx+lv)
      real szx(-lv:nz+lv,-lv:nx+lv)
      real memory_dsigmaxx_dx(1:nz,1:nx),memory_dsigmazz_dz(1:nz,1:nx)
      real memory_dsigmazx_dx(1:nz,1:nx),memory_dsigmazx_dz(1:nz,1:nx)
      real a_z(1:nz),b_z(1:nz),k_z(1:nz)
      real a_x(1:nx),b_x(1:nx),k_x(1:nx)
      real a_z_half(1:nz),b_z_half(1:nz),k_z_half(1:nz)
      real a_x_half(1:nx),b_x_half(1:nx),k_x_half(1:nx)

!  Local Parameters
      integer i, k
      real value_dsigmaxx_dx, value_dsigmazx_dz
      real value_dsigmazz_dz, value_dsigmazx_dx
         
!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,k,value_dsigmaxx_dx,value_dsigmazx_dz,value_dsigmazx_dx,value_dsigmazz_dz)

!$OMP DO SCHEDULE(STATIC)
      do i = 1, nx
      do k = 1, nz
        value_dsigmaxx_dx=(aa(1)*(sxx(k,i+1)-sxx(k,i  ))&
                          +aa(2)*(sxx(k,i+2)-sxx(k,i-1))&
                          +aa(3)*(sxx(k,i+3)-sxx(k,i-2))&
                          +aa(4)*(sxx(k,i+4)-sxx(k,i-3)))/deltah
        value_dsigmazx_dz=(aa(1)*(szx(k  ,i)-szx(k-1,i))&
                          +aa(2)*(szx(k+1,i)-szx(k-2,i))&
                          +aa(3)*(szx(k+2,i)-szx(k-3,i))&
                          +aa(4)*(szx(k+3,i)-szx(k-4,i)))/deltah
! MEMORY INCONSISTENT
      memory_dsigmaxx_dx(k,i) = b_x_half(i) * memory_dsigmaxx_dx(k,i) +&
                               a_x_half(i) * value_dsigmaxx_dx
      memory_dsigmazx_dz(k,i) = b_z(k) * memory_dsigmazx_dz(k,i) +&
                               a_z(k) * value_dsigmazx_dz
      value_dsigmaxx_dx = value_dsigmaxx_dx / K_x_half(i) +&
                          memory_dsigmaxx_dx(k,i)
      value_dsigmazx_dz = value_dsigmazx_dz / K_z(k) +&
                           memory_dsigmazx_dz(k,i)
      vx(k,i) = vx(k,i) &
         + (value_dsigmaxx_dx + value_dsigmazx_dz) * dt / rho(k,i)
           ! ((rho(k,i)+rho(k,i+1)+rho(k,i)+rho(k-1,i))*0.25)

      end do
      end do
!$OMP END DO NOWAIT

!$OMP DO SCHEDULE(STATIC)

      do i = 1, nx
      do k = 1, nz
        value_dsigmazx_dx=(aa(1)*(szx(k,i  )-szx(k,i-1))&
                          +aa(2)*(szx(k,i+1)-szx(k,i-2))&
                          +aa(3)*(szx(k,i+2)-szx(k,i-3))&
                          +aa(4)*(szx(k,i+3)-szx(k,i-4)))/deltah
        value_dsigmazz_dz=(aa(1)*(szz(k+1,i)-szz(k  ,i))&
                          +aa(2)*(szz(k+2,i)-szz(k-1,i))&
                          +aa(3)*(szz(k+3,i)-szz(k-2,i))&
                          +aa(4)*(szz(k+4,i)-szz(k-3,i)))/deltah
      memory_dsigmazx_dx(k,i) = b_x(i) * memory_dsigmazx_dx(k,i) +&
                               a_x(i) * value_dsigmazx_dx
      memory_dsigmazz_dz(k,i) = b_z_half(k) * memory_dsigmazz_dz(k,i) +&
                               a_z_half(k) * value_dsigmazz_dz
      value_dsigmazx_dx = value_dsigmazx_dx / K_x(i) +&
                         memory_dsigmazx_dx(k,i)
      value_dsigmazz_dz = value_dsigmazz_dz / K_z_half(k) +&
                         memory_dsigmazz_dz(k,i)

        vz(k,i) = vz(k,i)&
         + (value_dsigmazx_dx+value_dsigmazz_dz)*dt/ rho(k,i)
            !((rho(k,i)+rho(k,i+1)+rho(k,i)+rho(k-1,i))*0.25)

      end do
      end do
!$OMP END DO NOWAIT

!$OMP END PARALLEL
!
      return
      end

!-----------------------------------------------------------------
!/////////////////////////////////////////////////////////////////
!-----------------------------------------------------------------
!
      subroutine hooke(nx,nz,deltah,dt,lv,aa,&
                       c11,c13,c33,c55,&
                       c15,c35,&
                       vx,vz,sxx,szz,szx,&
                       memory_dvx_dx,memory_dvz_dz,&
                       memory_dvz_dx,memory_dvx_dz,&
                       a_z,b_z,k_z,a_x,b_x,k_x,&
                       a_z_half, b_z_half,K_z_half,a_x_half, b_x_half,K_x_half)

 
! -------------------------------------------------------------------
! generalized hooke's law
! compute stresses from particle velocities, displacement and memory
! variables
! Copyright : The University of Texas at Dallas, 2014.
! -------------------------------------------------------------------
      implicit none
!
!  Arguments
      integer nx, nz, lv
      real aa(4)
      real deltah, dt
      real c11(1:nz,1:nx),c13(1:nz,1:nx)
      real c33(1:nz,1:nx),c55(1:nz,1:nx)
      real c15(1:nz,1:nx),c35(1:nz,1:nx)
      real vx(-lv:nz+lv,-lv:nx+lv),vz(-lv:nz+lv,-lv:nx+lv)
      real sxx(-lv:nz+lv,-lv:nx+lv),szz(-lv:nz+lv,-lv:nx+lv)
      real szx(-lv:nz+lv,-lv:nx+lv)
      real memory_dvx_dx(1:nz,1:nx),memory_dvz_dz(1:nz,1:nx)
      real memory_dvz_dx(1:nz,1:nx),memory_dvx_dz(1:nz,1:nx)
      real a_z(1:nz),b_z(1:nz),k_z(1:nz)
      real a_x(1:nx),b_x(1:nx),k_x(1:nx)
      real a_z_half(1:nz),b_z_half(1:nz),k_z_half(1:nz)
      real a_x_half(1:nx),b_x_half(1:nx),k_x_half(1:nx)
!  Local Parameters
      integer i, k
      real*4 value_dvx_dx, value_dvz_dz
      real*4 value_dvz_dx, value_dvx_dz


!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,k,value_dvx_dx,value_dvz_dz,value_dvz_dx,value_dvx_dz)

!$OMP DO SCHEDULE(STATIC)
      do i = 1, nx
      do k = 1, nz
        value_dvx_dx=(aa(1)*(vx(k,i)-vx(k,i-1))&
                     +aa(2)*(vx(k,i+1)-vx(k,i-2))&
                     +aa(3)*(vx(k,i+2)-vx(k,i-3))&
                     +aa(4)*(vx(k,i+3)-vx(k,i-4)))/deltah
        value_dvz_dz=(aa(1)*(vz(k,i)-vz(k-1,i))&
                     +aa(2)*(vz(k+1,i)-vz(k-2,i))&
                     +aa(3)*(vz(k+2,i)-vz(k-3,i))&
                     +aa(4)*(vz(k+3,i)-vz(k-4,i)))/deltah
        memory_dvx_dx(k,i) = b_x(i) * memory_dvx_dx(k,i) + a_x(i) *&
                             value_dvx_dx
        memory_dvz_dz(k,i) = b_z(k) * memory_dvz_dz(k,i) + a_z(k) *&
                             value_dvz_dz
        value_dvx_dx = value_dvx_dx / K_x(i) + memory_dvx_dx(k,i)
        value_dvz_dz = value_dvz_dz / K_z(k) + memory_dvz_dz(k,i)



        value_dvz_dx=(aa(1)*(vz(k,i+1)-vz(k,i))&
                     +aa(2)*(vz(k,i+2)-vz(k,i-1))&
                     +aa(3)*(vz(k,i+3)-vz(k,i-2))&
                     +aa(4)*(vz(k,i+4)-vz(k,i-3)))/deltah
        value_dvx_dz=(aa(1)*(vx(k+1,i)-vx(k,i))&
                     +aa(2)*(vx(k+2,i)-vx(k-1,i))&
                     +aa(3)*(vx(k+3,i)-vx(k-2,i))&
                     +aa(4)*(vx(k+4,i)-vx(k-3,i)))/deltah
        memory_dvz_dx(k,i) = b_x_half(i) * memory_dvz_dx(k,i) +&
                             a_x_half(i) * value_dvz_dx
        memory_dvx_dz(k,i) = b_z_half(k) * memory_dvx_dz(k,i) +&
                             a_z_half(k) * value_dvx_dz

        value_dvz_dx = value_dvz_dx / K_x_half(i) + memory_dvz_dx(k,i)
        value_dvx_dz = value_dvx_dz / K_z_half(k) + memory_dvx_dz(k,i)

        sxx(k,i) = sxx(k,i) &
            + (c11(k,i) * value_dvx_dx + c13(k,i) * value_dvz_dz &
            +  c15(k,i) * (value_dvz_dx + value_dvx_dz)) * dt
        szz(k,i) = szz(k,i) &
            + (c13(k,i) * value_dvx_dx + c33(k,i) * value_dvz_dz &
            +  c35(k,i) * (value_dvz_dx + value_dvx_dz)) * dt

        szx(k,i) = szx(k,i) &
          + (c55(k,i) * (value_dvz_dx + value_dvx_dz) &
          +  c15(k,i)*value_dvx_dx + c35(k,i)*value_dvz_dz) * dt
      end do
      end do
!$OMP END DO NOWAIT

!$OMP END PARALLEL
!
      return
      end
!
!-----------------------------------------------------------------
!/////////////////////////////////////////////////////////////////
!-----------------------------------------------------------------
!
!

