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
cvalue = 0.1;
%---------------------------------------------------------------

nx=256;
nt=4000;
iter = 16;
err = zeros(1,iter+1);
figure(1)

for i = 1 : 1

    a = dlmread(['output0/seis_data' num2str(i) '.dat']);
    a = reshape(a,nx,nt*2).';
    a2 = a(1:nt,:);
    imagesc(a2);colormap(mycolor);caxis([-cvalue cvalue])

    drawnow;pause(0.00)
end