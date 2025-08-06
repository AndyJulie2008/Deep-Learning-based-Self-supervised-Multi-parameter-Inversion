! ********************************************************************** C
!                                                                        C
!  Program  :  getmod                                                    C
!  Coded by :  Wenlong Wang                                              C
!  Function :  Subroutine to read in parameter file                      C
!  Date     :  2020                                                     C
!  Language :  Fortran 90                                                C
! ********************************************************************** C
! ======================================================================!
      subroutine readparameter(inpt, nz, nx, nt, dt, deltah, &
                               itsnap, itshow, nsr, &
                               zsrg1, xsrg1, src_int, &
                               freq0, flag_ps, rank, datapath)
!
!
      implicit none
! Arguments
      integer inpt
      integer nz, nx, nt, flag_ps, rank
      real dt, deltah
      integer itsnap, itshow, nsr
      integer zsrg1, xsrg1, src_int
      real freq0
      character*128 datapath

!
      !initial
!
      !read in model parameters
      call skiplines(inpt, 3)
      read(inpt, *) nz, nx, nt
      read(inpt, *) dt, deltah
!
      !read in miscellaneou parameters
      call skiplines(inpt, 3)
      read(inpt, *) itsnap
      read(inpt, *) itshow
!
      !read in source locations (z,x)
      call skiplines(inpt, 3)
      read(inpt, *) nsr
      read(inpt, *) zsrg1, xsrg1, src_int
      !read in dominant frequencys
      read(inpt, *) freq0

      !read in rank number for PS decomposition
      call skiplines(inpt, 3)
      read(inpt, *) flag_ps, rank
!
      !read in data path
      call skiplines(inpt, 3)
      read(inpt,'(a)') datapath
!
      end
