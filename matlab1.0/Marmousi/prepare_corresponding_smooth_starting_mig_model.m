% sh_num_smooth_iteration = 400;
% sh_filter_size = 3;
% sh_water_depth = 13;

nxx=1000;
nzz=300;
nx=256;
nz=256;

start_x=491;
start_z=nzz-nz+1;

iter = num2str(0);
num_smooth_iteration = sh_num_smooth_iteration;
filter_size = sh_filter_size;
water_depth = sh_water_depth;
%input model
%vp = dlmread([iter 'th_iteration_FWI_model.dat']);
fid1=fopen('vpmodel','r');
vp=fread(fid1,[nxx nzz],'float32').'/1000;

fid1=fopen('vsmodel','r');
vs=fread(fid1,[nxx nzz],'float32').'/1000;

fid1=fopen('rhomodel','r');
rho=fread(fid1,[nxx nzz],'float32').'/1000;

fid1=fopen('epsimodel','r');
epsi=fread(fid1,[nxx nzz],'float32').';

fid1=fopen('deltamodel','r');
delta=fread(fid1,[nxx nzz],'float32').';

%conversion
vp_hor=vp.*sqrt(1+2*epsi);
vp_nmo=vp.*sqrt(1+2*delta);

vp=vp(start_z:start_z+nz-1,start_x:start_x+nx-1);
vs=vs(start_z:start_z+nz-1,start_x:start_x+nx-1);
rho=rho(start_z:start_z+nz-1,start_x:start_x+nx-1);
epsi=epsi(start_z:start_z+nz-1,start_x:start_x+nx-1);
delta=delta(start_z:start_z+nz-1,start_x:start_x+nx-1);

vp_hor=vp_hor(start_z:start_z+nz-1,start_x:start_x+nx-1);
vp_nmo=vp_nmo(start_z:start_z+nz-1,start_x:start_x+nx-1);

% % % % % vs = zeros(nz,nx);
% rho = 0.31*sqrt(sqrt(vp*1000));
low = 2;
high = 4;

figure(1);
subplot(3,3,1);imagesc(vp);caxis([1.5 4.5]);colormap('jet');
subplot(3,3,2);imagesc(vs);caxis([0 2.3]);colormap('jet');
subplot(3,3,3);imagesc(rho);caxis([1.5 2.5]);colormap('jet');
subplot(3,3,4);imagesc(vp_hor);caxis([1.5 4.5]);colormap('jet');
subplot(3,3,5);imagesc(vp_nmo);caxis([1.5 4.5]);colormap('jet');
subplot(3,3,7);imagesc(epsi);
subplot(3,3,8);imagesc(delta);

title('True model');
%output correct model:
vp = reshape(vp,1,nz*nx);
vs = reshape(vs,1,nz*nx);
rho = reshape(rho,1,nz*nx);

fid=fopen([iter 'th_true_vp.dat'],'wt');
fprintf(fid,'%17.8f',vp);
fclose(fid);

fid=fopen([iter 'th_true_vs.dat'],'wt');
fprintf(fid,'%17.8f',vs);
fclose(fid);

fid=fopen([iter 'th_true_rho.dat'],'wt');
fprintf(fid,'%17.8f',rho);
fclose(fid);

fid=fopen([iter 'th_true_epsi.dat'],'wt');
fprintf(fid,'%17.8f',epsi);
fclose(fid);

fid=fopen([iter 'th_true_delta.dat'],'wt');
fprintf(fid,'%17.8f',delta);
fclose(fid);

fid=fopen([iter 'th_true_vp_hor.dat'],'wt');
fprintf(fid,'%17.8f',vp_hor);
fclose(fid);

fid=fopen([iter 'th_true_vp_nmo.dat'],'wt');
fprintf(fid,'%17.8f',vp_nmo);
fclose(fid);

% ========================================
% create smooth vp model using slowness!
% ========================================
figure(2)
vp = reshape(vp,nz,nx);
vp_smooth = vp;
for i = 1:num_smooth_iteration
    if i >= num_smooth_iteration-10
        vp_smooth(1:water_depth,:) = vp(1:water_depth,:);
    end
    vp_smooth = imfilter(vp_smooth, fspecial('gaussian',filter_size),'replicate','same');
end
subplot(3,3,1);imagesc(vp_smooth);caxis([1.5 4.5]);colormap('jet');

vp_smooth=reshape(vp_smooth,1,nz*nx);
fid=fopen([iter 'th_mig_vp.dat'],'wt');
fprintf(fid,'%17.8f',vp_smooth);
fclose(fid);

vp_smooth = reshape(vp_smooth,nz,nx);
% ========================================
% create smooth vs model using slowness!
% ========================================
vs = reshape(vs,nz,nx);
vs_smooth = vs;
for i = 1:num_smooth_iteration
    if i >= num_smooth_iteration-10
        vs_smooth(1:water_depth,:) = vs(1:water_depth,:);
    end
    vs_smooth = imfilter(vs_smooth, fspecial('gaussian',filter_size),'replicate','same');
end
subplot(3,3,2);imagesc(vs_smooth);caxis([0 2.3]);colormap('jet');

vs_smooth=reshape(vs_smooth,1,nz*nx);
fid=fopen([iter 'th_mig_vs.dat'],'wt');
fprintf(fid,'%17.8f',vs_smooth);
fclose(fid);



% ========================================
% create smooth rho model using slowness!
% ========================================
% % 1. smoothing by filtering the true density model
rho = reshape(rho,nz,nx);
rho_smooth = rho;
for i = 1:num_smooth_iteration
    if i >= num_smooth_iteration-10
        rho_smooth(1:water_depth,:) = rho(1:water_depth,:);
    end
    rho_smooth = imfilter(rho_smooth, fspecial('gaussian',filter_size),'replicate','same');
end
subplot(3,3,3);imagesc(rho_smooth);caxis([1.5 2.5]);colormap('jet');

rho_smooth=reshape(rho_smooth,1,nz*nx);

% 2. smoothing by Garner's equation
% rho_smooth = 0.31*sqrt(sqrt(vp_smooth*1000));

fid=fopen([iter 'th_mig_rho.dat'],'wt');
fprintf(fid,'%17.8f',rho_smooth);
fclose(fid);




% ========================================
% create smooth epsi model using slowness!
% ========================================
% % 1. smoothing by filtering the true density model

vp_hor = reshape(vp_hor,nz,nx);
vp_hor_smooth = vp_hor;
for i = 1:num_smooth_iteration
    if i >= num_smooth_iteration-10
        vp_hor_smooth(1:water_depth,:) = vp_hor(1:water_depth,:);
    end
    vp_hor_smooth = imfilter(vp_hor_smooth, fspecial('gaussian',filter_size),'replicate','same');
end
subplot(3,3,4);imagesc(vp_hor_smooth);caxis([1.5 4.5]);colormap('jet');

epsi_smooth = ((vp_hor_smooth./vp_smooth).^2-1)/2;
subplot(3,3,7);imagesc(epsi_smooth);
epsi_smooth=reshape(epsi_smooth,1,nz*nx);


fid=fopen([iter 'th_mig_epsi.dat'],'wt');
fprintf(fid,'%17.8f',epsi_smooth);
fclose(fid);

fid=fopen([iter 'th_mig_vp_hor.dat'],'wt');
fprintf(fid,'%17.8f',vp_hor_smooth);
fclose(fid);
% ========================================
% create smooth delta model using slowness!
% ========================================
% % 1. smoothing by filtering the true density model
vp_nmo = reshape(vp_nmo,nz,nx);
vp_nmo_smooth = vp_nmo;
for i = 1:num_smooth_iteration
    if i >= num_smooth_iteration-10
        vp_nmo_smooth(1:water_depth,:) = vp_nmo(1:water_depth,:);
    end
    vp_nmo_smooth = imfilter(vp_nmo_smooth, fspecial('gaussian',filter_size),'replicate','same');
end
subplot(3,3,5);imagesc(vp_nmo_smooth);caxis([1.5 4.5]);colormap('jet');

delta_smooth = ((vp_nmo_smooth./vp_smooth).^2-1)/2;
subplot(3,3,8);imagesc(delta_smooth);
delta_smooth=reshape(delta_smooth,1,nz*nx);

fid=fopen([iter 'th_mig_delta.dat'],'wt');
fprintf(fid,'%17.8f',delta_smooth);
fclose(fid);

fid=fopen([iter 'th_mig_vp_nmo.dat'],'wt');
fprintf(fid,'%17.8f',vp_nmo_smooth);
fclose(fid);
