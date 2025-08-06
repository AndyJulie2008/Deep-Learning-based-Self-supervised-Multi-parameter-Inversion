
subroutine skiplines(lfilnam,n)

implicit none

integer  lfilnam,i,n

do i=1,n
  read(lfilnam,*)
enddo

return
end

