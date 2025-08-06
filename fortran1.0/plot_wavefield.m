clear all
close all
clc
format short
%------------------ colorbar setting----------------------------
Ncolor=64;
lenwhite=0;
indexcolor=zeros(Ncolor*3/2-lenwhite/2,1);
for i=1:Ncolor*1.5-lenwhite/2
    indexcolor(i)=i/(Ncolor*1.5-lenwhite/2);
end
mycolor=zeros(Ncolor*3,3);
mycolor(1:Ncolor*2,1)=1;
mycolor(1+Ncolor:Ncolor*3,3)=1;
mycolor(Ncolor*1.5-lenwhite/2:Ncolor*1.5+lenwhite/2,2)=1;
mycolor(1:Ncolor*1.5-lenwhite/2,2)=indexcolor;
mycolor(1:Ncolor*1.5-lenwhite/2,3)=indexcolor;
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,1)=flipud(indexcolor);
mycolor(1+Ncolor*1.5+lenwhite/2:Ncolor*3,2)=flipud(indexcolor);
mycolor=flipud(mycolor);
cvalue = 15;
%---------------------------------------------------------------

nx=256;nz=256;
nt=4000;
iter = 16;
figure(1)

    
for i = 1 : 100:2000
    a = dlmread(['output0/wavefield' num2str(i) '.dat']);
    a = reshape(a,nz,nx).';
    imagesc(a);colormap(mycolor);caxis([-cvalue cvalue])
    drawnow;pause(0.00)
end