
clear all
pack
close all
clc

nx=256;
nz=256;
input_directory = 'Marmousi';
output_directory = '../fortran1.0/given_models';
system(['mkdir ' output_directory '_inversion']);

name = 'vp';low = 1.5; high = 4.5;num = 1;
% name = 'vs';low = .5; high = 2.5; num = 2;
% name = 'rho';low = 1.8; high = 2.4; num = 3;

for i = 1 : 21
    iter = num2str(i);
    disp(iter)
    %input model

    if strcmp(name,'vs')
        vp = zeros(nz,nx);
    else
        vp = dlmread([input_directory '/' iter 'th_iteration_FWI_' name '_model6500.dat']);
        % vp = dlmread('Marmousi192x576x5000z270.dat');
        vp = reshape(vp,nz,nx);
    end

    figure(1);imagesc(vp);
    title('True model');caxis([low high]);

    vp = reshape(vp,nz,nx);
    vp_smooth = vp;
    num_smooth_iteration = 10;
    for i = 1:num_smooth_iteration
        vp_smooth = smooth_filter(vp_smooth,fspecial('gaussian'),40);
    end

    % ========================================
    % create smooth model using slowness!
    % ========================================
    figure(2);imagesc(vp_smooth);caxis([low high]);
    reflectivity = (vp - vp_smooth)./vp_smooth;



    figure(3)
    plot(vp(:,nx/2),'r');hold on;plot(vp_smooth(:,nx/2));hold off

    vp_smooth = reshape(vp_smooth,1,nz*nx);
    vp = reshape(vp,1,nz*nx);

    fid=fopen([output_directory '_inversion' '/' iter 'true' name '.dat'],'wt');
    disp(num2str(0))
    fprintf(fid,'%17.8f',vp);
    fclose(fid);

    fid=fopen([output_directory '_inversion' '/' iter 'mig' name '.dat'],'wt');
    disp(num2str(0))
    fprintf(fid,'%17.8f',vp_smooth);
    fclose(fid);
end
