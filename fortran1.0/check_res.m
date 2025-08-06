


close all;
clear all;
a = dlmread('given_models0/0migdelta.dat');
a=reshape(a,256,256);
subplot(4,2,1);imagesc(a)

a2 = dlmread('given_models0/0migepsi.dat');
a2=reshape(a2,256,256);
subplot(4,2,2);imagesc(a2)


b = dlmread('given_models0/0migvp.dat');
b=reshape(b,256,256);
% subplot(2,2,3);imagesc(b)

c = b.*sqrt(1+2.*a);
subplot(4,2,3);imagesc(c)

d = b.*sqrt(1+2.*a2);
subplot(4,2,4);imagesc(d)



f = dlmread('output0/Fortran_rtm0.dat');
f=reshape(f,256,256,12);
subplot(4,2,5);imagesc(f(:,:,9))
subplot(4,2,6);imagesc(f(:,:,10))