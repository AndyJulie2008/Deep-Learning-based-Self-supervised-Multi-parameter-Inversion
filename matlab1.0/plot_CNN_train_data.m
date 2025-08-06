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
cvalue = 0.001;
nz = 192;
nx = 192*3;


v = dlmread('train_outputs/train9.dat');

v1 = v(1:nz*nx);
v2 = v(1+nz*nx:nz*nx*2);
v3 = v(1+nz*nx*2:nz*nx*3);
v4 = v(1+nz*nx*3:nz*nx*4);%abandon

v1 = reshape(v1,nz,nx);
v2 = reshape(v2,nz,nx);
v3 = reshape(v3,nz,nx);
v4 = reshape(v4,nz,nx);%abandon



figure(1)
subplot(2,2,1)
cvalue = max(max(v1));
imagesc(v1);colormap(mycolor);caxis([-cvalue cvalue]);

subplot(2,2,2)
cvalue = max(max(v2));
imagesc(v2);colormap(mycolor);caxis([-cvalue cvalue]);

subplot(2,2,3)
cvalue = max(max(v4));
imagesc(v4);colormap(mycolor);caxis([-cvalue cvalue]);

subplot(2,2,4)
cvalue = max(max(v4));
imagesc(v4-v2);colormap(mycolor);caxis([-cvalue cvalue]);