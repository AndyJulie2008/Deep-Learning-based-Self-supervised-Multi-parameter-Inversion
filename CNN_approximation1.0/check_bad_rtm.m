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
cvalue = 0.6;
%---------------------------------------------------------------

nz = 192;
nx = 192*3;
max_reflectivity = 0.2;
dh = 0.0125;
[0 nx/3 nx/3*2 nx]*dh
%2,19,57
for i = 1:100
    try
        name = ['LSRTMtrain/CNN_train' num2str(i) '.dat'];
        CNN_real_dataset = dlmread(name);
        rtm_image = CNN_real_dataset(1:nz*nx);
        rtm_image = reshape(rtm_image,nz,nx);
        imagesc(rtm_image);drawnow;pause(0.0);title(num2str(i))
        if sum(sum(isnan(rtm_image))) > 0
            disp(i)
            system(['rm ' name]);
        end
    end
end