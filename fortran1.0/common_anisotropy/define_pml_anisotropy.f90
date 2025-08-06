!! SEISMIC_CPML Version 1.1.1, November 2009.
!
! Copyright Universite de Pau et des Pays de l'Adour, 
! CNRS and INRIA, France.
! Contributors: 
!       Dimitri Komatitsch, dimitri.komatitsch@univ-pau.fr
!       and Roland Martin, roland.martin@univ-pau.fr
!
! This software is a computer program whose purpose is to solve the 
! two-dimensional isotropic elastic wave equation using a 
! finite-difference method with Convolutional Perfectly Matched 
! Layer (C-PML) conditions.
!
! This software is governed by the CeCILL license under French law and
! abiding by the rules of distribution of free software. You can use,
! modify and/or redistribute the software under the terms of the CeCILL
! license as circulated by CEA, CNRS and INRIA at the following URL
! "http://www.cecill.info".
!
! As a counterpart to the access to the source code and rights to copy,
! modify and redistribute granted by the license, users are provided
! only with a limited warranty and the software's author, the holder 
! of the economic rights, and the successive licensors have only 
! limited liability.
!
! In this respect, the user's attention is drawn to the risks 
! associated with loading, using, modifying and/or developing or 
! reproducing the software by the user in light of its specific status 
! of free software, that may mean that it is complicated to manipulate, 
! and that also therefore means that it is reserved for developers and 
! experienced professionals having in-depth computer knowledge. Users 
! are therefore encouraged to load and test the software's suitability 
! as regards their requirements in conditions enabling the security of 
! their systems and/or data to be ensured and, more generally, to use 
! and operate it in the same conditions as regards security.
!
! The full text of the license is available at the end of this program
! and in file "LICENSE".
!-----------------------------------------------------------------------
! 2D elastic finite-difference code in velocity and stress formulation
! with Convolutional-PML (C-PML) absorbing conditions for an isotropic
! medium

! Dimitri Komatitsch, University of Pau, France, April 2007.
! Fourth-order implementation by Dimitri Komatitsch and Roland Martin,
! University of Pau, France, August 2007.
!
! The staggered-grid formulation of Madariaga (1976) and Virieux (1986)
! is used:
!
!            ^ y
!            |
!            |
!
!            +-------------------+
!            |                   |
!            |                   |
!            |                   |
!            |                   |
!            |        v_y        |
!   sigma_xy +---------+         |
!            |         |         |
!            |         |         |
!            |         |         |
!            |         |         |
!            |         |         |
!            +---------+---------+  ---> x
!           v_x    sigma_xx
!                  sigma_yy
!
! but a fourth-order spatial operator is used instead of a second-order
! operator
! as in program seismic_CPML_2D_iso_second.f90 . You can type the
! following command
! to see the changes that have been made to switch from the second-order
! operator
! to the fourth-order operator:
!
! diff seismic_CPML_2D_isotropic_second_order.f90
! seismic_CPML_2D_isotropic_fourth_order.f90

! The C-PML implementation is based in part on formulas given in Roden
! and Gedney (2000)
!
! If you use this code for your own research, please cite some (or all)
! of these articles:
!
! @ARTICLE{MaKoEz08,
! author = {Roland Martin and Dimitri Komatitsch and Abdelaaziz
! Ezziani},
! title = {An unsplit convolutional perfectly matched layer improved at
! grazing
!          incidence for seismic wave equation in poroelastic media},
! journal = {Geophysics},
! year = {2008},
! volume = {73},
! pages = {T51-T61},
! number = {4},
! doi = {10.1190/1.2939484}}
!
! @ARTICLE{MaKoGe08,
! author = {Roland Martin and Dimitri Komatitsch and Stephen D. Gedney},
! title = {A variational formulation of a stabilized unsplit
! convolutional perfectly
!          matched layer for the isotropic or anisotropic seismic wave
!          equation},
! journal = {Computer Modeling in Engineering and Sciences},
! year = {2008},
! volume = {37},
! pages = {274-304},
! number = {3}}
!
! @ARTICLE{RoGe00,
! author = {J. A. Roden and S. D. Gedney},
! title = {Convolution {PML} ({CPML}): {A}n Efficient {FDTD}
! Implementation
!          of the {CFS}-{PML} for Arbitrary Media},
! journal = {Microwave and Optical Technology Letters},
! year = {2000},
! volume = {27},
! number = {5},
! pages = {334-339},
! doi = {10.1002/1098-2760(20001205)27:5<334::AID-MOP14>3.0.CO;2-A}}
!
! @ARTICLE{KoMa07,
! author = {Dimitri Komatitsch and Roland Martin},
! title = {An unsplit convolutional {P}erfectly {M}atched {L}ayer
! improved
!          at grazing incidence for the seismic wave equation},
! journal = {Geophysics},
! year = {2007},
! volume = {72},
! number = {5},
! pages = {SM155-SM167},
! doi = {10.1190/1.2757586}}
!
! To display the 2D results as color images, use:
!
!   " display image*.gif " or " gimp image*.gif "
!
! or
!
!   " montage -geometry +0+3 -rotate 90 -tile 1x21 image*Vx*.gif
!   allfiles_Vx.gif "
!   " montage -geometry +0+3 -rotate 90 -tile 1x21 image*Vy*.gif
!   allfiles_Vy.gif "
!   then " display allfiles_Vx.gif " or " gimp allfiles_Vx.gif "
!   then " display allfiles_Vy.gif " or " gimp allfiles_Vy.gif "
!

! IMPORTANT : all our CPML codes work fine in single precision as well
! (which is significantly faster).
!             If you want you can thus force automatic conversion to
!             single precision at compile time
!             or change all the declarations and constants in the code
!             from double precision to single.
!-----------------------------------------------------------------------
 
 
 SUBROUTINE define_pml(nz, nx, vp, vs, epsi, f0, dz, dx, dt,&
        a_z,b_z, K_z, a_x, b_x, K_x,&
        a_z_half, b_z_half, K_z_half, a_x_half, b_x_half, K_x_half)

        implicit none

        ! input
        integer :: nz, nx
        real :: dz, dx, dt, f0
        real :: vs(1:nz,1:nx)
        real :: epsi(1:nz,1:nx)
   
        ! local
        real :: vp(1:nz,1:nx)

        ! output
        real, dimension(nz) :: a_z, b_z, K_z
        real, dimension(nx) :: a_x, b_x, K_x
        real, dimension(nz) :: a_z_half, b_z_half, K_z_half
        real, dimension(nx) :: a_x_half, b_x_half, K_x_half

        ! flags to add PML layers to the edges of the grid
        logical, parameter :: USE_PML_ZMIN = .true.
        logical, parameter :: USE_PML_ZMAX = .true.
        logical, parameter :: USE_PML_XMIN = .true.
        logical, parameter :: USE_PML_XMAX = .true.

        ! thickness of the PML layer in grid points
        integer, parameter :: NPOINTS_PML = 10

        ! value of PI
        real, parameter :: PI = 4. / atan(1.)

        ! zero
        real, parameter :: real0 = 0.d0

        ! power to compute d0 profile
        real, parameter :: NPOWER = 2.d0

        real, parameter :: K_MAX_PML = 1.d0 ! from Gedney page 8.11
        !from Festa and Vilotte:
!!!        real, parameter :: ALPHA_MAX_PML = 2.e0*PI*(f0/2.e0)
        real  ALPHA_MAX_PML

        ! 1D arrays for the damping profiles
        real, dimension(nz) :: d_z, alpha_z, d_z_half, alpha_z_half
        real, dimension(nx) :: d_x, alpha_x, d_x_half, alpha_x_half

        real :: thickness_PML_z, thickness_PML_x
        real :: zoriginleft, zoriginright, xoriginbottom, xorigintop
        real :: Rcoef, d0_z(nz,2), d0_x(nx,2), zval, xval
        real :: abscissa_in_PML, abscissa_normalized

        integer :: iz, ix

!--- define profile of absorption in PML region
        ALPHA_MAX_PML = 2.e0*PI*(f0/2.e0)
! thickness of the PML layer in meters
  thickness_PML_z = NPOINTS_PML * dz
  thickness_PML_x = NPOINTS_PML * dx

!  do iz = 1, nz
!  do ix = 1, nx
!   vp(iz, ix) = max(sqrt(c22(iz, ix)/rho(iz, ix)),sqrt(c11(iz, ix)/rho(iz, ix)))
!  enddo
!  enddo
! reflection coefficient (INRIA report section 6.1) http://hal.inria.fr/docs/00/07/32/19/PDF/RR-3471.pdf
  Rcoef =  0.001d0

! check that NPOWER is okay
  if(NPOWER < 1) stop 'NPOWER must be greater than 1'

!       compute d0 from INRIA report section 6.1 
!       http://hal.inria.fr/docs/00/07/32/19/PDF/RR-3471.pdf

  do iz = 1,nz
     !left:
     !d0_z(iz,1) = -(NPOWER+1) * vp(iz,1)*sqrt(1+epsi(iz,1)) * log(Rcoef) / (2.e0 * thickness_PML_z)
     d0_z(iz,1) = -(NPOWER+1) * vp(iz,1)* log(Rcoef) / (2.e0 * thickness_PML_z)

     !right:
     !d0_z(iz,2) = -(NPOWER+1) * vp(iz,nx)*sqrt(1+epsi(iz,nx)) * log(Rcoef) / (2.e0 * thickness_PML_z)
     d0_z(iz,2) = -(NPOWER+1) * vp(iz,nx)* log(Rcoef) / (2.e0 * thickness_PML_z)
  enddo

  do ix = 1,nx
     !bottom:
     !d0_x(ix,1) = -(NPOWER+1) * vp(nz,ix)*sqrt(1+epsi(nz,ix)) * log(Rcoef) / (2.e0 * thickness_PML_x)
     d0_x(ix,1) = -(NPOWER+1) * vp(nz,ix) * log(Rcoef) / (2.e0 * thickness_PML_x)

     !top:
     !d0_x(ix,2) = -(NPOWER+1) * vp(1,ix)*sqrt(1+epsi(1,ix)) * log(Rcoef) / (2.e0 * thickness_PML_x)
     d0_x(ix,2) = -(NPOWER+1) * vp(1,ix) * log(Rcoef) / (2.e0 * thickness_PML_x)
  enddo

!!!  print *,'d0_z = ',d0_z
!!!  print *,'d0_x = ',d0_x
!!!  print *

  d_z(:) = real0
  d_z_half(:) = real0
  K_z(:) = 1.e0
  K_z_half(:) = 1.e0
  alpha_z(:) = real0
  alpha_z_half(:) = real0
  a_z(:) = real0
  a_z_half(:) = real0

  d_x(:) = real0
  d_x_half(:) = real0
  K_x(:) = 1.e0
  K_x_half(:) = 1.e0
  alpha_x(:) = real0
  alpha_x_half(:) = real0
  a_x(:) = real0
  a_x_half(:) = real0
! damping in the X direction

! origin of the PML layer (position of right edge minus thickness, in meters)
  zoriginleft = thickness_PML_z
  !zoriginleft = thickness_PML_z-dz ! wenlong
  zoriginright = (nz-1)*dz - thickness_PML_z

  do iz = 1,nz

! abscissa of current grid point along the damping profile
    zval = dz * real(iz-1)

!---------- left edge
    if(USE_PML_ZMIN) then

! define damping profile at the grid points
      abscissa_in_PML = zoriginleft - zval
      if(abscissa_in_PML >= real0) then
!        print*,iz
        abscissa_normalized = abscissa_in_PML / thickness_PML_z
        d_z(iz) = d0_z(iz,1) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_z(iz) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_z(iz) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0 * ALPHA_MAX_PML
      endif
! define damping profile at half the grid points
      abscissa_in_PML = zoriginleft - (zval + dz/2.e0)
      if(abscissa_in_PML >= real0) then
        abscissa_normalized = abscissa_in_PML / thickness_PML_z
        d_z_half(iz) = d0_z(iz,1) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_z_half(iz) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_z_half(iz) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0* ALPHA_MAX_PML
      endif


    endif

!---------- right edge
    if(USE_PML_ZMAX) then

! define damping profile at the grid points
      abscissa_in_PML = zval - zoriginright
      if(abscissa_in_PML >= real0) then
!        print*,iz
        abscissa_normalized = abscissa_in_PML / thickness_PML_z
        d_z(iz) = d0_z(iz,2) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_z(iz) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_z(iz) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0 * ALPHA_MAX_PML
      endif

! define damping profile at half the grid points
      abscissa_in_PML = zval + dz/2.e0 - zoriginright
      if(abscissa_in_PML >= real0) then
        abscissa_normalized = abscissa_in_PML / thickness_PML_z
        d_z_half(iz) = d0_z(iz,2) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_z_half(iz) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_z_half(iz) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0* ALPHA_MAX_PML
      endif

    endif

! just in case, for -5 at the end
    if(alpha_z(iz) < real0) alpha_z(iz) = real0
    if(alpha_z_half(iz) < real0) alpha_z_half(iz) = real0

    b_z(iz) = exp(- (d_z(iz) / K_z(iz) + alpha_z(iz)) * dt)
    b_z_half(iz) = exp(- (d_z_half(iz) / K_z_half(iz) + alpha_z_half(iz)) * dt)

! this to avoid division by zero outside the PML
    if(abs(d_z(iz)) > 1.e-6) a_z(iz) = d_z(iz) * (b_z(iz) - 1.e0) / (K_z(iz) * (d_z(iz) + K_z(iz) * alpha_z(iz)))
    if(abs(d_z_half(iz)) > 1.e-6) a_z_half(iz) = d_z_half(iz) * &
      (b_z_half(iz) - 1.e0) / (K_z_half(iz) * (d_z_half(iz) + K_z_half(iz) * alpha_z_half(iz)))

  enddo

! damping in the X direction

! origin of the PML layer (position of right edge minus thickness, in meters)
  xoriginbottom = thickness_PML_x
  !xoriginbottom = thickness_PML_x-dx ! wenlong
  xorigintop = (nx-1)*dx - thickness_PML_x

  do ix = 1,nx

! abscissa of current grid point along the damping profile
    xval = dx * real(ix-1)

!---------- bottom edge
    if(USE_PML_XMIN) then

! define damping profile at the grid points
      abscissa_in_PML = xoriginbottom - xval
      if(abscissa_in_PML >= real0) then
!        print*,ix
        abscissa_normalized = abscissa_in_PML / thickness_PML_x
        d_x(ix) = d0_x(ix,1) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_x(ix) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_x(ix) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0 * ALPHA_MAX_PML
      endif
! define damping profile at half the grid points
      abscissa_in_PML = xoriginbottom - (xval + dx/2.e0)
      if(abscissa_in_PML >= real0) then
        abscissa_normalized = abscissa_in_PML / thickness_PML_x
        d_x_half(ix) = d0_x(ix,1) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_x_half(ix) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_x_half(ix) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0* ALPHA_MAX_PML
      endif


    endif

!---------- top edge
    if(USE_PML_XMAX) then

! define damping profile at the grid points
      abscissa_in_PML = xval - xorigintop
      if(abscissa_in_PML >= real0) then
!        print*,ix
        abscissa_normalized = abscissa_in_PML / thickness_PML_x
        d_x(ix) = d0_x(ix,2) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_x(ix) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_x(ix) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0 * ALPHA_MAX_PML
      endif
! define damping profile at half the grid points
      abscissa_in_PML = xval + dx/2.e0 - xorigintop
      if(abscissa_in_PML >= real0) then
        abscissa_normalized = abscissa_in_PML / thickness_PML_x
        d_x_half(ix) = d0_x(ix,2) * abscissa_normalized**NPOWER
! this taken from Gedney page 8.2
        K_x_half(ix) = 1.e0 + (K_MAX_PML - 1.e0) * abscissa_normalized**NPOWER
        alpha_x_half(ix) = ALPHA_MAX_PML * (1.e0 - abscissa_normalized) + 0.1e0 * ALPHA_MAX_PML
      endif

    endif

    b_x(ix) = exp(- (d_x(ix) / K_x(ix) + alpha_x(ix)) * dt)
    b_x_half(ix) = exp(- (d_x_half(ix) / K_x_half(ix) + alpha_x_half(ix)) * dt)

! this to avoid division by zero outside the PML
    if(abs(d_x(ix)) > 1.e-6) a_x(ix) = d_x(ix) * (b_x(ix) - 1.e0) / (K_x(ix) * (d_x(ix) + K_x(ix) * alpha_x(ix)))
    if(abs(d_x_half(ix)) > 1.e-6) a_x_half(ix) = d_x_half(ix) * &
      (b_x_half(ix) - 1.e0) / (K_x_half(ix) * (d_x_half(ix) + K_x_half(ix) *alpha_x_half(ix)))


  enddo
        RETURN
        END SUBROUTINE define_pml
!***********************************************************************
!***********************************************************************


