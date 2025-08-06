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
nz = 256;
nx = 256;
dh = 12.5;
iter = 1;
offset = [64 128 192];
vp_true = dlmread(['0th_true_' 'vp' '.dat']);
vp_true = reshape(vp_true,nz,nx);

vp_hor_true = dlmread(['0th_true_' 'vp_hor' '.dat']);
vp_hor_true = reshape(vp_hor_true,nz,nx);

vp_nmo_true = dlmread(['0th_true_' 'vp_nmo' '.dat']);
vp_nmo_true = reshape(vp_nmo_true,nz,nx);

vp_hor_init = dlmread(['0th_mig_' 'vp_hor' '.dat']);
vp_hor_init = reshape(vp_hor_init,nz,nx);

vp_nmo_init = dlmread(['0th_mig_' 'vp_nmo' '.dat']);
vp_nmo_init = reshape(vp_nmo_init,nz,nx);

vp_true = dlmread(['0th_true_' 'vp' '.dat']);
vp_true = reshape(vp_true,nz,nx);

vp_init = dlmread(['0th_mig_' 'vp' '.dat']);
vp_init = reshape(vp_init,nz,nx);

rho_true = dlmread(['0th_true_' 'rho' '.dat']);
rho_true = reshape(rho_true,nz,nx);

rho_init = dlmread(['0th_mig_' 'rho' '.dat']);
rho_init = reshape(rho_init,nz,nx);


vs_true = dlmread(['0th_true_' 'vs' '.dat']);
vs_true = reshape(vs_true,nz,nx);

vs_init = dlmread(['0th_mig_' 'vs' '.dat']);
vs_init = reshape(vs_init,nz,nx);

vp_err = zeros(1,iter+1);
vp_hor_err = zeros(1,iter+1);
vp_nmo_err = zeros(1,iter+1);
rho_err = zeros(1,iter+1);
vs_err = zeros(1,iter+1);

vp_err(1)=RMS(vp_true,vp_init);
vp_hor_err(1)=RMS(vp_hor_true,vp_hor_init);
vp_nmo_err(1)=RMS(vp_nmo_true,vp_nmo_init);
rho_err(1)=RMS(rho_true,rho_init);
vs_err(1)=RMS(vs_true,vs_init);
    
for i = 1:iter
    disp(i)
    figure(1)
    subplot(3,5,1)
    imagesc(vp_true);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp = ' num2str(RMS(vp_true,vp_true))])

    subplot(3,5,2)
    imagesc(rho_true);caxis([2.0 2.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model rho = ' num2str(RMS(rho_true,rho_true))])
    
    subplot(3,5,3)
    imagesc(vs_true);caxis([0 3]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vs = ' num2str(RMS(vs_true,vs_true))])
    
    subplot(3,5,4)
    imagesc(vp_hor_true);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp hor = ' num2str(RMS(vp_hor_true,vp_hor_true))])
    
    subplot(3,5,5)
    imagesc(vp_nmo_true);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp nmo = ' num2str(RMS(vp_nmo_true,vp_nmo_true))])
    
    subplot(3,5,6)
    imagesc(vp_init);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp = ' num2str(RMS(vp_true,vp_init))])

    subplot(3,5,7)
    imagesc(rho_init);caxis([2.0 2.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model rho = ' num2str(RMS(rho_true,rho_init))])

    subplot(3,5,8)
    imagesc(vs_init);caxis([0 3]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vs = ' num2str(RMS(vs_true,vs_init))])
    
    subplot(3,5,9)
    imagesc(vp_hor_init);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp hor = ' num2str(RMS(vp_hor_true,vp_hor_init))])
    
    subplot(3,5,10)
    imagesc(vp_nmo_init);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp nmo = ' num2str(RMS(vp_nmo_true,vp_nmo_init))])
    
    vp1 = dlmread([num2str(i) 'th_true_' 'vp' '.dat']);
    vp1 = reshape(vp1,nz,nx);
    
    vs1 = dlmread([num2str(i) 'th_true_' 'vs' '.dat']);
    vs1 = reshape(vs1,nz,nx);
    
    rho1 = dlmread([num2str(i) 'th_true_' 'rho' '.dat']);
    rho1 = reshape(rho1,nz,nx);
    
    vp_hor1 = dlmread([num2str(i) 'th_true_' 'vp_hor' '.dat']);
    vp_hor1 = reshape(vp_hor1,nz,nx);
    
    vp_nmo1 = dlmread([num2str(i) 'th_true_' 'vp_nmo' '.dat']);
    vp_nmo1 = reshape(vp_nmo1,nz,nx);
    
    vp_err(i+1)=RMS(vp_true,vp1);
    vp_hor_err(i+1)=RMS(vp_hor_true,vp_hor1);
    vp_nmo_err(i+1)=RMS(vp_nmo_true,vp_nmo1);
    rho_err(i+1)=RMS(rho_true,rho1);
    vs_err(i+1)=RMS(vs_true,vs1);

    subplot(3,5,11)
    imagesc(vp1);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp = ' num2str(vp_err(i+1))])

    subplot(3,5,12)
    imagesc(rho1);caxis([2.0 2.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model rho = ' num2str(rho_err(i+1))])

    subplot(3,5,13)
    imagesc(vs1);caxis([0 3]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vs = ' num2str(vs_err(i+1))])

    subplot(3,5,14)
    imagesc(vp_hor1);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp hor = ' num2str(vp_hor_err(i+1))])
    
    subplot(3,5,15)
    imagesc(vp_nmo1);caxis([1.5 4.5]);axis equal;xlim([1 nx]);ylim([1 nz]);colormap('jet');
    title(['RMS model vp nmo = ' num2str(vp_nmo_err(i+1))])
% 
%     figure(2)
%     for k = 1:3
%         subplot(3,5,k)
%         depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines
%         x_position = offset(k); %nx/4*1; % The horizontal position (unitless)
%         plot(vp_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
%         plot(vp_init(:,x_position),depth,'b','LineWidth',1.5);hold on;
%         plot(vp1(:,x_position),depth,'r','LineWidth',1.5);hold off;
%         set(gca,'YDir','reverse')
%         xlabel('Velocity (km/s)')
%         ylabel('Depth (km)')
% %         set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
% %         set(gca,'xtick',1.5:1.0:4.7) 
% %         set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% %         set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
% %         axis([1.2 5.0 1*dh (nz)*dh]) 
%         set(gca,'XAxisLocation','top');
%         text(0.209139784946237, -0.6682,'a)')
%         title(i)
%         
%         subplot(3,5,k+3)
%         depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines
%         x_position = offset(k); %nx/4*1; % The horizontal position (unitless)
%         plot(rho_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
%         plot(rho_init(:,x_position),depth,'b','LineWidth',1.5);hold on;
%         plot(rho1(:,x_position),depth,'r','LineWidth',1.5);hold off;
%         set(gca,'YDir','reverse')
%         xlabel('Velocity (km/s)')
%         ylabel('Depth (km)')
% %         set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
% %         set(gca,'xtick',1.2:0.5:3.1) 
% %         set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% %         set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
% %         axis([1.2 3.1 1*dh (nz)*dh]) 
%         set(gca,'XAxisLocation','top');
%         text(0.209139784946237, -0.6682,'a)')
%         
%         subplot(3,5,k+6)
%         depth=(0:1:nz-1)*dh; % The depth (m) at each vertical grid lines
%         x_position = offset(k); %nx/4*1; % The horizontal position (unitless)
%         plot(vs_true(:,x_position),depth,'k','LineWidth',1.5);hold on;
%         plot(vs_init(:,x_position),depth,'b','LineWidth',1.5);hold on;
%         plot(vs1(:,x_position),depth,'r','LineWidth',1.5);hold off;
%         set(gca,'YDir','reverse')
%         xlabel('Velocity (km/s)')
%         ylabel('Depth (km)')
% %         set(gca,'ytick',[1 nz/4 nz/2 nz/4*3 nz]*dh) 
% %         set(gca,'xtick',1.5*1.2:1.5:4.5*3.1) 
% %         set(gca,'xticklabel',sprintf('%3.1f|',get(gca,'xtick')))
% %         set(gca,'yticklabel',sprintf('%3.1f|',get(gca,'ytick')))
% %         axis([1.5*1.2 4.5*3.1 1*dh (nz)*dh]) 
%         set(gca,'XAxisLocation','top');
%         text(0.209139784946237, -0.6682,'a)')
%     end
drawnow;
pause(0.2)
end

figure(2)
subplot(3,2,1);plot(vp_err);
subplot(3,2,2);plot(rho_err);
subplot(3,2,3);plot(vs_err);
subplot(3,2,4);plot(vp_hor_err);
subplot(3,2,5);plot(vp_nmo_err);