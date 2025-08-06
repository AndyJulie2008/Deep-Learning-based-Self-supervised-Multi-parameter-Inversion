clear all
pack
%close all
clc
%%%%%%%%%%%%%%%%%%%%%
% Strategy: maximize the number of clusters at the first and second steps
% Randomly choose the final number of clusters to output model
%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%0. Set parameters and input starting model
nz=128;
nx=256;
smooth_num = 21;
kmean_num_first = 7; %for main group clustering
kmean_num_second = 3; % for sub group clustering
max_iteration = 300; %maximum number of iteration to find clusters (not used if singleton is applied)
first_level = kmean_num_second*10; %for main group index
second_level = 1; % for sub group index
vel_sigma = 10; %after getting the mean and variance of the clustered models, randomly choose value from distribution

smooth_num = 20; %smooth number for smoothing clustered velocity
smooth_filter_size = 3;
water_depth = 6;
vp_mig=dlmread(['new_FWI_model199.dat']);
vp_mig = reshape(vp_mig,nz,nx);
vp_mig(1:water_depth,:) = 1.5;

vp_cluster = gen_similar_model( vp_mig, kmean_num_first,kmean_num_second,max_iteration,first_level,second_level,vel_sigma);
vp_cluster_reflectivity = reflectivity_model(vp_cluster);

filter = fspecial('average',smooth_filter_size);
vp_cluster2 = smooth_filter(vp_cluster,filter,smooth_num);
vp_cluster2 = gen_similar_model(vp_cluster2, kmean_num_first,kmean_num_second,max_iteration,first_level,second_level,vel_sigma);
vp_cluster2_reflectivity = reflectivity_model(vp_cluster2);

% Below is for plot only
vp_true=dlmread('true_Marmousi.dat');
vp_true = reshape(vp_true,nz,nx);
true_reflectivity=reflectivity_model(vp_true);
true_reflectivity = reshape(true_reflectivity,nz,nx);

vp_mig = reshape(vp_mig,nz,nx);
vp_mig_reflectivity = reflectivity_model(vp_mig);



figure(1)
subplot(2,4,1)
imagesc(vp_true);caxis([1.5 4.5])
title('First-cluster index map')
subplot(2,4,5)
imagesc((true_reflectivity));
title('Second-cluster index map')

subplot(2,4,2)
imagesc(vp_mig);caxis([1.5 4.5])
title('First-cluster index map')
text(210.998338870432, 284.636222910217,['R2= ' num2str(R2(vp_true,vp_mig))])

subplot(2,4,6)
imagesc((vp_mig_reflectivity));
title('Second-cluster index map')

subplot(2,4,3)
imagesc(vp_cluster);caxis([1.5 4.5]);
title('Second-cluster index map')
text(210.998338870432, 284.636222910217,['R2 to true= ' num2str(R2(vp_true,vp_cluster))])
text(210.998338870432, 304.636222910217,['R2 to invt = ' num2str(R2(vp_mig,vp_cluster))])

subplot(2,4,7)
imagesc((vp_cluster_reflectivity));
title('Second-cluster')

subplot(2,4,4)
imagesc(vp_cluster2);caxis([1.5 4.5]);
title('Second-cluster index map')
text(210.998338870432, 284.636222910217,['R2 to true= ' num2str(R2(vp_true,vp_cluster2))])
text(210.998338870432, 304.636222910217,['R2 to invt = ' num2str(R2(vp_mig,vp_cluster2))])

subplot(2,4,8)
imagesc((vp_cluster2_reflectivity));
title('Second-cluster')
% figure(2)
% subplot(1,2,1)
% plot(hash_map_value(:,1),'o');
% title('Mean')
% subplot(1,2,2)
% plot(hash_map_value(:,2),'o');
% title('Variance')
% 
% 
% 
% 
% figure(3)
% subplot(1,3,1)
% imagesc(vp_mig)
% subplot(1,3,2)
% imagesc(vp_cluster)
% subplot(1,3,3)
% imagesc(vp_cluster - vp_mig)