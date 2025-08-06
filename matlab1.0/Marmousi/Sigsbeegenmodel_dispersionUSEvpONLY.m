clear all
pack
close all
clc

orignx=3201; %0.00762
orignz=1201; %0.00762
start_z = 350
start_x = 1
nx=256*2;
nz=256*2;
compress = 2;
isr = 3; %for mute velocity
%input original model
vp=dlmread('velSigsbeemodel.dat');

vp=reshape(vp,orignz,orignx);
vp = vp(start_z + 1:start_z + nz,start_x + 1:start_x + nx);

for i = 1:nx
    for j = 1:nz
        if mod(j,compress) == 0 && mod(i,compress) == 0
            vp(int32(j/compress),int32(i/compress))=vp(j, i);
        end
    end
end

nz = int32(nz/compress);
nx = int32(nx/compress);
vp = vp(1:nz,1:nx);

rho = 0.31*sqrt(sqrt(vp*1000));



figure(100)
subplot(2,2,1);imagesc(vp);colorbar;
title('True vp')
%output correct model:
vp = reshape(vp,1,nz*nx);
name1 = 'Sigsbee_vp';
fid=fopen([name1 num2str(start_z) 'x' num2str(start_x) '.dat'],'wt');
fprintf(fid,'%17.8f',vp);
fclose(fid);

subplot(2,2,2);imagesc(rho);colorbar;
title('True rho')
%output correct model:
rho = reshape(rho,1,nz*nx);
name2 = 'Sigsbee_rho';
fid=fopen([name2 num2str(start_z) 'x' num2str(start_x) '.dat'],'wt');
fprintf(fid,'%17.8f',rho);
fclose(fid);

% ========================================
% create smooth model using slowness!
% ========================================
numofsmooth=1;
vp=reshape(vp,nz,nx);
mute_vp = ones(nz,nx)*vp(isr,nx/2);
sp = 1./vp;
filter=ones(3,3);
smooth_sp=sp;
for i=1:numofsmooth
temp= xcorr2(smooth_sp,filter);
smooth_sp=temp(2:nz+1,2:nx+1);
smooth_sp(1,:)  = smooth_sp(2,:);
smooth_sp(nz,:) = smooth_sp(nz-1,:);
smooth_sp(:,1)  = smooth_sp(:,2);
smooth_sp(:,nx) = smooth_sp(:,nx-1);
smooth_sp=smooth_sp/9;
end


%output smooth model:
vp = 1./smooth_sp;
subplot(2,2,3);imagesc(vp);colorbar;
title('Migration model')
vp=reshape(vp,1,nz*nx);
fid=fopen(['mig_' num2str(numofsmooth) name1 '.dat'],'wt');
fprintf(fid,'%17.8f',vp);
fclose(fid);





rho=reshape(rho,nz,nx);
mute_rho = ones(nz,nx)*rho(isr,nx/2);
sp = 1./rho;
filter=ones(3,3);
smooth_sp=sp;
for i=1:numofsmooth
temp= xcorr2(smooth_sp,filter);
smooth_sp=temp(2:nz+1,2:nx+1);
smooth_sp(1,:)  = smooth_sp(2,:);
smooth_sp(nz,:) = smooth_sp(nz-1,:);
smooth_sp(:,1)  = smooth_sp(:,2);
smooth_sp(:,nx) = smooth_sp(:,nx-1);
smooth_sp=smooth_sp/9;
end


%output smooth model:
rho = 1./smooth_sp;
subplot(2,2,4);imagesc(rho);colorbar;
title('Migration model')
rho=reshape(rho,1,nz*nx);
fid=fopen(['mig_' num2str(numofsmooth) name2 '.dat'],'wt');
fprintf(fid,'%17.8f',rho);
fclose(fid);








